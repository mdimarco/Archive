#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pgm.h"

pgm_image_t *new_pgm(int x,int y)
{
  pgm_image_t *ret=(pgm_image_t*)malloc(sizeof(pgm_image_t));
  ret->x=x;
  ret->y=y;
  ret->img=(unsigned int*)malloc(sizeof(int)*x*y);
  return ret;
}

pgm_image_t *read_pgm(char *filename)
{
  pgm_image_t *ret=(pgm_image_t*)malloc(sizeof(pgm_image_t));
  //open pgm file
  FILE *file = fopen(filename,"r");
  if(!file)
    {
      fprintf(stderr,"Error while opening %s",filename);
      perror(NULL);
      return NULL;
    }
  //read magic number
  char magic_number[3];
  if(!fread(magic_number,3*sizeof(char),1,file))
    {
      perror("Error while reading magic number");
      return NULL;
    }
  //check magic number=P5 (binary PGM)
  if(magic_number[0]!='P' || magic_number[1] !='5')
    {
      fprintf(stderr,"Error: not a pgm file");
      return NULL;
    }
  //read through comments
  char c = getc(file);
  while (c == '#')
    {
      while (getc(file) != '\n');
      c = getc(file);
    }
  fseek(file,-1,SEEK_CUR);
  //read size info
  int x,y;
  if(fscanf(file,"%d %d ",&x,&y)==EOF)
    {
      perror("Error while reading size information");
      return NULL;
    }
  ret->x=x;
  ret->y=y;
  //read max grayscale value
  int max_val;
  if(fscanf(file,"%d ",&max_val)==EOF)
    {
      perror("Error while reading max grayscale value");
      return NULL;
    }
  //check max grayscale value
  if(max_val!=255)
    {
      fprintf(stderr,"Error: max grayscale value must be 255\n");
      return NULL;
    }
  //read image data
  ret->img=(unsigned int*)malloc(x*y*sizeof(unsigned int));
  unsigned char buf[x*y];
  if(fread(buf,x,y,file)==0)
    {
      perror("Error while reading image data");
      return NULL;
    }
  int i;
  for(i=0;i<x*y;i++)
    ret->img[i]=(unsigned int)buf[i];
  return ret;
}

const char *comment="Created by the Fall 2014 CS033 TAs";

int write_pgm(char *filename,pgm_image_t *img)
{
  FILE *file=fopen(filename,"w+");
  //write header
  if(fprintf(file,"P5\n#%s\n%d %d\n%d\n",comment,img->x,img->y,255)<0)
    {
      perror("Error while writing header to output file");
      return 0;
    }
  unsigned char buf[img->x*img->y];
  int i;
  for(i=0;i<img->x*img->y;i++)
    buf[i]=(char)img->img[i];
  //write image data
  if(fwrite(buf,sizeof(char)*img->x,img->y,file)<img->y)
    {
      perror("Error while writing data to output file");
      return 0;
    }
  return 1;
}

pgm_image_t *copy_pgm(pgm_image_t *img)
{
  pgm_image_t *ret=(pgm_image_t*)malloc(sizeof(pgm_image_t));
  ret->x=img->x;
  ret->y=img->y;
  ret->img=(unsigned int*)malloc(sizeof(int)*ret->x*ret->y);
  memcpy(ret->img,img->img,sizeof(int)*ret->x*ret->y);
  return ret;
}

void clean_pgm(pgm_image_t *img)
{
  free(img->img);
  free(img);
}
