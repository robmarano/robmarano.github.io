# ECE 465 Week 13 `k8s_histo_deployed` Bare Metal & GitOps Module

## Objective
Migrated the sandbox to `k8s_histo_deployed` and introduced Bare Metal Provisioning, Infrastructure as Code, and GitOps deployments.

## Implementation Details
*   **Infrastructure as Code Sandbox**: Added a `deploy/` folder containing real-world Terraform (Equinix Metal bare metal provisioning), Ansible (Kubeadm OS configuration), and ArgoCD (GitOps synchronization) code examples.
*   **Deployment Observability Simulator**: Modified the Python backend to intercept new WebSocket connections and stream a simulated infrastructure deployment pipeline (Terraform -> iPXE -> Ansible -> ArgoCD) directly into the UI's SecOps & Infrastructure Observability Dashboard.
*   **Curriculum Mapping**: Authored `notes_week_13.md` comprehensively covering Bare Metal PXE booting (MAAS, Tinkerbell), IaC (Terraform, Ansible, Chef), and GitOps (ArgoCD).
