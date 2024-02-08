# Parameterized D Flip Flop

`dff.sv` &mdash; DFF without ENABLE
```verilog
module dff
    # (
        parameter n = 32
    )(
  input  logic [n-1:0] d,
  input clk, rst,
  output logic [n-1:0] q,
  output logic [n-1:0] qn
);
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      q  = 0;
      qn = ~q;
    end else begin
      q  <= d;
      qn <= ~d;
    end
  end
endmodule
```
`dff.sv` &mdash; DFF with ENABLE
```verilog
module dff
    # (
        parameter n = 32
    )(
  input  logic [n-1:0] d,
  input clk, rst, en,
  output logic [n-1:0] q,
  output logic [n-1:0] qn
);
    always_ff @(posedge clk, posedge rst) begin
        if (en)
            begin
                if (rst)
                    begin
                        q  = 0;
                        qn = ~q;
                    end
                else // rst
                    begin
                        q  <= d;
                        qn <= ~d;
                    end
            end
        else
            begin
                q = 'bz;
                qn ='bz;
            end
    end
endmodule
```

`tb_dff.sv`
```verilog
`timescale 1ns/100ps

module tb_dff;
    //
    // ---------------- DECLARATIONS OF PARAMETERS ----------------
    //
    parameter N = 32;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic
    reg CLK;
    reg RST;
    reg EN;
    //outputs are wire for test bench - or use logic
    logic [N-1:0] D;
    logic [N-1:0] Q;
    logic [N-1:0] Qn;

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_signals
        CLK <= 1'b0;
        RST <= 1'b0;
        EN <= 1'b0;
        D <= 0;
    end

    initial begin
//        $monitor ($time,"\tCLK=%b EN=%b RST=%b Z1=%b", CLK, RST, EN, Z1);
        $monitor (
            $time,
            "\tCLK=%b EN=%b RST=%b \n\tD=%04b_%04b_%04b_%04b_%04b_%04b_%04b_%04b\n\tQ==%04b_%04b_%04b_%04b_%04b_%04b_%04b_%04b\n\tQn=%04b_%04b_%04b_%04b_%04b_%04b_%04b_%04b",
            CLK, RST, EN,
            D[31:28], D[27:24], D[23:20], D[19:16], D[15:12], D[11:8], D[7:4], D[3:0],
            Q[31:28], Q[27:24], Q[23:20], Q[19:16], Q[15:12], Q[11:8], Q[7:4], Q[3:0],
            Qn[31:28], Qn[27:24], Qn[23:20], Qn[19:16], Qn[15:12], Qn[11:8], Qn[7:4], Qn[3:0]
        );
//        $display("0x%04h_%04h_%04h_%04h", d[63:48], d[47:32], d[31:16], d[15:0]);
    end

    initial begin
        $dumpfile("tb_dff.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut);
    end
  
    // a simple clock with 50% duty cycle
    always begin: clock
        #10 CLK = ~CLK;
    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //

    initial begin: prog_apply_stimuli
    #0
    #10	RST = 1'b1;
    #10 RST = 1'b0;
    #10 EN = 1'b1;
    #10
    #10 INP = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    #10 
    #10
    #10
    #100 EN = 1'b0;
    #10
    #10
    #10
    $finish;
    end


    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    // WITHOUT ENABLE
    dff #(.n(N)) dut(
        .d(D), .clk(CLK), .rst(RST), .q(Q), .qn(Qn)
    );
    // WITH ENABLE
    // dff #(.n(N)) dut(
    //    .d(D), .clk(CLK), .rst(RST), .en(EN), .q(Q), .qn(Qn)
    //);

endmodule
```
## For MacOS or Linux
Use the following `Makefile` AND run the following command:
To compile
```bash
make compile
```
To simulate
```bash
make simulate
```
To display the timing waveform using GTKWave
```base
make display
```
`Makefile`
```bash
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
COMPONENT = dff
SRC = $(COMPONENT).sv
SIM_ARGS=
TESTBENCH = tb_$(COMPONENT).sv
TBOUTPUT = tb_$(COMPONENT).vcd	#THIS NEEDS TO MATCH THE OUTPUT FILE
							#FROM YOUR TESTBENCH
