#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <sys/file.h>
#include <signal.h>
#include <unistd.h>

#include "db.h"

//define type to enact rw lock on
enum locktype {l_read, l_write};


typedef struct DBNode DBNode;
/* Struct representing a database node */
struct DBNode {
	char *name;
	char *value;
	DBNode *lchild;
	DBNode *rchild;
	pthread_rwlock_t lock;
};

/* Struct representing a database */
struct Database {
	DBNode *root;
};



/*********************************************
 * FORWARD DECLARATIONS
 *********************************************/
static DBNode *dbnode_new(char *name, char *value, DBNode *left, DBNode *right);
static void dbnode_delete(DBNode *node);
static void dbnode_rdelete(DBNode *node);
static DBNode *search(DBNode *parent, char *name, DBNode **parentpp, enum locktype lt);
static void dbnode_print(DBNode *node, FILE *file);
static void dbnode_rprint(DBNode *node, FILE *file, int level);
static void print_spaces(FILE *file, int nspaces);


static void Pthread_rwlock_rdlock(pthread_rwlock_t *);
static void Pthread_rwlock_wrlock(pthread_rwlock_t *);
static void Pthread_rwlock_unlock(pthread_rwlock_t *);


/*********************************************
 * END FORWARD DECLARATIONS
 *********************************************/


//takes in locktype and lock-ptr, sets approprieate rwlock state
#define lock(lt, lk) ((lt) == l_read ) ? Pthread_rwlock_rdlock(lk) : Pthread_rwlock_wrlock(lk)


/****************************************
 * Database creation/deletion functions
 ****************************************/

/* Create a database */
Database *db_new() {

	Database *db = (Database *)malloc(sizeof(Database));
	if(!db)
		return NULL;

	if(!(db->root = dbnode_new("", "", NULL, NULL))) {
		free(db);
		return NULL;
	}
	return db;
}

/* Delete a database */
void db_delete(Database *db) {
	if(db) {
		dbnode_rdelete(db->root);  // Delete all nodes in the database
		free(db);
	}
}

/* Create a database node */
static DBNode *dbnode_new(char *name, char *value, DBNode *left, DBNode *right) {



	DBNode *node = (DBNode *)malloc(sizeof(DBNode));
	if(!node)
		return NULL;

	if(!(node->name = (char *)malloc(strlen(name)+1))) {
		free(node);
		return NULL;
	}

	if(!(node->value = (char *)malloc(strlen(value)+1))) {
		free(node->name);	
		free(node);
		return NULL;
	}

	int errnum;
	if( (errnum = pthread_rwlock_init(&(node->lock), NULL)) )
	{
		free(node->name);
		free(node->value);
		free(node);
		fprintf(stderr, "pthread rwlock init %s\n", strerror(errnum));
		return NULL;
	}


	strcpy(node->name, name);
	strcpy(node->value, value);

	node->lchild = left;
	node->rchild = right;


	return node;
}

/* Delete a database node */
static void dbnode_delete(DBNode *node) {
	free(node->name);
	free(node->value);

	int errnum;
	if( (errnum = pthread_rwlock_destroy(&node->lock)) )
	{
		fprintf(stderr, "pthread rwlock destroy %s\n", strerror(errnum));
	}
	free(node);
}

/* Recursively delete a database node and all children */
static void dbnode_rdelete(DBNode *node) {
	if(node) {
		dbnode_rdelete(node->lchild);
		dbnode_rdelete(node->rchild);
		dbnode_delete(node);
	}
}

/****************************************
 * Access/modification functions
 ****************************************/

/* Add a key-value pair to the database
 *
 * db    - The database
 * name  - The key to add
 * value - The corresponding value
 *
 * Return 1 on success, 0 on failure
 */
int db_add(Database *db, char *name, char *value) {
	DBNode *parent;

	enum locktype lt = l_write;
	lock(lt, &db->root->lock);
	DBNode *target = search(db->root, name, &parent, lt);
	if(target){  // Name is already in database
		Pthread_rwlock_unlock(&target->lock);
		Pthread_rwlock_unlock(&parent->lock);
		return 0;
	}

	target = dbnode_new(name, value, NULL, NULL);
	if(strcmp(name, parent->name)<0){
		parent->lchild = target;
	}
	else{
		parent->rchild = target;
	}


	Pthread_rwlock_unlock(&parent->lock);
	return 1;
}

/* Search for the value corresponding to a given key
 *
 * db    - The database
 * name  - The key to search for
 * value - A buffer in which to store the result
 * len   - The result buffer length
 *
 * Return 1 on success, 0 on failure
 */
