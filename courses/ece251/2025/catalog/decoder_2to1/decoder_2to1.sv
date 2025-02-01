//////////////////////////////////////////////////////////////////////////////
//
// Module: decoder_2to1
//
// 2-to-1 decoder
//
// module: decoder_2to1
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
//
// Notes on this digital circuit
//
// 1- Uses always_comb for combinational logic, which is more efficient than always @* in modern SystemVerilog.
// 2- Includes an enable signal (en). This is crucial for practical decoders. When en is 0, both outputs are 0.
// 3- Uses a nested if statement to check the sel value only when en is high. This makes the code cleaner.
///////////////////////////////////////////////////////////////////////////////
`ifndef decoder_2to1
`define decoder_2to1

module decoder_2to1 (
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input logic sel,
    input logic en,
    output logic y0,
    output logic y1
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    always_comb begin
        if (en) begin
            if (sel == 0) begin
                y0 = 1;
                y1 = 0;
            end else begin
                y0 = 0;
                y1 = 1;
            end
        end else begin
            y0 = 0;
            y1 = 0;
        end
    end
endmodule
`endif // decoder_2to1

