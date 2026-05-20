# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A GitHub Pages site for Rob Marano's courses at The Cooper Union (adjunct professor, ECE). Built with Jekyll using the Primer theme. The site hosts syllabi, weekly lecture notes, assignments, study guides, and SystemVerilog/MIPS code examples for multiple courses across semesters.

## Build & Serve

```bash
# First-time setup
script/bootstrap          # installs bundler + gems

# Local dev server (http://localhost:4000)
script/server             # runs `bundle exec jekyll serve`

# CI build (build + htmlproofer + rubocop + HTML validation)
script/cibuild

# Update gems
./build.sh                # runs `bundle update`
```

Pandoc is used for PDF generation from markdown (not part of the Jekyll build):
```bash
pandoc --reference-links --dpi=150 -t pdf <input>.md \
  -V geometry="left=3cm,right=3cm,top=2cm,bottom=2cm" -o <output>.pdf
```

## Architecture

- **Static site generator:** Jekyll with `github-pages` gem (deployed via GitHub Pages from `master` branch)
- **Theme:** `jekyll-theme-primer` (GitHub Primer CSS), customized layout in `_layouts/default.html`
- **Rendering extensions in default layout:**
  - **MathJax 3** — inline LaTeX math via `$...$` and `\(...\)` delimiters
  - **Mermaid.js 10** — fenced code blocks with `mermaid` language tag are auto-converted to diagrams
  - **Anchor.js** — auto-generates anchor links for headings

## Content Organization

```
courses/
  ece251/          # Computer Architecture (Spring semesters)
  ece465/          # Cloud Computing (Fall/Spring, sometimes independent study)
  ece366/          # SW Engineering & Large Scale Design
  ece460/          # (future course)
  cs102/           # Intro CS (past, C/C++)
```

Each course is organized by year: `courses/<course>/<year>/`. Current semester is **Spring 2026** for ECE 251 and ECE 465.

Within a semester, weekly content lives in `weeks/week_NN/` with `notes_week_NN.md` as the standard filename. Supplemental files (slides PDFs, SystemVerilog `.sv` files, images) sit alongside the notes.

Catalogs of reusable SystemVerilog modules live under `courses/ece251/<year>/catalog/`.

### ECE 251 2026 — SystemVerilog CPU Progression

The course builds progressively complex MIPS32 CPUs, each in its own directory:

| Directory | Architecture |
|-----------|-------------|
| `weeks/week_04/` | Combinational building blocks (gates, muxes, adders, flip-flops) |
| `weeks/week_05/mips32_alu/` | Standalone 32-bit ALU |
| `weeks/week_10/single_cycle_cpu/` | Full single-cycle MIPS datapath |
| `weeks/week_10/multi_cycle_cpu/` | Multi-cycle with FSM controller |
| `weeks/week_11/pipelined_cpu/` | 5-stage pipeline with hazard unit & forwarding |
| `weeks/week_12/pipelined_cpu_exceptions/` | Pipeline + exception/interrupt handling |
| `weeks/week_13/pipelined_cached_computer/` | Pipeline + L1 cache (direct-mapped, set-assoc, fully-assoc) |

Common SV module vocabulary: `alu.sv`, `aludec.sv`, `maindec.sv`, `controller.sv`, `datapath.sv`, `cpu.sv`, `computer.sv`, `regfile.sv`, `mux2/3/4.sv`, `signext.sv`, `sl2.sv`, `adder.sv`, `dff.sv`, `flopenr.sv`, `tb_computer.sv`.

### ECE 251 2026 — Toolchain

- **Icarus Verilog** (`iverilog`) + `vvp` — compile and simulate SystemVerilog, produces `.vcd` waveforms
- **Surfer / VS Code** — waveform viewing
- **SPIM/QtSPIM** — MIPS assembly emulator
- **Python 3** `assembler.py` — translates `.asm` → `.exe` hex files (in `weeks/week_12/final_project/student_template/`)
- **LaTeX** — slide decks (`ece251_week_NN_slides.tex`) and exam papers (in `exams/`)
- **Makefile** — per-project SV build automation (in catalog/templates and final project)

## Content Conventions

- Course markdown files generally do **not** use Jekyll frontmatter — they start with a markdown heading and navigation links back to the syllabus/notes index.
- Syllabus files use `layout: default` frontmatter.
- Weekly notes link back to the syllabus with: `[ ← back to syllabus](...)` and `[ ← back to notes](...)`.
- Math notation uses LaTeX syntax rendered by MathJax (e.g., `$O(n \log n)$`).
- Diagrams use fenced mermaid code blocks.
- Internal links use relative paths with `.html` extensions (Jekyll converts `.md` → `.html`).
- **MathJax/Mermaid conflict:** Never put bare `$` signs (e.g., MIPS registers `$rs`, `$t0`) inside mermaid diagram blocks. MathJax intercepts them before Mermaid renders, breaking the diagram. Use plain names (`rs`, `t0`) instead.
- **Writing tone:** All course documentation must use formal, objective engineering tone. No hype, subjective adjectives, or weasel words.

## Branch Strategy

- `master` is the deploy branch (GitHub Pages publishes from it).
- Feature branches use `feature/<topic>` naming.
- Workflow: create `feature/...` branch → edit → update `PR_SUMMARY.md` → commit/push → `gh pr create` → `gh pr merge --squash --delete-branch`.
