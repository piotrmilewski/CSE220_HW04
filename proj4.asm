# CSE 220 Programming Project #4
# Name: Piotr Milewski
# Net ID: pmilewski
# SBU ID: 112291666

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# t0: can modify this starting address of boards
# t1: filename
# t2: can't modify this starting address of boards
# t3: 
# t4: 
# t5: 
# t6: 
# t7: 
# t8: 
# t9: 
load_board:
	# store the original arguments
	move $t0, $a0
	move $t1, $a1
	move $t2, $t0
	# open the file
	move $a0, $t1
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	# check if the file exists
	move $t1, $v0
	bltz $t3, load_board_fileDoesntExist
	# continue if the file exists
	li $t6, 0
	li $t7, 10
	load_board_getNumOfRows:
		addi $t9, $sp, -1
		move $a0, $t1
		move $a1, $t9
		li $a2, 1
		li $v0, 14
		syscall
		lb $t9, 0($t9)
		beq $t9, $t7, load_board_finGetNumOfRows
		addi $t9, $t9, -48
		mul $t6, $t6, $t7
		add $t6, $t6, $t9
		j load_board_getNumOfRows
	load_board_finGetNumOfRows:
		sw $t6, 0($t0)
		addi $t0, $t0, 4 # increment boards to col address
		li $t6, 0
	load_board_getNumOfCols:
		addi $t9, $sp, -1
		move $a0, $t1
		move $a1, $t9
		li $a2, 1
		li $v0, 14
		syscall
		lb $t9, 0($t9)
		beq $t9, $t7, load_board_finGetNumOfCols
		addi $t9, $t9, -48
		mul $t6, $t6, $t7
		add $t6, $t6, $t9
		j load_board_getNumOfCols
	load_board_finGetNumOfCols:
		sw $t6, 0($t0)
		addi $t0, $t0, 4 # increment to where we gonna store the board
	lw $t6, 0($t2) # num of rows
	lw $t7, 4($t2) # num of cols
	li $t3, 0 # num of Xs
	li $t4, 0 # num of Os
	li $t5, 0 # num of invalids
	load_board_getCurrentRow:
		beqz $t6, load_board_fin
		beqz $t7, load_board_getNextRow
		addi $t9, $sp, -1
		move $a0, $t1
		move $a1, $t9
		li $a2, 1
		li $v0, 14
		syscall
		lb $t9, 0($t9)
		li $t8, 88 # X
		beq $t9, $t8, load_board_getCurrentRow_X
		li $t8, 79 # O
		beq $t9, $t8, load_board_getCurrentRow_O
		li $t8, 46
		beq $t9, $t8, load_board_getCurrentRow_cont
		load_board_getCurrentRow_Invalid:
			li $t9, 46
			addi $t5, $t5, 1
			j load_board_getCurrentRow_cont		
		load_board_getCurrentRow_X:
			addi $t3, $t3, 1
			j load_board_getCurrentRow_cont
		load_board_getCurrentRow_O:
			addi $t4, $t4, 1
			j load_board_getCurrentRow_cont		
		load_board_getCurrentRow_cont:
			sb $t9, 0($t0)
			addi $t0, $t0, 1
			addi $t7, $t7, -1
			j load_board_getCurrentRow
	load_board_getNextRow:
		# get rid of newline character
		addi $t9, $sp, -1
		move $a0, $t1
		move $a1, $t9
		li $a2, 1
		li $v0, 14
		syscall
		# reset county bois
		lw $t7, 4($t2)
		addi $t6, $t6, -1
		j load_board_getCurrentRow
	
	load_board_fin:
		sll $t3, $t3, 16
		sll $t4, $t4, 8
		move $v0, $t5
		add $v0, $v0, $t3
		add $v0, $v0, $t3
		j load_board_end
	
	load_board_fileDoesntExist:
		li $v0, -1
		j load_board_end
	
	load_board_end:
    	jr $ra

# t0: # of rows
# t1: # of cols -> offset
# t2: 
# t3: 
# t4: 
# t5: 
# t6: 
# t7: TEMP
# t8: 
# t9: 
get_slot:
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	# invalid cases
	bltz $a1, get_slot_invalid
	bltz $a2, get_slot_invalid
	bge $a1, $t0, get_slot_invalid
	bge $a2, $t1, get_slot_invalid
	addi $a0, $a0, 8
	get_slot_loop:
		beqz $a1, get_slot_fin
		add $a0, $a0, $t1
		addi $a1, $a1, -1
		j get_slot_loop
	
	get_slot_fin:
		add $a0, $a0, $a2
		lb $v0, 0($a0)
		j get_slot_end
		
	get_slot_invalid:
		li $v0, -1
		j get_slot_end
	
	get_slot_end:
	    jr $ra

