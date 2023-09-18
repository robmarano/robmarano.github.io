# ECE 465 Fall 2023 Weekly Course Notes

[<- back to syllabus](./ece465-syllabus-fall-2023.md)

# Week 1

## Refresher of Computer Architecture

### The von Neumann (Princeton) Architecture for a Computer

THe combination of a central processing unit (CPU), computer memory, datapath, input, and output defines a modern computer. The purpose of any computer or computing devices is to process data with a desired set of instructions. The program contains the instructions and the data, or a refernece to where data is stored. The stored-program concept describes the fact instructions and data can be encoded into numbers and stored into memory. A von Neumann computer has a single memory which is generally segmented into a stack, a heap, and reserved sections, defined by the instruction set architecture of the computer's CPU. The stack section of the memory can be considered the scratch working area for programs (instructions & data). Every program that runs on the computer gets its own stack. The hardware of the computer does not perform this coordination. Rather the very first program that runs upon the computer's initial start (boot sequence from power-on state) coordinates programs to execute on the computer and manages the memory sections. A computer is designed to have as much memory that can be addressed by the number of bits defined by the CPU's bit width, which, in turn, defines the width of an operand of the CPU's compute engine, i.e., the arithmetic logic unit (ALU). For example, if you have a 32-bit, byte-addressable CPU, the bit width of an operand is defined to be 32 bits, which means the total addressable space is 2^32, or 4 gigabytes. However, you can have more memory available to you if the motherboard has been modified to allow for more addressable memory. The motherboard serves as the physical device that houses the CPU, memory, input and output connections. It provides interconnects and slots of the computer components.

## Centralized vs Decentralized vs Distributed

From our textbook:

The three-way distinction is one between _sufficiency_ and _necessity_ for spreading processes and resources across multiple computers. We take the standpoint that decentralization can never be a goal in itself, and that it should focus on the sufficiency for spreading processes and resources across computers. In principle, the less spreading, the better. Yet at the same time, we need to realize that spreading is sometimes truly necessary, as illustrated by the examples of decentralized systems.

Considering that distributed and decentralized systems are inherently complex, it is equally important to consider solutions that are as simple as possible.

- A _decentralized system_ is a networked computer system in which processes and resources are necessarily spread across multiple computers.
- A _distributed system_ is a networked computer system in which processes and resources are sufficiently spread across multiple computers.

_Centralized solutions_ are generally much simpler, and also simpler along different criteria. _Decentralization_, that is, the act of spreading the implementation of a service across multiple computers because we believe it is necessary, is a decision that needs to be **considered carefully**.

Distributed and decentralized solutions are inherently difficult:

- There are many, often unexpected, dependencies that hinder understand- ing the behavior of these systems.
- Distributed and decentralized systems suffer almost continuously from partial failures: some process or resource, somewhere at one of the participating computers, is not operating according to expectations.
- Many networked computer systems, participating nodes, processes, resources, and so on, come and go. This makes these systems highly dynamic, in turn requiring forms of automated management and maintenance, in turn increasing the complexity.
- Distributed and decentralized systems are networked, used by many users and applications, and often cross multiple administrative boundaries. As a result, they become particularly vulnerable to security attacks.

### Studying Distributed Systems

From our textbook:

Considering that distributed systems are inherently difficult, it is important to take a systematic approach toward studying them.

We look at distributed systems from a variety of limited perspectives:

