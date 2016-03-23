#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void trim();

int main(){

return 0;
}

void trim(){
	char* myString = "    lol     ";

	printf("%sa\n", myString);
	size_t endTrim = strlen(myString)-1;
	while( !isprint(myString[endTrim]) || isspace(myString[endTrim]) ){
		endTrim--;
	}	
 	endTrim++;	
	char new[endTrim+1];
	new[endTrim] = '\0';
	for(int i = 0; i<endTrim;i++){
	    new[i] = myString[i];
	}
	printf("%sa\n", new);

	int leadingSpace = 0;
	while(new[leadingSpace] != '\0' &&
 (!isprint(myString[leadingSpace]) || isspace(myString[leadingSpace])) ){
		leadingSpace++;
	}
	
	char *noLead = &new[leadingSpace];
	printf("%sa\n",noLead);



}


