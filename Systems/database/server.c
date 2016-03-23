#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <pthread.h>

#include "window.h"
#include "io_functions.h"
#include "db.h"
#include "timeout.h"

#define BUFSIZE 128



/* Struct encapsulating information about a client */
typedef struct Client {
	Window *window;  // The client window
	Timeout *timeout;
	pthread_t thread;
	int id;
} Client;


/******************************
 * LINKED LIST Declarations
 ******************************/

// Element in a linked list
typedef struct list_ele {
	int val;
    struct list_ele *next;
    pthread_t thread; //The client's thread
    pthread_mutex_t lock;
    Client *client;
} list_ele_t;


//adds with an id and associated thread
//These are here to keep consistancy with linked list block
void client_list_add(  int , Client *); 
void client_list_remove( int );
void delete_client_list( void );
/******************************
 * END LINKED LIST DECLARATIONS
 ******************************/
list_ele_t clients_head; 



// Global variables
Database *db;
char *scriptname;

//For the active threads
int active_threads;
int client_id;
pthread_mutex_t active_thread_mut;
pthread_cond_t active_thread_cond;
//End active threads

//Stop-Go cond mutex
int is_stopped;
pthread_mutex_t stop_go_mutex;
pthread_cond_t stop_go_cond;
//End stop-go cond mutex


//Sigint stuff
pthread_t sigint_thread;
//End sigint stuff

//Timeout global
int timeout_time;
//End timeout stuff


/*********************************************
 * FORWARD DECLARATIONS
 *********************************************/
Client *client_new( int );
void client_delete(Client *client);
void *run_client(void *client);
void process_command(char *command, char *response);



//Signal Handlers
void signals_setup(void);
int install_handler(int sig, void (*handler)(int));
void *sigint_handler(void *sig);
//End signal handlers


//Error-safe pthreads
void Pthread_create(pthread_t *, const pthread_attr_t *, void *(*) (void *), void *);
void Pthread_detach(pthread_t);
void Pthread_cancel(pthread_t);

void Pthread_mutex_init(pthread_mutex_t *, const pthread_mutexattr_t *);
void Pthread_mutex_destroy(pthread_mutex_t *);
void Pthread_mutex_lock(pthread_mutex_t *); 
void Pthread_mutex_unlock(pthread_mutex_t *);

void Pthread_cond_init(pthread_cond_t *,const pthread_condattr_t *);
void Pthread_cond_broadcast(pthread_cond_t *);
void Pthread_cond_wait(pthread_cond_t *, pthread_mutex_t*);
void Pthread_cond_destroy(pthread_cond_t *);
//End erorr-safe pthreads


//Begin Thread Cancelling functions
void cancel_threads(void);
void cleanup_pthread_mutex_unlock(void *);
void cleanup_client_list_remove(void *);
//End Thread Cancelling functions

//Client Timeout
void client_timeout(void *);

/*********************************************
 * END FORWARD DECLARATIONS
 *********************************************/





/***********************************
 * Main function
 ***********************************/