# t0: # of rows
# t1: # of cols -> offset
# t2: 
# t3: 
# t4: 
# t5: 
# t6: 
# t7: TEMP
# t8: 
# t9: 
set_slot:
    lw $t0, 0($a0)
	lw $t1, 4($a0)
	# invalid cases
	bltz $a1, set_slot_invalid
	bltz $a2, set_slot_invalid
	bge $a1, $t0, set_slot_invalid
	bge $a2, $t1, set_slot_invalid
	addi $a0, $a0, 8
	set_slot_loop:
		beqz $a1, set_slot_fin
		add $a0, $a0, $t1
		addi $a1, $a1, -1
		j set_slot_loop
	
	set_slot_fin:
		add $a0, $a0, $a2
		sb $a3, 0($a0)
		move $v0, $a3
		j set_slot_end
		
	set_slot_invalid:
		li $v0, -1
		j set_slot_end
	
	set_slot_end:
	    jr $ra

# t0: 
# t1: 
# t2: 
# t3: 
# t4: 
# t5: 
# t6: 
# t7: TEMP
# t8: 
# t9: 
place_piece:
	#check if player is 'X' or 'O'
	move $t8, $a3
	li $t7, 79
	beq $t8, $t7, place_piece_cont # player is 'O'
	li $t7, 88
	beq $t8, $t7, place_piece_cont # player is 'X'
	j place_piece_invalid
place_piece_cont:
	# call get_slot
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	# check to see if we can use the slot
	bltz $v0, place_piece_invalid # -1 if either row or col are invalid
	li $t7, 79
	beq $v0, $t7, place_piece_invalid # current spot has a 'O'
	li $t7, 88
	beq $v0, $t7, place_piece_invalid # current spot has a 'X'
	# set the slot to the player piece
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j place_piece_end	
	
	place_piece_invalid:
		li $v0, -1
		j place_piece_end
	
	place_piece_end:
	    jr $ra

game_status:
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	mul $t0, $t1, $t0
	addi $a0, $a0, 8
	li $v0, 0
	li $v1, 0
	li $t1, 79 # 'O'
	li $t2, 88 # 'X'
	game_status_loop:
		beqz $t0, game_status_end
		lb $t3, 0($a0)
		bne $t3, $t1, game_status_loop_checkX
		addi $v1, $v1, 1
		j game_status_loop_reset
		game_status_loop_checkX:
			bne $t3, $t2, game_status_loop_reset
			addi $v0, $v0, 1
			j game_status_loop_reset
		game_status_loop_reset:
			addi $a0, $a0, 1
			addi $t0, $t0, -1
			j game_status_loop
		
	game_status_end:
	    jr $ra

check_horizontal_capture:	
	# call get slot
	# save $a registers
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# call get_slot
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# restore $a registers
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# interpret $v0
	bltz $v0, check_horizontal_capture_invalid # if row or col are invalid
	li $t7, 79
	beq $t7, $v0, check_horizontal_capture_checkPlayer
	li $t7, 88
	beq $t7, $v0, check_horizontal_capture_checkPlayer
	j check_horizontal_capture_invalid # player is neither 'X' nor 'O'
	
	# check if slot at given row/column is equal to player
	check_horizontal_capture_checkPlayer:
	bne $v0, $a3, check_horizontal_capture_invalid # slot at given row/column is not equal to player
	
	# save the $s registers that will be used
	addi $sp, $sp, -28
	sw $s0, 0($sp) # will hold board
	sw $s1, 4($sp) # will hold row
	sw $s2, 8($sp) # will hold col
	sw $s3, 12($sp) # will hold value of col-1/col+1
	sw $s4, 16($sp) # will hold value of col-1/col+1
	sw $s5, 20($sp) # will hold value of col-2/col+2
	sw $s6, 24($sp) # will hold return value ($v0)
	
	# initialize $s6
	li $s6, 0
	
	# LEFT side of board[row][col]
	# get board[row][col-1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, -1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row][col-2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, -2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row][col-3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, -3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_horizontal_capture_rightSide
	bltz $s5, check_horizontal_capture_rightSide
	bltz $v0, check_horizontal_capture_rightSide
	
	# check if left side is: XOO
	li $t7, 79
	bne $s4, $t7, check_horizontal_capture_leftSideXXO
	bne $s5, $t7, check_horizontal_capture_rightSide
	li $t7, 88
	bne $v0, $t7, check_horizontal_capture_rightSide
	j check_horizontal_capture_leftSideGood
	
	# check if left side is OXX
	check_horizontal_capture_leftSideXXO:
	li $t7, 88
	bne $s4, $t7, check_horizontal_capture_rightSide
	bne $s5, $t7, check_horizontal_capture_rightSide
	li $t7, 79
	bne $v0, $t7, check_horizontal_capture_rightSide
	
	check_horizontal_capture_leftSideGood:
	# left side is: XOO
	li $s6, 2
	
	# replace board[row][col-1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a2, $a2, -1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row][col-2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a2, $a2, -2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_horizontal_capture_rightSide:
	# RIGHT side of board[row][col]
	# get board[row][col+1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row][col+2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row][col+3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a2, $a2, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_horizontal_capture_fin
	bltz $s5, check_horizontal_capture_fin
	bltz $v0, check_horizontal_capture_fin
	
	# check if right side is: OOX
	li $t7, 79
	bne $s4, $t7, check_horizontal_capture_rightSideXXO
	bne $s5, $t7, check_horizontal_capture_fin
	li $t7, 88
	bne $v0, $t7, check_horizontal_capture_fin
	j check_horizontal_capture_rightSideGood
	
	# check if right side is XXO
	check_horizontal_capture_rightSideXXO:
	li $t7, 88
	bne $s4, $t7, check_horizontal_capture_fin
	bne $s5, $t7, check_horizontal_capture_fin
	li $t7, 79
	bne $v0, $t7, check_horizontal_capture_fin
	
	check_horizontal_capture_rightSideGood:
	# right side is: OOX
	addi $s6, $s6, 2
	
	# replace board[row][col+1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a2, $a2, 1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row][col+2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a2, $a2, 2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_horizontal_capture_fin:
		# set the $v0
		move $v0, $s6
		# restore the used $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		j check_horizontal_capture_end
	
	check_horizontal_capture_invalid:
		li $v0, -1
		j check_horizontal_capture_end

	check_horizontal_capture_end:
	    jr $ra

