`timescale 1ns/1ps

module tb_multiplier2x2;
    logic [1:0] a, b;
    logic [3:0] p;

    multiplier2x2 uut (.*);

    initial begin
        $dumpfile("multiplier_structural.vcd");
        $dumpvars(0, tb_multiplier2x2);

        $display("\n=========================================");
        $display("   Example 8D: 2x2 Structural Multiplier ");
        $display("=========================================");
        
        // Exhaustive test (4x4 = 16 cases)
        for (int i=0; i<4; i++) begin
            for (int j=0; j<4; j++) begin
                a = i[1:0];
                b = j[1:0];
                #10;
                if (p !== (a*b))
                     $display("ERROR: %d * %d = %d (Exp %d)", a, b, p, a*b);
                else
                     $display(" OK: %d * %d = %d", a, b, p);
            end
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
