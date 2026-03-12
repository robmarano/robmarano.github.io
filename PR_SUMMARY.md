# PR Summary: Week 8 Session Notes and Midterm Study Guide

**Intended Changes**
* Create `courses/ece251/2026/weeks/week_08/ece251_week_08_slides.tex` containing LaTeX Beamer slides for the Week 08 notes.
* Structure slides around IEEE 754 concepts, Coprocessor 1 FPU design, floating-point hardware pipelining, and MIPS immediate literal values.
* Include explicit exercises for converting floating-point base-10 to binary/hex and vice-versa.
* Draft `study_guide_midterm.md` to aggregate Weeks 01-08 content for the Midterm Exam.

**Implementation Details**
* Generated `ece251_week_08_slides.tex` compiling the 4 new floating-point topics with Beamer.
* Injected Harris and Hamacher textbook architecture diagrams visually into Week 08 Notes and Slides.
* Extracted the CPU Execution Equation example from `CSCI_155_Fall_2013_Exam_1_M01.tex`.
* Extracted the C-to-MIPS array iteration and MIPS Machine Code decoding examples from `CSCI_155_Fall_2014_Exam_1_M01.tex`.
* Extracted the K-Map logic simplification and Boolean Expansion examples from `CSCI_155_Fall_2014_Exam_1_M01.tex`.
* Synthesized the comprehensive `study_guide_midterm.md` containing all historical examples explicitly mapped to SystemVerilog and MIPS conventions, applying `_ {` MathJax subscript invariants.
* Integrated a mathematical explanation analyzing how the raw bit-shifting inside `quake_calc.s` exploits the IEEE 754 exponent bias structure to perform Fast Inverse Square Roots.
