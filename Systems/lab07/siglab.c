#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <time.h>

// Forward Declarations
int install_handler(int sig, void (*handler)(int));
void sigint_handler(int sig);
void sigtstp_handler(int sig);
void sigquit_handler(int sig);
int read_and_echo();

/* main
 * Install the necessary signal handlers, then call read_and_echo().
 */
int main(int argc, char** argv) {
	sigset_t old;
	sigset_t full;
	sigfillset(&full);

	printf("%d\n", getpid());

	// Ignore signals while installing handlers
	sigprocmask(SIG_SETMASK, &full, &old);

	//Install signal handlers
	if(install_handler(SIGINT, &sigint_handler))
		perror("Warning: could not install handler for SIGINT");

	if(install_handler(SIGTSTP, &sigtstp_handler))
		perror("Warning: could not install handler for SIGTSTP");

	if(install_handler(SIGQUIT, &sigquit_handler))
		perror("Warning: could not install handler for SIGQUIT");

	// Restore signal mask to previous value
	sigprocmask(SIG_SETMASK, &old, NULL);

	read_and_echo();

	return 0;
}


int time_start = 0;
int signal_sum = 0;

/* install_handler
 * Installs a signal handler for the given signal
 * Returns 0 on success, -1 on error
 */
int install_handler(int sig, void (*handler)(int)) {
	// TODO: Use sigaction() to install a the given function
	// as a handler for the given signal.

	struct sigaction my_sig;
	my_sig.sa_handler = handler;
	my_sig.sa_flags = SA_RESTART;

	sigemptyset(&my_sig.sa_mask);
	sigaddset(&my_sig.sa_mask, SIGINT);
	sigaddset(&my_sig.sa_mask, SIGTSTP);
	sigaddset(&my_sig.sa_mask, SIGQUIT);

	

	return sigaction(sig, &my_sig, NULL);
}


/* sigint_handler
 * Respond to SIGINT signal (CTRL-C)
 *
 * Argument: int sig - the integer code representing this signal
 */
void sigint_handler(int sig) {
	printf("SIGINT CAUGHT %i\n", sig);
	signal_sum = 1;
	time_start = time(NULL);
}


/* sigtstp_handler 
 * Respond to SIGTSTP signal (CTRL-Z)
 *
 * Argument: int sig - the integer code representing this signal
 */
void sigtstp_handler(int sig) {
	printf("SIGSTP CAUGHT %i\n", sig);
	if( (signal_sum == 1) && ((time(NULL) -time_start ) < 2000)  ){
		signal_sum = 2;
	}
	else{
		signal_sum = 0;
	}
}


/* sigquit_handler
 * Catches SIGQUIT signal (CTRL-\)
 *
 * Argument: int sig - the integer code representing this signal
 */
void sigquit_handler(int sig) {
	printf("SIGQUIT CAUGHT %i\n", sig);
	if( (signal_sum == 2) && ((time(NULL) -time_start ) < 2000)  ){
		printf("Foiled again!\n");
		exit(0);
	}
	else{
		signal_sum = 0;
	}

}

/* read_and_echo
 * Read input from stdin, echo to stdout.
 * Return 0 on EOF, -1 on error
 */
int read_and_echo() {
	// TODO: Read from stdin and write to stdout
	// Use the async-signal-safe syscalls read() and write()
	char buf[1024];
	memset(buf, 0, sizeof(buf));

	ssize_t n;
	while( (n=read(STDIN_FILENO, buf, sizeof(buf) )) > 0 ){

		printf("%i\n", signal_sum);


		if( write(STDOUT_FILENO, buf, sizeof(buf) ) == -1){
			(void)write(2, "lololol broke\n", 15);
			exit(1);
		}
	}
	return -1;
}
