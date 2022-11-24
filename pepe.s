.data 0x10010000
	dato1:	.word 10
	dato2:	.word 0
	res:	.space 1
	
.text
.globl main
main:
	lw	$t8,dato1($0)
	lw	$t9,dato2($0)
	and	$t1,$t1,$0
	and	$t0,$t0,$0
	sle $t0,$t8,$t9
	bne $t8,$0,fineval
	ori	$t0,$0,1
fineval:
	or	$t0,$t0,$t1
	sb	$t0,res($0)
	
	