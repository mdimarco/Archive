#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>


#include "Stringlib.h"
#include "SysCallHandling.h"
#include "jobs.h"
#include "SignalStuff.h"


#define BUFSIZE 1024
#define FILENAME_SIZE 251
#define MY_PROMPT "33sh >>> "

void child_proc( char *[BUFSIZE],size_t );
ssize_t read_in(int, char [BUFSIZE], size_t);

pid_t Fork(void);
size_t split_args(char  [BUFSIZE], char **);

size_t check_redir(char *[256], size_t);
int check_for_mult_redir(char *[256], size_t);


job_list_t *ze_jobs; //JOB LIST
int next_jid = 1;
void reap_children( void );



int main() {

    char buf[BUFSIZE];
    ssize_t read_resp;
    //Initial buffer clear	
    for(size_t i = 0; i<BUFSIZE; i++){
		buf[i] = '\0';
	}

    ze_jobs = init_job_list();


    //call to signalstuff.c that sets up signal ignores for the parent process
    terminal_sig_setup();

    while( 1 ) {

	#ifdef PROMPT	
	write(STDOUT_FILENO, MY_PROMPT, strlen(MY_PROMPT));
	#endif

	read_resp = read(STDIN_FILENO, buf, BUFSIZE);

	if( read_resp > 0 ){

		//Reap the children! MWUAHAHAHAHAHA
		reap_children();
		//Trim the spaces
		
		char *new_buf = trim_spaces(buf);

		//Clear the arguments list
		char *argsv[256];
	    	for(int i = 0; i<256;i++){
		    argsv[i] = '\0';
	    	}
	
		//Tokenize and return numb args
	    	size_t num_tokens = split_args(new_buf, argsv);

		//Empty input
	   	 if(num_tokens == 0){
		    continue;
	    	 }

		//Returns 1 if sys call performed
		int called = handle_sys_call(argsv, num_tokens);
		if(called != 1){
			child_proc(argsv, num_tokens);
		}
	
		//Clear buffer
		for(size_t i = 0; i<BUFSIZE; i++){
			buf[i] = '\0';
		}

		
	}
	else if( read_resp < 0  ){
		perror("Error reading from standard in ");
	}
	else{
	
		break;
	}

    }
		
    cleanup_job_list(ze_jobs);
    return 0;
}


/*
fork wrapper with better
error handling
   */
pid_t Fork(void){
	pid_t pid;
	if((pid = fork()) < 0){
		char *errnote = "Fork Error\n";
		write(STDERR_FILENO, errnote, strlen(errnote));
		exit(0);
	}
	return pid;
}


void child_proc(char *argsv[256], size_t num_tokens){


	    //Check if we should make it a background process
	    int background = 0;
	    if( strcmp(argsv[num_tokens-1],"&") == 0 ){
		argsv[num_tokens-1] = NULL;
		num_tokens--;
		background = 1;
	    }

	    pid_t pid = Fork();
	    
	    
	    if( pid == 0){
		//Within child process, check for possible redirects
	        num_tokens = check_redir( argsv, num_tokens);
	
		argsv[num_tokens] = NULL;


		//Now set up the child's signals/group
		//(from signalstuff.c)
		child_sig_from_child();

		if(execv(argsv[0],argsv) == -1){
			perror("Execv");
		}
		exit(1);
	    }

	    
	    add_job( ze_jobs, next_jid++, pid, _STATE_RUNNING, argsv[0] );

	    //Give child its own process group
	    if( setpgid(pid, pid) < 0){
		perror("setpgid from parent error");
	    }

	    //Wait for child to finish before starting
	   if( !background ){

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
		int jid = get_job_jid( ze_jobs, kid_pid);
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
	
		//Background process
	   }else{
		char job_print[256];
	        int len = sprintf(job_print,"[%d] (%d)\n", next_jid-1, pid); 
		if(len == -1){
			perror("sprintf failed to print jobs\n");
		}
	        write(STDOUT_FILENO, job_print, (size_t)len);
           
	   }
				
	 	//Get terminal control back to parent
	   	if(tcsetpgrp(STDIN_FILENO, getpgrp()) < 0){
		   perror("Error getting terminal back after child\n");
		   exit(1);
		   }

	   
}

size_t split_args(char  buf[BUFSIZE], char **argsv ){
	size_t num_tokens = tokenize(buf, " \r\n\t\f\v",argsv);	
	return num_tokens;
	}


