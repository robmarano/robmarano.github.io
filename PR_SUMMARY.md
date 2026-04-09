# Formalize ECE 251 Week 11 Curriculum (Pipelining)

## Intended Changes
* Establish the complete reading assignments, pedagogical breakdown, and rigorous SystemVerilog implementation notes for the difficult transition to Pipelined Datapaths (Sections 4.6-4.9).
* Anchor Week 11 inside the root index.

## Implementation Details
*   **Root Hub Updates**: Placed explicit anchor bullets mapping Sections 4.6 (Datapath), 4.7 (Data Hazards), and 4.8 (Control Hazards) onto `ece251-notes.md`.
*   **Pipeline Architecture Notes (`notes_week_11.md`)**: Engineered a heavily technical lecture roadmap isolating physical hardware realities (such as $200\text{ps}$ clock restrictions).
*   **SystemVerilog Integrations**: Bypassed creating isolated git directories in favor of directly embedding logic snippets inside the notes; explicitly mapped mathematical hazard identification logic (`EX/MEM` tracking) to dynamic module assignments like `ForwardAE = 2'b10` targeting the ALU inputs.
*   **Problem Sets**: Formulated a 3-tier graded evaluation logic (Easy, Medium, Hard) that validates mathematical `Iron Law` CPU comparisons, manual Hazard identification, and physical pipeline flushing logic (`PcSrcD == 1` triggering `reset`).
*   **Native Slide Generation**: Manufactured `ece251_week_11_slides.tex`. Leveraged the native Beamer LaTeX package with the `minted` extension to format dual SystemVerilog blocks mapping Pipeline Registers and Forward Unit logic directly into the presentation decks for in-class parsing.
*   **Amdahl's Law Integration**: Formally mapped the mathematical physical execution limit formula $\text{Speedup} = \frac{1}{(1 - p) + \frac{p}{k}}$ directly into `notes_week_11.md` and slide \#2 of the presentation layout, explicitly evaluating how architectural structural boundaries and pipeline flushes (the static non-parallel $1-p$ fraction) intrinsically mandate an absolute maximum processor frequency constraint.
*   **Pedagogical Visual Enhancements**: Embedded explicit digital diagram references connecting locally to `Image Bank/ch004-9780128201091/jpg-9780128201091/`. This links the complex SystemVerilog state logic directly to Patterson & Hennessy's renowned Figure plates covering Datapath Architecture (004035), Data Bypassing (004053), Hazard Stalling (004056), and Pipeline Branch Flushing (004060).
