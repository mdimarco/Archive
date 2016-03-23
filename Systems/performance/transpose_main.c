#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "timer.h"

extern int transpose_naive(int n, int mat[][n], int res[][n]);
extern int transpose(int n, int mat[][n], int res[][n]);

int main(int argc, char *argv[]) {
	if (argc < 2 || argc > 3) {
		fprintf(stderr, "Usage: %s <size> [<check>]\n", argv[0]);
		exit(1);
	}

	int pre_size = atoi(argv[1]);

    /* adjust size to a multiple of 64 */
    int size = ((pre_size + 63) >> 6) << 6;
    if (pre_size != size)
        printf("Adjusted size to %d x %d.\n", size, size);

    /* allocate source matrix */
    int (*m)[size] = (int (*)[size])malloc(sizeof(int) * size * size);
    if (m == 0) {
        fprintf(stderr, "not enough memory\n");
        exit(1);
    }
	int a, b;
	int q = 0;
	for (a = 0; a < size; a++){
		for (b = 0; b < size; b++){
			m[a][b] = q++;
		}
	}

    /* allocate destination matrix */
    int (*r)[size] = (int (*)[size])malloc(sizeof(int) * size * size);
    if (r == 0) {
        fprintf(stderr, "not enough memory\n");
        exit(1);
    }

    /* perform the transposition */
    timer_start();
    transpose(size, m, r);
    timer_stop();

    /* if desired, check against baseline algorithm for correctness */
    if (argc == 3) {
        int (*cmp)[size] = (int (*)[size])malloc(sizeof(int) * size * size);
        transpose_naive(size, m, cmp);

        int i, j;
        for (i = 0; i < size; i++) {
            for (j = 0; j < size; j++) {
                if (cmp[i][j] != r[i][j]) {
                    fprintf(stderr, "error: position (%d, %d) incorrect.\n"
                                "Expected: %d\n"
                                "Received: %d\n",
                            i, j, cmp[i][j], r[i][j]);
                    exit(1);
                }
            }
        }
        fprintf(stdout, "Congrats! Your algorithm is correct.\n");
    }

	return 0;
}
