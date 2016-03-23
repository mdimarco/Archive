/* This program reads command line arguments
 * and sends the corresponding signals to the specified PID */

#include <signal.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

/* Main function */
int main(int argc, char** argv) {
	// TODO: Parse command line arguments and send the specified signals
	// Pause briefly between signals using sleep(), usleep(), or nanosleep()
	if(argc != 3){
		printf("Error\n");
		return 1;
	}

	pid_t pid = atoi(argv[1]);
	for(size_t i = 0; i < strlen(argv[2]); i++){
		if( argv[2][i] == 'c'){
			kill(pid, SIGINT);
		}
		if( argv[2][i] == 'z'){
			kill(pid, SIGTSTP);
		}
		if( argv[2][i] == 'q'){
			kill(pid, SIGQUIT);
		}
		usleep(15);
	}
	return 0;
}
