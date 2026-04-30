# ECE 251 - AI Agent Memory & Progress Context

This file serves as the strict historical continuity bridge for AI agent sessions working on `robmarano.github.io/courses/ece251/2026/`.

## 1. Global Repository Rules & Constraints
*   **Tone & Style**: All documentation (Syllabus, Notes, Assignments, Keys) must maintain a highly strict, formal, objective engineering tone. Do not use subjective adjectives, hype descriptors, or "weasel words". 
*   **MathJax & Markdown Parsers**: The GitHub Pages Jekyll environment processes MathJax. **Never** include standalone `$` variables (like MIPS registers `$rs`, `$t0`) naked within Mermaid diagrams, or MathJax will intercept them and crash the diagram syntax renderer. 
*   **Workflow**: Branch creation `feature/...` -> Edit -> Update `PR_SUMMARY.md` -> Commit/Push -> `gh pr create` -> `gh pr merge --squash --delete-branch`.

## 2. Completed Milestones (Week 13 & 14)
### Documentation & Curriculum
*   **Textbook Problem Integration**: Injected 9 official COaD problems into `notes_week_14.md` and `ece251_week_14_slides.tex`. Cross-referenced and corrected typos in the official solution manual (e.g., Hamming Code Bit 5 vs Bit 8 syndrome).
*   **Homework Assignments**: Authored `hw-14.md` and `hw-14-solution.md` covering SEC/DED Parity, Virtual Memory Tracing, and Page Table Overhead logic.
*   **Lecture Support**: Authored `week_14_speaking_notes.md` providing a timed 165-minute script synchronized to the LaTeX slide deck.
*   **Primers**: Added a targeted Exam Readiness Guide (Primer) to the end of `notes_week_14.md` synthesizing textbook mechanics for students.

### Hardware Simulation (`SystemVerilog`)
*   **Memory Hierarchy (L1/L2 Caches)**: Implemented cycle-accurate L1/L2 caches (`cache_direct_mapped.sv`, `cache_fully_associative.sv`, `cache_set_associative.sv`).
*   **Pipeline Integration**: Hooked cache hit/miss logic into the 5-stage MIPS datapath via a `cpu_stall` handshake, successfully dropping Effective CPI from 4.34 to 1.89 during simulations.

## 3. Current Live State
*   All Week 13/14 integration, SystemVerilog codebases, architectural documentation, LaTeX slide decks, and homework assignments are completed.
*   Currently pushing changes to the `feature/week-14-memory-hierarchy-2` branch for merging into `master`.

## 4. Next Session Directives / Roadmap
*   **Final Exam Drafting**: With Week 14 complete, the immediate next pedagogical phase is drafting the Final Exam. Requirements include 15-minute question segments, two-column formatting, and comprehensive coverage of Weeks 1–14.
*   **Web Embedding Strategy (`TODO.md`)**: Explore active strategies to convert static markdown blocks into runnable logic natively within the Jekyll `.io` site (e.g., Monaco IDE or WebMIPS).