void run_server() {
    char buf[BUFSIZE];
    char response[BUFSIZE];



    //################
    //Active Threads
    active_threads = 0;
    Pthread_mutex_init(&active_thread_mut, NULL);
    Pthread_cond_init(&active_thread_cond, NULL);
    //End Active Threads
    //################



    //################
    //Stop-Go
    is_stopped = 0;
    Pthread_mutex_init(&stop_go_mutex, NULL);
    Pthread_cond_init(&stop_go_cond, NULL);
    //End Stop-Go
    //################


	//################
	//Keeping track of le'clients
    Pthread_mutex_init(&(&clients_head)->lock, NULL);
    (&clients_head)->next = NULL;
    (&clients_head)->client = NULL;
    (&clients_head)->val = -1;
    client_id = 0;
    //################


    while (fgets(buf, BUFSIZE, stdin)) {
        /* remove trailing newline */
        int len = strlen(buf);
        if (len > 0 && buf[len - 1] == '\n') {
            len--;
            buf[len] = 0;
        }

        switch (buf[0]) {
            case 'q':
            case 'a':
            case 'd':
            case 'p':
            case 'f':
                /* any of these letters is a client command */
                process_command(buf, response);
                printf("%s\n", response);
                break;

			case 's':
				Pthread_mutex_lock( &stop_go_mutex );
				printf("Stop Dog Stop!\n");
				is_stopped = 1;
				Pthread_cond_broadcast( &stop_go_cond );
				Pthread_mutex_unlock( &stop_go_mutex );
				break;

			case 'g':
				Pthread_mutex_lock( &stop_go_mutex );
				printf("Go Dog Go!\n");
				is_stopped = 0;
				Pthread_cond_broadcast( &stop_go_cond );
				Pthread_mutex_unlock( &stop_go_mutex );
				break;

			case 0: //Handlin newline which fgets treats as null

				//Mutex Put here so that client id's remain unique
				Pthread_mutex_lock( &active_thread_mut );
				printf("Adding client\n");
				client_new(client_id++);
				Pthread_mutex_unlock( &active_thread_mut);

				break;

			case 'w':
				Pthread_mutex_lock( &active_thread_mut );
				while( active_threads )
				{
					Pthread_cond_wait(&active_thread_cond, &active_thread_mut);
				}
				Pthread_mutex_unlock( &active_thread_mut);
				break;

           	default:
                printf("%s\n", "invalid command");
        }
    }
	
	if(ferror(stdin))
		perror("fgets");

}

int main(int argc, char **argv) {
	

	if(argc == 2 || argc == 3) {

		timeout_time = strtol(argv[1], NULL, 10);
		if(timeout_time <= 0)
		{
			fprintf(stderr, "Timeout must be a positive number\n");
			exit(1);
		}

		if(argc == 3)
		{
			int len = strlen(argv[2]);
			scriptname = malloc(len+1);
			strncpy(scriptname, argv[2], len+1);
		}
		else
		{
			scriptname = NULL;
		}

	}else {
		fprintf(stderr, "Usage: %s timeout [scriptname]\n", argv[0]);
		exit(1);
	}
	printf("Timeout: %d\n", timeout_time);

	//Begin SIGINT handling
	sigset_t full;
	sigemptyset(&full);
	sigaddset(&full, SIGINT);
	// Ignore signals while installing handlers
	pthread_sigmask(SIG_BLOCK, &full, NULL);


	Pthread_create(&sigint_thread, NULL, sigint_handler, (void *)&full);
	Pthread_detach(sigint_thread);
	//End SIGINT handling




	// Ignore SIGPIPE
	struct sigaction ign;
	ign.sa_handler = SIG_IGN;
	sigemptyset(&ign.sa_mask);
	ign.sa_flags = SA_RESTART;
	sigaction(SIGPIPE, &ign, NULL);

	db = db_new();
    
    // Run main server loop
    run_server();

	// Cleanup and exit
	fprintf(stderr, "Quitting\n");

	//Mark all threads on linked list as cancelled
	cancel_threads();
	printf("Threads cancellled\n");

	db_delete(db);
	free(scriptname);


	//*******************
	//BEGIN SLEEP UNTIL ALL THREADS GONE
	//*******************
	Pthread_mutex_lock( &active_thread_mut );

	while( active_threads )
	{
		Pthread_cond_wait(&active_thread_cond, &active_thread_mut);
	}

	Pthread_mutex_unlock( &active_thread_mut);
	//*******************
	//END SLEEP UNTIL ALL THREADS GONE
	//*******************

	//End the sigint handling
	Pthread_cancel(sigint_thread);


	//Make sure threads are finished off
	delete_client_list();
	printf("Client list deleted\n");


	//Destroy Stop-Go Threads Mutex/Cond
	Pthread_mutex_destroy( &stop_go_mutex);
	Pthread_cond_destroy( &stop_go_cond);
	//End Stop-Go Threads Mutex/Cond

	//Destroy Active Threads Mutex
	Pthread_mutex_destroy( &active_thread_mut);
	Pthread_cond_destroy(  &active_thread_cond);
	//End Destroy Active Threads Mutex


	pthread_exit( NULL );

}

