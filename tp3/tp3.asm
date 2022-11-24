		.data
slist: 		.word 0 # pointer to list to manage smalloc and sfree
cclist: 	.word 0	# pointer to circular category list
wclist: 	.word 0 # pointer to current circular object list
schedv: 	.space 36
menu: 		.ascii "\nColecciones de objetos categorizados\n"
		.ascii "====================================\n"
		.ascii "1-Nueva categoria\n"
		.ascii "2-Siguiente categoria\n"
		.ascii "3-Anterior categoria\n"
		.ascii "4-Listar categorias\n"
		.ascii "5-Borrar categoria actual\n"
		.ascii "6-Anexar objeto a la categoria actual\n"
		.ascii "7-Listar objetos de la categoria\n"
		.ascii "8-Borrar objeto de la categoria\n"
		.ascii "9-Lista de errores\n"
		.ascii "0-Salir\n\n"
		.asciiz "Ingrese la opcion deseada (solo numeros): "
		
errorMessage: 	.asciiz "Error: "
return: 	.asciiz "\n"
catNameMessage:	.asciiz "\nIngrese el nombre de una categoria: "
selCatMessage: 	.asciiz "\nSe ha seleccionado la categoria: "
idObjMessage: 	.asciiz "\nIngrese el ID del objeto a eliminar: "
objNameMessage:	.asciiz "\nIngrese el nombre de un objeto: "
successMessage:	.asciiz "La operación se realizo con exito\n\n"
noObjFound:	.asciiz "\nEl objeto no fue encontrado en la lista\n"

errorList:	.ascii "ERRORES:\n"
		.ascii "201 - No hay categorias para seleccionar\n"
		.ascii "301 - No hay categorias para listar\n"
		.ascii "401 - No hay categorias para borrar\n"
		.ascii "501 - No existen categorias para poder anexar objetos\n"
		.ascii "601 - No hay categorias creadas\n"
		.ascii "602 - No hay objetos para la categoria en curso\n"
		.asciiz "701 - No existen categorias para borrar\n"

flechita:	.asciiz "-->"
notFound:	.asciiz "\nNo se encontro el objeto\n\n"

#newcategory -
#listcategory -
#delcategory 
#nextcategory -
#prevcategory -
#newobject -
#listobjects -
#delobjet -
#falta mejorar como se presenta el output
	.text
	.globl main
main:	
	addi $sp,$sp,-4
	li $t0,9	#schedv options
	sw $t0,($sp)
	jal initialize_schedv
do2:	
	la $a0,menu
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $a0,$v0
	beq $a0,$0,endw2
	blt $a0,$0,do2
	bgt $a0,$t0,do2
	jal manage_schedv
	lw $t0,($sp)
	j do2
endw2:	
	lw $t0,($sp)
	addi $sp,$sp,4
	li $v0,10
	syscall

smalloc:
	lw $t0, slist
	beqz $t0, sbrk
	move $v0, $t0
	lw $t0, 12($t0)
	sw $t0, slist
	sw $0,($v0)
	sw $0,12($v0)
	jr $ra
	
sbrk: 	li $a0, 16 # node size fixed 4 words
	li $v0, 9
	syscall # return node address in v0
	jr $ra
	
sfree: 	lw $t0, slist
	sw $t0, 12($a0)
	sw $a0, slist # $a0 node address in unused list
	jr $ra

# a0: list address
# a1: NULL if category, node address if object 
# a2: *char to category name
# v0: node added address
addnode:
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $a0, 4($sp)	
	jal smalloc
	sw $a1, 4($v0) 	# set node content, if object
	sw $a2, 8($v0)  # $a2 = *char to category name
	lw $a0, 4($sp)
	lw $t0, ($a0) 	# first node address
	beqz $t0, addnode_empty_list
addnode_to_end:
	lw $t1, ($t0) 	# last node address
			# update prev and next pointers of new node
	sw $t1, 0($v0)
	sw $t0, 12($v0)	# update prev and first node to new node
	sw $v0, 12($t1)
	sw $v0, 0($t0)
	j addnode_exit
addnode_empty_list:
	sw $v0, ($a0)
	sw $v0, 0($v0)
	sw $v0, 12($v0)
addnode_exit:
	lw $ra, ($sp)
	addi $sp, $sp, 8
	jr $ra
	
