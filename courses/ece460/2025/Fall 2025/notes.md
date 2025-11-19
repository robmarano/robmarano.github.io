# ECE 460 - GPU Architecture

# Week 2

Let's do a quick refresher on the MIPS 32-bit processor you designed, focusing on the key concepts of its instruction set architecture (ISA) and pipelined datapath. This will serve as a familiar starting point. Then, we'll pivot to the core of today's session: an introduction to GPU architecture. We'll explore the fundamental differences between CPUs and GPUs, and I'll introduce a very simple GPU design with a minimal ISA. To make it tangible, we'll walk through a basic program and see how it would execute on our simple GPU.


By the end of this session, you should have a solid conceptual understanding of the architectural principles that make GPUs so powerful for certain tasks. We'll be keeping things at a high level today, focusing on the theory and design. In the coming weeks, we'll dive deeper into the SystemVerilog implementation of this simple GPU.

## Part 0: Flynn's Notation - A framework for understanding the processor architectures

In the world of computer architecture, we need a way to classify different types of computer systems based on how they handle instructions and data. In 1966, Michael J. Flynn developed a simple yet powerful classification system known as **Flynn's Taxonomy** (or Notation). This taxonomy categorizes computer architectures based on the number of concurrent instruction streams and data streams available in the system.

Think of it as a high-level way to group processors by their parallel computing capabilities. It focuses on two fundamental concepts:
1. `Instruction Stream`: The sequence of instructions being executed by the processor.
2. `Data Stream`: The sequence of data being manipulated by those instructions.

By looking at whether these streams are single or multiple, Flynn created a 2x2 matrix that gives us four distinct classifications.

### The Four Classifications

Here is a brief explanation of each of the four categories in Flynn's Notation.
1. **SISD** (Single Instruction, Single Data)
  * **Description**: This is the classic, non-parallel computer architecture. It features a single control unit that fetches and executes a single stream of instructions, which operate on a single stream of data. One instruction is processed at a time on one set of data.
  * **Analogy**: Think of a single chef following one recipe (one instruction stream) to cook one dish (one data stream).
  * **Example**: The MIPS processor you designed in ECE 251 is a perfect example of a SISD architecture. Early personal computers and most simple microcontrollers also fall into this category.
2. **SIMD** (Single Instruction, Multiple Data)
  * **Description**: This architecture features a single control unit that broadcasts a single instruction to multiple independent processing elements (PEs). Each PE executes that same instruction simultaneously, but on its own unique piece of data. It's a model built for data-level parallelism.
  * **Analogy**: Imagine a drill sergeant (single instruction) telling an entire platoon of soldiers (multiple data streams) to "do ten push-ups." Everyone does the same thing at the same time, but on their own body.
  * **Example**: This is the model for our simple GPU. Graphics processors are the quintessential example of SIMD, as they often apply the same operation (e.g., shading a pixel) to massive amounts of data (all the pixels in a polygon). CPU instruction set extensions like MMX, SSE, and AVX also use SIMD principles.
3. MISD (Multiple Instruction, Single Data)
  * **Description**: In this model, multiple instruction streams operate in parallel on a single data stream. Several processing units receive different instructions but work on the same data.
  * **Analogy**: Imagine a single assembly line (single data stream) where multiple quality control inspectors (multiple instruction streams) are performing different checks on each item as it passes by.
  * **Example**: This is the rarest of the four classifications and has seen very few commercial implementations. It is sometimes used in fault-tolerant systems where multiple redundant processors perform different calculations on the same input to verify the correctness of the result.
4. MIMD (Multiple Instruction, Multiple Data)
  * **Description**: This is the most flexible and powerful form of parallel computing. A MIMD system contains multiple, independent processors, each executing a different instruction stream on its own separate data stream. The processors can work on completely unrelated tasks or coordinate to solve a larger problem.
  * **Analogy**: Think of a large commercial kitchen with several chefs (multiple instruction streams), each working on a different recipe with their own ingredients (multiple data streams) to create a complete banquet.
  * **Example**: Modern multi-core CPUs are the most common example of MIMD architecture. Each core can run a different program or a different thread of the same program independently. Supercomputers and distributed computing clusters also fall into this category.

Understanding this taxonomy helps us place our designs in the proper context. Our MIPS CPU was SISD, and the GPU we are now designing is a classic example of SIMD. This distinction is fundamental to why GPUs are so effective at graphics and scientific computing, while CPUs excel at general-purpose, sequential tasks.

## Part 1: MIPS 32-bit CPU Review

Let's begin by jogging our memory about the MIPS 32-bit processor you masterfully designed in ECE 251. The MIPS architecture is a classic example of a Reduced Instruction Set Computer (RISC), characterized by a small, highly optimized set of instructions.

### Instruction Set Architecture (ISA):

The MIPS ISA is a **load-store architecture**, meaning that only load and store instructions can access memory. All other operations, like arithmetic and logical instructions, operate on registers. This design choice simplifies the control logic and allows for a more efficient pipeline. You'll recall the three main instruction formats: R-type for register-to-register operations, I-type for immediate and data transfer instructions, and J-type for jumps.

### Single-Cycle vs. Pipelined Datapath:
In ECE 251, you designed a single-cycle processor. While conceptually simple, where each instruction is executed in a single clock cycle, it's not very efficient. The clock cycle time is determined by the longest instruction, which slows down the entire processor.


To improve performance, you then moved on to a pipelined MIPS processor. By breaking down the instruction execution into five stages—Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB)—we can overlap the execution of multiple instructions. This is analogous to an assembly line, where different stages work on different parts of the production process simultaneously, significantly increasing the instruction throughput. The key to this is the use of pipeline registers between each stage to hold the intermediate results.


The following table illustrates the 5-stage MIPS pipeline.
Classic 5-Stage MIPS Pipeline:
1. `IF`: Instruction Fetch
2. `ID`: Instruction Decode & Register Read
3. `EX`: Execute or Address Calculation
4. `MEM`: Memory Access
5. `WB`: Write Back

| Cycle | 1st Instr | 2nd Instr | 3rd Instr | 4th Instr | 5th Instr |
|-------|-----------|-----------|-----------|-----------|-----------|
|   1   |    IF     |           |           |           |           |
|   2   |    ID     |    IF     |           |           |           |
|   3   |    EX     |    ID     |    IF     |           |           |
|   4   |   MEM     |    EX     |    ID     |    IF     |           |
|   5   |    WB     |   MEM     |    EX     |    ID     |    IF     |
|   6   |           |    WB     |   MEM     |    EX     |    ID     |
|   7   |           |           |    WB     |   MEM     |    EX     |
|   8   |           |           |           |    WB     |   MEM     |
|   9   |           |           |           |           |    WB     |