###############################################################################
# BE CAREFUL WHEN CHANGING ITEMS BELOW THIS LINE
###############################################################################
#TOOLS
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave #works on your host, not docker container since it's a GUI
#TOOL OPTIONS
COFLAGS = -g2012
SFLAGS = -lxt2
SOUTPUT = -lxt2		#SIMULATOR OUTPUT TYPE
#TOOL OUTPUT
#COUTPUT = compiler.out			#COMPILER OUTPUT
###############################################################################
#MAKE DIRECTIVES
.PHONY: compile simulate display clean
compile : $(TESTBENCH) $(SRC)
	$(COMPILER) $(COFLAGS) -o $(COMPONENT) $(TESTBENCH) $(SRC)

simulate: $(COMPONENT)
	$(SIMULATOR) $(SFLAGS) $(COMPONENT) $(TESTBENCH) $(SOUTPUT)

display: $(TBOUTPUT)
	$(VIEWER) $(TBOUTPUT) &

clean:
	/bin/rm -f $(COMPONENT) $(TBOUTPUT) a.out compiler.out
```

## For Windows

Use the following files AND run the following command:
To compile and simulate
```powershell
.\makefile.ps1
```
To display the timing waveform using GTKWave
```powershell
.\display.ps1
```


`makefile.ps1`
```powershell
<#
 # File: 	makefile.ps1
 # Author: 	Prof. Rob Marano
 # Build and test file for Verilog on Windows using PowerShell
 # Note: icarus verilog and gtkwave must be installed
 #>

$COMPONENT = "dff"
$SRC = "$COMPONENT.sv"
$TESTBENCH = "tb_$COMPONENT.sv"
$TBOUTPUT = "tb_$COMPONENT.vcd"

# TOOLS
$COMPILER = "C:\ProgramData\chocolatey\bin\iverilog.exe"
$SIMULATOR = "C:\ProgramData\chocolatey\bin\vvp.exe"
$VIEWER = "C:\ProgramData\chocolatey\bin\gtkwave.exe" # GUI app
# TOOL OPTIONS
$COFLAGS = "-g2012"
$SFLAGS = "-lx2"		#SIMULATOR FLAGS
$SOUTPUT = "-lxt2"		#SIMULATOR OUTPUT TYPE

# Clean up from last run
$filesToRemove = @("$COMPONENT", "$COMPONENT.vcd")
Write-Output "Removing files: $filesToRemove"s
#Remove-Item -Path $filesToRemove -ErrorAction SilentlyContinue -Confirm
$filesToRemove | ForEach-Object { Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue -Confirm:$false}

#
# Compile Verilog file
#
# $COMPILER $COFLAGS -o $COMPONENT $TESTBENCH $SRC
$compileProcessOptions = @{
    FilePath = "$COMPILER"
    ArgumentList = @("$COFLAGS", "-o", "$COMPONENT", "$TESTBENCH", "$SRC")
    UseNewEnvironment = $true
}
Start-Process -NoNewWindow -Wait @compileProcessOptions

#
# Simulate Verilog module with testbench
# $(SIMULATOR) $(SFLAGS) $(COMPONENT) $(TESTBENCH) $(SOUTPUT)
$simulateProcessOptions = @{
    FilePath = "$SIMULATOR"
    ArgumentList = @("$SFLAGS", "$COMPONENT", "$SOUTPUT")
    UseNewEnvironment = $true
}
Write-Output @simulateProcessOptions
Start-Process @simulateProcessOptions -NoNewWindow -Wait
```

`display.ps1`
```powershell
<#
 # File: 	makefile.ps1
 # Author: 	Prof. Rob Marano
 # Build and test file for Verilog on Windows using PowerShell
 # Note: icarus verilog and gtkwave must be installed
 #>

 $COMPONENT = "dff"
$SRC = "$COMPONENT.sv"
$TESTBENCH = "tb_$COMPONENT.sv"
$TBOUTPUT = "tb_$COMPONENT.vcd"

# TOOLS
$VIEWER = "C:\ProgramData\chocolatey\bin\gtkwave.exe" # GUI app
# TOOL OPTIONS
$COFLAGS = "-g2012"
$SFLAGS = "-lx2"		#SIMULATOR FLAGS
$SOUTPUT = "-lxt2"		#SIMULATOR OUTPUT TYPE

#
# Display Verilog module with testbench
# $(SIMULATOR) $(SFLAGS) $(COMPONENT) $(TESTBENCH) $(SOUTPUT)
$displayProcessOptions = @{
    FilePath = "$VIEWER"
    ArgumentList = @("$TBOUTPUT")
    UseNewEnvironment = $true
}
Start-Process @displayProcessOptions -NoNewWindow -Wait
```
