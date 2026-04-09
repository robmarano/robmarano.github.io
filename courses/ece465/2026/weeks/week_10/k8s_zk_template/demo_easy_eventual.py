import time
import os
from kazoo.client import KazooClient
from kazoo.recipe.watchers import DataWatch

ZK_HOSTS = os.getenv('ZK_HOSTS', 'zookeeper:2181')
zk = KazooClient(hosts=ZK_HOSTS)
zk.start()

zk.ensure_path('/config')
if not zk.exists('/config/mapreduce_params'):
    zk.create('/config/mapreduce_params', b'{"chunk_size": 1024}')

global_app_config = {}

@DataWatch(zk, '/config/mapreduce_params')
def watch_global_config(data, stat, event):
    global global_app_config
    if data:
        global_app_config = eval(data.decode('utf-8'))
        print(f"\n>>>> [DataWatch Event] Local Replica Cache Eventually Converged To: {global_app_config} <<<<\n")

print("--- DataWatch Eventual Consistency Demo Running ---")
print("[Listener] Starting asynchronous watch on /config/mapreduce_params...")
time.sleep(2)

print("[Master] Simulating a Master Node updating the global ZNode across the network via zk.set()...")
new_config = b'{"chunk_size": 4096, "active_nodes": 5}'
zk.retry(zk.set, '/config/mapreduce_params', new_config)

# Keep the python thread alive enough for the async DataWatch event to trigger
time.sleep(3)
print("[System] Demo Complete. The local state seamlessly tracked the master configuration dynamically.")
zk.stop()
