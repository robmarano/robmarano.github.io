# CS 102 - Section C - Intro to Computer Science
## General Course Information
Instructor: Prof. Rob Marano  
Email: rob@cooper.edu  
Semester of the course: Fall 2021  
Dates of the course: 31 August 2021 – 14 December 2021  

## Course Description
Concepts in computer science are presented in the context of programming in C, with a brief introduction to Python. Topics include variables, conditional statements, loops, functions, data structures, pointers. Multiple programming projects are assigned, as well as homeworks and quizzes.  
2 credits. 2 hours per week (30 total hours).

## Course Prerequisites
Being a Cooper Union freshman engineering student serves as the minimum prerequisite.  

### Course Structure/Method
__Lectures and Live Coding Labs:__ This class meets in person on 8/31, 9/7, 9/14, 9/21, 9/28, 10/5, 10/12, 10/19, 10/26, 11/2, 11/9, 11/16, 11/30, 12/7, and 12/14, for a total of 15 sessions. **Note:** 11/23 we do not meet. The class meets from 6:00-8:00 pm on all days. Office hours are held Tuesdays 5:00-6:00pm in the Engineering Adjunct's Office on the 2nd floor of the NAB at 41 Cooper Square.

## Course Learning Outcomes
Upon successful completion of this course, each student will be able to:
1. Set up a working and extensible C development environment using the Linux operating system.
2. Demonstrate working understanding of the main C mechanisms for in-memory structures, computation, network communication, and external storage.
3. Understand and demonstrate basic programming mechanisms of Python 3, including graphing numerical data.
4. Collaborative programming using GitHub for source code and project documentation, in addition to simple Kanban agile management.

## Communication Policy
The best way to contact me is via email then by instant messaging on Microsoft Teams. I will do my best to respond within 24 hours. Communication and participation in class is not only encouraged, but required. I seek to understand your individual understanding of the material each class. Advocate for yourself.

