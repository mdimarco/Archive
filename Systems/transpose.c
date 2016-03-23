/*
 * transpose_naive: baseline implementation of matrix transposition.
 */
void transpose_naive(int n, int mat[][n], int res[][n]) {
	int i, j;

	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			res[j][i] = mat[i][j];
		}
	}
}

/*
 * transpose: implementation of matrix transposition.
 * TODO: make this as fast as possible!
 */
void transpose(int n, int mat[][n], int res[][n]) {

    int i,j,i1,j1;
    int B = 64; //Block size
    for( i = 0; i<n; i+=B){
	    for(j = 0; j<n; j+=B){

		    //Inner block
		    for(i1 = i; i1<i+B;i1++){
			    for(j1 = j; j1<j+B; j1++){
				    res[j1][i1] = mat[i1][j1];
			    }
		    }
	    }
    }
    //transpose_naive(n, mat, res);
}
