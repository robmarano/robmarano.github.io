# ECE 465 Spring 2026: Master Course Notes Compilation

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)

This document serves as the global synthesis of all lecture materials and design deep-dives covered throughout the semester. Follow the links provided within each section to access the detailed, technical notes for that week.

---

Classes will be decided week-to-week.

|       Week(s) | Week of | Topic                                                                    |
| ------------: | ------: | :----------------------------------------------------------------------- |
| [01](#week01) |    1/27 | Intro; centralized vs distributed systems; development environment setup |
| [02](#week02) |     2/3 | Multi-processing & network programming &mdash; Part 1                    |
| [03](#week03) |    2/10 | Multi-processing & network programming &mdash; Part 2                    |
| [04](#week04) |    2/17 | Multi-processing & network programming &mdash; Part 3                    |
| [05](#week05) |    2/24 | Containerization: Docker and Kubernetes                                  |
| [06](#week06) |     3/3 | DevOps and CI/CD                                                         |
| [07](#week07) |    3/10 | Integrate application to infrastructure                                  |
| [08](#week08) |    3/17 | Distributed Architectures                                                |
| [09](#week09) |    3/24 | Communication and Coordination                                           |
| [10](#week10) |    3/31 | Consistency & Replication                                                |
| [11](#week11) |     4/7 | Fault Tolerance                                                          |
| [12](#week12) |    4/21 | Security                                                                 |
| [13](#week13) |    4/28 | Deploying on k8s on cloud-based virtual bare metal nodes                 |
| [14](#week14) |     5/5 | Deploying on k8s on cloud-based k8s                                      |
| [15](#week15) |    5/12 | Final individual projects due                                            |

Follow the link above to the respective week's materials below.
<br>

---

## <a id="week01"></a>[Week 1: Intro to Distributed Systems](./weeks/week_01/notes_week_01.md)
*   **Overview**: An introduction to defining exactly what a distributed system is—a collection of autonomous computing elements that appears to its users as a single coherent system. 
*   **Key Concepts**: The difference between highly decentralized structures versus physically distributed ones, and the four core design goals: Resource Sharing, Distribution Transparency, Openness, and Scalability.

## <a id="week02"></a>[Week 2: Multi-processing & Network Programming — Part 1](./weeks/week_02/notes_week_02.md)
*   **Overview**: A deep dive into the foundational operating system constructs required to build distributed logic.
*   **Key Concepts**: Understanding the Linux Process model, context switching overheads, and Inter-Process Communication (IPC) utilizing pipes, shared memory, and locks. Contrastingly, the transition to multi-threading within a shared address space is explored with Python and Java examples to achieve lightweight concurrency.

## <a id="week03"></a>[Week 3: Multi-processing & Network Programming — Part 2](./weeks/week_03/notes_week_03.md)
*   **Overview**: Expanding upon basic intra-machine multiprocessing to inter-machine communication over standard network protocols.
*   **Key Concepts**: Establishing reliable byte streams via TCP sockets and unreliable packet transmission via UDP. Moving from theoretical concurrency models to physical Java networking implementations.

## <a id="week04"></a>[Week 4: Multi-processing & Network Programming — Part 3](./weeks/week_04/notes_week_04.md)
*   **Overview**: Elevating raw byte-stream communication into the high-level paradigms needed for modern distributed application development.
*   **Key Concepts**: Remote Procedure Calls (RPC) that marshal parameters to make remote executions appear local, and Message-Oriented Communication (Message Queues, Publish-Subscribe topologies) to totally decouple senders from receivers and provide asynchronous resilience.

## <a id="week05"></a>[Week 5: Containerization (Docker) & Orchestration (Kubernetes)](./weeks/week_05/notes_week_05.md)
*   **Overview**: Exploring how to predictably package, deploy, and scale complex, multi-service network applications.
*   **Key Concepts**: Bridging the theory of OS-level virtualization to practice via Docker containers. Investigating declarative orchestration utilizing Kubernetes/Docker Compose. A massive real-world implementation is detailed here: building a distributed Image Processing Map-Reduce framework using a containerized microservice topology.

## <a id="week06"></a>[Week 6: DevOps and CI/CD](./weeks/week_06/notes_week_06.md)
*   **Overview**: The automation journey from manual configuration to reliable, automated code deployments.
*   **Key Concepts**: Analyzing the DevOps culture shift and API-first designs. Building Continuous Integration (CI) pipelines for build/test testing alongside Continuous Deployment (CD) progressive delivery models (Rolling, Blue-Green, Canary). Integrating GitOps and Infrastructure as Code into modern cluster deployments.

## <a id="week07"></a>[Week 7: Integrate Application to Infrastructure (Middleware)](./weeks/week_07/notes_week_07.md)
*   **Overview**: Examining how disparate applications are bridged smoothly to underlying OS and network infrastructure.
*   **Key Concepts**: The definition and utility of Middleware as a single-system image enabler. Deep exploration of application integration using Wrappers, Adapters, and Interceptors. The accompanying design exercise challenges students to implement a robust routing and logging proxy interceptor in raw code.

## <a id="week08"></a>[Week 8: Distributed Architectures](./weeks/week_08/notes_week_08.md)
*   **Overview**: Analyzing the fundamental logical and physical layouts of distributed environments, aligning directly with Tanenbaum's Chapter 2.
*   **Key Concepts**: Decoupling Architectural Styles (Layered, Object-based, Resource-centered/REST, Event-based) from System Architectures (Centralized client-server topologies vs Decentralized structured P2P vs Hybrid Edge/Cloud computing).

## <a id="week09"></a>[Week 9: Communication and Coordination](./weeks/week_09/notes_week_09.md)
*   **Overview**: An exploration of how distributed applications actually pass messages and synchronize state across physical networks without failing.
*   **Key Concepts**: The nuances of Remote Procedure Calls (RPC) versus socket-level message passing. The theory behind logical Lamport clocks, leader election via the Ring and Bully algorithms, and achieving scalable fault-tolerance. The week culminates with deploying a live, event-driven Homogeneous MapReduce engine backed natively by Apache ZooKeeper and Kubernetes.

## <a id="week10"></a>[Week 10: Consistency & Replication](./weeks/week_10/notes_week_10.md)
*   **Overview**: An investigation into the inherent tradeoffs between data reliability and latency when deploying active cluster network replicas.
*   **Key Concepts**: Contrasting Data-Centric consistency models (Strict, Sequential, Causal, Eventual) against Client-Centric session guarantees (Read-Your-Writes). We advance the infrastructure constructed in Week 09 to natively deploy Python ZooKeeper scripts modeling Eventual Convergence, synchronous Primary-Backup replication, and mathematically provable N-W-R Quorum-based transaction partitions.

---
[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)
