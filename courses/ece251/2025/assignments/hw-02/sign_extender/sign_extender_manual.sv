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