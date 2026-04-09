import os
import time
import requests
import socketio
import subprocess
import random
import threading
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

BASE_URL = 'http://localhost:5050'
TEST_FILE = os.path.join(os.path.dirname(__file__), 'test_file_large_dark.tiff')

def get_robust_session():
    session = requests.Session()
    retry = Retry(connect=5, backoff_factor=0.5, status_forcelist=[ 500, 502, 503, 504 ])
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    return session

def get_running_pods(label_selector):
    """Utility to get running pod names based on a label selector."""
    out = subprocess.check_output([
        "kubectl", "get", "pods", "-l", label_selector, 
        "--field-selector=status.phase=Running", 
        "-o", "jsonpath={.items[*].metadata.name}"
    ]).decode('utf-8')
    return out.strip().split() if out.strip() else []

def kill_pod(pod_name):
    """Utility to kill a specific pod."""
    print(f"      [Fault Injection] Killing pod: {pod_name}")
    subprocess.run(["kubectl", "delete", "pod", pod_name, "--wait=false"], check=True)

def run_fault_injection_pipeline(fault_target_label, role_to_avoid=None):
    """
    Uploads a file and kills a pod matching `fault_target_label` during execution.
    If `role_to_avoid` is set, ensures the killed pod does not have that role 
    (e.g., avoiding killing the Master, which holds the HTTP connection).
    """
    # Start port-forwarding dynamically for this test
    print(f"[Test] Starting kubectl port-forward to master-service on port 5050...")
    pf_process = subprocess.Popen(["kubectl", "port-forward", "svc/master-service", "5050:80"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(3) # Wait for tunnel to establish
    
    session = get_robust_session()

    print(f"\n[Test] Connecting to Cluster at {BASE_URL}...")
    try:
        r = session.get(BASE_URL)
        assert r.status_code == 200
    except requests.exceptions.ConnectionError:
        pf_process.terminate()
        raise RuntimeError("Failed to establish port forwarding tunnel.")

    print(f"[Test] Uploading {TEST_FILE} for fault injection test...")
    with open(TEST_FILE, 'rb') as f:
        files = {'image': ('test_file_large_dark.tiff', f, 'image/tiff')}
        r = session.post(f"{BASE_URL}/upload", files=files)
        
    assert r.status_code == 200, f"Upload failed! Code {r.status_code}"
    job_id = r.json().get('job_id')
    assert job_id, "No job ID returned!"
    print(f"[Test] Orchestrating Job ID: {job_id}")
    
    sio = socketio.Client()
    job_completed = False
    download_url = None
    fault_injected = False
    
    @sio.on('job_status')
    def on_job_status(data):
        nonlocal job_completed, download_url, fault_injected
        if data.get('id') == job_id:
            msg = data.get('msg', '')
            print(f" -> [Cluster Event] {msg}")
            
            # Inject the fault during the distributed mapping phase
            if 'Waiting for Ephemeral Workers' in msg and not fault_injected:
                fault_injected = True
                
                # Find candidate pods
                pods = get_running_pods(fault_target_label)
                if role_to_avoid:
                    avoid_pods = get_running_pods(role_to_avoid)
                    pods = [p for p in pods if p not in avoid_pods]
                
                if pods:
                    target_pod = random.choice(pods)
                    # Kill it asynchronously so we don't block the SocketIO event thread
                    threading.Thread(target=kill_pod, args=(target_pod,)).start()
                else:
                    print("      [Warning] No target pods found to kill!")

            if 'url' in data:
                download_url = data['url']
                job_completed = True
                sio.disconnect()
                
    sio.connect(BASE_URL, transports=['websocket', 'polling'])
    
    timeout = time.time() + 240
    while not job_completed and time.time() < timeout:
        time.sleep(0.5)
        
    if not job_completed:
        pf_process.terminate()
        raise TimeoutError(f"Job {job_id} processing timed out! The fault may have corrupted the state.")
        
    assert download_url is not None
    print(f"[Test] Success! Downloaded processed file from {download_url}.")
    
    # Check download with retries in case the port-forward blipped
    dl_res = session.get(f"{BASE_URL}{download_url}")
    assert dl_res.status_code == 200
    assert len(dl_res.content) > 100000
    
    pf_process.terminate()
    pf_process.wait()

def test_app_worker_node_failure():
    """
    Test that if an active Worker node dies mid-computation, its ephemeral lock 
    is released, and another worker picks up the task, successfully completing the job.
    """
    print("\n--- Starting Application Worker Failure Test ---")
    run_fault_injection_pipeline(fault_target_label="app=zk-app", role_to_avoid="role=master")
    print("--- Passed Application Worker Failure Test ---")

def test_zookeeper_node_failure():
    """
    Test that if a single ZooKeeper node in the 3-node ensemble dies, the Quorum
    maintains the job state and sessions, allowing the job to complete seamlessly.
    """
    print("\n--- Starting ZooKeeper Node Failure Test ---")
    run_fault_injection_pipeline(fault_target_label="app=zookeeper")
    print("--- Passed ZooKeeper Node Failure Test ---")

if __name__ == '__main__':
    test_app_worker_node_failure()
    test_zookeeper_node_failure()
