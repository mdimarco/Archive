CC = gcc
CFLAGS = -Wall -Wextra -Wunused
CFLAGS += -std=gnu99 -g -O2

client: 
	$(CC) $(CFLAGS) -o client snowcast.c
	rm -rf *.o

clean:
	rm -rf client 
