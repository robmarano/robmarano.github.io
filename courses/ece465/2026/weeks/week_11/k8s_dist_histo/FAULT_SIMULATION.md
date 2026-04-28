# Chaos Engineering: Simulating Fault Tolerance

This document outlines how to manually inject faults into the `k8s_dist_histo` cluster to observe how the theoretical Fault Tolerance design concepts are executed in real-time by Kubernetes and ZooKeeper.

Before proceeding, ensure your cluster is fully deployed and the Web UI (Observability Dashboard) is open:
```bash
eval $(minikube docker-env)
docker build -t zk-app:latest .
kubectl apply -f k8s/
```

---

## Fault 1: The Master Assassination (Crash Failure)

In a **Crash Failure**, a node suddenly halts execution without warning. In our `k8s_dist_histo` cluster, the Python processes handle Leader Election to assign exactly one Master node.

### 🔪 How to inject the fault
Open your terminal and forcefully assassinate the current Master Pod:
```bash
kubectl delete pod -l role=master
```

### 👁️ What to watch in the Observability Stream
1. **The Timeout:** ZooKeeper will realize the TCP heartbeat from the Master pod has vanished.
2. **The Election Triggered:** Because the ephemeral lock at `/election` vanishes, the 4 remaining worker pods instantly trigger the `Kazoo` election callback.
3. **The Promotion:** You will see a `WARNING` or `CRITICAL` log stream onto the dashboard: `Leader Election Won by zk-app-xxxxx`.
4. **The Recovery (Masking):** Kubernetes will immediately notice that the Deployment requested 5 replicas, but only 4 exist. It will spin up a fresh pod to replace the assassinated one, silently restoring full Physical Redundancy.

---

## Fault 2: The Network Partition (Omission Failure)

In an **Omission Failure**, a node is perfectly healthy, but its network cable is severed. It cannot send or receive messages.

### 🔪 How to inject the fault
We will use `iptables` to drop all outgoing TCP packets to ZooKeeper (Port 2181) from a specific worker pod.

First, find a worker pod name:
```bash
kubectl get pods -l role=worker
```
Then, execute the firewall drop:
```bash
kubectl exec -it <YOUR_WORKER_POD_NAME> -- iptables -A OUTPUT -p tcp --dport 2181 -j DROP
```

### 👁️ What to watch in the Observability Stream
1. **Connection Suspended:** The UI will print a `WARNING` indicating `ZooKeeper Connection: SUSPENDED`. The Kazoo client knows it cannot reach the ensemble.
2. **Session Lost:** After the heartbeat timeout expires (typically ~10-60s), Kazoo declares the session `LOST`. Any ephemeral ZNodes owned by this pod are securely purged by the ensemble.
3. **Healing:** To heal the partition, flush the firewall rules:
   ```bash
   kubectl exec -it <YOUR_WORKER_POD_NAME> -- iptables -F
   ```
   You will see the UI immediately print a green `ZooKeeper Connection: CONNECTED` as the pod resyncs its state!

---

## Fault 3: Overwhelming the System (Quorum Collapse)

Fault Tolerance has mathematical bounds. The system is designed to handle $F$ failures. If we intentionally exceed the designed failure limits, the system goes "out-of-spec" and collapses.

Our ZooKeeper ensemble is a StatefulSet of **3 Replicas**. 
ZooKeeper requires a strict majority **Quorum** ($N/2 + 1$) to operate. 
For $N=3$, the Quorum is **2**. Therefore, the ensemble can only tolerate $F=1$ failure.

### 🔪 How to inject the fault
We will simulate a catastrophic datacenter fire that destroys 2 of the 3 ZooKeeper nodes simultaneously.

```bash
kubectl scale statefulset zookeeper --replicas=1
```

### 👁️ What to watch in the Observability Stream
1. **Absolute Silence / Massive Errors:** The UI will instantly flood with red `LOST` connection events from all 5 Python pods.
2. **System Deadlock:** Because ZooKeeper only has 1 node online, it **cannot establish a Quorum (1 < 2)**. To prevent a Split-Brain scenario, ZooKeeper intentionally transitions into `READ_ONLY` mode or halts. 
3. **MapReduce Failure:** If you attempt to upload an image in the UI, the Python backend will freeze or throw `ConnectionDrop` errors because it is mathematically impossible to safely acquire a distributed lock without Quorum consensus. 
4. **The Lesson:** We overwhelmed the system. To survive a 2-datacenter fire, the system MUST be designed with $N=5$ ZooKeeper nodes (Quorum = 3, allowing $F=2$ failures).

To recover the system, scale it back into spec:
```bash
kubectl scale statefulset zookeeper --replicas=3
```
