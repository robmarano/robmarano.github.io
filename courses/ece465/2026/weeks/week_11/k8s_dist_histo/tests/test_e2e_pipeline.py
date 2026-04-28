import os
import time
import requests
import socketio

BASE_URL = 'http://localhost:5050'
# The cwd when running pytest will be the k8s_zk_template directory
TEST_FILE = os.path.join(os.path.dirname(__file__), 'test_file_large_dark.tiff')

def test_full_pipeline():
    print(f"\n[Test] Connecting to ZooKeeper K8s Cluster at {BASE_URL}...")
    try:
        r = requests.get(BASE_URL)
        assert r.status_code == 200
    except requests.exceptions.ConnectionError:
        print("Minikube service not running on port 8080. Please start port forwarding.")
        return

    print(f"[Test] Uploading {TEST_FILE} ({os.path.getsize(TEST_FILE) / 1024 / 1024:.2f} MB)...")
    
    with open(TEST_FILE, 'rb') as f:
        files = {'image': ('test_file_large_dark.tiff', f, 'image/tiff')}
        r = requests.post(f"{BASE_URL}/upload", files=files)
        
    assert r.status_code == 200, f"Upload failed! Code {r.status_code}. Output: {r.text}"
    job_id = r.json().get('job_id')
    assert job_id, "No job ID returned in JSON payload!"
    print(f"[Test] Upload Successful! Orchestrating Job ID: {job_id}")
    
    sio = socketio.Client()
    job_completed = False
    download_url = None
    
    @sio.on('job_status')
    def on_job_status(data):
        nonlocal job_completed, download_url
        if data.get('id') == job_id:
            print(f" -> [Cluster Event] {data.get('msg', '')}")
            if 'url' in data:
                download_url = data['url']
                job_completed = True
                sio.disconnect()
                
    # Also optionally log workers to stdout
    @sio.on('node_log')
    def on_node_log(data):
        if job_id in data.get('log', ''):
             pass # Too noisy to print all docker logs, but available if needed
                
    sio.connect(BASE_URL, transports=['websocket', 'polling'])
    
    # Wait for cluster execution with 4-minute maximum timeout
    print("[Test] Connected to Event Stream. Awaiting Ephemeral Worker Kazoo processing...")
    timeout = time.time() + 240
    while not job_completed and time.time() < timeout:
        time.sleep(0.5)
        
    if not job_completed:
        raise TimeoutError(f"Job {job_id} processing timed out after 240s! Cluster may be hanging or out of memory.")
        
    assert download_url is not None
    print(f"[Test] Downloading Final Stitched Image from {download_url}...")
    
    dl_res = requests.get(f"{BASE_URL}{download_url}")
    assert dl_res.status_code == 200
    
    out_size = len(dl_res.content)
    assert out_size > 100000 # Should be multiple megabytes for the large TIFF
    print(f"[Test] Success! Downloaded processed TIFF size: {out_size / 1024 / 1024:.2f} MB.")

if __name__ == '__main__':
    test_full_pipeline()