# a0: node address to delete
# a1: list address where deleted node is
delnode:
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $a0, 4($sp)
	lw $a0, 8($a0) 	# get block address
	jal sfree 	# free block
	lw $a0, 4($sp) 	# restore argument a0
	lw $t0, 12($a0) # get next node addres on t0
	beq $a0, $t0, delnode_point_self
	
	lw $t1, 0($a0) 	# get address to prev node
	sw $t1, 0($t0)	# point next node previous, to a0 previous (t1)
	sw $t0, 12($t1) # point previous node next, to a0 next
	lw $t1, 0($a1) 	# get address of the first node of the list
	bne $a0, $t1, delnode_exit # if the list points to the same node that a0
	sw $t0, ($a1) 	# point list to next node
	j delnode_exit
	
delnode_point_self:
	sw $0, ($a1)
delnode_exit:
	jal sfree
	lw $ra,($sp)
	addi $sp, $sp, 8
	jr $ra
	
# a0: address of the message asking for input
# v0: block address allocated with string
getblock:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	li $v0,4
	syscall
	jal smalloc	
	move $a0, $v0
	li $a1, 16
	li $v0, 8
	syscall		
	move $v0, $a0
	lw $ra,($sp)
	addi $sp, $sp, 4
	jr $ra
	
#a0: execute op
initialize_schedv:
	la $t0,schedv
	la $t1,newcategory
	sw $t1,($t0)
	la $t1,next_category
	sw $t1,4($t0)
	la $t1,prev_category
	sw $t1,8($t0)
	la $t1,list_categories
	sw $t1,12($t0)
	la $t1,del_category
	sw $t1,16($t0)
	la $t1,add_object
	sw $t1,20($t0)
	la $t1,list_objects
	sw $t1,24($t0)
	la $t1,del_object
	sw $t1,28($t0)
	la $t1,list_errors
	sw $t1,32($t0)
	jr $ra	

newcategory:
	addiu $sp, $sp, -4
	sw $ra,($sp)
	la $a0, catNameMessage # input category name
	jal getblock
	move $a2, $v0 	# $a2 = *char to category name
	la $a0, cclist 	# $a0 = list
	li $a1, 0 	# $a1 = NULL
	jal addnode
	lw $t0, wclist
	bnez $t0, newcategory_end
	sw $v0, wclist	 # update working list if was NULL
newcategory_end:
	li $v0, 0 	 # return success
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra
	
list_categories:
	lw $t0,cclist
if1:	bne $t0,$0,endif1	#if there are not categories, throw error and return
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,301
	li $v0,1
	syscall
	jr $ra
endif1:	
	move $t1,$t0	#t1 copy of the first node
	
do1:	la $a0,flechita
	li $v0,4
	syscall
	lw $a0,8($t0)
	li $v0,4
	syscall
	la $a0,return
	li $v0,4
	syscall		
	lw $t0,12($t0)		#t0 = t0 next node
while1:	beq $t0,$t1,endw1	#out of the loop if $t0 == $t1
	j do1
endw1:	
	jr $ra		

#a0: user choice (0,1,2,...,8)
manage_schedv:
	#$a0>0 bc a0 comes from the main loop
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $t0,$a0,-1
	la $t1,schedv	#get address of the schedv
	sll $t0,$t0,2	#multiply the choice by 4
	add $t0,$t0,$t1 #add choice*4 + schedv_address
	lw $t0,($t0) 	#save contents of the manipulated address onto t0
	jalr $t0
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
	
next_category:
	lw $t0,wclist 	#get address of the block
	beq $t0,$0,no_wclist
	lw $t1,12($t0)	#get pointer to next block
	j end_select_cat
prev_category:
	lw $t0,wclist 	#get address of the block
	beq $t0,$0,no_wclist
	lw $t1,($t0)	#get pointer to next block
	j end_select_cat
end_select_cat:
	la $a0,selCatMessage
	li $v0,4
	syscall
	sw $t1,wclist
	lw $a0,8($t1)
	li $v0,4
	syscall
	la $a0,return
	li $v0,4
	syscall
	jr $ra	
no_wclist:
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,201
	li $v0,1
	syscall
	jr $ra
	
#remember that addnode has:
	#a0:list address
	#a1:content of the object, NULL if it's a category
	#a2:address of the block name
add_object:
	lw $s0,wclist 			#get the address current block pointed to wcl
	bne $s0,$0,add_object_if_cat 	#a0 is left intact if there are categories
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,501
	li $v0,1
	syscall
	jr $ra
	
add_object_if_cat:
	addi $sp,$sp,-8
	sw $ra,($sp)
	sw $s0,4($sp)
	la $a0,objNameMessage
	jal getblock 	#v0 has the string block
	lw $s0,4($sp)
	
	la $a0,4($s0)	#get the address of the list appended to wclist node
	move $a2,$v0 	#put address of the string block onto a2
	lw $t0,($a0)	#get address of the current block pointed by the category pointer
	
