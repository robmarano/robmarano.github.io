PROJECT_NAME=pipelined_cpu
SRCS=tb_computer.sv
VVPOPTS=-s tb_computer
# Default assembly program if none is specified
ASM ?= test_prog

all: clean asm compile run

compile:
	iverilog -g2012 -o $(PROJECT_NAME).vvp $(SRCS)

run:
	vvp $(PROJECT_NAME).vvp +PROG=$(ASM).exe > debug_output.txt
	@echo "\nSimulation complete! Check debug_output.txt for cycle-by-cycle logs."

asm:
	python3 assembler.py $(ASM).asm $(ASM).exe
	
clean:
	rm -f *.vvp *.vcd *.exe debug_output.txt
