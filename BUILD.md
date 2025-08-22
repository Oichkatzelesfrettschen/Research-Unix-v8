# Build Guide

The repository preserves Bell Labs' 8th Edition Research Unix sources.  Modern development uses the LLVM/Clang toolchain with `lld` and the Ninja build system.

## Prerequisites

Follow [SETUP.md](SETUP.md) to install Clang, `lld`, CMake, Ninja, and related analysis tools.  These utilities enable reproducible builds on contemporary Unix-like hosts.

## Modern Ninja Entry Point

```sh
cmake -B build -G Ninja \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_LINKER=lld \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
ninja -C build
```

This `ninja` invocation is the primary build driver going forward.  Reusable modules in `cmake/` provide shared header checks and hardening flags so future utilities can adopt the same configuration.  Individual targets may be invoked directly; for example, to build the modern `flcopy` utility:

```sh
ninja -C build flcopy
```

Run the test suite to verify hardening and configuration checks:

```sh
ctest --test-dir build
```

## Legacy Makefiles (Historical)

The original tree retains makefiles designed for early 1980s Unix environments.  They remain available for reference or archaeology.

### Kernel

```sh
cd v8/usr/sys/conf
make
```

The `makefile` invokes `newvers.sh` and expects a VAX cross-compiler, producing a `vmunix` image.

### Userland

```sh
cd v8/usr/src
make
```

This top-level make recursively enters subdirectories such as `lib`, `cmd`, and `libc` to build each component.

## Notes

These sources are historical and may require patches to compile on modern hosts.  The makefiles assume toolchain conventions from the early 1980s.
