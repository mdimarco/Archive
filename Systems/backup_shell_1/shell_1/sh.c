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

void child_proc(ssize_t , char [BUFSIZE], const char *);
ssize_t read_in(int, char [BUFSIZE], size_t);

pid_t Fork(void);
size_t split_args(char  [BUFSIZE], char **);

void check_redirect(char *, char*[2] );


int main() {

    char buf[BUFSIZE];
    memset(buf,0,strlen(buf));

    ssize_t n;

    const char *note = "Write failed\n";

    while((n = read_in(STDIN_FILENO, buf, sizeof(buf))) > 0){

	

	printf("N %u\n", (unsigned int)n);
	for(ssize_t i = n; i<BUFSIZE; i++){
		buf[i] = ' ';
	}

	int called = handle_sys_call(buf);
	if(called != 1){
		child_proc(n, buf, note);
	}
	memset(buf,0,strlen(buf));

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
		fprintf(stderr, "fork error: %s\n", strerror(errno));
		exit(0);
	}
	return pid;
}

/*
  wrapper over system read function

   */
ssize_t read_in(int path, char buf[BUFSIZE], size_t buf_size){
	
	#ifdef PROMPT	
	write(1, MY_PROMPT, sizeof(MY_PROMPT));
	#else
	write(1, "\n", sizeof("\n"));
	#endif

	return read(path, buf, buf_size);
}

void child_proc(ssize_t n, char buf[BUFSIZE], const char *note){
	    if(!isprint(buf[0]) || buf[0] == '\0' || strlen(buf) == 0){
		return;
	    }
	    buf = trim_spaces(buf);

	    char *filenames[2];
	    filenames[0] = NULL;
	    filenames[1] = NULL;
	    check_redirect(buf, filenames);
	    

	    char *argsv[256];
	    size_t num_tokens = split_args(buf, argsv);

	    pid_t pid = Fork();
	    if( pid == 0){
		if( filenames[1] != NULL ){
			close(1);
			if( open( filenames[1], O_CREAT|O_WRONLY,S_IRWXU) == -1){
				printf("file open error\n");
				exit(1);
			}	
	   	 }
		argsv[num_tokens] = NULL;
		printf("EXEC Command %d\n", execv(argsv[0],argsv));
		printf("No such command:%s\n", argsv[0]);
		exit(1);
	    }

	    

	    while( wait(0) > 0)
	 	;


	    if( 0 && write(1, buf, (size_t)n) != n) {
		    (void)write(2, note, strlen(note) );
		    exit(1);
		   }
	    
}

size_t split_args(char  buf[BUFSIZE], char **argsv ){
	

	buf = trim_spaces(buf);
	
	
	size_t num_tokens = tokenize(buf, " \r\n\t\f\v",argsv);

	 
	
	return num_tokens;
	}


void check_redirect( char *buf, char *filename[2]){

	int numGT = 0;
	int numLT = 0;


	size_t len = strlen(buf);
	size_t i = 0;
	while( i < len ){
		if( buf[i] == '>'){
			if( numGT > 0){
				//TODO HANDLE ERROR multiple >
			}
			numGT = 1;
			buf[i] = ' ';
			//Case of >>
			if( (i < len -1) && (buf[i+1] == '>') ){
				buf[i+1] = ' ';
				i++; //increase	by one more to skip over next
			}
			
			while( (i <= (len-1)) && isspace(buf[i]) ){
				i++;
			}
			//Case of no output file
			if( i == len ){
				//TODO Handle error, no output file
			}
			
			//Now at output file
			int j = 0;
			char temp[255];
			while( (i <= len-1) && !isspace(buf[i]) ){
				temp[j] = buf[i];
				buf[i] = ' ';
				i++;
				j++;
			}
			filename[1] = temp;
			//printf("Filename len %u\n",(unsigned int) strlen(filename[1]));
		}
	
		if( buf[i] == '<'){	
			if( numLT > 0){
				//TODO HANDLE ERROR
			}
		}
		i++;
	}
}