1. **Architectual Perspective** &mdash; how various components of existing systems interact and depend on each other
2. **Process Perspective** &mdash; processes form the software foundation of distributed systems, covering the different forms of processes that occur in distributed systems, e.g., threads, virtualization of hardware processes, clients, servers, etc.
3. **Communications Perspective** &mdash;facilities that distributed systems provide to exchange data between processes.
4. **Coordination Perspective** &mdash; fundamental tasks that coordinate resources across distributed processes, e.g., clock time, access to resources, etc.
5. **Naming Perspective** &mdash; focuses entirely on resolving a name to the access point of the named entity/resource.
6. **Consistency and Replication Perspective** &mdash; focuses on the trade-offs between consistency, replication, and performance. A critical aspect of distributed systems is that they perform well in terms of efficiency and in terms of dependability. The key instrument for both aspects is replicating resources while keep copies consistent with the latest updates.
7. **Fault Tolerance Perspective** &mdash;how to effectively and efficiently handle partial failures. It has proven to be one of the toughest perspectives for understanding distributed systems, mainly because there are so many trade-offs to be made, and also because completely masking failures and their recovery is provably impossible.
8. **Security Perspective** &mdash; ensures authorized access to resources, effectively ensuring trust in distributed systems, along with authentication, namely verifying a claimed identity.

Just because it is possible to build distributed systems does not necessarily mean that it is a good idea. There are four important goals that should be met to make building a distributed system worth the effort. A distributed system should

1. **Resource Sharing** &mdash; make resources easily accessible & economical
2. **Distribution Transparency** &mdash; hide the fact that resources are distributed across a network
3. **Openness** &mdash; be open
4. **Dependability** &mdash; be dependable
5. **Security** &mdash; be secure
6. **Scalability** &mdash; be scalable

### Resource Sharing

From our textbook:

An important goal of a distributed system is to make it easy for users (and applications) to access and share remote resources. Resources can be virtually anything, but typical examples include peripherals, storage facilities, data, files, services, and networks, to name just a few. There are many reasons for wanting to share resources. One obvious reason is that of economics. For example, it is cheaper to have a single high-end reliable storage facility be shared than having to buy and maintain storage for each user separately. Seamless integration of resource-sharing facilities in a networked environ- ment is also now commonplace.

### Distribution Transparency

From our textbook:

An important goal of a distributed system is to hide the fact that its processes and resources are physically distributed across multiple computers, possibly separated by large distances. In other words, it tries to make the distribution of processes and resources transparent, that is, invisible, to end users and applications.

In essence, what applications get to see is the same interface everywhere, whereas behind that interface, where and how processes and resources are and how they are accessed is kept transparent.

There are different types of transparency:
(We use the term object to mean either a process or a resource.)

1. **Access Transparency** &mdash; hide differences in data representation and how an object is accessed
2. **Location Transparency** &mdash; hide where an object is located
3. **Relocation Transparency** &mdash; hide that an object may be moved to another location while in use
4. **Migration Transparency** &mdash; hide that an object may move to another location
5. **Replication Transparency** &mdash; hide that an object is replicated
6. **Concurrency Transparency** &mdash; hide that an object may be shared by several independent users
7. **Failure Transparency** &mdash; hide the failure and recovery of an object

The **degree of distribution transparency** is dictated by the distributed system's set of use cases it is designed to handle. Although distribution transparency is generally considered preferable for any distributed system, there are situations in which blindly attempting to hide all distribution aspects from users is not a good idea. The conclusion is that aiming for distribution transparency may be a nice goal when designing and implementing distributed systems, but that it should be considered together with other issues such as performance and comprehensibility. The price (economics) for achieving full transparency may be surprisingly high.

