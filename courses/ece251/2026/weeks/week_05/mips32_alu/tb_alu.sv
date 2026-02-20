`timescale 1ns / 1ps

/*
 * Testbench for the MIPS32 Combinational ALU
 * 
 * Verifies standard R-Type arithmetic and logic operations defined by the 
 * OP_RTYPE (0x00) opcode and various funct codes.
 */
module tb_alu;

    // Testbench Parameters
    parameter DATA_WIDTH = 32;
    parameter OPCODE_WIDTH = 6;
    parameter FUNCT_WIDTH = 6;

    // Test Bench Signals
    logic [OPCODE_WIDTH-1:0] opcode;
    logic [FUNCT_WIDTH-1:0]  funct;
    logic [DATA_WIDTH-1:0]   rs_val;
    logic [DATA_WIDTH-1:0]   rt_val;
    logic [DATA_WIDTH-1:0]   rd_val;
    logic                    zero;

    // Instantiate the Unit Under Test (UUT)
    alu #(
        .DATA_WIDTH(DATA_WIDTH),
        .OPCODE_WIDTH(OPCODE_WIDTH),
        .FUNCT_WIDTH(FUNCT_WIDTH)
    ) uut (
        .opcode(opcode),
        .funct(funct),
        .rs_val(rs_val),
        .rt_val(rt_val),
        .rd_val(rd_val),
        .zero(zero)
    );

    // MIPS32 Funct Definitions for reference in test output
    localparam F_ADD  = 6'b100000;
    localparam F_SUB  = 6'b100010;
    localparam F_AND  = 6'b100100;
    localparam F_OR   = 6'b100101;
    localparam F_XOR  = 6'b100110;
    localparam F_NOR  = 6'b100111;
    localparam F_SLT  = 6'b101010;

    // Stimulus Task
    task test_op(input [5:0] f_code, input string op_name, input [31:0] rs, input [31:0] rt);
        begin
            funct = f_code;
            rs_val = rs;
            rt_val = rt;
            #10; // Wait 10 time units for combinational logic to settle
            $display("OP: %-4s | rs: %d, rt: %d -> rd: %d \t [zero=%b]", op_name, $signed(rs_val), $signed(rt_val), $signed(rd_val), zero);
        end
    endtask

    initial begin
        // Setup Waveform Dumping
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu);

        $display("\n=======================================================");
        $display("   MIPS32 ALU Combinational Testbench (32-bit data)  ");
        $display("=======================================================\n");

        // Set Opcode to standard R-Type (0x00) for all standard tests
        opcode = 6'b000000;

        // --- Test Cases ---
        
        $display("--- Arithmetic Operations ---");
        test_op(F_ADD, "ADD", 32'd150, 32'd50);       // 150 + 50 = 200
        test_op(F_ADD, "ADD", -32'd150, 32'd50);      // -150 + 50 = -100
        test_op(F_SUB, "SUB", 32'd1000, 32'd250);     // 1000 - 250 = 750
        test_op(F_SUB, "SUB", 32'd50, 32'd50);        // 50 - 50 = 0 (Check Zero Flag!)

        $display("\n--- Logical Operations ---");
        test_op(F_AND, "AND", 32'h0000FFFF, 32'h12345678); // Should mask upper half
        test_op(F_OR,  "OR",  32'h11110000, 32'h00002222); // Should combine halves
        test_op(F_XOR, "XOR", 32'hFFFFFFFF, 32'h55555555); // Should invert
        test_op(F_NOR, "NOR", 32'h00000000, 32'h00000000); // Should be all 1s

        $display("\n--- Set Less Than (SLT) ---");
        test_op(F_SLT, "SLT", 32'd10, 32'd20);        // 10 < 20 (True -> 1)
        test_op(F_SLT, "SLT", 32'd20, 32'd10);        // 20 < 10 (False -> 0)
        test_op(F_SLT, "SLT", -32'd5, 32'd0);         // -5 < 0 (True -> 1, signed test)

        $display("\n=======================================================\n");
        $finish;
    end

endmodule
