# Assignment 2
[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)


< 5 points >
<details>
<summary>Homework Pointing Scheme</summary>
{% highlight markdown %}
| Total points | Explanation                                                                                                                                                                       |
| -----------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|            0 | Not handed in                                                                                                                                                                     |
|            1 | Handed in late                                                                                                                                                                    |
|            2 | Handed in on time, not every problem fully worked through and clearly identifying the solution                                                                                    |
|            3 | Handed in on time, each problem answered a boxed answer, each problems answered with a clearly worked through solution, and **less than majority** of problems answered correctly |
|            4 | Handed in on time, **majority** of problems answered correctly, each solution boxed clearly, and each problem fully worked through                                                |
|            5 | Handed in on time, every problem answered correctly, every solution boxed clearly, and every problem fully worked through.    
{% endhighlight %}
</details>

## Problem Set

**GitHub Classroom Assignment Link:** [https://classroom.github.com/a/GSFzh7kV](https://classroom.github.com/a/GSFzh7kV)

Do your work on your specific GitHub Classroom repo. Remember to just add the GitHub repository to the Microsoft Team's assignment from here. Using Behavioral Modeling in SystemVerilog, create the following modules that will be used in your final project — your CPU and memory design of your own computer. Parameterize your bit length so that you can define any bit size in your test bench, not hardcoding that in your module definition. Use 8-bits are the default bit length.

1. n-bit full adder
2. (arithmetic) sign extender
3. clock
4. program counter, with inputs clock, reset, enable, increment
5. DFF, with inputs clock, reset, enable
6. n-bit register built from DFF, with inputs clock, reset, enable

### Solution to Problem 1
#### n-bit full adder
<details>
<summary><code>full_adder.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: full_adder
//
// Parameterized n-bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef full_adder
`define full_adder

`include "bit_full_adder.sv"

module full_adder #(parameter N = 8) (
  input logic [N-1:0] a, b,
  input logic cin,
  output logic [N-1:0] sum,
  output logic cout
);

  wire [N-1:0] carry;

  genvar i;
  generate
    for (i = 0; i < N; i++) begin: adder_stages
      // LSb gets cin, others get carry from previous stage
      if (i == 0) begin 
          bit_full_adder fa (
              .a(a[i]), .b(b[i]), .cin(cin), 
              .sum(sum[i]), .cout(carry[i])
          );
      // get carry from previous stage
      end else begin 
          bit_full_adder fa (
              .a(a[i]), .b(b[i]), .cin(carry[i-1]), 
              .sum(sum[i]), .cout(carry[i])
          );
      end
    end: adder_stages
  endgenerate

  assign cout = carry[N-1];

endmodule : full_adder
`endif // full_adder
{% endhighlight %}
</details>

<details>
<summary><code>tb_full_adder.sv</code></summary>
{% highlight verilog %}
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

`include "full_adder.sv"
//`include "fa.sv"

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
{% endhighlight %}
</details>

<details>
<summary><code>bit_full_adder.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: bit_full_adder
//
// Parameterized one bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef bit_full_adder
`define bit_full_adder

module bit_full_adder (
  input logic a, b, cin,
  output logic sum, cout
);

  logic p, g;

  always_comb begin : one_bit_full_adder
    // blocking assignments
    p = a ^ b;
    g = a & b;
    sum = p ^ cin;
    cout = g | (p & cin);    
  end : one_bit_full_adder

endmodule : bit_full_adder

`endif // bit_full_adder

// module bit_full_adder (
//     input logic a, b, cin, 
//     output logic sum, cout
// );
//     always_comb begin : one_bit_full_adder
//       sum = a ^ b ^ cin; 
//       cout = (a & b) | (b & cin) | (a & cin);
//     end : one_bit_full_adder

//   // assign sum = a ^ b ^ cin;
//   // assign cout = (a & b) | (a & cin) | (b & cin);

// endmodule: bit_full_adder

{% endhighlight %}
</details>

