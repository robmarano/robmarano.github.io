# Week 7: Integrating Application to Infrastructure (Middleware)

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2026.html)

**Objective**: In this session, we explore the bridge between high-level application code (like our Python Map-Reduce algorithms) and the underlying distributed infrastructure (OS, containers, and networks). This bridging layer is called **Middleware**.

## 1. The Role of Middleware

In a distributed system, applications are spread across multiple machines, running potentially different operating systems, and written in different languages. **Middleware** is the software layer that logically resides above the operating systems and below the applications to provide a **single-system image**. 

Instead of an application developer manually opening TCP sockets and worrying about endianness, lost packets, or finding the IP address of a target server, the middleware abstracts these infrastructure details away.

### Core Goals of Middleware:
1. **Distribution Transparency**: Hiding the fact that resources are network-bound.
2. **Interoperability**: Allowing C++ programs on Linux to communicate with Java programs on Windows.
3. **Modifiability & Adaptability**: Allowing the system configuration to change (e.g., adding more servers) without rewriting the application code.

---

## 2. Integration Techniques

To integrate applications into infrastructure seamlessly, middleware employs several architectural tricks.

### 2.1 Wrappers and Adapters
A **wrapper** (or adapter) is a piece of software that offers an interface to a component so that it looks exactly like another interface. This is crucial for integrating legacy applications into modern cloud-native systems without modifying the legacy source code.

*Example*: Imagine an old main-frame database that only accepts custom binary commands. You can build a REST-API Wrapper around it. Modern web applications send standard HTTP JSON requests to the Wrapper, which translates them into the binary format for the database.

### 2.2 Interceptors
**Interceptors** allow middleware to break the normal flow of execution (like an RPC call) and insert custom infrastructure logic (like logging, authentication, or load balancing), without the application knowing.

*Example*: When a Python microservice calls `database.get_user()`, an interceptor intercepts the call, checks a Redis cache first, and if found, returns the data immediately. The application logic is completely unaware of the caching infrastructure.

### 2.3 Remote Procedure Calls (RPC)
RPC is the oldest and most fundamental integration middleware. It makes a call to a function running on a remote server look exactly like a local function call. Under the hood, the middleware "stub" serializes the parameters, opens the socket, sends the network request, receives the response, and hands it back to the program.

*Example*: gRPC (built by Google) uses Protocol Buffers to serialize data efficiently and operates over HTTP/2, acting as a high-performance modern middleware.

---

## 3. Deployment Integration

Today, the "Infrastructure" heavily implies Container Orchestration (like Kubernetes). How does an application integrate into K8s?

1. **Service Meshes**: A modern form of middleware (e.g., Istio, Linkerd). It runs as a "sidecar" proxy container next to your application container. Your application simply makes an HTTP request to `localhost:8080`, and the sidecar intercepts it, encrypts it, routes it to the correct remote server, and handles retries.
2. **Environment Variables & ConfigMaps**: Applications are designed to be stateless and configurable. Infrastructure injects settings (like database passwords) into the application via the environment, fully decoupling the code from the deployment.

---

## 4. Design & Implementation Exercises

These exercises build directly upon the **Distributed Image Processor** covered in Week 5 (Containerization) and the **GitOps Pipeline** in Week 6 (CI/CD). 

### Exercise 7A (Easy): API Gateway Wrapper
**Scenario**: Users are currently accessing the Image Processor API directly across different microservice ports.
**Task**: Implement an API Gateway (using Nginx or a lightweight Python Flask app) acting as a **Wrapper**. The Gateway should listen on a single port (e.g., `80`) and route `/api/upload` requests to the Upload Microservice and `/api/status` requests to the Status Microservice. Do this without modifying the Week 5 Python code.

### Exercise 7B (Medium): Request Interceptor (Auth & Rate Limiting)
**Scenario**: The Image Processor is public, and malicious bots are flooding the system with massive 4K images, exhausting our Kubernetes cluster resources.
**Task**: Write an **Interceptor** middleware (in Python or injected via an Envoy sidecar proxy).
1. The interceptor must check a dummy API key in the request header `X-API-KEY`.
2. Implement a rate limit of 5 image uploads per minute per API key.
3. If the limit is exceeded, the middleware must instantly return an HTTP 429 Too Many Requests status without ever waking up the backend Image Processor containers.

### Exercise 7C (Hard): Custom Service Mesh (Client-Side Load Balancing)
**Scenario**: Instead of relying on Kubernetes to load balance the internal worker pods, we want to construct a native RPC smart-client.
**Task**: Modify the Week 5 image "Distributor" component to act as its own middleware.
1. Have the Distributor query a simple registry (e.g., a text file or Redis key) to discover the IP addresses of all currently active `Image-Worker` containers.
2. Implement a Round-Robin or Least-Connections algorithm directly inside the Distributor's python code to dispatch the image processing RPC tasks.
3. Hook this new logic into your Week 6 CI/CD pipeline so it builds and deploys automatically upon a Git push.
