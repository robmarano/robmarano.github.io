PROJECT_NAME=pipelined_cpu
SRCS=tb_computer.sv
VVPOPTS=-s tb_computer
# Default assembly program if none is specified
ASM ?= test_prog

all: clean check_asm asm compile run

check_asm:
	@if [ ! -f $(ASM).asm ]; then \
		echo "ERROR: Assembly file '$(ASM).asm' not found!"; \
		echo "Available test files are:"; \
		ls -1 *.asm | sed 's/\.asm//'; \
		exit 1; \
	fi

compile:
	iverilog -g2012 -o $(PROJECT_NAME).vvp $(SRCS)

run:
	vvp $(PROJECT_NAME).vvp +PROG=$(ASM).exe > debug_output.txt
	@echo "\nSimulation complete! Check debug_output.txt for cycle-by-cycle logs."

asm:
	python3 assembler.py $(ASM).asm $(ASM).exe

test_exceptions: clean
	@echo "Running Exception Testbench..."
	python3 assembler.py test_exceptions.asm test_exceptions.exe
	iverilog -g2012 -o exceptions.vvp tb_exceptions.sv
	vvp exceptions.vvp +PROG=test_exceptions.exe > debug_output.txt
	@echo "\nSimulation complete! Check debug_output.txt for cycle-by-cycle logs."

clean:
	rm -f *.vvp *.vcd *.exe debug_output.txt
