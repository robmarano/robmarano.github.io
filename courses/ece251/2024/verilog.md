# Verilog & SystemVerilog

# References

- [Verilog HDL Design Examples](https://www.taylorfrancis.com/books/mono/10.1201/b22315/verilog-hdl-design-examples-joseph-cavanagh) by Joseph Cavanagh, ISBN 978-1-138-09995-1

# Logic Elements

## Comments

```verilog
// This is a single-line comment like in C++
/*
 * This is a multi-line comment like in C
 */

```

## Logic Gates

- and
- or
- not (inverter)
- nand
- nor
- xor

## Logic Macro Functions

Logic macro functions serve as those circuits which consist of several logic primitives to form larger more complex functions.

### Combinational logic macros

- multiplexers
- decoders
- encoders
- comparators
- adders
- subtractors
- array multipliers
- array dividers
- error detection and correction circuits

#### Multiplexers

A multiplexer is a logic macro device that allows digital information from two or more data inputs to be directed to a single output. Data input selection is controlled by a set of select inputs that determine which data input is gated to the out- put.

**4:1 Multiplexer**  
4-bit input (d3d2d1d0)  
2-bit selector (s1s0)  
1-bit multiplexed output (z)

```verilog
z = s1's0'd0 + s1's0d1 + s1s0'd2 + s1s0d3
```

#### Decoders

A decoder is a combinational logic macro that is characterized by the following property: For every valid combination of inputs, a unique output is generated.

In general, a decoder has `n` binary inputs and `m` mutually exclusive outputs, where 2^n >= m. An n:m (n-to-m) decoder is a demultiplexer. Each output represents a minterm that corresponds to the binary representation of the input vector. Thus, zi = mi, where mi is the ith minterm of the n input variables.

A decoder with n inputs, therefore, has a maximum of 2^n outputs. Because the outputs are mutually exclusive, only one output is active for each different combination of the inputs. The decoder outputs may be asserted high or low. Decoders have many applications in digital engineering, ranging from instruction decoding to memory addressing to code conversion.

For example, if n = 3 and x1 x2 x3 = 101, then output z5 is asserted, that is, the fifth bit.

#### Encoders

A simple encoder circuit is a one-hot to binary converter. That is, if there are 2^n input lines, and at most only one of them will ever be high, the binary code of this 'hot' line is produced on the n-bit output lines.

The function of an encoder can be considered to be the inverse of a decoder; that is, the mutually exclusive inputs are encoded into a corresponding binary number. An encoder inputs are mutually exclusive, meaning only one input is asserted, or set to on/true.

An encoder is a macro logic circuit with n mutually exclusive inputs and m binary outputs, where n <= 2^m. The inputs are mutually exclusive to prevent errors from appearing on the outputs. The outputs generate a binary code that corresponds to the active input value.

##### Priority Encoders

An encoder inputs are mutually exclusive. In certain applications more than one input can be active at a time. Then a **priority** must be established to select and encode a particular input. This is referred to as a **priority encoder**.

#### Comparators

A comparator is a logic macro circuit that compares the magnitude of two n-bit binary numbers X1 and X2.

Therefore, there are 2^n inputs and three outputs that indicate the relative magnitude of the two numbers. The outputs are mutually exclusive, specifying

- X1 < X2,
- X1 = X2, or
- X1 > X2

(X1 < X2) = x11'x21 + (x11 &#x2295; x21)' x12'x22 + (x11 &#x2295; x21)' (x12 &#x2295; x22)'x13' x23

(X1 = X2) = (x11 &#x2295; x21)'(x12 &#x2295; x22)'(x13 &#x2295; x23)'

(X1 > X2) = x11 x21' + (x11 &#x2295; x21)'x12x22' + (x11 &#x2295; x21)'(x12 &#x2295; x22)'x13 x23'⊕

### Sequential logic macros

- SR latches
- D and JK flip-flops
- counters of various moduli, including count-up and count-down counters
- registers, including shift registers
- sequential multipliers and dividers

We will cover this later in this document...

# Procedural Flow Control

Procedural flow control statements modify the flow in a behavior by selecting branch options, repeating certain activities, selecting a parallel activity, or terminating an ac- tivity.

The activity can occur in sequential blocks or in parallel blocks.

## `begin ... end` code block

group multiple statements into sequential blocks

## `disable` keyword

terminates a named block of procedural statements or a task and transfers control to the statement immediately following the block or task. The disable statement can also be used to exit a loop.

## `for` loop

specifies a loop. The for loop repeats the execution of a procedural statement or a block of procedural statements a specified number of times. The for loop is used when there is a specified beginning and end to the loop. The format and function of a for loop is similar to the for loop used in the C program- ming language. The parentheses following the keyword for contain three expressions separated by semicolons:

```verilog
for (<register initialization>; <test condition>; <update register control variable>)
begin
// procedural statement or block (using the begin..end) of procedural statements
```

## `forever` loop

executes the procedural statements continuously. The loop is primarily used for timing control constructs, such as clock pulse generation. The forever procedural statement must be contained within an initial or an always block. In order to exit the loop, the disable statement may be used to pre- maturely terminate the procedural statements. An always statement executes at the beginning of simulation; the forever statement executes only when it is encountered in a procedural block.

## `if ... else` conditional statement

These keywords are used as conditional statements to alter the flow of activity through a behavioral module. They permit a choice of alternative paths based upon a Boolean value obtained from a condition.

```verilog
if (<condition>)
  // if condition true
  begin
    <procedural statement(s)>
  end
else
  // if condition false
  begin
    <procedural statement(s)>
  end
```

or if you need to nest your conditional logic:

```verilog
if (<condition1>)
  // if condition1 true
  begin
    <procedural statement(s)>
  end
// if condition1 false
else if (<condition2>)
  // if condition2 true
  begin
    <procedural statement(s)>
  end
// if condition2 false
else if (<condition3>)
  // if condition3 true
  begin
    <procedural statement(s)>
  end
else
  // if condition3 false
  begin
    <procedural statement(s)>
  end
```

## `repeat` keyword

execute a loop a fixed number of times as specified by a constant contained within parentheses following the repeat keyword. The loop can be a single statement or a block of statements contained within `begin ... end` keywords. When the activity flow reaches the repeat construct, the expression in parentheses is evaluated to determine the number of times that the loop is to be executed. The expression can be a constant, a variable, or a signal value. If the expression evaluates to x or z, then the value is treated as 0 and the loop is not executed.

```verilog
repeat (<expression>) begin
  <statement(s)>
end
```

## `while` loop

executes a statement or a block of statements while an expression is true. he expression is evaluated and a Boolean value, either true (a logical 1) or false (a logical 0) is returned. If the expression is true, then the procedural statement or block of statements is executed. The while loop executes until the expression be- comes false, at which time the loop is exited and the next sequential statement is ex- ecuted. If the expression is false when the loop is entered, then the procedural statement is not executed. If the value returned is "x" (don't care) or "z" (unknown/floating), then the value is treated as false.

```verilog
while (<expression>) begin
  <statement(s)>
end
```

## Net Data Types

Verilog defines two data types, i.e., net (wire) or register (reg). These predefined data types are used to connect logical elements and to provide storage. A `net` or `wire` is a physical wire or group of wires connecting hardware elements in a module or between modules. SystemVerilog condenses net(wire) and reg into `logic`.

## Register Data Types

A register data type represents a variable that can retain a value. Verilog registers are similar in function to hardware registers, but are conceptually different. Hardware registers are synthesized with storage elements such as D flip-flops, JK flip-flops, and SR latches. Verilog registers are an abstract representation of hardware registers and are declared as `reg`.

The default size of a register is 1-bit, but a larger width can be specified in the declaration.

The general syntax to declare a width of more than 1-bit

```verilog
reg [<msb>:<lsb>] register_name;
```

where &lt;msb&gt; = most significant bit number, e.g., 7 for an 8-bit number, and &lt;lsb&gt; = least significant bit number, e.g., 0; for example, a one-byte register called data_register:

```verilog
reg[7:0] data_register;
```

## Memories

You can model a memory in Verilog using an array of registers; for example, a 32-word register with one byte per word:

```verilog
reg[7:0] data_memory[0:31]; // [0:31] defines the 32 word array
```

A register can be assigned a value using one statement, as long as the bit widths line up. For example,

```verilog
reg[15:0] buffer; // 16-bit register
buffer = 16'h8a04; // same as 16'b1000_1010_0000_0100
```

Values can be stored in memory elements by assigning a value to each word individually; for example,

```verilog
reg[7:0] cache[0:4];
cache[0] = 8'h01;
cache[1] = 8'h02;
cache[2] = 8'h03;
cache[3] = 8'h04;
```

# Verilog Expressions

Expressions consist of operands and operators, which are the basis of Verilog HDL.

The result of a **right-hand side** expression can be assigned to a **left-hand side** net variable or register variable using the keyword `assign`.

The value of an expression is determined from the combined operations on the operands. An expression can consist of a single operand or two or more operands in conjunction with one or more operators. The result of an expression is represented by one or more bits.

## Operands

|        Operands | Notes                                                                 |
| --------------: | :-------------------------------------------------------------------- |
|        constant | `signed` or `unsigned`                                                |
|     `parameter` | similar to a constant but used to parametrize modules, like bit-width |
| `net` or `wire` | scalar or vector, or `logic` for SystemVerilog                        |
|           `reg` | scalar or vector                                                      |
|      bit-select | choose one bit from a vector                                          |
|     part-select | choose contiguous bits of a vector                                    |
|  memory element | one word of a memory                                                  |

### Constant

Constants can be signed or unsigned. A decimal integer is treated as a signed number. An integer that is specified by a base is interpreted as an unsigned number.

|     Constant | Notes                                                                     |
| -----------: | :------------------------------------------------------------------------ |
|          127 | Signed decimal: Value = 8-bit binary vector: 0111_1111                    |
|           –1 | Signed decimal: Value = 8-bit binary vector: 1111_1111                    |
|         –128 | Signed decimal: Value = 8-bit binary vector: 1000_0000                    |
|      4'b1110 | Binary base: Value = unsigned decimal 14                                  |
| 8'b0011_1010 | Binary base: Value = unsigned decimal 58                                  |
|     16'h1A3C | Hexadecimal base: Value = unsigned decimal 6716                           |
|     16'hBCDE | Hexadecimal base: Value = unsigned decimal 48,350                         |
|       9'o536 | Octal base: Value = unsigned decimal 350                                  |
|          –22 | Signed decimal: Value = 8-bit binary vector: 1110_1010                    |
|      –9'o352 | Octal base: Value = 8-bit binary vector: 1110_1010 = unsigned decimal 234 |

The number –22 (base 10) is a signed decimal value; the number –9'o352 is treated as an unsigned number with a decimal value of 234 (base 10).

## Parameter

A parameter is similar to a constant and is declared by the keyword pa- rameter. Parameter statements assign values to constants; the values cannot be changed during simulation. Wherever the parameter name is used in the code, it is replaced by the value assigned to the parameter name.

|                   Parameter Example | Notes                                                         |
| ----------------------------------: | :------------------------------------------------------------ |
|               `parameter` width = 8 | Used to define a bus width of 8 bits                          |
| `parameter` width = 16, depth = 512 | Used to define a memory with two bytes per word and 512 words |
|            `parameter` out_port = 8 | Used to define an output port with an address of 8            |

## Operators

Verilog has a set of operators that perform various operations on different types of data to yield results on nets and registers. Some operators are similar to those used in the C programming language.

| Operator Type | Operator Symbol | Operation             | # Operands |
| ------------: | :-------------- | :-------------------- | :--------- |
|    Arithmetic | +               | Add                   | 2 or 1     |
|               | -               | Subtract              | 2 or 1     |
|               | \*              | Multiply              | 2          |
|               | /               | Divide                | 2          |
|               | %               | Modulus               | 2          |
|       Logical | &&              | logical AND           | 2          |
|               | \|\|            | logical OR            | 2          |
|               | !               | logical negation      | 1          |
|    Relational | &gt;            | greater than          | 2          |
|               | &lt;            | less than             | 2          |
|               | &gt;=           | greater than or equal | 2          |
|               | &lt;=           | less than or equal    | 2          |
|      Equality | ==              | logical equality      | 2          |
|               | !=              | logical inequality    | 2          |
|               | ===             | case equality         | 2          |
|               | !==             | case inequality       | 2          |
|       Bitwise | &               | AND                   | 2          |
|               | \|              | OR                    | 2          |
|               | ~               | Negation              | 1          |
|               | ^               | Exclusive OR          | 2          |
|               | ^~ or ~^        | Exclusive NOR         | 2          |
|     Reduction | &               | AND                   | 1          |
|               | ~&              | NAND                  | 1          |
|               | \|              | OR                    | 1          |
|               | ~\|             | NOR                   | 1          |
|               | ^               | Exclusive OR          | 1          |
|               | ^~ or ~^        | Exclusive NOR         | 1          |
|         Shift | <<              | Shift LEFT            | 1          |
|               | >>              | Shift RIGHT           | 1          |
|   Conditional | ?:              | Conditional (if/else) | 3          |
| Concatenation | {}              | Concatenation         | 2 or more  |
|   Replication | {{ }}           | Replication           | 2 or more  |

### Let's review the arithmetic terminologies

|      Operation | Terminology                              |
| -------------: | :--------------------------------------- |
|       Addition | Augend + Addend = Sum                    |
|    Subtraction | Minuend - Subtrahend = Difference        |
| Multiplication | Multiplicand \* Multiplier = Product     |
|       Division | Dividend / Divisor = Quotient, Remainder |

### Concatenation

The concatenation operator ( { } ) forms a single operand from two or more operands by joining the different operands in sequence separated by commas. The operands to be appended are contained within braces. The size of the operands must be known before concatenation takes place.

```verilog
reg a[1:0] = 2'b11;
reg b[2:0] = 3'b001;
reg c[3:0] = 4'b1100;
reg d = 1'b1;
reg z1[9:0] = {a,c}; // 10'b0000_11_1100
reg z2[9:0] = {b,a}; // 10'b00000_001_11
reg z3[9:0] = {c,b,a}; // 10'b0_1100_001_11
reg z4[9:0] = {a,b,c,d}; // 10'b11_001_1100_1
```

### Replication

Replication is a means of performing repetitive concatenation. Replication specifies the number of times to duplicate the expressions within the innermost braces.

Syntax:

```verilog
{number_ of_ repetitions {expression_1, expression_2, ... , expression_n}};
```

For example,

```verilog
reg a[1:0] = 2'b11;
reg b[2:0] = 3'b001;
reg c[3:0] = 4'b1100;
reg z1[9:0] = 11_0011_11_0011, //z1 = {2{a, c}}
reg z2[9:0] = 010_0011_0111_010_0011_0111 //z2 = {2{b, c, 4'b0111}}
```

# Module and Ports

A `module`` is the basic unit of design in Verilog. It describes the functional operation of some logical entity and can be a standalone module or a collection of modules that are instantiated into a structural module.

**Instantiation** means to use one or more lower-level modules in the construction of a higher-level structural module. A module can be a logic gate, an adder, a multiplexer, a counter, or some other logical function.

A module consists of declarative text which specifies the function of the module using Verilog constructs. A Verilog module is a software representation of the physical hardware structure and behavior. The declaration of a module is indicated by the keyword `module` and is always terminated by the keyword `endmodule`. Modules contain **ports** which allow communication with the external environment or other modules.

Verilog has predefined logical elements called **primitives**. These built-in primitives are structural elements that can be instantiated into a larger design to form a more complex structure. Examples are: `and`, `or`, `xor`, and `not`.

# Designing a Test Bench for Simulation

This section describes the techniques for writing test benches in Verilog HDL. When a Verilog module is finished, it must be tested to ensure that it operates according to the machine specifications. The functionality of the module can be tested by applying stimulus to the inputs and checking the outputs. The test bench will display the inputs and outputs in a radix (binary, octal, hexadecimal, or decimal).

The test bench contains an instantiation of the unit under test and Verilog code to generate input stimulus and to monitor and display the response to the stimulus.

A Verilog module defines the information that describes the relationship between the inputs and outputs of a logic circuit. A structural module will have one or more in- stantiations of other modules or logic primitives.

**Simple template for a testbench**

Using a two-port and module as an example; see below.

```verilog
/*
 * filename: tb_and2.sv
 */
`timescale 1ns/100ps

module tb_and2;

reg X1, X2; // In SystemVerilog reg -> logic
wire Z1;    // In SystemVerilog wire -> logic

/*
 * display variables
 */
initial begin
  $monitor ("X1 = %b, X2 = %b, Z1 = %b", X1, X2, Z1);
end

/*
 * apply input vectors
 */
initial begin
#0
    X1 = 1'b0;
    X2 = 1'b0;
#10
    X1 = 1'b0;
    X2 = 1'b1;
#10
    X1 = 1'b1;
    X2 = 1'b0;
#10
    X1 = 1'b1;
    X2 = 1'b1;
#10
    $stop;
end

/*
 * instantiate the module into the test bench
 */
and2 dut(
    .X1(x1), .X2(x2), .Z1(z1)
);

endmodule //tb_and2
```

```verilog
/*
 * filename: and2.sv
 */
`timescale 1ns/100ps

module and2 (x1, x2, z1);
    input x1, x2; output z1;
    wire x1, x2; wire z1;
    assign z1 = x1 & x2;
endmodule // and2
```
