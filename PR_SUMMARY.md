# ECE 465 Week 12 `k8s_dist_histo_secured` Security Module

## Objective
Migrated the Week 11 Fault Tolerance sandbox into a hardened Week 12 module (`k8s_dist_histo_secured`) to demonstrate Confidentiality, Integrity, and Availability. Authored the Week 12 Curriculum Notes based on the textbook's Chapter 9.

## Implementation Details
*   **Secure Channels (TLS)**: Upgraded Flask and SocketIO to serve exclusively over HTTPS via dynamic self-signed adhoc certificates.
*   **API Authentication**: Injected a mandatory Bearer Token validation layer into the `/upload` endpoint to defend against DoS.
*   **Access Control Lists (ACL)**: Hardened ZooKeeper by switching Kazoo to Digest Authentication, restricting ZNode creation exclusively to authorized users to prevent MapReduce hijacking.
*   **SecOps Observability**: Rebranded the UI to a SecOps Dashboard that actively listens for `SECURITY_VIOLATION` websockets, instantly highlighting invalid API requests to the user in bright red.
*   **Curriculum Mapping**: Authored `notes_week_12.md` detailing the CIA Triad and Cryptography, mapping the textbook theory directly to the Python/YAML code executed in the sandbox.
