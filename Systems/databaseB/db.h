#ifndef DB_H
#define DB_H

#include <stdio.h>
#include <pthread.h>


/* Struct representing a database */
typedef struct Database Database;

/* Create a database */
Database *db_new();

/* Delete the given database */
void db_delete(Database *db);

/* Add a key-value pair to the database
 *
 * db    - The database
 * name  - The key to add
 * value - The corresponding value
 *
 * Return 1 on success, 0 on failure
 */
int db_add(Database *db, char *name, char *value);

/* Search for the value corresponding to a given key
 *
 * db    - The database
 * name  - The key to search for
 * value - A buffer in which to store the result
 * len   - The result buffer length
 *
 * Return 1 on success, 0 on failure
 */
int db_query(Database *db, char *name, char *value, int len);

/* Delete a key-value pair from the database
 *
 * db    - The database
 * name  - The key to delete
 *
 * Return 1 on success, 0 on failure
 */
int db_remove(Database *db, char *name);

/* Print contents of database to the given file */
void db_print(Database *db, FILE *file);


/** Error safe pthread_functions
   *Used for shortening of error handling within db.c/server.c
   *
   *
   *See man pages for lowercase "p" versions
**/


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



#endif
