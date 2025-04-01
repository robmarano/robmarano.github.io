# Notes for Week 10 &mdash; The Processor &mdash; Data Path & Control (Part 1 of 3)

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Reading Assignment for these topics

1.Read sections 4.1, 4.2, 4.3, and 4.4 from [CODmips textbook's Chapter 4](./textbook_CODmips_Chapter_4%20-%20The%20Processor.pdf). In Section 4.4 read until "A Multicycle Implementation."

These topics are covered in our [CODmips textbook's Chapter 4 presentation deck](./Patterson6e_MIPS_Ch04_PPT.ppt)

# Topics

1.
2.
3.

## Introduction to high-level abstracted overview of The Processor

Section 4.1 of _Computer Organization and Design_ serves as the **introduction to the chapter on the processor**. This section provides a **high-level and abstract overview** of the principles and techniques used in implementing a processor. It sets the context for the more detailed discussions in the subsequent sections of the chapter.

Key points from Section 4.1 include:

Starting with a **highly abstract and simplified overview**, we will explain the principles and techniques used in implementing a processor. This initial overview follows building a **datapath** and construct a simple version of a processor capable of implementing an instruction set like MIPS.

Figure 4.1 shows a **high-level view of a MIPS implementation**, focusing on functional units and their interconnections. However, this figure omits the selection (control) logic for multiple data sources (multiplexors) and the control signals needed for different instruction types.

<center>
 <img src="./004fe001.jpg" alt="figure-4.1" style="height: 40%; width: 40%;" />
</center>

An abstract view of the implementation of the MIPS subset showing the major functional units and the major connections between them. All instructions start by using the program counter to supply the instruction address to the instruction memory. After the instruction is fetched, the register operands used by an instruction are specified by fields of that instruction. Once the register operands have been fetched, they can be operated on to compute a memory address (for a load or store), to compute an arithmetic result (for an integer arithmetic-logical instruction), or a compare (for a branch). If the instruction is an arithmetic-logical instruction, the result from the ALU must be written to a register. If the operation is a load or store, the ALU result is used as an address to either load a value from memory into the registers or store a value from the registers. The result from the ALU or memory is written back into the register file. Branches require the use of the ALU output to determine the next instruction address, which comes either from the ALU (where the PC and branch offset are summed) or from an adder that increments the current PC by 4. The thick lines interconnecting the functional units represent buses, which consist of multiple signals. The arrows are used to guide the reader in knowing how information flows. Since signal lines may cross, we explicitly show when crossing lines are connected by the presence of a dot where the lines cross.

In essence, Section 4.1 lays the groundwork for the chapter by outlining the topics that will be covered, ranging from basic datapath construction to advanced pipelining techniques and considerations for complex instruction sets. It also indicates different levels of detail that readers can focus on based on their interests.

## (review of) Logic Design Conventions

Section 4.2 of CODtextbook focuses on **logic design conventions** and how the hardware logic implementing a computer operates and is clocked. This section reviews key ideas in digital logic that are essential for understanding the rest of the chapter on the processor.

1. **Digital Logic**: The section likely assumes the reader has some basic understanding of digital logic. It mentions that logic components can be **combinational** or **sequential**.
1. **Combinational logic** elements operate on input values to produce outputs based on a logical function. Their outputs depend only on their current inputs.
1. **Sequential logic** elements contain state, meaning their outputs depend not only on the current inputs but also on the history of inputs and the contents of their internal state. An example given is the functional unit representing registers. Appendix B is mentioned as providing more detail on both combinational and sequential elements.
1. **Clocking Methodology**: A **clocking methodology** defines when signals can be read and when they can be written. This is crucial for predictable hardware operation, as reading and writing a signal simultaneously can lead to indeterminate values. The purpose of a clocking methodology is to ensure hardware predictability.
1. **Edge-Triggered Clocking**: The book relies on an **edge-triggered timing methodology**. This approach allows a state element (like a register) to be read and written in the same clock cycle without creating a race condition that could lead to indeterminate data values. The clock cycle must be long enough for the input values to be stable when the active clock edge occurs. Feedback within one clock cycle is not possible with edge-triggered updates, which is important for the proper functioning of the designs in this and the next chapter. Figure 4.4 illustrates this concept.

In summary, Section 4.2 lays the groundwork for understanding the processor's design by introducing the fundamental concepts of combinational and sequential logic and emphasizing the importance of a predictable clocking methodology, specifically the edge-triggered approach used throughout the chapter.

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)
