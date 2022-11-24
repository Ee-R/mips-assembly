.data 0x10010000
	message1:		.asciiz "Find factorial of :"
	message2:		.asciiz "The result is: "
	inputNumber:	.word 0
	answer:			.word 0
.text
.globl main
main:
	la		$a0,message1
	li		$v0,4
	syscall
	li		$v0, 5
	syscall
	sw		$v0, inputNumber
	
	lw		$a0, inputNumber
	jal 	factorial
	sw		$v0, answer
	#display message
	la		$a0,message2
	li		$v0,4
	syscall	
	#display answer
	lw		$a0,answer
	li		$v0,1
	syscall
	
	#tell OS end of main
	li 		$v0,10
	syscall
.globl factorial
factorial:
	#save local variables and return variable to the stack
	subu	$sp, $sp,8
	sw		$ra,($sp)
	sw		$s0,4($sp)
	if:	# a0 == 0
		bne		$a0, $0, endif
	then:
		addi	$v0,$0,1
		lw		$ra,0($sp)
		add		$sp,$sp,8
		jr		$ra
	endif:
		move 	$s0,$a0
		sub		$a0,$a0,1
		jal		factorial
		mul		$v0,$v0,$s0
		lw		$ra,($sp)
		jr		$ra
		
