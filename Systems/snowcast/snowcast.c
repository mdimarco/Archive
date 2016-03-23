#include <inttypes.h>
#include <netdb.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <sys/un.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <ctype.h>

#define BUFFER_SIZE 1024

int open_tcp_fd(char *, int);
void say_hello(int, int);
void set_station(int, int);
void hear_welcome(int, uint8_t *, uint16_t *);
void handle_invalid_command( int );
int is_all_digits(char *, int);
int open_udp_fd(int);
int Write(int , void *, size_t );

int main(int argc, char **argv) {
    if( argc != 4){
       fprintf(stderr, "Correct Args: ./client  <hostname> <serverport> <udpport>\n");
	   return 1;
	}


	//Recovering arguments
    char *hostname = argv[1];
    int server_port = atoi(argv[2]);
    int udp_port = atoi(argv[3]);
    if(server_port < 1024 || udp_port < 1024)
    {
    	char *errm ="error, you port #'s must be >= 1024\n";
    	Write(STDERR_FILENO, errm, strlen(errm));
    	return 1;
    }

    //opening connection
    int tcp_fd = open_tcp_fd(hostname, server_port);


    //Saying hello to TCP
    say_hello(tcp_fd, udp_port);
    


    //Reading welcome from server
    uint8_t reply_type;
	uint16_t num_stations;
	hear_welcome( tcp_fd, &reply_type, &num_stations);
	num_stations = ntohs(num_stations);



	//Writing welcome to STDERR
	char welcome[80];
	memset(welcome, 0, 80);
	sprintf(welcome, 
		"Server sent welcome with reply type %d and # of stations %d\n", 
		(int)reply_type, (int)num_stations);

	Write(STDERR_FILENO, welcome, sizeof(welcome));


	//Setting the station
	set_station(tcp_fd, 0);
 

 	int udp_fd = open_udp_fd(udp_port);


    fd_set rd;
    while(1)
    {
    	char udp_buf[BUFFER_SIZE];
    	char tcp_buf[BUFFER_SIZE];
        char inp_buf[BUFFER_SIZE];
        for(int i = 0; i < BUFFER_SIZE; i++)
        {
            udp_buf[i] = '\0';
            inp_buf[i] = '\0';
        }
        FD_ZERO(&rd);

        FD_SET(tcp_fd, &rd);
        FD_SET(udp_fd, &rd);
        FD_SET(STDIN_FILENO, &rd);


        select(5, &rd, 0, 0, 0);


        if( FD_ISSET(tcp_fd, &rd))
        {
        	ssize_t readlen = read(tcp_fd, tcp_buf, BUFFER_SIZE);
        	if(readlen < 0)
        	{
        		perror("Read error");
        		return 1;
        	}
        	Write(STDERR_FILENO, tcp_buf, readlen);
        }

        if( FD_ISSET(udp_fd, &rd))
        {
        	ssize_t readlen = read(udp_fd, udp_buf, BUFFER_SIZE);
        	if(readlen < 0)
        	{
        		perror("Read error");
        		return 1;
        	}
        	Write(STDOUT_FILENO, udp_buf, readlen);
        }

        if( FD_ISSET(STDIN_FILENO, &rd))
        {
        	ssize_t readlen = read(STDIN_FILENO, inp_buf, BUFFER_SIZE);
        	inp_buf[readlen-1] = '\0';
        	if(readlen < 0)
        	{
        		perror("reading in stdin");
        		exit(1);
        	}
        	if(readlen > 1)
        	{
        		if( !strcmp(inp_buf, "q") || !strcmp(inp_buf, "quit") )
        		{
        			exit(1);
        		}
        		if( !is_all_digits(inp_buf, (int)(readlen-1)) )
        		{
        			char *errm="Invalid Command\n";
        			Write(STDERR_FILENO, errm, strlen(errm));
        		}
        		else
        		{
        			int station_no = atoi(inp_buf);
        			//might as well check it locally since I know how many
        			//stations there are already
        			if( station_no < 0) //could also check this but your specs seemed not to want it like that -> || station_no >= num_stations)
        			{
						char *errm="Invalid Station\n";
	        			Write(STDERR_FILENO, errm, strlen(errm));
      				    exit(1);

        			}
        			else
        			{
        				set_station(tcp_fd, station_no);
        			}
        		}
        	}
        }


    }
    close(udp_fd);
    close(tcp_fd);
    return 0;
}

//Specialized Write for my purposes that handles error check
//basically just a wrapper
int Write(int fd, void *message, size_t length)
{
	int ret_val = 0;
	if( (ret_val = write(fd, message, length)) < -1)
	{
		perror("Write erorr");
		exit(1);
	}
	return ret_val;
}


/*
	Input:  port number
	Output: file descriptor udp port is bound to
	
	gets all of the one way udp goodness
*/
int open_udp_fd( int port)
{

	struct sockaddr_in myaddr;
	int fd;


	//make udp socked
	if((fd = socket(AF_INET, SOCK_DGRAM, 0)) <0)
	{
		perror("Error making udp socket");
		return -1;
	}

	memset((char *)&myaddr, 0, sizeof(myaddr));
	myaddr.sin_family = AF_INET;
	myaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	myaddr.sin_port = htons(port);

	//bind socket to wildcard address
	if( bind(fd, (struct sockaddr *)&myaddr, sizeof(myaddr)) < 0)
	{
		perror("Error binding udp socket");
		return -1;
	}
	return fd;

}




