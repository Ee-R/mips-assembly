	.data
message1: .asciiz "Add a name: "
	.align 2
node_name:.space 10
	.align 4
listp:	.space 4

    .text
    .globl main

main:
    la $a0,message1
    li $v0,4
    syscall
    la $a0,node_name
    li $a1,10
    li $v0,8
    syscall

    jal addnode

    lw $a0,listp
    addi $a0,$a0,4
    li $v0,4
    syscall

    li $v0,10
    syscall


#void addnode(char *name)
    .globl addnode
addnode:
    addi $sp,$sp,-4
    sw $ra,($sp)

    addi $t0,$a0,0
    li $a0,14
    li $v0,9
    syscall
    sw $0,($v0)

    addi $a0,$t0,0
    addi $a1,$v0,4
    jal strcpy
    lw $t1,listp    # t1 = listp
    lw $ra,($sp)
    addi $sp,$sp,4

if: bne $t1,$0,endif # t1 == null
    sw $v0,listp($0)
    jr $ra

endif:  sw $t1,($v0)
    sw $v0,listp($0)
    jr $ra

    .globl strcpy
strcpy:
    addi $sp,$sp,-8
    sw $a0,($sp)
    sw $ra,4($sp)

for:    lb $t0,($a0)

    beq $t0,0x0a,endfor
    beq $t0,$0,endfor

    lb $t0,($a1)
    addi $a0,$a0,1
    addi $a1,$a1,1
    j for

endfor: lw $ra,4($sp)
    lw $a0,($sp)
    addi $sp,$sp,8
    jr $ra

