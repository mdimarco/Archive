CC = gcc
GEN = generator
CFLAGS = -g -Wall -Wextra -std=c99

GEN_OBJS = generator.c

all:  generator

generator: $(GEN_OBJS)
	$(CC) $(CFLAGS) -o $(GEN) $(GEN_OBJS)

clean:
	rm -f $(GEN)
