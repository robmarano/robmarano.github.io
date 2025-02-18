# Notes for Week 4
[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.md) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.md)

# Topics

1. Verilog: Parameterization; Built-in primitives; User-defined primitives; Dataflow modeling
2. Stored Program Concept
3. History of computer architecture and modern advancements

# Topics Deep Dive
## Verilog
### Parameterization
### SystemVerilog Built-in primitives
### SystemVerilog User-defined primitives
### SystemVerilog Dataflow modeling

## Modern Computer Architecture and the Stored Program Concept
### History of the Stored Program Concept
The stored-program concept, a fundamental principle in computer architecture, was pioneered by John von Neumann in the mid-1940s. It revolutionized computing by allowing computers to store both data and instructions in the same memory location. This seemingly simple idea had profound implications, enabling computers to become much more flexible and powerful than their predecessors, which relied on fixed programs or manual reconfiguration.   

Before the stored-program concept, computers were often limited to specific tasks. These "Fixed Program Computers" had their functionality determined by their physical design and could not be easily reprogrammed.  For example, the ENIAC and Colossus had to be physically rewired or reconfigured with switches and cables to change their programs. This process was time-consuming and laborious, often taking weeks to set up and debug a single program. Imagine having to rewire your computer every time you wanted to switch from writing an email to browsing the internet!   

With the stored-program concept, instructions are encoded as binary numbers and stored in memory alongside the data they operate on. This means that the computer can access and execute instructions sequentially, just like it accesses data. This is achieved through a continuous cycle of fetching instructions from memory, decoding them, and then executing them, known as the fetch-decode-execute cycle. The control unit acts like the brain of the computer, fetching instructions from memory and interpreting them. It then instructs the ALU, which is responsible for performing calculations and logical operations, to carry out the tasks specified by the instructions.

### Relating through an Example
Think of a chef in a kitchen. In early computers, the chef would have to follow a single recipe written on a wall, with no way to change it, cooking one item, dish, or ingredient at a time. The chef **is** the computer system and the program. With the stored-program concept, the chef now has a cookbook where they can store and access different recipes (programs) as needed. The chef can then follow the instructions in the chosen recipe to prepare a dish (perform a computation).

A crucial aspect of this concept is that instructions are treated as data, that is, data and instructions are coded into binary representation and manipulated by the computer architecture to compute (and store) the results requested by the program and driven by the data. As a result, programs can not only be stored and executed, but they can also be manipulated and modified like any other data. This has profound implications, as it allows for the creation of programs that can write or modify other programs, leading to the development of assemblers, compilers, linkers, and other essential software tools. It also enables self-modifying code, where a program can alter its own instructions during execution, allowing for more complex and dynamic behavior.   

This ability to store and execute different programs from memory is what allows your computer to run various applications, from TikTok, SnapChat, and web browsers to games, video editing software, and Matlab, for example.   

### Key Advantages of the Stored-Program Concept:

1. **Programmability:** Computers can be easily reprogrammed to perform different tasks by simply loading a new set of instructions into memory.
2. **Flexibility:** A single computer can be used for a wide range of applications.
3. **Self-modifying code:** Programs can modify their own instructions during execution, enabling more complex and dynamic behavior. (Think how computer viruses work...)

### Limitations of the Von Neumann Architecture (aka Princeton Architecture)
While the Von Neumann architecture revolutionized computing, it also has limitations. One of the most significant is the "Von Neumann bottleneck." This bottleneck arises because the CPU fetches both data and instructions from the **same memory location** using a single bus. This means that the CPU cannot fetch data and instructions simultaneously, leading to a slowdown in processing speed, especially when dealing with large amounts of data.   

To mitigate this bottleneck, modern computer architectures employ various techniques, such as:

1. **Memory Hierarchy:** Two of the five main components of a modern, general purpose computer are CPU and memory. This general term memory represents all the addressable storage locations. The memory hierarchy begins with cache memory, closest to the CPU. These small, high-speed memory units store frequently accessed data and instructions, reducing the need to access the lower memory stages in the hierarchy, ultimately to the full extent of all the addressable storage locations, aka, main memory.
2. **Modified Harvard architecture:** Using separate caches or access paths for data and instructions.   
3. **Branch prediction:** Predicting the flow of program execution to pre-fetch instructions and reduce delays.   

These advancements help to improve the performance of modern computers, but the fundamental principle of the Von Neumann architecture remains a cornerstone of their design.

### In Conclusion
The stored-program concept, a brainchild of John von Neumann, revolutionized computing by allowing both data and instructions to reside in the same memory. This innovation enabled computers to become programmable, flexible, and capable of performing a wide range of tasks. By treating instructions as data, it paved the way for the development of software, operating systems, and ultimately, the digital world we have today. Modern computers, from smartphones to supercomputers, owe their versatility and power to this fundamental principle.

