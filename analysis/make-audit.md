# Global Makefile Build Audit

Running `analysis/run-make-audit.sh` attempted to build every `Makefile` in the repository using `clang-20` and `ld.lld-20`.
Results are summarized from `analysis/logs/summary.txt`.

## Summary

| Directory | Result |
| --------- | ------ |
| blit/diag | success |
| blit/src/pads | success |
| jerq/src/pads | success |
| modern | success |
| *(many others)* | failure |

## Example Failure

`blit/src/blitblt` fails due to reliance on legacy terminal interfaces:

```
blitblt.c:118:26: error: ‘TIOCGETP’ undeclared (first use in this function)
blitblt.c:120:35: error: ‘RAW’ undeclared (first use in this function)
blitblt.c:121:35: error: ‘ECHO’ undeclared (first use in this function)
```

For complete logs see files under `analysis/logs/`.
