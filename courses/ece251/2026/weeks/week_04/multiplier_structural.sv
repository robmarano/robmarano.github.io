module multiplier2x2 (
    input  logic [1:0] a, b,
    output logic [3:0] p
);
    logic p00, p01, p10, p11;
    logic c1;

    // 1. Generate Partial Products (AND gates)
    // p_AB means bit A of `a` AND bit B of `b`
    and (p00, a[0], b[0]);
    and (p01, a[0], b[1]);
    and (p10, a[1], b[0]);
    and (p11, a[1], b[1]);

    // 2. Summation Stage
    
    // P[0] is just a[0] & b[0]
    assign p[0] = p00;

    // P[1] is sum of (a[1]&b[0]) + (a[0]&b[1])
    // The "carry" from this goes to P[2] logic
    half_adder ha1 (.a(p10), .b(p01), .sum(p[1]), .cout(c1));

    // P[2] is sum of (a[1]&b[1]) + carry_from_bit_1
    // The "carry" from this is P[3]
    half_adder ha2 (.a(p11), .b(c1),  .sum(p[2]), .cout(p[3]));

endmodule
