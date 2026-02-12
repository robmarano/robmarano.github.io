module clock_divider (
    input  logic clk,
    input  logic rst,
    output logic slow_clk
);
    logic [25:0] count; // 26-bit counter covers large ranges

    always_ff @(posedge clk) begin
        if (rst) 
            count <= 0;
        else 
            count <= count + 1;
    end

    // Example with 50MHz input clock:
    // count[0] toggles at 25 MHz
    // count[25] toggles at ~0.74 Hz (visible to eye)
    assign slow_clk = count[25]; 
endmodule
