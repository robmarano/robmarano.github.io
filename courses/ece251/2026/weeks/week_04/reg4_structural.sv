module reg4_structural (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] d,
    output logic [3:0] q
);
    // Manually connecting each bit
    d_flip_flop d0 (.clk(clk), .rst_n(rst_n), .d(d[0]), .q(q[0]));
    d_flip_flop d1 (.clk(clk), .rst_n(rst_n), .d(d[1]), .q(q[1]));
    d_flip_flop d2 (.clk(clk), .rst_n(rst_n), .d(d[2]), .q(q[2]));
    d_flip_flop d3 (.clk(clk), .rst_n(rst_n), .d(d[3]), .q(q[3]));
endmodule