##### Extras
<details>
<summary><code>fa.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: fa
//
// Parameterized n-bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef fa
`define fa

module fa #(parameter N = 8) (
  input logic [N-1:0] a, b,
  input logic cin,
  output logic [N-1:0] sum,
  output logic cout
);

  assign {cout, sum} = a + b + cin;
endmodule : fa
`endif // fa
{% endhighlight %}
</details>

<details>
<summary><code>bit_half_adder.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: bit_half_adder
//
// Parameterized one bit full adder
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef bit_half_adder
`define bit_half_adder

module bit_half_adder (
    input logic a, b,
    output logic sum, cout
);
    always_comb begin : one_bit_half_adder
      sum = a ^ b; 
      cout = (a & b);
    end : one_bit_half_adder

endmodule: bit_half_adder

`endif // bit_half_adder
{% endhighlight %}
</details>

<details>
<summary><code>Makefile</code></summary>
{% highlight makefile %}
#
# Makefile for Verilog building
# reference https://wiki.hacdc.org/index.php/Iverilogmakefile
# 
# USE THE FOLLOWING COMMANDS WITH THIS MAKEFILE
#	"make check" - compiles your verilog design - good for checking code
#	"make simulate" - compiles your design+TB & simulates your design
#	"make display" - compiles, simulates and displays waveforms
# 
###############################################################################
#
# CHANGE THESE THREE LINES FOR YOUR DESIGN
#
#TOOL INPUT
#THIS NEEDS TO MATCH THE NAME OF YOUR MODULE
# just type on command line: make COMPONENT=module_name {compile, simulate, display, clean}
ifeq ($(COMPONENT),)
  $(error COMPONENT must be defined.  Please specify it on the command line, e.g., make COMPONENT=my_component)
endif

#SRC = $(shell ls *.sv)
SRC = $(wildcard *.sv)
SIM_ARGS=+a=3 +b=2 +s=0
TBOUTPUT = $(COMPONENT).vcd	# THIS NEEDS TO MATCH THE OUTPUT FILE FROM YOUR TESTBENCH
###############################################################################
# BE CAREFUL WHEN CHANGING ITEMS BELOW THIS LINE
###############################################################################
#TOOLS
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave #works on your host, not docker container since it's a GUI
#TOOL OPTIONS
COFLAGS = -g2012 #-v
SFLAGS = -M . #-v
SOUTPUT = -lxt2		#SIMULATOR OUTPUT TYPE
#TOOL OUTPUT
#COUTPUT = compiler.out			#COMPILER OUTPUT
###############################################################################
#MAKE DIRECTIVES
.PHONY: compile simulate display clean
compile : $(SRC)
	@echo "Compiling component: $(COMPONENT)"
	$(COMPILER) $(COFLAGS) -o $(COMPONENT).vvp $(SRC)

simulate: $(COMPONENT).vvp
	@echo "Simulating component: $(COMPONENT)"
	$(SIMULATOR) $(SFLAGS) $(COMPONENT).vvp $(SOUTPUT)

display:
	@echo "Opening GTKwave for component: $(COMPONENT)"
	$(VIEWER) $(TBOUTPUT) &

clean:
	/bin/rm -f $(COMPONENT) $(COMPONENT).vvp $(TBOUTPUT) *.vcd a.out compiler.out

{% endhighlight %}
</details>

<details>
<summary><code>makefile.ps1</code></summary>
{% highlight powershell %}
# makefile.ps1
# USAGE: .\makefile.ps1 your_module_name {compile, simulate, display, clean}
#
# Get the command line arguments
$COMPONENT = $args[0] # Name of the module
$command = $args[1]

#$COMPONENT = "dff" # Name of the module
#
$SRC = "$COMPONENT.sv"
$TESTBENCH = "tb_$COMPONENT.sv"
$TBOUTPUT = "tb_$COMPONENT.vcd"
$filesToRemove = @("$COMPONENT", "$TBOUTPUT")

# TOOLS
# You need to update the paths below to the tools in your system
$COMPILER = "C:\ProgramData\chocolatey\bin\iverilog.exe"
$SIMULATOR = "C:\ProgramData\chocolatey\bin\vvp.exe"
$VIEWER = "C:\ProgramData\chocolatey\bin\gtkwave.exe" # GUI app
# TOOL OPTIONS
$COFLAGS = "-g2012"
$SFLAGS = "-M ."		#SIMULATOR FLAGS
$SOUTPUT = "-lxt2"		#SIMULATOR OUTPUT TYPE

