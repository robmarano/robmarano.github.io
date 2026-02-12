`timescale 1ns/1ps

module tb_gates;
    logic a, b;
    logic y_and_s, y_or_s, y_xor_s, y_not_s, y_del_s;
    logic y_and_d, y_or_d, y_xor_d, y_nand_d, y_slow_d;

    structural_gates u_struct (
        .a(a), .b(b),
        .y_and(y_and_s), .y_or(y_or_s), .y_xor(y_xor_s),
        .y_not(y_not_s), .y_delayed(y_del_s)
    );

    dataflow_gates u_dataflow (
        .a(a), .b(b),
        .y_and(y_and_d), .y_or(y_or_d), .y_xor(y_xor_d),
        .y_nand(y_nand_d), .y_slow(y_slow_d)
    );

    initial begin
        $display("\n===================================================================");
        $display("                 Example 1: Logic Gates Comparison                 ");
        $display("===================================================================");
        $display(" Time | A B | Struct: AND OR XOR NOT | Dataflow: AND OR XOR NAND ");
        $display("------+-----+------------------------+-----------------------------");
        $monitor(" %4t | %b %b |         %b  %b   %b   %b  |           %b  %b   %b    %b",
                 $time, a, b, y_and_s, y_or_s, y_xor_s, y_not_s, y_and_d, y_or_d, y_xor_d, y_nand_d);
        
        a = 0; b = 0;
        #10;
        a = 0; b = 1;
        #10;
        a = 1; b = 0;
        #10;
        a = 1; b = 1;
        #10;
        $display("===================================================================\n");
        $finish;
    end
endmodule
