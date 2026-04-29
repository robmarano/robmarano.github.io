import os
os.environ["EVENTLET_NO_GREENDNS"] = "yes"
import eventlet
eventlet.monkey_patch()
import time
import uuid
import json
import logging
from functools import partial
from flask import Flask, render_template, request, jsonify, send_from_directory
from flask_socketio import SocketIO
from kazoo.client import KazooClient, KazooState
from kazoo.exceptions import NodeExistsError, NoNodeError
from kazoo.recipe.election import Election
from kazoo.security import make_digest_acl
from kubernetes import client, config
from core.image_processing import process_histogram_task, extract_chunks, compute_global_cdf, apply_cdf_task, stitch_image

app = Flask(__name__)
socketio = SocketIO(app, async_mode='eventlet', cors_allowed_origins="*")

# Configuration
ZK_HOSTS = os.getenv('ZK_HOSTS', 'zookeeper:2181')
POD_NAME = os.getenv('POD_NAME', 'unknown_pod')
NAMESPACE = os.getenv('POD_NAMESPACE', 'default')
SHARED_DIR = '/shared'
API_TOKEN = os.getenv('API_TOKEN', 'super-secret-token')
ZK_USER = os.getenv('ZK_USER', 'app_user')
ZK_PASS = os.getenv('ZK_PASS', 'secure_password')

# Kazoo Client setup (Increased timeout to tolerate Numpy computational lag on large datasets)
zk = KazooClient(hosts=ZK_HOSTS, timeout=60.0)

# Kazoo Access Control Lists (ACLs) - Digest Authentication
zk.add_auth('digest', f'{ZK_USER}:{ZK_PASS}')
secure_acl = [make_digest_acl(ZK_USER, ZK_PASS, all=True)]

def zk_state_listener(state):
    severity = "OK" if state == KazooState.CONNECTED else "WARNING"
    event_payload = {"event": f"ZooKeeper Connection: {state}", "severity": severity, "pod": POD_NAME}
    socketio.emit('observability', event_payload)

zk.add_listener(zk_state_listener)
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

try:
    zk.create(f"/nodes/{POD_NAME}", ephemeral=True, makepath=True, acl=secure_acl)
except NodeExistsError:
    zk.delete(f"/nodes/{POD_NAME}")
    zk.create(f"/nodes/{POD_NAME}", ephemeral=True, makepath=True, acl=secure_acl)

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
    socketio.emit('observability', {"event": f"Leader Election Won by {POD_NAME}", "severity": "CRITICAL", "pod": POD_NAME})
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

active_watches = set()

def watch_phase(children, phase_path):
    if is_master: return
    for task in children:
        task_path = f"{phase_path}/{task}"
        lock_path = f"{task_path}/lock"
        done_path = f"{task_path}/done"
        try:
            if not zk.retry(zk.exists, done_path) and not zk.retry(zk.exists, lock_path):
                zk.retry(zk.create, lock_path, ephemeral=True, makepath=True, acl=secure_acl)
                data, stat = zk.retry(zk.get, task_path)
                payload = json.loads(data.decode('utf-8'))
                
                logger.info(f"Worker {POD_NAME} computing {task_path}")
                
                if 'histograms' in phase_path:
                    from eventlet import tpool
                    result = tpool.execute(process_histogram_task, payload)
                else:
                    from eventlet import tpool
                    result = tpool.execute(apply_cdf_task, payload)
                    
                zk.retry(zk.set, task_path, json.dumps(result).encode('utf-8'))
                zk.retry(zk.create, done_path, makepath=True, acl=secure_acl)
                zk.retry(zk.delete, lock_path)
                logger.info(f"Worker {POD_NAME} finished {task_path}")
        except NodeExistsError:
            # NodeExists error means another worker beat us to the lock_path
            pass
        except NoNodeError:
            pass
        except Exception as e:
            logger.error(f"Worker execution error on {task_path}: {e}")

def watch_jobs(children):
    if is_master: return
    for job_id in children:
        phases = ['histograms', 'equalize']
        for phase in phases:
            phase_path = f'/jobs/{job_id}/{phase}'
            if phase_path not in active_watches:
                try:
                    exists = zk.retry(zk.exists, phase_path)
                except Exception as e:
                    logger.error(f"Failed to check phase_path {phase_path}: {e}")
                    exists = False
                
                if exists:
                    active_watches.add(phase_path)
                    zk.ChildrenWatch(phase_path, partial(watch_phase, phase_path=phase_path))

def worker_loop():
    # Setup the root job watch natively
    zk.ChildrenWatch('/jobs', watch_jobs)
    # The greenlet simply stays alive to let Kazoo background threads fire callbacks
    while True:
        try:
            # Fallback for Kazoo Event race condition (If '/jobs/xyz' is born right before 'histograms', the event misses)
            watch_jobs(zk.retry(zk.get_children, '/jobs'))
        except Exception:
            pass
        time.sleep(2)

# --- MASTER API ENDPOINTS ---
@app.route('/')
def index():
    if not is_master:
        return "I am a worker node. I do not serve UI. Connect to master-service instead.", 403
    return render_template('index.html', pods=active_nodes)

