# ECE 465 Fall 2023 Weekly Course Notes

[<- back to syllabus](./ece465-syllabus-fall-2023.md)

# Week 1

## Refresher of Computer Architecture

### The von Neumann (Princeton) Architecture for a Computer

THe combination of a central processing unit (CPU), computer memory, datapath, input, and output defines a modern computer. The purpose of any computer or computing devices is to process data with a desired set of instructions. The program contains the instructions and the data, or a refernece to where data is stored. The stored-program concept describes the fact instructions and data can be encoded into numbers and stored into memory. A von Neumann computer has a single memory which is generally segmented into a stack, a heap, and reserved sections, defined by the instruction set architecture of the computer's CPU. The stack section of the memory can be considered the scratch working area for programs (instructions & data). Every program that runs on the computer gets its own stack. The hardware of the computer does not perform this coordination. Rather the very first program that runs upon the computer's initial start (boot sequence from power-on state) coordinates programs to execute on the computer and manages the memory sections. A computer is designed to have as much memory that can be addressed by the number of bits defined by the CPU's bit width, which, in turn, defines the width of an operand of the CPU's compute engine, i.e., the arithmetic logic unit (ALU). For example, if you have a 32-bit, byte-addressable CPU, the bit width of an operand is defined to be 32 bits, which means the total addressable space is 2^32, or 4 gigabytes. However, you can have more memory available to you if the motherboard has been modified to allow for more addressable memory. The motherboard serves as the physical device that houses the CPU, memory, input and output connections. It provides interconnects and slots of the computer components.

## Centralized vs Decentralized vs Distributed

## Concurrent Execution & Programming Concurrency

### Process & Multiprocessing

What is a Process?

What is Uni-processing?

What is Multiprocessing?

### Task & Multitasking

### Thread & Multithreading

### Have you heard of these?

Parallel processing

Concurrent processing

...

# Week 15
