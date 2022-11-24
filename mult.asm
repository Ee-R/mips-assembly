.data
	num1: .word 5
	num2: .word 6
	
.text
main:	addi $t0, $zero, 2000
	addi $t1, $zero, 3
	lw $t2,num1
	lw $t3,num2
	
	mul $s1, $t2,$t3
	mult $t0,$t1
	mfhi $s0
	
	li $v0,1
	add $a0, $zero,$s0
	add $a1,$zero,$s1
	syscall