/***********************************
 * Client handling functions
 ***********************************/

/* Create a new client */
Client *client_new( int id ) {
	Client *client = (Client *)malloc(sizeof(Client));
	client->id = id;
	if(!client) {
		perror("malloc");
		return NULL;
	}
	// Create a window and set up a communication channel with it
	char title[20];
	sprintf(title, "Client %d", id);
	int errnum;
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL)) )
	{
		fprintf(stderr, "Error stopping pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}
	if(!(client->window = window_new(title, scriptname))) {
		free(client);
		return NULL;
	}
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL)) )
	{
		fprintf(stderr, "Error renabling pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}

	active_threads++; //ACTIVE THREADS MUTEX LOCKED OUTSIDE OF CLIENT_NEW

	//Add the client's timeout
	client->timeout = timeout_new(timeout_time, client_timeout, (void *) &(client->thread));

	Pthread_create(&(client->thread), 0, run_client, client);
	Pthread_detach(client->thread);

	client_list_add(id, client);


	return client;
}

/* Delete a client and all associated resources */
void client_delete(Client *client) {

	//remove active thread
	Pthread_mutex_lock( &active_thread_mut );
	active_threads--;
	Pthread_cond_broadcast( &active_thread_cond );
	Pthread_mutex_unlock( &active_thread_mut );

	//Prohibit cancellation
	int errnum;
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL)) )
	{
		fprintf(stderr, "Error stopping pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}

	//Cleaning up the timeout info
	timeout_deactivate(client->timeout);
	timeout_delete(client->timeout);

	window_delete(client->window);
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL)) )
	{
		fprintf(stderr, "Error renabling pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}
	//End Prohibit Cancellation
	free(client);
}

/* Function executed for a given client */
void *run_client(void *args) {
	Client *client = (Client *)args;
	char command[BUF_LEN];
	char response[BUF_LEN];
	//Just incase client is cancelled during one of these points
	pthread_cleanup_push( cleanup_client_list_remove, (void *)(&(client->id)));

	//Start client timer
	timeout_activate(client->timeout);

	
	// Main loop of the client: fetch commands from window, interpret
	// and handle them, and send results to window.
	while(get_command(client->window, command)) {

		//Start the clock over again
		timeout_activate(client->timeout);


		//################
		//BEGIN STOP-GO CHECK
		Pthread_mutex_lock(&stop_go_mutex);
		//cleanup mutex lock
		pthread_cleanup_push( cleanup_pthread_mutex_unlock, (void *)(&stop_go_mutex));
		while( is_stopped )
		{
			Pthread_cond_wait( &stop_go_cond, &stop_go_mutex);
		}
		//Unlock regardless
		pthread_cleanup_pop(1);

		//END STOP-GO CHECK
	    //################

		process_command(command, response);
		if(!send_response(client->window, response))
			break;

	}
	//This should have the cleanup_client_list_remove function in it
	//meaning regardless of if the client get's cancelled it will still
	//remove the client
	pthread_cleanup_pop(1);

	return args;
}

/***********************************
 * Command processing functions
 ***********************************/

char *skip_ws(char *str);
char *skip_nonws(char *str);
void next_word(char **curr, char **next);

/* Process the given command and produce an appropriate response */
void process_command(char *command, char *response) {


	int errnum;
	//Stopping cancellations from hurting my db functions
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL)) )
	{
		fprintf(stderr, "Error stopping pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}

	char *curr;
	char *next = command;
	next_word(&curr, &next);

	if(!*curr) {
		strcpy(response, "no command");
	} else if(!strcmp(curr, "a")) {
		next_word(&curr, &next);
		char *name = curr;
		next_word(&curr, &next);

		if(!*curr || *(skip_ws(next))) {
			strcpy(response, "ill-formed command");
		} else if(db_add(db, name, curr)) {
			strcpy(response, "added");
		} else {
			strcpy(response, "already in database");
		}
	} else if(!strcmp(curr, "q")) {
		next_word(&curr, &next);

		if(!*curr || *(skip_ws(next))) {
			strcpy(response, "ill-formed command");
		} else if(!db_query(db, curr, response, BUF_LEN)) {
			strcpy(response, "not in database");
		}
	} else if(!strcmp(curr, "d")) {
		next_word(&curr, &next);

		if(!*curr || *(skip_ws(next))) {
			strcpy(response, "ill-formed command");
		} else if(db_remove(db, curr)) {
			strcpy(response, "deleted");
		} else {
			strcpy(response, "not in database");
		}
	} else if(!strcmp(curr, "p")) {
		next_word(&curr, &next);

		if(!*curr || *(skip_ws(next))) {
			strcpy(response, "ill-formed command");
		} else {
			FILE *foutput = fopen(curr, "w");
			if (foutput) {
				db_print(db, foutput);
				fclose(foutput);
				strcpy(response, "done");
			} else {
				strcpy(response, "could not open file");
			}
		}
	} else if(!strcmp(curr, "f")) {
		next_word(&curr, &next);

		if(!*curr || *(skip_ws(next))) {
			strcpy(response, "ill-formed command");
		} else {
			FILE *finput = fopen(curr, "r");
			if(finput) {
				while(fgets(command, BUF_LEN, finput) != 0)
					process_command(command, response);

				fclose(finput);

				strcpy(response, "file processed");
			} else {
				strcpy(response, "could not open file");
			}
		}
	} else {
		strcpy(response, "invalid command");
	}

	//Db functions done. is ok now
	if( (errnum = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL)) )
	{
		fprintf(stderr, "Error renabling pthread_cancellation %s\n", strerror(errnum));
		exit(1);
	}
}

