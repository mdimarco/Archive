CC = gcc
GEN = generator
CFLAGS = -g -Wall -Wunused -Wextra -std=c99

GEN_OBJS = stringlib.c

all:  stringlib

generator: $(GEN_OBJS)
	$(CC) $(CFLAGS) -o $(GEN) $(GEN_OBJS)

clean:
	rm -f $(GEN)
