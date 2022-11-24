.data
	newLine:	.asciiz "\n"
	randNum:	.word 452
.text
	main:
		addi	$s0,$zero,22	#add 22 to the $s0 register
		jal	increaseNum		#jump and set program c to increaseNum
		
		li	$v0,4
		la	$a0,newLine	
		syscall
		
		jal	printTheValue
		#end of program
		li	$v0,10
		syscall
	
	increaseNum:
		addi	$sp,$sp,-4		#set stack to +4 bytes(since it goes "down", by convention negative numbers are added)
		sw	$s0,0($sp)		#set the value of $s0 on the addres of the stack pointer which occupies 4 bytes now
		lw	$t0,randNum		#load the value randNum from the ram onto the register t0
		add	$s0,$s0,$t0		#add on the register $s0, the sum between $s0 and $t0	
		
		jal	printTheValue
		
		lw	$s0,0($sp)		#save the previously stored in ram value (line 21)
		addi	$sp,$sp,4		
		jr	$ra
		
	printTheValue:
		li	$v0,1			#prepare the register to issue a call to the system to print an int
		move	$a0,$s0		#move the value of $s0 to $a0
		syscall
		jr	$ra
		