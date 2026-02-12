module d_latch (
    input  logic clk,
    input  logic d,
    output logic q
);
    always_latch begin
        if (clk) q <= d;
    end
endmodule
