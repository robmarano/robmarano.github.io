module tb_bit_manip;
    logic [3:0] a = 4'b1100;
    logic [3:0] b = 4'b0011;
    logic [7:0] y_concat;
    logic [7:0] y_repl;
    logic [3:0] reversed;

    assign y_concat = {a, b};          // Concatenation: 11000011
    assign y_repl = {2{a}};          // Replication: 11001100
    assign reversed = {a[0], a[1], a[2], a[3]}; // Manual reverse: 0011

    initial begin
        $display("\n=========================================");
        $display("       Example 4: Bit Manipulation       ");
        $display("=========================================");
        #1;
        $display("Inputs: a=%b, b=%b", a, b);
        $display("1. Concatenation {a,b}:    %b (Exp 11000011)", y_concat);
        $display("2. Replication   {2{a}}:   %b (Exp 11001100)", y_repl);
        $display("3. Reversal      {a[i]..}: %b (Exp 0011)", reversed);
        $display("=========================================\n");
        $finish;
    end
endmodule
