# Clock Dividers

# Divide by 2

`clock_div_2.sv`
```verilog
`ifndef CLOCK_DIV_2
`define CLOCK_DIV_2

module clock_div_2(
        input clk, rst,
        output logic clk_out
);
    always_ff @(posedge clk) begin
        if(rst) begin
            clk_out <= 1'b0;
        end else begin
            clk_out <= ~clk_out;
        end
    end
endmodule

`endif // CLOCK_DIV_2
```

# Divide by 2n

`clock_div_2n.sv`
```verilog
/*
A clock Divide by 2N circuit has a clock as an input and it divides the clock input by 2N. So for example,
if the frequency of the clock input is 50 MHz, and N = 5, the frequency of the output will be 5 MHz.
In other words the time period of the outout clock will be 2N times time perioud of the clock input.

To generate a clock frequency ny even number you only need to work on the rising edge of clock and
hence the circuit is simplified and potentially free from the glitches that a clock divided by an odd number works.

Problem - Write verilog code that has a clock and a reset as input. It has an output that can be called clk_out.
The clk_out is also a clock that has a frequency that is 1/2N frequency of the input clock.
It has synchronous reset and if there if the reset is 1, the outclock resets to 0. Write test bench to verify it.
 */

`ifndef CLOCK_DIV_2N
`define CLOCK_DIV_2N

module clock_div_2n
    # (
        parameter WIDTH = 3, // width of the register required to store the count
        parameter N = 6 // divide by 2*6 in this case
    )(
        input clk, rst,
        output logic clk_out
);

    reg [WIDTH-1:0] r_reg;
    wire [WIDTH-1:0] r_next;
    reg clk_track;

    always @(posedge clk or posedge rst) begin
        if(rst)
            begin
                r_reg <= 0;
                clk_track <= 1'b0;
            end
        else if (r_next == N)
            begin
                r_reg <= 0;
                clk_track <= ~clk_track;
            end
        else
            begin
                r_reg <= r_next;
            end
    end

    assign r_next = r_reg + 1;
    assign clk_out = clk_track;

endmodule

`endif // CLOCK_DIV_2N
```

# Test Bench for div_2 and div_2n

`tb_clock_dividers.sv`
```verilog
`timescale 1ns/100ps

`include "../clock/clock.sv"
`include "clock_div_2.sv"
`include "clock_div_2n.sv"

module tb_clock_dividers;
    //
    // ---------------- DECLARATIONS OF PARAMETERS ----------------
    //
    localparam P = 10;

    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic

    //outputs are wire for test bench - or use logic
    reg CLK;
    wire CLK_DIV_2, CLK_DIV_2N;
    reg RST;

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    
    initial begin
        $monitor ($time,"\tCLK=%b\tCLK_DIV_2=%b\tCLK_DIV_2N=%b", CLK, CLK_DIV_2, CLK_DIV_2N);
    end

    initial begin
        $dumpfile("tb_clock_dividers.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut1, dut2, dut3);
    end
  
      //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_signals
        RST = 1'b0;
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //

    initial begin: prog_apply_stimuli
    #0
    #10	
    #10 RST = 1'b1;
    #10 RST = 1'b0;
    #500
    $finish;
    end


    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    clock #(.period(P)) dut1(
        .clk(CLK)
    );

    clock_div_2 dut2(
        .clk(CLK), .rst(RST), .clk_out(CLK_DIV_2)
    );

    clock_div_2n #(4,8) dut3(
        .clk(CLK), .rst(RST), .clk_out(CLK_DIV_2N)
    );

endmodule
```

## Commands to run
Compile
```bash
iverilog -g2012 -o clock_dividers tb_clock_dividers.sv clock_div_2.sv clock_div_2n.sv
```
Simulate
```bash
vvp -lxt2 clock_dividers
```
Display with GTKwave
```bash
gtkwave tb_clock_dividers.vcd
```