# Use a switch statement to handle different commands
switch ($command) {
    'compile' {
        # Code to execute when the command is 'compile'
        Write-Host "Compiling..."
        #
        # Compile Verilog file
        #
        # $COMPILER $COFLAGS -o $COMPONENT $TESTBENCH $SRC
        $compileProcessOptions = @{
            FilePath          = "$COMPILER"
            ArgumentList      = @("$COFLAGS", "-o", "$COMPONENT", "$TESTBENCH", "$SRC")
            UseNewEnvironment = $true
        }
        Start-Process -NoNewWindow -Wait @compileProcessOptions
    }
    'simulate' {
        # Code to execute when the command is 'simulate'
        Write-Host "Simulating..."
        #
        # Simulate Verilog module with testbench
        # $(SIMULATOR) $(SFLAGS) $(COMPONENT) $(TESTBENCH) $(SOUTPUT)
        $simulateProcessOptions = @{
            FilePath          = "$SIMULATOR"
            ArgumentList      = @("$SFLAGS", "$COMPONENT", "$SOUTPUT")
            UseNewEnvironment = $true
        }
        Write-Output @simulateProcessOptions
        Start-Process @simulateProcessOptions -NoNewWindow -Wait
    }
    'display' {
        # Code to execute when the command is 'display'
        Write-Host "Displaying..."
        #
        # Display Verilog module with testbench
        # $(SIMULATOR) $(SFLAGS) $(COMPONENT) $(TESTBENCH) $(SOUTPUT)
        $displayProcessOptions = @{
            FilePath          = "$VIEWER"
            ArgumentList      = @("$TBOUTPUT")
            UseNewEnvironment = $true
        }
        Start-Process @displayProcessOptions -NoNewWindow -Wait
    }
    'clean' {
        # Code to execute when the command is 'display'
        Write-Host "Cleaning up..."
        # Clean up from last run
        Write-Output "Removing files: $filesToRemove"
        $filesToRemove | ForEach-Object { Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue -Confirm:$false }

    }
    default {
        # Code to execute when the command is not recognized
        Write-Host "Incorrect use of '.\makefile.ps1'. `nPlease provide the Verilog module name and the command to run with options given as follows:"
        Write-Host "`t.\makefile.ps1 <module_name> <command - 'compile', 'simulate', 'display', 'clean'>"
    }
}
{% endhighlight %}
</details>

### Solution to Problem 2
#### (arithmetic) sign extender

#### Sign Extension Techniques

Two's complement representation is how negative numbers are typically stored in computers. The MSB indicates the sign (0 for positive, 1 for negative).  To extend a negative number, you must fill the new higher-order bits with 1s.  This preserves the negative value. For positive numbers, you fill the new higher-order bits with 0s.  Our manual method achieves exactly this.

Comparison:

* **SystemVerilog's `$signed` method**: Concise, easier to read, and less prone to errors. It's the recommended approach in almost all cases.
* **Manual method**: More verbose but helps you understand the underlying principles of sign extension and two's complement. It might be useful in situations where you need very fine-grained control or where $signed is not available (though that's rare).

In almost all practical design scenarios, stick with the $signed method.  It's the industry standard for a reason.  However, understanding the manual method gives you a deeper appreciation for how these fundamental operations work.  It's like knowing how a car engine works, even if you just drive the car!  Any more questions?  Let's keep the discussion going.

#### Example of SystemVerilog's `$signed`
```verilog
logic signed [3:0] small_val;
logic signed [7:0] large_val;

small_val = 4'b1000; // -8

large_val = $signed(small_val); // Sign-extended to -8 in 8 bits (8'hF8)

small_val = $signed(large_val); // Narrowed.  The MSB of large_val (1) is copied into small_val's MSB. The lower 3 bits are also copied.  small_val remains -8.

small_val = 4'b0111; // +7

large_val = $signed(small_val); // Sign-extended to +7 in 8 bits (8'h07)

small_val = $signed(large_val); // Narrowed. The MSB of large_val (0) is copied into small_val's MSB. The lower 3 bits are also copied. small_val remains +7.
```

