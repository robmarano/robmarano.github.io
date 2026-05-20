# ECE 251 Spring 2026 — Final Project Grading Rubric

[← back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html)

## Overview

Students design and implement a MIPS-like processor in SystemVerilog, including a custom instruction set architecture, memory subsystem, test programs, and supporting documentation.

- **Team size:** Typically 2 members. Solo teams and teams of 3 or more are permitted in rare cases with prior approval. Teams of 3+ are subject to additional contribution scrutiny (see Step 7).
- **Raw points:** 200 base + 70 extra credit = 270 maximum
- **Scaled grade:** Raw score is scaled to 100 points (25% of the final course grade)
- **Due:** May 15, 2026 at 5:00pm ET. Ten points deducted per hour late.
- **Submission:** Every team member individually submits the GitHub repository URL via the Final Project Assignment on Microsoft Teams. This is not a single team submission — each student must submit.

---

## Grading Summary

| Category | Points |
| ---: | :--- |
| A. ISA Design (Processor Design) | 34 |
| B. Memory Design & Implementation | 16 |
| C. Processor Design & Implementation | 120 |
| D. Documentation | 30 |
| **Base Total** | **200** |
| E. Extra Credit | 70 |
| **Maximum Raw Total** | **270** |

---

## A. ISA Design — Processor Design (34 points)

Each criterion below is assessed at 2 points.

| # | Criterion | Pts |
| :---: | :--- | :---: |
| A1 | ALU Operand Size — defined and documented (e.g., 32-bit) | 2 |
| A2 | Address Bus Size — width of the address bus specified | 2 |
| A3 | Addressability — byte vs. word addressability defined | 2 |
| A4 | Register File Size — number of registers and width specified (e.g., 32 registers x 32-bit) | 2 |
| A5 | Opcode Size — number of bits allocated to opcode field | 2 |
| A6 | Function Size — number of bits allocated to funct field for R-type | 2 |
| A7 | shamt Size — number of bits allocated to shift amount field | 2 |
| A8 | Instruction Size — total instruction width defined (e.g., 32-bit) | 2 |
| A9 | PC Increment — increment value defined and consistent with addressability | 2 |
| A10 | Immediate Size — number of bits for immediate field in I-type instructions | 2 |
| A11 | R-type Instruction Support — R-type format defined with field layout | 2 |
| A12 | I-type Instruction Support — I-type format defined with field layout | 2 |
| A13 | Memory Reference Support — load/store instructions specified with addressing mode | 2 |
| A14 | J-type Instruction Support — J-type format defined with field layout | 2 |
| A15 | R-type Instructions — specific R-type instructions listed (add, sub, and, or, slt, etc.) | 2 |
| A16 | I-type Instructions — specific I-type instructions listed (lw, sw, beq, addi, etc.) | 2 |
| A17 | J-type Instructions — specific J-type instructions listed (j, jal, etc.) | 2 |
| | **Section Total** | **34** |

---

## B. Memory Design & Implementation (16 points)

| # | Criterion | Pts |
| :---: | :--- | :---: |
| B1 | Instruction Memory — `imem.sv` present and correctly addressed; loads hex program file | 3 |
| B2 | Data Memory — `dmem.sv` present with read/write capability | 3 |
| B3 | Memory Layout — address space layout documented (instruction region, data region, I/O mapped addresses) | 5 |
| B4 | Program Load into Processor — mechanism to load assembled hex file into instruction memory at simulation start | 5 |
| | **Section Total** | **16** |

---

## C. Processor Design & Implementation (120 points)

### C.1 Control Logic

| # | Criterion | Pts |
| :---: | :--- | :---: |
| C1 | Clock Design — clock generation module present and functional | 2 |
| C2 | Overall Control Signals — correct generation of `regwrite`, `regdst`, `alusrc`, `branch`, `memwrite`, `memtoreg`, `jump`, `aluop[]` | 10 |
| C3 | Multiplexors — `regdst`, `alusrc`, `pcsrc`, `mem2reg` muxes correctly select datapath signals | 4 |
| C4 | Main Decoder Details — `maindec.sv` maps opcodes to complete control signal vectors | 5 |
| C5 | ALU Decoder — `aludec.sv` maps `funct` and `aluop` to `alucontrol` | 5 |

### C.2 Instruction Implementation

