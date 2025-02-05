`include "register_file.sv"
`timescale 1ns/100ps

// Testbench for the parameterized register file
module register_file_tb;
  logic clk;
  logic rst;
  logic enable;

  logic [2:0] write_addr; // 8 registers so 3 bits for address
  logic [7:0] write_data;
  logic write_en;

  logic [2:0] read_addr1;
  logic [7:0] read_data1;

  logic [2:0] read_addr2;
  logic [7:0] read_data2;

  register_file rf (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .write_addr(write_addr),
    .write_data(write_data),
    .write_en(write_en),
    .read_addr1(read_addr1),
    .read_data1(read_data1),
    .read_addr2(read_addr2),
    .read_data2(read_data2)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    rst = 1;
    enable = 0;
    write_en = 0;

    #10 rst = 0;
    enable = 1;

    write_addr = 3'h3;
    write_data = 8'hAA;
    write_en = 1;
    #10 write_en = 0;

    write_addr = 3'h5;
    write_data = 8'h55;
    write_en = 1;
    #10 write_en = 0;

    read_addr1 = 3'h3;
    read_addr2 = 3'h5;

    #10;

    $display("Read Data 1 (addr 3): %h", read_data1); // Should be AA
    $display("Read Data 2 (addr 5): %h", read_data2); // Should be 55

    $finish;
  end

endmodule