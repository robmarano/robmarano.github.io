# Architecture & Bug Fix TODOs (Pipelined CPU with Exceptions)

This document outlines critical structural bugs and architectural flaws that were identified and have since been REMEDIATED.

---

## 1. [RESOLVED] EPC Logic Error (Instruction Re-execution Bug)
**Severity:** Critical
**Status:** FIXED in `datapath.sv`
**Verification:** Verified via `tb_exceptions.sv` showing EPC capturing `pcplus4D - 4`.

---

## 2. [RESOLVED] ALU Control Collision (MFHI & Division Overlap)
**Severity:** High
**Status:** FIXED. expanded `alucontrol` to 4 bits. 
**Verification:** `DIV` is now `4'b1000` and `MFHI` is `4'b0101`.

---

## 3. [RESOLVED] ALU Control Collision (MULT & NOR Overlap)
**Severity:** High
**Status:** FIXED. expanded `alucontrol` to 4 bits.
**Verification:** `MULT` is now `4'b1001` and `NOR` is `4'b0011`.

---

## 4. [RESOLVED] Exception Vector Memory Aliasing
**Severity:** Medium
**Status:** FIXED. Memory depths increased.

---

## 5. [RESOLVED] Testbench Port Instantiation Mismatch
**Severity:** Low / Build Failure
**Status:** FIXED in `tb_computer.sv`.
**Verification:** `computer dut(clk, reset, intr, ...)` correctly connected.
