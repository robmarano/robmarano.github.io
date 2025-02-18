//////////////////////////////////////////////////////////////////////////////
//
// Module: tb_full_adder
//
// Test Bench for the n-bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef tb_full_adder
`define tb_full_adder

`timescale 1ns/100ps // Time unit and time precision
// ensure you note the scale (ns) below in $monitor

// `include "full_adder.sv"
`include "fa.sv"

// ---------------- INTERFACE ----------------
interface full_adder_if #(parameter N = 8);
    logic [N-1:0] a, b;
    logic cin;
    logic [N-1:0] sum;
    logic cout;
endinterface : full_adder_if

module tb_full_adder;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    // Parameters & Variables
    localparam N = 4;
    int x = 0, y = 0, inc = 0, xyinc = 0;
    int sum = 0, outc = 0;
    full_adder_if #(N) ifc();

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    // fa #(N) faddr ( // use this line for fa.sv
    full_adder #(N) faddr ( // use this line for full_adder.sv
        .a(ifc.a),
        .b(ifc.b),
        .cin(ifc.cin),
        .sum(ifc.sum),
        .cout(ifc.cout)
    );

    // Property and Assertion
    // always @(posedge clk) begin : property_block
    //     property full_adder_property;
    //         (a + b + cin) == {cout, sum};
    //     endproperty
    //     assert property (full_adder_property)
    //         else $error("Full adder property failed!");
    // end

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("full_adder.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(0, tb_full_adder);
    end : dump_variables

    //
    // display variables
    //
    initial begin: display_variables
        $monitor($time,"ns a=%d(%b) b=%d(%b) cin=%b sum=%d(%b) cout=%b",
            ifc.a, ifc.a, ifc.b, ifc.b, ifc.cin, ifc.sum, ifc.sum, ifc.cout);
    end : display_variables

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin: apply_stimulus
        // Test cases
        // Remember value of N
        // Test 1
        // x = 0; y = 0; inc = 0; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 1 failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
        //         ifc.a, x, ifc.b, y, ifc.cin, inc, ifc.sum, xyinc, ifc.cout, 1'(xyinc[N]));

        // Test 2
        // x = 1; y = 1; inc = 0; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 2 failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
        //         ifc.a, x, ifc.b, y, ifc.cin, inc, ifc.sum, xyinc, ifc.cout, 1'(xyinc[N]));

        // Test 3
        // x = 2; y = 3; inc = 1; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 3 failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
        //         ifc.a, x, ifc.b, y, ifc.cin, inc, ifc.sum, xyinc, ifc.cout, 1'(xyinc[N]));
                
        // Test 4
        // x = 15; y = 1; inc = 1; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 4 failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
        //         ifc.a, x, ifc.b, y, ifc.cin, inc, ifc.sum, xyinc, ifc.cout, 1'(xyinc[N]));

        // Test 5
        // x = 7; y = 7; inc = 1; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 5 failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
        //         ifc.a, x, ifc.b, y, ifc.cin, inc, ifc.sum, xyinc, ifc.cout, 1'(xyinc[N]));

        // Test 6
        // x = 4; y = 11; inc = 1; xyinc = x+y+inc;
        // ifc.a = N'(x); ifc.b = N'(y); ifc.cin = 1'(inc);
        // #10;
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 5 failed: a=%d(%b)(%b), b=%d(%b)(%b), cin=%b(%b), ifc.sum=%d(%b)(%b), ifc.cout=%b(%b)",
        //         N'(x), ifc.a, N'(x), N'(y), ifc.b, N'(y), ifc.cin, inc, N'(xyinc), N'(ifc.sum), N'(xyinc), ifc.cout, 1'(xyinc[N]));
        // #10;

        // Test 7
        // x = 0; y = 0; inc = 0; xyinc = x + y + inc;
        // ifc.a = x; ifc.b = y; ifc.cin = inc;
        // #10; // wait till cout and sum are stable
        // $display("a=%d(%b)(%b), b=%d(%b)(%b), cin=%b(%b), ifc.sum=%d(%b)(%b), ifc.cout=%b(%b)",
        //     ifc.a, N'(ifc.a), N'(x), ifc.b, N'(ifc.b), N'(y), ifc.cin, 1'(inc), ifc.sum, N'(ifc.sum), N'(xyinc), ifc.cout, 1'(xyinc[N]));
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 5 failed: a=%d(%b)(%b), b=%d(%b)(%b), cin=%b(%b), ifc.sum=%d(%b)(%b), ifc.cout=%b(%b)",
        //         N'(x), ifc.a, N'(x), N'(y), ifc.b, N'(y), ifc.cin, inc, N'(xyinc), N'(ifc.sum), N'(xyinc), ifc.cout, 1'(xyinc[N]));

        // Test 8
        // x = 6; y = 0; inc = 0; xyinc = x + y + inc;
        // ifc.a = x; ifc.b = y; ifc.cin = inc;
        // #10; // wait till cout and sum are stable
        // $display("a=%d(%b)(%b), b=%d(%b)(%b), cin=%b(%b), ifc.sum=%d(%b)(%b), ifc.cout=%b(%b)",
        //     ifc.a, N'(ifc.a), N'(x), ifc.b, N'(ifc.b), N'(y), ifc.cin, 1'(inc), ifc.sum, N'(ifc.sum), N'(xyinc), ifc.cout, 1'(xyinc[N]));
        // assert (ifc.sum == N'(xyinc) && ifc.cout == xyinc[N])
        //     else $error("Test case 5 failed: a=%d(%b)(%b), b=%d(%b)(%b), cin=%b(%b), ifc.sum=%d(%b)(%b), ifc.cout=%b(%b)",
        //         N'(x), ifc.a, N'(x), N'(y), ifc.b, N'(y), ifc.cin, inc, N'(xyinc), N'(ifc.sum), N'(xyinc), ifc.cout, 1'(xyinc[N]));

        // Add more test cases as needed

        // Loop through every value of a and b
        // since adder is combinational logic, set all values to zero
        ifc.a = 0; ifc.b = 0; ifc.cin = 0;
        #10; // wait till cout and sum are stable
        for (int i = 0; i < 2**N; i++) begin: a_loop
            ifc.a = N'(i);
            for (int j = 0; j < 2**N; j++) begin: b_loop
                ifc.b = N'(j);
                for (int k = 0; k < 2; k++) begin: cin_loop
                    ifc.cin = 1'(k);
                    sum = (N+1)'(ifc.a + ifc.b + ifc.cin);
                    outc = sum[N];
                    #10; // wait till cout and sum are stable
                    assert ( (N'(ifc.sum) == N'(sum)) && (1'(ifc.cout) == 1'(outc)) )
                        else $error("Test case failed: a=%b(%b), b=%b(%b), cin=%b(%b), ifc.sum=%b(%b), ifc.cout=%b(%b)",
                            ifc.a, N'(i), ifc.b, N'(j), ifc.cin, 1'(k), ifc.sum, N'(sum), ifc.cout, 1'(outc));
                end: cin_loop
                // ifc.cin = $urandom; // Generate a random value for cin
            end: b_loop
        end: a_loop

        $finish;
    end: apply_stimulus

endmodule : tb_full_adder
`endif // tb_full_adder