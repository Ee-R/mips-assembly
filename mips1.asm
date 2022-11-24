	.data
message1:.asciiz "La lista es : "
warning1:.asciiz "Empty list\n"
	.align 2
listp:	.word 0
	.align 2
numbers:.word 30,123,45,60,77,91,12,22
	.text
	.globl main
main:
	la $s0,pepin
	li $a0,4
	li $v0,1
	syscall
pepin:
	li $v0,10
	syscall

#void newnode(int)
addnode:
	
	addi $t0,$a0,0
	li $a0,8
	li $v0,9
	syscall
	sw $t0,4($v0)
	sw $0,($v0)
	lw $t1,listp
	
if:	bne $t1,$0,endif #if t0 == null
then:	sw $v0,listp
	jr $ra
	
endif:	sw $t1,($v0)
	sw $v0,listp
	jr $ra

#showList (node*)
showList:
if1:	bne $a0,$0,endif1
then1:	la $a0,warning1
	jr $ra
endif1:	
	addi $sp,$sp,-8
	sw $ra,($sp)
	sw $a0,4($sp)
	
	lw $a0,4($a0)
	li $v0,1
	syscall
	
	lw $ra,($sp)
	lw $a0,4($sp)
	addi $sp,$sp,4
	lw $a0,($a0)
	jal showList
	
