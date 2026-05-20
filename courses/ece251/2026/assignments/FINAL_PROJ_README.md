# ECE 251 Spring 2026 — Final Project Grading: Process, Tasks, and Decision Criteria

## TL;DR

For each student team repo URL, execute this sequence: **(1)** clone the repo and extract team member names, GitHub handles, and owner/contributor roles from README.md and `git log`; **(2)** assess 48 criteria across 5 categories (A–E) worth 200 base + 70 extra credit = 270 max raw points; **(3)** attempt `iverilog` compilation and `vvp` simulation to verify the design works, not just that files exist; **(4)** run 6 git forensic commands to quantify each member's contribution by commit count, file type, lines changed, and timeline; **(5)** for teams of 3+, apply rigorous per-member contribution floor checks and flag anyone below 15% of commits or 10% of `.sv` commits; **(6)** fill out the grading form in [grading_rubric_final_project.md](../assignments/grading_rubric_final_project.md) with per-criterion scores, contribution analysis, and any individual grade adjustments; **(7)** scale the raw score to 100 points. The authoritative point values come from [ECE 251 Final Project Rubric.xlsx](./../assignments/ECE%20251%20Final%20Project%20Rubric.xlsx).

---

## 1. Purpose of This Document

This file is the operational handbook for grading ECE 251 final projects. It specifies exactly what to do when handed a GitHub repository URL, in what order, what to look for, what constitutes full/partial/zero credit for each criterion, and how to handle edge cases (late submissions, team size variations, compilation failures, suspected unequal contribution).

The point values and criterion definitions come from the authoritative rubric spreadsheet:
- **Source of truth:** [ECE 251 Final Project Rubric.xlsx](./../assignments/ECE%20251%20Final%20Project%20Rubric.xlsx)
- **Markdown rendering:** [grading_rubric_final_project.md](../assignments/grading_rubric_final_project.md)

---

## 2. What You Receive

Every student individually submits their team's GitHub repository URL via the **Final Project Assignment on Microsoft Teams**. This is not a single team submission — each student must submit, regardless of team size.

For each team, the grader receives:
- One or more Teams Assignment submissions, each containing the same GitHub repository URL.
- The submitting student's name (from Teams). Cross-reference against README.md and `git log` to confirm team membership.
- Optionally, the instructor may provide the expected team member names.

**Verification:** Confirm that every team member listed in the repo's README.md also submitted individually on Teams. A student who is listed as a team member but did not submit on Teams should be flagged for the instructor's attention — they may not receive credit.

---

## 3. Grading Workflow — Step by Step

### Phase 1: Repository Setup and Team Identification

**Objective:** Establish who is on the team, who owns the repo, and whether the submission is on time.

**Tasks:**

1. **Clone the repository.**
   ```
   git clone <URL> && cd <repo-name>
   ```

2. **Read README.md** and extract:
   - Team member full names.
   - GitHub handles (look for `@handle` mentions, a contributors section, or author lines).
   - Link to demo video (YouTube or other), if present.

3. **Identify the repo owner** from the GitHub URL path (the user or org before the repo name).

4. **Identify all contributors** using two methods and cross-reference:
   ```
   git shortlog -sne --no-merges
   ```
   ```
   git log --format='%aN <%aE>' | sort -u
   ```
   Compare the git authors against the names listed in README.md. Note any discrepancies (e.g., a contributor in git who is not listed as a team member, or a listed member with zero commits).

5. **Check the submission deadline.**
   - Deadline: **May 15, 2026, 5:00pm ET.**
   - Find the last commit before the deadline:
     ```
     git log --before="2026-05-15T17:00:00-04:00" -1 --format='%H %aI %s'
     ```
   - Find the actual last commit:
     ```
     git log -1 --format='%H %aI %s'
     ```
   - If commits exist after the deadline, the grading is based on the repo state at the deadline. Use `git checkout <hash>` to check out the last on-time commit.
   - **Late penalty:** 10 points deducted per hour late from the scaled grade, applied only if the team has no commits before the deadline and the entire submission is late.

