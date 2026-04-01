import os
os.environ["EVENTLET_NO_GREENDNS"] = "yes"
import eventlet
eventlet.monkey_patch()
import time
import uuid
import json
import logging
import threading
from flask import Flask, render_template, request, jsonify, send_from_directory
from flask_socketio import SocketIO
from kazoo.client import KazooClient
from kazoo.recipe.election import Election
from kubernetes import client, config
from core.image_processing import process_histogram_task, extract_chunks, compute_global_cdf, apply_cdf_task, stitch_image

app = Flask(__name__)
socketio = SocketIO(app, async_mode='eventlet', cors_allowed_origins="*")

# Configuration
ZK_HOSTS = os.getenv('ZK_HOSTS', 'zookeeper:2181')
POD_NAME = os.getenv('POD_NAME', 'unknown_pod')
NAMESPACE = os.getenv('POD_NAMESPACE', 'default')
SHARED_DIR = '/shared'

# Kazoo Client setup
zk = KazooClient(hosts=ZK_HOSTS)
zk.start()

# Track Global State
is_master = False
active_nodes = 0
tailed_pods = set()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Ensure paths
zk.ensure_path('/nodes')
zk.ensure_path('/jobs')
os.makedirs(SHARED_DIR, exist_ok=True)
os.makedirs(os.path.join(SHARED_DIR, "uploads"), exist_ok=True)
os.makedirs(os.path.join(SHARED_DIR, "results"), exist_ok=True)

# Register node presence
zk.create(f"/nodes/{POD_NAME}", ephemeral=True)

def update_pod_label(role):
    # If running outside k8s (e.g., local test), safely ignore
    if POD_NAME == 'unknown_pod': return
    try:
        config.load_incluster_config()
        v1 = client.CoreV1Api()
        body = {"metadata": {"labels": {"role": role}}}
        v1.patch_namespaced_pod(name=POD_NAME, namespace=NAMESPACE, body=body)
        logger.info(f"Successfully relabeled pod {POD_NAME} to role: {role}")
    except Exception as e:
        logger.error(f"Failed to relabel pod: {e}")

# Leader Election Logic
def become_leader():
    global is_master
    is_master = True
    logger.info(f"I am the Master! ({POD_NAME})")
    update_pod_label("master")
    # Start watching /nodes
    zk.ChildrenWatch('/nodes', watch_cluster_resources)
    
    # Kazoo Election drops leadership immediately if this function returns. 
    # Must block indefinitely to HOLD the Master lock.
    while True:
        time.sleep(10)

def run_election():
    election = Election(zk, "/election")
    election.run(become_leader)

def stream_pod_logs(pod_name):
    # Continuously tail to survive K8s API timeout disconnects
    while True:
        try:
            config.load_incluster_config()
            v1 = client.CoreV1Api()
            # Only tail the most recent lines upon a fresh connection
            resp = v1.read_namespaced_pod_log(name=pod_name, namespace=NAMESPACE, tail_lines=20, follow=True, _preload_content=False)
            for chunk in resp.stream():
                if chunk:
                    log_chunk = chunk.decode('utf-8').strip()
                    if log_chunk:
                        socketio.emit('node_log', {'pod': pod_name, 'log': log_chunk})
                        
            # If the stream gracefully exhausts (K8s API Timeout Drop), log and quickly reconnect
            logger.info(f"API tail stream for {pod_name} unexpectedly closed. Reconnecting...")
            time.sleep(2)
        except Exception as e:
            logger.error(f"Stream error for {pod_name}: {e}. Retrying...")
            time.sleep(5)

# Watch cluster size (Only master cares)
def watch_cluster_resources(children):
    global active_nodes, tailed_pods
    active_nodes = len(children)
    logger.info(f"Cluster topology changed. Active nodes: {active_nodes}")
    if is_master and active_nodes < 5:
        socketio.emit('cluster_alert', {'status': 'error', 'message': f'Service not available, not enough resources. Only {active_nodes} pods running.'})
    elif is_master:
        socketio.emit('cluster_alert', {'status': 'ok', 'message': f'Cluster healthy with {active_nodes} nodes.'})
        
        # Spawn log tailers for newly discovered nodes
        for pod in children:
            if pod not in tailed_pods:
                tailed_pods.add(pod)
                socketio.start_background_task(stream_pod_logs, pod)

# --- WORKER LOGIC ---
def worker_loop():
    while True:
        if not is_master:
            try:
                # Find available tasks ...
                jobs = zk.get_children('/jobs')
                for job_id in jobs:
                    phases = ['histograms', 'equalize']
                    for phase in phases:
                        tasks_path = f'/jobs/{job_id}/{phase}'
                        if zk.exists(tasks_path):
                            tasks = zk.get_children(tasks_path)
                            for task in tasks:
                                task_path = f"{tasks_path}/{task}"
                                lock_path = f"{task_path}/lock"
                                done_path = f"{task_path}/done"
                                
                                # Skip if already done or currently locked
                                if not zk.exists(done_path) and not zk.exists(lock_path):
                                    try:
                                        # Attempt to claim lock via Ephemeral Node
                                        zk.create(lock_path, ephemeral=True)
                                        data, stat = zk.get(task_path)
                                        payload = json.loads(data.decode('utf-8'))
                                        
                                        logger.info(f"Worker {POD_NAME} computing {task_path}")
                                        
                                        # Execute MapReduce Logic
                                        if phase == 'histograms':
                                            result = process_histogram_task(payload)
                                        else:
                                            result = apply_cdf_task(payload)
                                            
                                        # Save result to Znode
                                        zk.set(task_path, json.dumps(result).encode('utf-8'))
                                        
                                        # Mark done and release ephemeral lock
                                        zk.create(done_path)
                                        zk.delete(lock_path)
                                        logger.info(f"Worker {POD_NAME} finished {task_path}")
                                    except Exception as e:
                                        # NodeExisits error means another worker beat us to the lock lock_path
                                        pass
            except Exception:
                pass
        time.sleep(2)

