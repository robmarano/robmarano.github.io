# Add Homework 2/4 Solutions & Finalize Week 9/10 Curriculum

## Intended Changes
* Provide rigorous, markdown-formatted solution keys for Assignment 2 and Assignment 4.
* Mirror the pedagogical layout, table formatting, and pointer logic natively used in `hw-01-solution.md`.
* Finalize ECE 251 Week 9/10 curriculum documentation, ensuring a formal, objective engineering tone.
* Introduce Pipeline Hazard origins (Structural, Data, Control) to bridge concepts for Week 11.

## Implementation Details
*   **HW-02 & HW-04 Solutions**: Translated pointer logic natively with line-by-line documentation, provided complete MIPS machine code hexadecimal translations, and detailed explicit prologue Call Stack preservation logic.
*   **Week 9 & 10 Formalization**: Stripped subjective adjectives ("weasel words") across all documents (`notes`, `slides`, `hw`) to enforce an objective, academic engineering tone.
*   **Datapath Architecture Visualization**: Standardized architecture diagrams referencing the local `/Image Bank/`, including integrating the textbook's "Laundry Analogy" (Figure 4.25) directly into the Week 10 slides and notes.
*   **Week 10 Assessments (`hw-10.md` & `hw-10-solution.md`)**: Designed homework problems evaluating algebraic Multicycle timing derivations, SystemVerilog FSM state-transition logic, and Data Hazard detection.
*   **Reference Materials**: Consolidated fundamental equations, instruction formats, and hardware logic limits for Chapters 1-4 into `mips_cheatsheet_ch1_4.md` and prominently linked it.
*   **Textbook Integration**: Embedded absolute links to the original Patterson & Hennessy Chapter 4 PowerPoints (`Patterson6e_MIPS_Ch04_PPT.ppt`) inside Week 9 and 10 notes.
*   **Development Log**: Explicitly documented all course structure alterations natively inside `GEMINI.md`.
*   **Single/Multi-Cycle Simulators**: Restored `/single_cycle_cpu` and established `/multi_cycle_cpu` SystemVerilog directories. Wrote unified FSM Logic and memory architectures for the latter.
*   **Performance Tracking**: Injected explicit `cycle_count` monitoring into `tb_computer.sv` to scientifically plot execution speeds (e.g. 61 cycles vs 187 cycles for Fib(7)).
*   **Architectural Analysis**: Mapped hardware paradigms (Harvard vs Von Neumann) comprehensively to Single vs Multi-Cycle designs natively inside `notes_week_10.md`, alongside an explicit Mermaid UML sequence diagram modeling the 5-State Multicycle pipeline.
*   **Web Embedding Strategy**: Prepared `TODO.md` with implementation options to route `.asm` and `.sv` directly through Monaco IDE, Gists, and Javascript-based GUI Emulators natively on GitHub Pages.
*   **UML Parser Hotfix**: Repaired the Multi-Cycle Mermaid sequence diagram by purging literal parenthesis `()`, MathJax interceptors `$`, and logic operators `==` to prevent strict-mode `Mermaid v10.9.5` parser failures natively within Jekyll.
