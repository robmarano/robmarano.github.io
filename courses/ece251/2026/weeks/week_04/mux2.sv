module mux2 (
    input  logic [3:0] d0, d1,
    input  logic       sel,
    output logic [3:0] y
);
    // Ternary operator is perfect for 2:1 mux
    assign y = sel ? d1 : d0; 
endmodule