6. **Cross-reference Teams submissions.**
   - Confirm that every team member listed in README.md also submitted the repo URL individually on the Microsoft Teams Final Project Assignment.
   - A student listed in the repo but absent from Teams submissions should be flagged — they may not receive credit.
   - A student who submitted on Teams but is not listed in README.md or `git log` is also flagged for clarification.

**Decision Criteria:**
- If README.md does not list team members, check for an `AUTHORS` file, `CONTRIBUTORS.md`, or the repo description. If no names are found anywhere, note this as a deficiency under D1 (Overall Design Explanation).
- If a listed team member has zero commits in the git history, flag this immediately for Step 7 contribution analysis.
- If a listed team member did not submit on Teams, note this in the grading form. The instructor decides whether to award credit.

---

### Phase 2: ISA Design Review (Section A — 34 points)

**Objective:** Determine whether the team specified a complete, internally consistent instruction set architecture.

**Where to look:** README.md, any file in a `docs/` directory, or dedicated markdown files (e.g., `ISA.md`, `design.md`, `architecture.md`). Also check inline comments at the top of `alu.sv`, `maindec.sv`, or `aludec.sv` for ISA tables.

**Tasks — assess each criterion (2 points each):**

| # | What to find | Full credit (2) | Partial credit (1) | Zero (0) |
| :---: | :--- | :--- | :--- | :--- |
| A1 | ALU Operand Size | Explicitly stated (e.g., "32-bit ALU") | Inferrable from code but not documented | Not defined anywhere |
| A2 | Address Bus Size | Width explicitly specified | Inferrable from `imem.sv` parameter | Not defined |
| A3 | Addressability | Byte vs. word explicitly stated | Implied by PC increment value | Contradictory or absent |
| A4 | Register File Size | Count and width stated (e.g., "32 x 32-bit") | Inferrable from `regfile.sv` parameter | Not defined |
| A5 | Opcode Size | Bit count stated in instruction format diagram | Present in code constants but not documented | Not defined |
| A6 | Function Size | Bit count for funct field stated | Present in `aludec.sv` but not documented | Not defined |
| A7 | shamt Size | Bit count for shift amount stated | Inferrable but not documented | Not defined |
| A8 | Instruction Size | Total width stated (e.g., "32-bit instructions") | Inferrable from field sizes summing correctly | Not defined or inconsistent |
| A9 | PC Increment | Increment value stated and consistent with A3 | Value present in code but not documented | Contradictory or absent |
| A10 | Immediate Size | Bit count for I-type immediate stated | Inferrable from instruction format | Not defined |
| A11 | R-type format | Field layout diagram with bit positions | Text description without diagram | Not defined |
| A12 | I-type format | Field layout diagram with bit positions | Text description without diagram | Not defined |
| A13 | Memory references | Load/store instructions specified with addressing mode | Instructions listed but addressing mode unclear | Not defined |
| A14 | J-type format | Field layout diagram with bit positions | Text description without diagram | Not defined |
| A15 | R-type instructions | Specific mnemonics listed with opcodes/funct codes | Listed but incomplete or missing codes | Not listed |
| A16 | I-type instructions | Specific mnemonics listed with opcodes | Listed but incomplete or missing codes | Not listed |
| A17 | J-type instructions | Specific mnemonics listed with opcodes | Listed but incomplete or missing codes | Not listed |

**Key decision:** Documentation must be in the repo, not just in the student's head. Code comments alone earn partial credit. A well-structured ISA reference document with bit-field diagrams earns full credit.

---

### Phase 3: Memory Design Review (Section B — 16 points)

**Objective:** Verify the memory subsystem exists, is functional, and is documented.

**Tasks:**

