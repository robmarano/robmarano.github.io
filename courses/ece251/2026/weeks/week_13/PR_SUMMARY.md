# PR Summary: Week 13 Cache Curriculum Expansion

## Objective
The objective of this update is to finalize the Week 13 Memory Hierarchies curriculum for ECE 251. We aim to bridge abstract architectural theory with practical physical hardware realities, specifically focusing on cache topologies, DRAM mechanics, and foundational SystemVerilog implementations.

## Changes Made

### 1. Markdown Notes (`notes_week_13.md`)
*   **Expanded Topologies:** Added deep-dive explanations of Direct-Mapped, Fully Associative, and Set-Associative caches.
*   **Historical Context:** Injected "The Journey So Far" narrative, contextualizing the memory system as the crucial counterpart to our pipelined processor.
*   **Textbook Synthesis:** Integrated concepts from both Harris (Desk Analogy, AMAT) and Hamacher (Write Policies, Interleaving).
*   **Hardware Reality (DRAM):** Added a breakdown of 1T1C cells, destructive reads, and RAS/CAS multiplexing.
*   **SystemVerilog Models:** Interleaved a 3-stage hardware progression:
    *   Level 1: Basic Synchronous Main Memory.
    *   Level 2: Direct-Mapped Cache Arrays (`Data`, `Tag`, `Valid`).
    *   Level 3: Combinational Hit/Miss Logic.
*   **Practice Problems:** Added a tiered (Easy/Medium/Hard) problem set using `<details>` blocks.

### 2. Lecture Slides (`ece251_week_13_slides.tex`)
*   Added parallel content to visually support the notes.
*   Included verbatim blocks containing the SystemVerilog progression.
*   Successfully recompiled PDF (extended to 23 frames).

### 3. Architecture Diagrams (`TECH_DESIGN.md`)
*   Created Mermaid UML sequence and block diagrams mapping out the DRAM refresh loop, Cache hit logic, and overall system architecture.

## Verification
*   LaTeX slide deck successfully compiled without fatal errors.
*   Mermaid diagrams validated for syntax correctness.
*   Markdown previewed successfully.
