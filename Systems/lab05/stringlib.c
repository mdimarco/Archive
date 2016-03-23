#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAXARGS 1024

/* STRING LIB
 * Holds a bunch of string parsing functions used in the
 * Babylib lab - tokenize/next_token/find_string/trim_spaces  
 */

/* Finds a substring in a given string */
char *find_string(char * str, char * sub) {
	// TODO: Implement this function	
	return NULL;
}

/* Breaks a string up into tokens separated by the
 * parameter string "delim".
 */
char *next_token(char *s, char *delim) {
	// TODO: Implement this function
	return NULL;	
}

/* Tokenizes a string, placing pointers to the tokens in argv.
 * After calling tokenize, you should be able to get all
 * tokens from argv.
 */
size_t tokenize(char *buf, char *delim, char **argv) {
	// TODO: Implement this function
	return 0;    
}

/* Trims both leading and trailing spaces from a given string.
 * Spaces are regular whitespace and non-printable characters.
 */
char *trim_spaces(char *src) {
	// TODO: Implement this function
	return NULL;
}

int main() {
	// Tokenize
	printf("Beginning tokenize tests (should see \" Let's create a sentence \" on separate lines\n");
	char myVar[] = "Let's\t\ncreate\v   a sentence\n";
        char *delim = "\r\n\t\f\v ";
        char* argv[MAXARGS];
	tokenize(myVar, delim, argv);
	for(int i = 0; i<4; i++){

		printf("%d. %s\n", i, argv[i]);

	}

	// Find String
	printf("Beginning find string tests - FAILs will print if tests don't pass\n");
	char * s1 = "hello world my name is bob";
	char * s2 = "hello";
	char * s3 = "bob";
	char * s4 = "world my";

	char * t1 = "simple simulation";
	char * t2 = "sim";
	char * t3 = "simul";

	char * bad = "blah";
	char * badsub = "blahblahblah";


	// Find string - normal
        char *found = find_string(s1, s2);
	if (!found || strcmp(found, s1)) {
		printf("FAIL 1\n");
	}

        found = find_string(s1, s3);
	if (!found || strcmp(found, "bob")) {
		printf("FAIL 2\n");
	}

        found = find_string(s1, s4);
	if (!found || strcmp(found, "world my name is bob")) {
		printf("FAIL 3\n");
	}

	// Find string - overlap test cases
        found = find_string(t1, t2);
	if (!found || strcmp(found, t1)) {
		printf("FAIL 4\n");
	}

        found = find_string(s1, s3);
	if (!found || strcmp(find_string(t1, t3), "simulation")) {
		printf("FAIL 5\n");
	}

	// Find string - Bad test cases
	if (!found || find_string(bad, badsub) ) {
		printf("FAIL 6\n");
	}

	if (find_string(NULL, NULL)) {
		printf("FAIL 7\n");
	}


	// Trim
	printf("Beginning trim tests - FAILs will print if tests don't pass\n");
	char * output = "hello world";
	char ip1[MAXARGS] = "hello world";
	char ip2[MAXARGS] = "   \n hello world";
	char ip3[MAXARGS] = "hello world   \t\n  ";
        char ip4[MAXARGS] = "\n \n hello world   ";
	char ip5[MAXARGS] = "\n hello world\t\t\tblah   ";
	char * dest;
	dest = trim_spaces(ip1 );
	if (!dest || strcmp(dest, output)) {
		printf("FAIL 1\n");
	}
	dest = trim_spaces(ip2 );
	if (!dest || strcmp(dest, output)) {
		printf("FAIL 2\n");
	}
	dest = trim_spaces(ip3 );
	if (!dest || strcmp(dest, output)) {
		printf("FAIL 3\n");
	}
	dest = trim_spaces(ip4 );
	if (!dest || strcmp(dest, output)) {
		printf("FAIL 4\n");
	}
	dest = trim_spaces(ip5 );
	if (!dest || strcmp(dest, "hello world\t\t\tblah")) {
		printf("FAIL 5\n");
	}

	return 0;
}
