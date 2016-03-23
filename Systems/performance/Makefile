CC = gcc
CFLAGS = -std=c99 -Wall -Werror -Wunused -O1
EXECS = smooth transpose

all: $(EXECS)

$(EXECS): % : %.c %_main.c pgm.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	/bin/rm -f $(EXECS) *~ *.o

