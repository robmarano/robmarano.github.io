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
