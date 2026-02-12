`timescale 1ns/1ps

module tb_full_adder;
    logic a, b, cin;
    logic sum, cout;

    full_adder uut (.*);

    initial begin
        $display("\n=========================================");
        $display("          Example 8B: Full Adder         ");
        $display("=========================================");
        $display(" Time | A B Cin | Sum Cout | Expected Sum/Cout");
        $display("------+---------+----------+------------------");
        
        // Exhaustive test for 3 bits (8 cases)
        for (int i=0; i<8; i++) begin
            {a, b, cin} = i[2:0];
            #10;
            $display(" %4t | %b %b  %b  |  %b    %b  | Sum=%b Cout=%b", 
                     $time, a, b, cin, sum, cout, (a^b^cin), ((a&b)|(cin&(a^b))) );
        end

        $display("=========================================\n");
        $finish;
    end
endmodule