| # | Criterion | Pts |
| :---: | :--- | :---: |
| C6 | R-Type Instruction Implementation — R-type instructions execute correctly through ALU with register writeback | 5 |
| C7 | I-Type Instruction Implementation — I-type instructions (load, store, branch, immediate arithmetic) execute correctly | 5 |
| C8 | J-Type Instruction Implementation — jump instructions correctly update PC | 5 |

### C.3 PC Logic

| # | Criterion | Pts |
| :---: | :--- | :---: |
| C9 | PC Increment for R- and I-types — PC increments by correct value for sequential execution | 5 |
| C10 | PC Increment for J-type — PC loads jump target address correctly | 5 |
| C11 | PC Increment for Conditional Branch — branch target calculated correctly; PC updates only when branch condition is met | 5 |

### C.4 Datapath Components

| # | Criterion | Pts |
| :---: | :--- | :---: |
| C12 | Datapath Design — `imem`, `dmem`, `alu`, `regfile`, `signext`, `sll` correctly instantiated and wired | 5 |
| C13 | PC Increment Adders — `pc+1` adder, `pc+jump` adder, and shift-left-2 logic present and functional | 5 |
| C14 | Register File — three-port register file (`regfile.sv`) with two read ports and one write port; `$zero` hardwired to 0 | 5 |
| C15 | Sign Extender(s) — `signext.sv` correctly extends 16-bit immediate to 32 bits | 3 |
| C16 | ALU — supports `and`, `or`, `nor`, `add`, `sub`, `slt` at minimum | 5 |

### C.5 Integration and Testing

| # | Criterion | Pts |
| :---: | :--- | :---: |
| C17 | Controller–Datapath Integration — `cpu.sv` correctly connects controller outputs to datapath control inputs | 5 |
| C18 | Program Load Integration — assembled program loads into instruction memory and execution begins at address 0 | 4 |
| C19 | Provided Assembly Program in Code — repository contains assembly source files (`.asm`) | 4 |
| C20 | Hand-compiled Program — at least one program hand-assembled to hex with documented encoding | 4 |
| C21 | Program 0 — Simple Assembly Code: basic arithmetic and logic operations execute correctly | 4 |
| C22 | Program 1 — Leaf Procedure Code: function call and return using `$ra`, stack not required | 5 |
| C23 | Program 2 — Nested Procedure Code: caller-saved/callee-saved register conventions and stack usage | 5 |
| C24 | Program 3 — Recursive Procedure Code: recursive function with correct stack frame management | 10 |

| | **Section Total** | **120** |
| :---: | :--- | :---: |

---

## D. Documentation (30 points)

| # | Criterion | Pts |
| :---: | :--- | :---: |
| D1 | Overall Design Explanation — written description of the processor architecture, design decisions, and any deviations from the reference MIPS32 design | 5 |
| D2 | Overall Design Diagrams — block diagrams showing the processor datapath, control unit, and memory subsystem interconnections | 5 |
| D3 | R-type Timing Diagram — signal-level timing diagram showing an R-type instruction traversing the datapath | 5 |
| D4 | I-type Timing Diagram — signal-level timing diagram showing an I-type instruction (e.g., `lw` or `sw`) | 5 |
| D5 | J-type Timing Diagram — signal-level timing diagram showing a J-type instruction | 5 |
| D6 | Instructions to Successfully Demo — step-by-step build and run instructions (clone, compile with `iverilog`, simulate with `vvp`, view waveforms) sufficient for a reviewer to reproduce the demo | 5 |
| | **Section Total** | **30** |

---

## E. Extra Credit (70 points)

