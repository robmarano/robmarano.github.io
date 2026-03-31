# Week 9: Communication and Coordination

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)

**Objective**: This week we move from defining overall architectural styles to understanding the underlying mechanisms that allow geographically separated components to **Communicate** reliably and **Coordinate** their actions without a centralized clock. This session heavily maps to the theories presented in the van Steen & Tanenbaum *Distributed Systems* textbook.

> 📖 **Reading Assignment:** Before proceeding with this week's exercises, please read **Chapter 4 (Communication)** and **Chapter 6 (Coordination)** in *Distributed Systems* (van Steen and Tanenbaum, Version 4.0.3x).

---

## 1. Communication in Distributed Systems

At the core of any distributed system is the ability to move data between nodes. While we have explored raw TCP/UDP sockets (Week 2/3), enterprise systems rely on higher-level abstractions.

### 1.1 Remote Procedure Calls (RPC)
The aim of RPC is to hide communication by making a remote function call look identical to a local function call. 
*   **Mechanism**: A client application calls a local "stub" function. The stub serializes (marshals) the parameters, opens a network socket, sends the data, and blocks until the server returns the serialized result.
*   **Challenges**: RPC cannot easily pass pointers/references. It also struggles with failures: if a client calls `charge_credit_card()` and the connection drops, did the server execute it and fail to send a reply, or did the server crash before execution? Dealing with *at-least-once* vs *at-most-once* semantics introduces high complexity.

### 1.2 Message-Oriented Communication
Unlike RPC's synchronous, tightly-coupled nature, Message-Oriented Middleware (MOM) allows asynchronous decoupling.
*   **Transient Messaging**: Like traditional sockets; if the receiver is not active when the message is sent, the message is lost.
*   **Persistent Messaging (Queues)**: Systems like RabbitMQ guarantee that a message sent by a producer is stored safely on disk by the middleware until a consumer comes online and reads it. This provides extreme resilience against sudden burst traffic.

---

## 2. Coordination and Synchronization

If multiple independent computers are working on a shared problem, how do they agree on the state of the world? 

### 2.1 The Problem of Clock Synchronization
In a single machine, there is one CPU clock. In a distributed system, every computer has its own physical quartz clock. Over time, these clocks drift apart due to microscopic hardware differences. 
*   If Server A creates a file at 12:00:01 and sends it to Server B, and Server B's clock thinks it is currently 11:59:59, Server B might assume the file was created "in the future" or incorrectly sequence events.
*   *Solution*: **Logical Clocks** (like Lamport timestamps) don't care about the *actual* physical time. They only care about causality: if Event A causes Event B, then Event B must have a larger timestamp than Event A.

### 2.2 Leader Election Algorithms
Many distributed systems require one node to act as a coordinator. If that coordinator crashes, the remaining nodes must elect a new one without human intervention.
1.  **The Bully Algorithm**: Every node has a numeric ID. When a node detects the leader is dead, it broadcasts an election message to nodes with *higher* IDs. If no higher node responds, it declares itself the leader ("bullying" the smaller nodes).
2.  **The Ring Algorithm**: Nodes are logically organized in a ring. An election message is passed around the ring, accumulating the IDs of all active nodes. Once it completes the circuit, the surviving node with the highest ID is elected as the new coordinator.

---

## 3. Apache ZooKeeper: Putting Theory into Practice

Implementing consensus algorithms (like Paxos or Raft) from scratch is notoriously difficult. Modern cloud-native architectures rely on highly consistent coordination services like **Apache ZooKeeper** (or `etcd`).

### What is ZooKeeper?
ZooKeeper is a centralized open-source service for maintaining configuration information, naming, providing distributed synchronization, and offering group services over large clusters. 

### How it solves Distributed Coordination:
*   **Znodes**: ZooKeeper maintains a hierarchical, in-memory file system. Data is stored in tiny files called `znodes`.
*   **Ephemeral Nodes**: A znode can be marked as ephemeral. This means it only exists as long as the client connection that created it is alive. If the client crashes, ZooKeeper instantly deletes the node. This is *perfect* for heartbeat monitoring and leader election.
*   **Watches**: Instead of a client constantly polling ZooKeeper to see if data changed, it sets a "Watch". ZooKeeper will instantly push a notification to the client the moment a znode is modified, added, or deleted.

### Implementing Leader Election with ZooKeeper
Instead of building the Bully algorithm, nodes simply use ZooKeeper's atomic creation:
1. All 10 worker nodes try to create an ephemeral znode at `/cluster/leader`.
2. ZooKeeper guarantees that only **one** creation request will succeed concurrently.
3. The node that succeeded knows it is the leader.
4. The remaining 9 nodes set a Watch on `/cluster/leader` and go to sleep.
5. If the leader crashes, its ephemeral node vanishes. ZooKeeper fires the Watch, waking up the 9 nodes. They all try to create `/cluster/leader` again.

---

## 4. Design & Implementation Exercise
**Task**: *The ZooKeeper Homogenous MapReduce Array*

Move to the `k8s_zk_template` directory. We are rebuilding our Week 5 Image equalization engine to be completely fault-tolerant and homogenous. 

You must deploy a Kubernetes application where **all** Pods run the exact same `app.py` code. Upon startup, the pods connect to a central ZooKeeper service in the cluster.
1. The Pods will race using `kazoo` to elect a Master.
2. The elected Master will use the Kubernetes API to add the label `role: master` to itself.
3. Kubernetes DNS will instantly map `http://master-service` to that specific pod!
4. The Master orchestrates a distributed MapReduce job by passing task slices not via direct HTTP, but by dropping JSON jobs into ZooKeeper `/jobs` znodes. The ephemeral workers watch this path, claim specific chunk jobs, and return the histogram logic securely.
