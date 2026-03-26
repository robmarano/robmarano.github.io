# Pull Request Summary: Week 09 Notes

## Intended Changes
Add the lecture notes for Week 09 to the ECE 251 Computer Architecture course repository, focusing on the processor datapath, logical design conventions, and SystemVerilog behavioral emulation.

## Implementation Details
- **Created `courses/ece251/2026/weeks/week_09/notes_week_09.md`**:
  - Implemented deep dives for Textbook Chapter 4 (Sections 4.1 to 4.3).
  - Explicitly mapped the Session 1-8 syllabus timeline to the fundamental structural datapath components required to emulate the single-cycle machine.
  - Linked specific textbook Datapath logic figures (`Textbook Figure 4.1`, `4.2`, `4.5`, `4.6`, `4.7`, `4.11`) to visual assets in `/Image Bank`.
  - Authored a dedicated subsection for SystemVerilog behavioral modeling of the Program Counter, Register File, and ALU to bridge theoretical logic concepts with practical RTL programming.
  - Supplied three complete problem walkthroughs mapping back to Chapter 4 textbook exercises (Simple - Ex 4.3 Component Utilization, Medium - Ex 4.1 Control Signals, Hard - Ex 4.4 Diagnosing Stuck Control Multiplexers).
  - Added reading assignments mapping directly to the week's syllabus timeline.
- **Fixed Typography**: Corrected unclosed HTML anchor tags (`</a>`) in `ece251-notes.md` for Weeks 12, 13, and 14 headers that resulted from previous week shifts.

- **Generated Homework 09 (`hw-09.md` & `hw-09-solution.md`)**:
  - Created a new assignment evaluating Datapath Component Utilization, Single-Cycle Instruction Tracing, and Component Latencies based on textbook exercises 4.3, 4.5, and 4.7.
  - Tailored solution breakdowns explicitly to MIPS32 register standards and aligned mathematical explanations with `Textbook Figure 4.11`.
- **Updated `notes_week_09.md` Latencies**: Added section `4.5 Datapath Component Latencies and Critical Paths` to support students in identifying physical execution delays.
- **Standardized Submission Guidelines**: Updated the submission instruction text uniformly across assignments (`hw-01` through `hw-09`) to explicitly direct students to submit via Microsoft Teams instead of GitHub.

- **Added MIPS Datapath Infographic**: Embedded the explicit 'Inside the MIPS Single-Cycle Processor' visual overview into `notes_week_09.md` to cleanly map the Instruction Fetch through Write-Back components for students.

- **Deep Textbook Integration (Sections 4.1-4.3)**:
  - Systematically expanded `notes_week_09.md` to rigorously define Edge vs. Level-Triggering for the 5-stage loop based on Hamacher textbook details, and detailed the Datapath logic.
  - Authored a comprehensive 9-slide Beamer presentation outputting to `ece251_week_09_slides.pdf` synthesizing the newly expanded Datapath architecture.

- **Session Agenda & Structuring**: Created `agenda_week_09.md` modeling the Week 07 pedagogy layout and explicitly embedded the new Slide Deck download link at the top of the `notes_week_09.md` document.

## Next Steps
- Commit the content, push to `feature/week09-notes`, and open a Pull Request.
