.data	0x10010000
	vector:	.word -1,-4,-5,-2
			.align 2
	variable:	.space 1
	#debe retornar 1 si todos los elementos son negativos, 0 en caso contrario
.text
.globl main
main:
	lw		$t8,vector($0)
	andi	$t0,$t0,0
	andi	$t1,$t1,0	
	slt		$t0,$t8,$0
	beq		$t0,$0,igual1
	and		$t1,$t0,1
igual1:
	lw		$t8,vector+4($0)
	slt		$t0,$t8,$0
	beq		$t0,$0,igual2
	and		$t1,1
igual2:
	lw		$t8,vector+8($0)
	slt		$t0,$t8,$0
	beq		$t0,$0,igual3
	and		$t1,1
igual3:
	lw		$t8,vector+12($0)
	slt		$t0,$t8,$0
	beq		$t0,$0,fineval
	and		$t1,1
fineval:
	and		$t1,$t1,1
	sb		$t1,variable
	li		$v0,10
	syscall
	
		
	
	
	
	
