module multiplier #(parameter N = 4) (
    input  logic [N-1:0] a, b,
    output logic [(2*N)-1:0] product
);
    // Result of N*N multiplication is 2*N bits wide
    assign product = a * b;
endmodule
