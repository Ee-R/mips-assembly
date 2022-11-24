.data
	vector:	.word	2,-4,6
			.align 3
	vectorBooleanos:	.space 3
.text
.globl main
main:
	la		$t0,vector($0)
	la 		$t1,vectorBooleanos($0)
	addi	$t2,$0,0	#llevara la cuenta de los loops
	addi	$t3,$0,3	#maxima cantidad de loops
bucle:
	beq		$t2,$t3,final
	lw		$t8,($t0)
	bgez	$t8,salto
	andi	$t9,0
	sb		$t9,($t1)
	addi	$t0,$t0,4
	addi	$t1,$t1,1
	addi	$t2,$t2,1
	j		bucle
salto:
	ori		$t9,1
	sb		$t9,($t1)
	addi	$t0,$t0,4
	addi	$t1,$t1,1
	addi	$t2,$t2,1
	j		bucle
final:
	li		$v0,10
	syscall
	
	
	
	
	
	
	
