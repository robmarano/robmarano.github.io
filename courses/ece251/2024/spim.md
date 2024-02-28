# Meet SPIM

_Source:_ [SPIM &mdash; A MIPS32 Simulator](https://pages.cs.wisc.edu/~larus/spim.html)

> `spim` is a self-contained simulator that runs `MIPS32` programs. It reads and executes assembly language programs written for this processor. `spim` also provides a simple debugger and minimal set of operating system services. `spim` does not execute binary (compiled) programs. So provide only MIP32 assembly program files.
>
> `spim` implements almost the entire `MIPS32` assembler-extended instruction set. (It _omits_ most floating point comparisons and rounding modes and the memory system page tables.) The `MIPS` architecture has several variants that differ in various ways (e.g., the `MIPS64` architecture supports 64-bit integers and addresses), which means that `spim` will not run programs compiled for all MIPS processors. `MIPS` compilers also generate a number of assembler directives that `spim` cannot process. These directives usually can be safely ignored.
>
> Earlier versions of spim (before 7.0) implemented the `MIPS-I` instruction set used on the `MIPS R2000/R3000` computers. This architecture is obsolete (though, never surpassed for its simplicity and elegance). `spim` now supports the more modern `MIPS32` architecture, which is the `MIPS-I` instruction set augmented with a large number of occasionally useful instructions. `MIPS` code from earlier versions of `SPIM` should run without changes, except code that handles exceptions and interrupts. This part of the architecture changed over time (and was poorly implemented in earlier versions of `spim`). This type of code will need to be updated. Examples of new exception handling are in the files: `exceptions.s` and `Tests/tt.io.s`.
>
> `spim` comes with complete source code and documentation. It also include a torture test to verify a port to a new machine.
>
> `spim` implements both a terminal and a window interface. On `Microsoft Windows`, `Linux`, and `Mac OS X`, the `spim` program provides the simple terminal interface and the `QtSpim` program provides the windowing interface.

# Installing `spim`

> QtSpim
> The newest version of spim is called QtSpim, and unlike all of the other version, it runs on Microsoft Windows, Mac OS X, and Linux—the same source code and the same user interface on all three platforms! QtSpim is the version of spim that currently being actively maintaned. The other versions are still available, but please stop using them and move to QtSpim. It has a modern user interface, extensive help, and is consistent across all three platforms. QtSpim makes my life far easier, and will likely improve yours and your students' experience as well.
>
> A compiled, immediately installable version of QtSpim is available for Microsoft Windows, Mac OS X, and Linux can be downloaded from: https://sourceforge.net/projects/spimsimulator/files/. Full source code is also available (to compile QtSpim, you need Nokia's Qt framework, a very nice cross-platform UI framework that can be downloaded from here).

## Installing on `Windows`, `Linux`, and `MacOS`

Download the files from here https://sourceforge.net/projects/spimsimulator/files/.

### Another way on `MacOS`

Use Homebrew to install. There are two versions: one to run in a terminal and another to run as a GUI application, called `Qtspim`.

Terminal-based `spim`:

```bash
brew install spim
```

GUI-based `Qtspim`:

```bash
brew install --cask qtspim
```

# `Qtspim` Tutorial

See https://www.lri.fr/~de/QtSpim-Tutorial.pdf
