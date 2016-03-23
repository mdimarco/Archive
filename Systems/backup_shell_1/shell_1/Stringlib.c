
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "Stringlib.h"
/* STRING LIB
 * Holds a bunch of string parsing functions used in the
 * Babylib lab - tokenize/next_token/find_string/trim_spaces  
 */

/* Finds a substring in a given string */
char *find_string(char * str, char * sub) {
	if(str == NULL || sub == NULL){return NULL;}

	size_t s1_len = strlen( str );
	size_t sub_len = strlen( sub );
	if(sub_len > s1_len){return NULL;}

	unsigned int s1_counter = 0;
	unsigned int sub_counter = 0;
	while( s1_counter < s1_len ){

		while( str[s1_counter+sub_counter] == sub[sub_counter] && sub_counter < sub_len){
			sub_counter++;
		}
		if( sub_counter == sub_len){ return &str[s1_counter];}
		sub_counter = 0;
		s1_counter++;
	}
	return NULL;

}
/* Breaks a string up into tokens separated by the
 * parameter string "delim".
 */
char *next_token(char *s, char *delim) {

	if(strlen(s) == 0 ) return "\0";

	size_t length_til_delim = strcspn( s, delim );
	char *new = s + length_til_delim + 1;


	return new;
}

/* Tokenizes a string, placing pointers to the tokens in argv.
 * After calling tokenize, you should be able to get all
 * tokens from argv.
 */
size_t tokenize(char *buf, char *delim, char **argv) {




	size_t index = 0;
	while( buf[0] != '\0'){


		size_t length_til_delim = strcspn( buf, delim );

		if(length_til_delim == 0){
			buf = next_token(buf, delim);
			continue;
		}

		buf[length_til_delim] = '\0';
		argv[index] = buf;
		index++;

		buf = next_token(buf, delim);
	}

	return index;    
}


/* Trims both leading and trailing spaces from a given string.
 * Spaces are regular whitespace and non-printable characters.
 *size_/ti */ 
char *trim_spaces(char *src) {


	/*
		##############################
		BEGIN Trail Space Trimming
	
	i
	size_t endTrim = strlen(src)-1;
    while( !isprint(src[endTrim]) || isspace(src[endTrim]) ){
            endTrim--;
    }
    endTrim++;
    char noTrail[endTrim+1];
    noTrail[endTrim] = '\0';
    for(size_t i = 0; i<endTrim;i++){
        noTrail[i] = src[i];
    }
	
		END Trail Space Trimming
		##############################
	

	//

	
		##############################
		BEGIN Leading Space Trimming
	
	int leadingSpace = 0;
    while(noTrail[leadingSpace] != '\0' &&
 	(!isprint(src[leadingSpace]) || isspace(src[leadingSpace])) ){
                leadingSpace++;
        }

        char *noLeadOrTrail = &noTrail[leadingSpace];
	
		END Leading Space Trimming
		##############################
	
	strcpy(src, noLeadOrTrail);
	*/

	//New and improved
	char *end;
	while(isspace(*src)) src++;
	if(*src == 0)
		return src;
	end = src + strlen(src) - 1;
	while(end>src && isspace(*end)) end--;
	*(end+1) = 0;



	return src;
}
