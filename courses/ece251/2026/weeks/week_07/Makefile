.PHONY: all sum interactive fileio exception quake bench_standard bench_quake clean

all: sum interactive fileio exception quake bench_standard bench_quake

sum:
	spim -file sum_array.asm

interactive:
	spim -file interactive_io.asm

fileio:
	spim -file file_io.asm

exception:
	spim -file exception_demo.asm

quake:
	spim -file quake_inv_sqrt.asm

bench_standard:
	spim -file bench_standard.asm

bench_quake:
	spim -file bench_quake.asm

clean:
	rm -f *.out
