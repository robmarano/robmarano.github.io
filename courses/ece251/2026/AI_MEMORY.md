# ECE 251 - AI Agent Memory & Progress Context

This file serves as the strict historical continuity bridge for AI agent sessions working on `robmarano.github.io/courses/ece251/2026/`.

## 1. Global Repository Rules & Constraints
*   **Tone & Style**: All documentation (Syllabus, Notes, Assignments, Keys) must maintain a highly strict, formal, objective engineering tone. Do not use subjective adjectives, hype descriptors, or "weasel words". 
*   **MathJax & Markdown Parsers**: The GitHub Pages Jekyll environment processes MathJax. **Never** include standalone `$` variables (like MIPS registers `$rs`, `$t0`) naked within Mermaid diagrams, or MathJax will intercept them and crash the diagram syntax renderer. 
*   **Workflow**: Branch creation `feature/...` -> Edit -> Update `PR_SUMMARY.md` -> Commit/Push -> `gh pr create` -> `gh pr merge --squash --delete-branch`.

## 2. Completed Milestones (Week 9 & 10)
### Documentation & Curriculum
*   **Homework Solutions**: `hw-02-solution.md` and `hw-04-solution.md` successfully authored, rigorously mirroring the data-table and explicit pointer layouts native to `hw-01-solution.md`.
*   **Cheatsheet**: Manufactured `mips_cheatsheet_ch1_4.md` integrating math constraints, system components, and MIPS ISA structures as a unified Chapter 1-4 lookup.
*   **Visual Integration**: Properly seeded textbook diagrams (Patterson & Hennessy) using absolute `/Image Bank/` links including the Pipelining "Laundry Analogy" (Figure 4.25).
*   **Notes (Week 10)**: Engineered robust justifications defining why Single-Cycle necessitates **Harvard Architecture** and Multi-Cycle safely relies on **Von Neumann Architecture** directly derived from Sections 4.4 and 4.5.

### Hardware Simulation (`SystemVerilog`)
*   **Single-Cycle CPU**: Perfected the `single_cycle_cpu/` module directory utilizing pure combinatorial lookup controllers targeting physical Harvard instruction/data splits.
*   **Multi-Cycle CPU**: Brought `multi_cycle_cpu/` online. Collapsed redundant component logic, merged `dmem` and `imem` into unified `mem.sv`, bound an `IorD` multiplexer, and established the 5-state cycle logic via Moore/Mealy Finite State Machine (`maindec.sv`). Intermediary pipelining logic (`IR`, `MDR`, `A`, `B`, `ALUOut`) operates flawlessly.
*   **Performance Monitoring**: Hooked a dynamic `cycle_count` parameter into both `tb_computer.sv` environments mathematically logging cycle speeds (e.g., executing iterative `fib_prog.asm` required 61 sequential cycles via Single-Cycle vs 187 isolated micro-cycles on the Multi-Cycle hardware).

## 3. Current Live State
*   All Week 10 integration, Verilog codebases, architectural documentation, and UML sequence diagram hotfixes were pushed and successfully merged into the **`master`** branch explicitly tracking on Pull Request #15.
*   The temporary development branch (`feature/hw-solutions`) was deleted via CI/CD cleanup.

## 4. Next Session Directives / Roadmap
*   **Week 11 - Pipelining Hazards**: The immediate next pedagogical push involves building upon the end of Week 10 to resolve **Structural, Data, and Control Hazards** introducing delay blocks, operand forwarding pathways, and explicit branch prediction tracking within the verliog/datapath infrastructure.
*   **Web Embedding Strategy (`TODO.md`)**: Explore active strategies to convert static markdown blocks into runnable logic natively within the Jekyll `.io` site. Current mitigation includes native `.zip` packaging of the `systemverilog` source environments integrated natively into the `notes_week_10.md` layout. Future tracking targets include injecting **Monaco IDE** CDN instances, linking interactive **EDA Playground** simulators directly, or natively utilizing a JavaScript execution visualizer (e.g., WebMIPS / MARS-JS).
