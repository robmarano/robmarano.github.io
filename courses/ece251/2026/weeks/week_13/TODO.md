# Week 13 / Memory Hierarchy TODOs

## Immediate Future Work (Week 14)
- [ ] **Miss Penalty FSM:** We stopped the SystemVerilog implementation at the combinational hit logic. We need to implement the Finite State Machine that stalls the CPU, triggers the fetch from Main Memory, writes the block into the cache, and resumes the CPU.
- [ ] **Virtual Memory:** Prepare notes and slides for Section 5.6 (Virtual Memory, Page Tables).
- [ ] **TLB (Translation Lookaside Buffer):** Explain how a cache for the page table dramatically speeds up translation.

## Final Project Integration
- [ ] Update the `final_project/GUIDE.md` to introduce the Cache Controller requirement.
- [ ] Provide students with a `tb_memory.sv` wrapper that forces a cache miss latency (e.g., 50 cycles) to test if their pipelined CPU stall logic actually works.
- [ ] Define the exact associativity (e.g., Direct-Mapped) required for the Final Project.