/* Advance pointer until first non-whitespace character */
char *skip_ws(char *str) {
	while(isspace(*str))
		str++;
	return str;
}

/* Advance pointer until first whitespace or null character */
char *skip_nonws(char *str) {
	while(*str && !(isspace(*str)))
		str++;
	return str;
}

/* Advance to the next word and null-terminate */
void next_word(char **curr, char **next) {
	*curr = skip_ws(*next);
	*next = skip_nonws(*curr);
	if(**next) {
		**next = 0;
		(*next)++;
	}
}



//Handler for sigint that marks
//all threads for cancellation
void *sigint_handler(void *info)
{
	sigset_t sig_stuff = *(sigset_t *) info;
	int sig = SIGINT;

	//This will end once the thread is cancelled by the server
	while( 1 ){
		sigwait(&sig_stuff, &sig);
		printf("ancelling threads.\n");
		//*******************
		//CANCELLING THREADS
		//*******************
		list_ele_t *current = (&clients_head)->next;
		list_ele_t *temp;
		while( current != NULL )
		{
			Pthread_cancel( current->client->thread );
			temp = current->next;
			current = temp;
		}
		//*******************
		//END CANCELLING THREADS
		//*******************
	}
	return info;
}



/******************************
 * CLEANUP IMPLEMENTATION
 ******************************/

void cleanup_pthread_mutex_unlock(void *arg){
	pthread_mutex_t *lock = (pthread_mutex_t *)arg;
	Pthread_mutex_unlock( lock );
}

void cleanup_client_list_remove(void *arg){
	int id = *((int *) arg);
	client_list_remove(id);
}


/******************************
 * END CLEANUP IMPLEMENTATION
 ******************************/





/************************************************************
 * LINKED LIST IMPLEMENTATION
 ************************************************************/


// Searches the linked list for a node with the given value
list_ele_t *search(int val, list_ele_t **parentp) {
	// called with head locked.
	// returns with parent locked and found item (if any) locked
	
	list_ele_t *par = &clients_head;
	list_ele_t *ele = clients_head.next;
	
	if(ele != 0)
	{
		Pthread_mutex_lock(&ele->lock);
	}
	
	while (ele != 0) {
		// par is locked
		
		if (val <= ele->val) {
			// If the value was found
			*parentp = par;
			if (val == ele->val) {
				// ele stays locked
				return ele;
			} else {
				// Unlock the element since we didn't find anything
				Pthread_mutex_unlock(&ele->lock);
				return 0;
			}
		}
		*parentp = par;
		
		par = ele;
		ele = ele->next;
		
		// Lock the new element
		if(ele != 0)
		{
			Pthread_mutex_lock(&ele->lock);
		}
		
		// Unlock the old parent
		Pthread_mutex_unlock(&((*parentp)->lock));
	}
	
	// Nothing found. Return the locked parent in the passed pointer
	
	*parentp = par;
	return 0;
}

