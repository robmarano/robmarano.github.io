# ECE 251: Week 14 Speaking Notes

## Class Timeline (6:05 PM – 8:50 PM)

- **6:05 PM – 6:15 PM:** Welcome & Week 13 Retrospective (Slides 1-3)
- **6:15 PM – 6:45 PM:** Section 5.4: Cache Performance & Multi-Level Caching (Slides 4-8)
- **6:45 PM – 7:10 PM:** Hardware Realization in SystemVerilog (Slides 9-11)
- **7:10 PM – 7:25 PM:** Mathematical Proof of Performance (Slides 12-15)
- **7:25 PM – 7:40 PM:** **[SCHEDULED BREAK - 15 MINUTES]**
- **7:40 PM – 8:00 PM:** Section 5.5: Dependable Memory & ECC (Slides 16-21)
- **8:00 PM – 8:20 PM:** Section 5.6: Virtual Memory, Page Faults, and the TLB (Slides 22-26)
- **8:20 PM – 8:45 PM:** Section 5.8: Official Textbook Practice Problems (Slides 27-63)
- **8:45 PM – 8:50 PM:** Conclusion & Q&A (Slides 64-65)

------

## 6:05 PM: Introduction & Retrospective

**Slide 1: Title Slide** "Good evening. Tonight, we cover Week 14: Memory Hierarchies, Part 2. This session concludes our architectural progression from boolean logic to the highest levels of modern microprocessor memory systems."

**Slide 2: Week 13 Retrospective** "Before we advance, let us review the structural foundations established in Week 13. Caches operate on the Principle of Locality—both Temporal and Spatial. We utilize fast, expensive SRAM for cache cells and slower, denser DRAM for main memory. Recall our three mapping topologies: Direct-Mapped, Fully Associative, and Set-Associative. Finally, the critical metric for memory performance is Average Memory Access Time, or AMAT, calculated as Hit Time plus the product of Miss Rate and Miss Penalty."

**Slide 3: Agenda** "Tonight's agenda is divided into six segments. We will quantify cache performance and the 'Memory Wall,' examine the SystemVerilog realizations of multi-level cache controllers, mathematically prove the speedup of these topologies, introduce error detection and correction for dependable memory, formalize Virtual Memory mechanics, and conclude by solving nine official textbook practice problems."

------

## 6:15 PM: Cache Performance & Multi-Level Caching

**Slide 4: The Memory Hierarchy Pyramid** "Observe Figure 5.1. The hierarchy is organized by latency and capacity. We place small, low-latency SRAM close to the core, backed by larger DRAM, and finally backed by massive, high-latency magnetic or solid-state disk storage."

**Slide 5: The Memory Wall & Hiding Penalties** "The 'Memory Wall' describes the divergence between processor execution speed and DRAM access latency. Modern CPUs execute instructions exponentially faster than DRAM can supply data. To mitigate this bus bandwidth bottleneck, superscalar architectures employ out-of-order execution to bypass stalled instructions and non-blocking caches to continue processing hits while resolving a prior miss."

**Slide 6: Reducing Miss Rate: The Three C's** "Misses fall into three categories. First, Compulsory misses—unavoidable on initial access, mitigated by increasing block size to leverage spatial locality. Second, Capacity misses—occurring when the working set exceeds the cache volume, mitigated by increasing the total cache size. Third, Conflict misses—occurring when multiple addresses map to the same index, mitigated by increasing the set associativity."

**Slide 7: Reducing Miss Penalty: Multi-Level Caches** "To prevent a 100-cycle stall to Main Memory on an L1 miss, modern architectures implement multi-level caches. The L1 cache is tightly coupled to the processor pipeline and is optimized strictly for minimum Hit Time. The L2 cache is larger, slightly slower, and is optimized for a minimum Miss Rate to intercept requests before they reach the DRAM bus."

**Slide 8: The Multi-Level AMAT Formula** "With the introduction of an L2 cache, the AMAT formula expands. The L1 Miss Penalty is no longer a static DRAM access time; it is replaced by the AMAT of the L2 cache itself—specifically, the L2 Hit Time plus the product of the L2 Miss Rate and the L2 Miss Penalty."

