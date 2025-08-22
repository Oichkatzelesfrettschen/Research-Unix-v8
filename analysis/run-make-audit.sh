#!/usr/bin/env bash
#
# Global build audit for Research Unix v8 tree.
# Enumerates every Makefile and attempts a Clang/LLD build while
# capturing logs and summarizing success or failure.  This provides
# a reproducible snapshot of which components still build under a
# modern toolchain.

set -euo pipefail

CC=${CC:-clang-20}
LD=${LD:-ld.lld-20}
LOG_DIR="analysis/logs"
SUMMARY_FILE="$LOG_DIR/summary.txt"

mkdir -p "$LOG_DIR"
: > "$SUMMARY_FILE"

find . -name Makefile | sort | while read -r mk; do
  dir=$(dirname "$mk")
  safe_name=$(echo "$dir" | tr '/.' '__')
  logfile="$LOG_DIR/${safe_name}.log"
  echo "=== Building $dir ===" | tee "$logfile"
  (
    set +e
    make -C "$dir" clean >/dev/null 2>&1
    make -C "$dir" CC="$CC" LD="$LD" V=1 >>"$logfile" 2>&1
    rc=$?
    echo "status=$rc" >>"$logfile"
    if [ $rc -eq 0 ]; then
      echo "$dir: success" >>"$SUMMARY_FILE"
    else
      echo "$dir: failure ($rc)" >>"$SUMMARY_FILE"
    fi
  )
done

cat "$SUMMARY_FILE"
