# PR Summary: Week 13 Homework and Solutions

## Objective
The objective of this PR is to provide the ECE 251 students with their Week 13 assignment (`hw-13.md`) and the corresponding solution key (`hw-13-solution.md`). The assignment focuses heavily on Memory Hierarchies, Caches, and AMAT (Average Memory Access Time), pulling rigorous mathematical exercises directly from Chapter 5 of the Patterson & Hennessy textbook.

## Key Changes

### 1. Homework Assignment (`hw-13.md`)
*   Created a 5-point assignment following the standard ECE 251 pointing schema.
*   **Part 1 (Geometry):** Tests the student's ability to extract the block size, entry count, and bit-ratio overhead of a Direct-Mapped cache based on address field bit-widths (Tag, Index, Offset).
*   **Part 2 (Tracing):** Challenges students to trace a list of 12 hex addresses through a 16-block cache to find hit/miss rates, forcing them to manually translate to binary and isolate the index.
*   **Part 3 (Performance):** A rigorous CPI and AMAT calculation problem comparing two processors (P1 and P2) to determine the performance impact of L1 miss penalties.

### 2. Solution Key (`hw-13-solution.md`)
*   Provided the complete, mathematically worked-out solutions for all three parts based on the official Chapter 5 Solution Manual.
*   Included a markdown trace table for Part 2 showing exactly how the modulo arithmetic forces cache conflicts.
*   Explicitly defined the formulas for AMAT, Miss Penalty (in cycles), and Effective CPI for Part 3.
