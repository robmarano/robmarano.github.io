# ECE 465 Spring 2025 Weekly Course Notes

[<- back to syllabus](./ece465-ind-study-syllabus-spring-2025.html)

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

# <a id="week05">Week 05 &mdash; Multi-processing & network programming</a>

## Topics

1. Network Programming

## Deep Dive into Topics

### Network Programming

Chapter 4 of "Distributed Systems" addresses communication protocols and models crucial for distributed systems [1]. It emphasizes structuring protocols into layers and explores communication models such as Remote Procedure Call (RPC) and Message-Oriented Middleware (MOM). The chapter also discusses multicasting [1].

Key areas covered include:

Foundations of Communication: The chapter explains the importance of communication in distributed systems, highlighting the need for processes to adhere to protocols [1, 2]. It references the OSI model, which divides communication into seven layers, each offering specific services to the layer above [3]. The physical layer focuses on transmitting bits, while the data link layer deals with error-free transmission [4]. The network layer handles routing, and the transport layer provides reliable data transfer [4].
Types of Communication: It distinguishes between connection-oriented and connectionless services [3]. The chapter also categorizes communication based on synchronization (synchronous vs. asynchronous) and persistence (persistent vs. transient) [5].
Remote Procedure Call (RPC): RPC aims to hide the intricacies of message passing and is suited for client-server applications [1]. The steps involved in RPC execution include client stub activation, message construction, message transmission, server stub activation, procedure execution, and result return [6]. The chapter also mentions asynchronous RPCs, where the client continues processing without waiting for immediate results, using callbacks for later notification [7]. Multicast RPC is introduced as sending an RPC request to a group of servers [8].
Message-Oriented Communication: This section discusses sockets as communication endpoints for applications [9]. It explains message-queuing systems, including the Advanced Message Queuing Protocol (AMQP), emphasizing loose coupling where senders and receivers don't need to be active simultaneously [10].
Multicast Communication: The chapter covers sending data to multiple receivers [1]. It discusses application-level tree-based multicasting, flooding-based multicasting, and gossip-based data dissemination [11]. Application-level multicasting involves constructing an overlay network for efficient data distribution, but the selection of participating nodes might not consider performance metrics [12]. Gossip-based dissemination relies on epidemic behavior for information propagation, lacking a central coordination component [13].
Gossip-based data dissemination: This approach uses epidemic behavior to rapidly spread information among a large collection of nodes using only local information [13].
