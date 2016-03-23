CFLAGS = -g3 -Wall -Wextra -Wconversion -Wcast-qual -Wcast-align -g
CFLAGS += -Winline -Wfloat-equal -Wnested-externs
CFLAGS += -pedantic -std=c99 -Werror
CC = gcc 
PROMPT = -DPROMPT

EXECS = Stringlib.o SysCall.o 33sh 

all: $(EXECS)
	
Stringlib.o:	Stringlib.c
	$(CC) -c $(CFLAGS) Stringlib.c

SysCall.o:	bSysStuff.c
	$(CC) -c $(CFLAGS) bSysStuff.c

33sh:	sh.c
	$(CC) $(CFLAGS) $(PROMPT) Stringlib.o bSysStuff.o -o main sh.c
	rm -rf *.o

33noprompt:	sh.c
	$(CC) $(CFLAGS) -o main sh.c

clean:
	rm -rf *.o
	#TODO: clean up any executable files that this Makefile has produced

