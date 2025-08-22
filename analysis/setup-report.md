# Environment Setup Report

## System Packages
The following key development tools were installed via `apt`:

| Package | Version |
| ------- | ------- |
| clang-20 | 20.1.8 |
| ld.lld-20 | 20.1.8 |
| llvm-20 | 20.1.8 |
| cmake | 3.28.3-1build7 |
| ninja-build | 1.11.1-2 |
| build-essential | 12.10ubuntu1 |
| pkg-config | 1.8.1-2build1 |
| gdb | 15.0.50.20240403-0ubuntu1 |
| strace | 6.8-0ubuntu2 |
| ltrace | 0.7.3-6.4ubuntu3 |
| valgrind | 1:3.22.0-0ubuntu3 |
| linux-tools-common | 6.8.0-78.78 |
| linux-tools-generic | 6.8.0-78.78 |
| bear | 3.1.3-1build4 |
| cppcheck | 2.13.0-2ubuntu3 |
| clang-format | 20.1.8 |
| clang-tidy | 20.1.0 |
| shellcheck | 0.9.0 |
| cscope | 15.9-2 |
| cloc | 1.98-1 |
| npm | 9.2.0~ds1-2 |
| python3-pip | 24.0+dfsg-1ubuntu1.2 |
| ripgrep | 14.1.0-1 |

## Node and Python Tools

- `tree-sitter` CLI version `0.25.8` installed globally via `npm`.
- `lizard` complexity analyzer version `1.17.31` installed via `pip`.

## Modern Build Artifact

`modern/flcopy` was compiled with Clang using aggressive optimization and hardening flags:

```
-Wall -Wextra -pedantic -std=c99 -O3 -march=native -flto -fPIE -fno-plt \
-pipe -fstack-protector-strong -D_FORTIFY_SOURCE=2
```

Linker flags ensured a hardened executable:

```
-flto -fstack-protector-strong -Wl,-O1 -Wl,--as-needed -fno-plt -fPIE -pie \
-Wl,--no-undefined -Wl,-z,relro -Wl,-z,now
```

## Hardening Verification

Running `modern/test-flcopy.sh` confirmed PIE, stack protection, RELRO, and immediate binding (`BIND_NOW`) on the resulting binary.

## Static Analysis Tools

`clang-format` and `clang-tidy` 20.1 as well as `shellcheck` 0.9.0 were installed to support source formatting and shell script linting.

