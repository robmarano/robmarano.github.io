# Notes for Week 13
[ &larr; back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html) [ &larr; back to notes](/courses/ece251/2026/ece251-notes.html)

> **[🗂️ Download Week 13 Slides (PDF)](./ece251_week_13_slides.pdf)**

# Memory Hierarchies (Part 1)

## Reading Assignment
*   Read Chapter 5, Sections 5.1 through 5.3 in the textbook (*Computer Organization and Design - MIPS Edition*).

## High-Level Topic Coverage

### 5.1 Introduction to the Memory Hierarchy
Computer architects face a fundamental paradox: processors are incredibly fast, but memory is relatively slow. To keep the processor fed with data without stalling, we rely on the **Principle of Locality**:
*   **Temporal Locality (Locality in Time):** If an item is referenced, it will tend to be referenced again soon. (e.g., loops iterating over the same variables).
*   **Spatial Locality (Locality in Space):** If an item is referenced, items whose addresses are close by will tend to be referenced soon. (e.g., sequentially accessing elements in an array).

We exploit locality by implementing a **Memory Hierarchy**:
<p align="center">
  <img src="../../../../Image Bank/ch005-9780128201091/jpg-9780128201091/005001.jpg" width="60%" alt="Memory Hierarchy Pyramid">
</p>

*   **Top of the hierarchy (closest to CPU):** Fast, small, expensive (e.g., L1/L2 Caches).
*   **Bottom of the hierarchy (furthest from CPU):** Slow, large, cheap (e.g., Magnetic Disk / SSD).

**Key Terminology:**
*   **Block (or Line):** The minimum unit of information that can be either present or not present in a two-level hierarchy.
*   **Hit:** Data requested by the processor appears in some block in the upper level.
    *   **Hit Rate:** The fraction of memory accesses found in the upper level.
    *   **Hit Time:** The time required to access data in the upper level.
*   **Miss:** Data is not found in the upper level.
    *   **Miss Penalty:** The time required to fetch the block from the lower level into the upper level, plus the time to deliver it to the processor.

### 5.2 Memory Technologies
The physical mediums we use dictate the hierarchy:
1.  **SRAM (Static RAM):** Used for caches. It requires no refreshing to keep data (hence "static"). Extremely fast (nanoseconds) but low density and very expensive. Built using 6 transistors per bit.
2.  **DRAM (Dynamic RAM):** Used for main memory. Data is stored as a charge on a capacitor. It must be periodically "refreshed" (hence "dynamic") because the charge leaks. High density, cheaper, but slower than SRAM.
3.  **Flash Memory:** Non-volatile semiconductor memory (EEPROM). Survives power-off. Reads are fast, but writes are significantly slower and physically wear out the memory cells over time (requiring wear leveling).
4.  **Magnetic Disk:** Used for massive secondary storage. Relies on moving mechanical parts (platters and read/write heads). Measured in milliseconds (millions of times slower than SRAM).

### 5.3 The Basics of Caches
The **Cache** is the level of the memory hierarchy closest to the CPU. The simplest way to map memory blocks into the cache is a **Direct-Mapped Cache**.

**Direct-Mapped Caching**
In a direct-mapped cache, each memory block maps to exactly *one* specific block in the cache. 
*   **Mapping Formula:** `(Block address) modulo (Number of blocks in the cache)`
*   Since the number of cache blocks is usually a power of 2, the modulo operation is just the lower $n$ bits of the block address.

<p align="center">
  <img src="../../../../Image Bank/ch005-9780128201091/jpg-9780128201091/005007.jpg" width="60%" alt="Direct Mapped Cache Diagram">
</p>

**Tags and Valid Bits**
Because multiple memory blocks map to the same cache index, we need a way to know exactly *which* memory block is currently sitting in the cache.
*   **Tag:** The upper portion of the address is stored alongside the data. The cache compares the requested address's tag against the stored tag to verify a match.
*   **Valid Bit:** A single bit added to the cache block to indicate whether the block contains valid data (1) or garbage/empty space (0).

**Handling Cache Misses**
When a miss occurs, the control unit must:
1.  Stall the CPU pipeline (suspend execution).
2.  Fetch the requested block from the next lower level of the memory hierarchy (Main Memory).
3.  Write the block into the cache (updating the tag and setting the valid bit).
4.  Restart the instruction that caused the miss.

**Block Size Considerations**
Increasing the block size takes advantage of spatial locality, reducing the miss rate. However, if the block size gets too large compared to the overall cache size, the miss rate can actually *increase* because fewer total blocks can be held in the cache simultaneously (increasing conflict and capacity misses). Additionally, a larger block size increases the *miss penalty* since more data must be fetched from slower memory.
