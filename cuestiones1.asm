.data 0x10010000
	data1: .word 20
	data2: .word 10
	res:	.space 1
	
.text
.globl main
main:
	lw $t8,data1($0)
	lw $t9,data2($0)
	and $t0,$t0,$0
	and $t1,$t1,$0
	beq $t8,$0,igual
	ori	$t0,$0,1
igual:
	beq	$t9,$t8,fineval
	ori	$t1,$0,1
fineval:
	and $t0,$t0,$t1
	sb	$t0,res($0)
	
