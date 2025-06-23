# Modern Build Example

This repository preserves the Research Unix Version 8 source tree.
To demonstrate building a small utility with a modern toolchain, the
`modern/` directory contains a cleaned up version of `flcopy.c`.

```
cd modern
make
```

The resulting binary `flcopy` links against standard C libraries and
uses aggressive optimization including link-time optimization.
The Makefile uses an aggressive set of optimization and hardening flags:

* `-O3` and `-march=native` tune the code for the host CPU
* `-flto` enables link-time optimization for smaller binaries
* `-pipe` streams intermediate results through pipes
* `-fPIE` and the linker option `-pie` produce a position independent executable
* `-fno-plt` avoids the PLT for faster, safer calls
* `-fstack-protector-strong` and `-D_FORTIFY_SOURCE=2` add stack smashing guards
* `-Wl,--no-undefined` ensures all symbols resolve at link time
* `-Wl,-z,relro` and `-Wl,-z,now` enforce immediate relocation binding

All of these flags combine to produce a secure, optimized utility.
The floppy device may be specified with the `-d` flag:

```sh
./flcopy -d /dev/fd0
```

Run `./flcopy --help` (or `-H`) for a summary of options.

## Testing the build

`test-flcopy.sh` rebuilds the program and verifies that PIE,
stack-protector support, and that no spurious PLT calls remain:

```sh
./test-flcopy.sh
```

### Analyzing complexity

The setup script installs the `lizard` tool. Run it to review function
complexity metrics:

```sh
lizard flcopy.c
```