# --- MASTER API ENDPOINTS ---
@app.route('/')
def index():
    if not is_master:
        return "I am a worker node. I do not serve UI. Connect to master-service instead.", 403
    return render_template('index.html', pods=active_nodes)

@socketio.on('connect')
def handle_connect():
    logger.info("New Web Client connected to Socket.IO! Sending current topology.")
    socketio.emit('cluster_alert', {'status': 'ok', 'message': f'Cluster healthy with {active_nodes} nodes.'})

@app.route('/upload', methods=['POST'])
def upload_file():
    if not is_master:
        return jsonify({"error": "Not master"}), 403
    if active_nodes < 3:
        return jsonify({"error": "Not enough resources. Minimum 3 required."}), 503
        
    file = request.files.get('image')
    if not file:
        return jsonify({"error": "No file"}), 400
        
    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in ['.jpg', '.jpeg', '.png', '.tiff', '.tif']:
        ext = '.jpg'
        
    job_id = str(uuid.uuid4())
    img_path = os.path.join(SHARED_DIR, "uploads", f"{job_id}{ext}")
    file.save(img_path)
    
    # Start orchestrator thread so we don't block the upload HTTP request
    socketio.start_background_task(orchestrate_job, job_id, img_path)
    return jsonify({"job_id": job_id})

def orchestrate_job(job_id, img_path):
    job_path = f"/jobs/{job_id}"
    num_workers = max(1, active_nodes) # Distribute slices based on active topology
    
    # Phase 1: Split and deploy histogram tasks
    socketio.emit('job_status', {'id': job_id, 'msg': f'Extracting {num_workers} chunks for distributed Map...'})
    zk.ensure_path(f"{job_path}/histograms")
    chunks = extract_chunks(img_path, num_workers)
    
    for i, chunk in enumerate(chunks):
        zk.create(f"{job_path}/histograms/task_{i}", json.dumps(chunk).encode('utf-8'))
        
    socketio.emit('job_status', {'id': job_id, 'msg': 'Waiting for Ephemeral Workers to map local histograms...'})
    
    # Wait for completion (Simple polling for demonstration of synchronization barrier)
    while True:
        dones = 0
        tasks = zk.get_children(f"{job_path}/histograms")
        for t in tasks:
            if zk.exists(f"{job_path}/histograms/{t}/done"):
                dones += 1
        if dones == len(chunks):
            break
        time.sleep(1)
        
    # Gather histograms
    socketio.emit('job_status', {'id': job_id, 'msg': 'Calculating Global CDF (Reduce)...'})
    hists = []
    for i in range(len(chunks)):
        data, _ = zk.get(f"{job_path}/histograms/task_{i}")
        hists.append(json.loads(data.decode('utf-8'))['histogram'])
        
    cdf = compute_global_cdf(hists)
    
    # Phase 2: Deploy CDF Equalization tasks
    zk.ensure_path(f"{job_path}/equalize")
    for i, chunk in enumerate(chunks):
        payload = {**chunk, "cdf": cdf}
        zk.create(f"{job_path}/equalize/task_{i}", json.dumps(payload).encode('utf-8'))
        
    socketio.emit('job_status', {'id': job_id, 'msg': 'Waiting for Ephemeral Workers to apply global distributions...'})
    while True:
        dones = 0
        tasks = zk.get_children(f"{job_path}/equalize")
        for t in tasks:
            if zk.exists(f"{job_path}/equalize/{t}/done"):
                dones += 1
        if dones == len(chunks):
            break
        time.sleep(1)

    # Gather & Stitch
    socketio.emit('job_status', {'id': job_id, 'msg': 'Stitching final image chunks...'})
    results = []
    for i in range(len(chunks)):
        data, _ = zk.get(f"{job_path}/equalize/task_{i}")
        results.append(json.loads(data.decode('utf-8'))['out_path'])
        
    ext = os.path.splitext(img_path)[1]
    final_path = os.path.join(SHARED_DIR, "results", f"{job_id}_final{ext}")
    stitch_image(results, final_path)
    
    socketio.emit('job_status', {'id': job_id, 'msg': 'Complete!', 'url': f'/download/{job_id}_final{ext}'})
    zk.delete(job_path, recursive=True)

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(os.path.join(SHARED_DIR, "results"), filename)

if __name__ == '__main__':
    # Start the Election and the Worker polling loop asynchronously
    socketio.start_background_task(run_election)
    socketio.start_background_task(worker_loop)
    socketio.run(app, host='0.0.0.0', port=5000)