int db_query(Database *db, char *name, char *value, int len) {

	enum locktype lt = l_read;
	lock(lt, &db->root->lock);
	DBNode *target = search(db->root, name, NULL, lt);

	if(target) {
		int tlen = strlen(target->value) + 1;
		strncpy(value, target->value, (len < tlen ? len : tlen));
		Pthread_rwlock_unlock(&target->lock);
		return 1;
	} 
	else {
		return 0;
	}
}

/* Delete a key-value pair from the database
 *
 * db    - The database
 * name  - The key to delete
 *
 * Return 1 on success, 0 on failure
 */
int db_remove(Database *db, char *name) {
	DBNode *parent;

	enum locktype lt = l_write;
	lock(lt, &db->root->lock);
	DBNode *target = search(db->root, name, &parent, lt);

	if(!target){ // Name is not in database
		Pthread_rwlock_unlock(&parent->lock);
		return 0;
	}

	if( target->lchild )
	{
		lock(lt, &target->lchild->lock);
	}
	if( target->rchild )
	{
		lock(lt, &target->rchild->lock);
	}
	Pthread_rwlock_unlock(&target->lock);

	DBNode *tleft = target->lchild;
	DBNode *tright = target->rchild;

	dbnode_delete(target);
	DBNode *successor;

	if(!tleft) {
		// If deleted node has no left child, promote right child

		successor = tright;
	} else if(!tright) {
		// If deleted node has not right child, promote left child

		successor = tleft;
	} else {
		// If deleted node has both children, find leftmost child
		// of right subtree.  This node is less than all other nodes in
		// the right subtree, and greater than all nodes in the left subtree,
		// so it can be used to replace the deleted node.

		DBNode *old;
		DBNode *sp = NULL;
		successor = tright;
		while(successor->lchild) {
			old = sp;
			sp = successor;
			lock(lt, &successor->lchild->lock);
			successor = successor->lchild;
			if(old){
				Pthread_rwlock_unlock(&old->lock);
			}

		}

		if(sp) {
			sp->lchild = successor->rchild;
			successor->rchild = tright;
			Pthread_rwlock_unlock(&sp->lock);
		}

		successor->lchild = tleft;
		Pthread_rwlock_unlock(&tleft->lock);//No more need for the left now

	}

	if(strcmp(name, parent->name)<0)
		parent->lchild = successor;
	else
		parent->rchild = successor;

	if(successor)
		Pthread_rwlock_unlock(&successor->lock);
	Pthread_rwlock_unlock(&parent->lock);
	return 1;
}

/* Search the tree, starting at parent, for a node whose name is
 * as specified.
 *
 * Return a pointer to the node if found, or NULL otherwise.
 *
 * If parentpp is not NULL, then it points to a location at which
 * the address of the parent of the target node is stored. 
 * If the target node is not found, the location pointed to by
 * parentpp is set to what would be the the address of the parent
 * of the target node, if it existed.
 *
 * Assumptions: parent is not null and does not contain name
 */
static DBNode *search(DBNode *parent, char *name, DBNode **parentpp, enum locktype lt) {
	DBNode *next = parent;

	do{
		parent = next;
		if(strcmp(name, parent->name) < 0){
			if(parent->lchild){
				lock(lt, &parent->lchild->lock);
			}
			next = parent->lchild;
		}
		else{
			if(parent->rchild){
				lock(lt, &parent->rchild->lock);
			}
			next = parent->rchild;
		}


		//IF THERE WILL BE A NEXT ITERATION
		//UNLOCK THE PARENT OTHERWISE HANG ON
		if(next && strcmp(name, next->name))
			Pthread_rwlock_unlock(&parent->lock);


	} while(next && strcmp(name, next->name));

	if(parentpp){
		*parentpp = parent;
	}

	else{
		Pthread_rwlock_unlock(&parent->lock);
	}

	return next;
}

/*********************************************
 * Database printing functions
 *********************************************/

/* Print contents of database to the given file */
void db_print(Database *db, FILE *file) {


    //Get file's file descriptor
	int file_num = fileno(file);
	if(file_num == -1)
	{
		perror("Fileno Error");
		return;
	}
	//End get file's file descriptor


    //Begin file lock
	int errnum;
	if( (errnum = flock(file_num, LOCK_EX)) )
	{
		fprintf(stderr, "File Lock: %s\n", strerror(errnum));
		exit(1);
	}
	//End file lock


	dbnode_rprint(db->root, file, 0);

    //Begin File unlock
	if( (errnum = flock(file_num, LOCK_UN)) )
	{
		fprintf(stderr, "File Unlock: %s\n", strerror(errnum));
		exit(1);
	}
	//End file unlock
}

/* Print a representation of the given node */
static void dbnode_print(DBNode *node, FILE *file) {

	if(!node)
		fprintf(file, "(null)\n");
	else if(!*(node->name))  // Root node has name ""
		fprintf(file, "(root)\n");
	else
		fprintf(file, "%s %s\n", node->name, node->value);
}