check_vertical_capture:
    # call get slot
	# save $a registers
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# call get_slot
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# restore $a registers
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# interpret $v0
	bltz $v0, check_vertical_capture_invalid # if row or col are invalid
	li $t7, 79
	beq $t7, $v0, check_vertical_capture_checkPlayer
	li $t7, 88
	beq $t7, $v0, check_vertical_capture_checkPlayer
	j check_vertical_capture_invalid # player is neither 'X' nor 'O'
	
	# check if slot at given row/column is equal to player
	check_vertical_capture_checkPlayer:
	bne $v0, $a3, check_vertical_capture_invalid # slot at given row/column is not equal to player
	
	# save the $s registers that will be used
	addi $sp, $sp, -28
	sw $s0, 0($sp) # will hold board
	sw $s1, 4($sp) # will hold row
	sw $s2, 8($sp) # will hold col
	sw $s3, 12($sp) # will hold value of col-1/col+1
	sw $s4, 16($sp) # will hold value of col-1/col+1
	sw $s5, 20($sp) # will hold value of col-2/col+2
	sw $s6, 24($sp) # will hold return value ($v0)
	
	# initialize $s6
	li $s6, 0
	
	# TOP side of board[row][col]
	# get board[row-1][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row-2][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row-3][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_vertical_capture_bottomSide
	bltz $s5, check_vertical_capture_bottomSide
	bltz $v0, check_vertical_capture_bottomSide
	
	# check if top side is: XOO
	li $t7, 79
	bne $s4, $t7, check_vertical_capture_topSideXXO
	bne $s5, $t7, check_vertical_capture_bottomSide
	li $t7, 88
	bne $v0, $t7, check_vertical_capture_bottomSide
	j check_vertical_capture_topSideGood
	
	# check if top side is OXX
	check_vertical_capture_topSideXXO:
	li $t7, 88
	bne $s4, $t7, check_vertical_capture_bottomSide
	bne $s5, $t7, check_vertical_capture_bottomSide
	li $t7, 79
	bne $v0, $t7, check_vertical_capture_bottomSide
	
	check_vertical_capture_topSideGood:
	# top side is: XOO
	li $s6, 2
	
	# replace board[row-1][col] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row-2][col] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_vertical_capture_bottomSide:
	# BOTTOM side of board[row][col]
	# get board[row+1][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row+2][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row+3][col]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_vertical_capture_fin
	bltz $s5, check_vertical_capture_fin
	bltz $v0, check_vertical_capture_fin
	
	# check if bottom side is: OOX
	li $t7, 79
	bne $s4, $t7, check_vertical_capture_bottomSideXXO
	bne $s5, $t7, check_vertical_capture_fin
	li $t7, 88
	bne $v0, $t7, check_vertical_capture_fin
	j check_vertical_capture_bottomSideGood
	
	# check if bottom side is XXO
	check_vertical_capture_bottomSideXXO:
	li $t7, 88
	bne $s4, $t7, check_vertical_capture_fin
	bne $s5, $t7, check_vertical_capture_fin
	li $t7, 79
	bne $v0, $t7, check_vertical_capture_fin
	
	check_vertical_capture_bottomSideGood:
	# bottom side is: OOX
	addi $s6, $s6, 2
	
	# replace board[row+1][col] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row+2][col] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_vertical_capture_fin:
		# set the $v0
		move $v0, $s6
		# restore the used $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		j check_vertical_capture_end
	
	check_vertical_capture_invalid:
		li $v0, -1
		j check_vertical_capture_end

	check_vertical_capture_end:
	    jr $ra

