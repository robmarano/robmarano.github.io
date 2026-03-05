# ECE 251: Session 7 - What to Expect Tonight!
**Date:** March 5, 2026
**Theme:** Real-World Hardware, SPIM Magic, and Launching Your Final Project 🚀

Hey everyone! Welcome to Session 7. Tonight is a big milestone in our architecture journey! We're bridging the gap between isolated MIPS instructions and how real-world software actually runs on hardware. We're also officially kicking off your Final Projects! 

Here’s what we have planned for our 2 hours together:

### 1. Welcome & Check-in (10 mins)
*   **How’s it going?** We’ll do a quick pulse check on MIPS assembly.
*   **Tonight's Roadmap:** Getting into the real fun—I/O, memory tricks, and project ideation.

### 2. Making SPIM Talk: OS-like Library Calls (20 mins)
*   **The Magic of `syscall`:** SPIM isn't just an emulator; it acts like a mini-OS! We'll learn how to actually ask the user for input and print to the console.
*   **Interactive Demo:** We’ll write code together to prompt for a user's name and age, and even read data directly from a `.txt` file on your computer.
*   **Crash Course on Exceptions:** What actually happens when a program divides by zero or hits a bad address? We'll dive into SPIM’s `exceptions.s` file to see how hardware forcefully handles software mistakes.

### 3. Leveling Up: Advanced Assembly (25 mins)
*   **Arrays vs. Strings:** Why do we increment by 4 bytes for arrays but only 1 byte for strings? We'll trace the memory live.
*   **Conquering Recursion (`fib(3)`):** We will map out exactly how the Stack (`$sp`) grows downwards and why saving your Return Address (`$ra`) is the only thing keeping your program from catastrophically crashing during nested function calls.

### 4. Stretch Break (10 mins) ☕

### 5. Hardware vs. Software: The Quake 3 Story (25 mins)
*   **The Fast Inverse Square Root:** We’ll look at real, legendary game engine code from 1999 (Quake 3). You'll see why developers used incredible bit-hacking tricks instead of standard math to calculate 3D lighting reflections.
*   **The Emulator "Blind Spot":** We will run a benchmark that proves why testing solely on an emulator can trick you. We will use the CPU Performance Equation to prove why an algorithm that takes 14 instructions was physically 4x faster on 1999 hardware than a 2-instruction algorithm! 
*   **A Sneak Peek at Chapter 3:** We'll loosely introduce the FPU (Floating Point Unit) and how the IEEE 754 protocol handles decimals natively in silicon.

### 6. 🚀 The Final Group Project Launch! (20 mins)
*   **The Mission:** You and a partner are going to natively design and simulate your very own von Neumann CPU from scratch using SystemVerilog!
*   **What's Expected:** We'll walk through the entire 100-point rubric (ISA Design, Memory, Processor Logic, and Validation). 
*   **Extra Credit Opportunities:** Want to try pipelining, L1 Cache, or building a custom Python assembler? You can earn up to 30 EC points!

### 7. Wrap-up & Midterm Prep (10 mins)
*   **Tonight's Homework:** Find your project partner, pick a classic CPU architecture for inspiration (like the Intel 4004 or MOS 6502), and submit your 1-page Ideation proposal on Microsoft Teams.
*   **The Midterm is Next Week (Session 8)!** We'll review the newly posted [Midterm Study Guide](../../assignments/study_guide_midterm.md) and talk about what to explicitly practice (Logic Gates, K-Maps, MIPS decoding, SystemVerilog concepts, and Stack tracing).

See you all tonight! Bring your questions and let's build some hardware. 🛠️
