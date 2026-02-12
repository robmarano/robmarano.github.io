module pwm_generator (
    input  logic       clk,
    input  logic       rst,
    output logic       pwm_out
);
    logic [7:0] count;         // 8-bit counter (0-255)
    localparam DUTY_CYCLE = 64; // 25% Duty Cycle (64/256)

    // Free-running counter
    always_ff @(posedge clk) begin
        if (rst) count <= 0;
        else     count <= count + 1;
    end

    // Comparator: High when count < threshold
    assign pwm_out = (count < DUTY_CYCLE);
endmodule