@app.route('/health')
def health_check():
    # Liveness probe: Fails if the Python event loop deadlocks
    return "OK", 200

@app.route('/ready')
def ready_check():
    # Readiness probe: Fails if not connected to ZK ensemble
    if zk.state == KazooState.CONNECTED:
        return "READY", 200
    return "NOT READY", 503

@socketio.on('connect')
def handle_connect():
    logger.info("New Web Client connected to Socket.IO! Sending deployment logs and topology.")
    
    # Send simulated deployment logs to the UI for observability
    socketio.start_background_task(simulate_deployment)
    socketio.emit('cluster_alert', {'status': 'ok', 'message': f'Cluster healthy with {active_nodes} nodes.'})

def simulate_deployment():
    # ECE 465 Week 13: Simulate the Infrastructure as Code (IaC) Deployment Rollout
    time.sleep(1)
    socketio.emit('deployment_log', {'event': 'Terraform: Provisioning 3 Bare Metal nodes on Equinix Metal (c3.small.x86)'})
    time.sleep(2)
    socketio.emit('deployment_log', {'event': 'Tinkerbell/iPXE: Booting nodes and burning Ubuntu 22.04 LTS OS'})
    time.sleep(2)
    socketio.emit('deployment_log', {'event': 'Ansible: SSH successful. Installing Containerd & Kubeadm'})
    time.sleep(2)
    socketio.emit('deployment_log', {'event': 'Kubernetes: Control plane initialized. Workers joined.'})
    time.sleep(2)
    socketio.emit('deployment_log', {'event': 'GitOps (ArgoCD): Synchronizing k8s_dist_histo_deployed/k8s/ from Git...'})
    time.sleep(2)
    socketio.emit('deployment_log', {'event': 'GitOps (ArgoCD): StatefulSet zk-app successfully deployed to bare metal cluster.'})

@app.route('/upload', methods=['POST'])
def upload_file():
    if not is_master:
        return jsonify({"error": "Not master"}), 403
        
    # SecOps Authentication Check
    auth_header = request.headers.get('Authorization')
    if auth_header != f"Bearer {API_TOKEN}":
        logger.warning(f"Unauthorized API access blocked from {request.remote_addr}")
        socketio.emit('secops', {"event": f"Intrusion Attempt Blocked: Invalid API Token from {request.remote_addr}", "severity": "CRITICAL", "pod": POD_NAME})
        return jsonify({"error": "Unauthorized Access"}), 401
        
    if active_nodes < 5:
        return jsonify({"error": "Not enough resources. Minimum 5 required."}), 503
        
    file = request.files.get('image')
    if not file:
        return jsonify({"error": "No file"}), 400
        
    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in ['.jpg', '.jpeg', '.png', '.tiff', '.tif']:
        return jsonify({"error": f"Unsupported file format {ext}. Must be JPG, PNG, or TIFF"}), 400
        
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
    zk.retry(zk.ensure_path, f"{job_path}/histograms")
    
    # 75MB TIFF chunking natively blocks single-threaded Eventlet Hubs causing Kazoo heartbeat timeouts.
    # Offload to real OS threads to preserve cluster connectivity.
    from eventlet import tpool
    chunks = tpool.execute(extract_chunks, img_path, num_workers)
    
    for i, chunk in enumerate(chunks):
        zk.retry(zk.create, f"{job_path}/histograms/task_{i}", json.dumps(chunk).encode('utf-8'), makepath=True, acl=secure_acl)
        
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
        data, _ = zk.retry(zk.get, f"{job_path}/histograms/task_{i}")
        hists.append(json.loads(data.decode('utf-8'))['histogram'])
        
    cdf = tpool.execute(compute_global_cdf, hists)
    
    # Phase 2: Deploy CDF Equalization tasks
    zk.retry(zk.ensure_path, f"{job_path}/equalize")
    for i, chunk in enumerate(chunks):
        payload = {**chunk, "cdf": cdf}
        zk.retry(zk.create, f"{job_path}/equalize/task_{i}", json.dumps(payload).encode('utf-8'), makepath=True, acl=secure_acl)
        
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
        data, _ = zk.retry(zk.get, f"{job_path}/equalize/task_{i}")
        results.append(json.loads(data.decode('utf-8'))['out_path'])
        
    ext = os.path.splitext(img_path)[1]
    final_path = os.path.join(SHARED_DIR, "results", f"{job_id}_final{ext}")
    tpool.execute(stitch_image, results, final_path)
    
    socketio.emit('job_status', {'id': job_id, 'msg': 'Complete!', 'url': f'/download/{job_id}_final{ext}'})
    zk.retry(zk.delete, job_path, recursive=True)

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(os.path.join(SHARED_DIR, "results"), filename)

if __name__ == '__main__':
    # Start the Election and the Worker polling loop asynchronously
    socketio.start_background_task(run_election)
    socketio.start_background_task(worker_loop)
    # TLS encryption using self-signed adhoc certificates
    socketio.run(app, host='0.0.0.0', port=5000, ssl_context='adhoc')