## Course Expectations
### Class Preparation
Each session will consist of two components: discussion and in-class lab work on your computers, using your virtual environment. Come prepared with your laptop and the Linux environment as described in this [CS-102 Development Environment repository on GitHub](https://github.com/robmarano/cooper-cs-102-env). We will review in person during the first three classes. Each class discussion consists of a mix of lectures, programming examples, and question-driven group analysis of one or more large programming problems. Lab will consist of either group or individual work on exercises or projects. Questions arising during lab may be used to fuel additional discussion as time permits.

### Attendance
Success as a student begins with attendance. Class time serves not only for learning new concepts and skills but also for practicing what you have learned with active feedback. Some assignments and demos may be completed in class, but practice and study are required outside of class. Students are expected to attend classes regularly, arrive on time, and participate. I take attendance during every session, and it forms part of your grade. Students are encouraged to e-mail me when they are absent. Students are responsible for all academic work missed as a result of absences. It is at my discretion to work with students outside of class time in order to make-up any missed work.

## Materials
### Reference Books
Textbooks are not required for the course, but they may be useful to have. These are some we the CS102 professors suggest.
* <u>The C Programming Language, 2nd Edition</u> by Brian W. Kernighan & Dennis M. Ritchie
* <u>Python Programming for the Absolute Beginner, 3rd Edition</u> by Mihael Dawson
* <u>Engineering Problem Solving with C, 4th Edition</u> by Delores M. Etter
* <u>Computer Science: A Structured Programming Approach Using C, 3rd Edition</u> by Behrouz A. Forouzan and Richard F. Gilberg
* <u>Practical C Programming, 3rd Edition</u> by Steve Oualline
* <u>C Programming: A Modern Approach, 2nd Edition</u> by K. N. King

### Software
All software will be open source.

## Assessment Strategy and Grading Policy
All assignments must be completed by the end of this course in order to receive at least a passing grade.

| Assignment | Title | Points | Handed Out On | Due Date |
| :---:  | :---- | :----: |:---- | :--- |
| 1 | HW 1 | 5 | 09/21/2021 | 10/01/2021 @ 11:59:59pm ET |
| 2 | Quiz 1 | 10 | - | 09/28/2021 |
| 3 | HW 2 | 5 | 09/28/2021 | 10/08/2021 @ 11:59:59pm ET |
| 4 | Quiz 2 | 10 | - | 10/12/2021 |
| 5 | HW 3 | 5 | 10/12/2021 | 10/29/2021 @ 11:59:59pm ET |
| 6 | Quiz 3 | 10 | - | 11/02/2021 |
| 7 | HW 4 | 5 | 10/26/2021 | 11/12/2020 @ 11:59:59pm ET |
| 8 | Quiz 4 | 10 | - | 11/16/2021 |
| 9 | Python Final Mini-Project | 10 | - | 12/7/2021 |
| 10 | C Final Project | 30 | - | 12/14/2021 |
| 11 | Class attendance | 30 | - | two points earned per attended class |
| 12 | Class participation | 20 | - | qualitative points earned for contributing to classes |

## Final Projects MVPs
Two final projects, one for C and one for Python, the former will be more complex in size and scope than the latter. The following items pertain only to the final C project:
* Collaborate on teams of 2 people, not less, not more.
* Source code to be maintained in a GitHub repository per team.
* Design and document in GitHub Wiki the software architecture and source code of your team’s MVP.
* Breakdown the MVP design in manageable sets of tasks, and track high-level via GitHub Project.
* Document the design of each Python subsystem for your MVP in its appropriate GitHub Wiki section.
* Demonstrate the MVP as part of your team’s final presentation during the class on **12/14/2021**.

The following expectations pertain to the final Python project:
* Completed per student; no group group project
* Source code to be maintained in each student's GitHub repository
* Demonstrate the project's MVP during the class on **12/7/2021**.

## Course Outline

### Session 1: 08/31/2021, 6pm-8pm
**Description:** Course Overview; How computers work: CPU, memory, input, output, code; Intro to Linux plus gcc and make as your C development environment; Get your "Hello, World!" mojo going; and collaborating with git using GitHub. You will become a Command Line Master.  
**Assignments:** Review virtual machine options for your OS, e.g., Windows, Mac OS, Linux; for example, VirtualBox or Docker.

### Session 2: 09/07/2021, 6pm-8pm
**Description:** Debug building your Docker image based upon our course Dockerfile, and debug running your Docker image on your host computer. Intro basics of Git; Variables; Types; Operators.  
**Assignments:** In your Docker container via CLI, ```git clone``` our CS102 section's [course and class repository located here on GitHub](https://github.com/robmarano/cs102_at_cooper.git).

### Session 3: 09/14/2021, 6pm-8pm
**Description:** More on Docker container set up; Intro to C programming, data types and simple operators and basic input and output (I/O).  
**Assignments:** Read chapters 1 through 3 in Kernighan & Ritchie's <u>The C Programming Lanugage</u> as handed out in class. Try the examples using your Docker container CLI. Read, review, research, learn... Form your two-student final C project team.

### Session 4: 09/21/2021, 6pm-8pm
**Description:** Review basics of Git; Variables. More on data types and operators. Intro to operations precedence, conditional statements, the switch statement, as well as loops, and simple arrays, including character strings. Review topics of Quiz 1 to be held next class.  
**Assignments:** Receive definition of HW 1 via Assignment on Microsoft Teams and [here](./HW1.md) and hand-in by <u>10/01/2021 at 11:59:59pm ET</u>. Choose a teammate. Brainstorm ideas for your complex, multi-stage final C project with your teammate. **<i>Each</i>** student on the team creates her/his own new GitHub repo for the final project and adds a top-level README.md file that describes the project and submits the repo URL to me via Microsoft Teams under Assignments. Add MIT license to your individual repo.

### Session 5: 09/28/2021, 6pm-8pm
**Description:** More on Arrays; Intro to Functions; Intro to your first "large-scale" program design and implementation: Tic-Tac-Toe. Quiz 1 during last 15 minutes of class.  
**Assignments:** Receive definition of HW 2 via Assignment on Microsoft Teams and [here](./HW2.md), and it's due by <u>10/08/2021 @ 11:59:59pm ET</u>.

### Session 6: 10/05/2021, 6pm-8pm
**Description:** Deep dive into designing and implementing Tic-Tac-Toe in C. Review topics of Quiz 2 to be held next class.
**Assignments:** Work on homework and practice. Read, review, research, learn... Begin to design your MVP for your final C project with your teammate.

### Session 7: 10/12/2021, 6pm-8pm
**Description:** As we delve further into Tic Tac Toe ... What are these pointers? We don’t need no stinking pointers -- or so they say. Arrays in a brand new (non array) light... Quiz 2 during last 20 minutes of class.  
**Assignments:** Receive HW 3 via Assignment on Microsoft Teams and [here](./HW3.md), and it's due by <u>10/29/2021 @ 11:59:59pm ET</u>. Begin your final C project in earnest.

### Session 8: 10/19/2021, 6pm-8pm
**Description:** Encore, more on Pointers and Arrays. Finish up on Tic Tac Toe. 
**Assignments:** Work on homework and practice. Read, review, research, learn... Work on your final C project.

### Session 9: 10/26/2021, 6pm-8pm
**Description:** The CLI and Command-line arguments; intro to C data structures, e.g., struct, union, typedef.   
**Assignments:** Receive HW 4 via Assignment on Microsoft Teams and [here](./HW4.md), and it's due by <u>11/12/2021 @ 11:59:59pm ET</u>. Read, review, research, learn... Continue designing your MVP for your final C project with your teammate; start your project structure with the Makefile, file breakdowns, etc.

### Session 10: 11/02/2021, 6pm-8pm
**Description:** Mas C data structures; Mas on git and GitHub; Formal discussion on Final C Project, whose final presentation are on 12/14 and final code repository due 12/17 11:59:59pm (end of semester), but your code must work during your presentation.  Quiz 3 during last 20 minutes of class.  
**Assignments:** Work on homework and practice. Read, review, research, learn...

### Session 11: 11/09/2021, 6pm-8pm
**Description:** And now for something completely different, [Monty] Python introductions, along with Jupyter notebooks. Quiz 4 during last 20 minutes of class.  
**Assignments:** Study for last quiz, Quiz 4 on 11/16. Work on homework and practice. Read, review, research, learn... Write you (pseudo)code your MVP for your final C project with your teammate.

### Session 12: 11/16/2021, 6pm-8pm
**Description:** Python Functions; Python Modules. Quiz 4 during last 20 minutes of class. No more quizzes.    
**Assignments:** Brainstorm individually and begin your own Python final mini-project; no group final Python mini-project. Remember it’s to be short, sweet, and to the point; solve one problem with your code. Perhaps usable in other classes. Study ahead to work over break during week of 11/22/2021.

### Session 13: 11/30/2021, 6pm-8pm
**Description:** Files and Python; the Network and Python.  
**Assignments:** Python final mini-project due <u>12/07/2021 11:59:59pm ET</u> via your GitHub repository strictly for the final C project.

### Session 14: 12/07/2021, 6pm-8pm
**Description:** Data, Pandas, Python, and Matplotlib - taming my data and visualize it.  
**Assignments:** Remember, Python final project due 12/14 11:59:59pm.

### Session 15a: 12/14/2021, 6pm-8pm
**Description:** Final C final project presenatations; you get 10 minutes per group of students to present and demonstrate working code.  
**Assignments:** Final repo for C source code and presentations due 12/17 at 11:59:59pm. Feel free to record your video presentation again if you want me to renew your grade from class presentation. Make video available on YouTube.

### Session 15b: 12/17/2021, 11:59:59pm (fall semester ends)
**Description:** Final, working C source code due on your team’s main branch. See https://github.com/github/renaming.  
**Assignments:** Officially hand-in your two-person team C project.

# Your Coding Portfolio
Before you leave for break, ensure that you clean up your personal GitHub respository so that you can showcase the work you have developed. Like an artist, you know have a portfolio of software you have designed and implemented. No matter what you decide in your career, work and life is better through coding!

## Research, tinker, automate so you have more time for the fun stuff of life!