	.file	"my_atoi.c"
	.text
.globl my_atoi
	.type	my_atoi, @function
my_atoi:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
#####################################################################
# DON'T EDIT ABOVE THIS LINE                                        ######################################################################
# atoi(char *buffer)                                                #
# parse a character string into an integer.                         #
# %rdi contains a pointer to the array of characters (string).      #
# Place your return value in %rax at the end.                       #
#                                                                   #
# Use registers %rax, %rcx, and %r8 - %r11.                         #
#####################################################################
# Write your code here...                                           #
#####################################################################
	movq $0, %r8  #R8 = accumulator
	movq $0, %r9  #R9 = i
	movq $0, %r10 #R10 = arr[i]

 	start_loop:

 		movzbq (%rdi, %r9), %r10 #temp = arr[i]
 		subq $48, %r10 #temp = temp - 48

 		############################
 		#Start Conditionals
 		############################
 		cmp $0, %r10 # if temp < 0
 		jl end_loop # end loop

 		cmp $9, %r10 # if temp > 9
 		jg end_loop # end loop
 		############################
 		#END Conditionals
 		############################


		imul $10, %r8 # accumulator *= 10
		addq %r10, %r8 # accumulator += temp

		inc %r9 # i++

		jmp start_loop #go back to start



	end_loop:

		movq %r8, %rax #return accumulator

##############################
# DON'T EDIT BELOW THIS LINE #
##############################
	popq	%rbx
	leave
	ret

	.size	my_atoi, .-my_atoi
	.ident	"GCC: (Debian 4.4.5-8) 4.4.5"
	.section	.note.GNU-stack,"",@progbits
