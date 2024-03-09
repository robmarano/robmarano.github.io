# Using Verilog Locally On Your Computer

[<- back to notes](./ece251-notes.md) ; 
[<- back to syllabus](./ece251-syllabus-spring-2024.md)

---

Instead of using [EDA Playground]() or [8bitWorkshop IDE](https://8bitworkshop.com/v3.11.0/?file=racing_game_cpu.v&platform=verilog)

## <a id="module">Module Template</a>

[`module.sv`](./catalog/templates/module.sv)

```verilog
//////////////////////////////////////////////////////////////////////////////
//
// Module: module_name
//
// 4:1 Multiplexer
//
// module: module_name
// hdl: SystemVerilog
// modeling: Gate Level Modeling
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`ifndef MODULE_NAME
`define MODULE_NAME
// DO NOT FORGET TO RENAME MODULE_NAME to match your module_name

module module_name(
    //
    // ---------------- DECLARATIONS OF PORT IN/OUT & DATA TYPES ----------------
    //
    input logic i1,
    output logic z1
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //

endmodule

`endif // MODULE_NAME
```

## <a id="testbench">Test Bench Template</a>
[`tb_module.sv`](./catalog/templates/tb_module.sv)
```verilog
///////////////////////////////////////////////////////////////////////////////
//
// Module: Testbench for module module
//
// Testbench for MODULE_NAME
//
// module: tb_module
// hdl: SystemVerilog
//
// author: Prof. Rob Marano <rob@cooper.edu>
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`include "module_name.sv"

module tb_module_name;
    //
    // ---------------- DECLARATIONS OF DATA TYPES ----------------
    //
    //inputs are reg for test bench - or use logic

    //outputs are wire for test bench - or use logic

    //
    // ---------------- INITIALIZE TEST BENCH ----------------
    //
    initial begin : initialize_variables
    end

    initial begin
        //$monitor ($time,"ns, select:s=%b, inputs:d=%b, output:z1=%b", S, D, Z1);
    end

    initial begin : dump_variables
        $dumpfile("tb_module_name.vcd"); // for Makefile, make dump file same as module name
        $dumpvars(0, dut);
    end

    /*
    * display variables
    */
//    initial begin: display_variables
        // note: currently only simple signals or constant expressions may be passed to $monitor.
//        $monitor ("X1-X2-X4-X4 = %b, Z1 = %b", {X1,X2,X3,X4}, Z1);
//    end

    //
    // ---------------- APPLY INPUT VECTORS ----------------
    //
    // note: following the keyword begin is the name of the block: apply_stimulus
    initial begin : apply_stimuli
    #0  S = 2'b00; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1010; // D[0]=1'b0; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b00; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b01; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b10; // S[0]=1'b0; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b01; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1001; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b1011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b0011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b1; // EN=1'b1;
    #10 S = 2'b11; // S[0]=1'b1; S[1]=1'b0;
        D = 4'b0011; // D[0]=1'b1; D[1]=1'b1; D[2]=1'b0; D[3]=1'b1;
        EN = 1'b0; // EN=1'b1;
    #10 $finish;
    end
    //$finish;
    // note: do not need $finish, since the simulation runs for the set increments and ends.

    //
    // ---------------- INSTANTIATE UNIT UNDER TEST (UUT) ----------------
    //
    module_name dut(
        .d(D), .s(S), .z1(Z1), .en(EN)
    );

endmodule
```

## <a id="onWindows">Building and Running on Windows</a>
You will need these files to build and run your module and test bench on Windows using `iverilog` and `gtkwave`.

[`config.ps1`](./catalog/templates/config.ps1)
Used to define your Verilog module.
```powershell
<#
 # File: 	config.ps1
 # Author: 	Prof. Rob Marano
 # Build and test file for Verilog on Windows using PowerShell
 # Note: icarus verilog and gtkwave must be installed
 #>

$COMPONENT = "module_name" # replace with your module's name
#
$SRC = "$COMPONENT.sv"
$TESTBENCH = "tb_$COMPONENT.sv"
$TBOUTPUT = "tb_$COMPONENT.vcd"
$filesToRemove = @("$COMPONENT", "$TBOUTPUT")

# TOOLS
# You need to update the paths below to the tools in your system
$COMPILER = "C:\ProgramData\chocolatey\bin\iverilog.exe"
$SIMULATOR = "C:\ProgramData\chocolatey\bin\vvp.exe"
$VIEWER = "C:\ProgramData\chocolatey\bin\gtkwave.exe" # GUI app
# TOOL OPTIONS
$COFLAGS = "-g2012"
$SFLAGS = "-M ."		#SIMULATOR FLAGS
$SOUTPUT = "-lxt2"		#SIMULATOR OUTPUT TYPE
```

[`makefile.ps1`](./catalog/templates/makefile.ps1)
Used to compile then simulate your Verilog module using your test bench.
```powershell
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
Write-Output "Removing files: $filesToRemove"
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

[`display.ps1`](./catalog/templates/display.ps1)
Used to visualize the timing diagrams from your module's simulation output.
```powershell
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

[`clean.ps1`](./catalog/templates/clean.ps1)
Used to clean up the temporary files generated by your module compilation and simulation.
```powershell
<#
 # File: 	clean.ps1
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
Write-Output "Removing files: $filesToRemove"
$filesToRemove | ForEach-Object { Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue -Confirm:$false}

Write-Output "Finished cleaning up files."

```

## <a id="onUnix">On Linux/MacOS</a>
You will need thi `Makefile` file to build and run your module and test bench on Linux or MacOS using `iverilog` and `gtkwave`.

```makefile
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
COMPONENT = module_name	#THIS NEEDS TO MATCH THE NAME OF YOUR MODULE
#SRC = $(shell ls *.sv)
SRC = $(wildcard *.sv)
SIM_ARGS=+a=3 +b=2 +s=0
TBOUTPUT = tb_$(COMPONENT).vcd	# THIS NEEDS TO MATCH THE OUTPUT FILE
									# FROM YOUR TESTBENCH
###############################################################################
# BE CAREFUL WHEN CHANGING ITEMS BELOW THIS LINE
###############################################################################
#TOOLS
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave #works on your host, not docker container since it's a GUI
#TOOL OPTIONS
COFLAGS = -g2012 #-v
SFLAGS = -M . #-v
SOUTPUT = -lxt2		#SIMULATOR OUTPUT TYPE
#TOOL OUTPUT
#COUTPUT = compiler.out			#COMPILER OUTPUT
###############################################################################
#MAKE DIRECTIVES
.PHONY: compile simulate display clean
compile : $(SRC)
	$(COMPILER) $(COFLAGS) -o $(COMPONENT).vvp $(SRC)

simulate: $(COMPONENT).vvp
	$(SIMULATOR) $(SFLAGS) $(COMPONENT).vvp $(SOUTPUT)

display: $(TBOUTPUT)
	$(VIEWER) $(TBOUTPUT) &

clean:
	/bin/rm -f $(COMPONENT) $(COMPONENT).vvp $(TBOUTPUT) *.vcd a.out compiler.out
```

## <a id="withGit">Working with `git`</a>
Let's say that your GitHub repository for your assignment is called `take-one-for-your-verilog-catalog-robmarano` the following commands will copy your repo from GitHub to your local computer for you to work through, that means, add new files, change files, and commit those to your repo. Once completed, you can upload your changes using `git` commands too. Before you run through the following commands, follow [these GitHub instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) for creating SSH keys. If you do not like working with the command-line, use GitHub Desktop and these [instructions](https://docs.github.com/en/desktop/overview/about-github-desktop).

Working with GitHub using the command-line:
```bash
# change to your home directory
$ cd ~/my_user_name
# create a development folder
$ mkdir dev
# create an ece251 folder
$ mkdir ece251
# clone your GitHub repo that you were given from the GitHub Classroom site
$ git clone git@github.com:cooper-union-ece-251-marano/take-one-for-your-verilog-catalog-robmarano.git
# cd into the new folder and begin working on your verilog module
$ cd take-one-for-your-verilog-catalog-robmarano
# once your done with your module and you want to commit to the repo
$ git status
$ git add *
$ git commit -a -m "Provide a short summary of what you added/changed etc"
$ git push
$ git pull
```