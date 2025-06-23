CC ?= gcc
# Aggressively optimize for the host machine while remaining
# standards compliant.  Security hardening options and link-time
# optimization further reduce the binary footprint.
CFLAGS ?= -Wall -Wextra -pedantic -std=c99 -O3 -march=native -flto -fPIE -fno-plt \
       -pipe -fstack-protector-strong -D_FORTIFY_SOURCE=2
LDFLAGS ?= -flto -fstack-protector-strong -Wl,-O1 -Wl,--as-needed -fno-plt \
       -fPIE -pie -Wl,--no-undefined -Wl,-z,relro -Wl,-z,now

all: flcopy

flcopy: flcopy.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f flcopy

.PHONY: all clean