if2:	bne $t0,$0,add_last_object # $a0 == NULL, 
	li $a1,1
	jal addnode
	j end_add_object
	
add_last_object:
	lw $t0,($t0)	#take the address of the previous node
	lw $a1,4($t0)	#take the value of the previous node and add 1 to it
	addi $a1,$a1,1
	jal addnode
end_add_object:
	lw $ra,($sp)
	addi $sp,$sp,8
	jr $ra
#returns the address of the node added

list_objects:
	lw $t0,wclist 	#get first category node
	beq $t0,$0,list_obj_no_cat	#if wcl != null && wcl->objlist != null goto do3
	lw $t1,4($t0)
	move $t2,$t1
	beq $t1,$0,list_obj_no_objs
do3:	
	lw $a0,4($t1) 	# save the index
	li $v0,1
	syscall
	la $a0,flechita
	li $v0,4
	syscall
	lw $a0,8($t1)
	li $v0,4
	syscall
	la $a0,return
	li $v0,4
	syscall
	lw $t1,12($t1)	#point to previous node
w3:	beq $t1,$t2,endw3
	j do3
endw3:	jr $ra

list_obj_no_cat:
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,601
	li $v0,1
	syscall
	jr $ra

list_obj_no_objs:
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,602
	li $v0,1
	syscall
	jr $ra

del_object:
	lw $t0,wclist
	bne $t0,$0,check_if_objlist #if no categories,jump back
	la $a0,errorMessage
	li $v0,4
	syscall
	li $v0,701
	jr $ra
check_if_objlist:
	addi $t5,$t0,4		#get address of the object list
	lw $t0,4($t0)		#$t0 = first node address of the object list
	bne $t0,$0,ask_id	#check if there's a node
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,702
	li $v0,1
	syscall
	jr $ra
ask_id:
	addi $sp,$sp,-4
	sw $ra,($sp)
	la $a0,idObjMessage
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t7,$v0
search_delete_obj:
	move $t1,$t0	#copy the address of the first node to $t1
do4:	
	lw $t6,4($t0)	#check if actual node has the index asked
	beq $t6,$t7,obj_founded	#if so go to obj_founded
	lw $t0,12($t0)	#else change $t0 to next node address
	beq $t1,$t0,obj_not_founded
	j do4
obj_not_founded:
	la $a0,notFound
	li $v0,4
	syscall
	j end_del_obj
obj_founded:
	move $a0,$t0	#address of the node to remove
	move $a1,$t5	#address of the object list
	jal delnode
end_del_obj:
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra

del_category:
	#delnode ya se encarga de reapuntar los nodos
	#lo unico que me interesa es pasarle bien la direccion de las listas
	la $t0,wclist	#wclist address
	lw $t1,($t0)	#wclist node address
	bne $t1,$0,del_cat_objects
	la $a0,errorMessage
	li $v0,4
	syscall
	li $a0,401
	li $v0,1
	syscall
	jr $ra
	
del_cat_objects:
	addi $sp,$sp,-12
	sw $ra,($sp)
	sw $t0,4($sp)	#save address of wclist
	sw $t1,8($sp) 	#save address of wclist node
	addi $t2,$t1,4	#address of the object list
	
while5:	lw $t7,($t2)	#node address of the object list of the cat
	beq $t7,$0,del_current_cat	#if the list has no nodes go to delete cat
	move $a0,$t7	#set node address
	move $a1,$t2	#set list address
	jal delnode	#remove node of the list
	j while5
	
del_current_cat:
	#change cclist to next category
	#just in case that there's more than one category.
	#If wclist and cclist points to the same block and
	#we remove that block, wclist would be changed with
	#delnode but cclist would point to null 
	lw $t0,cclist 	#node address of cclist
	lw $t0,12($t0)	#node address of next node
	sw $t0,cclist	#set cclist to next node

	lw $a0,8($sp) 	#set wclist node address
	lw $a1,4($sp) 	#set wclist address
	jal delnode	#delete current category from 
			#wclist and set wclist to next node
	lw $t0,4($sp)
	lw $t1,($t0) 	#check the content of wclist
	bne $t1,$0,end_del_cat	#if wclist is null then there's no categories, thus set cclist to null
	sw $0,cclist
	j end_del_cat
end_del_cat:
	lw $ra,($sp)
	addi $sp,$sp,12
	jr $ra
	
list_errors:
	la $a0,errorList
	li $v0,4
	syscall
	jr $ra
	
	
		
	
	
	
	
	
	
	
	
	
