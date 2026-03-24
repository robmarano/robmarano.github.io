# Week 4: Multi-processing & Network Programming &mdash; Part 3

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)

**Objective**: In Parts 1 and 2, we looked at how programs can concurrently execute (using processes and threads) and communicate over a network using raw TCP/UDP Sockets. In Part 3, we elevate this raw byte-stream communication into higher-level, structured paradigms: **Remote Procedure Calls (RPC)** and **Message-Oriented Communication**.

These paradigms form the backbone of modern distributed application development, abstracting away the tedious nature of raw socket programming.

---

## 1. Remote Procedure Calls (RPC)

When a developer is writing a local application, calling a function is trivial: `result = calculate_tax(amount)`. 

The goal of **Remote Procedure Call (RPC)** is to make calling a function on a *remote* server look exactly like calling a local function. This is a classic example of achieving **Access and Location Transparency** in a distributed system.

### How RPC Works
Because the calling program (Client) and the executing program (Server) do not share the same memory space, the RPC framework introduces "Stubs":
1.  **Client Stub**: A local proxy function sitting on the client machine. When the client calls `calculate_tax()`, it is actually calling the Client Stub. The stub takes the parameters, *marshals* (serializes) them into a byte sequence (like JSON, XML, or Protocol Buffers), and sends them over a network socket to the server.
2.  **Server Stub (Skeleton)**: Receives the byte sequence over the network, *unmarshals* it back into native parameters, and executes the actual `calculate_tax()` function on the server. It then marshals the result and sends it back.

### Challenges with RPC
*   **Passing Parameters by Reference**: You cannot pass a memory pointer (reference) to a remote machine because memory spaces are completely separate. RPCs must pass everything *by value* or construct global references, which is highly inefficient.
*   **Failure Semantics**: If a local function fails, the program crashes. If an RPC call fails (due to a network timeout), the client does not know if the server crashed *before* executing the function, *during* the execution, or if the *reply* simply got lost. This introduces the complexity of exactly-once vs at-least-once execution semantics.

---

## 2. Message-Oriented Communication

While RPC is excellent for synchronous, request-reply interactions, it forces tight coupling: the client must block and wait for the server to respond, and both must be online simultaneously.

**Message-Oriented Communication** assumes that communication can be asynchronous and prolonged.

### 2.1 Transient Messaging (Raw Sockets)
As seen in Week 2, transient communication means the message is discarded if it cannot be delivered immediately. A TCP socket will fail if the receiving application isn't currently alive and listening.

### 2.2 Persistent Messaging (Message Queues)
To decouple the sender and receiver, we introduce **Message-Queueing Systems** (Message-Oriented Middleware or MOM), such as RabbitMQ, Apache Kafka, or AWS SQS.

1.  **Sender (Producer)**: Places a message into a specific queue maintained by the middleware.
2.  **Middleware Handler**: Stores the message safely on disk or in memory.
3.  **Receiver (Consumer)**: Whenever it is online or ready, it polls the queue and retrieves the message.

**Advantages**:
*   The sender and receiver do not need to be active at the same time.
*   Acts as a shock-absorber. If 10,000 requests hit the system at once, they queue up, and the receiver processes them at its own comfortable pace, preventing server crashes.

### 2.3 Publish-Subscribe (Pub/Sub)
A specialized form of message-oriented communication where the sender (Publisher) does not know who the receivers (Subscribers) are.
*   Publishers publish messages to a named "Topic" (e.g., `system.alerts.cpu`).
*   Any number of Subscribers can subscribe to that topic. The middleware ensures that all active subscribers receive a copy of the message. This broadcasts extremely well to massive, loosely-coupled architectures.

---

## 3. Preparing for Week 5
Understanding RPCs and Message Queues is essential. As we step into Week 5 (Containerization with Docker and Kubernetes), we will be taking these loosely coupled, network-communicating applications and packaging them into isolated microservices that orchestrate and load-balance these message queues at scale.
