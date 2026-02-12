`timescale 1ns/1ps

module tb_n_bit_adder;
    parameter WIDTH = 4;
    logic [WIDTH-1:0] a, b;
    logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;

    // Instantiate 4-bit adder
    n_bit_adder #(.N(WIDTH)) uut (.*);

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, tb_n_bit_adder);

        $display("\n=========================================");
        $display("  Example 8C: %0d-Bit Ripple Carry Adder ", WIDTH);
        $display("=========================================");
        
        // 1. Simple Test
        cin = 0; a = 2; b = 3;
        #10;
        $display(" %d + %d (cin=%b) = %d (cout=%b) | Exp: 5", a, b, cin, sum, cout);

        // 2. Test Carry Out
        cin = 0; a = 4'hF; b = 1;
        #10;
        $display(" %h + %h (cin=%b) = %h (cout=%b) | Exp: 0, Cout=1", a, b, cin, sum, cout);

        // 3. Test Carry In propagation
        cin = 1; a = 10; b = 10; // 10+10+1 = 21 (0x15). 4-bit -> 5 with carry
        #10;
        $display(" %d + %d (cin=%b) = %d (cout=%b) | Exp: 5, Cout=1", a, b, cin, sum, cout);

        // 4. Random Testing
        repeat(5) begin
             a = $random;
             b = $random;
             cin = $random;
             #10;
             if ({cout, sum} !== (a + b + cin)) begin
                 $display("ERROR: %d + %d + %b = %d (Actual %d)!", a, b, cin, (a+b+cin), {cout, sum});
             end else begin
                 $display(" OK: %d + %d + %b = %d", a, b, cin, {cout, sum});
             end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
