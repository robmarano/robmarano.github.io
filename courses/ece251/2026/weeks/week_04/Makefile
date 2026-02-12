# Makefile for ECE 251 Week 04 Examples
#
# Usage:
#   make help           - Show this help message
#   make <example_name> - Run specific example
#

IV = iverilog -g2012
VVP = vvp

# Default target
.PHONY: help
help:
	@echo "==============================================================="
	@echo "   ECE 251 Week 04 - SystemVerilog Demonstrations"
	@echo "==============================================================="
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available Targets:"
	@echo "  make gates                 - Example 1: Logic Gates (Structural vs Dataflow)"
	@echo "  make mux2                  - Example 2: 2:1 Multiplexor (with Testbench)"
	@echo "  make mux4                  - Example 2: 4:1 Multiplexor"
	@echo "  make clock_gen             - Example 3A: Clock Generation (Simulation)"
	@echo "  make divider               - Example 3B: Clock Divider"
	@echo "  make pwm_sim               - Example 3C.1: PWM Clock (Simulation)"
	@echo "  make pwm_hw                - Example 3C.2: PWM Generator (Hardware)"
	@echo "  make swizzle               - Example 4: Bit Manipulation (Swizzling)"
	@echo "  make flipflops             - Example 5: Latches vs Flip-Flops"
	@echo "  make registers             - Example 6: Register Files (Struct/Gen/Behav)"
	@echo "  make half_adder            - Example 8A: Structural Half Adder"
	@echo "  make full_adder            - Example 8B: Structural Full Adder"
	@echo "  make adder                 - Example 8C: N-Bit Ripple Carry Adder"
	@echo "  make multiplier_struct     - Example 8D: 2x2 Structural Multiplier"
	@echo "  make multiplier_n          - Example 8E: N-Bit Parameterized Multiplier"
	@echo "  make clean                 - Remove generated files"
	@echo "==============================================================="

# Example 1
.PHONY: gates
gates:
	$(IV) -o gates.vvp structural_gates.sv dataflow_gates.sv tb_gates.sv
	$(VVP) gates.vvp

# Example 2
.PHONY: mux2
mux2:
	$(IV) -o mux2.vvp mux2.sv tb_mux2.sv
	$(VVP) mux2.vvp

.PHONY: mux4
mux4:
	$(IV) -o mux4.vvp mux4.sv tb_mux4.sv
	$(VVP) mux4.vvp

# Example 3
.PHONY: clock_gen
clock_gen:
	$(IV) -o clock_gen.vvp tb_clock_gen.sv
	$(VVP) clock_gen.vvp

.PHONY: divider
divider:
	$(IV) -o divider.vvp clock_divider.sv tb_clock_divider.sv
	$(VVP) divider.vvp

.PHONY: pwm_sim
pwm_sim:
	$(IV) -o pwm_sim.vvp tb_pwm_clock.sv
	$(VVP) pwm_sim.vvp

.PHONY: pwm_hw
pwm_hw:
	$(IV) -o pwm_hw.vvp pwm_generator.sv tb_pwm_generator.sv
	$(VVP) pwm_hw.vvp

# Example 4
.PHONY: swizzle
swizzle:
	$(IV) -o swizzle.vvp tb_bit_manip.sv
	$(VVP) swizzle.vvp

# Example 5
.PHONY: flipflops
flipflops:
	$(IV) -o flipflops.vvp d_latch.sv d_flip_flop.sv tb_memory_elements.sv
	$(VVP) flipflops.vvp

# Example 6
.PHONY: registers
registers:
	$(IV) -o registers.vvp d_flip_flop.sv reg4_structural.sv reg_n.sv register_file.sv tb_registers.sv
	$(VVP) registers.vvp

# Example 8
.PHONY: half_adder
half_adder:
	$(IV) -o half_adder.vvp half_adder.sv tb_half_adder.sv
	$(VVP) half_adder.vvp

.PHONY: full_adder
full_adder:
	$(IV) -o full_adder.vvp half_adder.sv full_adder.sv tb_full_adder.sv
	$(VVP) full_adder.vvp

.PHONY: adder
adder:
	$(IV) -o adder.vvp half_adder.sv full_adder.sv n_bit_adder.sv tb_n_bit_adder.sv
	$(VVP) adder.vvp

.PHONY: multiplier_struct
multiplier_struct:
	$(IV) -o multiplier_struct.vvp half_adder.sv multiplier_structural.sv tb_multiplier_structural.sv
	$(VVP) multiplier_struct.vvp

.PHONY: multiplier_n
multiplier_n:
	$(IV) -o multiplier_n.vvp multiplier.sv tb_multiplier.sv
	$(VVP) multiplier_n.vvp

# Clean
.PHONY: clean
clean:
	rm -f *.vvp *.vcd
