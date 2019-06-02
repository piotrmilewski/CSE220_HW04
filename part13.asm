.data
filename: .asciiz "C:/Users/piotr/Documents/proj4/empty10x12.txt"
turns: .asciiz "X0207O0712X0211O0611X0506O0812X0108O0101X1107O0400X1010O0305X0304O0302X0203O0505X1006O0306X0708O0412"
.align 2
board: .space 1000
row: .word 6
col: .word 8
num_turns_to_play: .word 20
player: .byte 'X'

.text
la $a0, board
la $a1, filename
la $a2, turns
lw $a3, num_turns_to_play
jal simulate_game

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