check_diagonal_capture:
    # call get slot
	# save $a registers
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# call get_slot
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# restore $a registers
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# interpret $v0
	bltz $v0, check_diagonal_capture_invalid # if row or col are invalid
	li $t7, 79
	beq $t7, $v0, check_diagonal_capture_checkPlayer
	li $t7, 88
	beq $t7, $v0, check_diagonal_capture_checkPlayer
	j check_diagonal_capture_invalid # player is neither 'X' nor 'O'
	
	# check if slot at given row/column is equal to player
	check_diagonal_capture_checkPlayer:
	bne $v0, $a3, check_diagonal_capture_invalid # slot at given row/column is not equal to player
	
	# save the $s registers that will be used
	addi $sp, $sp, -28
	sw $s0, 0($sp) # will hold board
	sw $s1, 4($sp) # will hold row
	sw $s2, 8($sp) # will hold col
	sw $s3, 12($sp) # will hold value of col-1/col+1
	sw $s4, 16($sp) # will hold value of col-1/col+1
	sw $s5, 20($sp) # will hold value of col-2/col+2
	sw $s6, 24($sp) # will hold return value ($v0)
	
	# initialize $s6
	li $s6, 0
	
	# LEFTTOP side of board[row][col]
	# get board[row-1][col-1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -1
	addi $a2, $a2, -1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row-2][col-2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -2
	addi $a2, $a2, -2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row-3][col-3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -3
	addi $a2, $a2, -3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_diagonal_capture_rightTopSide
	bltz $s5, check_diagonal_capture_rightTopSide
	bltz $v0, check_diagonal_capture_rightTopSide
	
	# check if lefttop side is: XOO
	li $t7, 79
	bne $s4, $t7, check_diagonal_capture_leftTopSideXXO
	bne $s5, $t7, check_diagonal_capture_rightTopSide
	li $t7, 88
	bne $v0, $t7, check_diagonal_capture_rightTopSide
	j check_diagonal_capture_leftTopSideGood
	
	# check if leftTop side is OXX
	check_diagonal_capture_leftTopSideXXO:
	li $t7, 88
	bne $s4, $t7, check_diagonal_capture_rightTopSide
	bne $s5, $t7, check_diagonal_capture_rightTopSide
	li $t7, 79
	bne $v0, $t7, check_diagonal_capture_rightTopSide
	
	check_diagonal_capture_leftTopSideGood:
	# left side is: XOO
	li $s6, 2
	
	# replace board[row-1][col-1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -1
	addi $a2, $a2, -1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row-2][col-2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -2
	addi $a2, $a2, -2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_diagonal_capture_rightTopSide:
	# RIGHT side of board[row][col]
	# get board[row-1][col+1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -1
	addi $a2, $a2, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row-2][col+2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -2
	addi $a2, $a2, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row-3][col+3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, -3
	addi $a2, $a2, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_diagonal_capture_leftBottomSide
	bltz $s5, check_diagonal_capture_leftBottomSide
	bltz $v0, check_diagonal_capture_leftBottomSide
	
	# check if right side is: OOX
	li $t7, 79
	bne $s4, $t7, check_diagonal_capture_rightTopSideXXO
	bne $s5, $t7, check_diagonal_capture_leftBottomSide
	li $t7, 88
	bne $v0, $t7, check_diagonal_capture_leftBottomSide
	j check_diagonal_capture_rightTopSideGood
	
	# check if right side is XXO
	check_diagonal_capture_rightTopSideXXO:
	li $t7, 88
	bne $s4, $t7, check_diagonal_capture_leftBottomSide
	bne $s5, $t7, check_diagonal_capture_leftBottomSide
	li $t7, 79
	bne $v0, $t7, check_diagonal_capture_leftBottomSide
	
	check_diagonal_capture_rightTopSideGood:
	# right side is: OOX
	addi $s6, $s6, 2
	
	# replace board[row-1][col+1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -1
	addi $a2, $a2, 1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row-2][col+2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, -2
	addi $a2, $a2, 2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_diagonal_capture_leftBottomSide:
	# RIGHT side of board[row][col]
	# get board[row+1][col-1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 1
	addi $a2, $a2, -1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row+2][col-2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 2
	addi $a2, $a2, -2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row+3][col-3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 3
	addi $a2, $a2, -3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_diagonal_capture_rightBottomSide
	bltz $s5, check_diagonal_capture_rightBottomSide
	bltz $v0, check_diagonal_capture_rightBottomSide
	
	# check if right side is: OOX
	li $t7, 79
	bne $s4, $t7, check_diagonal_capture_leftBottomSideXXO
	bne $s5, $t7, check_diagonal_capture_rightBottomSide
	li $t7, 88
	bne $v0, $t7, check_diagonal_capture_rightBottomSide
	j check_diagonal_capture_leftBottomSideGood
	
	# check if right side is XXO
	check_diagonal_capture_leftBottomSideXXO:
	li $t7, 88
	bne $s4, $t7, check_diagonal_capture_rightBottomSide
	bne $s5, $t7, check_diagonal_capture_rightBottomSide
	li $t7, 79
	bne $v0, $t7, check_diagonal_capture_rightBottomSide
	
	check_diagonal_capture_leftBottomSideGood:
	# right side is: OOX
	addi $s6, $s6, 2
	
	# replace board[row+1][col-1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 1
	addi $a2, $a2, -1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row+2][col-2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 2
	addi $a2, $a2, -2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_diagonal_capture_rightBottomSide:
	# RIGHT side of board[row][col]
	# get board[row+1][col+1]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 1
	addi $a2, $a2, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s4, $v0 # only difference between function calls
	
	# get board[row+2][col+2]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 2
	addi $a2, $a2, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	# set $s to $v0
	move $s5, $v0 # only difference between function calls
	
	# get board[row+3][col+3]
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $a1, $a1, 3
	addi $a2, $a2, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal get_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	# check if any are out of bounds
	bltz $s4, check_diagonal_capture_fin
	bltz $s5, check_diagonal_capture_fin
	bltz $v0, check_diagonal_capture_fin
	
	# check if right side is: OOX
	li $t7, 79
	bne $s4, $t7, check_diagonal_capture_rightBottomSideXXO
	bne $s5, $t7, check_diagonal_capture_fin
	li $t7, 88
	bne $v0, $t7, check_diagonal_capture_fin
	j check_diagonal_capture_rightBottomSideGood
	
	# check if right side is XXO
	check_diagonal_capture_rightBottomSideXXO:
	li $t7, 88
	bne $s4, $t7, check_diagonal_capture_fin
	bne $s5, $t7, check_diagonal_capture_fin
	li $t7, 79
	bne $v0, $t7, check_diagonal_capture_fin
	
	check_diagonal_capture_rightBottomSideGood:
	# right side is: OOX
	addi $s6, $s6, 2
	
	# replace board[row+1][col+1] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 1
	addi $a2, $a2, 1
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	# replace board[row+2][col+2] with a '.'
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $a1, $a1, 2
	addi $a2, $a2, 2
	li $a3, 46
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_slot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	
	check_diagonal_capture_fin:
		# set the $v0
		move $v0, $s6
		# restore the used $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		j check_diagonal_capture_end
	
	check_diagonal_capture_invalid:
		li $v0, -1
		j check_diagonal_capture_end

	check_diagonal_capture_end:
	    jr $ra

check_horizontal_winner:

	# save $s registers that will be used in between function calls
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)

	move $a3, $a1 # move player to argument that won't be touched

	# check for invalid input
	li $t7, 79
	beq $a1, $t7, check_horizontal_winner_cont
	li $t7, 88
	beq $a1, $t7, check_horizontal_winner_cont
	j check_horizontal_winner_invalid
	
	# inputs are valid
	check_horizontal_winner_cont:
	
	# initialize values
	li $s1, 0 # current row & return value
	li $s2, 0 # current column & return value
	lw $s3, 0($a0) # num of rows
	lw $s4, 4($a0) # num of columns
	move $s0, $a0 # board
	
	# loop for checking current value and next 4 values
	check_horizontal_winner_loop:
		# check if out of bounds
		beq $s1, $s3, check_horizontal_winner_invalid
		beq $s2, $s4, check_horizontal_winner_loop_nextRow
	
		# get board[row][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col]
		bne $v0, $a3, check_horizontal_winner_loop_nextValue
		
		# get board[row][col+1]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a2, $a2, 1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col+1]
		bne $v0, $a3, check_horizontal_winner_loop_nextValue
		
		# get board[row][col+2]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a2, $a2, 2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col+2]
		bne $v0, $a3, check_horizontal_winner_loop_nextValue
		
		# get board[row][col+3]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a2, $a2, 3
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col+3]
		bne $v0, $a3, check_horizontal_winner_loop_nextValue
		
		# get board[row][col+4]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a2, $a2, 4
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col+4]
		bne $v0, $a3, check_horizontal_winner_loop_nextValue
		
		# got a row
		j check_horizontal_winner_chickenDinner
		
		check_horizontal_winner_loop_nextValue:
			addi $s2, $s2, 1
			j check_horizontal_winner_loop
			
		check_horizontal_winner_loop_nextRow:
			addi $s1, $s1, 1
			li $s2, 0
			j check_horizontal_winner_loop
	
	
	check_horizontal_winner_chickenDinner:
		move $v0, $s1
		move $v1, $s2
		j check_horizontal_winner_end
	
	check_horizontal_winner_invalid:
		li $v0, -1
		li $v1, -1
		j check_horizontal_winner_end
	
	check_horizontal_winner_end:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
	    jr $ra

