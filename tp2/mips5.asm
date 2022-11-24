.data 	0x10010000
	#analizar cuantos elementos del vector son igual a 0
	vector:	.word 5,1,2,3,1,2,0
	size:	.word 7
	total:	.space 4
.text
.globl main
main:
	la		$t0,vector($0)
	lw		$t1,size($0)	#t1 = size	
	and		$t2,$t2,0		#t2 = 0
	and		$t4,$t4,0		#t4 = 0, contador de ceros
for:
	bge		$t2,$t1,endfor
	lw		$t3,0($t0)
	bne		$t3,$0,notcero
	addi	$t0,$t0,4
	addi	$t2,$t2,1
	addi	$t4,$t4,1
	j		for
notcero:
	addi	$t2,$t2,1
	addi	$t0,$t0,4
	j		for
endfor:
	sw		$t4,total($0)
	li		$v0,10
	syscall
	
	
