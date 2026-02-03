Here are the instructor speaking notes for **Session 02 / Week 02** of ECE 251.

These notes are structured based on your syllabus, weekly course notes, and the style established in your Week 1 transcript. They cover the progression from computer abstractions to the specific Instruction Set Architecture (ISA) of MIPS.

***

# Instructor Speaking Notes: ECE 251 – Session 02
**Topic:** Instructions — The Language & Grammar of Computers (Part 1)
**Date:** Thursday, Jan 29, 2026
**Time:** 6:00 PM – 8:50 PM

---

## I. Administrative & Warm-Up (6:00 – 6:15 PM)

**1. Welcome Back**
*   How is everyone settling in? Any issues with Teams access or GitHub?
*   **Homework 1:** It was due today. Ensure your URL is submitted in Teams and the repo is pushed to GitHub.
*   **Homework 2:** Released today, due next Thursday (2/5).

**2. The "Arc of Learning" Recap**
*   Last week, we talked about **Abstraction**. We looked at the high-level definition of a computer: Input, Output, Memory, Datapath, and Control.
*   We discussed the **Stored Program Concept**—the idea that instructions and data are both just numbers stored in memory.
*   **Analogy:** Last week I mentioned language. Today we are learning the **Vocabulary** (Instructions) and the **Grammar** (ISA) of the computer.
*   **Goal for Today:** By 8:50 PM, you should be able to take a simple arithmetic line of C code (`a = b + c`) and tell me exactly what 32 bits the MIPS processor sees to execute that.

---

## II. The Instruction Set Architecture (ISA) (6:15 – 7:00 PM)

**1. What is an ISA?**
*   The ISA is the interface between the hardware and the software. It’s the contract.
*   We are using **MIPS** (Microprocessor without Interlocked Piped Stages).
    *   *Why?* It is elegant, simple, and the basis for learning RISC (Reduced Instruction Set Computer).
    *   *Contrast:* x86 (Intel/AMD) is CISC (Complex). MIPS is RISC. MIPS does *less* per instruction, so we (the programmers) have to do *more*, but the hardware can run faster.

**2. Design Principle 1: Simplicity Favors Regularity**
*   **[WRITE ON BOARD]:** `add a, b, c`
*   In MIPS, arithmetic instructions always have **three operands**: one destination, two sources.
*   *Example:* `add $s0, $s1, $s2` means `$s0 = $s1 + $s2`.
*   *Challenge Question:* What if I want to do `f = (g + h) - (i + j)`?
    *   *Answer:* You have to break it down. You can't do it in one line.
    *   `add $t0, g, h`
    *   `add $t1, i, j`
    *   `sub f, $t0, $t1`
*   **Takeaway:** We keep the hardware simple (fixed number of operands) so we can build it smaller and faster.

**3. Operands of the Computer Hardware**
*   Unlike C or Java, where you have unlimited variables, MIPS has a limited supply of "scratchpad" locations called **Registers**.
*   **MIPS has 32 Registers** (32 bits wide each).
    *   **$s0 - $s7:** Saved registers (maps to C variables).
    *   **$t0 - $t9:** Temporary registers (for intermediate math).
    *   **$zero:** Hardwired to the value 0. (Very useful!).
*   *Why 32?* **Design Principle 2: Smaller is Faster.** If we had 1000 registers, the electrical signal would have to travel farther, slowing down the clock cycle.

---

## III. Memory & Addressing (7:00 – 7:30 PM)

**1. Data Transfer Instructions**
*   Arithmetic happens in registers. But data lives in **Memory**.
*   We need instructions to move data between the two. This is a **Load/Store Architecture**.
    *   **lw (Load Word):** Memory $\to$ Register.
    *   **sw (Store Word):** Register $\to$ Memory.

**2. Addressing & Alignment**
*   Memory is just a giant array of bytes.
*   **[DRAW ON BOARD]:** A byte array indices 0, 1, 2, 3...
*   MIPS is a **32-bit** architecture. A "Word" is 4 bytes.
*   **Alignment Restriction:** Words must start at addresses that are multiples of 4 (0, 4, 8, 12...).
*   *Example:* `lw $t0, 8($s3)`
    *   This loads the word at address `(Base Register $s3 + Offset 8)`.
    *   *Note:* The offset is in *bytes*, not words. If you want `A`, the offset is $2 \times 4 = 8$.

