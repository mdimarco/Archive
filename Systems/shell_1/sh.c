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

#define BUFSIZE 1024
#define FILENAME_SIZE 251
#define MY_PROMPT "33sh >>> "

void child_proc( char *[BUFSIZE],size_t );
ssize_t read_in(int, char [BUFSIZE], size_t);

pid_t Fork(void);
size_t split_args(char  [BUFSIZE], char **);

size_t check_redir(char *[256], size_t);
int check_for_mult_redir(char *[256], size_t);


int main() {

    char buf[BUFSIZE];

    ssize_t n;

    //Initial buffer clear	
    for(size_t i = 0; i<BUFSIZE; i++){
		buf[i] = '\0';
	}

    while( 1) {

	#ifdef PROMPT	
	write(STDOUT_FILENO, MY_PROMPT, strlen(MY_PROMPT));
	#endif

	if( (n = read(STDIN_FILENO, buf, BUFSIZE) > 0) ){
		
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
	else{
		break;
	}

    }

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
	    
	    pid_t pid = Fork();
	    if( pid == 0){
		//Within child process, check for possible redirects
	        num_tokens = check_redir( argsv, num_tokens);
	
		argsv[num_tokens] = NULL;
		if(execv(argsv[0],argsv) == -1){
			char *errnote = "Incorrect Command\n";
			write(2, errnote, strlen(errnote));
		}
		exit(1);
	    }

	   //Wait for child to finish before starting
	   //Next command
	   wait(0); 

}

size_t split_args(char  buf[BUFSIZE], char **argsv ){
	size_t num_tokens = tokenize(buf, " \r\n\t\f\v",argsv);
	
	return num_tokens;
	}


size_t check_redir( char *argsv[256], size_t num){
	size_t i =0;

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


