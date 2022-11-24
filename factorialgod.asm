.data 0x10010000
	message:	.asciiz "Calculate the factorial of: "
	finalMessage:	.asciiz "The result is: "
	userInput:	.word 0
.text
.globl main
main:
	#print message
	la		$a0,message
	li		$v0,4
	syscall
	li		$v0,5
	syscall
	#save number
	addi	$a0,$v0,0
	move	$s0,$a0
	
	jal factorial
	move	$s1,$v0
	#print the final message
	la		$a0,finalMessage
	li		$v0,4
	syscall
	move	$a0,$s1
	li		$v0,1
	syscall
	#end main
	li		$v0,10
	syscall
factorial:
	if:	#a0 == 0
		bne		$a0,$0,endif
	then:
		li		$v0,1
		jr		$ra
	endif:
	subu	$sp,$sp,8
	sw		$s0,0($sp)
	sw		$ra,4($sp)
	move	$s0,$a0
	subi	$a0,$a0,1
	jal		factorial
	mul		$s0,$s0,$v0
	move	$v0,$s0
	lw		$s0,0($sp)
	lw		$ra,4($sp)
	addi	$sp,$sp,8	
	jr		$ra
