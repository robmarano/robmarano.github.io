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