| # | What to check | How to verify |
| :---: | :--- | :--- |
| B1 (3 pts) | `imem.sv` exists and loads a hex file | Search for `$readmemh` in the file. Verify the address width matches the ISA specification. |
| B2 (3 pts) | `dmem.sv` exists with read/write | Check for both `always_ff` (or `always @(posedge clk)`) write logic and combinational read logic. |
| B3 (5 pts) | Memory layout documented | Look for an address map in README.md or docs showing where instructions, data, and I/O live. Full credit requires a table or diagram. Partial credit if only implied by code constants. |
| B4 (5 pts) | Program load mechanism | Verify that the testbench or `imem.sv` loads a `.hex`/`.exe` file at simulation start. Check for `+PROG=` plusarg or hardcoded path. Full credit if the mechanism is documented and works. Partial if it exists but is undocumented. |

**Decision Criteria:**
- If memory modules use different names (e.g., `instruction_memory.sv`), that is acceptable. Search for the functionality, not the exact filename.
- If memory depth is hardcoded too small for the test programs (e.g., 16 words when the program needs 64), note this as a deficiency.

---

### Phase 4: Processor Implementation Review (Section C — 120 points)

**Objective:** This is the largest section. Verify that the processor's control logic, instruction execution, PC management, datapath components, and test programs are correct and functional.

**Task 4a — Attempt compilation and simulation:**

This is the single most informative test. Run it before detailed code review.

```
# Try the project's own Makefile first
make clean && make

# If no Makefile, compile manually
iverilog -g2012 -o sim.vvp *.sv

# Simulate
vvp sim.vvp
```

Record the outcome:
- **Compiles and simulates successfully:** Proceed with detailed review. The simulation output is strong evidence for C17–C24.
- **Compiles but simulation hangs or produces errors:** The design has integration issues. Award points for individual components that are structurally correct even if the system doesn't run end-to-end.
- **Does not compile:** Significant point reductions in C17 (integration) and C18–C24 (testing). Review individual files for structural correctness to determine partial credit for C1–C16.

**Task 4b — Control Logic (C1–C5):**

| # | What to inspect | Full credit | Partial | Zero |
| :---: | :--- | :--- | :--- | :--- |
| C1 (2) | `clock.sv` — generates a clock signal | Present and functional (toggling `clk`) | Present but incorrect period or duty cycle | Missing |
| C2 (10) | Control signals in `controller.sv` or `maindec.sv` | All 8 signals (`regwrite`, `regdst`, `alusrc`, `branch`, `memwrite`, `memtoreg`, `jump`, `aluop`) generated correctly for every supported opcode | Most signals correct, 1–2 errors | Fewer than half correct or module missing |
| C3 (4) | Mux modules | All 4 muxes (`regdst`, `alusrc`, `pcsrc`, `mem2reg`) present and correctly wired | 2–3 present and correct | Fewer than 2 or incorrectly wired |
| C4 (5) | `maindec.sv` truth table | Complete opcode-to-control mapping, matches ISA spec | Mapping exists but incomplete or has errors | Missing or non-functional |
| C5 (5) | `aludec.sv` truth table | Correct `funct`/`aluop` → `alucontrol` mapping for all R-type operations | Mapping exists but incomplete | Missing or non-functional |

**How to verify C2 (the 10-point criterion):** Read the `maindec.sv` case statement. For each opcode in the ISA (A15–A17), trace the control signal vector and confirm it enables the correct datapath behavior. Cross-reference with the ISA documentation. This is the most time-intensive single check — it connects ISA design to hardware implementation.

**Task 4c — Instruction Implementation (C6–C8):**

For each instruction type, trace the data flow through the datapath:
- **C6 (R-type, 5 pts):** Register read → ALU operation → register writeback. Check that `regdst` selects `rd`, `alusrc` selects register (not immediate), and `regwrite` is asserted.
- **C7 (I-type, 5 pts):** Check `lw` (memory read → register write), `sw` (register read → memory write), `beq` (register compare → conditional PC update), `addi` (immediate → ALU → register write). Each sub-type must work.
- **C8 (J-type, 5 pts):** Check that `j` loads the target address into PC. If `jal` is supported, verify `$ra` is written with PC+4.