<details>
<summary><code>sign_extender_manual.sv</code> (Using Verilog's <u>bit swizzling</u>)</summary>
{% highlight verilog %}
// sign_extender_manual.sv
module sign_extender_manual #(parameter WIDTH = 8) (
  input  logic [WIDTH/2-1:0] data_in,
  output logic [WIDTH-1:0]   data_out
);

  // Extract the MSB
  logic msb;
  assign msb = data_in[WIDTH/2-1];

  // Sign-extend using a conditional assignment to avoid x's
  always_comb begin
    if (msb == 1'b1) begin
      data_out = { {WIDTH/2{1'b1}}, data_in }; // Extend with 1s
    end else begin
      data_out = { {WIDTH/2{1'b0}}, data_in }; // Extend with 0s
    end
  end

endmodule
{% endhighlight %}
</details>

<details>
<summary><code>tb_sign_extender_manual.sv</code></summary>
{% highlight verilog %}

// sign_extender_tb.sv
module tb_sign_extender;
  // Parameters
  localparam WIDTH = 8;

  // Signals
  logic signed [WIDTH/2-1:0] data_in;
  logic signed [WIDTH-1:0]   data_out;

  // Instantiate the sign extender
  sign_extender_manual #(WIDTH) ext (
    .data_in  (data_in),
    .data_out (data_out)
  );

  // Test cases
  initial begin
    $display("Running tests...");

    // Test positive numbers
    data_in = 4'b0100;  // +4
    #10; // Small delay for signal propagation
    $display("Input: %h(%b), Output: %h(%b)", data_in, data_in, data_out, data_out);
    assert (data_out == 8'h04)
        else $error("Test failed!");

    data_in = 4'b0001; // +1
    #10;
    $display("Input: %h(%b), Output: %h(%b)", data_in, data_in, data_out, data_out);
    assert (data_out == 8'h01)
        else $error("Test failed!");


    // Test negative numbers
    data_in = 4'b1000; // -8 (2's complement)
    #10;
    $display("Input: %h(%b), Output: %h(%b)", data_in, data_in, data_out, data_out);
    assert (data_out == 8'hf8)
        else $error("Test failed!");

    data_in = 4'b1111; // -1 (2's complement)
    #10;
    $display("Input: %h(%b), Output: %h(%b)", data_in, data_in, data_out, data_out);
    assert (data_out == 8'hff)
        else $error("Test failed!");

    // Test zero
    data_in = 4'b0000; // 0
    #10;
    $display("Input: %h(%b), Output: %h(%b)", data_in, data_in, data_out, data_out);
    assert (data_out == 8'h00)
        else $error("Test failed!");

    $finish;
  end

endmodule
{% endhighlight %}
</details>

<details>
<summary><code>sign_extender.sv</code> (Using SystemVerilog's `$signed`)</summary>
{% highlight verilog %}
// sign_extender.sv
module sign_extender #(parameter WIDTH = 8) (
  input  logic signed [WIDTH/2-1:0] data_in, // Input data (half the output width)
  output logic signed [WIDTH-1:0]   data_out // Output data (full width)
);

  assign data_out = $signed(data_in); // Sign extension happens implicitly with $signed

endmodule
{% endhighlight %}
</details>

### Solution to Problem 3
#### clock

<details>
<summary><code>configurable_clock.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: configurable_clock
//
// Clock generator with configurable period and duty cycle
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef configurable_clock
`define configurable_clock

module configurable_clock
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter integer WIDTH = 8, // Width of the counter and period/duty cycle values
    parameter real FAST_CLK_PERIOD = 1.0 // Period of the faster clock (e.g., 1ns)
) (
    input logic fast_clk, // The faster clock
    input logic rst,      // Reset
    input logic enable,   // Enable the clock generator
    input logic [WIDTH-1:0] period,     // Total period of the output clock
    input logic [WIDTH-1:0] duty_cycle, // "On" time of the output clock
    output logic clk_out   // The output clock with configurable duty cycle
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [WIDTH-1:0] counter;

    always_ff @(posedge fast_clk) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (enable) begin
            if (counter < duty_cycle) begin
                clk_out <= 1;
            end else begin
                clk_out <= 0;
            end

            if (counter == period - 1) begin // Reset at the end of the period
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule : configurable_clock
`endif // configurable_clock
{% endhighlight %}
</details>

<details>
<summary><code>tb_configurable_clock.sv</code></summary>
{% highlight verilog %}
///////////////////////////////////////////////////////////////////////////////
//
// Testbench for configurable_clock
//
// module: tb_configurable_clock
// modeling: Structural and Behavioral
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps // Time unit and time precision
// ensure you note the scale (ns) below in $monitor

`include "configurable_clock.sv"

module tb_configurable_clock;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    // Parameters
    localparam integer DELAY = 5;
    localparam integer DEPTH = 8; // Number of registers
    localparam integer WIDTH = 8; // Width of each register
    
    //inputs are reg for test bench - or use logic
    reg [WIDTH-1:0] period = 'd2; // note bit width casting using `d4 to WIDTH width
    reg [WIDTH-1:0] duty = 'd1; // note bit width casting using `d4 to WIDTH width
    logic clk, fastest_clk;
    logic rst;
    logic enable;


    //outputs are wire for test bench - or use logic
    wire [WIDTH-1:0] read_data;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //

    // Base clock generation (fastest_clk)
    // Clock generation
    initial begin
        fastest_clk = 0;
        forever #0.1 fastest_clk = ~fastest_clk;
    end

    // Clock instantiation
    configurable_clock clocks (
        .fast_clk(fastest_clk),
        .rst(rst),
        .enable(enable),
        .period(period),
        .duty_cycle(duty),
        .clk_out(clk)
    );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("configurable_clock.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(0, tb_configurable_clock);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        $monitor($time,"ns clk=%b rst=%b enable=%b",
            clk, rst, enable);
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        rst = 1; enable = 0; write_en = 0;

        #10 rst = 0;
        enable = 1;

        #10 rst = 1;
        enable = 0;
        #10;
        $finish;
    end
endmodule : tb_configurable_clock
{% endhighlight %}
</details>

### Solution to Problem 4
#### program counter, with inputs clock, reset, enable, increment

<details>
<summary><code>program_counter.sv</code></summary>
{% highlight verilog %}
// program_counter.sv
module program_counter #(parameter WIDTH = 8) (
  input  logic clk,
  input  logic rst,
  input  logic enable, // Enable/disable counting
  input  logic [WIDTH-1:0] load_value, // Value to load when load is asserted
  input logic load,
  output logic [WIDTH-1:0] pc_out
);

  logic [WIDTH-1:0] pc_reg; // Internal register to store the PC value

  always_ff @(posedge clk) begin
    if (rst) begin
      pc_reg <= 0;
    end else if (load) begin
      pc_reg <= load_value;
    end else if (enable) begin
      pc_reg <= pc_reg + 1;
    end
  end

  assign pc_out = pc_reg;

endmodule
{% endhighlight %}
</details>

<details>
<summary><code>tb_program_counter.sv</code></summary>
{% highlight verilog %}
// tb_program_counter.sv
module tb_program_counter;
  // Parameters
  localparam WIDTH = 8;

  // Signals
  logic clk;
  logic rst;
  logic enable;
  logic [WIDTH-1:0] load_value;
  logic load;
  logic [WIDTH-1:0] pc_out;

  // Instantiate the program counter
  program_counter #(WIDTH) pc (
    .clk      (clk),
    .rst      (rst),
    .enable   (enable),
    .load_value (load_value),
    .load     (load),
    .pc_out   (pc_out)
  );

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("program_counter.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(0, tb_program_counter);
    end : dump_variables

    //
    // display variables
    //
    initial begin: display_variables
        $monitor($time,"ns clk=%b rst=%b enable=%b load_value=%d(%b) load=%b pc_out=%d(%b)",
            pc.clk, pc.rst, pc.enable, pc.load_value, pc.load_value, pc.load, pc.load, pc.pc_out, pc.pc_out);
    end : display_variables

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Period of 10 time units
  end

  // Test sequence
  initial begin
    $display("Running tests...");

    rst = 1;
    enable = 0;
    load = 0;
    #10;
    rst = 0; // Release reset

    // Test initial value
    #10;
    assert (pc_out == 8'h00)
        else $error("Test failed: Initial value incorrect");

    // Test incrementing
    enable = 1;
    #10;
    assert (pc_out == 8'h01)
        else $error("Test failed: Increment 1");
    #10;
    assert (pc_out == 8'h02)
        else $error("Test failed: Increment 2");
    #10;
    assert (pc_out == 8'h03)
        else $error("Test failed: Increment 3");

    // Test loading a value
    enable = 0;
    load = 1;
    load_value = 8'hA5;
    #10;
    assert (pc_out == 8'hA5)
        else $error("Test failed: Load value");

    // Test incrementing after load
    enable = 1;
    load = 0;
    #10;
    assert (pc_out == 8'hA6)
        else $error("Test failed: Increment after load");

    //Test wrapping around
    load_value = 8'hFF;
    load = 1;
    enable = 0;
    #10;
    assert (pc_out == 8'hFF)
        else $error("Test failed: Load max value");

    load = 0;
    enable = 1;
    #10;
    assert (pc_out == 8'h00)
        else $error("Test failed: Wrap around");

    $finish;
  end

endmodule
{% endhighlight %}
</details>

### Solution to Problem 5
#### DFF, with inputs clock, reset, enable

<details>
<summary><code>dff.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: dff
//
// D Flip-Flop with Reset and Enable
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef dff
`define dff

module dff
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
(
  input logic clk,
  input logic rst,
  input logic enable,
  input logic d,
  output logic q
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      q <= 0; // Synchronous reset
    end else if (enable) begin
      q <= d; // Data is loaded only when enable is high
    end
  end
endmodule : dff
`endif // dff
{% endhighlight %}
</details>




### Solution to Problem 6
#### n-bit register built from DFF, with inputs clock, reset, enable

<details>
<summary><code>register.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: register
//
// Parameterized Register
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef register
`define register

`include "dff.sv"

module register
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter WIDTH = 8 // Default width of 8 bits
) (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic [WIDTH-1:0] d, // Data input, parameterized width
    output logic [WIDTH-1:0] q // Data output, parameterized width
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [WIDTH-1:0] q_internal; // Internal signal for dff outputs

    generate
        genvar i;
        for (i = 0; i < WIDTH; i++) begin : flip_flops
            dff flip_flops (
            .clk(clk),
            .rst(rst),
            .enable(enable),
            .d(d[i]),      // Connecting individual bits of d
            .q(q_internal[i]) // Connecting individual bits of q_internal
            );
        end
    endgenerate

    assign q = q_internal; // Assign internal signal to output q
  
endmodule : register
`endif // register

{% endhighlight %}
</details>

<details>
<summary><code>register_file.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: register_file
//
// Parameterized Register File
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef register_file
`define register_file

`include "register.sv"

module register_file
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter DEPTH = 8,  // Number of registers (default 8)
    parameter WIDTH = 8   // Width of each register (inherited or specified)
) (
    input logic clk,
    input logic rst,
    input logic enable,

    input logic [$clog2(DEPTH)-1:0] write_addr, // Write address
    input logic [WIDTH-1:0] write_data,      // Write data
    input logic write_en,                  // Write enable

    input logic [$clog2(DEPTH)-1:0] read_addr, // Read address
    output logic [WIDTH-1:0] read_data     // Read data
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    // Array of registers
    register #( .WIDTH(WIDTH) ) registers [DEPTH-1:0]; // Parameterized register instances

    localparam bit [WIDTH-1:0] ZERO  = '0;
    logic [WIDTH-1:0] q_internal [DEPTH-1:0]; // Internal signal for register outputs

    genvar i;
    generate
        for (i = 0; i < DEPTH; i++) begin : register_instances
            register #( .WIDTH(WIDTH) ) registers (
                .clk(clk),
                .rst(rst),
                .enable(enable && write_en && (write_addr == i)), // Simplified enable logic
                .d(write_data),
                .q(q_internal[i]) // Output not directly connected within the array
            );
            // Debugging with $display inside the generate block
            `ifdef DEBUG_GENERATE_REGISTERS
                initial begin : debug_generate_registers
                    $display($time, "ns Register %0d: enable=%b, write_en=%b, write_addr=%0d", i, enable && write_en && (write_addr == i), write_en, write_addr);
                end
            `endif // DEBUG_GENERATE_REGISTERS
        end
    endgenerate

    // Inside register_file module:
    always_ff @(posedge clk) begin
        read_data <= q_internal[read_addr];
    end
endmodule : register_file
`endif // register_file
{% endhighlight %}
</details>

<details>
<summary><code>tb_register_file.sv</code></summary>
{% highlight verilog %}
///////////////////////////////////////////////////////////////////////////////
//
// Testbench for register_file
//
// module: tb_dff
// modeling: Structural and Behavioral
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 10ms/100us // Time unit and time precision
// ensure you note the scale (ns) below in $monitor

`ifndef DEBUG_GENERATE_REGISTERS
    `define DEBUG_GENERATE_REGISTERS
`endif

`include "register_file.sv"
`include "configurable_clock.sv"

module tb_register_file;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    // Parameters
    localparam integer DELAY = 5;
    localparam integer DEPTH = 8; // Number of registers
    localparam integer WIDTH = 8; // Width of each register
    localparam bit [WIDTH-1:0] ZERO  = '0;

    static shortint addr = 3'h0;
    static shortint val = 8'h00;
    reg[WIDTH-1:0] rval;
    reg[31:0] rseed;

    //inputs are reg for test bench - or use logic
    logic clk, fastest_clk;
    logic rst;
    logic enable;
    logic [$clog2(DEPTH)-1:0] write_addr;
    logic [WIDTH-1:0] write_data;
    logic write_en;        
    logic [$clog2(DEPTH)-1:0] read_addr;
    reg [WIDTH-1:0] period = 'd2; // note bit width casting using `d4 to WIDTH width
    reg [WIDTH-1:0] duty = 'd1; // note bit width casting using `d4 to WIDTH width


    //outputs are wire for test bench - or use logic
    wire [WIDTH-1:0] read_data;

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //

    // Base clock generation (fastest_clk)
    // Clock generation
    initial begin
        fastest_clk = 0;
        forever #0.1 fastest_clk = ~fastest_clk;
    end

    // Clock instantiation
    configurable_clock clocks (
        .fast_clk(fastest_clk),
        .rst(rst),
        .enable(enable),
        .period(period),
        .duty_cycle(duty),
        .clk_out(clk)
    );

    // Register file instantiation
    register_file rf (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_addr(read_addr),
        .read_data(read_data)
    );
    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //

    initial begin : dump_variables
        // Create a VCD file for waveform viewing
        // for Makefile, make dump file same as module name
        $dumpfile("register_file.vcd");

        // Dump all signals in the testbench and DUT
        $dumpvars(0, tb_register_file);
    end

    /*
    * display variables
    */
    initial begin: display_variables
        $monitor($time,"ms clk=%b rst=%b enable=%b write_addr=%h write_data=%h write_en=%b read_addr=%h read_data=%h",
            clk, rst, enable, write_addr, write_data, write_en, read_addr, read_data);
    end

    // // Correct way to probe registers: use a procedural block with a loop and generate block
    // genvar k;
    // generate
    //     for (k = 0; k < DEPTH; k++) begin : probe_registers
    //         always @(posedge clk) begin
    //             $display($time, "ns Register %0d: q=%h", k, rf.registers[k].q);
    //         end
    //     end
    // endgenerate

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
        rst = 1; enable = 0; write_en = 0;

        #1 rst = 0;
        enable = 1;

        // TEST 0 - initialize all the registers to zero
        $display("Initialize all registers to zero");
        for (addr = 0; addr < DEPTH; addr++) begin
            write_addr = addr; write_data = ZERO; read_addr = write_addr;
            write_en = 1;
            #5 write_en = 0;
            $display();
            assert (read_data == write_data)
                else $error("Read data mismatch!\n\tAddr (%h) = Data (%h), should be (%h)",
                    read_addr, read_data, write_data);
        end

        // reset for next test
        addr = ZERO; val = ZERO;
        #5 read_addr = ZERO; write_addr = ZERO; write_data = ZERO;
        rst = 1; enable = 0; write_en = 0;
        #5 rst = 0;
        enable = 1;

        // TEST 1
        $display("TEST 1");
        addr = 3'h4; val = 8'h01;
        write_addr = addr; write_data = val; read_addr = write_addr;
        write_en = 1;
        #5 write_en = 0; 
        assert (read_data == write_data)
            else $error("Read data mismatch!\n\tAddr (%h) = Data (%h), should be (%h)",
                read_addr, read_data, write_data);

        // reset for next test
        addr = ZERO; val = ZERO;
        #10 read_addr = ZERO; write_addr = ZERO; write_data = ZERO;
        rst = 1; enable = 0; write_en = 0;
        #5 rst = 0;
        enable = 1;

        // TEST 2
        $display("TEST 2");
        addr = 3'h6; val = 8'h10;
        write_addr = addr; write_data = val; read_addr = write_addr;
        write_en = 1;
        #5 write_en = 0; 
        assert (read_data == write_data)
            else $error("Read data mismatch!\n\tAddr (%h) = Data (%h), should be (%h)",
                read_addr, read_data, write_data);

        // reset for next test
        addr = ZERO; val = ZERO;
        #10 read_addr = ZERO; write_addr = ZERO; write_data = ZERO;
        rst = 1; enable = 0; write_en = 0;
        #5 rst = 0;
        enable = 1;


        // TEST all register addresses
        $display("TEST all register addresses");
        for (addr = DEPTH-1; addr > -1; addr--) begin
            // release val; force val = $urandom_range($pow(2,WIDTH)-1,0);
            // rval = $random(rseed) % WIDTH;
            // val = rval;
            #1 val = addr;
            write_addr = addr; write_data = val; read_addr = write_addr;
            write_en = 1;
            #5 write_en = 0;
            assert (read_data == write_data)
                else $error("Read data mismatch!\n\tAddr (%h) = Data (%h), should be (%h)",
                    read_addr, read_data, write_data);
        end
        // reset to end
        addr = ZERO; val = ZERO;
        #10 read_addr = ZERO; write_addr = ZERO; write_data = ZERO;
        rst = 1; enable = 0; write_en = 0;
        #2 rst = 0;
        #2 enable = 0;
        
        #1;
        $finish;
    end
endmodule : tb_register_file
{% endhighlight %}
</details>

<details>
<summary><code>configurable_clock.sv</code></summary>
{% highlight verilog %}
//////////////////////////////////////////////////////////////////////////////
//
// Module: configurable_clock
//
// Clock generator with configurable period and duty cycle
//
// hdl: SystemVerilog
// modeling: Behavioral Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef configurable_clock
`define configurable_clock

module configurable_clock
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
#(
    parameter integer WIDTH = 8, // Width of the counter and period/duty cycle values
    parameter real FAST_CLK_PERIOD = 1.0 // Period of the faster clock (e.g., 1ns)
) (
    input logic fast_clk, // The faster clock
    input logic rst,      // Reset
    input logic enable,   // Enable the clock generator
    input logic [WIDTH-1:0] period,     // Total period of the output clock
    input logic [WIDTH-1:0] duty_cycle, // "On" time of the output clock
    output logic clk_out   // The output clock with configurable duty cycle
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [WIDTH-1:0] counter;

    always_ff @(posedge fast_clk) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (enable) begin
            if (counter < duty_cycle) begin
                clk_out <= 1;
            end else begin
                clk_out <= 0;
            end

            if (counter == period - 1) begin // Reset at the end of the period
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule : configurable_clock
`endif // configurable_clock
{% endhighlight %}
</details>

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)
