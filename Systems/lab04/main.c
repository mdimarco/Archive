#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "fibs.h"

//Forward declarations
void print_usage(FILE *stream, char *name);
int parse_unsigned_int(char *str, unsigned long int *rptr);
void test_function(const char *name, void (*fptr)(), unsigned long int argsize, void *args);

int main(int argc, char **argv) {
	srand(time(NULL));

	if(argc == 1) {
		fprintf(stderr, "Usage: %s <n> ...\n", argv[0]);
		return 1;
	}

	int arg;
	for(arg = 1; arg<argc; arg++) {
		unsigned long int n;
		if(!parse_unsigned_int(argv[arg], &n)) {
			fprintf(stderr, "Could not parse argument \"%s\"\n", argv[arg]);
			return 1;
		}

		if(n > 47) {  //Overflow occurs starting at n=48
			fprintf(stderr, "n = %lu: Out of range\n", n);
			continue;
		}

		printf("n = %lu\n", n);
		test_function("fibs_recursive", (void (*)())&fibs_recursive, 1, (void*)(&n));
	}

	return 0;
}

/* Test the given function
 *
 * name    - A string representation of the function
 * fptr    - A function pointer
 * argsize - The number of words in the argument array
 * args    - A pointer to the start of an array of words to be copied onto the stack as arguments
 */
