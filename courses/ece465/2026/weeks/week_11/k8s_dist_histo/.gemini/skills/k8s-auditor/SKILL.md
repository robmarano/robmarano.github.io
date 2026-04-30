---
name: k8s-auditor
description: A comprehensive Kubernetes cluster auditing tool. Use this skill when asked to evaluate, inspect, or audit a local or remote Kubernetes cluster for health, security, topology, and workload deployment best practices.
---

# k8s-auditor: Kubernetes Deep-Dive Auditor

This skill transforms Gemini CLI into a specialized Kubernetes cluster auditor. It executes a rigorous, multi-layered assessment of a target cluster (accessed via a provided `kubectl` context or SSH remote command) to identify health issues, architectural bottlenecks, security misconfigurations, and general best practices.

## Audit Workflow

When invoked to assess a cluster, you MUST methodically execute the following assessment phases.

### Phase 1: Cluster Topology & Health
**Objective:** Understand the physical layout and baseline health of the control plane and worker nodes.
**Commands to execute:**
1. `kubectl get nodes -o wide` (Identify OS, Container Runtime, Kubernetes Version, Internal/External IPs)
2. `kubectl describe nodes | grep -i taints -A 2` (Identify scheduling constraints like `NoSchedule` or `NoExecute`)
3. `kubectl get componentstatuses` (Or equivalent checking core components like etcd, scheduler, controller-manager)

### Phase 2: Workload Footprint & Isolation
**Objective:** Map out the running applications and evaluate namespace isolation.
**Commands to execute:**
1. `kubectl get namespaces`
2. `kubectl get pods -A --field-selector status.phase!=Running` (Quickly identify crashing, pending, or failed pods)
3. `kubectl get deployments,statefulsets,daemonsets -A` (Understand the persistent vs. stateless architecture)

### Phase 3: Security & Access Control
**Objective:** Identify high-level security risks regarding RBAC and secrets management.
**Commands to execute:**
1. `kubectl get clusterroles,clusterrolebindings | grep -i admin` (Look for overly permissive bindings)
2. `kubectl get sa -A` (Check for default service account usage)
3. (If metrics server is installed) `kubectl top nodes` / `kubectl top pods -A` to check for resource exhaustion vulnerabilities.

### Phase 4: Storage & Networking
**Objective:** Evaluate data persistence and external exposure.
**Commands to execute:**
1. `kubectl get pv,pvc -A` (Look for unbound claims or problematic storage classes like local-path on multi-node clusters)
2. `kubectl get ingress -A` and `kubectl get svc -A | grep LoadBalancer` (Identify how traffic enters the cluster)

## Reporting the Audit (The Output Format)

After gathering the data across all phases, you MUST synthesize a report in the following format:

### 🏥 The Good (Strengths)
List 3-5 positive aspects of the cluster. Examples:
- Proper use of multi-node topology separating control-plane from workers.
- Modern container runtime usage (e.g., containerd instead of docker).
- Clear namespace isolation for distinct workloads.

### ⚠️ The Bad (Warnings & Inefficiencies)
List issues that degrade performance or availability but aren't critical failures. Examples:
- Pods stuck in `Pending` or `Failed` states.
- Missing resource requests/limits on deployments.
- Using `hostPath` storage in a multi-node environment.

### 💀 The Ugly (Critical Security & Architecture Flaws)
List severe risks. Examples:
- Outdated Kubernetes version with known CVEs.
- Over-privileged default service accounts.
- Nodes lacking crucial taints leading to control-plane resource starvation.

### 🛠️ Remediation & Recommendations (How to Fix)
Provide actionable, specific `kubectl` commands, YAML patches, or architectural advice to fix the issues identified in "The Bad" and "The Ugly". Do not provide generic advice; tailor it strictly to the exact workloads found on the cluster.
