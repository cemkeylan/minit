#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/reboot.h>

#define LEN(x) (sizeof (x) / sizeof *(x))

static void sigpoweroff(void);
static void sigreboot(void);
static void sighalt(void);
static void sigrestart(void);
static void spawn(char *const []);

static struct {
	int sig;
	void (*handler)(void);} sigmap[] = {
	{ SIGUSR1, sigpoweroff },
	{ SIGINT,  sigreboot   },
	{ SIGUSR2, sighalt     },
	{ SIGQUIT, sigrestart  },
};

static sigset_t set;

#include "config.h"

int main(void) {
	int sig;
	size_t i;
	if (getpid() != 1) return 1;

	sigfillset(&set);
	sigprocmask(SIG_BLOCK, &set, 0);
	spawn(rcinitcmd);
	while (1) {
		sigwait(&set, &sig);
		for (i = 0; i < LEN(sigmap); i++) {
			if (sigmap[i].sig == sig) {
				sigmap[i].handler();
				break;
			}
		}
	}
}

static void sigpoweroff(void){spawn(rcpoweroffcmd);}
static void sigreboot(void){spawn(rcrebootcmd);}
static void sighalt(void){reboot(RB_POWER_OFF);}
static void sigrestart(void){reboot(RB_AUTOBOOT);}
static void spawn(char *const argv[]){
	switch (fork()) {
		case 0:
			sigprocmask(SIG_UNBLOCK, &set, NULL);
			setsid();
			execvp(argv[0], argv);
			perror("execvp");
			_exit(1);
		case -1:
			perror("fork");
	}
}
