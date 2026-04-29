# ECE 465 Week 13 `k8s_histo_deployed` Bare Metal & GitOps Module

## Objective
Migrated the sandbox to `k8s_histo_deployed` and introduced Bare Metal Provisioning, Infrastructure as Code, and GitOps deployments.

## Implementation Details
*   **Infrastructure as Code Sandbox**: Added a `deploy/` folder containing real-world Terraform (Equinix Metal bare metal provisioning), Ansible (Kubeadm OS configuration), and ArgoCD (GitOps synchronization) code examples.
*   **Deployment Observability Simulator**: Modified the Python backend to intercept new WebSocket connections and stream a simulated infrastructure deployment pipeline (Terraform -> iPXE -> Ansible -> ArgoCD) directly into the UI's SecOps & Infrastructure Observability Dashboard.
*   **Curriculum Mapping**: Authored `notes_week_13.md` comprehensively covering Bare Metal PXE booting (MAAS, Tinkerbell), IaC (Terraform, Ansible, Chef), and GitOps (ArgoCD).
*   **Architecture Documentation (UML Diagrams):** Enhanced `notes_week_13.md` with visual Mermaid.js representations of the codebase:
    *   **System Topology Architecture:** A hierarchical flowchart mapping physical Equinix hardware, OS/Runtime, K8s orchestration, and MapReduce application layers.
    *   **Sequence Diagram:** A chronological flow detailing the exact WebSocket event exchanges during the infrastructure deployment simulation and MapReduce execution.
