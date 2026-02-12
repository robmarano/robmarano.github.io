module reg_n #(parameter WIDTH = 8) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    genvar i; // Special variable for generate loops
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_dff
            // Each instance needs a unique name, the loop handles this
            d_flip_flop d_inst (
                .clk(clk), 
                .rst_n(rst_n), 
                .d(d[i]), 
                .q(q[i])
            );
        end
    endgenerate
endmodule