check_vertical_winner:

	# save $s registers that will be used in between function calls
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
    
    move $a3, $a1 # move player to argument that won't be touched

	# check for invalid input
	li $t7, 79
	beq $a1, $t7, check_vertical_winner_cont
	li $t7, 88
	beq $a1, $t7, check_vertical_winner_cont
	j check_vertical_winner_invalid
	
	# inputs are valid
	check_vertical_winner_cont:
	
	# initialize values
	li $s1, 0 # current row & return value
	li $s2, 0 # current column & return value
	lw $s3, 0($a0) # num of rows
	lw $s4, 4($a0) # num of columns
	move $s0, $a0 # board
	
	# loop for checking current value and next 4 values
	check_vertical_winner_loop:
		# check if out of bounds
		beq $s1, $s3, check_vertical_winner_invalid
		beq $s2, $s4, check_vertical_winner_loop_nextRow
	
		# get board[row][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col]
		bne $v0, $a3, check_vertical_winner_loop_nextValue
		
		# get board[row+1][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+1][col]
		bne $v0, $a3, check_vertical_winner_loop_nextValue
		
		# get board[row+2][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+2][col]
		bne $v0, $a3, check_vertical_winner_loop_nextValue
		
		# get board[row+3][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 3
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+3][col]
		bne $v0, $a3, check_vertical_winner_loop_nextValue
		
		# get board[row+4][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 4
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+4][col]
		bne $v0, $a3, check_vertical_winner_loop_nextValue
		
		# got a match
		j check_vertical_winner_chickenDinner
		
		check_vertical_winner_loop_nextValue:
			addi $s2, $s2, 1
			j check_vertical_winner_loop
			
		check_vertical_winner_loop_nextRow:
			addi $s1, $s1, 1
			li $s2, 0
			j check_vertical_winner_loop
	
	
	check_vertical_winner_chickenDinner:
		move $v0, $s1
		move $v1, $s2
		j check_vertical_winner_end
	
	check_vertical_winner_invalid:
		li $v0, -1
		li $v1, -1
		j check_vertical_winner_end
	
	check_vertical_winner_end:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
	    jr $ra

