.data
.text
main:	addi	$t0,$zero,128
	addi	$t1,$zero,5
	
	#div	$s0,$t0,$t1	#using three registers
	div	$t0,$t1	#setting lo register to the quotient and hi to the rest
	#div	$s2,$t0,8	#using the number 8
	
	mflo	$s1		#moving the quotient from lo to s1
	mfhi	$s3		#moving the remainder from hi to s3
	
	li	$v0,1
	add	$a0,$zero,$s3

	syscall