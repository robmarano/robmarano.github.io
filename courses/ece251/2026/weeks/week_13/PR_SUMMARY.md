# PR Summary: Week 13 Cache Curriculum Expansion

## Objective
The objective of this update is to finalize the Week 13 Memory Hierarchies curriculum for ECE 251. We aim to bridge abstract architectural theory with practical physical hardware realities, specifically focusing on cache topologies, DRAM mechanics, foundational SystemVerilog implementations, and a formal retrospective on the Chapter 4 datapath evolution.

## Key Changes

### 1. Markdown Lecture Notes (`notes_week_13.md`)
*   **Chapter 4 Retrospective:** Replaced the generic introduction with a detailed 5-point retrospective summarizing the architecture evolution: Single-Cycle, Multi-Cycle, Pipelining, Hazard Resolution, and Exceptions.
*   **Conceptual Foundations:** Expanded the introduction to formally define the Memory Hierarchy Pyramid, Principle of Locality (Spatial vs. Temporal), and Hit/Miss terminology.
*   **DRAM Mechanics:** Added a deep dive into the physical reality of DRAM (1T1C architecture, destructive reads, precharge/refresh cycles, and RAS/CAS multiplexing).
*   **Hardware Implementation:** Bridged the gap between concept and code by defining a 3-level SystemVerilog architecture for caches.
*   **Worked Textbook Examples:** Added three highly detailed, step-by-step mathematical examples synthesized from Patterson & Hennessy, Harris & Harris, and Hamacher covering Address Field Breakdown, Direct-Mapped Tracing, and AMAT/CPI calculations.
*   **Bug Fix:** Standardized all image paths to `../../../../../Image Bank/` to correctly resolve against the repository root.

### 2. Lecture Slides (`ece251_week_13_slides.tex`)
*   **Retrospective Slide:** Added a new opening frame explicitly detailing the Chapter 4 architecture evolution right before the Agenda.
*   **Structure:** Created a complete slide deck structured around the new markdown notes (Introduction, DRAM, Cache Architecture, and SystemVerilog).
*   **Worked Examples:** Dedicated three new slides entirely to demonstrating the step-by-step textbook examples to the class.
*   **Rendering Fix:** Enforced a double-pass `pdflatex` build process to ensure the Table of Contents (Agenda slide) correctly populates.
*   **Image Alignment:** Fixed relative paths to ensure `graphicx` can embed the textbook diagrams.

### 3. Architecture Diagrams (`TECH_DESIGN.md`)
*   Created Mermaid UML sequence and block diagrams mapping out the DRAM refresh loop, Cache hit logic, and overall system architecture.

### 4. Cache SystemVerilog Implementation
*   **Pipeline Hazard Fix:** Patched `hazard.sv` to ensure `flushE` and `flushD` are strictly gated during `mem_stall` to prevent instruction dropping during cache misses.
*   **Cache Topologies:** Built and verified `cache_direct_mapped.sv`, `cache_set_associative.sv`, and `cache_fully_associative.sv` with hit/miss logic and `dmem_ready` handshaking.
*   **Memory Wall Simulation:** Implemented a parameterized 10-cycle latency delay into `dmem.sv`.
*   **Hardware Bypass:** Added a `cache_en` switch in `computer.sv` to dynamically route CPU requests to either the L1 Cache or directly to Main Memory.
*   **Performance Counters:** Expanded `tb_computer.sv` to track instruction count, cycles, hits, and misses.
*   **Performance Proof:** Wrote `loop_test.asm` to benchmark temporal locality, resulting in a dramatic reduction in Effective CPI (from 4.34 uncached to 1.89 cached).
*   **Course Notes Integration:** Added the hardware simulation performance results into the global `ece251-notes.md` syllabus.

## Verification
*   LaTeX slide deck successfully compiled without fatal errors and outputs performance metrics.
*   Mermaid diagrams validated for syntax correctness.
*   Markdown previewed successfully.
*   Verilog testbench successfully demonstrated the Cache performance impact mathematically.
