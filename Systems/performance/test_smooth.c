#include "pgm.h"
#include "smooth.h"

#define IDX(col,row,dim) row * dim + col
#define MIN(a,b) (a<b) ? a:b
#define MAX(a,b) (a>b) ? a:b
/***************************************************************
   * Various typedefs and helper functions for the smooth function
    * You may modify these any way you like.
     **************************************************************/

/* Compute the minimum of two integers */
int min(int a, int b) {
      if (a < b)
                return a;
          return b;
}

/* compute the maximum of two integers */
int max(int a, int b) {
      if (a < b)
                return b;
          return a;
}

/*
avg - Returns averaged pixel value at (i,j) 
*/
unsigned int avg(int dim, int i, int j, unsigned int *img)
{
  int ii, jj;
  unsigned int sum = 0;
  unsigned int num = 0;
  
  int iMX = MAX(i-1,0);
  int iMN = MIN(i+1,dim-1);
  int jMX = MAX(j-1,0);
  int jMN = MIN(j+1,dim-1);

  for(ii = iMX; ii <= iMN; ii++) {
    for(jj = jMX; jj <= jMN; jj++) {
	    sum += img[IDX(ii, jj, dim)];
	    num++; 
    }                                          
  }
  return (unsigned int)(sum/num);
}

/**
* naive smooth is a non-optimized implementation of smooth
 */
void smooth_naive(pgm_image_t *src, pgm_image_t *dst)
{
  int i, j;
  int dim = src->x;
  for (i = 0; i < dim; i++) {
    for (j = 0; j < dim; j++) {
      dst->img[IDX(i, j, src->x)] = avg(src->x, i, j, src->img);
      }
  }
}

void smooth_better(pgm_image_t *src, pgm_image_t *dst)
{
  int i, j, i1, j1, ii, jj;
  int dim = src->x;
  int B = 16;
  for (i = 0; i < dim; i+=B) {
    
     for (j = 0; j < dim; j+=B) {

	for(i1 = i; i1<i+B; i1++){
                int iMX = MAX(i1-1,0);
                int iMN = MIN(i1+1,dim-1);
		for(j1 = j; j1<j+B; j1++){

                   //Begin Average Stuff	     
                   unsigned int sum = 0;
                   unsigned int num = 0;
  
                   
                   int jMX = MAX(j1-1,0);
                   int jMN = MIN(j1+1,dim-1);

                   for(ii = iMX; ii <= iMN; ii++) {
                       for(jj = jMX; jj <= jMN; jj++) {
	                   sum += src->img[IDX(ii, jj, dim)];
	                   num++; 
	                }
                    }
                    //end average stuff
                    dst->img[IDX(i1, j1, src->x)] = (unsigned int)(sum/num);
		   }
	}
    }                                          
  }
}




void smooth(pgm_image_t *src, pgm_image_t *dst)
{
  //smooth_naive(src, dst);
  smooth_better(src,dst);
}