/* Recursively print the given node followed by its left and right subtrees */
static void dbnode_rprint(DBNode *node, FILE *file, int level) {
	print_spaces(file, level);
	dbnode_print(node, file);
	if(node) {
		dbnode_rprint(node->lchild, file, level+1);
		dbnode_rprint(node->rchild, file, level+1);
	}
}

/* Print the given number of spaces */
static void print_spaces(FILE *file, int nspaces) {
	while(0 < nspaces--)
		fprintf(file, " ");
}




/*********************************************
 * Error Safe Pthread Functions
 *********************************************/




/*********************************************
 * Standard Pthread Functions
 *********************************************/
void Pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                          void *(*start_routine) (void *), void *arg)
{
	int errnum;
	if ( (errnum = pthread_create(thread, attr, start_routine, arg)) )
    {
		fprintf(stderr,"Pthread Create error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_detach(pthread_t thread)
{
	int errnum;
	if ( (errnum = pthread_detach(thread) ) )
    {
		fprintf(stderr,"Pthread Detach error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_cancel(pthread_t thread)
{
	int errnum;
	if(  (errnum = pthread_cancel(thread)) )
	{
		fprintf(stderr,"Pthread Cancel error %s\n", strerror(errnum) );
		exit(1);		
	}
}

/*********************************************
 * End Standard Pthread Functions
 *********************************************/




/*********************************************
 * Mutex Pthread Functions
 *********************************************/
void Pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *restrict attr)
{
    int errnum;
	if ( (errnum = pthread_mutex_init(mutex, attr)) )
    {
		fprintf(stderr,"Mutex Init error %s\n", strerror(errnum) );
		exit(1);
    }
}


void Pthread_mutex_destroy(pthread_mutex_t *mutex)
{
    int errnum;
	if ( (errnum = pthread_mutex_destroy(mutex)) )
    {
		fprintf(stderr,"Mutex Destroy error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_mutex_lock(pthread_mutex_t *mutex)
{
    int errnum;
	if ( (errnum = pthread_mutex_lock(mutex) ) )
    {
		fprintf(stderr,"Mutex Lock error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_mutex_unlock(pthread_mutex_t *mutex)
{
    int errnum;
	if ( (errnum = pthread_mutex_unlock(mutex)) )
    {
		fprintf(stderr,"Mutex Unlock error %s\n", strerror(errnum) );
		exit(1);
    }
}

/*********************************************
 * End Mutex Pthread Functions
 *********************************************/



/*********************************************
 * Condition Pthread Functions
 *********************************************/
void Pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *restrict attr)
{
	int errnum;
	if ( (errnum = pthread_cond_init(cond, attr)) )
    {
		fprintf(stderr,"condition init error %s\n", strerror(errnum) );
		exit(1);
    }
}
void Pthread_cond_broadcast(pthread_cond_t *cond)
{
    int errnum;
	if ( (errnum = pthread_cond_broadcast(cond)) )
    {
		fprintf(stderr,"condition broadcast error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)
{
    int errnum;
	if ( (errnum = pthread_cond_wait(cond, mutex)) )
    {
		fprintf(stderr,"condition wait error %s\n", strerror(errnum) );
		exit(1);
    }
}

void Pthread_cond_destroy(pthread_cond_t *cond)
{
    int errnum;
	if ( (errnum = pthread_cond_destroy(cond)) )
    {
		fprintf(stderr,"condition destroy error %s\n", strerror(errnum) );
		exit(1);
    }
}

/*********************************************
 * End Condition Pthread Functions
 *********************************************/



/*********************************************
 * READ/WRITE LOCK Pthread Functions
 *********************************************/



static void Pthread_rwlock_rdlock(pthread_rwlock_t *lock)
{
	int errnum;
	if( (errnum = pthread_rwlock_rdlock(lock) ) )
	{
		fprintf(stderr,"Read/Write Lock Read Lock %s\n", strerror(errnum) );
		exit(1);
	}
}

static void Pthread_rwlock_wrlock(pthread_rwlock_t *lock)
{
	int errnum;
	if( (errnum = pthread_rwlock_wrlock(lock) ) )
	{
		fprintf(stderr,"Read/Write Lock Write Lock %s\n", strerror(errnum) );
		exit(1);
	}
}

static void Pthread_rwlock_unlock(pthread_rwlock_t *lock)
{
	int errnum;
	if( (errnum = pthread_rwlock_unlock(lock) ) )
	{
		fprintf(stderr,"Read/Write Lock Unlock %s\n", strerror(errnum) );
		exit(1);
	}

}



/*********************************************
 * END READ/WRITE LOCK Pthread Functions
 *********************************************/


