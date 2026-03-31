# PR Summary: Week 9 Communication and Coordination & Distributed ZooKeeper Implementation

**Intended Changes**
* Author `courses/ece465/2026/weeks/week_09/notes_week_09.md` focusing on Communication (RPC/Message Passing) and Coordination (Election, Consensus) based on the van Steen & Tanenbaum textbook.
* Introduce an advanced Kubernetes-based architecture in `courses/ece465/2026/weeks/week_09/k8s_zk_template`.
* Implement a highly fault-tolerant Homogenous MapReduce Image processing engine via Flask/SocketIO/Pillow.
* Rely on Apache ZooKeeper (`kazoo`) for leader election and ephemeral task distribution watches.
* Configure Kubernetes RBAC allowing the elected Master pod to label itself dynamically, routing the internal `master-service` DNS proxy instantaneously to the reigning leader.

**Implementation Details**
* **Notes**: Authored comprehensive markdown detailing Socket constraints, RPC Marshalling, Publisher/Subscriber topologies, Lamport Clock synchronization concepts, the Bully/Ring election algorithms, and finally mapping those concepts directly to Apache ZooKeeper theory.
* **Kubernetes Infrastructure**: Deployed `manifests` for a native ZooKeeper instance, a hostPath Persistence Volume mapped to Minikube, ServiceAccounts for Pod-relabeling, and a homogenous Deployment with 3 initial identical replicas.
* **Master Controller**: Python threads use `kazoo.recipe.election` to race for an ephemeral lock. The winner automatically patches its K8s namespace labels with `role: master`. This flawlessly hooks into K8s internal DNS to serve the external websockets UI. 
* **ZooKeeper Coordinated MapReduce**:
    *   **Map Phase**: Master slices images vertically using `numpy`, scattering ephemeral `task` Znodes to `/jobs/histogram`. Workers claim them, execute `PIL` logic, and report local metrics arrays.
    *   **Barrier**: Master watches the ZTree structure until all arrays return, and accurately computes global normalized CDF metrics.
    *   **Reduce Phase**: CDF metric definitions scattered via new ephemeral `/jobs/equalization` tasks.
    *   **Fault Tolerance**: Included explicit logic blocking user traffic and broadcasting websocket warnings if active worker count `< 3` pods, automatically resolving upon K8s redeployment/scaling.
