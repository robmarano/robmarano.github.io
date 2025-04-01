# Notes for Week 9 &mdash; Floating Point Numbers & Arithmetic

[ &larr; back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece251/2025/ece251-notes.html)

# Topics

Section 3.5 of CODmips textbook focuses on floating-point arithmetic, addressing the representation and manipulation of fractions and real numbers in computers. It explains why integers alone are insufficient for many calculations and introduces the IEEE 754 standard as the dominant format for representing floating-point numbers.

The section covers the following key concepts:
•
Representation of Floating-Point Numbers: The IEEE 754 standard defines two common formats:
◦
Single Precision (32 bits): Consists of a 1-bit sign (S), an 8-bit exponent (E), and a 23-bit fraction (F).
◦
Double Precision (64 bits): Consists of a 1-bit sign (S), an 11-bit exponent (E), and a 52-bit fraction (F).
◦
The sign bit determines the number's sign (0 for positive, 1 for negative).
◦
The exponent is stored in an excess or biased format. For single precision, the bias is 127, and for double precision, it is 1023. The actual exponent is calculated by subtracting the bias from the stored exponent. This allows for representing both positive and negative exponents without using a separate sign bit.
◦
The fraction (also called the mantissa) represents the significant bits of the number. IEEE 754 uses a normalized form where there is an implied leading '1' before the binary point (except for the number 0). This "hidden bit" is not explicitly stored, providing one extra bit of precision.
•
Normalization: Floating-point numbers are typically normalized so that there is a single non-zero digit to the left of the binary point. In binary, this means the number is of the form 1.xxxx $\times 2^y$. The hidden bit is this leading '1'.
•
Special Values: The IEEE 754 standard defines specific bit patterns for representing special values:
◦
Zero: Represented with an exponent of all 0s and a fraction of all 0s. Both positive and negative zero exist (differing by the sign bit).
◦
Infinity: Represented with an exponent of all 1s and a fraction of all 0s. Both positive and negative infinity exist.
◦
NaN (Not a Number): Represented with an exponent of all 1s and a non-zero fraction. NaNs are used to represent the results of invalid operations (e.g., division by zero, the square root of a negative number).
•
Floating-Point Arithmetic: The section discusses the general steps involved in performing arithmetic operations on floating-point numbers:
◦
Addition and Subtraction: Requires aligning the exponents of the two numbers so that the binary points match. Then, the fractions can be added or subtracted. The result may need to be normalized and rounded.
◦
Multiplication: The fractions are multiplied, and the exponents are added. The result might need to be normalized and rounded.
◦
Division: The fraction of the dividend is divided by the fraction of the divisor, and the exponent of the divisor is subtracted from the exponent of the dividend. The result might need to be normalized and rounded.
•
Precision and Rounding: Due to the finite number of bits used to represent floating-point numbers, rounding is often necessary when the result of an operation cannot be exactly represented. The IEEE 754 standard defines several rounding modes. The use of guard bits, round bits, and sticky bits during calculations helps to improve the accuracy of the rounding process.
•
Underflow and Overflow: Overflow occurs when the result of a floating-point operation is too large to be represented in the given format. Underflow occurs when the result is too small (close to zero) to be represented accurately, potentially leading to a loss of precision or being rounded to zero.
While section 3.5 itself in the provided excerpts doesn't contain extensive worked examples, Exercise 3.23 provides a task that requires understanding the IEEE 754 single-precision format:
Worked Example (based on Exercise 3.23):
Question: Write down the binary representation of the decimal number 63.25 assuming the IEEE 754 single precision format.
Steps:

1.  Convert the integer part to binary: $63_{10} = 32 + 16 + 8 + 4 + 2 + 1 = 111111_2$
2.  Convert the fractional part to binary: $0.25_{10} = 1/4 = 2^{-2} = 0.01_2$
3.  Combine the integer and fractional parts: $63.25_{10} = 111111.01_2$
4.  Normalize the binary number: Move the binary point to the left until there is only one '1' to its left. Count the number of places moved; this is the exponent. $111111.01_2 = 1.1111101 \times 2^5$ The fraction part (after the leading '1') is $1111101$.
5.  Determine the sign bit: Since 63.25 is positive, the sign bit (S) is 0.
6.  Calculate the biased exponent: For single precision, the bias is 127. The actual exponent is 5. Biased exponent = $5 + 127 = 132_{10}$ Convert the biased exponent to binary: $132_{10} = 128 + 4 = 10000100_2$
7.  Write down the fraction: The fraction part is $1111101$. Since the fraction field is 23 bits long, we need to pad it with zeros on the right: $11111010000000000000000_2$
8.  Combine the sign bit, biased exponent, and fraction: Sign (1 bit) | Biased Exponent (8 bits) | Fraction (23 bits) ------- | -------- | -------- 0 | 10000100 | 11111010000000000000000
    Therefore, the IEEE 754 single-precision binary representation of 63.25 is: 0 10000100 11111010000000000000000.
    Exercise 3.29 presents another worked example involving addition with the half-precision format:
    Worked Example (based on Exercise 3.29):
    Question: Calculate the sum of $2.6125 \times 10^1$ and $4.150390625 \times 10^{-1}$ by hand, assuming A and B are stored in the 16-bit half precision described in Exercise 3.27 (1 sign bit, 5 exponent bits with an excess-16 bias, and 10 mantissa bits with a hidden 1). Assume 1 guard, 1 round bit, and 1 sticky bit, and round to the nearest even. Show all the steps.
    While the full steps for this example are lengthy and involve detailed binary conversions and arithmetic with guard, round, and sticky bits, the exercise demonstrates the complexities involved in floating-point addition, particularly regarding exponent alignment, fraction addition, normalization, and rounding. The text emphasizes that such detailed understanding helps explain potential quirks encountered with computer arithmetic.
