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

---

## 5. Theoretical Problem Sets

The following problems bridge the theoretical concepts of Communication (Chapter 4) and Coordination (Chapter 6) into practical, real-world data center and internet-scale scenarios. Reference the *van Steen & Tanenbaum (v4.0.3x)* textbook for foundational models.

### Problem 5A (Easy): RPC Communication Semantics
**Reference:** *Chapter 4: Communication (RPC Semantics, Sec. 4.2.2, ~p. 182-185)*

**Scenario:** An e-commerce backend in an AWS Data Center uses Remote Procedure Calls (RPC) to communicate between a `CartService` and a `BillingService`. When a customer checks out over the internet (often dropping cellular connection), the `CartService` issues an RPC `process_payment(user_id, $50)` to the `BillingService`. A timeout occurs and no response is returned.

**Question:** What is the difference between *At-least-once* and *At-most-once* semantics in this scenario? Which is safer for internet-scale financial transactions, and how would you implement it from a design perspective?

**Worked Solution:**
1.  **Define the semantics:**
    *   *At-least-once* means the `CartService` will keep retrying the RPC indefinitely until it receives an ACK. If the network dropped the *reply* but not the *request*, the `BillingService` might execute the $50 charge multiple times.
    *   *At-most-once* means the RPC is sent exactly once. If it fails, an error is thrown. The payment will never be processed twice, but it might not be processed at all.
2.  **Evaluate Safety:** For financial transactions, *At-most-once* (or *Exactly-once*, which is practically impossible without distributed consensus) is safer than charging the user repeatedly.
3.  **Design Implementation:** Using **Idempotency**. The `CartService` generates a unique Transaction ID (UUID) and passes it in the RPC: `process_payment(user_id, $50, TXN_1234)`. We can now safely use an *At-least-once* retry loop. The `BillingService` coordinates by storing `TXN_1234` in a database. If the RPC is retried, the `BillingService` sees the UUID, skips the credit card charge, and simply returns the cached success response. 

### Problem 5B (Medium): Coordination via Logical Clocks
**Reference:** *Chapter 6: Coordination (Logical Clocks, Sec. 6.2, ~p. 306-310)*

**Scenario:** You have a distributed NoSQL database spanning three localized data centers (Nodes A, B, and C). They have distinct physical quartz clocks that suffer from clock drift. 
*   User 1 (connected to Node A) changes their profile picture.
*   User 2 (connected to Node B) immediately "Likes" the new profile picture.
Due to clock drift, Node B's physical clock is 5 minutes *behind* Node A. When the events replicate to Node C, Node C sees the "Like" timestamping *before* the "Profile Picture Change", creating an impossible reality.

**Question:** How does Lamport's Logical Clocks solve this without needing to physically synchronize the server clocks using NTP?

**Worked Solution:**
1.  **Discard Physical Time:** Instead of relying on quartz physical clocks, each node maintains a logical software counter, $L$.
2.  **Internal Events:** Before a node executes an event, it increments its own counter: $L = L + 1$.
3.  **Communication Events:** When Node A sends the "Profile Change" data to Node B, it attaches its current timestamp $L_A$. 
4.  **Causality Sync:** When Node B receives the message, it must respect that A's event *caused* B's subsequent event. Node B updates its own clock to be strictly greater than A's: $L_B = \text{MAX}(L_B, L_A) + 1$.
5.  **The Result:** When User 2 "Likes" the photo, Node B assigns a Lamport timestamp strictly higher than the "Profile Change". When Node C receives both replication streams, sorting by Lamport Timestamps guarantees absolute causal ordering, regardless of real-world physical drift.

### Problem 5C (Hard): Combining Pub/Sub Communication with Election Coordination
**Reference:** *Chapter 6: Coordination (Election Algorithms, Sec. 6.5, ~p. 339-344) & Chapter 4: Communication (Message-Oriented, Sec. 4.3, ~p. 192-205)*

**Scenario:** Millions of IoT smart-thermostats (Edge devices) connect over the public internet to a massive Data Center cluster. They communicate purely via an asynchronous, topic-based **Publish-Subscribe (Pub/Sub)** message broker (like MQTT). 
Within the Data Center, a cluster of 5 `Analytics` nodes process this data. Only one node can act as the "Coordinator" responsible for writing data to the Master SQL Database. The current Coordinator node catches on fire and is destroyed.

**Question:** Work through the exact steps of how the remaining 4 nodes utilize an Election Algorithm to coordinate, and how they subsequently communicate the result to the asynchronous Pub/Sub broker to ensure IoT traffic is not lost during the outage.

**Worked Solution (The Bully Algorithm + MOM):**
1.  **Failure Detection:** Node 3 attempts to send a heartbeat to the Coordinator (Node 5) and receives a TCP timeout. Node 3 suspects the coordinator is dead.
2.  **The Election (Coordination):**
    *   Node 3 initiates the *Bully Algorithm*. It sends an `ELECTION` message to all nodes with a higher ID (Node 4 and Node 5).
    *   Node 5 (dead) does not reply. Node 4 is alive and replies with an `OK` message, forcing Node 3 to stand down.
    *   Node 4 now holds the election. It sends an `ELECTION` message to higher nodes (Node 5).
    *   Receiving no reply, Node 4 promotes itself. It broadcasts a `COORDINATOR` message to Nodes 1, 2, and 3. The cluster is re-coordinated.
3.  **State Recovery (Communication):**
    *   IoT devices write continuously to the Pub/Sub broker asynchronously. Because messaging is *Persistent* (Section 4.3.2), the Pub/Sub broker simply buffers the millions of incoming MQTT messages in a queue while the Data Center was holding its election. No internet traffic was dropped.
4.  **Resuming Service:**
    *   The newly elected Coordinator (Node 4) opens a TCP connection to the Pub/Sub broker, subscribes to the `thermostat/data` topic, and begins draining the buffered message queue, writing the backlog to the SQL database.
