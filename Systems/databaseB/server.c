#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <pthread.h>

#include "window.h"
#include "io_functions.h"
#include "db.h"

#define BUFSIZE 128



/******************************
 * LINKED LIST Declarations
 ******************************/

typedef struct LinkedList LinkedList;

/* A ListNode is a node in a singly-linked list */
typedef struct ListNode ListNode;
struct ListNode {
	void *value;
	ListNode *next;
};

struct LinkedList{
    int (*equals)(void *, void *);  // Function to compare two elements for equality
    void (*delete)(void *);  // Function to delete an element

	ListNode *head;  // The first element (remember to update)
    int size;  // The number of elements in the list (remember to update)
};

/* Create a new linkedlist with the given element functions and return it */
LinkedList *linkedlist_new(int (*equals)(void *, void *),
					 void (*delete)(void *));


/* Linkedlist Modification Functiones */
void linkedlist_delete(LinkedList *linkedlist);
void linkedlist_append(LinkedList *linkedlist, void *element);
int linkedlist_contains(LinkedList *linkedlist, void *element);
int linkedlist_remove(LinkedList *linkedlist, void *element);
int linkedlist_size(LinkedList *linkedlist);

/******************************
 * END LINKED LIST DECLARATIONS
 ******************************/


LinkedList *client_list;




/* Struct encapsulating information about a client */
typedef struct Client {
	Window *window;  // The client window
	int id; // The client's thread id
} Client;

// Global variables
Database *db;
char *scriptname;

//For the active threads
int active_threads;
pthread_mutex_t active_thread_mut;
pthread_cond_t active_thread_cond;
//End active threads

//Stop-Go cond mutex
int is_stopped;
pthread_mutex_t stop_go_mutex;
pthread_cond_t stop_go_cond;
//End stop-go cond mutex



/*********************************************
 * FORWARD DECLARATIONS
 *********************************************/
Client *client_new(int id);
void client_delete(Client *client);
void *run_client(void *client);
void process_command(char *command, char *response);


//Client LinkedList Functions
/*
  Returns: 1 if client's ids =, 0 if NOT equal
 */
int ll_client_equals(void *, void *);
void ll_client_delete(void *);



//Signal Handlers
void signals_setup(void);
int install_handler(int sig, void (*handler)(int));
void sigint_handler(int sig);
//End signal handlers


//Error-safe pthreads
void Pthread_create(pthread_t *, const pthread_attr_t *, void *(*) (void *), void *);
void Pthread_detach(pthread_t);

void Pthread_mutex_init(pthread_mutex_t *, const pthread_mutexattr_t *);
void Pthread_mutex_destroy(pthread_mutex_t *);
void Pthread_mutex_lock(pthread_mutex_t *); 
void Pthread_mutex_unlock(pthread_mutex_t *);

void Pthread_cond_init(pthread_cond_t *,const pthread_condattr_t *);
void Pthread_cond_broadcast(pthread_cond_t *);
void Pthread_cond_wait(pthread_cond_t *, pthread_mutex_t*);
void Pthread_cond_destroy(pthread_cond_t *);

/*********************************************
 * END FORWARD DECLARATIONS
 *********************************************/





/***********************************
 * Main function
 ***********************************/

void run_server() {
    char buf[BUFSIZE];
    char response[BUFSIZE];

	client_list = linkedlist_new( ll_client_equals, ll_client_delete);

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



    int client_id = 0;

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
				printf("LOL NEW CLIENT\n");
				client_new( client_id++ );
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


	//Destroy Stop-Go Threads Mutex/Cond
	Pthread_mutex_destroy( &stop_go_mutex);
	Pthread_cond_destroy( &stop_go_cond);
	//End Stop-Go Threads Mutex/Cond


	if(client_list)
		linkedlist_delete(client_list);

}

