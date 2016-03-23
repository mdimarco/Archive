

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

int atoi_test( char[] );

int main(){

	char input[] = "1234";
	int answer = atoi_test( input );
	printf("%d\n", answer);

	return 0;
}


int atoi_test( char input[] ){

	int accumulator = 0;

	int i = 0;
	while( isdigit(input[i]) ){
		accumulator *= 10;
		accumulator += ((int)input[i]-48); 

		i++;
	}
	
	return accumulator;

}