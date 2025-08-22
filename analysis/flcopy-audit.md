# flcopy Build Audit

## Toolchain Versions
- `clang-20`: Ubuntu clang version 20.1.8
- `ld.lld-20`: Ubuntu LLD 20.1.8
- `cmake`: 3.28.3
- `ninja`: 1.11.1
- `lizard`: 1.17.31
- `tree-sitter`: 0.25.8

## Header Dependencies
The `clang -MM modern/flcopy.c` command produced:

```
flcopy.o: modern/flcopy.c
```

## Complexity Snapshot
`lizard modern/flcopy.c` reported the following summary:

```
NLOC    Avg.NLOC  AvgCCN  Avg.token  function_cnt    file
    158      23.5     6.2      137.0         6     modern/flcopy.c
```

The `main` function exceeded the default cyclomatic complexity threshold with a CCN of 22.

## Build and Verification
The audit script rebuilt `modern/flcopy` using Clang and LLD and then executed `modern/test-flcopy.sh` to confirm PIE, stack protector, RELRO, and BIND_NOW protections.

## Static Analysis

`cppcheck` noted missing standard headers when run with `--enable=all --inconclusive`.
`clang-tidy` emitted no diagnostics when invoked with `-std=c99`.

## Dynamic Analysis

Runtime diagnostics were performed using `/dev/null` as a stand-in floppy device:

- `valgrind` reported no memory leaks or errors.
- `strace` captured the initial system calls, confirming dynamic linkage to `libc`.
- `ltrace -S` logged the same system calls, demonstrating basic interaction with the kernel.

Detailed traces are preserved in `analysis/logs/flcopy-valgrind.log`, `flcopy-strace.log`, and `flcopy-ltrace.log`.
