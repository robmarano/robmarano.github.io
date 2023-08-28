# ECE 465 - Cloud Computing (Ind Study)

## General Course Information

Instructor: Prof. Rob Marano  
Email: rob@cooper.edu  
Semester of the course: Fall 2023  
Dates of the course: 28 Aug 2023 – 15 Dec 2023 (15 sessions)
Room: NAB 306 @ 6:00-8:50pm ET

_Note for Fall 2023, this course runs as an independent study._

"**Cloud computing** &mdash; the phenomenon by which services are provided by huge collections of remote servers." <br>
&mdash; Andrew Tanenbaum & Maarten van Steen

[Weekly course notes](./ece465-notes.md)

## Course Catalog Description

From the catalog: <br>
"Critical, foundational technology components that enable cloud computing, and the engineering advancements that have led to today’s ecosystem. Students design, build and test representational software units that implement different distributed computing components. Multi-threaded programming in Java. Functional programming (MapReduce). Hadoop: a programmer’s perspective; building and configuring clusters; Flume as an input engine to collect data; Mahout as a machine learning system to perform categorization, classification and recommendation; Zookeeper for systems coordination." <br>
_Note: We will update course catalog description to focus on topic vs software implementation._

From the instructor: <br>
You will dive deep, with hands-on approach, to study and implement critical, foundational technology components that enable distributed (cloud) computing, and the engineering advancements that have led to today’s thriving cloud computing ecosystem. Students will understand, design, build and test representational software units that implement different distributed components, e.g., concurrent logic execution that uses software-defined communications, compute, storage, and security. Distributed computing topics include multi-threaded programming; architecture designs; communication designs; coordination; naming; consistency & replication; fault tolerance; and security.

You will be introduced to many of the system design tenets used in the operation of large-scale distributed systems operated by modern commercial cloud computing providers (hyperscalers), e.g., Amazon Web Services, Microsoft Azure, and Google Cloud Platform. These tenets include reliability; scalability; availability; fault tolerance; data replication; caching; consistency; partition tolerance; load balancing; asynchronous communications; instrumentation; and monitoring.

This course prepares the student with foundational knowledge and experience to prepare for modern cloud computing software design and development professions and academic research.

3 credits. 3 hours per week (45 total hours).

## Course Prerequisites

Minimum ECE 251 and ECE 264, or approval of EE Department Chair.

### Course Structure/Method

**Lectures and Live Coding Labs:** This class meets from 6:00-8:50pm ET on the following days: 8/28, 9/11, 9/18, 9/25, 10/2, 10/9, 10/16, 10/23, 10/30, 11/6, 11/13, 11/20, 11/27, 12/4, and 12/11, for a total of 15 sessions. I encourage each of you to schedule office hours with me. Once appointment is confirmed, we will meet either in person in the Engineering Adjunct's Office on the 2nd floor of the NAB at 41 Cooper Square or remotely using Microsoft Teams video call.

_Anticipated Schedule_

|            Dates | Topic                                                       |
| ---------------: | :---------------------------------------------------------- |
|             8/28 | Introduction & dev env setup                                |
| 9/11, 9/18, 9/25 | Multi-processing & network programming                      |
|             10/2 | Distributed Architectures                                   |
|             10/9 | Communication                                               |
|            10/16 | Coordination                                                |
|            10/23 | Consistency & Replication                                   |
|            10/30 | Fault Tolerance                                             |
|             11/6 | Security                                                    |
|            11/13 | DevOps; Integrate designs - Iteration 1                     |
|            11/20 | DevOps; Integrate designs - Iteration 2                     |
|            11/27 | Deploying on a hyperscaler; Integrate designs - Iteration 3 |
|             12/4 | Deploying on a hyperscaler; Integrate designs - Iteration 4 |
|            12/11 | Last tidbits and guidance; Integrate designs - Iteration 5  |
|            12/15 | Final individual projects due                               |

## Course Learning Outcomes

Given that it's possible to build distributed systems, it does not always mean that it's a good idea.

A distributed system's design goals; it should

1. make resources easily accessible &mdash; Resource Sharing
2. mask the fact these resources are distributed across a network &mdash; Distribution Transparency
3. be open, offering components that can be easily used by or integrated into other systems &mdash; Openness
4. scale up and down based upon use &mdash; Scalability

Upon successful completion of this course, you will be able to understand the design goals that make building a distributed (cloud) system worth all the effort:

1. Learning how to scale program logic from a uniprocessor to a multi-processor to networked nodes
1. Understanding the core concepts of distributed systems as well as trade-offs, such as how multiple machines work together to solve problems in an efficient, reliable, and scalable manner
1. Applying knowledge of distributed systems techniques and methodologies
1. Gaining experience in the design and development of distributed systems and applications
1. Understanding how independent network and machine failure can make reliable distributed systems difficult to achieve
1. Understanding the core concepts in distributed computing, such as logical clocks, consistent cuts, consensus, replication, and fault tolerance

## Communication Policy

The best way to contact me is first by a short summary via chat on Microsoft Teams followed immediately by a detailed email to <code>rob.marano@cooper.edu</code>. I will do my best to respond within 24 hours. Communication and participation in class is not only encouraged, but required. I seek to understand your individual understanding of the material each class. Advocate for yourself, early and often.

## Course Expectations

### Class Preparation

Each session will consist of two components: discussion and in-class lab work on your computers. Come prepared with your laptop and the Linux environment. See the "Software" section below.