size_t check_redir( char *argsv[256], size_t num){
	size_t i=0;

	//helper function to check for multiple redirects
	int mult = check_for_mult_redir( argsv, num);
	if(mult == 1){
		char *err = "Error: Can not have more than one >, >>, or <\n";
		write(STDERR_FILENO, err, strlen(err));
		return 0;
	}

	while(i < num){
		if( strcmp(argsv[i], ">") == 0){
			if( i == (num-1)){
			  char *err = "Error: must provide output file\n";
			  write(STDERR_FILENO, err, strlen(err));
			  return 0;
			}

			char*outname = argsv[i+1];


			//does the actual file closing
			close(STDOUT_FILENO);
			if( open( outname, O_WRONLY|O_CREAT|O_TRUNC,
					       	S_IRUSR | S_IWUSR | S_IXUSR)
				       	== -1){
				char *errnote = "Error outputing to file.\n";
				write(STDERR_FILENO, errnote, strlen(errnote));
				exit(1);
			}

			num = remove_token(argsv,i,num);
			num = remove_token(argsv,i,num);
		}



		else if( strcmp(argsv[i], ">>") == 0 ){
			if( i == (num-1)){
			  char *err = "Error: must provide output file\n";
			  write(STDERR_FILENO, err, strlen(err));
			  return 0;
			}

			char* outname = argsv[i+1];


			//does the actual file closing
			close(STDOUT_FILENO);
			if( open( outname, O_WRONLY|O_APPEND|O_CREAT,
					       	S_IRUSR | S_IWUSR | S_IXUSR) == -1){
				char *errnote = "Error outputing to file1.\n";
				write(STDERR_FILENO, errnote, strlen(errnote));
				exit(1);
			}

			num = remove_token(argsv,i,num);
			num = remove_token(argsv,i,num);

		}
		else if( strcmp(argsv[i], "<") == 0){
			if( i == (num-1)){
			  char *err = "Error: must provide input file\n";
			  write(STDERR_FILENO, err, strlen(err));
			  return 0;
			}

			char* inname = argsv[i+1];

			//does the actual file closing
			close(STDIN_FILENO);
			if( open( inname, O_RDONLY) == -1){
				char *errnote = "Error getting file\n";
				write(STDERR_FILENO, errnote, strlen(errnote));
				exit(1);
			}

			num = remove_token(argsv,i,num);
			num = remove_token(argsv,i,num);
		}
		else{
			i++;
		}
	}

	return num;
}

//If multiple >, >>, or < are found, returns 1, else returns 0
int check_for_mult_redir( char **argsv, size_t n){
	int gt = 0;
	int lt = 0;
	for(size_t i = 0; i<n; i++){
		if( strcmp(argsv[i], ">") == 0){

			gt++;
		}
		if( strcmp(argsv[i], "<") == 0){
			lt++;
			
		}
		if( strcmp(argsv[i], ">>") == 0){
			gt++;
			
		}
	}
	if( gt >= 2){
		return 1;
	}
	if( lt >= 2){
		return 1;
	}
	
	return 0;
}	





//Actual children reaping
void reap_children( void ){
	pid_t kid_pid;
	int status;
	pid_t wait_ret;
	//Iterate through all jobs
	while( (kid_pid = get_next_pid(ze_jobs) ) != -1){
		

		//Set status
	    if( (wait_ret = waitpid( kid_pid, &status, WNOHANG | WUNTRACED | WCONTINUED ) ) == -1){
	            perror("waitpid failed on child process" );
		    exit(1);
		}
	    if( wait_ret == 0){
		continue;
	    }
	
	    int jid = get_job_jid( ze_jobs, kid_pid);

	    char message[256];
	    int len = 0;
	    if( WIFEXITED(status) ){
		len = sprintf(message,"[%d] (%d) terminated with exit status %d\n", jid, kid_pid, WEXITSTATUS(status));
		if( remove_job_pid(ze_jobs, kid_pid) == -1){
			char *errm = "Error removing child job from jobs list\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		}
	    }
	    if( WIFSIGNALED(status) ){
		len = sprintf(message,"[%d] (%d) terminated by signal %d\n", jid, kid_pid, WTERMSIG(status));
		if( remove_job_pid(ze_jobs, kid_pid) == -1){
			char *errm = "Error removing child job from jobs list\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		}
	    }
	    if( WIFSTOPPED(status) ){
		len = sprintf(message,"[%d] (%d) suspended by signal %d\n", jid, kid_pid, WSTOPSIG(status));
		if( update_job_pid(ze_jobs, kid_pid, _STATE_STOPPED ) == -1){
			char *errm = "Error marking job as stopped\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		}
	    }
	    if( WIFCONTINUED(status) ){
		len = sprintf(message,"[%d] (%d) resumed\n", jid, kid_pid);
		if( update_job_pid(ze_jobs, kid_pid, _STATE_RUNNING ) == -1){
			char *errm = "Error marking job as resumed\n";
			write(STDOUT_FILENO, errm, strlen(errm));
			exit(1);
		}
	    }

	    //Writing the actual status message
	    write(STDOUT_FILENO, message, (size_t)len);

	}	
}









