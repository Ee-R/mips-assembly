.data
	message:	.asciiz	"El numero es\n"
	num1:	.word 20
.text
	main:	
		jal	displayMessage
		lw	$s1,num1
		jal	addndisplay
		
		#end main
		li	$v0,10
		syscall
		
	displayMessage:
		li	$v0,4
		la	$a0,message
		syscall
		
		jr	$ra
	addndisplay:
		addi	$s6,$s1,4
		sll	$s7,$s6,3
		li	$v0,1
		add	$a0,$s7,$zero
		syscall
		jr	$ra
