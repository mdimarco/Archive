CC = gcc
CFLAGS = -Wall -Wextra -g 
SRC = colorize.c
EXECUTABLE = colorize

all: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXECUTABLE)

debug : $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXECUTABLE) -DDEBUG
	
clean:
	rm -f *.o $(EXECUTABLE)