void test_function(const char *name, void (*fptr)(), unsigned long int argsize, void *args) {
	pid_t pid = fork();
	if(!pid) {
		if (argsize > 6) {
			printf("Tried to call %s with %lu arguments, expected at most 6\n", name, argsize);
			exit(0);
		}
		printf("%s: ", name);
		fflush(stdout);

		static unsigned long canary; /* Stack corruption test value */
		static unsigned long osp[2]; /* Array for saved stack pointers */
		static unsigned long reg[7]; /* Array for saved registers */

		/* Initialize test values */
		canary = (unsigned long) rand();

		int i;
		for (i = 1; i < 7; i++) {
			reg[i] = (unsigned long) rand();
		}

		/* Extra space to protect the stack and make it unpredictable */
		unsigned long int space = 4 * (32 + (rand() % 11)); 

		static unsigned long info[8]; /* Array for various diagnostic values */

		static unsigned long result; /* The value returned by the function */

		__asm__ __volatile__(
				"movq     %6, %%rax \n\t" // Save current stack pointer to osp[0]
				"movq     %%rsp, (%%rax) \n\t"

				"movq     %2, %%r10 \n\t"
				"testq    %%r10, %%r10 \n\t"
				"jz       1f \n\t"

				"movq     $0x0, %%r11 \n\t" // Put first six arguments in registers
				"movq     %3, %%rax \n\t"
#define PASS_ARGUMENT(reg) \
				"movq     (%%rax, %%r11, 8), %%" # reg " \n\t" \
				"incq     %%r11 \n\t" \
				"cmpq     %%r11, %%r10 \n\t" \
				"jz       1f \n\t"

				PASS_ARGUMENT(rdi) // LOOP UNROLLING FOR GREAT JUSTICE
				PASS_ARGUMENT(rsi) // LOLOLOLOL
				PASS_ARGUMENT(rdx)
				PASS_ARGUMENT(rcx)
				PASS_ARGUMENT(r8)
				PASS_ARGUMENT(r9)
				"1:"

        "movq     %4, %%r10 \n\t" // save function pointer, we're about to mess with rsp

				"movq     %1, %%rax \n\t" // Make space on stack
				"subq     %%rax, %%rsp \n\t"

				"movq     %5, %%rax \n\t" // Push canary on stack
				"pushq    (%%rax) \n\t"

				"movq     %6, %%rax \n\t" // Save current stack pointer to osp[1]
				"movq     %%rsp, 0x8(%%rax) \n\t"

				"movq     %7, %%rax \n\t" // Prepare registers
				"movq     %%rsp, (%%rax) \n\t" // Save %%rsp to reg[0]
				"movq     0x8(%%rax), %%rbp \n\t" // Set %%rbp to reg[1]
				"movq     0x10(%%rax), %%rbx \n\t" // Set %%rbx to reg[2]
				"movq     0x18(%%rax), %%r12 \n\t" // Set %%r12 to reg[3]
				"movq     0x20(%%rax), %%r13 \n\t" // Set %%r13 to reg[4]
				"movq     0x28(%%rax), %%r14 \n\t" // Set %%r14 to reg[5]
				"movq     0x30(%%rax), %%r15 \n\t" // Set %%r15 to reg[6]

				"call     *%%r10 \n\t" // Call function
				"movq     %%rax, %0 \n\t" // Save return value

				"movq     %8, %%rax \n\t" // Save current register states to info
				"movq     %%rsp, (%%rax) \n\t"
				"movq     %%rbp, 0x8(%%rax) \n\t"
				"movq     %%rbx, 0x10(%%rax) \n\t"
				"movq     %%r12, 0x18(%%rax) \n\t"
				"movq     %%r13, 0x20(%%rax) \n\t"
				"movq     %%r14, 0x28(%%rax) \n\t"
				"movq     %%r15, 0x30(%%rax) \n\t"

				"movq     %7, %%rax \n\t" // Restore saved registers
				"movq     (%%rax), %%rsp \n\t"
				"movq     0x8(%%rax), %%rbp \n\t"
				"movq     0x10(%%rax), %%rbx \n\t"
				"movq     0x18(%%rax), %%r12 \n\t"
				"movq     0x20(%%rax), %%r13 \n\t"
				"movq     0x28(%%rax), %%r14 \n\t"
				"movq     0x30(%%rax), %%r15 \n\t"

				"movq    %6, %%rax \n\t" // Set stack pointer to osp[1]
				"movq    0x8(%%rax), %%rsp \n\t"

				"movq    %8, %%rax \n\t" // Save top of stack to info[7]
				"popq    %%rcx \n\t"
				"movq    %%rcx, 0x38(%%rax) \n\t"

				"movq    %6, %%rax \n\t" // Set stack pointer to osp[0]
				"movq    (%%rax), %%rsp \n\t"

				: "=g" (result)  // 0
				: "g" (space),   // 1
				"g" (argsize), // 2
				"g" (args),    // 3
				"g" (fptr),    // 4
				"i" (&canary), // 5
				"i" (osp),     // 6
				"i" (reg),     // 7
				"i" (info)     // 8
							 : "rax", "rcx", "rdx",
							 "rbp", "rbx", "rdi",
							 "rsi", "r8",  "r9",
							 "r10", "r11", "r12",
							 "r13", "r14", "r15",
							 "cc", "memory");

		printf("%lu\n", result);

		if(reg[0]!=info[0])
			printf("Warning: %%rsp corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[0], info[0]);
		if(reg[1]!=info[1])
			printf("Warning: %%rbp corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[1], info[1]);
		if(reg[2]!=info[2])
			printf("Warning: %%rbx corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[2], info[2]);
		if(reg[3]!=info[3])
			printf("Warning: %%r12 corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[3], info[3]);
		if(reg[4]!=info[4])
			printf("Warning: %%r13 corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[4], info[4]);
		if(reg[5]!=info[5])
			printf("Warning: %%r14 corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[5], info[5]);
		if(reg[6]!=info[6])
			printf("Warning: %%r15 corrupted (expected 0x%016lx, got 0x%016lx)\n", reg[6], info[6]);
		if(canary!=info[7])
			printf("Warning: stack corrupted\n");

		fflush(stdout);
		exit(0);
	} else if(pid==-1) {
		perror("Fork failed");
	} else {
		siginfo_t info;
		waitid(P_PID, pid, &info, WEXITED); //Wait for the forked child to terminate
		if(info.si_code == CLD_KILLED) {
			if(info.si_status == SIGSEGV)
				printf("Segmentation fault\n");
			else
				printf("Process killed by signal %d\n", info.si_status);
			fflush(stdout);
		}
	}
}

int parse_unsigned_int(char *str, unsigned long int *rptr) {
	char tmp;
	return (sscanf(str, " %lu %c", rptr, &tmp) == 1);
}
