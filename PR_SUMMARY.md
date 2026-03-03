# PR Summary

## Intended Changes
Prepare the ECE 465 Spring 2026 Session 5 notes and lab material focusing on **Containerization: Docker and Kubernetes**. 
- Append Session 5 concepts (OS-level virtualization, Docker, Kubernetes) to `ece465-notes.md`.
- Enhance the `weeks/week_05/netprog` lab directory by providing a descriptive `README.md` to guide students on containerizing the existing TCP Server application using the provided `Dockerfile` and `Makefile`.

## Implementation Details
1. **`ece465-notes.md`**: Added a new section for **Week 5**: "Containerization: Docker and Kubernetes". The section details:
   - Differences between OS-level and Hardware virtualization.
   - Core concepts of Docker (Images, Containers, Dockerfile).
   - Core concepts of Kubernetes (Pods, Deployments, Services).
2. **`weeks/week_05/netprog/Dockerfile`**: Updated the base Ubuntu image from `24.10` to `24.04` (LTS) to resolve `apt-get` repository EOL issues.
3. **`weeks/week_05/netprog/README.md`**: Created a step-by-step guide for students to build the Docker image, run the containerized TCP server, and test it using the local TCP client. Verified locally via `make compile` and `docker build/run/logs`.
