#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#define MAX(a, b) (a > b ? a : b)

#define BUFFER_SIZE 1024
#define READ_INDEX 0
#define WRITE_INDEX 1

#define STDOUT_COLOR "\x1B[32m" /* encoding for green */
#define STDERR_COLOR "\x1B[31m" /* encoding for red */
#define DEFAULT_COLOR "\x1B[0m" /* color reset */

/* print a line of the child process' output stream */
void print_output(char *output) {
    printf("%s%s%s", STDOUT_COLOR, output, DEFAULT_COLOR);
    fflush(stdout);
}

/* print a line of the child process' error stream */
void print_error(char *error) {
    fprintf(stderr, "%s%s%s", STDERR_COLOR, error, DEFAULT_COLOR);
    fflush(stderr);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <executable> [args ...]\n", argv[0]);
        return 1;
    }
    
    /* create pipes to child process */
    /* TODO: use pipe()! */
    int in_pipe[2];
    if( pipe(in_pipe) ){
        perror("in pipe failed");
        exit(1);
    }

    int out_pipe[2];
    if( pipe(out_pipe) ){
        perror("out pipe failed");
    }


    int err_pipe[2];
    if( pipe(err_pipe)){
        perror("Error pipe failed");
        exit(1);
    }


    /* fork off child process */
    pid_t child_id = fork();
    if (!child_id) {

        /* redirect file descriptors */
        /* TODO: use dup2() to redirect input and output streams.
           Note: it is good practice to close file descriptors that will not be used. */

        /* exec the other arguments to this process */
        dup2(in_pipe[0], STDIN_FILENO);
        close(in_pipe[1]);

        dup2(out_pipe[1], STDOUT_FILENO);
        close(out_pipe[0]);

        dup2(err_pipe[1], STDERR_FILENO);
        close(err_pipe[0]);

        execvp(argv[1], argv + 1);

        fprintf(stderr, "Could not execute %s: %s\n", argv[1], strerror(errno));
        return 1;
    }

    /* parent process */
    else if (child_id < 0) {
        perror("could not fork");
        return 1;
    }

    
    /* write an event loop */
    /* TODO: use fd_set macros and loop over select.  Careful - select mutates its fd_set inputs!
       Check each file descriptor and if there's something to read, read it!
       - stdin should be forwarded to the child process using the pipe.
       - the child's stdout should be printed with print_output.
       - the child's stderr should be printed with print_error.
       If stdin or the child process' input stream closes (read returns 0), break out of the loop. */

    fd_set rd;

    while( 1 ){
        char buffer[BUFFER_SIZE];
	int i;
        for(i = 0; i < BUFFER_SIZE; i++)
        {
            buffer[i] = '\0';
        }

        FD_ZERO(&rd);


        FD_SET(out_pipe[0], &rd); 
        FD_SET(err_pipe[0], &rd);
        FD_SET(STDIN_FILENO, &rd);
        //FD_SET(in_pipe[1], &rd);

        select(10, &rd, 0, 0, 0);
        if( FD_ISSET(out_pipe[0], &rd))
        {
            read( out_pipe[0], buffer, BUFFER_SIZE);
            print_output( buffer );
        }
        if( FD_ISSET(err_pipe[0], &rd))
        {
            read( err_pipe[0], buffer, BUFFER_SIZE);
            print_error( buffer );
        }
        if( FD_ISSET(STDIN_FILENO, &rd))
        {
            int merplen = read(STDIN_FILENO, buffer, BUFFER_SIZE );
            if( merplen == 0)
            {
                break;
            }
            write( in_pipe[1], buffer, BUFFER_SIZE );
        }

    }

    /* close pipe file descriptors before exiting */
    close(in_pipe[0]);
    close(in_pipe[1]);
    close(out_pipe[0]);
    close(out_pipe[1]);
    close(err_pipe[0]);
    close(err_pipe[1]);
    return 0;
}
