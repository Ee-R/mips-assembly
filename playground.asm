	.data 0x10010000
listp:	.word 342
	.text
	.globl main
main:	
	la $t0,listp
	lw $t1,listp
	li $v0,10
	syscall

	
	
	
	
