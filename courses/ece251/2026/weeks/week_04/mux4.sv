module mux4 (
    input  logic [3:0] d0, d1, d2, d3,
    input  logic [1:0] sel,
    output logic [3:0] y
);
    always_comb begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 4'bxxxx; // Handle undefined cases
        endcase
    end
endmodule
