# Notes for Week 8 &mdash; Arithmetic for Computers

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Topics

1. Reviewing what it means for a computer to perform arithmetic
2. Addition and Subtraction
3. Multiplication
4. Division
5. Floating Point

# Topic Deep Dive

## Computers perform arithmetic

At its core the fundamental principle of a computer is that it performs computation, specifically arithmetic operations.

Let's emphasize that arithmetic operations are a core function of the computer's Arithmetic and Logic Unit (ALU). It would explain that all other components of the computer system exist primarily to bring data to the ALU for processing and to handle the results, like storing them and using them again in another computation.

According to von Neumann's "stored program concept," number representation is crucial for understanding how arithmetic is performed.

### Integer Representation:

Integers represent the set of whole numbers in a CPU, using the binary format limited to the maximum bit width of the operands supported by the ALU. In our MIPS computer, that width is 32 bits.

**Binary Numbers:** The fundamental way computers represent numbers using strings of bits.

**Two's Complement Representation:** We have already covered this standard method for representing signed integers, especially covering its advantages for arithmetic operations.

### Floating-Point Representation:

Floating-point represents the set of **real numbers** using a format similar to scientific notation in binary. The **IEEE 754 standard** for floating-point representation defines the format for **single-precision** and **double-precision** floating-point numbers, including the **sign bit**, **exponent**, and **significand** (or mantissa). With IEEE 754 computers can adequately handle computating involving **normalized** and **denormalized numbers**, as well as special values like **infinity** and **NaN** (not a number), all defined in the IEEE 754 standard.

### Integer Arithmetic:

We will cover:

1. How addition and subtraction are performed using the two's complement representation.
2. The basic principles of integer multiplication and division.
3. The role of the ALU in executing these operations using digital logic circuits.

### Floating-Point Arithmetic:

We will cover:

1. The more complex algorithms for performing addition, subtraction, multiplication, and division on floating-point numbers according to the IEEE 754 standard
2. The steps involved, such as aligning exponents, performing the operation on the significands, and normalizing the result.
3. Guard bits, rounding techniques, overflow, and underflow, would also be covered. Understanding these is crucial for appreciating the limitations and potential sources of error in floating-point computations.