check_sw_ne_diagonal_winner:

	# save $s registers that will be used in between function calls
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
    
    move $a3, $a1 # move player to argument that won't be touched

	# check for invalid input
	li $t7, 79
	beq $a1, $t7, check_sw_ne_diagonal_winner_cont
	li $t7, 88
	beq $a1, $t7, check_sw_ne_diagonal_winner_cont
	j check_sw_ne_diagonal_winner_invalid
	
	# inputs are valid
	check_sw_ne_diagonal_winner_cont:
	
	# initialize values
	li $s1, 0 # current row & return value
	li $s2, 0 # current column & return value
	lw $s3, 0($a0) # num of rows
	lw $s4, 4($a0) # num of columns
	move $s0, $a0 # board
	
	# loop for checking current value and next 4 values
	check_sw_ne_diagonal_winner_loop:
		# check if out of bounds
		beq $s2, $s4, check_sw_ne_diagonal_winner_invalid
		beq $s1, $s3, check_sw_ne_diagonal_winner_loop_nextCol
	
		# get board[row][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col]
		bne $v0, $a3, check_sw_ne_diagonal_winner_loop_nextValue
		
		# get board[row-1][col+1]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, -1
		addi $a2, $a2, 1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row-1][col+1]
		bne $v0, $a3, check_sw_ne_diagonal_winner_loop_nextValue
		
		# get board[row-2][col+2]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, -2
		addi $a2, $a2, 2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row-2][col+2]
		bne $v0, $a3, check_sw_ne_diagonal_winner_loop_nextValue
		
		# get board[row-3][col+3]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, -3
		addi $a2, $a2, 3
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row-3][col+3]
		bne $v0, $a3, check_sw_ne_diagonal_winner_loop_nextValue
		
		# get board[row-4][col+4]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, -4
		addi $a2, $a2, 4
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row-4][col+4]
		bne $v0, $a3, check_sw_ne_diagonal_winner_loop_nextValue
		
		# got a match
		j check_sw_ne_diagonal_winner_chickenDinner
		
		check_sw_ne_diagonal_winner_loop_nextValue:
			addi $s1, $s1, 1
			j check_sw_ne_diagonal_winner_loop
			
		check_sw_ne_diagonal_winner_loop_nextCol:
			addi $s2, $s2, 1
			li $s1, 0
			j check_sw_ne_diagonal_winner_loop
	
	
	check_sw_ne_diagonal_winner_chickenDinner:
		move $v0, $s1
		move $v1, $s2
		j check_sw_ne_diagonal_winner_end
	
	check_sw_ne_diagonal_winner_invalid:
		li $v0, -1
		li $v1, -1
		j check_sw_ne_diagonal_winner_end
	
	check_sw_ne_diagonal_winner_end:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
	    jr $ra

