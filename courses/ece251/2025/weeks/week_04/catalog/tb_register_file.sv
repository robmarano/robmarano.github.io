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