int main(int argc, char **argv) {
	if(argc == 1) {
		scriptname = NULL;
	} else if(argc == 2) {
		int len = strlen(argv[1]);
		scriptname = malloc(len+1);
		strncpy(scriptname, argv[1], len+1);
	} else {
		fprintf(stderr, "Usage: %s [scriptname]\n", argv[0]);
		exit(1);
	}

	//Begin SIGINT handling
	sigset_t full;
	sigemptyset(&full);
	sigaddset(&full, SIGINT);
	// Ignore signals while installing handlers
	pthread_sigmask(SIG_BLOCK, &full, NULL);
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

	db_delete(db);
	free(scriptname);


	Pthread_mutex_lock( &active_thread_mut );
	while( active_threads )
	{
		Pthread_cond_wait(&active_thread_cond, &active_thread_mut);
	}
	Pthread_mutex_unlock( &active_thread_mut);





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
Client *client_new(int id) {
	Client *client = (Client *)malloc(sizeof(Client));
	if(!client) {
		perror("malloc");
		return NULL;
	}
	client->id = id;

	// Create a window and set up a communication channel with it
	char title[20];
	sprintf(title, "Client %d", id);
	if(!(client->window = window_new(title, scriptname))) {
		free(client);
		return NULL;
	}
	//increase active thread found
	pthread_t thread;

	Pthread_mutex_lock( &active_thread_mut );
	active_threads++;
	Pthread_mutex_unlock( &active_thread_mut );

	Pthread_create(&thread, 0, run_client, client);
	Pthread_detach(thread);

	return client;
}

/* Delete a client and all associated resources */
void client_delete(Client *client) {
	window_delete(client->window);
	free(client);
}

/* Function executed for a given client */
void *run_client(void *args) {
	Client *client = (Client *)args;
	char command[BUF_LEN];
	char response[BUF_LEN];

	// Main loop of the client: fetch commands from window, interpret
	// and handle them, and send results to window.
	while(get_command(client->window, command)) {


		//################
		//BEGIN STOP-GO CHECK
		Pthread_mutex_lock(&stop_go_mutex);
		while( is_stopped )
		{
			Pthread_cond_wait( &stop_go_cond, &stop_go_mutex);
		}
		Pthread_mutex_unlock(&stop_go_mutex);
		//END STOP-GO CHECK
	    //################



		process_command(command, response);
		if(!send_response(client->window, response))
			break;
	}
	
	//remove active thread
	Pthread_mutex_lock( &active_thread_mut );
	active_threads--;

	if( !active_threads )
	{
		Pthread_cond_broadcast( &active_thread_cond );
	}

	Pthread_mutex_unlock( &active_thread_mut );


	client_delete(client);
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



/* sigint_handler
 * Respond to SIGINT signal (CTRL-C)
 *
 * Argument: int sig - the integer code representing this signal
 */
void sigint_handler(int sig) {
	printf("Closing Clients %d\n", sig);
	}



/******************************
 * LINKED LIST IMPLEMENTATION
 ******************************/



/******************************
 * Client Stuff IMPLEMENTATION
 ******************************/



//Client LinkedList Functions
 /*
  Returns: 1 if client's ids =, 0 if NOT equal
 */
int ll_client_equals(void *client1, void *client2){
	if( ((Client *)client1)->id == ((Client *)client2)->id ) 
	{
		return 1;
	}
	return 0;
}

void ll_client_delete(void *client){
	client_delete( ((Client *)client)  );
}


/******************************
 * End Client Stuff IMPLEMENTATION
 ******************************/





/******************************
 * Creation/deletion functions
 ******************************/

/* Create a new linkedlist with the given element functions and return it */
LinkedList *linkedlist_new(int (*equals) (void *, void *),
                    void (*delete)(void *)) {
	// TODO: 1. Allocate space for a linkedlist struct.
	//       2. Initialize the struct.
	LinkedList *newlist = (LinkedList *) malloc( sizeof( LinkedList ) );
	if( !newlist ){
		perror("Malloc'ing New Linked List");
		exit(1);
	}


	newlist->equals = equals;
	newlist->delete = delete;

	newlist->head = NULL;
	newlist->size = 0;


	return newlist;
}

/* Delete the given linked list */
void linkedlist_delete(LinkedList *linkedlist) {
	// TODO: 1. Delete all of the linked list's internal data.
	//       2. Free the struct.

	
	ListNode *current = linkedlist->head;
	int som = linkedlist->size;
	for(int i =0; i<som; i++){
		ListNode *next = current->next;
		linkedlist->delete(current->value);
		free(current);
		current = next;
	}
	linkedlist->head = NULL;

	free(linkedlist);
}


/******************************
 * Access/modification functions
 ******************************/

/* Add a copy of the given element to the tail of the list */
void linkedlist_append(LinkedList *linkedlist, void *element) {
	// TODO: 1. Find the last node in the linked list.
	//       2. Create a copy of the element and store the copy in
    //          a new list node.
	//       3. Set the next pointer of the last node to the newly
    //          created node.


	if( linkedlist->head == NULL){
		ListNode *new_head = (ListNode *)malloc(sizeof(ListNode));
		if( !new_head ){
			perror("Mallocing Linked List Append");
			exit(1);
		}
		linkedlist->head = new_head;

		linkedlist->head->value = element;
		linkedlist->head->next = NULL;
		linkedlist->size++;
		return;
	}

	ListNode *current = linkedlist->head;
	while( current->next != NULL ){
		current = current->next;
	}
	ListNode *new = (ListNode *)malloc(sizeof(ListNode));
	if( !new ){
		perror("Mallocing Linked List Append");
		exit(1);
	}
	new->value = element;
	new->next = NULL;

	current->next = new;
	linkedlist->size++;
}


/* Return 1 if the given element is in the list
 * 0 otherwise
 */
int linkedlist_contains(LinkedList *linkedlist, void *element) {
	ListNode *current = linkedlist->head;
	while (current != NULL) {
		if (linkedlist->equals(current->value, element)) {
			return 1;
		}
		current = current->next;
	}
	return 0;
}

/* Remove the first occurence of the given element from the list
 * Return 1 if the element was removed successfully
 * 0 otherwise (if the element was not found)
 */
int linkedlist_remove(LinkedList *linkedlist, void *element) {
	// TODO: 1. Find the first node containing the element.
	//       2. If an element is found, delete the linkedlist's copy
	//          of the element and remove the node.
    //       3. Update the next pointer of the previous element.
	if( !linkedlist_contains(linkedlist, element) ){
		return 0;
	}

	if( linkedlist->equals( linkedlist->head->value, element) ){
		linkedlist->delete( linkedlist->head->value );
		ListNode *temp = linkedlist->head->next;
		free(linkedlist->head);
		linkedlist->head = temp;
		linkedlist->size--;
		return 1;
	}


	ListNode *current = linkedlist->head;
	while( !linkedlist->equals(current->next->value, element) ){
		current = current->next;
	}

	ListNode *temp = current->next;
	linkedlist->delete( temp->value );

	current->next = current->next->next;
	free(temp);
	linkedlist->size--;
	return 1;
}


/******************************
 * Other utility functions
 ******************************/

/* Get the size of the given set */
int linkedlist_size(LinkedList *linkedlist) {
	return linkedlist->size;
}



