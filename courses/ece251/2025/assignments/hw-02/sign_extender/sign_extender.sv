// sign_extender.sv
module sign_extender #(parameter WIDTH = 8) (
  input  logic signed [WIDTH/2-1:0] data_in, // Input data (half the output width)
  output logic signed [WIDTH-1:0]   data_out // Output data (full width)
);

  assign data_out = $signed(data_in); // Sign extension happens implicitly with $signed

endmodule