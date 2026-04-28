# ECE 465 Spring 2026: Week 13 - Cloud-Based Bare Metal & GitOps Deployment

> **Reading Assignment:** Real-World Deployments and Configuration Management. Supplemental reading on declarative infrastructure vs. imperative automation.

## 1. Escaping the Virtual Sandbox
Throughout the semester, we have utilized Kubernetes (`minikube`) running inside virtual machines on your local laptops. While Virtual Machines (VMs) provide immense isolation, they incur a virtualization penalty (the hypervisor overhead). 

When designing high-frequency trading platforms, massive machine-learning MapReduce clusters, or ultra-low-latency edge devices, you must deploy directly to **Bare Metal**. 

Deploying to bare metal introduces a severe physical challenge: *How do you install an Operating System onto thousands of blank hard drives simultaneously, without manually inserting a USB drive into each rack?*

---

## 2. Bare Metal Provisioning (PXE, MAAS, Tinkerbell)

To automate physical hardware, we rely on **PXE (Preboot Execution Environment)** and its modern successor, **iPXE**. 

When a bare metal server powers on, before it checks its hard drive, its Network Interface Card (NIC) broadcasts a DHCP request asking: *"Who am I, and where is my bootloader?"*

### Bare Metal as a Service (BMaaS)
To manage these PXE broadcasts at scale, we use automated provisioning engines:
*   **MAAS (Metal As A Service):** Created by Canonical (Ubuntu), MAAS acts as a full cloud-like orchestrator. It answers the PXE requests, automatically inventories the physical CPU/RAM/Disks, and pushes a fresh OS image onto the bare drive over the network.
*   **Tinkerbell:** A cloud-native, microservice-based provisioning engine (originally built by Equinix Metal). It uses declarative Kubernetes-style YAML manifests to define exactly what OS and scripts should be burned into the server during the PXE boot phase.

---

## 3. Infrastructure Automation: IaC vs. Configuration Management

Once the physical servers are powered on and running a raw OS (like Ubuntu 22.04), we must automate the installation of our software. We divide this into two categories.

### A. Infrastructure as Code (IaC) - *The "What"*
IaC tools are **Declarative**. You write code declaring *what* the final state of the datacenter should be, and the tool figures out how to make it happen.
*   **Terraform:** The industry standard. You write `.tf` files stating: *"I need 3 Bare Metal servers in New York."* Terraform communicates with the cloud provider APIs (like AWS or Equinix Metal) to securely order, provision, and network the hardware. Terraform is excellent for *creating* the raw compute resources.

### B. Configuration Management - *The "How"*
Once Terraform creates the servers, Configuration Management tools SSH into those servers to imperatively execute commands, install packages, and manage files.
*   **Chef:** Uses "Cookbooks" and "Recipes" (written in Ruby) to manage system configurations. It typically requires an agent running continuously on the physical server.
*   **Ansible:** The modern favorite for its simplicity. It is "agentless" (it just uses standard SSH) and executes sequential tasks defined in YAML **Playbooks**. We use Ansible to log into the raw Ubuntu servers, install Docker, and run `kubeadm init` to turn the raw servers into a Kubernetes cluster.

---

## 4. GitOps: Continuous Kubernetes Deployment

With Kubernetes running on our physical hardware, how do we deploy our MapReduce Sandbox? We could manually type `kubectl apply -f k8s/`, but that is prone to human error and undocumented changes.

Enter **GitOps**. 
GitOps mandates that your Git repository (e.g., GitHub) is the *single source of truth* for your live system. 
*   **ArgoCD:** An operator installed inside the Kubernetes cluster. It continuously monitors your GitHub repository. If you merge a Pull Request that updates the ZooKeeper Docker image from `v1` to `v2`, ArgoCD detects the change and automatically executes the rollout in the live cluster.
*   **Self-Healing:** If an attacker (or clumsy engineer) manually deletes a pod in production using `kubectl delete`, ArgoCD detects the cluster has drifted from the Git definition, and instantly respawns the pod.

---

## 5. Live Project: `k8s_histo_deployed`

This week, we migrated our sandbox to include a physical `deploy/` directory containing the exact scripts used to stand up the architecture:
1.  **`deploy/terraform/main.tf`**: The Terraform code to rent physical Equinix Metal servers.
2.  **`deploy/ansible/playbook.yml`**: The Ansible playbook to install `kubelet` and initialize the Kubernetes Control Plane.
3.  **`deploy/gitops/argocd-app.yaml`**: The ArgoCD declarative definition that binds the live cluster to the GitHub repository.

### Infrastructure Observability
We have also upgraded the UI's **SecOps Dashboard** to include **Infrastructure Deployment Observability**. 
When you deploy the application and open the Web UI, the Python backend will simulate the deployment pipeline sequence, streaming the Terraform, Tinkerbell, Ansible, and ArgoCD rollout events directly to the browser before the cluster accepts MapReduce workloads.
