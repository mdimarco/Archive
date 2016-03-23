#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include "fractal.h"
#include "image.h"


typedef struct frac_data{
	color_t *color_data;
	float width;
	float height;
	float start_row;
	float num_rows;
} frac_data_t;

/*  TODO: define a struct which wraps the arguments to generate_fractal_region()    */

/*
    generates part of the fractal region, computing data for a number of rows
    beginning from start_y
    
    arguments:    data: a struct wrapping the data needed to generated the fractal
                    - a pointer to the color data region of memory
                    - the width of the image
                    - the height of the image
                    - the starting row for filling out data
                    - the number of rows to fill out
    returns:    NULL
*/
void *gen_fractal_region(void *data) {
    
    /* TODO: unpack the data struct and call generate_fractal_region()    */
    frac_data_t *pic_data = (frac_data_t *)data;
    generate_fractal_region(pic_data->color_data, pic_data->width, 
		            pic_data->height, pic_data->start_row, pic_data->num_rows);

    return NULL;
}



int generate_fractal(char *file, float width, float height, int workers) {
    /* TODO: initialize several threads which will compute a unique
             region of the fractal data, and have them each execute
             gen_fractal_region().    */
    pthread_t thread[workers];
    frac_data_t args[workers];
    color_t *color_data = malloc(sizeof(color_t)*width*height);
    for(int i=0; i<workers;i++)
    {
	args[i].color_data = color_data;
	args[i].width = width;
	args[i].height = height;
	args[i].start_row = i*(height/workers);
	args[i].num_rows = height/workers;
	
	pthread_create(&thread[i],
			0,
			gen_fractal_region,
			&args[i]);
    }
    for(int i=0; i<workers;i++)
    {
	pthread_join(thread[i], NULL);
    }

    if(save_image_data(file, color_data, width, height))
    {
	    fprintf(stderr, "erorr saving image\n");
	    free(color_data);
	    return 1;
    }

    free(color_data);    
    printf("Complete.\n");
    return 0;
}
