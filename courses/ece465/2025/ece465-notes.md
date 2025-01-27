# ECE 465 Spring 2025 Weekly Course Notes

[<- back to syllabus](../ece465-ind-study-syllabus-spring-2025.html)

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

# <a id="week01">Week 01 &mdash; Centralized vs distributed</a>

## Topics

- Centralized computing and storage systems
- Distributed computing and storage systems
- Assessing centralized vs distributed systems along key feature characteristics
  - Architecture
  - Scalability
  - Fault tolerance
  - Complexity
  - Cost
  - Data Management
  - Security

### Table contrasting between centralized and distributed systems.

|             Feature | Centralized Systems           | Distributed Systems                                       |
| ------------------: | :---------------------------- | :-------------------------------------------------------- |
|    **Architecture** | Single process or machine     | Multiple processes or interconnected machines             |
|     **Scalability** | Limited                       | High                                                      |
| **Fault tolerance** | Low                           | High                                                      |
|      **Complexity** | Low                           | High                                                      |
|            **Cost** | Can be lower initially        | Can be higher initially, but more cost-effective at scale |
| **Data Management** | Simpler                       | More complex                                              |
|        **Security** | Single point of vulnerability | Multiple points of vulnerability                          |

## Software Installation

Setup your computer for this class

1. Install Java 21 Development Kit (JDK); I prefer [Amazon's Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html)
2. Install [Apache Maven](https://maven.apache.org/download.cgi)
3. Install the following integrated development environment ([Jetbrains IntelliJ](https://www.jetbrains.com/community/education/#students) - get full version with your student email; Visual Code)
4. Install the following systems: [Docker Desktop](https://www.docker.com/get-started/); [Minikube (Kubernetes cluster for your computer)](https://minikube.sigs.k8s.io/docs/); [Helm](https://helm.sh/)

## Homework Assignment

1. Review our independent study [our course's syllabus](./ece465-ind-study-syllabus-spring-2025.html). This course is to learn theory and immediately put it into practice building a distributed application (cloud service).
2. Read ["Basic Concepts You Need to Know about Building Large-Scale Distributed Systems"](https://archive.is/6rS63)
3. Read ["The Free Lunch Is Over: A Fundamental Turn Toward Concurrency in Software"](https://archive.is/oI2g0)
4. Sign up for the [free electronic copy of the textbook "Distributed Systems - 4th Edition"](https://www.distributed-systems.net/index.php/books/ds4/ds4-ebook/) by van Steen and Tanenbaum
5. Read Chapter 1 of the textbook, pay close attention to the design goals.
