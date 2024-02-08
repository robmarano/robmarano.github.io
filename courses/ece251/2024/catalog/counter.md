# Parameterized Counter

`counter.sv`
```verilog
module counter
    #(
        parameter n = 4,
        parameter down = 0
    ) (
    input clk,
    input rst,
    input enable,
    output reg [(n-1):0] count
);

    always @ (posedge clk) begin
        if (rst) begin
            count <= 0;
        end else if (enable) begin
            if (down) begin
                count <= count - 1;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
```

`tb_counter.sv`
```verilog
module tb_counter;
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
    wire [N-1:0] Z1;

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_signals
        CLK = 1'b0;
        RST = 1'b0;
        EN = 1'b0;
    end

    initial begin
//        $monitor ($time,"\tCLK=%b EN=%b RST=%b Z1=%b", CLK, RST, EN, Z1);
        $monitor ($time,"\tCLK=%b EN=%b RST=%b Z1=%04b_%04b_%04b_%04b_%04b_%04b_%04b_%04b", CLK, RST, EN, Z1[31:28], Z1[27:24], Z1[23:20], Z1[19:16], Z1[15:12], Z1[11:8], Z1[7:4], Z1[3:0]);
//        $display("0x%04h_%04h_%04h_%04h", d[63:48], d[47:32], d[31:16], d[15:0]);
    end

    initial begin
        $dumpfile("tb_counter.vcd"); // for Makefile, make dump file same as module name
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
    #10
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
    counter #(.n(N)) dut(
        .clk(CLK), .rst(RST), .enable(EN), .count(Z1)
    );

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
COMPONENT = counter
SRC = $(COMPONENT).sv
SIM_ARGS=
TESTBENCH = tb_$(COMPONENT).sv
TBOUTPUT = $(COMPONENT).vcd	#THIS NEEDS TO MATCH THE OUTPUT FILE
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
```ps
.\makefile.ps1
```
To display the timing waveform using GTKWave
```ps
.\display.ps1
```

`config.ps1`
```ps
$COMPONENT = "counter"
#
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
```
`makefile.ps1`
```ps
<#
 # File: 	makefile.ps1
 # Author: 	Prof. Rob Marano
 # Build and test file for Verilog on Windows using PowerShell
 # Note: icarus verilog and gtkwave must be installed
 #>

# $COMPONENT is named in config.ps1
# Do not forget to add that file in the same directory as this file and set the variable
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\config.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts"
    [Environment]::Exit(1)
}

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
```ps
<#
 # File: 	display.ps1
 # Author: 	Prof. Rob Marano
 # Build and test file for Verilog on Windows using PowerShell
 # Note: icarus verilog and gtkwave must be installed
 #>

# $COMPONENT is named in config.ps1
# Do not forget to add that file in the same directory as this file and set the variable
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\config.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts"
    [Environment]::Exit(1)
}

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