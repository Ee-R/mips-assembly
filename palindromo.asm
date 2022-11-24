.data
	misterious: .asciiz "luzazul"
	palindrome:	.asciiz "palindrome"
	palindroment:	.asciiz "palindroment"
.text
.globl main
main:
	la		$s0,misterious(0)
	move	$s1, $s0
	#we copy a direction and walk it through the final
	
saveLength:
	lb		$t0,s1,
	beqz	$s1, noPalindrome
	
	
		
	
noPalindrome:
	la $a0, palindroment
	li $v0,4
	syscall
	li $v0,10
	syscall
	