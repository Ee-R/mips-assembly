.data	0x10010000
	dato1:	.word 2
	dato2:	.word 10
	dato3:	.word 50
	dato4:	.word 70
	dato5:	.word 54
	res:	.space 4
.text
.globl
main:
	lw		$t0,dato5($0)
	lw		$t1,dato1($0)
	lw		$t2,dato2($0)
	lw		$t3,dato3($0)
	lw		$t4,dato4($0)
	and		$t5,$t5,0		#dejo t5 en cero para guardar el resultado
if:
	blt		$t0,$t1,elseif	#si dato5 >= dato1
	bgt		$t0,$t2,elseif	#si	dato5 <= dato2
then1:
	ori		$t5,$t5,1		#t5 = 1
	j		endif
elseif:
	blt		$t0,$t3,endif	#si dato5 >= dato3
	bge		$t0,$t4,endif	#si dato5 <= dato4
then2:
	ori		$t5,$t5,1		#t5 = 1
	j		endif
endif:
	sw		$t5,res($0)
	li		$v0,10
	syscall