Each class discussion consists of a mix of lectures, programming examples, and question-driven group analysis of one or more large programming problems. Lab will consist of either group or individual work on exercises or projects. Questions arising during lab may be used to fuel additional discussion as time permits.

### Attendance

Success as a student begins with attendance. Class time serves not only for learning new concepts and skills but also for practicing what you have learned with active feedback. Some assignments and demos may be completed in class, but practice and study are required outside of class. Students are expected to attend classes regularly, arrive on time, and participate. I take attendance during every session, and it forms part of your grade. Students are encouraged to e-mail me when they are absent. Students are responsible for all academic work missed as a result of absences. It is at my discretion to work with students outside of class time in order to make-up any missed work.

## Materials

### Reference Books

To understand the journey of distributed systems (that lead to today's current implementation called "The Cloud" - hence "cloud computing"):

- Tanenbaum, Andrew, and Maarten van Steen.<u>Distributed Systems, 4th ed</u>. Upper Saddle River, NJ: Prentice Hall, 2023. ISBN: 9789081540636. Get your official electronic copy [here](https://www.distributed-systems.net/index.php/books/ds4/ds4-ebook/)

We will be using other resources available on the Internet for our course. These will be shared throughout the semester based upon covered topics and assignments.

With that said, the following books provide helpful and historical background for our course and may help with programming. None are required.

- Stevens, W. Richard, Bill Fenner, and Andrew M. Rudoff. <u>UNIX Network Programming, Vol. 1: The Sockets Networking API. 3rd ed</u>. Reading, MA: Addison-Wesley Professional, 2003. ISBN: 9780131411555.

- Tanenbaum, Andrew. <u>Modern Operating Systems. 2nd ed</u>. Upper Saddle River, NJ: Prentice Hall, 2001. ISBN: 9780130313584.

- McKusick, Marshall Kirk, Keith Bostic, Michael J. Karels, and John S. Quarterman. <u>The Design and Implementation of the 4.4 BSD Operating System</u>. Reading, MA: Addison-Wesley Professional, 1996. ISBN: 9780201549799.

- Stevens, W. Richard, and Stephen Rago. <u>Advanced Programming in the UNIX Environment. 2nd ed</u>. Reading, MA: Addison-Wesley Professional, 2005. ISBN: 9780201433074.

### Software

You run your distributed systems development environment in Linux, which can be operated natively or within a virtual machine using VirtualBox, Vagrant, or Docker, for example. At a minimum, you'll need a terminal emulator running the Bash shell, Java 18 or higher with Maven, and git installed.

All software used during this course will be open source-based. We will also be using Amazon Web Services through the AWS Academy site of which Cooper Union has been given access. For many of our programming assignments, the Java programming language will be used, especially since this language is one of the most used ones for implementing modern cloud services given its portability across CPU instruction set architectures.

## Assessment Strategy and Grading Policy

All assignments and the individual final project per student must be completed by the end of this course. Programming assignments and the projects will be handed-in individually via GitHub.

| Assignment | Title         | Points | Given On | Due Date | Link to Solution |
| ---------: | :------------ | :----: | :------- | :------- | :--------------- |
|          1 | Program 1     |   10   | 8/28     | 9/11     | TBD              |
|          2 | Program 2     |   10   | 9/11     | 9/18     | TBD              |
|          3 | Program 3     |   10   | 9/18     | 9/25     | TBD              |
|          4 | Program 4     |   10   | 9/25     | 10/2     | TBD              |
|          5 | Program 5     |   10   | 10/2     | 10/9     | TBD              |
|          6 | Program 6     |   10   | 10/9     | 10/16    | TBD              |
|          7 | Program 7     |   10   | 10/16    | 10/23    | TBD              |
|          8 | Program 8     |   10   | 10/23    | 10/30    | TBD              |
|          9 | Program 9     |   10   | 10/30    | 11/6     | TBD              |
|         10 | Program 10    |   10   | 11/6     | 11/13    | TBD              |
|         11 | Program 11    |   10   | 11/13    | 11/20    | TBD              |
|         12 | Program 12    |   10   | 11/20    | 11/27    | TBD              |
|         13 | Final Project |  180   | 9/25     | 12/15    | TBD              |

## Final Projects MVP

One final project:

- Solo project; one student per project.
- Possibility to reuse strictly one subsystem implementing one design tenet will be shared across all projects; for example, naming, coordination, security. To be discussed during semester.
- Source code to be maintained in a GitHub repository; you will be invited by a GitHub invitation from the instructor's email address robmarano@gmail.com.
- Design and document in GitHub Wiki the software architecture and source code of your MVP; it's critical to document design in diagrams (draw.io) and in words on your project's wiki.
- Breakdown the MVP design in manageable sets of tasks, and track high-level via GitHub Project.
- Document the design of each subsystem for your MVP in its appropriate GitHub Wiki section.
- Demonstrate the MVP as part of your final presentation in an unlisted YouTube video, which will be due with your porject on **12/15/2023 11:59:59pm ET**.

# Your Coding Portfolio

Before you leave for break, ensure that you clean up your personal GitHub respository so that you can showcase the work you have developed. This will be helpful in any employment interviews you may have in the future. Like an artist, you know have a portfolio of software you have designed and implemented. No matter what you decide in your career, work and life is better through coding!

## Research, tinker, and automate so you have more time for the fun stuff of life!

Enjoy the course!
/prof.marano
