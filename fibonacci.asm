	.data 0x10010000
mes1:	.asciiz "Find the nth fibonacci: "
mes2:	.asciiz "The result is: "
result:	.space 4
	.text
	.globl main
main:	la $a0,mes1 #print first message
	li $v0,4
	syscall
	
	li $v0,5 #ask for a number
	syscall
	
	addi $a0,$v0,0 #move the number to $a0
	addi $t0,$0,1 #have $t0=1 as a reference
	jal fib
	la $a0,mes2
	li $v0,4
	syscall
	
	addi $a0,$v0,0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
fib:	bne $a0,$0,endif
then:	andi $v0,$v0,0
	jr $ra
	
endif:	bne $a0,$t0,endif2
then2:	addi $v0,$0,1
	jr $ra
	
endif2: addi $sp,$sp,-4
	sw $ra,($sp)
	
	addi $a0,$a0,-1
	jal fib
	addi $a0,$a0,1
	
	addi $sp,$sp,-4
	sw $v0,($sp)
	
	addi $a0,$a0,-2
	jal fib
	addi $a0,$a0,2
	
	lw $s0,($sp)
	addi $sp,$sp,4
	
	add $v0,$v0,$s0
	
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
	