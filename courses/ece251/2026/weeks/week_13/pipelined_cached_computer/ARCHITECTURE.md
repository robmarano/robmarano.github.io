# MIPS32 Pipelined CPU Architecture & Exception Logic

This document details the software architecture, datapath components, and sequence diagrams corresponding to the MIPS32 pipelined processor, specifically highlighting the handling of asynchronous exceptions and external interrupts.

## Software Architecture: Hardware Component Interaction

The MIPS32 processor is modeled structurally in SystemVerilog. The diagram below illustrates the hierarchical instantiation of modules and how control signals, like `Exception_Flag`, propagate down to affect the pipeline logic.

```mermaid
graph TD
    TB[Testbench: tb_exceptions.sv] -->|Provides clk, reset, intr| C[Computer: computer.sv]
    C -->|Instantiates| CPU[CPU Wrapper: cpu.sv]
    C -->|Instruction Fetch| IM[IMEM: imem.sv]
    C -->|Data R/W| DM[DMEM: dmem.sv]
    
    CPU -->|Decodes Instructions| CTRL[Controller: controller.sv]
    CPU -->|Routes Data| DP[Datapath: datapath.sv]
    CPU -->|Resolves Stalls/Flushes| HAZ[Hazard Unit: hazard.sv]

    CTRL -->|Main Control Signals| MD[Main Decoder: maindec.sv]
    CTRL -->|ALU Control 4-bit| AD[ALU Decoder: aludec.sv]
    
    HAZ -->|Intr -> Exception_Flag| DP
    HAZ -->|flushD, flushE| DP
    
    DP -->|PC Logic & Registers| RegFile[Register File: regfile.sv]
    DP -->|Arithmetic| ALU[ALU: alu.sv]
    DP -->|Exception Tracking| EPC[EPC Latch]
    
    style TB fill:#f9f,stroke:#333,stroke-width:2px
    style HAZ fill:#ff9,stroke:#333,stroke-width:2px
    style EPC fill:#bbf,stroke:#333,stroke-width:2px
```

## Exception Handling: Sequence Diagram

When an external interrupt pin (`intr`) is asserted high, the pipeline must be safely flushed to prevent the execution of in-flight instructions in the `ID` and `EX` stages while correctly capturing the `PC` to return to via `EPC`.

The sequence diagram below visualizes the cycle-by-cycle behavior during an asynchronous interrupt.

```mermaid
sequenceDiagram
    autonumber
    actor External as External Source
    participant TB as Testbench (tb_exceptions)
    participant HAZ as Hazard Unit
    participant DP as Datapath (IF/ID)
    participant EPC as EPC Latch
    participant IM as Instruction Memory
    
    External->>TB: Assert 'intr' pin
    TB->>HAZ: Propagate intr signal
    Note over HAZ: Hazard unit detects interrupt
    HAZ->>HAZ: Assert Exception_Flag = 1
    
    HAZ->>DP: Assert flushD = 1
    HAZ->>DP: Assert flushE = 1
    
    Note over DP: Instruction in Decode (ID) is squashed (converted to NOP)
    Note over DP: Instruction in Execute (EX) is squashed
    
    DP->>EPC: Latch EPC <= pcplus4D - 4
    Note over EPC: Captures exact PC of squashed ID instruction
    
    DP->>DP: Force pcnextFD = 0x8000_0180
    DP->>IM: Fetch from Exception Vector
    
    IM-->>DP: Return OS Handler Instruction
    Note over DP: Pipeline resumes execution in Kernel Mode
```

## Datapath Exception Redirection Logic

The `datapath.sv` module controls the flow of execution. Upon receiving `Exception_Flag`, the `Next PC` multiplexer is forced to target the pre-defined kernel exception address.

```mermaid
flowchart LR
    PC_Reg[Program Counter] --> |pcF| IMEM[(Instruction Memory)]
    IMEM --> |instrF| IF_ID[IF/ID Pipeline Register]
    
    PC_Reg --> Adder_4(+4)
    Adder_4 --> pcplus4F
    
    pcplus4F --> Mux_Branch{Branch Mux}
    pcbranchD --> Mux_Branch
    
    Mux_Branch --> Mux_Jump{Jump Mux}
    pcjumpFD --> Mux_Jump
    
    Mux_Jump --> Mux_Exception{Exception Mux}
    Vector[0x8000_0180] --> Mux_Exception
    
    Exception_Flag((Exception_Flag)) -.->|Select=1| Mux_Exception
    
    Mux_Exception --> |pcnextFD| PC_Reg

    IF_ID -.-> |flushD=1| NOP[Clear ID Stage]
```

## ALU Control Signal Expansion

To resolve decoding collisions, the 3-bit `alucontrol` was natively expanded to a 4-bit bus. The updated operational mapping ensures isolated combinational logic.

| Operation | `alucontrol` (4-bit) | Logic Component Used | Note |
|---|---|---|---|
| AND | `0000` | Combinational | bitwise & |
| OR | `0001` | Combinational | bitwise \| |
| ADD | `0010` | Combinational | a + b |
| NOR | `0011` | Combinational | ~(a \| b) |
| MFLO | `0100` | Combinational | Read lower 32-bits of HiLo |
| MFHI | `0101` | Combinational | Read upper 32-bits of HiLo |
| SUB | `0110` | Combinational | a - b |
| SLT | `0111` | Combinational | Set if a < b |
| DIV | `1001` | Sequential | a / b & a % b (updates HiLo) |
| MULT | `1000` | Sequential | a * b (updates HiLo) |
