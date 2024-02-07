# Clock

## Simple Clock

`clock.sv`
```verilog
`ifndef CLOCK
`define CLOCK

module clock
    # (
        parameter period = 10
    )(
        output logic clk
);
    //
    // ---------------- DECLARATIONS OF PARAMETERS ----------------
    //
    localparam half_period = period/2;

    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //

    initial begin : initialize_signals
        clk = 1'b0;
    end

    // a simple clock with 50% duty cycle
    always begin: clock
        #half_period clk = ~clk;
    end

endmodule

`endif // CLOCK

```

`tb_clock.sv`
```verilog
`timescale 1ns/100ps

module tb_clock;
    //
    // ---------------- DECLARATIONS OF PARAMETERS ----------------
    //
    localparam P = 10;

    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic

    //outputs are wire for test bench - or use logic
    reg CLK;

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    
    initial begin
        $monitor ($time,"\tCLK=%b", CLK);
    end

    initial begin
        $dumpfile("tb_clock.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut);
    end
  
    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //

    initial begin: prog_apply_stimuli
    #0
    #10	
    #10 
    #10 
    #10
    #10 
    #10 
    #10
    #10
    #10
    #10
    #10
    #10
    $finish;
    end

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    clock #(.period(P)) dut(
        .clk(CLK)
    );

endmodule
```
### For Unix (Linux, MacOS)
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
COMPONENT = clock
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

### For Windows PowerShell

`config.ps1`
```ps
$COMPONENT = "clock"
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
Start-Process @displayProcessOptions -NoNewWindow -Wait```
