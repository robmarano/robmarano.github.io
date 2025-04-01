# Notes for Week 11 &mdash; The Processor &mdash; Data Path & Control (Part 2 of 3)

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Reading Assignment for these topics

These topics are covered in our [CODmips textbook's Chapter 4 presentation deck](./Patterson6e_MIPS_Ch04_PPT.ppt)

# Topics

1. Computer performance
2. Multicycle processor implementation

# Topic Deep Dive

## Computer performance

Section 1.6 of CODmips textbook, titled "Performance", discusses the crucial aspects of evaluating and comparing the speed and efficiency of computers. It highlights the challenges in performance assessment due to the complexity of modern software and hardware.

### Defining Performance

The section begins by emphasizing that when we say one computer has better performance than another, the definition can be subtle. Using the analogy of passenger airplanes, it illustrates that "performance" can have different meanings depending on the criteria (e.g., speed for a single passenger vs. capacity for many). Similarly, computer performance can be defined in different ways based on the user's or manager's perspective.

### Response Time vs. Throughput:

The section distinguishes between two primary measures of performance:

1. **Response time** (or execution time) is the total time required for a computer to complete a task, which is most important to individual users. To maximize performance from this perspective, we aim to minimize response time.
2. **Throughput** (or bandwidth) is the total amount of work done in a given time, which is often of interest to datacenter managers.

### Relative Performance

The section explains how to quantitatively compare the performance of two computers. If computer X is n times faster than computer Y, it means that the execution time on Y is n times longer than on X. The performance ratio is calculated as (Performance of X) / (Performance of Y) = (Execution time of Y) / (Execution time of X).

### Measuring Performance

Time is presented as the ultimate and most reliable measure of computer performance; the computer that completes the same work in less time is faster.

Different ways of measuring time are discussed:

1. **Wall clock time** (response time, elapsed time) includes everything: disk accesses, memory accesses, I/O activities, operating system overhead, and CPU execution time.
2. **CPU execution time** (CPU time) is the actual time the CPU spends computing for a specific task. It can be further divided into user CPU time (time spent in the program itself) and system CPU time (time spent in the operating system on behalf of the program). For initial discussions, the focus is often on CPU performance.

### Clock Cycles

Computer designers often think about performance in terms of clock cycles, which are discrete time intervals determined by the computer's clock. The length of a clock cycle is the clock cycle time (e.g., in picoseconds), and its inverse is the clock rate (e.g., in gigahertz).

### The Basic Performance Equation

The section introduces the fundamental equation that relates CPU execution time to key hardware characteristics:

This equation shows that performance is affected by the number of instructions in a program, the average number of clock cycles required for each instruction (CPI), and the duration of each clock cycle. Figure 1.15 summarizes these basic components of performance.

<center>
 <img src="./fig-1-15.png" alt="figure-1.15" style="height: 30%; width: 30%;" />
</center>

### Factors Affecting Performance Equation

The section elaborates on the factors that influence each component of the performance equation:

1. **Instruction Count:** Determined by the algorithm, the programming language, and the compiler.
2. **CPI (Clock Cycles Per Instruction):** Influenced by the instruction set architecture and the processor implementation (including the memory system and processor structure). CPI can vary significantly between different instructions and applications. Some processors can even execute multiple instructions per clock cycle, leading to a CPI of less than 1 (or an IPC - instructions per clock cycle - greater than 1).
3. **Clock Cycle Time:** Determined by the hardware technology and the processor design. Modern processors can even vary their clock rates dynamically (e.g., Intel's Turbo mode).

### Instruction Mix

The dynamic frequency of different instruction types in a program (instruction mix) also plays a crucial role in overall performance as different instructions may have different CPI values.

### Importance of Complete Measurement

The section cautions against using only a subset of the performance equation (like clock rate) to compare computers, as this can be misleading. The only complete and reliable measure of computer performance is time.

### Understanding Program Performance

The performance of a program depends on the algorithm, the language, the compiler, the architecture, and the actual hardware. The following table summarizes how these components affect the factors in the CPU performance equation.

| Hardware or software component | Affects what?                      | How?                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------------------------ | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Algorithm                      | Instruction count, possibly CPI    | The algorithm determines the number of source program instructions executed and hence the number of processor instructions executed. The algorithm may also affect the CPI, by favoring slower or faster instructions. For example, if the algorithm uses more divides, it will tend to have a higher CPI.                                                                                      |
| Programming language           | Instruction count, CPI             | The programming language certainly affects the instruction count, since statements in the language are translated to processor instructions, which determine instruction count. The language may also affect the CPI because of its features; for example, a language with heavy support for data abstraction (e.g., Java) will require indirect calls, which will use higher CPI instructions. |
| Compiler                       | Instruction count, CPI             | The efficiency of the compiler affects both the instruction count and average cycles per instruction, since the compiler determines the translation of the source language instructions into computer instructions. The compiler’s role can be very complex and affect the CPI in complicated ways.                                                                                             |
| Instruction set architecture   | Instruction count, clock rate, CPI | The instruction set architecture affects all three aspects of CPU performance, since it affects the instructions needed for a function, the cost in cycles of each instruction, and the overall clock rate of the processor.                                                                                                                                                                    |

Although you might expect that the minimum CPI is 1.0, as we’ll see in Chapter 4, some processors fetch and execute multiple instructions per clock cycle. To reflect that approach, some designers invert CPI to talk about IPC, or instructions per clock cycle. If a processor executes on average 2 instructions per clock cycle, then it has an IPC of 2 and hence a CPI of 0.5.

Although clock cycle time has traditionally been fixed, to save energy or temporarily boost performance, today’s processors can vary their clock rates, so we would need to use the average clock rate for a program. For example, the Intel Core i7 will temporarily increase clock rate by about 10% until the chip gets too warm. Intel calls this Turbo mode.

### Conclusion

In summary, Section 1.6 lays the foundation for understanding computer performance by defining it from different perspectives, introducing key metrics like response time and throughput, explaining how to compare performance quantitatively, and presenting the fundamental performance equation that links execution time to instruction count, CPI, and clock cycle time. It emphasizes that achieving high performance requires considering all these factors and that time is the ultimate measure.

## Multicycle processor implementation

Section 4.5 covers multicycle processor implementation. We moved from basic concepts to a simple single-cycle implementation in Section 4.4

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)
