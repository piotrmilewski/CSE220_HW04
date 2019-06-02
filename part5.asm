.data
filename: .asciiz "C:/Users/piotr/Documents/proj4/game_status3.txt"
.align 2
board: .space 1000
row: .word 5
col: .word 9
player: .byte 'O'

.text
la $a0, board
la $a1, filename
jal load_board

la $a0, board
jal game_status

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

move $a0, $v1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# prints board
la $t9, board
lw $t0, 0($t9)
lw $t1, 4($t9)
lw $t2, 4($t9)
addi $t9, $t9, 8
loop:
	beqz $t0, end
	beqz $t1, nextRow
	lbu $a0, 0($t9)
	li $v0, 11
	syscall
	addi $t1, $t1, -1
	addi $t9, $t9, 1
	j loop
nextRow:
	move $t1, $t2
	addi $t0, $t0, -1
	li $a0, '\n'
	li $v0, 11
	syscall
	j loop
end:
	li $a0, '\n'
	li $v0, 11
	syscall

li $v0, 10
syscall

.include "proj4.asm"