CC = gcc
CFLAGS = -Wall -std=gnu99


all: siglab knocker

siglab: siglab.c
	$(CC) $(CFLAGS) siglab.c -o siglab

knocker: knocker.c
	$(CC) $(CFLAGS) knocker.c -o knocker

clean:
	rm -rf siglab knocker
