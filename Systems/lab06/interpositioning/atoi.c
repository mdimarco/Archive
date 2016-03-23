#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int __real_atoi(const char *s);

int __wrap_atoi(const char *s) {
   
	int len = strlen(s);
	for(int x = 0; x<len; x++){
		if(s[x] < 48 || s[x] > 57){
			fprintf(stderr, "you don goofed, s not between 48-57\n");
			return -1;
		}

	}
	return __real_atoi(s); 
}

int main() {
    printf("wrapped atoi of \"10\": %d\n", atoi("10"));
    printf("wrapped atoi of \"9abc\": %d\n", atoi("9abc"));
    printf("wrapped atoi of \"-10\": %d\n", atoi("-10")); 
    printf("unwrapped atoi of \"9abc\": %d\n", __real_atoi("9abc"));
    return 0;
}
