`timescale 1ns/1ps

module tb_half_adder;
    logic a, b;
    logic sum, cout;
    
    // Expected values for checking
    logic exp_sum, exp_cout;
    assign exp_sum = a ^ b;
    assign exp_cout = a & b;

    half_adder uut (.*);

    initial begin
        $display("\n=========================================");
        $display("          Example 8A: Half Adder         ");
        $display("=========================================");
        $display(" Time | A B | Sum Cout | Expected");
        $display("------+-----+----------+---------");
        $monitor(" %4t | %b %b |  %b    %b  | Sum=%b Cout=%b", $time, a, b, sum, cout, exp_sum, exp_cout);

        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;

        $display("=========================================\n");
        $finish;
    end
endmodule
