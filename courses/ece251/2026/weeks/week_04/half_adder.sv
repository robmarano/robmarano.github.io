module half_adder (
    input  logic a, b,
    output logic sum, cout
);
    xor u1 (sum, a, b);  // Sum = A ^ B
    and u2 (cout, a, b); // Carry = A & B
endmodule
