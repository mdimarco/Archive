.file "fibs.s"					# Linker stuff (you don't need to worry about this)
.text

##################
# fibs_recursive #
##################

.globl fibs_recursive				# Linker stuff
.type	fibs_recursive, @function

fibs_recursive:					# unsigned int fibs_recursive(unsigned int n) {



	##### BASE CASES
	cmp $0, %rdi	#if n == 0
	movq $0, %rax   #   return 0
	je RETURN

	cmp $1, %rdi    #if n == 1
	movq $1, %rax   #   return 1
	je RETURN
	##### END BASE CASES


	##### FIRST RECURSIVE CALL
	pushq %rdi

	decq %rdi
	call fibs_recursive #fib n-1

	popq %rdi
	##### END FIRST RECURSIVE CALL

	movq %rax, %r9
	pushq %r9

	##### SECOND RECURSIVE CALL
	pushq %rdi

	subq $2, %rdi
	call fibs_recursive #fib n-2

	popq %rdi
	##### END SECOND RECURSIVE CALL
	popq %r9
	
	addq %r9, %rax 


  RETURN:

	ret							#
								# }

.size	fibs_recursive, .-fibs_recursive  # Linker stuff

.section	.note.GNU-stack,"",@progbits
