# Using Verilog Locally On Your Computer

[<- back to notes](/courses/ece251/2025/ece251-notes.md) ;
[<- back to syllabus](/courses/ece251/2025/ece251-syllabus-spring-2025.md)

---

Instead of using [EDA Playground]() or [8bitWorkshop IDE](https://8bitworkshop.com/v3.11.0/?file=racing_game_cpu.v&platform=verilog)

_from MIT [course site](https://fpga.mit.edu/6205/F22/documentation/iVerilog)_

Icarus Verilog (or iVerilog for short) is a open-source Verilog simulation and synthesis tool we use for making fast simulations of Verilog projects. iVerilog works on all three families of operating systems. Details for different operating systems are provided on this site. A few notes from our experience:

# Windows and Icarus Verilog & GTKWave

If you're on Windows, it's best to just use the installer. There's a link to the installer page at the bottom of the official docs, or you can grab it here. Make sure to check the box to add the executable folders to the path when you install. There's also an option in the installer to also install GTKWave, feel free to check that too.

We'll also need to install GTKWave as well. This is a good lightweight waveform viewer, used for displaying simulation output. Detailed install instructions can be found [here](http://gtkwave.sourceforge.net/), and shouldn't need any significant changes, but we've found:

If you're on Windows and you already installed GTKWave at the same time you installed iVerilog, there's no need to install it again.

## Install using Software Packager Chocolately

This is the easiest and quickest.

- install Chocolately by following these [directions](https://chocolatey.org/install)
- open a Windows command prompt like `CMD` or `POWERSHELL` with elevated privileges, that is, running as Administrator
- to install iVerilog run this at the command prompt `choco install iverilog`
  - see https://community.chocolatey.org/packages/iverilog
- to install GTKwave run this at the command prompt `choco install gtkwave`
  - https://community.chocolatey.org/packages/gtkwave

**In case you're seeing messages that state the script (makefile.ps1) cannot run, try the following:**

1. Using "Search" on your task bar at the bottom, type in powershell then "Run as Administrator"
2. Type the following command to allow scripts to run and press Enter: Set-ExecutionPolicy RemoteSigned
3. Type "A" and press Enter (if applicable).
4. Type in the name of your script, e.g., .\makefile.ps1

You can check if the script execution policy was applied by typing `Get-ExecutionPolicy -List`. An example output would be as follows:

```powershell
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned
 LocalMachine    RemoteSigned
```

## Get source code, compile and install on your Windows PC

- if you're bold and have time on your hands (read this as doing this after the course)
- following these [directions](https://steveicarus.github.io/iverilog/usage/installation.md)

# MacOS and Icarus Verilog

If you're on Mac, just install it using [Homebrew](https://brew.sh/).

```bash
brew install icarus-verilog
```

That seems to be the least painful. macOS people will probably have the easiest time installing from homebrew with `brew install --cask gtkwave`. You might need to go the General tab under your `Security and Privacy` settings and manually allow GTKWave to run.

# Linux and Icarus Verilog & GTKwave

If you're using Debian/Ubuntu Linux, run `sudo apt update && sudo apt install -y iverilog`. To install GTKWave, `apt install gtkwave`.
