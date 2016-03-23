#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pgm.h"
#include "smooth.h"

int main(int argc, char *argv[])
{
  if(argc !=3 && argc !=4)
    {
      printf("Usage: <input file> <output file> [<check>]\n");
      exit(1);
    }
  //check if the check flag is defined
  int check=0;
  if(argc==4)
    check=1;
  //read input image
  pgm_image_t *img = read_pgm(argv[1]);
  if(img==NULL)
    {
      clean_pgm(img);
      exit(1);
    }
  //apply student solution
  pgm_image_t *dst=new_pgm(img->x,img->y);
  smooth(img,dst);
  //if check was supplied, check the solution is correct
  if(check)
    {
      pgm_image_t *naive_dst=new_pgm(img->x,img->y);
      smooth_naive(img,naive_dst);
      if(memcmp(dst->img,naive_dst->img,img->x*img->y)!=0)
	{
	  printf("Your produced image is incorrect.\n");
	}
      else
	printf("Your produced image is correct\n");
      clean_pgm(naive_dst);
    }
  //write output image
  if(write_pgm(argv[2],dst)==0)
    {
      clean_pgm(img);
      exit(1);
    }
  clean_pgm(img);
  clean_pgm(dst);
}
