import uuid
import time
import os
import eventlet
from kazoo.client import KazooClient

eventlet.monkey_patch()

ZK_HOSTS = os.getenv('ZK_HOSTS', 'zookeeper:2181')

def backup_worker_daemon():
    """ Simulates the Standby Node running on a separate machine watching for Jobs """
    zk = KazooClient(hosts=ZK_HOSTS)
    zk.start()
    zk.ensure_path('/jobs')
    
    print("[Backup Daemon] Online. Scanning for primary payloads...")
    while True:
        try:
            children = zk.retry(zk.get_children, '/jobs')
            for job in children:
                job_path = f"/jobs/{job}"
                ack_path = f"{job_path}/backup_ack"
                if not zk.exists(ack_path):
                    data, _ = zk.get(job_path)
                    print(f"\n[Backup Daemon] DETECTED new transaction for {job}!")
                    print(f"[Backup Daemon] Hard-syncing payload to backup disk: {data.decode('utf-8')}")
                    time.sleep(1.5) # Simulate network/disk latency
                    zk.create(ack_path, b"SYNCED")
                    print(f"[Backup Daemon] Emitted SYNCED verification to Master.")
        except Exception:
            pass
        time.sleep(1)

def master_primary_transaction():
    """ Simulates the Primary Node attempting a strict synchronous write """
    zk = KazooClient(hosts=ZK_HOSTS)
    zk.start()
    zk.ensure_path('/jobs')
    
    job_id = str(uuid.uuid4())
    job_path = f"/jobs/{job_id}"
    ack_path = f"{job_path}/backup_ack"
    
    payload = b'{"image_matrix": [255, 128, 64], "user_id": 99}'
    
    print(f"\n[Primary Leader] Executing strict Synchronous Replication for Transaction: {job_id}")
    zk.retry(zk.create, job_path, payload, makepath=True)
    
    print(f"[Primary Leader] Payload sent to ZK. Suspending user thread until Backup Node ACKs...")
    start_time = time.time()
    
    while time.time() - start_time < 10:
        if zk.retry(zk.exists, ack_path):
            print(f"\n>>>> [Primary Leader] SUCCESS! Backup ACK confirmed in {round(time.time()-start_time, 2)}s. Returning HTTP 200 OK to User! <<<<\n")
            zk.stop()
            return True
        time.sleep(0.5)
        
    print("\n[Primary Leader] FATAL: Replication Timeout. Aborting transaction!")
    zk.stop()
    return False

if __name__ == "__main__":
    print("--- Primary-Backup Synchronous Replication Demo ---")
    # Spawn background Backup replica
    daemon = eventlet.spawn(backup_worker_daemon)
    time.sleep(1)
    
    # Execute Primary logic
    master_primary_transaction()
    daemon.kill()
    
    # Cleanup trailing jobs natively (simulation cleanup)
    zk = KazooClient(hosts=ZK_HOSTS); zk.start()
    zk.delete('/jobs', recursive=True)
    zk.stop()
