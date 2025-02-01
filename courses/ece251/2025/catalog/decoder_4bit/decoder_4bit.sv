//////////////////////////////////////////////////////////////////////////////
//
// Module: decoder_4bit
//
// 4-bit Decoder
//
// module: decoder_4bit
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
//
// Notes on this digital circuit
//
// 1- Uses always_comb for combinational logic, which is more efficient than always @* in modern SystemVerilog.
///////////////////////////////////////////////////////////////////////////////
`ifndef decoder_4bit
`define decoder_4bit

module decoder_4bit(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input logic [3:0] sel,
    output logic [15:0] y
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    always_comb begin
        y = 16'b0; // Initialize all outputs to 0

        case (sel)
        4'b0000: y[0] = 1;
        4'b0001: y[1] = 1;
        4'b0010: y[2] = 1;
        4'b0011: y[3] = 1;
        4'b0100: y[4] = 1;
        4'b0101: y[5] = 1;
        4'b0110: y[6] = 1;
        4'b0111: y[7] = 1;
        4'b1000: y[8] = 1;
        4'b1001: y[9] = 1;
        4'b1010: y[10] = 1;
        4'b1011: y[11] = 1;
        4'b1100: y[12] = 1;
        4'b1101: y[13] = 1;
        4'b1110: y[14] = 1;
        4'b1111: y[15] = 1;
        default: y = 16'b0; // Default case to ensure all outputs are 0
        endcase
    end

endmodule

`endif // decoder_4bit