.data 0x10010000
	vector:	.byte 0,1,1,1,0
	.align 2
	res:	.space 3
.text
.globl main
main:
	#primera comparacion
	lb	$t0,vector($0)
	lb	$t1,vector+4($0)
	and $t2,$t0,$t1
	sb	$t2,res($0)
	#segunda comparacion
	lb	$t0,vector+1($0)
	lb	$t1,vector+3($0)
	and $t2,$t0,$t1
	sb	$t2,res+1($0)
	#tercera comparacion
	lb	$t0,vector($0)
	lb	$t1,vector+1($0)
	lb	$t2,vector+2($0)
	
	and $t2,$t0,$t1
	sb	$t2,res+2($0)
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	