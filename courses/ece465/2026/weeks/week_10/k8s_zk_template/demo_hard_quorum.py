import os
import os
os.environ["EVENTLET_NO_GREENDNS"] = "yes"
import eventlet
from kazoo.client import KazooClient
from kazoo.handlers.eventlet import SequentialEventletHandler

eventlet.monkey_patch()

ZK_HOSTS = os.getenv('ZK_HOSTS', 'zookeeper:2181')
zk = KazooClient(hosts=ZK_HOSTS, handler=SequentialEventletHandler())
zk.start()

N = 5 # Total Nodes
W = 3 # Write Quorum Target
R = 3 # Read Quorum Target
OBJECT_ID = "histogram_matrix"

def quorum_write(payload_data):
    """ Perform a concurrent W=3 Quorum Write across N nodes """
    print(f"\n[Quorum Write] Initiating N={N}, W={W} write operation for {OBJECT_ID}...")
    replica_paths = [f"/objects/{OBJECT_ID}/replica_{i}" for i in range(1, N+1)]
    
    def write_replica(path):
        try:
            zk.ensure_path(path)
            data, stat = zk.get(path)
            # Kazoo updates the version sequentially with each successful Set!
            zk.set(path, payload_data, version=stat.version)
            print(f"  + Node {path} Write OK (Version {stat.version + 1})")
            return True
        except Exception as e:
            print(f"  - Node {path} Offline/Error: {e}")
            return False
            
    pool = eventlet.GreenPool(size=N)
    results = list(pool.imap(write_replica, replica_paths))
    success_count = sum(results)
    
    if success_count >= W:
        print(f"\n>>>> [Quorum Write] SUCCESS! Majority {success_count}/{N} nodes committed. <<<<\n")
        return True
    else:
        print(f"\n[Quorum Write] FAILED! Only {success_count} nodes achieved. Target {W}.")
        return False

def quorum_read():
    """ Perform a concurrent R=3 Quorum Read to find absolute Truth """
    print(f"\n[Quorum Read] Initiating R={R} read operation... contacting random subset of {R} nodes.")
    # In a real system you'd shuffle and pick R nodes. Here we take the first R for demonstration.
    replica_paths = [f"/objects/{OBJECT_ID}/replica_{i}" for i in range(1, R+1)] 
    
    def read_replica(path):
        try:
            data, stat = zk.get(path)
            return {"node": path, "data": data, "version": stat.version}
        except Exception:
            return None
            
    pool = eventlet.GreenPool(size=R)
    results = [r for r in pool.imap(read_replica, replica_paths) if r is not None]
    
    if len(results) < R:
        print(f"[Quorum Read] FAILED! Failed to achieve Read Quorum. Only {len(results)} nodes responded.")
        return None
        
    print(f"[Quorum Read] Successfully queried {R} nodes. Analyzing timestamps...")
    for res in results:
        print(f"  * {res['node']} -> Version: {res['version']}, Data: {res['data'].decode('utf-8')}")
        
    latest_replica = max(results, key=lambda x: x['version'])
    
    print(f"\n>>>> [Quorum Read] CONSENSUS RESOLVED! Highest version is from {latest_replica['node']} (Version {latest_replica['version']}) <<<<")
    print(f"Absolute Truth Data: {latest_replica['data'].decode('utf-8')}\n")
    return latest_replica['data']

if __name__ == "__main__":
    print("--- N-W-R Quorum Replication Demo ---")
    zk.ensure_path(f"/objects/{OBJECT_ID}")
    
    # 1. Perform a Write
    quorum_write(b'{"computed_average": 210.5}')
    
    # 2. Perform a Read
    quorum_read()
    
    # Cleanup for next run (Optional)
    zk.delete('/objects', recursive=True)
    
    zk.stop()
