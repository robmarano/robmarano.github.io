# Final Project Grading Rubric

|             **Assessment Category** | **Sub-Category**                                                                       | **Points** |
| ----------------------------------: | :------------------------------------------------------------------------------------- | :--------: |
|                      **ISA Design** |                                                                                        |   **34**   |
|                                     | ALU Operand Size                                                                       |     2      |
|                                     | Address Bus Size                                                                       |     2      |
|                                     | Addressability                                                                         |     2      |
|                                     | Register File Size                                                                     |     2      |
|                                     | Opcode Size                                                                            |     2      |
|                                     | Function Size                                                                          |     2      |
|                                     | shamt Size                                                                             |     2      |
|                                     | Instruction Size                                                                       |     2      |
|                                     | PC Increment                                                                           |     2      |
|                                     | Immediate Size                                                                         |     2      |
|                                     | R-type Instruction support                                                             |     2      |
|                                     | I-type Instruction support                                                             |     2      |
|                                     | Memory Reference Support                                                               |     2      |
|                                     | J-type Instruction support                                                             |     2      |
|                                     | R-type Instructions                                                                    |     2      |
|                                     | I-type Instructions                                                                    |     2      |
|                                     | J-type Instructions                                                                    |     2      |
|  **Memory Design & Implementation** |                                                                                        |   **16**   |
|                                     | Instruction Memory                                                                     |     3      |
|                                     | Data Memory                                                                            |     3      |
|                                     | Memory Layout                                                                          |     5      |
|                                     | Program Load into Processor                                                            |     5      |
| **Process Design & Implementation** |                                                                                        |  **120**   |
|                                     | Clock Design                                                                           |     2      |
|                                     | Overall Control Signals (regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop[]) |     10     |
|                                     | Multiplexors (regdst,alusrc,pcsrc,mem2reg)                                             |     4      |
|                                     | Main Decoder Details                                                                   |     5      |
|                                     | ALU Decoder                                                                            |     5      |
|                                     | R-Type Instruction Impl                                                                |     5      |
|                                     | I-Type Instruction Impl                                                                |     5      |
|                                     | J-Type Instruction Impl                                                                |     5      |
|                                     | PC -- Increment for R- and I-types                                                     |     5      |
|                                     | PC -- Increment for J-type                                                             |     5      |
|                                     | PC -- Increment for Cond Branch                                                        |     5      |
|                                     | Datapath Design (imem, dmem, alu, regfile, signext, sll)                               |     5      |
|                                     | PC increment adders (pc+1 adder, pc+jump adder, shift logical left)                    |     5      |
|                                     | Register File                                                                          |     5      |
|                                     | Sign Entender(s)                                                                       |     3      |
|                                     | ALU (and,or,nor,add,sub,slt)                                                           |     5      |
|                                     | Controller -- Datapath Integration                                                     |     5      |
|                                     | Program Load Integration                                                               |     4      |
|                                     | Provided Assembly Program in code                                                      |     4      |
|                                     | Hand-compiled Program                                                                  |     4      |
|                                     | Program 0 - Simple Assembly Code                                                       |     4      |
|                                     | Program 1 - Leaf Procedure Code                                                        |     5      |
|                                     | Program 2 - Nested Procedure Code                                                      |     5      |
|                                     | Program 3 - Recursive Procedure Code                                                   |     10     |
|  **Project & Design Documentation** |                                                                                        |   **30**   |
|                                     | Overall Design Explanation                                                             |     5      |
|                                     | Overall Design Diagrams                                                                |     5      |
|                                     | R-type timing diagram                                                                  |     5      |
|                                     | I-type timing diagram                                                                  |     5      |
|                                     | J-type timing diagram                                                                  |     5      |
|                                     | Instructions to Successfully Run Demo Programs                                         |     5      |
|                    **Extra Credit** |                                                                                        |   **70**   |
|                                     | Programmatic Assembler                                                                 |     15     |
|                                     | Verilog Test Benches for each element                                                  |     5      |
|                                     | Adding Structural Modeling for Circuit Delays                                          |     5      |
|                                     | Demo Video Recording on YouTube                                                        |     5      |
|                                     | Pipeline Design Support                                                                |     20     |
|                                     | Cache Support                                                                          |     20     |
