# MIPS32 Combinational Arithmetic Logic Unit (ALU)

This sub-project contains a SystemVerilog implementation of a 32-bit ALU that aligns directly with the specifications laid out in the **MIPS32 Architecture (MIPS Green Sheet)**.

## Design Highlights
*   **Fully Parameterized**: The module can be customized upon instantiation to use arbitrary bit-widths (defaults: 32-bit data, 6-bit opcode, 6-bit funct code).
*   **Combinational Logic**: This ALU operates strictly in a dataflow/combinational context asynchronously. It does *not* utilize a clock signal.
*   **Zero Flag**: Integrates the standard zero-flag output, which goes `HIGH` when the computed `rd_val` equals absolute zero.
*   **Signed vs. Unsigned**: Appropriately handles signed operations specifically for the Set Less Than (`SLT`) instruction vs unsigned Sets (`SLTU`).

## Supported Instructions (R-Type)
When the inputted opcode is set to `0x00` (R-Type instructions), the ALU relies on the **funct** code to determine the math:

| Instruction | Funct (Hex) | Funct (Binary) | ALU Logic |
| :--- | :--- | :--- | :--- |
| **add** | `0x20` | `100000` | `rd = rs + rt` |
| **addu** | `0x21` | `100001` | `rd = rs + rt` |
| **sub** | `0x22` | `100010` | `rd = rs - rt` |
| **subu** | `0x23` | `100011` | `rd = rs - rt` |
| **and** | `0x24` | `100100` | `rd = rs & rt` |
| **or** | `0x25` | `100101` | `rd = rs | rt` |
| **xor** | `0x26` | `100110` | `rd = rs ^ rt` |
| **nor** | `0x27` | `100111` | `rd = ~(rs | rt)` |
| **slt** | `0x2A` | `101010` | `rd = ($signed(rs) < $signed(rt)) ? 1 : 0` |
| **sltu**| `0x2B` | `101011` | `rd = (rs < rt) ? 1 : 0` |

## How to Test

You can run the included `tb_alu.sv` testbench using `iverilog`:

```bash
# 1. Compile the module and its testbench
iverilog -g2012 -o alu.vvp alu.sv tb_alu.sv

# 2. Run the compiled `.vvp` simulation file
vvp alu.vvp
```

This will print the calculated logic outcomes to your console dynamically and generate an `alu.vcd` waveform file for inspection in `gtkwave`.