//iterates through every character in the sting to see
//if every element is a digit
int is_all_digits(char *inp_string, int str_len)
{
	for(int i =0; i<str_len; i++)
	{
		if( !isdigit(inp_string[i]))
		{
			return 0;
		}
	}
	return 1;
}


//Send Hello message to the server's port #
//Sends a 0 command message to alert server of client's presence
//Sends a udp_port to the server that will be used for data streaming
void say_hello(int client_fd, int udp_port){
    uint8_t command_type = 0;
    uint16_t udp_port_struct = htons(udp_port);
    Write(client_fd, &command_type, sizeof(command_type));
    Write(client_fd, &udp_port_struct, sizeof(udp_port_struct));

}


//Send the server the station you would like to listen to
void set_station(int client_fd, int station_no){


	//BEGIN REQUEST
	//#############
	//#############
	//#############
	uint8_t command_type = 1;
	uint16_t station_number = htons(station_no);
	Write( client_fd, &command_type, sizeof(command_type));
	Write( client_fd, &station_number, sizeof(station_number));
	//#############
	//#############
	//#############
	//END REQUEST


	//BEGIN RESPONSE
	//#############
	//#############
	uint8_t reply_type;
	uint8_t song_name_size;
	if(read(client_fd, &reply_type, sizeof(reply_type)) != sizeof(reply_type))
	{
		perror("Set station reply_type error");
		exit(1);
	}

	//Handling reply_type error
	if( (int)reply_type == 2 )
	{
		handle_invalid_command(client_fd);
	}

	if(read(client_fd, &song_name_size, sizeof(song_name_size)) 
		!= sizeof(song_name_size))
	{
		perror("Set station song_name_size error");
		exit(1);
	}

	char songname[song_name_size];
	for(int i = 0; i<song_name_size; i++)
	{
		songname[i] = '\0';
	}
	if(read(client_fd, songname, song_name_size) != song_name_size)
	{
		perror("Set station song_name error");
		exit(1);
	}



	//#############
	//#############
	//END RESPONSE


	char reply_message[80];
	//memset(reply_message,0,80);

	sprintf(reply_message, 
		"Got reply type %d and song name size %d\n",
		(int)reply_type, (int)song_name_size);
	Write(STDERR_FILENO, reply_message, strlen(reply_message));
	Write(STDERR_FILENO, songname, song_name_size);
	Write(STDERR_FILENO, "\n", sizeof("\n"));	
}



//Receive welcome message from the TCP port
//Recieves a reply type and the number of stations the server has
void hear_welcome(int client_fd, uint8_t* reply_type, uint16_t *num_stations ){
	if(read(client_fd, reply_type, sizeof(uint8_t)) != sizeof(uint8_t))
	{
		char *errm = "TCP welcome error: reply_type\n";
		Write(STDERR_FILENO,errm,strlen(errm));
	};

	if( (int)(*reply_type) == 2 )
	{
		handle_invalid_command(client_fd);
	}


	if(read(client_fd, num_stations, sizeof(uint16_t)) != sizeof(uint16_t))
	{
		char *errm = "TCP welcome error: num_stations\n";
		Write(STDERR_FILENO,errm,strlen(errm));
	}

}


//Handles the response from the server if an incorrect command has been entered
void handle_invalid_command( int client_fd )
{
	uint8_t reply_string_size;
	if( read(client_fd, &reply_string_size, sizeof(uint8_t)) <= 0)
	{
		char *errm = "Error handling invalid command: reading string size\n";
		Write(STDERR_FILENO, errm, strlen(errm));
		exit(1);
	}
	char reply_string[reply_string_size];
	if( read(client_fd, reply_string, reply_string_size) != reply_string_size )
	{
		char *errm = "Error handling invalid command: reading string\n";
		Write(STDERR_FILENO, errm, strlen(errm));
		exit(1);
	}
	Write(STDERR_FILENO, reply_string, reply_string_size);
	exit(1);

}


//Connects the client to the server via the server's hostname
//and the port that the server is currently listening to
int open_tcp_fd(char *hostname, int port){
	int clientfd;
	struct hostent *hp;
	struct sockaddr_in serveraddr;


	//Create client filedescripter for socket
	if((clientfd = socket(AF_INET, SOCK_STREAM,0)) <0){
		perror("Socket: ");
		return -1;
	}

	//get host's info
	if((hp = gethostbyname(hostname)) == NULL){
		perror("Get host by name ");
		return -2;
	}

	//Copy over host's info to server
	bzero((char *) &serveraddr, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	bcopy((char *)hp->h_addr_list[0],
		  (char *)&serveraddr.sin_addr.s_addr,
		  hp->h_length);
	serveraddr.sin_port = htons(port);

	//Establish connection to file descriptor
	if( connect(clientfd, (const struct sockaddr *)&serveraddr, sizeof(serveraddr))){
		perror("Error connecting to server ");
		return -1;
	}

	return clientfd;

}
