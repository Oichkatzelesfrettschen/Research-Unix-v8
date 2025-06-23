#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>

/**
 * Modernized floppy copy utility derived from Research Unix v8.
 * This version compiles cleanly with modern C compilers and
 * demonstrates basic block-level copy between a floppy device
 * and an image file. It preserves the original algorithm but
 * uses ANSI C prototypes and standard headers.
 */

static int floppydes = -1;
static const char *flopname = "/dev/floppy";
static long dsize = 77L * 26 * 128; /* default size in bytes */
static int hflag = 0; /* half-time flag */
static int rflag = 0; /* read-only flag */

static void usage(const char *progname);
static void rt_init(void);
static long trans(int logical);
static void lread(int startad, int count, char *obuff);
static void lwrite(int startad, int count, char *obuff);

int main(int argc, char **argv) {
    char buff[512];
    long count;
    int startad = -26 * 128;
    int n, file = -1;
    int opt;
    static const struct option long_opts[] = {
        {"help",  no_argument,       0, 'H'},
        {0,       0,                 0, 0}
    };

    while ((opt = getopt_long(argc, argv, "d:hrt:H", long_opts, NULL)) != -1) {
        switch (opt) {
        case 'H':
            usage(argv[0]);
            return 0;
        case 'd':
            flopname = optarg;
            break;
        case 'h':
            hflag = 1;
            break;
        case 'r':
            rflag = 1;
            break;
        case 't':
            dsize = atol(optarg);
            if (dsize <= 0 || dsize > 77) {
                fprintf(stderr, "Bad number of tracks\n");
                return 2;
            }
            dsize *= 26 * 128;
            break;
        default:
            usage(argv[0]);
            return 1;
        }
    }
    if (optind != argc) {
        usage(argv[0]);
        return 1;
    }
    if (hflag) {
        printf("Halftime!\n");
        file = open("floppy", O_RDONLY);
        if (file < 0) {
            perror("failed to open floppy image for reading");
            return 1;
        }
    }

    if (!hflag) {
        file = creat("floppy", 0666);
        (void)close(file);
        file = open("floppy", O_RDWR);
        if (file < 0) {
            perror("failed to open floppy image");
            return 1;
        }
        for (count = dsize; count > 0; count -= 512) {
            n = count > 512 ? 512 : (int)count;
            lread(startad, n, buff);
            if (write(file, buff, n) != n) {
                perror("write");
                return 1;
            }
            startad += 512;
        }
    }

    if (rflag) return 0;
    printf("Change Floppy, hit return when done.\n");
    if (fgets(buff, sizeof(buff), stdin) == NULL) {
        perror("fgets");
        return 1;
    }
    (void)lseek(file, 0, SEEK_SET);
    count = dsize; startad = -26 * 128;
    for (; count > 0; count -= 512) {
        n = count > 512 ? 512 : (int)count;
        if (read(file, buff, n) != n) {
            perror("read");
            return 1;
        }
        lwrite(startad, n, buff);
        startad += 512;
    }
    return 0;
}

static void rt_init(void) {
    static int initialized = 0;
    int mode = O_RDWR;
    if (initialized) return;
    if (rflag) mode = O_RDONLY;
    initialized = 1;
    floppydes = open(flopname, mode);
    if (floppydes < 0) {
        perror("Floppy open failed");
        exit(1);
    }
}

static long trans(int logical) {
    /* Logical to physical address translation */
    int sector, bytes, track;
    logical += 26 * 128;
    bytes = logical & 127;
    logical >>= 7;
    sector = logical % 26;
    if (sector >= 13)
        sector = sector * 2 + 1;
    else
        sector *= 2;
    sector += 26 + ((track = (logical / 26)) - 1) * 6;
    sector %= 26;
    return (((track * 26) + sector) << 7) + bytes;
}

static void lread(int startad, int count, char *obuff) {
    rt_init();
    while ((count -= 128) >= 0) {
        if (lseek(floppydes, trans(startad), SEEK_SET) < 0 ||
            read(floppydes, obuff, 128) != 128) {
            perror("floppy read");
            exit(1);
        }
        obuff += 128;
        startad += 128;
    }
}

static void lwrite(int startad, int count, char *obuff) {
    rt_init();
    while ((count -= 128) >= 0) {
        if (lseek(floppydes, trans(startad), SEEK_SET) < 0 ||
            write(floppydes, obuff, 128) != 128) {
            perror("floppy write");
            exit(1);
        }
        obuff += 128;
        startad += 128;
    }
}

static void usage(const char *progname) {
    fprintf(stderr,
            "Usage: %s [-d device] [-h] [-r] [-t tracks]\n",
            progname);
}