This concept of pipelining is a form of instruction-level parallelism. It's a crucial technique for speeding up sequential programs. However, as we'll see, GPUs take parallelism to a whole new level.

## Part 2: Introduction to a Simple GPU Architecture

While CPUs are optimized for low-latency execution of a single instruction stream, GPUs are designed for high-throughput, parallel processing of massive amounts of data. Think of a CPU as a sports car, designed for speed on a single task, while a GPU is like a fleet of buses, designed to move a lot of people (data) at once.

The key architectural difference lies in the number of processing cores. A CPU typically has a few powerful cores, whereas a GPU has hundreds or even thousands of smaller, more specialized cores. This massive parallelism is what makes GPUs so effective for tasks like graphics rendering, scientific computing, and machine learning.

To understand how this works, we're going to design a very simple GPU. Our goal here is not to build a commercial-grade GPU, but to grasp the core concepts.

### A Minimal GPU ISA:
Let's define a very simple Instruction Set Architecture for our GPU. We'll keep it minimal to illustrate the key ideas.

| Instruction |	Opcode | Description |
|-------------|--------|-------------|
| `LOAD Rx, [Ry]` | `0001` | Load data from memory address in Ry into register Rx.|
| `STORE Rx, [Ry]` | `0010` | Store data from register Rx to memory address in Ry.|
| `ADD Rx, Ry, Rz` | `0011` | Add the values in Ry and Rz and store the result in Rx.|
| `HALT` | `1111` | Stop execution.|

This is a very basic set of instructions, but it's enough to perform a simple but common parallel task: **vector addition**.


### A Simple SIMD GPU Architecture:

Our simple GPU will be a SIMD (Single Instruction, Multiple Data) machine. This means that a single instruction is executed simultaneously by multiple processing elements (our "cores") on different data.

Here's the high-level architecture of our simple GPU:

* **A small number of cores:** Let's say we have 4 simple cores. Each core has its own small set of registers (e.g., `R0` - `R3`).
* **Shared Instruction Memory:** All cores will fetch instructions from the same instruction memory. This is where the **Single Instruction** part of SIMD comes from.
* **Shared Data Memory:** All cores can access a shared data memory.
* **A simple Control Unit:** This unit will fetch the instructions and broadcast them to all the cores.

```
+--------------------------------------------------+
|                  Control Unit                    |
+---------------------------+----------------------+
|   Shared Instruction Mem  | Shared Data Memory   |
+---------------------------+----------------------+
|   +---------+   +---------+   +---------+        |
|   |  Core 1 |   |  Core 2 |...|  Core N |        |
|   +---------+   +---------+   +---------+        |
|   |Regs |ALU|   |Regs |ALU|   |Regs |ALU|        |
|   +---------+   +---------+   +---------+        |
+--------------------------------------------------+
```

* `Regs` are per-core registers; `ALU` is the per-core arithmetic-logic unit.
* All cores receive instructions from shared instruction memory and share access to shared data memory.
* The control unit oversees this architecture by dispatching instructions and managing coordination among cores.

This structure enables high parallelism by allowing many computations to run simultaneously with minimal control and maximal data throughput.

#### Example Program: Vector Addition
Now, let's see how we can use our simple GPU to perform vector addition. Imagine we have two vectors, A and B, and we want to compute their sum and store it in a vector C.

Let's say our vectors have a length of 4.

```
A = [A0, A1, A2, A3]
B = [B0, B1, B2, B3]
C = [C0, C1, C2, C3]
```

In memory, we'll lay out the data like this:
```
Address 0-3: Vector A
Address 4-7: Vector B
Address 8-11: Vector C (for the results)
```

Here is a **simple program** in our GPU's ISA to perform this vector addition:

```assembly
// Each core will execute this program in parallel on a different element of the vectors.
// For simplicity, we'll assume each core has a unique ID (0-3) that it can use
// to calculate its memory offsets.  In a real GPU, this is handled by the hardware.

// Core 0 will process A[0] and B[0], Core 1 will process A[1] and B[1], and so on.

LOAD R1, [R0 + 0]    // Load A[i] into R1 (R0 holds the base address for A for this core)
LOAD R2, [R0 + 4]    // Load B[i] into R2 (offset of 4 for vector B)
ADD R3, R1, R2       // C[i] = A[i] + B[i]
STORE [R0 + 8], R3   // Store the result in C[i] (offset of 8 for vector C)
HALT
```

**Execution Walkthrough:**

Now, let's trace the execution of this program on our 4-core GPU. The control unit fetches the first instruction, `LOAD R1, [R0 + 0]`, and broadcasts it to all four cores.

* `Core 0:` `R0` is initialized to `0`. It loads the value at memory address `0` (`A0`) into its `R1`.
* `Core 1:` `R0` is initialized to `1`. It loads the value at memory address `1` (`A1`) into its `R1`.
* `Core 2:` `R0` is initialized to `2`. It loads the value at memory address `2` (`A2`) into its `R1`.
* `Core 3:` `R0` is initialized to `3`. It loads the value at memory address `3` (`A3`) into its `R1`.

In a single cycle (conceptually), all four cores have loaded their respective elements from vector A.

The control unit then fetches and broadcasts the next instruction, `LOAD R2, [R0 + 4]`.

* `Core 0:` Loads the value at memory address `4` (`B0`) into its `R2`.
* `Core 1:` Loads the value at memory address `5` (`B1`) into its `R2`.
* `Core 2:` Loads the value at memory address `6` (`B2`) into its `R2`.
* `Core 3:` Loads the value at memory address `7` (`B3`) into its `R2`.

Next, the `ADD` instruction is executed in parallel on all cores, and finally, the `STORE` instruction writes the results back to the corresponding locations in `vector C`.

As you can see, in just a few instruction cycles, we have performed four additions. A single-core CPU would have had to loop through these operations four times. This is the power of data parallelism. Believe! :)

#### From Theory to SystemVerilog:
Next, we will start translating this conceptual design into a SystemVerilog implementation. We'll design the individual modules: the core, the memory interfaces, and the control unit. You'll find that many of the skills you learned in designing the MIPS processor, such as creating ALUs, register files, and control logic, will be directly applicable here. The main new challenge will be in orchestrating the parallel execution across multiple cores.


# Week 3

## The History of the GPU

The history and architecture of Graphics Processing Units (GPUs) are closely tied to their origin as specialized graphics processors, distinct from traditional Central Processing Units (CPUs).

### Ancestry and Foundational Purpose

GPUs and CPUs do not trace back to a common ancestor in computer architecture genealogy. Instead, the sources indicate that the **primary ancestors of GPUs are graphics accelerators**.

The fundamental reason GPUs exist is **to excel at graphics processing**. While they have begun to move toward mainstream computing, their design must still enable them to continue to perform graphics functions efficiently.