| # | Criterion | Pts |
| :---: | :--- | :---: |
| E1 | Programmatic Assembler — Python assembler (`assembler.py`) that translates the team's assembly language into hex machine code; handles labels, `.org` directives, and all supported instructions | 15 |
| E2 | Verilog Test Benches for Each Element — individual testbenches (`tb_*.sv`) for ALU, register file, decoder, and other components beyond the top-level `tb_computer.sv` | 5 |
| E3 | Structural Modeling or Delays — use of gate-level structural modeling or `#delay` annotations to demonstrate timing awareness | 5 |
| E4 | Demo Video Recording — 5–10 minute video uploaded to YouTube as a **private** video with `robmarano@gmail.com` invited as viewer; demonstrates the working processor with narration; link in README.md | 5 |
| E5 | Pipeline Design Support — 5-stage pipelined implementation with pipeline registers (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`), hazard detection, and data forwarding | 20 |
| E6 | Cache Support — functional cache (direct-mapped, set-associative, or fully-associative) integrated into the memory hierarchy with stall logic | 20 |
| | **Section Total** | **70** |

---

## Grading Process

When given a student team's GitHub repository URL, the following assessment procedure is executed:

### Step 1: Repository Identification

1. Clone or fetch the repository at the provided URL.
2. Read `README.md` to extract:
   - Team member names and GitHub handles.
   - Repository owner and contributors (via `README.md` content, GitHub contributors page, and `git log` author fields).
   - Link to demo video (if present).
3. Record the last commit timestamp to verify submission deadline compliance.

### Step 2: ISA Design Review (Section A)

1. Locate the ISA specification document (typically in `README.md` or a dedicated `docs/` markdown file).
2. For each of the 17 criteria (A1–A17), verify the specification explicitly defines the item.
3. Check that R-type, I-type, and J-type instruction formats are diagrammed with bit-field boundaries.
4. Verify that a machine code encoding table exists mapping mnemonics to binary.

### Step 3: Memory Design Review (Section B)

1. Locate `imem.sv` and `dmem.sv` (or equivalently named memory modules).
2. Verify `imem.sv` uses `$readmemh` or equivalent to load a hex program file.
3. Check that `dmem.sv` supports both read and write operations.
4. Review documentation for memory layout (address map, I/O regions).
5. Verify the program loading mechanism works (hex file path, parameter depth).

### Step 4: Processor Implementation Review (Section C)

1. **Control Logic (C1–C5):** Inspect `clock.sv`, `maindec.sv`, `aludec.sv`, `controller.sv`, and all multiplexor modules. Verify control signal truth tables match the ISA specification.
2. **Instruction Implementation (C6–C8):** Trace R-type, I-type, and J-type instructions through the datapath by reading the `datapath.sv` wiring and the control signal mappings.
3. **PC Logic (C9–C11):** Verify PC increment logic for sequential, jump, and branch execution paths. Check branch target calculation (sign-extend, shift-left-2, add to PC+4).
4. **Datapath Components (C12–C16):** Confirm presence and correct wiring of `alu.sv`, `regfile.sv`, `signext.sv`, `sl2.sv`, `adder.sv`, and datapath mux instances.
5. **Integration and Testing (C17–C24):**
   - Verify `cpu.sv` instantiates controller and datapath with correct port connections.
   - Verify `computer.sv` connects CPU to instruction and data memory.
   - Attempt compilation: `iverilog -g2012 -o sim.vvp *.sv`
   - Attempt simulation: `vvp sim.vvp` (or per the project's Makefile).
   - Check for `.asm` source files and `.exe`/`.hex` compiled programs.
   - Evaluate test program complexity: simple (C21), leaf procedure (C22), nested procedure (C23), recursive (C24).
   - For each program, check whether simulation output or VCD waveforms demonstrate correct execution.

### Step 5: Documentation Review (Section D)

1. **D1:** Read the design explanation for completeness and technical accuracy.
2. **D2:** Verify block diagrams exist (images, Mermaid, or drawn diagrams) showing datapath and control.
3. **D3–D5:** Check for timing diagrams showing signal transitions for R-type, I-type, and J-type instructions.
4. **D6:** Follow the documented build/run instructions to verify they are sufficient to reproduce the demo from a clean clone.

### Step 6: Extra Credit Review (Section E)

1. **E1:** Check for `assembler.py` (or equivalent). Test it if possible: `python3 assembler.py test.asm test.exe`.
2. **E2:** Search for individual testbenches (`tb_alu.sv`, `tb_regfile.sv`, etc.) beyond `tb_computer.sv`.
3. **E3:** Search for `#` delay annotations or gate-level `and`, `or`, `not` primitives in any `.sv` file.
4. **E4:** Check README.md for a YouTube or video link.
5. **E5:** Search for pipeline register modules (`flopenr.sv`, `flopenrc.sv`), a `hazard.sv` module, and forwarding/stalling logic in `datapath.sv`.
6. **E6:** Search for cache modules (`cache_*.sv` or `*cache*.sv`) and stall handshake signals.

### Step 7: Contribution Analysis

This step establishes whether each team member made a substantive, roughly equal contribution. The standard of scrutiny scales with team size: 2-member teams receive a baseline review; solo teams are noted; **teams of 3 or more receive rigorous per-member assessment** because the same 200-point project scope must yield meaningful work for every first-year computer architecture student.

#### 7a. Quantitative Git Analysis

Run the following commands against the cloned repository:

1. **Overall commit count per author:**
   `git shortlog -sne --no-merges`
2. **Commits to SystemVerilog files per author:**
   `git log --no-merges --format='%aN' -- '*.sv' | sort | uniq -c | sort -rn`
3. **Commits to documentation/markdown per author:**
   `git log --no-merges --format='%aN' -- '*.md' | sort | uniq -c | sort -rn`
4. **Commits to assembly/test programs per author:**
   `git log --no-merges --format='%aN' -- '*.asm' '*.py' | sort | uniq -c | sort -rn`
5. **Lines added/removed per author:**
   `git log --no-merges --numstat --format='%aN' | awk 'NF==1{author=$0} NF==3{added[author]+=$1; removed[author]+=$2} END{for(a in added) print a": +"added[a]" -"removed[a]}'`
6. **Commit timeline span per author** (to detect last-minute dump commits):
   `git log --no-merges --format='%aN|%aI' | sort | awk -F'|' '{first[$1]=first[$1]?first[$1]:$2; last[$1]=$2} END{for(a in first) print a": "first[a]" to "last[a]}'`

#### 7b. Qualitative Contribution Assessment

1. **File authorship mapping:** For each major module (`alu.sv`, `datapath.sv`, `controller.sv`, `hazard.sv`, `cpu.sv`, `computer.sv`, `assembler.py`), use `git log --follow --format='%aN' -- <file> | sort | uniq -c` to identify the primary author(s).
2. **README/documentation authorship:** Check whether documentation and design explanations were written by one member or distributed.
3. **Issue tracker / project board:** If the team used GitHub Issues or Projects, note whether tasks were assigned and completed by different members.
4. **Commit message quality:** Look for co-authored commits, pair-programming indicators, or "bulk upload" patterns (a single commit adding all files at once by one person).

#### 7c. Team-Size-Specific Assessment

**Solo teams (1 member):**
- Note that a single student completed all work. No contribution imbalance is possible.
- Assess whether the scope of work is consistent with a single student's effort over the project timeline.

**Standard teams (2 members):**
- Record the contribution split from 7a and 7b.
- Flag if one member accounts for less than **25%** of total commits or less than **20%** of `.sv` file commits. This does not automatically reduce the grade, but is noted for the instructor's attention.

**Large teams (3 or more members) — Rigorous Assessment:**

A 3+ member team must demonstrate that the project scope was genuinely expanded or that each member owned a distinct, non-trivial subsystem. The same base project (200 points) does not triple in scope by adding a third member. Apply all of the following checks:

1. **Per-member work ownership matrix:** For each team member, identify the specific modules (`.sv` files), documentation sections, and test programs they primarily authored. Record this in the grading form. Each member must own at least one non-trivial SystemVerilog module (not just a mux or clock) and at least one documentation deliverable.

2. **Contribution floor enforcement:** Flag a team member as **"insufficient contribution"** if any of the following are true:
   - Fewer than **15%** of total non-merge commits.
   - Fewer than **10%** of commits touching `.sv` files.
   - No primary authorship of any module in the datapath, control, or ALU categories (C2–C16).
   - Commits are concentrated in a single day or the final 48 hours before the deadline, with no earlier commit history.
   - All `.sv` files were authored by a single large commit from one team member, with other members only contributing documentation or minor edits.

3. **Scope expansion check:** Determine whether the team attempted additional work beyond the base 200 points to justify the extra member. Evidence includes:
   - Extra credit items (E1–E6) with distinct authorship per member.
   - Additional test programs beyond the required four (Programs 0–3).
   - More extensive documentation (e.g., each member documented the subsystem they built).
   - Additional ISA instructions with corresponding implementation and testing.

4. **Individual grade adjustment:** If the contribution analysis reveals that a member contributed substantially less than their share:
   - The team's base score applies to members with demonstrated contribution.
   - The under-contributing member's individual score may be reduced by the instructor based on the severity of the imbalance.
   - Record the recommended adjustment and supporting evidence in the grading form.

#### 7d. Contribution Summary Table

Compile the findings into the per-team grading form (see template below).

### Step 8: Score Compilation

1. Assign points for each criterion (A1–A17, B1–B4, C1–C24, D1–D6, E1–E6).
2. Sum base points (out of 200) and extra credit points (out of 70).
3. Record the raw score and any notes on partial credit or deductions.
4. For teams of 3+, attach the contribution analysis from Step 7c and note any recommended individual grade adjustments.

---

## Per-Team Grading Form Template

For each student team submission, the assessment is recorded in the following format:

---

### Team: [Team Name or Repo Name]

**Repository:** [GitHub URL]
**Team Size:** [1 / 2 / 3+] | **Large Team Scrutiny Required:** [Yes / No]
**Last Commit:** [timestamp] | **On-time:** [Yes / No — deduction if late]

**Team Members:**

| Name | GitHub Handle | Role | Submitted on Teams | Commits (total) | Commits (.sv) | Commits (.md) | Commits (.asm/.py) | Lines +/- |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| [Name 1] | @[handle1] | [Owner / Contributor] | [Yes/No] | | | | | |
| [Name 2] | @[handle2] | [Owner / Contributor] | [Yes/No] | | | | | |
| [Name 3 if applicable] | @[handle3] | [Contributor] | [Yes/No] | | | | | |

**Commit Timeline:**
- [handle1]: [first commit date] to [last commit date]
- [handle2]: [first commit date] to [last commit date]

#### Contribution Analysis (required for teams of 3+; recommended for all)

**Per-Member Work Ownership:**

| Module / Deliverable | Primary Author | Evidence |
| :--- | :--- | :--- |
| `alu.sv` | | git log |
| `datapath.sv` | | git log |
| `controller.sv` / `maindec.sv` | | git log |
| `cpu.sv` / `computer.sv` | | git log |
| `hazard.sv` (if present) | | git log |
| `assembler.py` (if present) | | git log |
| ISA documentation | | git log |
| Design diagrams | | git log |
| Test programs (.asm) | | git log |

**Contribution Flags (3+ member teams only):**
- [ ] Each member owns at least one non-trivial SV module (not just mux/clock)
- [ ] Each member owns at least one documentation deliverable
- [ ] No member is below 15% of total commits
- [ ] No member is below 10% of .sv commits
- [ ] Commits are distributed across the project timeline (not concentrated in final 48 hours)
- [ ] Scope expansion present to justify additional team member(s)

**Contribution Assessment:** [Equitable / Minor imbalance noted / Significant imbalance — see notes]
**Individual Grade Adjustment Recommended:** [None / Member X reduced by N% — reason]

#### A. ISA Design (34 pts)

| # | Criterion | Pts | Awarded | Notes |
| :---: | :--- | :---: | :---: | :--- |
| A1 | ALU Operand Size | 2 | | |
| A2 | Address Bus Size | 2 | | |
| A3 | Addressability | 2 | | |
| A4 | Register File Size | 2 | | |
| A5 | Opcode Size | 2 | | |
| A6 | Function Size | 2 | | |
| A7 | shamt Size | 2 | | |
| A8 | Instruction Size | 2 | | |
| A9 | PC Increment | 2 | | |
| A10 | Immediate Size | 2 | | |
| A11 | R-type Instruction Support | 2 | | |
| A12 | I-type Instruction Support | 2 | | |
| A13 | Memory Reference Support | 2 | | |
| A14 | J-type Instruction Support | 2 | | |
| A15 | R-type Instructions | 2 | | |
| A16 | I-type Instructions | 2 | | |
| A17 | J-type Instructions | 2 | | |
| | **Subtotal** | **34** | | |

#### B. Memory Design & Implementation (16 pts)

| # | Criterion | Pts | Awarded | Notes |
| :---: | :--- | :---: | :---: | :--- |
| B1 | Instruction Memory | 3 | | |
| B2 | Data Memory | 3 | | |
| B3 | Memory Layout | 5 | | |
| B4 | Program Load into Processor | 5 | | |
| | **Subtotal** | **16** | | |

#### C. Processor Design & Implementation (120 pts)

| # | Criterion | Pts | Awarded | Notes |
| :---: | :--- | :---: | :---: | :--- |
| C1 | Clock Design | 2 | | |
| C2 | Overall Control Signals | 10 | | |
| C3 | Multiplexors | 4 | | |
| C4 | Main Decoder Details | 5 | | |
| C5 | ALU Decoder | 5 | | |
| C6 | R-Type Instruction Impl | 5 | | |
| C7 | I-Type Instruction Impl | 5 | | |
| C8 | J-Type Instruction Impl | 5 | | |
| C9 | PC — R/I-type Increment | 5 | | |
| C10 | PC — J-type Increment | 5 | | |
| C11 | PC — Conditional Branch | 5 | | |
| C12 | Datapath Design | 5 | | |
| C13 | PC Increment Adders | 5 | | |
| C14 | Register File | 5 | | |
| C15 | Sign Extender(s) | 3 | | |
| C16 | ALU | 5 | | |
| C17 | Controller–Datapath Integration | 5 | | |
| C18 | Program Load Integration | 4 | | |
| C19 | Assembly Source in Repo | 4 | | |
| C20 | Hand-compiled Program | 4 | | |
| C21 | Program 0 — Simple Assembly | 4 | | |
| C22 | Program 1 — Leaf Procedure | 5 | | |
| C23 | Program 2 — Nested Procedure | 5 | | |
| C24 | Program 3 — Recursive Procedure | 10 | | |
| | **Subtotal** | **120** | | |

#### D. Documentation (30 pts)

| # | Criterion | Pts | Awarded | Notes |
| :---: | :--- | :---: | :---: | :--- |
| D1 | Overall Design Explanation | 5 | | |
| D2 | Overall Design Diagrams | 5 | | |
| D3 | R-type Timing Diagram | 5 | | |
| D4 | I-type Timing Diagram | 5 | | |
| D5 | J-type Timing Diagram | 5 | | |
| D6 | Instructions to Successfully Demo | 5 | | |
| | **Subtotal** | **30** | | |

#### E. Extra Credit (70 pts)

| # | Criterion | Pts | Awarded | Notes |
| :---: | :--- | :---: | :---: | :--- |
| E1 | Programmatic Assembler | 15 | | |
| E2 | Testbenches per Element | 5 | | |
| E3 | Structural Modeling / Delays | 5 | | |
| E4 | Demo Video Recording | 5 | | |
| E5 | Pipeline Design Support | 20 | | |
| E6 | Cache Support | 20 | | |
| | **Subtotal** | **70** | | |

#### Score Summary

| Category | Available | Awarded |
| :--- | :---: | :---: |
| A. ISA Design | 34 | |
| B. Memory Design | 16 | |
| C. Processor Implementation | 120 | |
| D. Documentation | 30 | |
| **Base Total** | **200** | |
| E. Extra Credit | 70 | |
| **Raw Total** | **270** | |
| **Scaled Grade (out of 100)** | | |

**Late Penalty:** [None / -N points]
**Final Scaled Grade:** [score]

**Grader Notes:**
[Overall observations, notable strengths, areas for improvement]

**Individual Grades (if adjustments apply):**

| Name | Team Score | Adjustment | Final Score | Reason |
| :--- | :---: | :---: | :---: | :--- |
| [Name 1] | | — | | |
| [Name 2] | | — | | |
| [Name 3 if applicable] | | | | |

---

## Evaluation Notes

- **Standard teams (2 members):** Both members receive the same grade unless there is documented evidence of significantly unequal contribution.
- **Solo teams (1 member):** The full rubric applies. No contribution analysis is required.
- **Large teams (3+ members):** All members receive the team's base score unless the Step 7c contribution analysis identifies a member below the contribution floor. In that case, the instructor may reduce the individual member's grade proportionally to the deficit, using the evidence documented in the grading form.
- **Submission requirement:** Every student must individually submit the GitHub repository URL via the Final Project Assignment on Microsoft Teams, regardless of team size. A team member who does not submit on Teams may not receive credit.
- Source code must compile with Icarus Verilog (`iverilog`) and simulate with `vvp` without errors.
- All SystemVerilog source files, the assembler, test programs, hex files, and documentation must be committed to the team's GitHub repository by the submission deadline.
- Task tracking (who does what by when, how long it took) should be visible in the repository via commit history, issues, or a project board. This is especially important for teams of 3+.

[← back to syllabus](/courses/ece251/2026/ece251-syllabus-spring-2026.html)