check_nw_se_diagonal_winner:
    
    # save $s registers that will be used in between function calls
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
    
    move $a3, $a1 # move player to argument that won't be touched

	# check for invalid input
	li $t7, 79
	beq $a1, $t7, check_nw_se_diagonal_winner_cont
	li $t7, 88
	beq $a1, $t7, check_nw_se_diagonal_winner_cont
	j check_nw_se_diagonal_winner_invalid
	
	# inputs are valid
	check_nw_se_diagonal_winner_cont:
	
	# initialize values
	li $s1, 0 # current row & return value
	li $s2, 0 # current column & return value
	lw $s3, 0($a0) # num of rows
	lw $s4, 4($a0) # num of columns
	move $s0, $a0 # board
	
	# loop for checking current value and next 4 values
	check_nw_se_diagonal_winner_loop:
		# check if out of bounds
		beq $s2, $s4, check_nw_se_diagonal_winner_invalid
		beq $s1, $s3, check_nw_se_diagonal_winner_loop_nextCol
	
		# get board[row][col]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row][col]
		bne $v0, $a3, check_nw_se_diagonal_winner_loop_nextValue
		
		# get board[row+1][col+1]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 1
		addi $a2, $a2, 1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+1][col+1]
		bne $v0, $a3, check_nw_se_diagonal_winner_loop_nextValue
		
		# get board[row+2][col+2]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 2
		addi $a2, $a2, 2
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+2][col+2]
		bne $v0, $a3, check_nw_se_diagonal_winner_loop_nextValue
		
		# get board[row+3][col+3]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 3
		addi $a2, $a2, 3
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+3][col+3]
		bne $v0, $a3, check_nw_se_diagonal_winner_loop_nextValue
		
		# get board[row-4][col+4]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		addi $a1, $a1, 4
		addi $a2, $a2, 4
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_slot
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# check board[row+4][col+4]
		bne $v0, $a3, check_nw_se_diagonal_winner_loop_nextValue
		
		# got a match
		j check_nw_se_diagonal_winner_chickenDinner
		
		check_nw_se_diagonal_winner_loop_nextValue:
			addi $s1, $s1, 1
			j check_nw_se_diagonal_winner_loop
			
		check_nw_se_diagonal_winner_loop_nextCol:
			addi $s2, $s2, 1
			li $s1, 0
			j check_nw_se_diagonal_winner_loop
	
	
	check_nw_se_diagonal_winner_chickenDinner:
		move $v0, $s1
		move $v1, $s2
		j check_nw_se_diagonal_winner_end
	
	check_nw_se_diagonal_winner_invalid:
		li $v0, -1
		li $v1, -1
		j check_nw_se_diagonal_winner_end
	
	check_nw_se_diagonal_winner_end:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
	    jr $ra

