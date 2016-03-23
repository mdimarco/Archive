#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	    int fd;

	        if(2 != argc)
			    {
				            printf("\n Usage :  \n");
					            return 1;
						        }

		    errno = 0;
		        fd = open(argv[1],O_RDONLY|O_CREAT, S_IRWXU);

			    if(-1 == fd)
				        {
						        printf("\n open() failed with error [%s]\n",strerror(errno));
							        return 1;
								    }
			        else
					    {
						            printf("\n Open() Successful\n");
							            /* open() succeeded, now one can do read operations
								                  on the file opened since we opened it in read-only
										             mode. Also once done with processing, the file needs
											                to be closed. Closing a file can be achieved using
													           close() function. */
							        }

				    return 0;
}
