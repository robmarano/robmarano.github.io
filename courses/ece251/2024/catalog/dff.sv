module dff
    # (
        parameter n = 32
    )(
  input  logic [n-1:0] d, clk, rst,
  output logic [n-1:0] q, [n-1:0] qn;
);
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      q  <= 0;
      qn <= 1;
    end else begin
      q  <= d;
      qn <= ~d;
    end
  end
endmodule