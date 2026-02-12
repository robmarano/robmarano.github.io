`timescale 1ns/1ps

module tb_multiplier;
    parameter WIDTH = 4;
    logic [WIDTH-1:0] a, b;
    logic [(2*WIDTH)-1:0] product;

    multiplier #(.N(WIDTH)) uut (.*);

    initial begin
        $dumpfile("multiplier.vcd");
        $dumpvars(0, tb_multiplier);

        $display("\n=========================================");
        $display("  Example 8E: %0d-Bit Multiplier         ", WIDTH);
        $display("=========================================");
        
        // 1. Simple Test
        a = 2; b = 3;
        #10;
        $display(" %d * %d = %d | Exp: 6", a, b, product);

        // 2. Max Value
        a = 4'hF; b = 4'hF; // 15 * 15 = 225 (0xE1)
        #10;
        $display(" %d * %d = %d (Hex: %h) | Exp: 225 (E1)", a, b, product, product);

        // 3. Random Testing
        repeat(5) begin
             a = $random;
             b = $random;
             #10;
             if (product !== (a * b)) begin
                 $display("ERROR: %d * %d = %d (Actual %d)!", a, b, (a*b), product);
             end else begin
                 $display(" OK: %d * %d = %d", a, b, product);
             end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
