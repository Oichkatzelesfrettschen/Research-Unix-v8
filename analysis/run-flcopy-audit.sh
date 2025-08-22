#!/usr/bin/env bash
# Audit script for modern/flcopy build environment and dependencies.
# Displays tool versions, header dependencies, complexity analysis,
# and executes a hardened build with subsequent verification tests.
set -euo pipefail

# Resolve tool commands
CC=${CC:-clang-20}
LD=${LD:-ld.lld-20}
LOG_DIR="analysis/logs"
mkdir -p "$LOG_DIR"

# Show critical tool versions
"$CC" --version
"$LD" --version
cmake --version
ninja --version
lizard --version
tree-sitter --version

# Examine header dependencies for flcopy.c
"$CC" -MM modern/flcopy.c

# Run complexity analysis
lizard modern/flcopy.c || true

# Static analysis
cppcheck --enable=all --inconclusive modern/flcopy.c || true
clang-tidy modern/flcopy.c -- -std=c99 || true

# Build and verify flcopy
make -C modern clean all CC="$CC" LD="$LD"
( cd modern && ./test-flcopy.sh )

# Dynamic analysis using /dev/null as a dummy device
valgrind --leak-check=full ./modern/flcopy -d /dev/null &> "$LOG_DIR/flcopy-valgrind.log" || true
strace -o "$LOG_DIR/flcopy-strace.log" ./modern/flcopy -d /dev/null || true
ltrace -S -o "$LOG_DIR/flcopy-ltrace.log" ./modern/flcopy -d /dev/null || true
