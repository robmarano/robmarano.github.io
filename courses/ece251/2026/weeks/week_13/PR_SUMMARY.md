# PR Summary: Week 13 Cache Curriculum Expansion

## Objective
The objective of this update is to finalize the Week 13 Memory Hierarchies curriculum for ECE 251. We aim to bridge abstract architectural theory with practical physical hardware realities, specifically focusing on cache topologies, DRAM mechanics, and foundational SystemVerilog implementations.

## Key Changes

### 1. Markdown Lecture Notes (`notes_week_13.md`)
*   **Conceptual Foundations:** Expanded the introduction to formally define the Memory Hierarchy Pyramid, Principle of Locality (Spatial vs. Temporal), and Hit/Miss terminology.
*   **DRAM Mechanics:** Added a deep dive into the physical reality of DRAM (1T1C architecture, destructive reads, precharge/refresh cycles, and RAS/CAS multiplexing).
*   **Hardware Implementation:** Bridged the gap between concept and code by defining a 3-level SystemVerilog architecture for caches.
*   **Worked Textbook Examples:** Added three highly detailed, step-by-step mathematical examples synthesized from Patterson & Hennessy, Harris & Harris, and Hamacher covering Address Field Breakdown, Direct-Mapped Tracing, and AMAT/CPI calculations.
*   **Bug Fix:** Standardized all image paths to `../../../../../Image Bank/` to correctly resolve against the repository root.

### 2. Lecture Slides (`ece251_week_13_slides.tex`)
*   **Structure:** Created a complete slide deck structured around the new markdown notes (Introduction, DRAM, Cache Architecture, and SystemVerilog).
*   **Worked Examples:** Dedicated three new slides entirely to demonstrating the step-by-step textbook examples to the class.
*   **Rendering Fix:** Enforced a double-pass `pdflatex` build process to ensure the Table of Contents (Agenda slide) correctly populates.
*   **Image Alignment:** Fixed relative paths to ensure `graphicx` can embed the textbook diagrams.

### 3. Architecture Diagrams (`TECH_DESIGN.md`)
*   Created Mermaid UML sequence and block diagrams mapping out the DRAM refresh loop, Cache hit logic, and overall system architecture.

## Verification
*   LaTeX slide deck successfully compiled without fatal errors.
*   Mermaid diagrams validated for syntax correctness.
*   Markdown previewed successfully.
