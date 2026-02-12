module n_bit_adder #(parameter N = 4) (
    input  logic [N-1:0] a, b,
    input  logic         cin,
    output logic [N-1:0] sum,
    output logic         cout
);
    // Internal carry chain. 
    // c[0] is input carry, c[N] is output carry.
    wire [N:0] c; 

    assign c[0] = cin;
    assign cout = c[N]; 

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_adder
            // Connect carry out of previous stage (i) to carry in of this stage (i)
            // Wait, previous stage output is c[i+1]? No.
            // Full Adder: a, b, cin(from prev), sum, cout(to next)
            // c[0] -> FA[0] -> c[1] -> FA[1] ...
            full_adder fa_inst (
                .a(a[i]), 
                .b(b[i]), 
                .cin(c[i]), 
                .sum(sum[i]), 
                .cout(c[i+1])
            );
        end
    endgenerate
endmodule