**Decision Criteria:** If the simulation runs Programs 0–3 correctly, award full credit for C6–C8 — working programs are proof of correct instruction implementation. If simulation fails, fall back to code reading.

**Task 4d — PC Logic (C9–C11):**

- **C9 (5 pts):** Sequential PC: check for `pc <= pc + 1` (word-addressed) or `pc <= pc + 4` (byte-addressed), consistent with A3/A9.
- **C10 (5 pts):** Jump target: check for `{pc[31:28], instr[25:0], 2'b00}` or equivalent concatenation.
- **C11 (5 pts):** Branch target: check for sign-extend → shift-left-2 → add-to-PC+4 → conditional selection via `pcsrc`.

**Task 4e — Datapath Components (C12–C16):**

Verify presence and correct port wiring of each component. For each, check the module instantiation in `datapath.sv` or `cpu.sv`:

| # | Component | Key correctness check |
| :---: | :--- | :--- |
| C12 (5) | Overall wiring | All submodules instantiated with correct signal names; no dangling ports |
| C13 (5) | PC adders | `pc+1` (or `pc+4`) adder and branch target adder both present |
| C14 (5) | Register file | Two read ports, one write port, `$zero` returns 0 on read and ignores writes |
| C15 (3) | Sign extender | 16-bit → 32-bit sign extension (check bit replication, not zero-extension) |
| C16 (5) | ALU | Supports at minimum: AND, OR, NOR, ADD, SUB, SLT. Check the `case` statement in `alu.sv`. |

**Task 4f — Integration and Testing (C17–C24):**

| # | What to verify | Decision criteria |
| :---: | :--- | :--- |
| C17 (5) | `cpu.sv` wiring | Controller outputs connect to datapath control inputs with matching signal names and widths |
| C18 (4) | Program loads and executes | Simulation starts at address 0 and fetches instructions from `imem` |
| C19 (4) | `.asm` files in repo | At least one assembly source file present. Check with `find . -name '*.asm'` |
| C20 (4) | Hand-compiled hex | At least one program with a documented hand-assembly showing the mnemonic → binary → hex translation |
| C21 (4) | Program 0 — simple | Assembly with basic arithmetic/logic (`add`, `sub`, `and`, `or`). Award if simulation output or waveform shows correct register values. |
| C22 (5) | Program 1 — leaf procedure | Uses `jal`/`jr` or `j` with `$ra`. Does not need stack. Award if call and return both work. |
| C23 (5) | Program 2 — nested procedure | Caller saves registers to stack (`$sp`), calls a procedure that calls another. Award if stack management is correct in the `.asm` source and simulation shows correct nesting. |
| C24 (10) | Program 3 — recursive | A recursive function (e.g., factorial, Fibonacci) with correct stack frame push/pop on each call. This is the hardest test — award full credit only if the recursion terminates correctly with the right result. Partial credit (5) if the recursion is attempted but produces wrong results. |

