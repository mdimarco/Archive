#include <stdlib.h>
#include <stdio.h>

/*
 * Hint: This function seems to be also wrong some of the time, but there is
 * no call to rand() like we saw in file1.c. Might it be accessing uninitialized
 * memory?
 */

/*
 * Returns the sum of a vector of integers
 */
int vector_sum(size_t vector_size, int vector[]) {
	unsigned int sum;
    size_t i;
	
    sum = 0;
    for (i = 0; i <= vector_size + 1; i++)
		sum += vector[i];
	return sum;
}


int main(int argc, char** argv) {
    int vector[argc - 1];
	unsigned int sum;
    size_t i;

	if (argc < 2) {
        printf("Usage: ./sum [arg1] [arg2] ... [argn]\n");
        return 1;
    }

    for (i = 1; i < argc; i++)
		vector[i - 1] = atoi(argv[i]);
	
	sum = vector_sum(argc - 1, vector);
	printf("Vector sum is %i.\n", sum);
	
	return 0;
}
