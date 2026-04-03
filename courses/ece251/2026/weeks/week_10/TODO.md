## ECE 251 Week 10 Roadmap Improvements (Web Interactions)

### 1. Embedded Code Editor (Monaco/VS Code integration)
*   **Goal**: Replace passive Markdown code blocks with active, syntax-highlighted IDE environments within the `notes_week_10.md` webpage.
*   **Implementation Route A**: Embed the [Monaco Editor via CDN](https://microsoft.github.io/monaco-editor/) directly into the `_layouts`. Requires injecting `<div id="editor"></div>` and a javascript instantiation script.
*   **Implementation Route B (Fast)**: Move `fib_prog.asm` and `tb_computer.sv` to GitHub Gists, then embed them directly using `<script src="https://gist.github.com/..."></script>`.

### 2. Browser-Based SystemVerilog Simulation
*   **Goal**: Allow students to simulate the single-cycle and multi-cycle CPUs without installing `iverilog` or `gtkwave` locally.
*   **Implementation**: Create an instance on [EDA Playground](https://edaplayground.com/) loading the entire `datapath.sv`, `controller.sv`, and `mem.sv` structure. Set simulator to Icarus Verilog 0.9.7. Save the workspace and embed the resulting responsive `iframe` into the Jekyll site.

### 3. JavaScript MIPS Emulation
*   **Goal**: Provide a graphical datapath trace where students can watch variables like `$t0` highlight iteratively as loop logic runs.
*   **Implementation**: Implement or embed [WebMIPS](https://visualmips.github.io/) or [MARS Web Simulator](https://alainsprojects.com/mars/) alongside the interactive simulation walkthrough in the notes.
