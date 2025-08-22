# Modern Build Example

This repository preserves the Research Unix Version 8 source tree.
To demonstrate building a small utility with a modern toolchain, the
`modern/` directory contains a cleaned up version of `flcopy.c`.

Configuration now leverages reusable CMake modules. `Require.cmake`
verifies that all requisite headers and runtime symbols are present
before compilation, while `Hardening.cmake` applies a consistent suite
of optimization and security flags.

Build the example with CMake and Ninja:

```sh
cmake -B build -S .. -G Ninja \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_LINKER=lld \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
ninja -C build flcopy
```

The resulting binary `build/modern/flcopy` links against the standard C
library and applies an aggressive set of optimization and hardening
flags:

* `-O3` and `-march=native` tune the code for the host CPU
* `-flto` enables link-time optimization for smaller binaries
* `-pipe` streams intermediate results through pipes
* `-fPIE` and the linker option `-pie` produce a position independent executable
* `-fno-plt` avoids the PLT for faster, safer calls
* `-fstack-protector-strong` and `-D_FORTIFY_SOURCE=2` add stack smashing guards
* `-fstack-clash-protection` (when available) mitigates stack clash attacks
* `-fcf-protection=full` (when available) emits Intel CET instrumentation
* `-Wformat=2` strengthens format string checking
* `-Wl,--no-undefined` ensures all symbols resolve at link time
* `-Wl,-z,relro` and `-Wl,-z,now` enforce immediate relocation binding

All of these flags combine to produce a secure, optimized utility.
The floppy device may be specified with the `-d` flag:

```sh
./build/modern/flcopy -d /dev/fd0
```

Run `./build/modern/flcopy --help` (or `-H`) for a summary of options.

### Complexity analysis

If the [lizard](https://github.com/terryyin/lizard) tool is available,
CTests also invoke it to report function metrics for `flcopy.c`.

## Testing the build

`test-flcopy.sh` rebuilds the program using CMake and verifies that PIE,
stack-protector support, and that no spurious PLT calls remain. It also
warns if the binary lacks Intel CET notes, indicating the compiler does
not support `-fcf-protection`. The script is integrated with CTest so
after building you may run:

```sh
ctest --test-dir build
```

to execute the verification suite. Alternatively, invoke the script
directly:

```sh
./test-flcopy.sh
```

### Analyzing complexity

The setup script installs the `lizard` tool. Run it to review function
complexity metrics:

```sh
lizard flcopy.c
```
