CFLAGS = -g3 -Wall -Wextra -Wconversion -Wcast-qual -Wcast-align -g
CFLAGS += -Winline -Wfloat-equal -Wnested-externs
CFLAGS += -pedantic -std=gnu99 -Werror -Wl,--wrap=read,--wrap=write
CC = gcc 
PROMPT = -DPROMPT

EXECS = wrappers.o Stringlib.o 33noprompt 33sh

all: $(EXECS)
	
wrappers.o:	wrappers.c
	-$(CC) -c $(CLAGS) wrappers.c

33sh:	sh.c
	$(CC) $(CFLAGS) $(PROMPT) wrappers.o -o 33sh sh.c jobs.c signalstuff.c bSysStuff.c Stringlib.c
	rm -rf *.o

33noprompt:	sh.c
	$(CC) $(CFLAGS) wrappers.o -o 33noprompt sh.c jobs.c signalstuff.c bSysStuff.c Stringlib.c  

clean:
	rm -rf *.o 33sh 33noprompt

