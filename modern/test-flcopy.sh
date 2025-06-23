#!/bin/sh
# Simple build test verifying hardened flags in flcopy
set -e

make clean
make

# Ensure the binary is a PIE
if ! readelf -h flcopy | grep -q "Type:.*DYN"; then
    echo "flcopy is not built as PIE" >&2
    exit 1
fi

# Ensure stack protector symbols are present
if ! readelf -s flcopy | grep -q "__stack_chk_fail"; then
    echo "Stack protector not enabled" >&2
    exit 1
fi

# Verify RELRO and BIND_NOW
if ! readelf -l flcopy | grep -q "GNU_RELRO"; then
    echo "RELRO not enabled" >&2
    exit 1
fi

if ! readelf -d flcopy | grep -q "BIND_NOW"; then
    echo "BIND_NOW not enabled" >&2
    exit 1
fi

# Ensure no PLT calls except for the startup handler
if objdump -d flcopy | grep -E "@plt>" | grep -v "__cxa_finalize" >/dev/null; then
    echo "Unexpected PLT calls detected" >&2
    exit 1
fi

echo "flcopy passes hardening checks."
