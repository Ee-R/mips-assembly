.data 0x10010000
	#que numeros estan en el rango 
	vector:	.word 1,2,3,4,5,6
	size:	.word 6
	rango1:	.word 3
	rango2:	.word 10
	res:	.space 4
.text
.globl main
main:
	la		$t0,vector($0)
	lw		$t1,size($0)
	lw		$t2,rango1($0)
	lw		$t3,rango2($0)
	and 	$t4,$t4,0		#t4=0, registro palabra
	and		$t5,$t5,0		#t5=0, contador
	and		$t6,$t6,0		#t6=0, contador de numeros en rango
for:
	lw		$t4,0($t0)
	bge		$t5,$t1,endfor
if:
	blt		$t4,$t2,endif
	bgt		$t4,$t3,endif
then:
	addi	$t6,$t6,1
endif:
	addi	$t0,$t0,4
	addi	$t5,$t5,1
	j		for
endfor:
	sw		$t6,res($0)
	li		$v0,10
	syscall

		
	
	