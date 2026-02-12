module dataflow_gates (
    input  logic a, b,
    output logic y_and, y_or, y_xor, y_nand, y_slow
);
    // Continuous Assignment
    assign y_and  = a & b;
    assign y_or   = a | b;
    assign y_xor  = a ^ b;
    assign y_nand = ~(a & b);

    // Modeling Delays in Dataflow:
    // While structural is "best" for low-level delay modeling, you can
    // add simulated delays to dataflow assignments for testbenches or distinct timing analysis.
    assign #5 y_slow = a & b; // Wait 5 time units before updating y_slow
endmodule
