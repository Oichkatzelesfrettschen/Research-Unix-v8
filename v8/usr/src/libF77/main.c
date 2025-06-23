/* STARTUP PROCEDURE FOR UNIX FORTRAN PROGRAMS */

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>

static void sigfdie(int);
static void sigidie(int);
static void sigqdie(int);
static void sigindie(int);
static void sigtdie(int);
static void sigdie(char *, int);
void f_init(void);
void MAIN__(void);
void f_exit(void);

int xargc;
char **xargv;

int main(int argc, char **argv, char **arge)
{

xargc = argc;
xargv = argv;
signal(SIGFPE, sigfdie);	/* ignore underflow, enable overflow */
signal(SIGIOT, sigidie);
if( (int)signal(SIGQUIT,sigqdie) & 01) signal(SIGQUIT, SIG_IGN);
if( (int)signal(SIGINT, sigindie) & 01) signal(SIGINT, SIG_IGN);
signal(SIGTERM,sigtdie);

#ifdef pdp11
	ldfps(01200); /* detect overflow as an exception */
#endif

f_init();
MAIN__();
f_exit();
}


static void sigfdie(int sig)
{
sigdie("Floating Exception", 1);
}



static void sigidie(int sig)
{
sigdie("IOT Trap", 1);
}


static void sigqdie(int sig)
{
sigdie("Quit signal", 1);
}



static void sigindie(int sig)
{
sigdie("Interrupt", 0);
}



static void sigtdie(int sig)
{
sigdie("Killed", 0);
}



static void sigdie(char *s, int kill)
{
/* print error message, then clear buffers */
fflush(stderr);
fprintf(stderr, "%s\n", s);
f_exit();
fflush(stderr);

if(kill)
	{
	/* now get a core */
	signal(SIGIOT, 0);
	abort();
	}
else
	exit(1);
}
