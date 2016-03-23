#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
    if(argc!=3){
        printf("Usage: mmap <source filepath> <destination file path>\n");
        exit(1);
    }

    char *src_fn = argv[1];
    char *dst_fn = argv[2];

    int src_fd = open( src_fn, O_RDONLY );
    int dst_fd = open( dst_fn, O_CREAT | O_RDWR | O_TRUNC, 0666);
    off_t src_size = lseek(src_fd,(size_t)0, SEEK_END);

    if( ftruncate( dst_fd, src_size) < 0){
    	perror("ftrunc");
    }



    void *src = mmap( NULL, src_size, PROT_READ, MAP_SHARED, src_fd, 0);
    void *dst = mmap( NULL, src_size, PROT_READ | PROT_WRITE, MAP_SHARED, dst_fd, 0);
    
    memcpy( dst, src, src_size );
    
    munmap( src, src_size );
    munmap( dst, src_size );
    /*  TODO:
        1. Get file descriptors to the file paths passed to the program.
        2. Find the size of source file.
        3. Make the destination file is the same size as source file.
        4. Map virtual addresses to source and destination file descriptors.
        5. Copy pages from source to destination addresses.
        6. Unmap virtual addresses and close file descriptors.
    */


    return 0; 
}        	
