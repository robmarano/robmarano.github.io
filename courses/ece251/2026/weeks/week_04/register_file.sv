module register_file (
    input  logic        clk,
    input  logic        we3,       // Write enable for port 3
    input  logic [4:0]  ra1, ra2,  // Read addresses (5 bits for 32 regs)
    input  logic [4:0]  wa3,       // Write address
    input  logic [31:0] wd3,       // Write data
    output logic [31:0] rd1, rd2   // Read data outputs
);
    // Shorthand: Defining an array of logic vectors
    // logic [width] name [depth];
    logic [31:0] rf[31:0]; 

    // Write Logic (Synchronous)
    always_ff @(posedge clk) begin
        if (we3) rf[wa3] <= wd3;
    end

    // Read Logic (Combinational / Asynchronous)
    // MIPS R0 is always hardwired to 0
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
