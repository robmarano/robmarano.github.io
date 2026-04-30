✦ Here is the exact step-by-step walkthrough you can use for your class, tailored perfectly to the local folder you are currently in
  (courses/ece251/2026/weeks/week_13/pipelined_cached_computer).

  (Note: The terminal will render the text below in bright ANSI colors. I am representing the colors here with Markdown).

  Step 1: Set the Stage (The Hardware)
  What you say:
  > "Alright everyone, today we're looking at the 5-stage MIPS pipelined processor. Unlike a single-cycle CPU, this processor has up to 5 instructions in flight at the
  exact same time. This introduces data hazards and branch mispredictions. I'm going to show you how we write assembly for it, and more importantly, how we see exactly what
  the hardware is doing on every single clock cycle."

  Step 2: Show them the Assembly Code
  Open the terminal and print the standard test program to the screen so they can see the code they are about to run:

   1 cat test_prog.asm | head -n 12

  What you point out:
  > "Look at the first few lines. We load a value from memory (lw $t5), and then immediately try to use it in an add instruction on the very next line. Because of the
  pipeline, the lw hasn't written the data back to the register file yet. The hardware has to detect this 'Load-Use' hazard and physically stall the pipeline. Let's watch
  the hardware do exactly that."

  Step 3: Run the Standard Simulation
  Execute the primary make command to assemble, compile, and run the simulator.

   1 make clean all ASM=test_prog

  What you say:
  > "That one command just ran our Python assembler, compiled all of our SystemVerilog files, and ran the hardware simulation. All the cycle-by-cycle logs are now in
  debug_output.txt."

  Step 4: The Big Reveal (The Colored Logs)
  Show them the output.

   1 cat debug_output.txt | head -n 45

  What you point out:
  > "Look at this output. It is heavily color-coded so your eyes know exactly where to go:
  > 1.  The Blue/Purple/Yellow tags ([IF], [ID], etc.): Represent the 5 stages.
  > 2.  The Green WRITE: Shows exactly when data successfully hits memory or the register file."

  (Now show them the specific stall by jumping to Cycle 9):

   1 cat debug_output.txt | grep -A 20 "Cycle 9"

  The Output on screen:

   1 =================================================================================================
   2  Cycle 9 (Time: 1050)
   3 -------------------------------------------------------------------------------------------------
   4   [IF]   PC: 0x00000020 | Status: >> STALLED <<
   5   [ID]   Instr: 0x01a97020 | rs: 13, rt:  9 | Stall: >> STALLED << | Flush:       -
   6   [EX]   ALUOut: 0x00000054 | Flush:       -       | EPC: 0x00000000
   7   [MEM]  MemWrite: WRITE | Addr: 0x00000054 | WriteData: 0x0000000c
   8   [WB]   RegWrite: WRITE | RegDst: 12 | ResultW: 0x0000000c

  What you say:
  > "Look right there. See that bright yellow >> STALLED <<? The hazard unit detected that a Load instruction was still fetching data from memory, so it froze the Fetch and
  Decode stages to wait."

  Step 5: The Advanced Feature (Exceptions)
  What you say:
  > "Now for the fun part. What happens if a hardware component—like a timer or a keyboard—sends an asynchronous interrupt signal directly to the CPU pin while a program is
  running? The CPU has to stop what it's doing, flush the pipeline, jump to the Operating System's handler, and save the Program Counter (EPC) so it can resume later."

  Step 6: Run the Exception Test
  Run the specific target we created in the Makefile.

   1 make test_exceptions

  What you point out:
  > "This testbench forcefully spikes the intr pin high in the middle of execution. Let's look at the log to see how the hardware reacted."

   1 cat debug_output.txt | grep -B 5 -A 20 "INTERRUPT PIN"

  The Output on screen:

    1 [105000] Asserting Interrupt asynchronously!
    2 =================================================================================================
    3  Cycle 10 (Time: 105000) [!!! INTERRUPT PIN HIGH !!!]
    4 -------------------------------------------------------------------------------------------------
    5   [IF]   PC: 0x00000010 | Status:       -
    6   [ID]   Instr: 0x22100001 | rs: 16, rt: 16 | Stall:       -       | Flush: >> FLUSHED <<
    7   [EX]   ALUOut: 0x00000005 | Flush:       -       | EPC: 0x00000000
    8   [MEM]  MemWrite:   -   | Addr: 0x00000004 | WriteData: 0x00000003
    9   [WB]   RegWrite: WRITE | RegDst:  0 | ResultW: 0x00000000
   10 =================================================================================================
   11  Cycle 11 (Time: 115000) [Normal]
   12 -------------------------------------------------------------------------------------------------
   13   [IF]   PC: 0x80000180 | Status:       -
   14   [ID]   Instr: 0x00000000 | rs:  0, rt:  0 | Stall:       -       | Flush:       -
   15   [EX]   ALUOut: 0x00000006 | Flush: >> FLUSHED << | EPC: 0x0000000c

  What you say:
  > "Look at the header for Cycle 10. The header turns red: [!!! INTERRUPT PIN HIGH !!!].
  > Look at the Decode ([ID]) stage. The hazard unit immediately asserts a red >> FLUSHED <<. It throws away the instruction that was mid-flight.
  > Now look at Cycle 11. The EPC register successfully captured the exact address (0x0000000c) of the instruction it just killed so the OS knows where to return.
  > And look at the PC in the [IF] stage—it jumped abruptly from 0x10 to 0x80000180 to run the Kernel exception handler!"

  Step 7: The "Get to Work" Conclusion
  What you say:
  > "Everything you need is in the STUDENT_GUIDE.md. You just type make clean all ASM=your_file, and you read debug_output.txt. If your program isn't working, don't guess.
  Look for the yellow stalls and red flushes in the log to figure out exactly why your data isn't where you expect it to be. Get to work!"