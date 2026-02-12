module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    logic s1, c1, c2;

    // First Half Adder: A + B -> S1, C1
    half_adder ha1 (.a(a), .b(b), .sum(s1), .cout(c1));

    // Second Half Adder: S1 + Cin -> Sum, C2
    half_adder ha2 (.a(s1), .b(cin), .sum(sum), .cout(c2));

    // Carry Logic: If either HA generated a carry, we have a carry out
    or u3 (cout, c1, c2);
endmodule
