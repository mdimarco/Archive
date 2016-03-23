INCLUDE = -I/course/cs033/pub/lab09/libgd/include
LIBDIR  = -L/course/cs033/pub/lab09/libgd/lib

COMPILERFLAGS = -Wall -g -std=gnu99 -m32
CC = gcc
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)
LIBRARIES = -lgd

COLORS = colors.h colors.c
IMAGE = image.h image.c
MAIN = fractal.h main.c

all: default forked 

default: $(OBJS)
	$(CC) $(CFLAGS) -o fractal $(LIBDIR) $(LIBRARIES) $(COLORS) $(IMAGE) $(MAIN) fractal.c
	
forked:
	$(CC) $(CFLAGS) -o fractal_forked $(LIBDIR) $(LIBRARIES) $(COLORS) $(IMAGE) $(MAIN) fractal_forked.c

clean:
	rm -rf *.o fractal fractal_forked *~ *.png