simulate_game:
	
	# store values before calling load_board
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# call the function
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal load_board
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# load vack the values after calling load_board
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	# check if board cannot be loaded
	bltz $v0, simulate_game_cannotLoadBoard
	
	# initialize values for loop
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
		
	li $s0, 0 # game_over status | 0 = false, 1 = true
	li $s1, 0 # valid_num_turns
	li $s2, 0 # turn_number
	li $s3, 0 # turns_length
	move $s4, $a0 # a0 board
	move $s5, $a2 # a2 turns
	move $s6, $a3 # a3 num_turns_to_play
	
	move $t0, $s5
	simulate_game_turnLength:
		lbu $t1, 0($t0)
		beqz $t1, simulate_game_turnLengthCalculated
		addi $s3, $s3, 1
		addi $t0, $t0, 1
		j simulate_game_turnLength
	
	simulate_game_turnLengthCalculated:
		li $t7, 5
		div $s3, $t7
		mflo $s3
		
	simulate_game_loop:
		bnez $s0, simulate_game_gameOver
		bge $s1, $s6, simulate_game_badGameOver
		bge $s2, $s3, simulate_game_badGameOver
		
		# extract the next player, row and column from turns[] string
		lbu $t0, 0($s5) # player
		lbu $t1, 1($s5)
		lbu $t2, 2($s5)
		lbu $t3, 3($s5)
		lbu $t4, 4($s5)
		
		addi $t1, $t1, -48
		addi $t2, $t2, -48
		addi $t3, $t3, -48
		addi $t4, $t4, -48
		
		li $t5, 10
		mul $t1, $t1, $t5
		mul $t3, $t3, $t5
		
		add $t1, $t1, $t2 # row
		add $t2, $t3, $t4 # column
		
		# if the player char is invalid, or row or column number is invalid, then skip this turn
		li $t7, 79
		beq $t0, $t7, simulate_game_loop_goodPlayer
		li $t7, 88
		beq $t0, $t7, simulate_game_loop_goodPlayer
		j simulate_game_loop_skipTurn
			
		simulate_game_loop_goodPlayer:
		lw $t8, 0($s4)
		bge $t1, $t8, simulate_game_loop_skipTurn
		lw $t8, 4($s4)
		bge $t2, $t8, simulate_game_loop_skipTurn
		j simulate_game_loop_goodTurn
		
		simulate_game_loop_goodTurn:
		# r = place_piece (board, row, col, player)
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		move $a0, $s4
		move $a1, $t1
		move $a2, $t2
		move $a3, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal place_piece
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		addi $sp, $sp, 12
		
		# if a piece was successfully placed
		bltz $v0, simulate_game_loop_badPiecePlace
		j simulate_game_loop_goodPiecePlace
		
		simulate_game_loop_goodPiecePlace:
		# check_horizontal_capture(board, row, col, player)
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		move $a0, $s4
		move $a1, $t1
		move $a2, $t2
		move $a3, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_horizontal_capture
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		addi $sp, $sp, 12
		
		# check_vertical_capture(board, row, col, player)
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		move $a0, $s4
		move $a1, $t1
		move $a2, $t2
		move $a3, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_vertical_capture
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		addi $sp, $sp, 12
		
		# check_diagonal_capture(board, row, col, player)
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		move $a0, $s4
		move $a1, $t1
		move $a2, $t2
		move $a3, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_diagonal_capture
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		addi $sp, $sp, 12
		
		# r1, r2 = check_horizontal_winner(board, player)
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s4
		move $a1, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_horizontal_winner
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		# if the player won the game
		bgez $v0, simulate_game_loop_win

		# r1, r2 = check_vertical_winner(board, player)
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s4
		move $a1, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_vertical_winner
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		# if the player won the game
		bgez $v0, simulate_game_loop_win
		
		# r1, r2 = check_sw_ne_diagonal_winner(board, player)
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s4
		move $a1, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_sw_ne_diagonal_winner
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		# if the player won the game
		bgez $v0, simulate_game_loop_win
		
		# r1, r2 = check_nw_se_diagonal_winner(board, player)
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s4
		move $a1, $t0
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal check_nw_se_diagonal_winner
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		# if the player won the game
		bgez $v0, simulate_game_loop_win		
		
		simulate_game_loop_badPiecePlace:
		# r1, r2 = game_status(board)
		move $a0, $s4
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal game_status
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		# if game is not over and r1 + r2 equals number of slots in the board
		bnez $s0, simulate_game_loop_nextTurn
		lw $t0, 0($s4)
		lw $t1, 4($s4)
		mul $t0, $t0, $t1 # number of slots in the board
		add $v0, $v0, $v1
		bne $v0, $t0, simulate_game_loop_nextTurn
		li $s0, 1
		li $v1, -1
		j simulate_game_loop_nextTurn
		
		simulate_game_loop_win:
			# record the winner
			move $v1, $t0
			# game_over = True
			li $s0, 1
			j simulate_game_loop_nextTurn
			
		simulate_game_loop_nextTurn:
			addi $s1, $s1, 1
			addi $s2, $s2, 1
			addi $s5, $s5, 5
			j simulate_game_loop		
		
		simulate_game_loop_skipTurn:
			addi $s2, $s2, 1
			addi $s5, $s5, 5
			j simulate_game_loop
	
	simulate_game_badGameOver:
		li $v1, -1
		j simulate_game_gameOver
	
	simulate_game_gameOver:
		move $v0, $s1
		# restore da $s
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		j simulate_game_end
	
	simulate_game_cannotLoadBoard:
		li $v0, 0
		li $v1, -1
		j simulate_game_end

	simulate_game_end:
	    jr $ra
