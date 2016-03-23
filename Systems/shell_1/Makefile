CFLAGS = -g3 -Wall -Wextra -Wconversion -Wcast-qual -Wcast-align -g
CFLAGS += -Winline -Wfloat-equal -Wnested-externs
CFLAGS += -pedantic -std=c99 -Werror -Wl,--wrap=read,--wrap=write
CC = gcc 
PROMPT = -DPROMPT

EXECS = wrappers.o Stringlib.o SysCall.o 33noprompt 33sh 

all: $(EXECS)
	
wrappers.o:	wrappers.c
	$(CC) -c $(CLAGS) wrappers.c

Stringlib.o:	Stringlib.c
	$(CC) -c $(CFLAGS) Stringlib.c

SysCall.o:	bSysStuff.c
	$(CC) -c $(CFLAGS) bSysStuff.c

33sh:	sh.c
	$(CC) $(CFLAGS) $(PROMPT) wrappers.o Stringlib.o bSysStuff.o -o 33sh sh.c
	rm -rf *.o

33noprompt:	sh.c
	$(CC) $(CFLAGS) wrappers.o Stringlib.o bSysStuff.o -o 33noprompt sh.c

clean:
	rm -rf *.o 33sh 33noprompt