**3. Endianness**
*   **Big Endian:** Most Significant Byte at the lowest address (Motorola, old IBM).
*   **Little Endian:** Least Significant Byte at the lowest address (Intel, MIPS can usually switch).
*   *Note:* This affects how we view data in memory dumps, though registers always treat it as a 32-bit number.

---

## IV. BREAK (7:30 – 7:40 PM)

---

## V. The Alphabet: Numbers & Binary (7:40 – 8:15 PM)

**1. Binary & Hexadecimal**
*   Computers only speak voltage (High/Low $\to$ 1/0).
*   We use **Hexadecimal** (0x...) as a shorthand because binary gets too long to write.
*   *Quick check:* What is $2^{10}$? (1024 or 1K). What is $2^{32}$? (~4 Billion or 4 Gigabytes).

**2. Signed vs. Unsigned Numbers**
*   **Unsigned:** 0 to $2^{32}-1$. Used for addresses.
*   **Signed:** $-2^{31}$ to $2^{31}-1$. Used for math.
*   **Two's Complement:** The standard for representing negative numbers.
    *   *Why?* It allows us to use the same hardware adder for both addition and subtraction.
    *   *How to negate:* Invert every bit and add 1.
    *   *Example:*
        *   2 is `00...0010`
        *   Invert: `11...1101`
        *   Add 1: `11...1110` (This is -2).

**3. Sign Extension**
*   When we load a 16-bit immediate (like in `addi`) into a 32-bit register, what happens to the upper 16 bits?
*   **Unsigned (or Logical):** Fill with 0s.
*   **Signed (Arithmetic):** Replicate the sign bit (MSB). If it was negative, fill with 1s. If positive, fill with 0s.

---

## VI. Representing Instructions (Machine Code) (8:15 – 8:40 PM)

**1. Instructions are Numbers**
*   We write `add $t0, $s1, $s2`.
*   The assembler translates this into **Machine Language** (32 bits of 0s and 1s).

**2. R-Type Format (Register)**
*   Used for: `add`, `sub`, `and`, `or`.
*   **[DRAW FIELDS ON BOARD]:**
    *   `op` (6 bits): Opcode (0 for R-type).
    *   `rs` (5 bits): Source register 1.
    *   `rt` (5 bits): Source register 2.
    *   `rd` (5 bits): Destination register.
    *   `shamt` (5 bits): Shift amount.
    *   `funct` (6 bits): Function code (tells the CPU *which* R-type math to do, e.g., add vs. sub).

**3. I-Type Format (Immediate)**
*   Used for: `lw`, `sw`, `addi` (add immediate).
*   **Design Principle 4: Good design demands good compromise.**.
*   We want to keep all instructions the same length (32 bits) for speed, but sometimes we need a constant (immediate) value.
*   **[DRAW FIELDS ON BOARD]:**
    *   `op` (6 bits).
    *   `rs` (5 bits).
    *   `rt` (5 bits) (Destination for load, Source for store).
    *   `immediate` (16 bits): The constant or offset.

---

## VII. Logical Operations & Wrap Up (8:40 – 8:50 PM)

**1. Logical Instructions**
*   We need to manipulate bits (packing/unpacking data).
*   **sll (Shift Left Logical):** Multiplying by powers of 2.
    *   `sll $t2, $s0, 4` $\rightarrow$ shift left 4 bits (multiply by 16).
*   **and / or:** Bitwise masking and combining.
*   **nor:** Used to implement NOT (A NOR 0 = NOT A).

**2. Looking Ahead**
*   Next week (Week 3): Making Decisions.
*   We will cover `beq` (Branch if Equal) and `bne` (Branch if Not Equal). This is how we implement `if` statements and loops.
*   **Software Installation:** Please install the MIPS emulator (SPIM or QtSPIM) before next class so we can start running code.

**3. Final Thought**
*   Remember: "If you can dream it, you can build it. The thing in the middle is you got to ace this stuff—the mechanisms.".
*   See you next Thursday.