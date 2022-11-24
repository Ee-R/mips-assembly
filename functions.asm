.data

	newArr:	.word	1,2,3,4,5
.text

	main:	
		addi	$a1,$zero,33
		addi	$a2,$zero,18
		
		jal	addvalues
		
		li	$v0,1
		add	$a0,$zero,$v1
		syscall
		
		li	$v0,10
		syscall
		
	addvalues:
		add	$v1,$a1,$a2
		
		jr	$ra
			
	
