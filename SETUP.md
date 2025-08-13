# Development Environment Setup

This guide replaces the former `setup.sh` script and enumerates the tools needed to explore and refactor the 8th Edition Research Unix source tree with a modern LLVM/Clang + Ninja workflow.  Each utility is documented with its purpose.

## Update Package Lists

```sh
sudo apt update
```

## Install Build and Analysis Tools

```sh
sudo apt install -y clang lld llvm cmake ninja-build build-essential pkg-config gdb strace ltrace valgrind linux-tools-common linux-tools-generic bear cppcheck cscope cloc npm python3-pip ripgrep
```

| Tool | Purpose |
|------|---------|
| `clang`/`clang++` | Primary C/C++ compilers |
| `lld` | Modern linker used in place of `ld` |
| `llvm` | Supplementary LLVM utilities such as `llvm-ar`, `clang-format`, and `clang-tidy` |
| `cmake` | Build-system generator targeting Ninja |
| `ninja-build` | High-speed build executor and new main entry point |
| `build-essential` | Provides GNU make and standard headers required by some tools |
| `pkg-config` | Discovers compiler/linker flags for libraries |
| `gdb` | Source-level debugger |
| `strace`, `ltrace` | Trace system and library calls for instrumentation |
| `valgrind` | Dynamic analysis and memory debugging |
| `linux-tools-common`, `linux-tools-generic` | Performance analysis (`perf`); a kernel-specific package may be required |
| `bear` | Captures compilation commands into `compile_commands.json` |
| `cppcheck` | Static analysis for C/C++ |
| `cscope` | Code navigation database |
| `cloc` | Counts lines of code |
| `ripgrep` | Fast project-wide search |
| `npm` | Node.js package manager |
| `python3-pip` | Python package manager |

## Install Node-based Tree-sitter CLI

```sh
sudo npm install -g tree-sitter-cli
```

## Install Lizard for Complexity Analysis

```sh
sudo pip install lizard --break-system-packages
```

## Configure Environment

Optionally set the toolchain explicitly:

```sh
export CC=clang
export CXX=clang++
export LD=ld.lld
```

These steps furnish the LLVM/Clang toolchain, the `lld` linker, Ninja, and an assortment of analysis and instrumentation utilities.

## Analysis Tool Installation Matrix

The following table summarizes recommended installation paths for common analysis and instrumentation utilities.  Commands reflect the authoritative method cited by each project's documentation or distribution-specific packaging.

```
+-------------------+--------------------+--------------------------------------------------+
| Tool              | Installation Method| Example Command                                  |
+-------------------+--------------------+--------------------------------------------------+
| lizard            | pip                | pip install lizard                               |
| cloc              | apt                | sudo apt install cloc                            |
| cscope            | apt                | sudo apt install cscope                          |
| diffoscope        | pip                | pip install diffoscope                           |
| dtrace            | Source/Build       | git clone https://github.com/dtrace4linux/linux.git; cd linux; make; sudo make install |
| valgrind          | apt                | sudo apt install valgrind                        |
| cppcheck          | apt                | sudo apt install cppcheck                        |
| sloccount         | apt                | sudo apt install sloccount                       |
| flawfinder        | apt                | sudo apt install flawfinder                      |
| gdb               | apt                | sudo apt install gdb                             |
| pylint            | pip                | pip install pylint                               |
| flake8            | pip                | pip install flake8                               |
| mypy              | pip                | pip install mypy                                 |
| semgrep           | pip                | pip install semgrep                              |
| eslint            | npm                | npm install -g eslint                            |
| jshint            | npm                | npm install -g jshint                            |
| jscpd             | npm                | npm install -g jscpd                             |
| nyc               | npm                | npm install -g nyc                               |
+-------------------+--------------------+--------------------------------------------------+
```

When multiple installation avenues exist, the table prefers the distribution-specific package manager (e.g., `apt` for Debian-based systems), language-native managers (`pip`, `npm`), or official source builds where no packaged alternative is available.
