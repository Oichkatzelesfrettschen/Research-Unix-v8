# diffoscope

```
--- SETUP.md
+++ BUILD.md
@@ -1,91 +1,42 @@
-# Development Environment Setup
+# Build Guide
 
-This guide replaces the former `setup.sh` script and enumerates the tools needed to explore and refactor the 8th Edition Research Unix source tree with a modern LLVM/Clang + Ninja workflow.  Each utility is documented with its purpose.
+The repository preserves Bell Labs' 8th Edition Research Unix sources.  Modern development uses the LLVM/Clang toolchain with `lld` and the Ninja build system.
 
-## Update Package Lists
+## Modern Ninja Entry Point
 
 ```sh
-sudo apt update
+cmake -B build -G Ninja \
+      -DCMAKE_C_COMPILER=clang \
+      -DCMAKE_CXX_COMPILER=clang++ \
+      -DCMAKE_LINKER=lld \
+      -DCMAKE_BUILD_TYPE=RelWithDebInfo
+ninja -C build

```
