# ECE 465 Week 11 `k8s_dist_histo` Fault Tolerance Sandbox

## Objective
Migrated the Week 10 ZooKeeper baseline into a dedicated Week 11 sandbox (`k8s_dist_histo`) to demonstrate Crash Failure masking and provide live UI telemetric observability of fault-tolerant recovery events.

## Implementation Details
*   **Kubernetes Crash Masking**: Injected `livenessProbe` (`/health`) and `readinessProbe` (`/ready`) directly into the `app.yaml` deployments. Kubernetes now automatically terminates and respawns any Python pod suffering from an Eventlet deadlock.
*   **Kazoo State Interceptors**: Wired a `KazooState` listener in `app.py` to detect underlying TCP disconnections (`LOST`, `SUSPENDED`) and broadcast them over WebSockets.
*   **Fault Observability Dashboard**: Augmented `index.html` with a live, color-coded terminal dashboard that visually prints master node crashes, leader elections, and connection renegotiations in real-time.
*   **Curriculum Integration**: Augmented `notes_week_11.md` to include explicit Python pseudo-code for the Two-Phase Commit (2PC) algorithm and a Mermaid sequence diagram detailing the Liveness Probe Crash Masking flowchart executed by `k8s_dist_histo`.


## Update (Chaos Engineering)
Authored `FAULT_SIMULATION.md` to provide students with explicit terminal commands (`kubectl delete`, `iptables DROP`, `kubectl scale`) to manually inject Crash, Omission, and Quorum-Collapse failures into the cluster. Expanded `notes_week_11.md` to explicitly map theoretical Failure Models to the physical Python/YAML code deployed in `k8s_dist_histo`.
