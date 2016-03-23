CC = gcc
SOL = solver
SOL_FULL = solver_full
CFLAGS = -g -Wall -Wextra -std=c99

SOL_OBJS = solver.c

all: solver solver_full

solver: $(SOL_OBJS)
	$(CC) $(CFLAGS) -o $(SOL) $(SOL_OBJS)

solver_full: $(SOL_OBJS)
	$(CC) $(CFLAGS) -o $(SOL_FULL) -DFULL $(SOL_OBJS)

clean:
	rm -f $(SOL) $(SOL_FULL)
