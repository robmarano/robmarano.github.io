# k8s_dist_histo: Distributed MapReduce Image Processor

This repository implements a distributed MapReduce application for image histogram equalization. It serves as a comprehensive pedagogical tool for ECE 465, demonstrating distributed systems, consistency models, and fault tolerance within a Kubernetes environment.

## 🏗️ System Architecture

The project utilizes a **homogeneous deployment topology** where all pods run the identical Python image. Roles are assigned dynamically at runtime:

- **Leader Election**: Pods compete for an ephemeral lock in **Apache ZooKeeper** using the `kazoo` library. The winner is promoted to **Master**, while the remaining nodes become **Workers**.
- **Dynamic Routing**: The elected Master utilizes the Kubernetes Python client to inject a `role: master` label into its own pod metadata. A dedicated `master-service` internal DNS routes external traffic exclusively to the current leader.
- **Distributed MapReduce Execution**:
    - **Master**: Accepts incoming images (TIFF/PNG/JPG), slices them horizontally using NumPy, and drops task definitions into ZooKeeper znodes (`/jobs/<job_id>`).
    - **Workers**: Utilize Kazoo `ChildrenWatch` events to detect new tasks, acquire an ephemeral lock on a specific slice, compute the local histogram or apply the equalization function using **NumPy** and **Pillow**, and write the result.
    - **Master**: Aggregates the local histograms to compute a Global CDF, dispatches the equalization tasks, and finally stitches the processed chunks back into a final image.
- **Shared Workspace**: A Kubernetes `PersistentVolumeClaim` mounts a shared directory across all pods. This allows the lightweight ZooKeeper znodes to coordinate execution while the heavy intermediate image matrices (`.npy` files) are passed via the shared filesystem.

## ⚖️ Consistency Model Demonstrations

The project includes three specialized standalone scripts to demonstrate theoretical distributed consistency levels:

1.  **Eventual Consistency (`demo_easy_eventual.py`)**: Uses ZooKeeper `DataWatch` to show how configuration changes from a primary source eventually propagate and synchronize across local replica caches asynchronously.
2.  **Primary-Backup Synchronous Replication (`demo_medium_primary_backup.py`)**: Simulates a strict synchronous write. The Master suspends an HTTP transaction until a simulated standby daemon acknowledges the payload replication, guaranteeing durability before returning success to the user.
3.  **Quorum Replication (`demo_hard_quorum.py`)**: Implements an **N-W-R** consensus model using concurrent GreenThreads. It demonstrates how majority writes ($W$) and overlapping majority reads ($R$) can resolve the "absolute truth" version of a data object even when multiple nodes fail or disagree.

## 🛡️ Fault Tolerance & Chaos Engineering

The system is engineered to handle and recover from severe failure modes, as outlined in the `FAULT_SIMULATION.md` guide:

- **Crash Failures (The Master Assassination)**: If the Master pod is forcefully deleted, its TCP heartbeat vanishes, and ZooKeeper drops the `/election` ephemeral lock. This triggers an instant callback in the workers, automatically promoting a new leader while Kubernetes spins up a replacement pod to restore physical redundancy.
- **Omission Failures (Network Partitions)**: By utilizing `iptables` to sever a worker's connection to port 2181, the node loses its ZooKeeper session. Any ephemeral task locks it held are purged, allowing healthy workers to safely steal and complete the orphaned tasks.
- **Quorum Collapse**: Demonstrates mathematical limits. If 2 out of 3 ZooKeeper replicas are destroyed, the ensemble cannot form a Quorum ($N/2 + 1$). The system intentionally freezes to prevent a "Split-Brain" scenario, proving that an $F=1$ fault-tolerant cluster cannot survive an $F=2$ disaster.

## 📊 Observability & Distributed UI

The system features a real-time observability dashboard built with Flask and Socket.IO:

- **Infinite Multiplexed Tailing**: The Master uses Kubernetes API RBAC (`read_namespaced_pod_log`) to continuously HTTP tail the `stdout` of every single pod in the cluster.
- **Live Terminal Grid**: The intercepted logs are broadcast via WebSockets to the frontend, which generates a dynamic Masonry Grid of mini-terminals. Users can visually track which worker is processing which chunk in real-time.
- **Auto-Scaling Alerts**: If the cluster topology drops below the required 5 active nodes, the Master broadcasts a cluster alert, safely halting MapReduce jobs until Kubernetes auto-recovers the missing pods.

## 🧪 Core Implementation Files

- **`app.py`**: The main Flask application orchestrating Leader Election, the MapReduce job lifecycle, Kubernetes API log tailing, and Socket.IO real-time communication.
- **`core/image_processing.py`**: Contains the mathematical logic for NumPy array splitting, histogram aggregation, CDF mask calculations, and Pillow image stitching.
- **`k8s/`**: The complete suite of Kubernetes manifests deploying the ZooKeeper StatefulSet, PersistentVolumes, RBAC bindings, and the homogeneous Application Deployment.