### Shift to Parallel Computing

The rise of GPUs in computing platforms was driven by the increasing importance of **multimedia applications**, such as games and video processing. GPUs were found to achieve significant performance advantages for applications exhibiting **extensive data-level parallelism (DLP)**.

This adoption led to a widespread shift to GPU parallel computing, particularly as processors faced limitations in Instruction-Level Parallelism (ILP) and thermal constraints. See [The Free Lunch Is Over - The Fundamental Shift Towards Concurrency in Software](https://www.cs.utexas.edu/~lin/cs380p/Free_Lunch.pdf)

GPUs utilize a specialized form of parallelism known as **Data-Level Parallelism** (DLP), often employing a Single Instruction, Multiple Data (SIMD) or Single Instruction, Multiple Thread (SIMT) execution model. This makes them architected for **high throughput** on massively parallel workloads, contrasting with traditional CPUs optimized for low-latency execution of sequential tasks.

### Architectural Understanding and Terminology

GPUs represent a distinct variation of SIMD architecture, alongside vector architectures and multimedia SIMD instruction set extensions found in CPUs.

A major hurdle in understanding GPU architecture has been the **jargon** used by the GPU community, with some terms having non-traditional or misleading definitions when compared to standard computer architecture vocabulary. The architecture utilizes hierarchical concepts, including Grids, Blocks/Cooperative Thread Arrays (CTAs), and Warps/Wavefronts, to manage massive parallelism and leverage underlying SIMD/SIMT principles.

### Resources and Study

The historical development of GPUs, alongside SIMD architectures, is covered in specialized materials like the revised Chapter 4 on Data-Level Parallelism in certain computer architecture curricula. Resources detailing the architecture often leverage technical documentation, whitepapers, and insightful articles from industry leaders like NVIDIA and AMD to connect theoretical knowledge to current hardware design. Specific detailed historical perspectives on GPUs can be found in reference sections, such as Section L.6 of the sources.

## Some Jargon Addressed

The terms **grid**, **block** / **cooperative thread array (CTA)**, and **warp** / **wavefront** describe the hierarchical structure used in the programming and execution models of general-purpose GPUs (GP-GPUs), particularly those using APIs like CUDA, GCN/RDNA, and OpenCL.

Here is a definition for each term, drawing on the descriptive names, official NVIDIA (CUDA), and AMD jargon:

### 1. Grid (Vectorizable Loop)

A **grid** is the highest level of the software hierarchy used in GPU programming models.

*   **Definition:** A grid is the **code that runs on a GPU** that consists of a set of **thread blocks**. It is analogous to a **vectorizable loop**.
*   **Purpose:** The grid is the overall parallel workload launched by the CPU (host) to be executed on the GPU (device).
*   **NVIDIA/CUDA terminology:** **grid**.
    *   NVIDIA defines a grid as an array of thread blocks that can execute concurrently, sequentially, or a mixture.
*   **AMD/OpenCL terminology:** OpenCL refers to it as the **index range**, and AMD refers to it as the **NDRange**.

### 2. Block / Cooperative Thread Array (CTA) (Body of a Vectorized Loop)

A **thread block** (or CTA) is a grouping of individual threads within a grid, forming the primary unit of work assignment on the GPU.

*   **Definition:** A thread block (or CTA) is a vectorized loop that is executed on a **multithreaded SIMD Processor** (Streaming Multiprocessor). It is composed of one or more threads of SIMD instructions and is analogous to the **body of a (strip-mined) vectorized loop**.
*   **Execution & Communication:** The grid of thread blocks is assigned to the multithreaded SIMD Processors by the thread block scheduler (Giga Thread Engine).
    *   Threads within a CTA can **communicate efficiently** with each other via a fast, per-core scratchpad memory. This on-chip memory is called **shared memory** by NVIDIA and the **local data store (LDS)** by AMD.
    *   Threads within a CTA can also **synchronize efficiently** using hardware-supported barrier instructions.
    *   In the CUDA programming model, a thread block is defined as an array of CUDA threads that execute concurrently together and can cooperate and communicate via shared memory and barrier synchronization.
*   **NVIDIA/CUDA Terminology:** **thread block** or **cooperative thread array (CTA)**.
*   **AMD/OpenCL Terminology:** **work group**.

### 3. Warp / Wavefront (A Thread of SIMD Instructions)

The **warp** (NVIDIA) or **wavefront** (AMD)is the fundamental hardware scheduling and execution unit on the GPU.

*   **Definition:** A warp is a **traditional thread** that contains exclusively **SIMD instructions**. This group of threads is executed **in lockstep on SIMD hardware** to exploit regularities and spatial localities. The execution model is often referred to as Single-Instruction, Multiple-Thread (SIMT).
*   **Scheduling:** The warp (or wavefront) is the **unit of scheduling** for the GPU hardware. The GPU hardware executes groups of scalar threads, called warps (or wavefronts), in lockstep on SIMD hardware. The **warp scheduler** (SIMD thread scheduler) is the hardware unit that schedules and issues these threads of SIMD instructions when they are ready to execute.
*   **Size:** NVIDIA warps typically consist of **32 threads**, while AMD wavefronts typically consist of **64 threads**.
*   **Individual Threads:** Each individual thread launched onto the GPU is referred to as a **CUDA thread** (NVIDIA) or **work item** (AMD/OpenCL). The CUDA thread is a "vertical cut" of a warp, corresponding to one element executed by one SIMD Lane.
*   **Divergence:** GPU hardware enables threads within a warp to follow different paths through code by **serializing execution of threads following divergent paths** within a given warp. This management is typically handled using a SIMT stack or convergence barriers.
*   **NVIDIA/CUDA Terminology:** **warp**.
*   **AMD/OpenCL Terminology:** **wavefront**.

## Parallelism in a CPU
Parallelism in a Central Processing Unit (CPU) involves understanding a several architectural concepts, starting with sequential processing fundamentals and progressing through different forms of parallel execution.

Understanding CPU parallelism starts with implicit parallelism handled by the hardware to explicit parallelism requiring software engineer coding:

### 1. Foundational Concepts and Sequential Processing

Let's start with the **essential building blocks of classical computer architecture** (ECE 251) and sequential processing paradigms. The foundations include:

*   **Instruction Set Architectures (ISAs)**, datapath, and control units.
*   Principles of **memory hierarchies**, including caches, main memory, and virtual memory.
*   Study the historical motivation for parallelism, such as the diminishing returns of instruction-level parallelism and constraints like the maximum power dissipation of integrated chips.

### 2. Instruction-Level Parallelism (ILP)

**Instruction-Level Parallelism** exploits overlap among instructions in a sequential stream and is generally handled implicitly by the compiler and hardware. This area of study is crucial for understanding how modern processors execute tasks quickly:

*   **Pipelining:** Understanding the principles of **pipelining** (chapter 4 in ECE 251 textbook) is the simplest and most common form of ILP. Pipelining principles include hazards (structural, data, control) and mitigation techniques like forwarding and hazard detection.
*   **Advanced ILP Techniques:** ILP has been enhanced using **superscalar execution**, **dynamic scheduling** (like Tomasulo's algorithm, see parking lot below), and **hardware-based speculation**. These techniques enable multiple instructions to issue per clock cycle (decreasing the cycles per instruction, or CPI).
*   **Limitations of ILP:** The **limitations of ILP** directly led to the industry-wide shift toward multicore designs focusing on thread-level parallelism.

#### Deeper dive into ILP limitations
The ability to exploit Instruction-Level Parallelism (ILP) is constrained by several fundamental factors related to program structure, hardware implementation complexity, and diminishing returns. Understanding these limitations was a crucial driver in the shift toward multicore and thread-level parallelism (TLP).

The limitations of ILP can be categorized based on their source: those imposed by the program's inherent structure, and those imposed by realistic hardware implementations.

##### 2a. Program Limitations (Inherent Constraints)

These limitations exist even in an idealized processor with perfect hardware resources (like infinite renaming and perfect caches):

*   **Data dependences (true dependences):** ILP is fundamentally limited by true data dependences, where one instruction produces a result that must be used by a subsequent instruction, forcing a sequential ordering of operations.
*   **Limited parallelism within basic blocks:** The amount of parallelism available within a basic block (a straight-line code sequence with no internal branches) is quite small. For typical programs, exploiting substantial performance requires overcoming these basic block limits to find ILP across multiple blocks, often within loops.
*   **Recurrences and unnecessary dependences:** Dependences arising from recurrences (such as a loop control variable being incremented in every iteration) or specific code generation conventions (like using return address registers or stack pointers) unnecessarily limit parallelism. Aggressive algebraic optimization or loop unrolling may be required to remove these constraints.
*   **WAW and WAR hazards through memory:** While register renaming eliminates Write-After-Write (WAW) and Write-After-Read (WAR) hazards through registers, these hazards can still arise in memory, particularly due to stack frame allocation where called procedures reuse memory locations, creating WAW and WAR hazards that unnecessarily limit performance.
*   **Control flow (branches):** Branches introduce control dependences, determining whether a subsequent instruction should execute. Although branch prediction helps reduce control stalls, mispredictions lead to wasted work (misspeculation), which is typically much higher for integer programs than floating-point programs.

##### 2b. Hardware and Implementation Limitations

These constraints relate to the practical costs and complexity of building real-world processors capable of exploiting high degrees of ILP:

*   **Complexity and bottlenecks in dynamic scheduling:**
    *   **Issue logic complexity:** The step of issuing multiple instructions per clock in a dynamically scheduled processor is fundamentally complex because multiple instructions may depend on one another. The necessary logic to determine dependences and update reservation tables in a single clock cycle becomes a **chief bottleneck** and a major factor limiting issue width to typically four instructions per clock.
    *   **Hardware overhead:** Dynamic scheduling techniques like Tomasulo's algorithm require substantial, complex hardware, including large associative buffers and control logic.
*   **Code size and tegisterpressure in static scheduling (VLIW):**
    *   **Code size:** Techniques like aggressive loop unrolling, necessary to expose sufficient ILP for wide-issue machines (like VLIW), increase code size significantly. This increase can potentially hurt performance by raising the instruction cache miss rate.
    *   **Register pressure:** Aggressive unrolling and scheduling increase the number of live values, leading to **register pressure** (a shortage of available registers), which can necessitate generating memory traffic (spills) and negate performance gains.
*   **Memory latency and the memory wall:**
    *   **Cache misses:** Although dynamic scheduling and speculation can hide the latency of short delays (like L1 cache misses), they struggle to hide the latency of L2 or L3 misses going to main memory (which can be 50 to 135 cycles or more).
    *   **Non-unit latencies:** Longer latencies in functional units increase the frequency of Read-After-Write (RAW) hazards and resultant stalls.
*   **Lack of binary compatibility (VLIW):** Early VLIW processors required code sequences that depended on the specific pipeline structure and latencies. Migrating code to new implementations required recompilation, which was a major logistical drawback compared to superscalar designs.
*   **Power and efficiency:** Trying to extract significantly more ILP via wider issue and speculation is highly **inefficient** in terms of silicon utilization and power consumption. The costs of very aggressive speculation (wasted energy, additional silicon area for recovery mechanisms) are generally too high to justify the limited performance gains observed.
*   **Stall synchronization (early VLIW):** Early VLIWs operated in lockstep, meaning a stall in any functional unit pipeline caused the entire processor to stall. This was unacceptable as issue rates increased, especially when encountering unpredictable cache stalls.

#### Summary of Diminishing Returns

Studies indicate that pushing ILP beyond moderate levels (e.g., beyond four issues per clock) is extremely difficult. For practical, cost-effective processors, the actual performance levels achieved are significantly lower than theoretical limits.

The eventual recognition that pushing ILP further was fundamentally inefficient led designers to moderate ILP exploitation and shift focus toward **Thread-Level Parallelism (TLP)**, using techniques like Simultaneous Multithreading (SMT) and integrating more cores (multicore architectures) to utilize the increasing transistor budget.

### 3. Data-Level Parallelism (DLP) via SIMD

DLP arises when many data items can be operated on simultaneously, like in vector processors, or GPUs. Learning this involves introducing **Single Instruction, Multiple Data (SIMD) processing on CPUs**.

*   **SIMD instruction extensions:** This includes studying SIMD instruction set extensions (like multimedia extensions; x86 MMX) which exploit DLP by applying the same instruction to multiple data items in parallel.
*   **Concepts:** Understanding SIMD concepts helps transition to the massive parallelism seen in specialized architectures like GPUs.

### 4. Thread-Level Parallelism (TLP)

TLP arises because tasks of work can operate independently and in parallel. Unlike ILP, TLP is **explicitly parallel**, requiring the programmer to restructure the application. Remember, no more "free lunch."

*   **Multicore architectures:** Study focuses on architectures that exploit TLP, namely **multicore processors** and shared-memory multiprocessors.
*   **Coherence and synchronization:** Key challenges to learn involve addressing the cost of communication, **cache coherence protocols** (snooping and directory-based schemes) necessary when shared data is cached, and basic **synchronization mechanisms** (like locks and barriers) built using hardware primitives (e.g., atomic read and modify operations).
*   **Multithreading:** Learning includes how **multithreading** (such as simultaneous multithreading or SMT, used in processors like the Intel Core i7) can be used to exploit TLP to improve processor throughput by using multiple threads to hide pipeline and memory latencies.

The multithreading technology utilized by the Intel Core i7 processor is Simultaneous Multithreading (SMT). While the term "Hyper-Threading Technology" (often abbreviated as HT) has historically been associated with Intel's implementation of SMT (seen referenced on older processors like the Pentium 4), the sources explicitly confirm that the Intel Core i7 is an SMT processor:
* The Intel Core i7 is described as an out-of-order execution processor that includes four cores.
* The i7 can support up to two simultaneous threads per processor.
* The technique used to achieve this is called simultaneous multithreading (SMT).
* The Intel Core i7 is explicitly cited as an example of a processor that uses SMT.
* The i7 supports SMT with two threads.

**Context of Simultaneous Multithreading**

SMT is characterized as the most common implementation of multithreading, which naturally arises when fine-grained multithreading is deployed on a multiple-issue, dynamically scheduled processor. The core purpose of SMT is to leverage thread-level parallelism (TLP) to hide long-latency events within a processor, thereby increasing the utilization of functional units.

SMT operates using the insight that a dynamically scheduled processor already has the necessary hardware (such as a large virtual register set) needed to support the mechanism. Although instructions from different threads can execute in the same cycle using the dynamic scheduling hardware, in all existing SMT implementations, instructions issue from only one thread at a time. The Intel Core i7 fits this profile, using an aggressive, four-issue dynamically scheduled speculative pipeline structure.

## Let's Practice Vocabulary

What does **multiple-issue, dynamically scheduled processor** mean?

The phrase "multiple-issue, dynamically scheduled processor" describes a type of CPU architecture that is designed to aggressively exploit ILP by executing many instructions simultaneously and often out of their original program order.

This architecture is defined by two key concepts:
### 1. Multiple Issue (Superscalar)

"Multiple issue" means that the processor can fetch, decode, and try to start the execution of more than one instruction per clock cycle. Processors with this capability are generally called superscalar processors.

* Goal: The primary goal of multiple issue is to reduce the Cycles Per Instruction (CPI) to less than one, thereby maximizing the utilization of the processor's functional units.
* Implementation: Multiple-issue processors can be classified into three major categories, one of which is the dynamically scheduled superscalar processor. They require wide datapaths, large instruction queues, and complex issue logic to handle multiple instructions simultaneously. For instance, the Intel Core i7 is a multiple-issue processor that can execute up to four $80\mathrm{x}86$ instructions per clock cycle.

### 2. Dynamically Scheduled Processor (Out-of-Order Execution)
"Dynamically scheduled" means that the hardware itself rearranges the execution order of instructions at runtime to reduce pipeline stalls while strictly maintaining data flow and exception behavior. This is also known as out-of-order execution.

* Mechanism: Dynamic scheduling separates the instruction issue process (checking for structural hazards) from the operand reading process (waiting for the absence of data hazards). This allows an instruction to begin execution as soon as its data operands are available, even if earlier instructions are stalled (in-order issue, out-of-order execution).
* Key Advantage: Dynamic scheduling enables the processor to tolerate unpredictable delays, such as those caused by cache misses, by executing other independent instructions while waiting for the delay to resolve. This capability makes dynamically scheduled processors (like the Intel Core series) dominant in the desktop and server markets.
* Implementation: Dynamically scheduled processors often use techniques like Tomasulo's algorithm to manage data hazards (RAW) and name dependences (WAW and WAR) through hardware-based register renaming. They frequently incorporate hardware-based speculation to overcome control dependences by executing instructions along a predicted path before the branch outcome is definitively known.

### Some Examples

The combination of these concepts forms the microarchitecture used in most high-end CPUs:
* Intel Core i7: This is a prime example, using an aggressive four-issue, dynamically scheduled, speculative pipeline structure.
* Superscalar (Speculative): This is the category that includes the Intel Core i3, i5, and i7, as well as the AMD Phenom and IBM Power 7.

In contrast, other types of processors, such as the ARM Cortex-A8, use a statically scheduled superscalar approach (relying on the compiler for scheduling).

## Parking Lot for Week 3

### Tomasulo's Algorithm

**Tomasulo's algorithm** is a sophisticated **dynamic scheduling** technique used in pipelined processors, originally invented by Robert Tomasulo for the floating-point unit of the IBM 360/91.

This scheme enables **out-of-order execution** of instructions to maximize performance. It has proven to be particularly effective since it allows processors to tolerate unpredictable delays, such as those caused by cache misses, by continuing to execute other instructions while waiting for the delay to resolve.

### Key Mechanisms and Components

The algorithm relies on two primary mechanisms:

1.  **Hazard Minimization:** It tracks when instruction operands are available to minimize **Read-After-Write (RAW) hazards**.
2.  **Register Renaming:** It introduces register renaming in hardware to minimize **Write-After-Write (WAW) and Write-After-Read (WAR) hazards**.

This mechanism involves several architectural components:

*   **Reservation Stations (RS):** These stations buffer the operands of instructions waiting to execute. They fetch and buffer an operand as soon as it is available, preventing the need to fetch it from a register later. When an instruction issues, its register specifiers are renamed to the names of the reservation station that will provide the operand values, effectively acting as **extended virtual registers**.
*   **Common Data Bus (CDB):** This is a shared result bus used to broadcast results from functional units (like FP adders or multipliers) directly to the register file and to any waiting reservation stations and store buffers. This broadcast capability implements the necessary forwarding and bypassing.

### The Three Steps of Execution

In a Tomasulo-based processor, an instruction typically goes through three steps after leaving the instruction unit:

1.  **Issue:** The next instruction is retrieved from the Instruction Queue (which maintains FIFO order). If an available matching reservation station exists, the instruction is issued to it. If operands are immediately available, they are stored in the reservation station; otherwise, the station keeps track of the functional units (using tags) that will produce the needed operands. This step handles **register renaming**, thereby eliminating WAW and WAR hazards.
2.  **Execute:** If one or more operands are missing, the instruction monitors the CDB. When all necessary operands arrive, the operation begins execution at the corresponding functional unit, which avoids **RAW hazards** by delaying execution until operands are ready.
3.  **Write Result:** The result is broadcast on the CDB to the register file and all reservation stations that are waiting for that result.

### Advantages and Applications

Tomasulo's approach offers several significant advantages over earlier, simpler techniques like scoreboarding:

*   **Distributed Control:** Hazard detection and execution control logic are distributed among the reservation stations.
*   **Hazard Elimination:** It specifically eliminates stalls arising from WAW and WAR hazards via register renaming.
*   **Dynamic Loop Unrolling:** When applied to loops, the dynamic renaming effectively unrolls the loop, allowing multiple iterations to proceed in parallel without explicit code modification. This allows successive executions of a loop to overlap.

The complexity of the hardware required (particularly associative buffers) is considered a major drawback, along with potential performance limits imposed by having a single CDB.

**Extension:** Tomasulo's algorithm forms the basis for modern speculative processors. By adding an instruction **commit** phase and a **Reorder Buffer (ROB)**, the concepts of dynamic scheduling can be extended to handle speculation and maintain precise exception handling.

### Tomasulo's Algorithm in short description

**Tomasulo's algorithm** is a dynamic scheduling technique developed by Robert Tomasulo for the floating-point unit of the IBM 360/91. It is designed to maximize processor performance by enabling **out-of-order execution** of instructions.

This approach achieves performance gains by implementing two crucial mechanisms:

1.  **Hazard Minimization:** It tracks when instruction operands become available to minimize **Read-After-Write (RAW) hazards**.
2.  **Register Renaming:** It uses hardware renaming to dynamically eliminate **Write-After-Write (WAW) and Write-After-Read (WAR) hazards**.

#### Key Components

The algorithm relies on several specialized structures:

*   **Reservation Stations (RS):** These buffers hold instructions that have been issued and are awaiting execution at a functional unit. They perform register renaming by replacing register specifiers with the names (tags) of the reservation stations that will produce the required operands. Hazard detection and execution control are distributed across these stations.
*   **Common Data Bus (CDB):** A shared bus used to **broadcast results** from functional units (like FP adders or load units) to the register file and to all waiting reservation stations simultaneously. This mechanism implements forwarding and bypassing.

#### Execution Flow

An instruction moves through three main steps after leaving the instruction unit, although each step can take an arbitrary number of clock cycles:

1.  **Issue:** Instructions are issued in order from the Instruction Queue to an available Reservation Station. Operands that are immediately available are stored; otherwise, the instruction records the name of the reservation station (the tag) that will produce the result.
2.  **Execute:** Instructions wait in the Reservation Station until all their source operands are available (indicated by zero in the tag fields). Execution then begins, potentially out of the original program order.
3.  **Write Result:** The result is broadcast on the CDB to any functional units, registers, or buffers waiting for that value.

Tomasulo's scheme was widely adopted in processors starting in the 1990s because out-of-order execution effectively **hides all or part of unpredictable memory latency** (such as cache miss penalties) by allowing independent instructions to continue executing. However, its complexity requires a large amount of hardware, including high-speed associative buffers and complex control logic.

### Has Tomasulo's Algorithm been updated?

The concept introduced by **Tomasulo's algorithm**—dynamic scheduling and hardware-based register renaming to enable out-of-order execution—remains a fundamental component of high-performance CPU design (such as the Intel Core i7).

However, modern methodologies have significantly **improved upon** and **extended** Tomasulo's foundational ideas, primarily through the incorporation of **speculation** and by addressing the challenges of parallelism in **GPU architectures**.

Here are the key methodologies that represent improvements or alternatives to the basic Tomasulo's algorithm described for the IBM 360/91:

### 1. Hardware-Based Speculation (Extension of Tomasulo's)

The most critical extension to Tomasulo's algorithm is the addition of **hardware-based speculation**. This technique allows processors to execute instructions along a predicted path (e.g., following a predicted branch outcome) before that outcome is confirmed.

*   **Reorder Buffer (ROB):** Speculation requires separating the execution of an instruction from its definitive completion or **commit**. This separation is managed by adding a **Reorder Buffer (ROB)**. The ROB holds the result of an instruction after execution is complete but before the instruction commits.
*   **In-Order Commit:** Instructions write their results to the ROB, and the processor state (register file or memory) is updated only when the instruction reaches the head of the ROB and is known to be non-speculative (i.e., the branch prediction was correct). This process maintains a **precise interrupt model**, which is a significant advantage over simple Tomasulo's.
*   **Modern Usage:** Processors like the Intel Core i7 utilize this sophisticated approach, which combines dynamic scheduling, multiple instruction issue, and speculation.

### 2. Alternatives to Reorder Buffers (Implementation Variation)

Instead of using a Reorder Buffer (ROB) structure like the one that extends Tomasulo's algorithm, some high-end processors use **explicit register renaming** with a larger physical register set.

*   This approach also builds on the concept of renaming used in Tomasulo's, but the register values temporarily reside in the physical register file itself rather than solely in the ROB.
*   Whether using the ROB or explicit renaming, the hardware must still track instructions and ensure the final update (commit) occurs in strict program order.

### 3. Scoreboarding (Alternative/Simpler Approach)

While Tomasulo's algorithm is preferred for high-performance out-of-order execution due to its ability to handle WAW and WAR hazards via hardware renaming, the older technique of **scoreboarding** is a simpler dynamic scheduling technique.

*   **Suitability:** Scoreboarding may be sufficient for a simpler processor like the two-issue superscalar **ARM Cortex-A8**, whereas a more aggressive four-issue processor like the Intel i7 benefits from Tomasulo's (or its speculative extensions).
*   **Context:** Scoreboarding (used in the CDC 6600) is a gentler introduction to dynamic scheduling than the more complex Tomasulo's scheme.

### 4. GPU Divergence Management (SIMT Architectures)

For massively parallel **Graphics Processing Unit (GPU)** architectures, which operate under the **SIMT (Single Instruction, Multiple Thread)** model, the problem is not about dynamically scheduling independent scalar instructions but rather efficiently managing threads that diverge in control flow (branch divergence).

Research and industry have developed numerous alternatives to manage this divergence, fundamentally differing from the dynamic ILP exploitation sought by Tomasulo's:

*   **SIMT Stack and Convergence:** Modern GPUs achieve thread independence using a **SIMT stack** of predicate masks to manage nested control flow and skip computation entirely for inactive threads.
*   **Alternative Architectures:** Academic work has focused on improving the SIMT execution model by proposing:
    *   **Independent Thread Scheduling:** NVIDIA's approach for the Volta architecture, designed to avoid **SIMT deadlock**, a new form of circular dependence that can occur with stack-based divergence management.
    *   **Multi-Path Execution:** Techniques like Dynamic Warp Subdivision (DWS) and Multi-Path Execution (MPM) allow threads in a single *warp* (a fundamental execution unit) that follow divergent paths to execute concurrently, boosting Thread-Level Parallelism (TLP).
    *   **Thread Frontiers:** This approach departs from the SIMT stack by tracking each thread's Program Counter (PC) and prioritizing threads with lower PCs to implicitly force reconvergence, offering higher SIMD efficiency for unstructured control flow.

### 5. Static Scheduling Approaches (VLIW/Compiler-Driven)

While not a direct replacement for dynamic scheduling, **statically scheduled** architectures like **VLIW** (Very Long Instruction Word) represent an alternative methodology that shifts the burden of finding and scheduling parallelism entirely to the compiler.

*   **ILP Goal:** VLIW achieves high ILP by grouping multiple independent operations into a single, wide instruction word.
*   **Context:** VLIW was considered for high-end microprocessors (e.g., Intel Itanium) but was ultimately unsuccessful outside specialized domains like high-performance embedded systems (e.g., TI VelociTI 320C6x DSPs), largely because they lack the runtime flexibility of dynamically scheduled processors to hide unpredictable latencies (like cache misses). VLIW processors are preferred in embedded systems where memory latencies are often predictable and the overhead of dynamic scheduling is deemed wasteful of power and chip area.

# Week 4

## Instruction Level Parallelism (ILP)

## Design Documentation for the Out-of-Order CPU

The following provides a detailed explanation of the SystemVerilog-based out-of-order (OoO) processor, its testbench, and the expected behavior of the sample program.

**NOTE**: Running this SystemVerilog code on `iverilog` will create the following compilation errors due to the a bug in `iverilog` which cannot handle assignments to fields within an array of `structs`. To experience this code to see how a re-order buffer (ROB) works, run it in [EDA Playground](https://www.edaplayground.com/) and configure to use SystemVerilog/Verilog as the Testbench + Design, as well as choose Cadence Xcellium 23.09 as the Tools & Simulators. Here is an [example](https://www.edaplayground.com/x/h_Pv) running already.

The `-g2012` flag is the most important configuration setting, and it is set correctly. There are no other flags that would change this fundamental behavior.

The issue we are facing is a well-known limitation of many non-commercial or older versions of `iverilog`. While the SystemVerilog-2012 *standard* says that assigning to fields of structs inside an array is perfectly legal, the `iverilog` *program* does not have a complete or bug-free implementation of that part of the standard.

Detailed cause of errors using `iverilog`
* __Warning:__ `sorry: Assignment to an entire array or to an array slice is not yet supported.` This warning is erroneously triggered for every line in the `initial` block where a value is assigned to a field of the `instr_mem` array (e.g., `instr_mem[0].opcode = MUL;`).
* __Crash:__ The compiler's inability to handle this valid syntax leads to an internal crash (`Abort trap: 6`).


__In summary__: The code is correct according to the SystemVerilg language rules, and the compiler is configured correctly to use those rules. However, the compiler program itself has a bug that makes it crash when it sees this specific, valid code pattern. So run it in EDA Playground.

### 1. CPU Design (`cpu.sv`)

The `cpu.sv` module implements a simplified superscalar, out-of-order processor based on the **Tomasulo algorithm**. The primary goal of this architecture is to exploit **Instruction-Level Parallelism (ILP)**, allowing independent instructions to execute as soon as their operands are ready, rather than being stalled by preceding, long-latency instructions.

#### Key Architectural Components

The processor is built around several key data structures that manage the out-of-order execution and in-order retirement of instructions.

*   **Instruction Memory (`instr_mem`)**: A simple ROM that holds the assembly program to be executed.
*   **Dispatch & Rename Logic**: This is the in-order front-end of the pipeline. It fetches instructions sequentially, allocates resources, and performs register renaming.
*   **Register Alias Table (RAT)**: A mapping table that is central to register renaming. It tracks which future instruction (identified by its ROB tag) will produce the next value for each architectural register. This is what eliminates false dependencies (WAR and WAW hazards).
*   **Reservation Stations (RS)**: A buffer where instructions wait after being dispatched. Each entry holds an instruction's opcode, its operand values (or the tags of the ROB entries that will produce them), and its destination ROB tag. An instruction is issued to a functional unit only when all its operands are valid.
*   **Functional Units (FUs)**: The hardware that performs the actual calculations (e.g., an Adder and a Multiplier). In this design, the `ADD` unit has a 1-cycle latency, and the `MUL` unit has a 3-cycle latency.
*   **Common Data Bus (CDB)**: A shared bus that broadcasts the results from completed functional units to all reservation stations and the Re-Order Buffer. This is the critical datapath that allows results to be forwarded directly to waiting instructions without first being written to the register file.
*   **Re-Order Buffer (ROB)**: A circular buffer that tracks all in-flight instructions in their original program order. It stores the instruction's state, its result, and its original destination register. The ROB ensures that even though instructions execute out-of-order, they are committed (retired) in-order.
*   **Architectural Register File (ARF)**: The programmer-visible register file. It holds the committed state of the machine. The ARF is only updated when an instruction at the head of the ROB commits.

### Pipeline Flow

1.  **Dispatch**: The CPU fetches an instruction from `instr_mem`. It allocates the next available entries in the ROB and a Reservation Station. It then uses the RAT to rename the instruction's source and destination registers. Source operands are either read directly from the ARF (if no pending instruction is writing to them) or tagged with the ROB entry that will produce their value.
2.  **Execute**: The Reservation Stations monitor the CDB. When an instruction in an RS has all of its operands valid, it is issued to a functional unit.
3.  **Writeback**: When a functional unit completes its calculation, it requests access to the CDB. The result, along with the instruction's ROB tag, is broadcast on the CDB. All waiting RS entries and the instruction's own ROB entry capture this result.
4.  **Commit**: The logic monitors the instruction at the `rob_head`. If that instruction's result is ready in the ROB, its result is written to the ARF, and the instruction is removed from the ROB. This process is strictly in-order.

## 2. Testbench Design (`tb_cpu.sv`)

The `tb_cpu.sv` module is a simple test harness designed to provide the necessary stimulus to run and verify the `cpu` module (the Design Under Test, or DUT).

Its responsibilities are:
*   **Instantiation**: It creates an instance of the `cpu` module.
*   **Clock Generation**: It generates a periodic clock signal to drive the synchronous logic within the CPU.
*   **Reset Generation**: It asserts a `rst` signal at the beginning of the simulation to initialize the CPU to a known state, and then de-asserts it to allow the program to run.
*   **Simulation Control**: It allows the simulation to run for a fixed duration (200ns) to ensure all instructions have time to complete and commit.
*   **Result Verification**: At the end of the simulation, it prints the final values of all registers in the Architectural Register File (ARF), allowing for a simple pass/fail check.
*   **Waveform Dumping**: It includes commands (`$dumpfile`, `$dumpvars`) to generate a Value Change Dump (`.vcd`) file. This file can be loaded into a waveform viewer like GTKWave to visually debug the signals inside the CPU on a cycle-by-cycle basis.

## 3. Expected Program Result

The CPU is hard-coded with the following four-instruction program:

```assembly
// Initial ARF values: R1=11, R2=12, R5=15, R7=17
0: MUL R3, R1, R2   // R3 <- 11 * 12
1: ADD R4, R1, R5   // R4 <- 11 + 15
2: ADD R6, R2, R7   // R6 <- 12 + 17
3: ADD R1, R4, R6   // R1 <- (new R4) + (new R6)
```

### Step-by-Step Calculation

1.  `MUL R3, R1, R2`: `R3` will be `11 * 12 = 132`.
2.  `ADD R4, R1, R5`: `R4` will be `11 + 15 = 26`.
3.  `ADD R6, R2, R7`: `R6` will be `12 + 17 = 29`.
4.  `ADD R1, R4, R6`: This instruction depends on the results of the previous two `ADD`s. The processor will forward these results (`26` and `29`) to this instruction. `R1` will be `26 + 29 = 55`.

### Final Architectural Register File (ARF) State

The expected final values in the ARF are:

| Register | Initial Value | Final Value |
| :------- | :------------ | :---------- |
| `ARF[0]` | 10            | 10          |
| `ARF[1]` | 11            | **55**      |
| `ARF[2]` | 12            | 12          |
| `ARF[3]` | 13            | **132**     |
| `ARF[4]` | 14            | **26**      |
| `ARF[5]` | 15            | 15          |
| `ARF[6]` | 16            | **29**      |
| `ARF[7]` | 17            | 17          |

## 4. System-Level Datapath Diagram

The following ASCII diagram illustrates the high-level connections between the major components of the CPU.

```
              +-----------------+
              | Instr. Memory   |
              +-----------------+
                     |      ^
        (PC) |      | (Instruction)
             V      |
      +------------------------------------------------+
      |      Dispatch / Decode / Rename Logic          |
      |                                                |
      |  +-----------------+                           |
      |  | Register Alias  |<-+                        |
      |  | Table (RAT)     |  | (Update Tag)           |
      |  +-----------------+  |                        |
      +-----------|-----------|------------------------+
                  |           |
(Instr. + Operands|/ Tags)    | (Dest. Tag)
                  |           |
     +------------V-----------V------------+
     |    Reservation Stations (RS)        |
     | +------+  +------+  +------+        |
     | | RS 0 |  | RS 1 |..| RS n |        |
     | +------+  +------+  +------+        |
     +-----|--------------------^----------+
           | (Issue)            | (Result from CDB)
           |                    |
+----------V----------+ +-------V---------+
|      ADD Unit       | |      MUL Unit     |
+---------------------+ +-----------------+
           |                    |
           +----------+---------+
                      | (Result + ROB Tag)
                      V
<===================================================>
<=============== Common Data Bus (CDB) =============>
<===================================================>
       |           ^              ^
       |           |              | (Result + Tag)
(Result|/ Tag)     |              |
       |   (Listen for Tags)      |
       V                          |
+----------------+         +--------------------------+
| Re-Order       |         | Architectural            |
| Buffer (ROB)   |-------->| Register File (ARF)      |
|                | (Commit)|                          |
+----------------+         +-----------^--------------+
                                       | (Read Operands)
                                       |
                                       + (from Dispatch)
```
## If using a single Common Data Bus (CDB) above

Possible output without use of CDBs:
```
The following is the result  from running in EDA Playground using the xcelium simulator. Is the output correct for the example program?

----------------- SIMULATION START -----------------
[15] DISPATCH: Instr ''{opcode:MUL, rd:'h3, rs1:'h1, rs2:'h2}' from PC=0 to ROB[0], RS[0]
[25] EXECUTE-ISSUE: RS[0] for ROB[0] is starting execution.
[25] DISPATCH: Instr ''{opcode:ADD, rd:'h4, rs1:'h1, rs2:'h5}' from PC=1 to ROB[1], RS[1]
[35] EXECUTE-ISSUE: RS[1] for ROB[1] is starting execution.
[35] DISPATCH: Instr ''{opcode:ADD, rd:'h6, rs1:'h2, rs2:'h7}' from PC=2 to ROB[2], RS[2]
[45] EXECUTE-FINISH: RS[1] for ROB[1] will broadcast.
[45] EXECUTE-ISSUE: RS[2] for ROB[2] is starting execution.
[45] DISPATCH: Instr ''{opcode:ADD, rd:'h1, rs1:'h4, rs2:'h6}' from PC=3 to ROB[3], RS[3]
[55] WRITEBACK: CDB has result for ROB[1].
[55] EXECUTE-FINISH: RS[0] for ROB[0] will broadcast.
[55] EXECUTE-FINISH: RS[2] for ROB[2] will broadcast.
[65] WRITEBACK: CDB has result for ROB[2].
[75] EXECUTE-ISSUE: RS[3] for ROB[3] is starting execution.
[85] EXECUTE-FINISH: RS[3] for ROB[3] will broadcast.
[95] WRITEBACK: CDB has result for ROB[3].

Final Register Values:
ARF[0] =  10
ARF[1] =  11
ARF[2] =  12
ARF[3] =  13
ARF[4] =  14
ARF[5] =  15
ARF[6] =  16
ARF[7] =  17
```

### Analysis of the Incorrect Output

Let's look at two key pieces of evidence:

1. __The Final Register Values:__

   ```
   Final Register Values:
   ARF[0] =  10
   ARF[1] =  11
   ...
   ARF[7] =  17
   ```

   These are the initial values you set during reset. None of the registers that should have been written to (`R1`, `R3`, `R4`, `R6`) have been updated. This tells us that the __Commit Stage__ is not working. No results are ever being written back to the architectural register file.

2. __The Simulation Log:__ Look closely at the log at time `55`:

   ```
   [55] WRITEBACK: CDB has result for ROB[1].
   [55] EXECUTE-FINISH: RS[0] for ROB[0] will broadcast.
   [55] EXECUTE-FINISH: RS[2] for ROB[2] will broadcast.
   [65] WRITEBACK: CDB has result for ROB[2].
   ```

Here's the problem: At time `55`, two instructions finish execution at the exact same time: the `MUL` for ROB[0] and the `ADD` for ROB[2].

The previous processor design had only __one Common Data Bus (CDB)__. This is a shared resource used to broadcast results. When two instructions try to use it in the same cycle, you have a __structural hazard__. In the current code, the `for` loop that checks for finished instructions will allow the last instruction it finds (the `ADD` for ROB[2]) to win access to the bus.

As a result:

   - At `t=65`, the result for ROB[2] is correctly broadcast.
   - The result for the `MUL` instruction in ROB[0] is __lost forever__. It never gets a chance to use the CDB.
   - Because the result for ROB[0] is never broadcast, its entry in the ROB is never marked as `ready`.
   - The Commit Stage is permanently stalled, because it is waiting for the instruction at the head of the buffer (ROB[0]) to become `ready`, which it never will.

### The Fix

A production-quality CPU would have multiple CDBs or complex arbitration logic. For our academic model, we can implement a simpler solution: we will add a flag to ensure only one instruction can broadcast on the CDB per clock cycle. This will correctly serialize the results and prevent any from being lost.



