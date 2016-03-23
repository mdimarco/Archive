#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

ssize_t __real_read(int fd, void *buf, size_t count);

ssize_t __wrap_read(int fd, void *buf, size_t count){



	

	ssize_t ret =  __real_read(fd, buf, count);
	if( ret < 0){
		char *errm = "Read error\n";
		write(STDOUT_FILENO, errm, strlen(errm));	
	}
	return ret;
}

ssize_t __real_write( int fd, void*buf, size_t count );

ssize_t __wrap_write( int fd, void *buf, size_t count ){
	ssize_t ret = __real_write(fd, buf, count);
	if( ret < 0){
		char *errm = "Write error\n";
		write(STDOUT_FILENO, errm, strlen(errm));
	}
	return ret;
}
