.data 0x10010000
	vector:	.word 6,7,8,9,10,1
	res:	.space 4
.text
	la		$t2,vector($0)
	and		$t3,$t3,0
	li		$t0,0
	li		$t1,5		#t1 = 5?
for:
	bgt		$t0,$t1,endfor
	lw		$t4,0($t2)
	add		$t3,$t3,$t4	#por cada pasada suma 1
	addi	$t2,$t2,4	#salto 4 para ir al otro registro de 4
	addi	$t0,$t0,1
	j		for
endfor:
	sw		$t3,res($0)
	li		$v0,10
	syscall
	
	

		