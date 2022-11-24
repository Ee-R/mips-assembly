.data 0x10010000
	string:	.asciiz "The quick brow fox jumped over the lazy dog"
	caracter:	.byte 'e'
			.align 4
	res:	.space 4
.text
.globl main
main:
	la		$t0,string($0)
	lb		$t1,caracter($0)
	andi	$t2,$t2,0		#contador
	andi	$t3,$t3,0		#guarda byte	
while:
	lb		$t3,0($t0)
	beq		$t3,$0,endwhile
if:
	bne		$t3,$t1,endif
then:
	addi	$t2,$t2,1	
endif:
	addi	$t0,$t0,1
	j		while
endwhile:
	sw		$t2,res($0)
	li		$v0,10
	syscall
	
	
	
	
	
	
	