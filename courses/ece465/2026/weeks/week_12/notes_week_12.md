# Week 12: Security in Distributed Systems

## 1. Introduction: The CIA Triad
In distributed architectures, fault tolerance ensures the system survives accidental failures (like crashes or network partitions). However, **Security** ensures the system survives *malicious, intentional attacks*. 

According to Chapter 9 of the textbook, any secure distributed system must guarantee three properties, known as the **CIA Triad**:
*   **Confidentiality**: Ensuring data is exposed *only* to authorized entities. If a packet is intercepted over the network, it must be unreadable to the attacker.
*   **Integrity**: Ensuring data has not been secretly tampered with. If an attacker modifies a packet in transit, the receiver must be able to mathematically prove the tampering occurred.
*   **Availability**: Ensuring the system remains usable for legitimate users. We defend against Denial of Service (DoS) attacks that attempt to artificially trigger fault-tolerance overloads.

---

## 2. Cryptography & Secure Channels

To achieve Confidentiality and Integrity over untrusted networks (like the open Internet), we must establish **Secure Channels**. 

### Symmetric vs. Asymmetric Cryptography
*   **Symmetric Cryptography**: Both the sender and receiver use the exact same secret key to encrypt and decrypt the message. (e.g., AES-256). It is blazingly fast but suffers from the **Key Distribution Problem**: How do we safely hand the secret key to the receiver over an untrusted network?
*   **Asymmetric Cryptography (Public-Key)**: Every node has two mathematically linked keys: a **Public Key** (shared with everyone) and a **Private Key** (kept absolutely secret). If Alice wants to send a secure message to Bob, Alice encrypts the message using *Bob's Public Key*. Now, the *only* mathematical way to decrypt the message is by using *Bob's Private Key*. (e.g., RSA).

### The SSL/TLS Handshake
Modern Secure Channels (like HTTPS) combine both. They use Asymmetric Cryptography to securely swap a temporary Symmetric Key, and then switch to the faster Symmetric Key for the rest of the connection.

---

## 3. Access Control: Authentication vs. Authorization

Once a Secure Channel is established, the server must decide if the client is allowed to execute the requested action.

*   **Authentication**: Proving *who* you are. 
    *   *Example:* "I am Alice. Here is my password or API Token to prove it."
*   **Authorization**: Proving *what* you are allowed to do.
    *   *Example:* "Alice is authenticated. But is Alice allowed to delete the database?" This is usually enforced via **Access Control Lists (ACLs)** or Role-Based Access Control (RBAC).

---

## 4. Live Project: Securing `k8s_dist_histo_secured`

This week, we migrated our sandbox into `k8s_dist_histo_secured`. We took the theoretical textbook concepts and hard-coded them into the Python and Kubernetes layers.

### Design-to-Code Mapping 1: Confidentiality via HTTPS (Secure Channels)
**Theoretical Spec:** All communication between the Web UI and the Flask Master node must be encrypted to prevent packet sniffing.
**Code Implementation:** We upgraded the SocketIO/Flask web server to enforce TLS via an `adhoc` self-signed certificate.

```python
# Inside app.py
if __name__ == '__main__':
    # ...
    # TLS encryption using self-signed adhoc certificates
    socketio.run(app, host='0.0.0.0', port=5000, ssl_context='adhoc')
```

### Design-to-Code Mapping 2: API Token Authentication
**Theoretical Spec:** The MapReduce Engine is computationally expensive. We must protect the `/upload` API endpoint from unauthorized requests that could overload the cluster (DoS).
**Code Implementation:** We injected a mandatory **Bearer Token** check into the Flask HTTP POST route.

```python
# Inside app.py
@app.route('/upload', methods=['POST'])
def upload_file():
    # SecOps Authentication Check
    auth_header = request.headers.get('Authorization')
    if auth_header != f"Bearer {API_TOKEN}":
        logger.warning(f"Unauthorized API access blocked from {request.remote_addr}")
        # Emit an Intrusion alert to the SecOps Dashboard
        socketio.emit('secops', {"event": f"Intrusion Attempt Blocked: Invalid API Token from {request.remote_addr}", "severity": "CRITICAL", "pod": POD_NAME})
        return jsonify({"error": "Unauthorized Access"}), 401
```
*In `templates/index.html`, the Javascript `fetch` call was updated to inject this exact token into the HTTP Headers.*

### Design-to-Code Mapping 3: Kazoo Digest ACL Authorization
**Theoretical Spec:** ZooKeeper ZNodes represent distributed locks. A malicious pod inside the cluster could artificially delete or modify `/jobs` nodes, collapsing the engine. We must restrict node creation/modification exclusively to authenticated Kazoo clients.
**Code Implementation:** We upgraded the `KazooClient` connection to use Digest Authentication. We defined an `ACL` that only grants permissions to the `app_user:secure_password` identity.

```python
# Inside app.py
from kazoo.security import make_digest_acl

# Kazoo Client setup
zk = KazooClient(hosts=ZK_HOSTS, timeout=60.0)

# Digest Authentication
zk.add_auth('digest', f'{ZK_USER}:{ZK_PASS}')

# Define the Access Control List: Only this user gets full access
secure_acl = [make_digest_acl(ZK_USER, ZK_PASS, all=True)]

# Apply the ACL to the physical ZooKeeper Nodes upon creation
zk.create(f"/nodes/{POD_NAME}", ephemeral=True, makepath=True, acl=secure_acl)
```

---

## 5. SecOps Chaos: Hacking the Sandbox

You can observe the Security Architecture actively defending the system using the new **🛡️ SecOps Observability Dashboard** in the Web UI.

1. **Deploy the Cluster:**
   ```bash
   eval $(minikube docker-env)
   docker build -t zk-app-secure:latest .
   kubectl apply -f k8s/
   ```
2. **Access the HTTPS UI:**
   Navigate to `https://<minikube-ip>:30000` (You will need to accept the browser's "unsafe" warning because we used a self-signed `adhoc` certificate).
3. **Simulate an Intrusion:**
   Open `templates/index.html` in your local IDE, and intentionally break the Javascript token:
   ```javascript
   // Change this line to an invalid token:
   'Authorization': 'Bearer HACKER-TOKEN-123'
   ```
   Save the file, rebuild the docker image, and apply. When you try to upload an image, watch the **SecOps Dashboard** light up with a red **🚨 Intrusion Attempt Blocked** alert broadcast directly from the Python backend!
