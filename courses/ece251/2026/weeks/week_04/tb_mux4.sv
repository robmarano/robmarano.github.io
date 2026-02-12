`timescale 1ns/1ps

module tb_mux4;
    logic [3:0] d0, d1, d2, d3;
    logic [1:0] sel;
    logic [3:0] y;

    mux4 uut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .sel(sel), .y(y)
    );

    initial begin
        $display("\n=========================================");
        $display("         Example 2: 4:1 Multiplexor      ");
        $display("=========================================");
        d0 = 1; d1 = 2; d2 = 3; d3 = 4;
        sel = 0;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 1)", sel, d0,d1,d2,d3,y);
        sel = 1;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 2)", sel, d0,d1,d2,d3,y);
        sel = 2;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 3)", sel, d0,d1,d2,d3,y);
        sel = 3;
        #10 $display("Sel=%b Inputs=(%d,%d,%d,%d) -> Out=%d (Exp 4)", sel, d0,d1,d2,d3,y);
        $display("=========================================\n");
        $finish;
    end
endmodule