Note: A somewhat radical standpoint was taken by [Wams (2012)](https://research.vu.nl/en/publications/unified-messaging-atop-a-cloud-of-micro-objects) by stating that partial failures preclude relying on the successful execution of a remote service. If such reliability cannot be guaranteed, it is then best to always perform only local executions, leading to the copy-before-use principle. According to this principle, data can be accessed only after they have been transferred to the machine of the process wanting that data. Moreover, modifying a data item should not be done. Instead, it can only be updated to a new version. It is not difficult to imagine that many other problems will surface. However, Wams shows that many existing applications can be retrofitted to this alternative approach without sacrificing functionality.

### Openness

From our textbook:

An open distributed system is essentially a system that offers components that can easily be used by, or integrated into other systems. At the same time, an open distributed system itself will often consist of components that originate from elsewhere.

Openness involves _interoperability_, _composability_, and _extensibility_.

Interoperability characterizes the extent by which two implementations of systems or components from different software providers can co-exist and work together by merely relying on each other's services as specified by the interface definition's common standard.

Portability means to what extent an application developed for a distributed system A can be executed, without modification, on a different distributed system B; both A and B implement the same interfaces.

Extensibility characterizes an open distributed system that would allow for relative ease to add additional functionality and replace functionality with other implementations that satisfy its respective interface definitions. Another important goal for an open distributed system is that is should be easy to build and configure the system out of different components, or parts, even from different software providers or vendors. Moreover, it should be easy to add new components or replace existing ones that adhere to its respective interface definitions without affecting those components that stay in place. T

To be open means that components should adhere to standard rules that describe the syntax and semantics of what those components have to offer (i.e., which service they provide). A general approach is to define services through interfaces using an **Interface Definition Language** (**IDL**).

See Wikipedia's definition [link](https://en.wikipedia.org/wiki/Interface_description_language):

> **IDL** is a generic term for a language that lets a program or object written in one language communicate with another program written in an unknown language. IDLs are usually used to describe data types and interfaces in a language-independent way, for example, between those written in C++ and those written in Java.
>
> IDLs are commonly used in remote procedure call software. In these cases the machines at either end of the link may be using different operating systems and computer languages. IDLs offer a bridge between the two different systems.

If properly specified, an _interface definition_ allows any process that needs a certain functionality provided by the published interface to communicate to another process (on same computer or over the network to another one running on a different computer node) that provides that interface. At the interface definition level, all process which supply the interface may have differing implementations, thus possibly different performance profiles.

Proper specifications of interface definitions are complete and neutral, but many of these interface definitions may not be complete, leaving decisions on implementation and "filling in the blanks" are left to the software engineers building the process.

#### Separating policy from mechanism

Open distributed systems become flexible when the system is designed and organized as a set of relatively small, easily replaceable/adaptable components, in other words, small, loosely coupled components. The interface definitions provide the coupling. Many older and even some contemporary systems have been constructed using a monolithic approach in which components are logically separated but implemented as one, large program. This approach increases difficulty to replace or to adapt a component without affecting the entire system. Therefore, monolithic systems tend to be closed instead of open.

What is needed is a separation of _policy_ and of _mechanism_. As the old adage goes, the only constant is change. The need for changing a distributed system often results from a component requiring an update or replacement in order to provide the optimal policy for a specific application use case. Policy updates should be loosely coupled to the system. However, there is an important trade-off to consider. The stricter the separation, the more a distributed systems designer and developer needs to ensure they offer appropriate collection of mechanisms. Strict separation of policies and mechanisms my lead to highly complex configuration problems.

One option to ease these configuration problems is to provide reasonable defaults. This is the usual situation in practice. An alternative, more complex approach is to have the system observe usage and dynamically change parameter settings, resulting in a _self-configurable system_. Note, hard-coding policies into a distributed system may reduce complexity considerably but at the price of less flexibility.

### Dependability

From our textbook:

Dependability refers to the degree that a computer system can be relied upon to operate as expected. Dependability in distributed systems can be rather intricate as compared to single-computer systems due to **partial failure**. A partial failure means a part of the distributed system does not operate as designed even though the whole system seems to be operating as expected up to a certain point. The issue with partial failures across a distributed system is that these anomalies' impact add up, like small holes in a large boat; left unmanaged, the boat will sink. One should assume that at any time in a distributed system, there are always partial failures occurring. An **important goal** of distributed systems is to make these failures and mask the recovery from those failures. This masking is the essence of being able to tolerate failures, referred as "fault tolerance."

#### Baseic concepts of dependendability

Dependability covers many useful requirements in distributed systems design, including the following:

1. availability
2. reliability
3. safety
4. maintainability

**Availability** is the property that a system is ready to be used immediately, right now. A highly available is one that will most likely be working at any given **instant time**, not necessarily in a range of time. Availability is usually specificed as a percentage; for example, if a distributed system has an availability of 99.999% then is has a maximum downtime of 5 minutes and 15.6 seconds considered over any given entire year. Availability, as a measure of the amount of time the system has been up (aka uptime), can be calculated as follows:

```
Percentage of availability = (total elapsed time – sum of downtime)/total elapsed time
```

See [availability table](https://sre.google/sre-book/availability-table/) in [Google's Site Reliability](https://sre.google/) web site.

**Reliability** is the property that a system can run **continuously** without failure. In contrast with a system's property of availability, reliability is defined in terms of a **time interval** instead of an _instant in time_. A highly reliable system is one that will most likely continue to work without interruption during a relatively **long** period of time. This is a subtle but important difference when compared to availability; for example, for an availability of 99.999%, the system may or not be reliable. Covered below, metrics such as "mean time to failure" and "mean time between failures" define reliability in numerical terms.

[Helpful discussion on Availability and Reliability for distributed applications.](https://www.pagerduty.com/resources/learn/reliability/)

**Safety** is the property that when a system temporarily fails to operate as expected no catastrophic event happens. This property is very important for distributed systems that deal with human and property safety, e.g., medical devices, nuclear power plants, air travel, space travel, and many more. Read the story of the [Therac-25 as one of the most infamous examples of how software faults may harm human life](https://hackaday.com/2015/10/26/killed-by-a-machine-the-therac-25/).

**Maintainability** is the property of how easily a fault in a system can be repaired. A highly maintainable system may also exhibit a high degree of availability, especially if failures can be detected and repaired automatically. However, automatic recovery is easier said than done. Traditionally, the ability of a system to tolerate faults (fault tolerant) has been related to the following statistical metrics:

1. **Mean Time To Failure** (MTTF) &mdash; the avereage time until a component fails
2. **Mean Time To Repair** (MTTR) &mdash; the average time needed to repair a component
3. **Mean Time Between Failures** (MTBF) &mdash; MTTF + MTTR

These metrics make sense only if we have an accurate notion of what a failure actually is. as seen in our textbook's Chapter 8, identifying the occurrence of a failure may actually not be so obvious.

#### Faults, errors, failures

A system is said to **fail** when it cannot meet its promises (expected behavior). An **error** is a part of a system's overall state, and it may lead to a **failure**. The cause of an error is called a **fault**. Building dependable systems closely relates to controlling faults. A distinction can be made between preventing, tolerating, removing, and forecasting faults. For distributed systems design, the most important issue is **fault tolerance**, meaning the system can provide its services even in the presence of faults. For example, consider a system that depends upon a network connection that experiences errors in transmission for whatever reason. By comparmentalizing the design of the network connection service, one can implement error-correcting codes for transmitting packets. At the lower level, which is loosely coupled to the higher-level functionality, the system can tolerate, to a certain extent, relatively poor transmission lines, thus reducing the probability that an error (a damaged packet) may lead to a failure.

A distributed system by design provides its users with several services. The distributed system fails when one or more of those services cannot be (completely) provided.

Faults are generally categorized as follows:

1. transient fault
2. intermittent fault
3. permanent fault

\*_Transient_ faults are those that occur once and then disappear; for example, if a tranmission between two nodes times out and is retried, it will probably work the second time.

**Intermittent** fault are those that occur, then vanishes on its own, then reappears, continuing in this manner; for example, a loose contact on a connector will often cause an intermittent fault. This type of faults usually are very hard to diagnose.

**Permanent** faults are those that continue until the component causing the root cause is replaced; for example, software bugs and burnt-out ICs.

### Security

From our textbook:

Dependable systems provide security, especially in terms of confidentiality and integrity.

**Confidentiality** is the property that only authorized parties (human, machine/process) have access to the protected information assets and protected resources.

**Integrity** is the property that only authorized parties (human, machine/process) can change the protected information and protected resources.

The fundamental components of the security of any system are **authentication** of requesting entities (users or processes); **authorization** of such requests on the protected information and protected resources; and **audit** of the records of each authentication and authorization request and response.

> > Review Chapter 1's section 1.2.5 on the key elements of security, e.g., cryptography etc.

### Scalability

## Concurrent Execution & Programming Concurrency

### Process & Multiprocessing

#### What is a Program?

A computer program is a collection of data and of instructions which process the collection of data. Von Neumann's "[stored program concept](https://en.wikipedia.org/wiki/Stored-program_computer)" states that instructions and data can be represented or encoded into (binary) numbers so that binary logic (computer hardware) can execute the instructions and thereby process the data.

#### What is a [Process](<https://en.wikipedia.org/wiki/Process_(computing)>)?

A process executes the program on the von Neumann computer (CPU+memory+datapath+input+output). Consequently, the process "comprises program code, assigned system resources, physical and logical access permissions, and data structures to initiate, control and coordinate execution activity."

A process has its own memory stack within the main memory to store it's own data that is not global in nature, as well as registers, file handles, signals, and much more.

Modern operating systems further divide the computing aspects of a program to more granular compute artifacts called _threads_.

#### What is a [Thread](<https://en.wikipedia.org/wiki/Thread_(computing)>)?

Quote from (Introduction to Embedded Systems)[https://ptolemy.berkeley.edu/books/leeseshia/]:
"Threads are imperative programs that run concurrently and share a memory space. They can access each others’ variables. Many practitioners in the field use the term “threads” more narrowly to refer to particular ways of constructing programs that share memory, [others] to broadly refer to any mechanism where imperative programs run concurrently and share memory. In this broad sense, threads exist in the form of interrupts on almost all microprocessors, even without any operating system at all (bare iron)."

Another good [reference](https://randu.org/tutorials/threads/)

#### What is Uni-processing vs. Multi-processing?

Uni-processing means a computer operates with one CPU. Multi-processing means a computer operates with more than one CPU, usually with one set of memory shared between the CPUs.

### Flynn's Taxonomy

See [Wikipedia's entry](https://en.wikipedia.org/wiki/Flynn%27s_taxonomy).
We will use "I" for instruction instead of "P" for program. Michael Flynn's [original publication](https://ieeexplore.ieee.org/document/1447203).

1. Single Instruction Single Data &mdash; SISD
2. Single Instruction Multiple Data &mdash; SIMD
3. Multiple Instruction Single Data &mdash; MISD
4. Multiple Instruction Multiple Data &mdash; MIMD

#### SISD

A sequential computer which exploits no parallelism in either the instruction or data streams. Single control unit (CU) fetches a single instruction stream (IS) from memory. The CU then generates appropriate control signals to direct a single processing element (PE) to operate on a single data stream (DS) i.e., one operation at a time.

Examples of SISD architectures are the traditional uniprocessor machines like older personal computers (PCs) (by 2010, many PCs had multiple cores) and mainframe computers.

#### SIMD

A single instruction is simultaneously applied to multiple different data streams. Instructions can be executed sequentially, such as by pipelining, or in parallel by multiple functional units.

#### MISD

Multiple instructions operate on one data stream. This is an uncommon architecture which is generally used for fault tolerance. Heterogeneous systems operate on the same data stream and must agree on the result.

#### MIMD

Multiple autonomous processors simultaneously executing different instructions on different data. MIMD architectures include multi-core superscalar processors, and distributed systems, using either one shared memory space or a distributed memory space.

### Task & Multitasking

### Thread & Multithreading

### Have you heard of these?

Parallel processing

Concurrent processing

...

# Week 15
