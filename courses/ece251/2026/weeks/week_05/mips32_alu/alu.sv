`timescale 1ns / 1ps

/*
 * MIPS32 Combinational Arithmetic Logic Unit (ALU)
 * 
 * Supports standard R-Type arithmetic and logic operations defined by the 
 * OP_RTYPE (0x00) opcode and various funct codes.
 */
module alu #(
    parameter DATA_WIDTH = 32,
    parameter OPCODE_WIDTH = 6,
    parameter FUNCT_WIDTH = 6
)(
    input  logic [OPCODE_WIDTH-1:0] opcode,
    input  logic [FUNCT_WIDTH-1:0]  funct,
    input  logic [DATA_WIDTH-1:0]   rs_val,
    input  logic [DATA_WIDTH-1:0]   rt_val,
    output logic [DATA_WIDTH-1:0]   rd_val,
    output logic                    zero
);

    // MIPS32 Opcode definitions
    localparam OP_RTYPE = 6'b000000; // 0x00

    // MIPS32 Funct definitions (for OP_RTYPE)
    localparam F_ADD  = 6'b100000; // 0x20
    localparam F_ADDU = 6'b100001; // 0x21
    localparam F_SUB  = 6'b100010; // 0x22
    localparam F_SUBU = 6'b100011; // 0x23
    localparam F_AND  = 6'b100100; // 0x24
    localparam F_OR   = 6'b100101; // 0x25
    localparam F_XOR  = 6'b100110; // 0x26
    localparam F_NOR  = 6'b100111; // 0x27
    localparam F_SLT  = 6'b101010; // 0x2A
    localparam F_SLTU = 6'b101011; // 0x2B

    // Combinational Logic Block
    always_comb begin
        // Default assignment to prevent inferred latches
        rd_val = {DATA_WIDTH{1'b0}};

        if (opcode == OP_RTYPE) begin
            case (funct)
                F_ADD, F_ADDU:  rd_val = rs_val + rt_val;
                F_SUB, F_SUBU:  rd_val = rs_val - rt_val;
                F_AND:          rd_val = rs_val & rt_val;
                F_OR:           rd_val = rs_val | rt_val;
                F_XOR:          rd_val = rs_val ^ rt_val;
                F_NOR:          rd_val = ~(rs_val | rt_val);
                F_SLT:          // Signed comparison
                                rd_val = ($signed(rs_val) < $signed(rt_val)) ? 
                                         {{DATA_WIDTH-1{1'b0}}, 1'b1} : 
                                         {DATA_WIDTH{1'b0}};
                F_SLTU:         // Unsigned comparison
                                rd_val = (rs_val < rt_val) ? 
                                         {{DATA_WIDTH-1{1'b0}}, 1'b1} : 
                                         {DATA_WIDTH{1'b0}};
                default:        rd_val = {DATA_WIDTH{1'b0}}; // Unknown funct
            endcase
        end else begin
            // Non R-Type logic would go here (e.g. OP_ADDI, OP_BEQ)
            // For now, default to zero
            rd_val = {DATA_WIDTH{1'b0}};
        end
    end

    // Flag generation
    assign zero = (rd_val == {DATA_WIDTH{1'b0}});

endmodule
