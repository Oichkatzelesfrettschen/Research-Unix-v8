#!/bin/sh
# Build and verify the modern flcopy utility using CMake.
set -eu

build_dir="build-test"
rm -rf "$build_dir"

cmake -B "$build_dir" -S .. -G Ninja \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_LINKER=lld \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo
ninja -C "$build_dir" flcopy

bin="$build_dir/modern/flcopy"

# Ensure the binary is a PIE
if ! readelf -h "$bin" | grep -q "Type:.*DYN"; then
	echo "flcopy is not built as PIE" >&2
	exit 1
fi

# Ensure stack protector symbols are present
if ! readelf -s "$bin" | grep -q "__stack_chk_fail"; then
	echo "Stack protector not enabled" >&2
	exit 1
fi

# Verify RELRO and BIND_NOW
if ! readelf -l "$bin" | grep -q "GNU_RELRO"; then
	echo "RELRO not enabled" >&2
	exit 1
fi
if ! readelf -d "$bin" | grep -q "BIND_NOW"; then
	echo "BIND_NOW not enabled" >&2
	exit 1
fi

# Ensure no PLT calls except for the startup and stack protector handlers
if objdump -d "$bin" | grep -E "@plt>" | grep -vE "__cxa_finalize|__stack_chk_fail" >/dev/null; then
	echo "Unexpected PLT calls detected" >&2
	exit 1
fi

# Warn if control-flow protection notes are missing; absence indicates the
# compiler lacked support for -fcf-protection.
if ! readelf -n "$bin" | grep -q "GNU_PROPERTY_X86_FEATURE_1_IBT"; then
	echo "Warning: IBT note missing" >&2
fi
if ! readelf -n "$bin" | grep -q "GNU_PROPERTY_X86_FEATURE_1_SHSTK"; then
	echo "Warning: SHSTK note missing" >&2
fi

echo "flcopy passes hardening checks."
