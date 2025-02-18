// sign_extender_tb.sv
module tb_sign_extender;
  // Parameters
  localparam WIDTH = 8;

  // Signals
  logic signed [WIDTH/2-1:0] data_in;
  logic signed [WIDTH-1:0]   data_out;

  // Instantiate the sign extender
  // Verilog and bit swizzling
  sign_extender_manual #(WIDTH) ext (
    .data_in  (data_in),
    .data_out (data_out)
  );
  // SystemVerilog and $signed
//   sign_extender #(WIDTH) ext (
//     .data_in  (data_in),
//     .data_out (data_out)
//   );

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