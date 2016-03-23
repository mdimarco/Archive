#include "SysCallHandling.h"
#include "Stringlib.h"
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include "jobs.h"
#include <sys/wait.h>
#include <signal.h>


extern job_list_t *ze_jobs;


//Stuff for cd and rm and ln
int handle_sys_call( char **argsv, size_t num_tokens){


	int called = 0;
	if( strcmp(argsv[0], "cd") == 0 ){
		if(num_tokens < 2){
			char *errnote = "Error: select a directory\n";
			write(STDERR_FILENO, errnote, strlen(errnote));
		}
		else{
			handle_cd( argsv );
		}	
		called++;
	}
	if( strcmp(argsv[0], "rm") == 0){
		if(num_tokens < 2){
	    	   char *errnote = "Error: Please specify a file to remove\n";
		   write(STDERR_FILENO, errnote, strlen(errnote));
		}
		else{
		    handle_rm( argsv );
		}
		called++;
	}
	if( strcmp(argsv[0], "ln") == 0){
		if(num_tokens != 3){
	    char *errnote = "Error: ln takes 3  args, itself and 2 files.\n";
		   write(STDERR_FILENO, errnote, strlen(errnote));
		}
		handle_ln( argsv );
		called++;
	}
	if( strcmp(argsv[0], "exit") == 0){
		exit(1);
	}

	if( strcmp(argsv[0], "jobs") == 0){
		jobs( ze_jobs );
		called++;
	}

	if( strcmp(argsv[0], "bg") == 0){
		called++;
		if( num_tokens != 2  ){
			char *errnote = "Error, bg takes 2 args\n";
			write(STDERR_FILENO, errnote, strlen(errnote));
			return called;
		}
		else if( strlen(argsv[1]) < 2 || argsv[1][0] != '%'  ){
			char *errnote = "Error, call bg: % \\num\n";
			write(STDERR_FILENO, errnote, strlen(errnote));
			return called;
		}
		else{
			char jid_str[1];
			jid_str[0] = argsv[1][1];
			int jid = atoi( jid_str );
			pid_t pid;
			if( (pid = get_job_pid(ze_jobs, jid)) == -1 ){
				char *errnote = "job number invalid\n";
				write(STDERR_FILENO, errnote, strlen(errnote));
				return called;
			}

			killpg( pid  , SIGCONT);
		    }
		}

	if( strcmp(argsv[0], "fg") == 0){
		called++;
		if( num_tokens != 2 ){
			char *errnote = "Error, bg takes 2 args\n";
			write(STDERR_FILENO, errnote, strlen(errnote));
			return called;
		}
		else if( strlen(argsv[1]) < 2 || argsv[1][0] != '%' ){
			char *errnote = "Error, call fg % \\num \n";
			write(STDERR_FILENO, errnote, strlen(errnote));
			return called;
		}
		else{
			char jid_str[1];
			jid_str[0] = argsv[1][1];
			int jid = atoi( jid_str );
			pid_t pid;
		        if( (pid= get_job_pid(ze_jobs, jid)) == -1){
				char *errnote = "Error, incorrect jid\n";
				write(STDERR_FILENO, errnote, strlen(errnote));	
				return called;
			}
			killpg( pid, SIGCONT);
		 //giving terminal control to child
	         //from the parent process
		if( tcsetpgrp( STDIN_FILENO, getpgid(pid) ) <0 ){
			perror("Error giving child terminal control from parent");
		}


		int status;
	   	if( waitpid(pid, &status, WUNTRACED) == -1){
			perror("waitpid");
		}
		pid_t kid_pid = pid;
		char message[256];
		int len;

		if( WIFSIGNALED(status) ){
		    //Terminated by signal
		    len = sprintf(message,"[%d] (%d) terminated by signal %d\n", jid, kid_pid, WTERMSIG(status));
		    if( remove_job_pid(ze_jobs, kid_pid) == -1){
			char *errm = "Error removing child job from jobs list\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		    }
		    write(STDOUT_FILENO, message, (size_t)len);
	        }
		else if( WIFSTOPPED(status) ){
		    //Stopped
		    len = sprintf(message,"[%d] (%d) suspended by signal %d\n", jid, kid_pid, WSTOPSIG(status));
		    if( update_job_pid(ze_jobs, kid_pid, _STATE_STOPPED ) == -1){
			char *errm = "Error marking job as stopped\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
	            }
		    write(STDOUT_FILENO, message, (size_t)len);
	        }
		else if( WIFEXITED(status) ){
		    //Exited
		    len = sprintf(message,"[%d] (%d) terminated with exit status %d\n", jid, kid_pid, WEXITSTATUS(status));
		    if( remove_job_pid(ze_jobs, kid_pid) == -1){
			char *errm = "Error removing child job from jobs list\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		    }
		}
	
	
		}
		//Get terminal control back to parent
	   	if(tcsetpgrp(STDIN_FILENO, getpgrp()) < 0){
		   perror("Error getting terminal back after child\n");
		   exit(1);
		   }

	}



	return called;
}


void handle_cd( char *argsv[255]){
	if( chdir(argsv[1]) == -1){
		char *errnote = "Error: Incorrect directory\n";
		write(2, errnote, strlen(errnote) );
		exit(1);
	}
}

void handle_rm( char *argsv[255]){
	if( unlink(argsv[1]) == -1){
		char *errnote = "Error: Removal failed\n";
		write(2, errnote, strlen(errnote));
		exit(1);
	}

}

void handle_ln( char *argsv[255]){
	if( link(argsv[1], argsv[2]) == -1){
		char *errnote = "Error: Linking failed\n";
		write(2, errnote, strlen(errnote));
		exit(1);
	}

}