**Decision Criteria for C21–C24:** If the simulation compiles and runs, check the terminal output or VCD waveforms for expected values. If the simulation does not run, read the `.asm` source to assess whether the program is structurally correct (award partial credit for well-written assembly even if the hardware doesn't execute it).

---

### Phase 5: Documentation Review (Section D — 30 points)

**Objective:** Assess the quality and completeness of the project's written documentation.

| # | What to find | Full credit | Partial | Zero |
| :---: | :--- | :--- | :--- | :--- |
| D1 (5) | Design explanation | Multi-paragraph description of the architecture, naming each major component and explaining design decisions or deviations from reference MIPS32 | Brief paragraph with minimal detail | No design explanation beyond a project title |
| D2 (5) | Design diagrams | Block diagram(s) showing processor datapath, control unit, and memory interconnections. May be hand-drawn photos, Mermaid diagrams, or image files. Must show signal names. | Diagram exists but is incomplete (e.g., missing memory connections) | No diagrams |
| D3 (5) | R-type timing diagram | Signal-level timing diagram showing an R-type instruction through the datapath across clock cycles. Must label key signals (PC, instruction, ALU inputs/output, register write). | Timing diagram exists but is incomplete or unlabeled | No timing diagram |
| D4 (5) | I-type timing diagram | Same standard as D3 but for `lw`, `sw`, `beq`, or `addi` | Same partial criteria | No timing diagram |
| D5 (5) | J-type timing diagram | Same standard as D3 but for `j` or `jal` | Same partial criteria | No timing diagram |
| D6 (5) | Demo instructions | Step-by-step instructions sufficient for a reviewer to clone, compile, simulate, and view results. Must include specific commands. | Instructions exist but are incomplete (e.g., missing prerequisites or the compile command) | No build/run instructions |

**Decision Criteria:**
- Diagrams in any format are acceptable: PNG/JPG photos of hand-drawn diagrams, Mermaid code blocks, draw.io exports, LaTeX-generated figures.
- Timing diagrams must show time progression (clock edges) on one axis and signal values on the other. A plain datapath diagram does not count as a timing diagram.
- D6 is tested by actually following the instructions. If they work from a clean clone, full credit. If they require guesswork or undocumented steps, partial credit.

---

### Phase 6: Extra Credit Review (Section E — 70 points)

**Objective:** Identify and assess work beyond the base requirements.

| # | What to search for | How to verify | Full credit | Partial |
| :---: | :--- | :--- | :--- | :--- |
| E1 (15) | `assembler.py` or equivalent | `find . -name 'assembler*' -o -name '*.py'`. If found, read the source to confirm it parses `.asm` and outputs hex. Test with: `python3 assembler.py <any .asm file> /tmp/test.exe`. | Assembler handles labels, `.org`, and all ISA instructions; produces correct hex output | Assembler exists but handles only a subset of instructions or has bugs |
| E2 (5) | Individual testbenches | `find . -name 'tb_*.sv' \| grep -v tb_computer`. Count distinct testbenches. | 3+ individual testbenches beyond `tb_computer.sv` | 1–2 individual testbenches |
| E3 (5) | Structural modeling / delays | `grep -rn '#[0-9]' *.sv` and `grep -rn '\band\b\|\bor\b\|\bnot\b\|\bnand\b\|\bnor\b' *.sv \| grep -v '//'`. | Gate-level structural modeling or `#delay` annotations used meaningfully in multiple modules | Present in one module or used trivially |
| E4 (5) | Demo video | Search README.md for a YouTube link. Video must be 5–10 minutes, uploaded as a **private** YouTube video with `robmarano@gmail.com` invited as viewer. | Private YouTube video, 5–10 min, invitation sent, shows working simulation with narration | Video exists but is public (not private), under 5 min, no invitation, or shows no working simulation |
| E5 (20) | Pipeline support | Search for `flopenr.sv`, `flopenrc.sv`, `hazard.sv`. Check `datapath.sv` for pipeline register instantiations (look for signal names containing `D`, `E`, `M`, `W` suffixes indicating pipeline stages). | 5-stage pipeline with forwarding and stall logic; simulation demonstrates pipelined execution | Pipeline registers exist but hazard handling is incomplete or non-functional |
| E6 (20) | Cache support | `find . -name '*cache*'`. Check for cache modules with tag/valid/data arrays and hit/miss logic. Look for a `stall` or `cpu_stall` signal connecting cache to datapath. | Functional cache integrated into memory hierarchy; simulation shows hit/miss behavior | Cache module exists but is not integrated or does not function |

**Decision Criteria:**
- Extra credit is all-or-nothing per criterion only for E4 (video exists or it doesn't). All other criteria accept partial credit.
- For E5 and E6 (20 points each), partial credit is awarded in increments: structural presence (5), correct logic (5), integration with CPU (5), simulation evidence (5).

---

### Phase 7: Contribution Analysis

**Objective:** Determine whether each team member made a substantive contribution. The standard of scrutiny scales with team size.

**Task 7a — Run quantitative git commands:**

```bash
# 1. Overall commits per author
git shortlog -sne --no-merges

# 2. SV file commits per author
git log --no-merges --format='%aN' -- '*.sv' | sort | uniq -c | sort -rn

# 3. Documentation commits per author
git log --no-merges --format='%aN' -- '*.md' | sort | uniq -c | sort -rn

# 4. Assembly/Python commits per author
git log --no-merges --format='%aN' -- '*.asm' '*.py' | sort | uniq -c | sort -rn

# 5. Lines added/removed per author
git log --no-merges --numstat --format='%aN' | awk 'NF==1{a=$0} NF==3{p[a]+=$1;m[a]+=$2} END{for(i in p) print i": +"p[i]" -"m[i]}'

# 6. Commit timeline per author
git log --no-merges --format='%aN|%aI' | sort | awk -F'|' '{f[$1]=f[$1]?f[$1]:$2; l[$1]=$2} END{for(i in f) print i": "f[i]" to "l[i]}'
```

Record all results in the grading form.

**Task 7b — Map file authorship for major modules:**

For each of the following files, identify the primary author:

```bash
for f in alu.sv aludec.sv maindec.sv controller.sv datapath.sv cpu.sv computer.sv regfile.sv hazard.sv assembler.py; do
  echo "=== $f ===" && git log --follow --format='%aN' -- "$f" 2>/dev/null | sort | uniq -c | sort -rn
done
```

Record who primarily authored each module in the grading form's Work Ownership table.

**Task 7c — Apply team-size-specific rules:**

**Solo teams (1 member):**
- No contribution analysis needed. Note that the student completed all work independently.

**Standard teams (2 members):**
- Record the split. Flag if one member is below **25% of total commits** or **20% of `.sv` commits**.
- A flag does not automatically reduce anyone's grade. It is a data point for the instructor.

**Large teams (3+ members) — apply all of the following:**

1. **Per-member module ownership:** Each member must be the primary author of at least one non-trivial SystemVerilog module. "Non-trivial" means a module in the control, datapath, or ALU categories (C2–C16), not a utility like `mux2.sv` or `clock.sv`. If a member owns no non-trivial module, flag as **insufficient contribution**.

2. **Contribution floor:** Flag a member as **insufficient** if:
   - Below **15%** of total non-merge commits, OR
   - Below **10%** of `.sv` file commits, OR
   - No primary authorship of any C2–C16 module, OR
   - All commits concentrated in the final 48 hours with no earlier history, OR
   - A single bulk commit by one member adds all `.sv` files while others contribute only docs/minor edits.

3. **Scope expansion:** Did the team do more work to justify the extra member?
   - Extra credit items (E1–E6) with distinct per-member authorship?
   - Additional test programs beyond Programs 0–3?
   - More extensive documentation than a 2-person team would produce?
   - Additional ISA instructions with implementation and tests?
   
   If none of these are present, the 3+ member team is doing a 2-person project with an extra person. Note this.

4. **Recommendation:** If a member fails the contribution floor, recommend an individual grade reduction. Severity guide:
   - **Minor imbalance** (below thresholds but contributed meaningfully to docs/testing): recommend 10–20% individual reduction.
   - **Significant imbalance** (near-zero code contribution, docs-only): recommend 30–50% individual reduction.
   - **No meaningful contribution** (handful of commits, no module ownership, no docs): recommend 70–100% individual reduction.

   The instructor makes the final decision. The grading form documents the evidence and recommendation.

---

### Phase 8: Score Compilation and Scaling

**Tasks:**

1. **Sum base points** across sections A–D (out of 200).
2. **Sum extra credit points** for section E (out of 70).
3. **Compute raw total** (out of 270 maximum).
4. **Scale to 100:** `scaled_grade = (base_points / 200) * 100`. Extra credit adds on top: `scaled_grade = ((base_points + extra_credit) / 200) * 100`, capped at 100 unless the instructor allows scores above 100.
5. **Apply late penalty** if applicable: subtract 10 points per hour late from the scaled grade (not from raw points).
6. **Apply individual adjustments** for 3+ member teams if Step 7c identified contribution deficits.
7. **Record the final scaled grade** for each team member in the grading form.

**Scaling example:**
- Team earns 160 base + 35 extra credit = 195 raw.
- Scaled: (195 / 200) * 100 = 97.5 → 97.5 (or 98 if rounding).
- If 2 hours late: 97.5 - 20 = 77.5.

---

## 4. Edge Cases and Decision Rules

### Compilation failure
If `iverilog` fails to compile the project:
- Review the error messages. If the errors are minor (e.g., a missing `timescale directive), attempt to fix and recompile.
- Award points for individual modules that are structurally correct by reading the source code.
- C17 (integration) receives at most 2/5 if the system does not compile.
- C18–C24 (testing) receive 0 unless the assembly programs are present and structurally correct (award C19 and C20 based on file presence, not execution).

### No README.md
- D1 and D6 receive 0.
- Team member identification relies entirely on `git log`.
- Note the deficiency prominently in grader notes.

### Suspected code copying from reference implementation
The course provides a reference implementation in `weeks/week_12/final_project/reference_src/`. Students may use it as a starting point. This is permitted. However, if a submission is an unmodified copy of the reference with no custom ISA, no additional programs, and no documentation, the following criteria receive 0:
- A11–A17 (instruction definitions — must be the team's own specification, not just the reference defaults).
- D1 (design explanation — must describe the team's design decisions, not restate the reference).
- C20 (hand-compiled program — must show the team understands the encoding, not just use the provided hex).

### Team member not in git history or not submitted on Teams
If a listed team member has zero commits:
- The member receives a flag in the contribution analysis.
- For 2-member teams: note for instructor review.
- For 3+ member teams: the member is below every contribution floor and is recommended for a 70–100% individual grade reduction.

If a team member did not submit the repo URL on the Microsoft Teams Final Project Assignment:
- The member may not receive credit regardless of their git contribution.
- Flag for the instructor's final decision. Every student is required to submit individually on Teams.

### Late submission with partial work before deadline
If the team has commits before the deadline but also commits after:
- Grade based on the repo state at the deadline (checkout the last on-time commit).
- If the team requests consideration for post-deadline work, that is the instructor's decision, not the grader's.

---

## 5. Output

For each team, produce a completed grading form as specified in the [grading_rubric_final_project.md](../assignments/grading_rubric_final_project.md) template. The form includes:

1. Team identification (names, handles, owner/contributor roles).
2. Commit statistics per member.
3. Contribution analysis (ownership matrix, flags for 3+ teams).
4. Per-criterion scores for A1–A17, B1–B4, C1–C24, D1–D6, E1–E6.
5. Score summary (base, extra credit, raw, scaled).
6. Late penalty and individual adjustments if applicable.
7. Grader notes with overall observations.

---

## 6. Reference Files

| File | Purpose |
| :--- | :--- |
| [ECE 251 Final Project Rubric.xlsx](./../assignments/ECE%20251%20Final%20Project%20Rubric.xlsx) | Authoritative point values (source of truth) |
| [grading_rubric_final_project.md](../assignments/grading_rubric_final_project.md) | Rubric with criteria definitions and grading form template |
| [GUIDE.md](../weeks/week_12/final_project/GUIDE.md) | 5-phase build instructions given to students |
| [reference_src/](../weeks/week_12/final_project/reference_src/) | Reference pipelined CPU implementation |
| [student_template/](../weeks/week_12/final_project/student_template/) | Makefile and assembler.py provided to students |
| [ece251-syllabus-spring-2026.md](../ece251-syllabus-spring-2026.md) | Course syllabus with grading distribution |
