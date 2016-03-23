#include "SysCallHandling.h"
#include "Stringlib.h"
#include <string.h>
#include <ctype.h>
#include <unistd.h>

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

