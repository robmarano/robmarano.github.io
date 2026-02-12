module d_flip_flop (
    input  logic clk,
    input  logic rst_n, // Active low reset
    input  logic d,
    output logic q
);
    // Asynchronous Reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 0;
        else 
            q <= d;
    end
endmodule
