# ECE 465 Week 13 - Practical Bare Metal Walkthrough

## Objective
Add a detailed real-world walkthrough (Section 7) to `notes_week_13.md` that bridges the theoretical bare metal concepts (PXE, Terraform, Ansible, GitOps) with the practical deployment and observability of our `k8s_histo_deployed` MapReduce application.

## Implementation Details
*   **Section 7 Integration:** Appended a comprehensive "Connecting the Dots" tutorial to the Week 13 curriculum.
*   **Real-World Pipeline Documentation:** Detailed the step-by-step lifecycle:
    1.  **Hardware Design:** Reserving Equinix Metal physical nodes via Terraform.
    2.  **OS Installation:** Bootstrapping Ubuntu via iPXE/Tinkerbell.
    3.  **Cluster Configuration:** Executing Ansible to install Containerd and configure `kubeadm`.
    4.  **GitOps Deployment:** Binding the cluster to GitHub using ArgoCD to deploy `k8s_histo_deployed`.
    5.  **Observability & Management:** Utilizing the Flask/SocketIO dashboard to observe the deployment simulator and live ZooKeeper telemetry.
