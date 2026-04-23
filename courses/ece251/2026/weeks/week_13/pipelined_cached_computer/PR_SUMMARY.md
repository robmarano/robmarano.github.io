# Pull Request Summary: MIPS32 Pipelined CPU Exceptions & Architecture Fixes

## Intent
This PR addresses critical architectural bugs identified in the 5-stage MIPS32 pipelined processor, specifically focusing on fixing asynchronous exception handling (EPC logic) and ALU control signal collisions.

## Implementation Details
1. **EPC Logic Error Remediation**:
   - Modified `datapath.sv` to correctly latch `pcplus4D - 4` into the `EPC` register during an exception flush (`Exception_Flag = 1`). This ensures the precise instruction squashed in the Decode stage is captured and re-executed when returning from the interrupt handler.
   
2. **ALU Control Expansion**:
   - Increased the `alucontrol` signal width from 3 bits to 4 bits across all pipeline stages (`aludec.sv`, `controller.sv`, `datapath.sv`, `cpu.sv`, and `alu.sv`).
   - Reassigned conflicting opcodes to unique values:
     - `MULT`: `4'b1001` (was colliding with `NOR` `3'b011`)
     - `DIV`: `4'b1000` (was colliding with `MFHI` `3'b101`)

3. **Exception Vector Memory Bounds**:
   - Verified that `imem.sv` and `dmem.sv` have sufficient addressing bounds to accommodate the OS exception handler at `0x8000_0180`.

4. **Port Instantiation Mismatch**:
   - Verified that `tb_computer.sv` now properly supplies the asynchronous `intr` port signal to the `computer` module, resolving compilation issues on strict Verilog simulators.

## Validation
- Successfully ran the standard baseline simulation (`test_prog.asm`) verifying `RAW` hazard forwarding and pipelined branch flushes.
- Successfully ran the asynchronous interrupt simulation (`test_exceptions.asm` via `tb_exceptions.sv`). The testbench correctly triggered an exception, redirected the datapath to the kernel handler, successfully tracked state into `$k0`, and correctly captured `EPC = 0x0000000c`.

## Documentation Updates
- Updated `GEMINI.md` and `TODO.md` to reflect all architectural tasks as `[RESOLVED]`.
- Updated `README.md` to mirror the accurate 4-bit ALU control specifications and documented modern VCD wave inspection tools.
- Generated `ARCHITECTURE.md` to outline the software architecture diagrams and exception sequence logic using Mermaid.js.
