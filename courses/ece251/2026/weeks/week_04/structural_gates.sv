module structural_gates (
    input  logic a, b,
    output logic y_and, y_or, y_xor, y_not, y_delayed
);
    // Syntax: <gate_type> <instance_name> (output, input1, input2...);
    // Instance names (u1, u2...) are optional for primitives but good practice.
    
    and u1 (y_and, a, b);  // AND gate
    or  u2 (y_or,  a, b);  // OR gate
    xor u3 (y_xor, a, b);  // XOR gate
    not u4 (y_not, a);     // NOT gate (1 input)

    // Modeling Delays:
    // You can specify propagation delays directly on primitives.
    // 'and #3' means it takes 3 time units for the output to change.
    and #3 u5 (y_delayed, a, b); 
endmodule
