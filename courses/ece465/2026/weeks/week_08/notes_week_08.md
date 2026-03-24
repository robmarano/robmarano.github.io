# Week 8: Distributed Architectures

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)

**Objective**: This week we explore how distributed systems are fundamentally organized. Leveraging Chapter 2 (Architectures) from the van Steen & Tanenbaum textbook, we will separate **Architectural Styles** (the logical organization) from **System Architectures** (the physical deployment topologies).

---

## 1. Architectural Styles

An architectural style formulates the rules on how components are connected, the data they exchange, and how they jointly form a system.

### 1.1 Layered Architectures
Components are organized in a logical hierarchy (Layer 1 to Layer N).
*   **Downcalls**: Layer N can make a request to Layer N-1. (Standard pattern: A web UI calls a backend API, which calls a Database).
*   **Upcalls**: Occasionally used, where Layer N-1 triggers an event in Layer N (Callbacks).
*   *Advantage*: Strong separation of concerns. Easy to replace one layer without affecting the whole system.

### 1.2 Object-based and Service-Oriented Architectures (SOA)
Components are treated as independent objects or services connected via a network call (like RPC or REST).
*   The system acts as a web of services. This is the foundation of modern **Microservices**.
*   *Advantage*: Highly modular. Different teams can write different services in totally different programming languages.

### 1.3 Resource-Centered Architectures (REST)
Representational State Transfer (REST) is a wildly popular style primarily built for the Web. It views the distributed system as a massive collection of **Resources**.
*   Each resource is uniquely identified by a URI (e.g., `https://api.system.com/users/12`).
*   Operations are standard and few: `GET`, `PUT`, `POST`, `DELETE`.
*   *Stateless*: The server does not remember the client's previous requests between calls. Every request must be fully self-contained.

### 1.4 Event-Based (Publish-Subscribe) Architectures
Components do not call each other directly (strong decoupling).
*   **Publishers**: Generate events or messages (e.g., "User account created").
*   **Subscribers**: Listen for specific events on an Event Bus (like Kafka, or RabbitMQ) and react to them.
*   *Advantage*: A publisher doesn't even need to know if the subscriber exists. Excellent for massive scale.

---

## 2. System Architectures

While styles dictate the logic, System Architectures dictate where the physical boxes (nodes) live and how traffic routes between them.

### 2.1 Centralized Architectures (Client-Server)
The traditional model. A set of specific machines (Servers) hold the data and do the heavy lifting. Many machines (Clients) solely make requests.
*   **Two-Tiered**: A thick client (Desktop App) talks directly to a Database Server.
*   **Multitiered**: A thin client (Web Browser) talks to an App Server, which talks to an independently hosted Database Server.

### 2.2 Decentralized Architectures (Peer-to-Peer)
Every node is equal. A node acts as both a client and a server.
*   **Structured P2P**: Nodes are organized mathematically (e.g., a massive logical ring in a Distributed Hash Table). If you are looking for file 'X', the math instantly tells you exactly which peer IP holds the file.
*   **Unstructured P2P**: Nodes form a random web. To find a file, you ask all your neighbors, who ask their neighbors, flooding the network until someone replies "I have it!" (e.g., early Gnutella).

### 2.3 Hybrid Architectures
Modern massive scale forces a blend of client-server and peer-to-peer.
*   **Edge & Fog Computing**: We don't want to send all data back to the central Cloud Server due to latency. We push processing out to the "Edge" (e.g., routers, 5G towers, or local IoT hubs). Data is analyzed locally, and only summaries are sent to the central Cloud.
*   **BitTorrent**: A classic hybrid. You ask a central server (the Tracker) *who* has pieces of the file you want (Client-Server). You then download the file pieces directly from the other users (Peer-to-Peer).
*   **Blockchains**: Nodes communicate purely peer-to-peer to gossip about transactions, yet jointly maintain a single decentralized, verifiable ledger.

---

## 3. Design & Implementation Exercises

These exercises challenge you to re-architect and scale the **Distributed Image Processor** (from Week 5) using the architectural styles discussed in Chapter 2 of Tanenbaum.

### Exercise 8A (Easy): Architectural Deconstruction
**Task**: Analyze the exact Docker Compose / Kubernetes topology you built in Week 5.
1. Does it utilize a **Layered Architecture** or a **Service-Oriented Architecture**? Justify.
2. Characterize the communication. Is it purely **REST** (Resource-centered) or does it utilize **Event-Based/Pub-Sub** concepts? 
3. Diagram this out using Mermaid, explicitly labeling the architectural styles.

### Exercise 8B (Medium): Event-Based Migration
**Scenario**: In Week 5, your API gateway or Distributor strictly called the Worker nodes directly. If a spike occurs, workers crash under the load.
**Task**: Re-architect the Image Processor to an **Event-Based (Publish-Subscribe) Architecture**.
1. Introduce a Message Queue (like RabbitMQ or Redis Streams) as the central nervous system.
2. The Web API now acts simply as a **Publisher**, dropping image upload events onto an `image_tasks` queue.
3. The Workers act strictly as **Subscribers**, pulling tasks off the queue only when they have free CPU cycles.
4. Provide a 3-paragraph write-up on how this architectural shift guarantees Distribution Transparency and Fault Tolerance.

### Exercise 8C (Hard): Hybrid Edge-Cloud Processing
**Scenario**: You are deploying the Image Processor for mobile devices globally. Cloud bandwidth costs are skyrocketing because users are uploading massive uncompressed RAW photos for simple grayscale processing.
**Task**: Design a **Hybrid Edge-Cloud Architecture**.
1. Modify the system design so that the mobile app (Edge) evaluates the request. If the task is simple (e.g., Grayscale or crop), the local Mobile CPU processes it (Edge computing).
2. If the task is heavy (e.g., AI-based upscaling), the Edge node compresses the image heavily and dispatches it over the network to the central Kubernetes cluster (Cloud computing).
3. Diagram the decision-tree logic and the network topology. Include this hybrid flow into an updated `PR_SUMMARY.md` reflecting your system design changes.
