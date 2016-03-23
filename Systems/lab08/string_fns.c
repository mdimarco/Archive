#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "string_fns.h"

/* The following function signatures will be used for
 * sets containing strings, where all void * pointers
 * are really char *s.
 */


/* Test two strings for equality */
int string_equals(void *arg1, void *arg2) {
	if(!arg1 || !arg2)
		return !arg1 && !arg2;
	else
		return !strcmp((char *)arg1, (char *)arg2);
}

/* Create a dynamically-allocated copy of the
 * given string, and return a pointer to it */
void *string_copy(void *arg) {
	char *str = (char *)arg;
	if(str) {
		size_t len = strlen(str);
		char *kopje = (char *)malloc(len + 1);
		strncpy(kopje, str, len+1);
		return kopje;
	} else
		return NULL;
}

/* Free the given string */
void string_delete(void *arg) {
	free(arg);
}

/* Print a representation of the given string
 * to the given stream */
void string_print(FILE* stream, void *arg) {
	if(arg==NULL)
		fprintf(stream, "null ");
	else
		fprintf(stream, "\"%s\" ", (char *)arg);
}
