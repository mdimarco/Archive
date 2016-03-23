#ifndef PGM
#define PGM

typedef struct pgm_image
{
  int x;
  int y;
  unsigned int *img;
} pgm_image_t;

pgm_image_t *new_pgm(int x,int y);
pgm_image_t *read_pgm(char *filename);
int write_pgm(char *filename,pgm_image_t *img);
pgm_image_t *copy_pgm(pgm_image_t *img);
void clean_pgm(pgm_image_t *img);
#endif