// Inserts an element into the list if it is not already in the list
void client_list_add(int val, Client *client) {
	list_ele_t *found = NULL;
	list_ele_t *parent = NULL;
	list_ele_t *newItem = NULL;
	
	// Lock the head
	Pthread_mutex_lock(&(clients_head.lock));
	
	if ((found = search(val, &parent)) != 0) {
		Pthread_mutex_unlock(&(parent->lock));
		Pthread_mutex_unlock(&(found->lock));
		return;
	}
	
	// val is not in the list -- add it
	if ((newItem = (list_ele_t *)malloc(sizeof(list_ele_t))) == 0) {
		fprintf(stderr, "out of memory\n");
		exit(1);
	}
	
	// Parent is already locked by search
	
	// Add the info to the new element
	newItem->val = val;
	newItem->client = client;
	// Init the mutex
	Pthread_mutex_init(&(newItem->lock), NULL);

	
	// Insert the element into the list
	newItem->next = parent->next;
	parent->next = newItem;
	
	Pthread_mutex_unlock(&(parent->lock));
	// Unlock the parent and next element
	if(newItem->next != NULL)
	{
		Pthread_mutex_unlock(&(newItem->next->lock));
	}
	return;
}

// Deletes an element from the list
void client_list_remove(int val) {
	list_ele_t *parent = NULL;
	list_ele_t *oldItem = NULL;
	// Lock the head
	Pthread_mutex_lock(&(clients_head.lock));

	//Find item
	if ((oldItem = search(val, &parent)) == 0) {
		Pthread_mutex_unlock(&(parent->lock));
		if(parent->next != NULL)
		{
			Pthread_mutex_unlock(&(parent->next->lock));
		}
		return;
	}
	// Parent is already locked by search
	
	// val was in the list -- remove it
	parent->next = oldItem->next;
	
	// Delete the client struct
	if(oldItem->client != NULL)
	{
		client_delete(oldItem->client);
	}

	Pthread_mutex_unlock(&(oldItem->lock));
	free(oldItem);
	Pthread_mutex_unlock(&(parent->lock));
	return;
}


/************************************************************
 * END LINKED LIST IMPLEMENTATION
 ************************************************************/




//Deletes all clients that are remaining in the list
//Then deletes the head of the list
void delete_client_list( void )
{
	list_ele_t *next = clients_head.next;
	while( next != NULL)
	{
		client_list_remove(next->client->id);
		next = clients_head.next;
	}
	Pthread_mutex_destroy(&(clients_head.lock));

}


//*******************
//CANCELLING THREADS
//*******************
void cancel_threads(void)
{
	list_ele_t *current = (&clients_head)->next;
	list_ele_t *temp;
	while( current != NULL )
	{
		temp = current->next;
		Pthread_cancel( current->client->thread );
		client_list_remove(current->client->id);
		current = temp;
	}
}
//*******************
//END CANCELLING THREADS
//*******************


//*******************
//TIMEOUT FUNCTIONS
//*******************

//Client timedout MARKING FOR CANCEL
void client_timeout(void *client_thread)
{

	//################
	//BEGIN STOP-GO CHECK
	Pthread_mutex_lock(&stop_go_mutex);
	//cleanup mutex lock
	pthread_cleanup_push( cleanup_pthread_mutex_unlock, (void *)(&stop_go_mutex));
	while( is_stopped )
	{
		Pthread_cond_wait( &stop_go_cond, &stop_go_mutex);
	}
	//Unlock regardless
	pthread_cleanup_pop(1);

	//END STOP-GO CHECK
    //################

	Pthread_cancel( *((pthread_t *)client_thread) );
}


//*******************
//END TIMEOUT FUNCTIONS
//*******************