------

## 6:45 PM: Hardware Realization (SystemVerilog)

**Slide 9: SystemVerilog Review: Direct-Mapped Hit Logic** "Reviewing the hardware implementation, a Direct-Mapped controller physically slices the 32-bit address into an index and a tag. The index directly addresses the SRAM arrays to extract the stored tag and valid bit. Combinational logic then asserts a cache hit if the valid bit is high and the tags match exactly."

**Slide 10: SV Upgrade: 2-Way Set Associative** "To eliminate Conflict Misses, we implement a 2-Way Set Associative controller. The index width decreases by one bit, expanding the tag by one bit. We instantiate two parallel hardware comparators, 'Way 0' and 'Way 1'. A global hit is resolved via a logical OR gate, and the specific hitting way governs a downstream data multiplexer."

**Slide 11: SV Upgrade: Multi-Level L1/L2 Handshake** "Integrating the L1 and L2 controllers requires pipeline stall logic. The CPU must halt if an L1 read request misses and the data has not yet been resolved by the L2 cache or the DRAM controller. The data routing multiplexer conditionally supplies `cpu_read_data` from either the L1 SRAM or the L2 SRAM upon hit resolution."

------

## 7:10 PM: Mathematical Proof of Performance

**Slide 12: The Iron Law & Effective CPI** "We will now quantify the necessity of this hardware complexity using the Iron Law of Performance. Consider a baseline processor with a theoretical CPI of 1.0. Memory instructions constitute 30% of the workload. The L1 miss rate is 5%, and the DRAM penalty is a strict 100 cycles."

**Slide 13: Scenario A: L1 Cache Only** "In Scenario A, lacking an L2 cache, an L1 miss incurs the full 100-cycle DRAM penalty. Calculating the stalls yields 1.5 additional cycles per instruction. Adding this to the base CPI yields an Effective CPI of 2.5. The processor is operating 2.5 times slower than its theoretical capability due exclusively to memory latency."

**Slide 14: Scenario B: Adding the L2 Cache** "In Scenario B, we introduce an L2 cache with a 10-cycle hit time and a local miss rate of 20%. The L1 miss penalty drops from 100 cycles to 30 cycles. Recalculating the stall cycles yields 0.45 stalls per instruction, resulting in a new Effective CPI of 1.45."

**Slide 15: The Conclusion: Performance Speedup** "Comparing the two architectures, the addition of the L2 cache reduces the execution time by 42%. This yields a 1.72x speedup for the processor without any alterations to the clock frequency or the Instruction Set Architecture."

------

## 7:25 PM: [SCHEDULED BREAK]

"We will now take a 15-minute break. Please return promptly at 7:40 PM as we transition to Dependable Memory and Virtual Memory mechanisms."

------

## 7:40 PM: Dependable Memory

**Slide 16: The Vulnerability of DRAM** "Welcome back. Section 5.5 addresses Dependable Memory. As semiconductor fabrication scales to smaller nanometer nodes, SRAM and DRAM become highly susceptible to soft errors induced by cosmic rays. A DRAM bit is represented by a single microscopic capacitor and transistor. A particle strike can discharge this capacitor, resulting in a bit flip. Dependable systems require hardware to detect and correct these physical faults."

**Slide 17: Measures of Dependability** "We quantify dependability using two metrics. Reliability is measured as Mean Time To Failure, or MTTF. Availability is the fraction of continuous service time, calculated mathematically as MTTF divided by the sum of MTTF and the Mean Time To Repair, or MTTR."

**Slide 18: Error Detection and Correction (EDC)** "The baseline EDC mechanism is the Parity Bit, which ensures the total number of '1's in a word remains either strictly even or odd. Parity detects single-bit errors but cannot correct them. Server architectures require SEC/DED—Single Error Correction, Double Error Detection—implemented via Hamming Codes. By establishing overlapping parity equations, the hardware isolates the exact bit that flipped."

