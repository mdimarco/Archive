#include "SysCallHandling.h"
#include "Stringlib.h"
#include <string.h>
#include <ctype.h>
#include <unistd.h>

//Stuff for cd and rm and ln
int handle_sys_call(char * buf){

	char *argsv[255];
	trim_spaces(buf);
	size_t num_tokens = tokenize(buf, " \r\n\t\f\v", argsv);
	printf("Tokens: %u\n", (unsigned int)num_tokens);
	if(num_tokens == 0){
		return 0;
	}

	int called = 0;

	if( strcmp(argsv[0], "cd") == 0 ){
		handle_cd( argsv );
		called++;
	}
	if( strcmp(argsv[0], "rm") == 0){
		handle_rm( argsv );
		called++;
	}
	if( strcmp(argsv[0], "ln") == 0){
		handle_ln( argsv );
	}
	if( strcmp(argsv[0], "exit") == 0){
		exit(1);
	}

	return called;
}


void handle_cd( char *argsv[255]){
	if( chdir(argsv[1]) == -1){
		char *errnote = "Error: Incorrect directory\n";
		write(2, errnote, strlen(errnote) );
	}
	else{
	    printf("Directory change successful");
	}
}

void handle_rm( char *argsv[255]){
	if( unlink(argsv[1]) == -1){
		char *errnote = "Error: Incorrect directory\n";
		write(2, errnote, strlen(errnote));
	}

}

void handle_ln( char *argsv[255]){
	if(argsv[1]){
	}

}