**Slide 19: Hamming Code Generation** "Figure 5.23 visualizes the Hamming logic. The check bits are interspersed at power-of-two positions, forcing the data bits into intersecting logical circles. If a bit flips, it breaks a specific, unique combination of these equations."

**Slide 20: SV Realization: Even Parity Generator** "In SystemVerilog, generating an even parity bit requires exactly one line of code: the unary XOR reduction operator. This synthesizes to a parallel XOR tree that computes the parity instantly."

**Slide 21: SV Realization: Hamming Syndrome Decoder** "To decode the Hamming syndrome, the controller simultaneously processes three parity equations. The outputs of these equations are concatenated into a 3-bit syndrome vector. If the syndrome equals binary 101, or decimal 5, the hardware possesses mathematical proof that bit 5 is corrupted and instantly inverts it."

------

## 8:00 PM: Virtual Memory

**Slide 22: Virtual Memory Concepts** "Moving to Virtual Memory. While caches simulate fast memory, Virtual Memory simulates infinite, isolated memory. Memory is partitioned into Pages, typically 4KB in size. The software utilizes Virtual Addresses, which the Memory Management Unit translates to Physical Addresses via the Page Table—a rigid mapping structure stored in DRAM."

**Slide 23: Page Faults** "Virtual Memory treats DRAM as a cache for the Magnetic Disk. When a requested Virtual Page is not resident in DRAM, the system registers a Page Fault. Because disk access latencies are tens of millions of cycles, the CPU cannot simply stall. It triggers a hardware exception, forcing the Operating System to context switch and load the page from disk."

**Slide 24: The Translation Lookaside Buffer (TLB)** "To prevent every memory instruction from requiring a preliminary DRAM read just to query the Page Table, processors include a Translation Lookaside Buffer, or TLB. The TLB is a minuscule, ultra-fast fully associative cache dedicated exclusively to housing recent Virtual-to-Physical translations."

**Slide 25: Parallel Cache & TLB Access** "As shown in Figure 5.28, the TLB and the L1 cache are queried in parallel. The TLB translates the Virtual Page Number into a Physical Page Number while the L1 SRAM concurrently fetches the data using the untranslated offset index."

**Slide 26: SV Realization: Fully Associative TLB Array** "A fully associative TLB in SystemVerilog relies on an unrolled `for` loop. This instantiates a massive parallel bank of comparators, evaluating the requested Virtual Page Number against every stored tag simultaneously to output the Physical Page Number and assert a TLB hit."

------

## 8:20 PM: Interactive Practice Problems

**Slides 27-63: Practice Problems Overview** *(Instructor Note: The remainder of the lecture involves walking through the 9 textbook problems. Use the "Problem" slides to introduce the parameters, allow a brief pause for mental calculation or student input, and then advance to the "Solution" slides to demonstrate the step-by-step mathematical logic.)*

**Slide Key Points to Emphasize during Problems:**

- **Slide 40 (Multi-Level CPI Note):** Ensure you point out the discrepancy between the textbook's "Global" label and its mathematical calculation as a "Local" miss rate.
- **Slide 52 (Hamming Code):** Walk through the syndrome generation slowly to show how equations 1 and 3 failing (but equation 2 passing) points definitively to Bit 5.
- **Slide 60 (Full VM Trace):** Emphasize how Access 1 triggers a Page Fault because the Page Table explicitly states the target is on Disk.

------

## 8:45 PM: Conclusion & Q&A

**Slide 64: Conclusion** "This concludes our journey through the computer architecture stack. Over the semester, we have mathematically and logically bridged the gap from fundamental boolean logic gates to ALUs, Single-Cycle CPUs, pipelined datapaths, SRAM caches, DRAM main memory, and finally Virtual Memory. We have analyzed the foundation of modern, high-performance, fault-tolerant microprocessors."

**Slide 65: Questions** "We have a few minutes remaining before 8:50 PM. I will now open the floor to any questions regarding the memory hierarchy or the calculations we performed tonight."