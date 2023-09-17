; AssemblyGameofLifeStack.asm Final Project Stack for Assembly Class
INCLUDE Irvine32.inc

.data
max_row EQU 20
max_col EQU 40
game_array BYTE max_row*max_col DUP('0'),0
game_temp_array BYTE max_row*max_col DUP('0'),0
game_col BYTE ?
game_row BYTE ?
game_read_v BYTE ?
game_write_v BYTE ?
game_count_v BYTE ?
.code

main PROC
	COMMENT !
	mov game_row, 3
	mov game_col, 4
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 3
	mov game_col, 5
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 3
	mov game_col, 6
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	!
	mov game_row, 7
	mov game_col, 7
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 7
	mov game_col, 6
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 7
	mov game_col, 5
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 6
	mov game_col, 7
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	mov game_row, 5
	mov game_col, 6
	mov game_write_v, 1
	mov esi, OFFSET game_array
	push esi
	movzx eax, game_row
	push eax
	movzx eax, game_col
	push eax
	call game_write_input
	call do_the_mirror_walls
	call game_print
	mov ecx, 200
game_loop:
	mov esi, OFFSET game_array
	push esi
	mov edi, OFFSET game_temp_array
	push edi
	call go_through_entire_array
	call game_print
	mov eax, 15
	call Delay
	loop game_loop
	exit

main ENDP

game_print PROC USES eax ecx edx esi
	mov edx, 0														; this will allow me to print at same part of console
	call Gotoxy														; brings cursor back to beginning
	mov esi, OFFSET game_array										; this will track the game of life array
	mov ecx, max_row												; loops through double loop
Print_1:
	push ecx														; done to do inner loop
	mov ecx, max_col												; give it the cols
Print_2:
	mov eax, '0'													; reset 0
	cmp [esi], al													; compare esi to 0 to see if it is 0
	jz print_zero													; go to print zero if there is zero
	mov eax, red + (red*16)
	call setTextColor
	mov al, ' '														; give 1 in char
	jmp print_to_console											; skip
print_zero:
	mov eax, gray + (gray*16)
	call setTextColor
	mov al, ' '														; give 0 in char
print_to_console:
	call WriteChar													; call the procedure WriteChar
	call WriteChar
	inc esi															; increment position of array
	loop Print_2													; loop until it gets to the max col
	pop ecx															; get back ecx for the outer loop
	call Crlf														; go to next row in console
	loop Print_1													; continue outer loop
	ret
game_print ENDP

game_read PROC
	enter 0,0														; done for stack stuff ebp
	pushad															; save the registers from before
	mov esi, [ebp+8]												; give OFFSET of whatever array we read
	mov eax, 0														; reset eax
	mov ax, [esi]													; move it to ax so I can move it
	mov game_read_v, al												; moved into variable
	popad															; restore registers
	leave															; do stuff to ebp
	ret	4															; leave procedure
game_read ENDP


game_write_input PROC
	enter 0,0														; done for stack stuff edp
	pushad															; save the registers from before
	mov esi, [ebp+16]												; give OFFSET of whatever array we read
	mov eax, 0														; reset eax
	mov ebx, 0														; reset ebx
	mov al, BYTE PTR [ebp+12]										; give al, game_row
	mov bl, max_col													; give bl max_col
	mul bl															; multiply for formula
	mov bl, BYTE PTR [ebp+8]										; give bl game_col
	add ax, bx														; formula i*max_col+j
	add esi, eax													; hand to esi for correct position in array
	mov eax, 0														; reset eax
	.IF game_write_v == 1											; check game_write_v
	mov al, 1														; if 1
	mov BYTE PTR [esi], '1'											; change to '1'
	.ELSE															; else
	mov al, '0'														; change to 0
	mov BYTE PTR [esi], al											; this will make it 0	
	.ENDIF															; end the if statement
	popad															; restore registers
	leave															; do stuff to edp
	ret	12															; leave procedure
game_write_input ENDP


game_write PROC
	enter 0,0														; done for stack stuff edp
	pushad															; save the registers from before
	mov esi, [ebp+8]												; give OFFSET of whatever array we read
	mov eax, 0														; reset eax
	.IF game_write_v == 1											; check game_write_v
	mov al, '1'														; if 1
	mov BYTE PTR [esi], al											; change to '1'
	.ELSE															; else
	mov al, '0'														; change to 0
	mov BYTE PTR [esi], al											; this will make it 0	
	.ENDIF															; end the if statement
	popad															; restore registers
	leave															; do stuff to edp
	ret	4															; leave procedure
game_write ENDP

go_through_entire_array PROC
	enter 0,0
	pushad
	mov esi, [ebp+12]												; OFFSET for game_array
	mov edi, [ebp+8]												; OFFSET for game_temp_array
	mov ecx, max_row*max_col
	mov game_row, 0
	mov game_col, 0
loop_count:
	.IF game_row < 1
		jmp count_skip
	.ELSEIF game_col < 1
		jmp count_skip
	.ELSEIF game_row > (max_row-1)
		jmp count_skip
	.ELSEIF game_col > (max_col-1)
		jmp count_skip
	.ENDIF
	push esi
	call count_neighbors_func
	mov al, game_count_v											; used so game_count_v can be compared
	cmp al, 3
	je its_ALIVE
	cmp al, 4
	je its_SAME
	jne DIE
its_ALIVE:
	push edi
	mov game_write_v, 1
	call game_write
	jmp count_skip
its_SAME:
	push esi
	call game_read
	mov al, game_read_v
	cmp al, '1'
	jne same_die
	push edi
	mov game_write_v, 1
	call game_write
	jmp count_skip
same_die:
	push edi
	mov game_write_v, 0
	call game_write
	jmp count_skip
DIE:
	push edi
	mov game_write_v, 0
	call game_write
	jmp count_skip
count_skip:
	add esi, TYPE BYTE												; this goes to next position in array
	add edi, TYPE BYTE												; this goes to next position in temp_array
	add game_col, 1
	.IF game_col >= max_col
		add game_row, 1
		mov game_col, 0	
	.ENDIF
	dec ecx
	jnz loop_count
	call do_the_mirror_walls
	call copy_over
	popad
	leave
	ret 8
go_through_entire_array ENDP

count_neighbors_func PROC
	enter 0,0
	pushad															; save the registers
	mov esi, [ebp+8]												; this will be OFFSET of game_array at whatever position
																	; that it was currently at
	sub esi, max_col												; start of making it the top left square neighbor
	sub esi, 1														; this makes the position of esi top left square neighbor
	mov game_count_v, 0												; this is reset from previous uses
	push esi
	call game_read													; this will be for top left
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF

	add esi, 1														; position is top middle
	push esi
	call game_read													; this reads top middle
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF

	add esi, 1														; position is top right
	push esi
	call game_read													; this reads top right
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF
	
	add esi, max_col												; position is middle right
	push esi
	call game_read													; this reads middle right
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF

	sub esi, 1														; position is original position
	push esi
	call game_read													; this reads original position
	.IF game_read_v == '1'												
	add game_count_v, 1
	.ENDIF

	sub esi, 1
	push esi
	call game_read													; position is middle left
	.IF game_read_v == '1'											; this reads middle left
	add game_count_v, 1
	.ENDIF

	add esi, max_col												; position is bottom left
	push esi
	call game_read													; this reads bottom left
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF

	add esi, 1														; position is bottom middle
	push esi
	call game_read													; this reads bottom middle
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF

	add esi, 1														; position is bottom right
	push esi
	call game_read													; this reads bottom right
	.IF game_read_v == '1'
	add game_count_v, 1
	.ENDIF
	
	popad
	leave
	ret 4
count_neighbors_func ENDP

copy_over PROC USES ecx esi edi
	mov ecx, max_row*max_col
	mov esi, OFFSET game_array
	mov edi, OFFSET game_temp_array
moving_temp_to_actual:
	mov al, BYTE PTR [edi]
	mov BYTE PTR [esi], al
	add esi, TYPE BYTE
	add edi, TYPE BYTE
	loop moving_temp_to_actual
	ret
copy_over ENDP

do_the_mirror_walls PROC
	pushad
	mov esi, OFFSET game_temp_array				; must be done before any of the them can be copied
	mov ecx, max_row*max_col
	mov game_row, 0
	mov game_col, 0
mirror_read:
	push esi
	mov bl, BYTE PTR [esi]						; used to check what is inside
.IF game_row == 1
	jmp mirror_top_row
.ELSEIF game_col == 1
	jmp mirror_left_col
.ELSEIF game_row == max_row - 2
	jmp mirror_bottom_row
.ELSEIF game_col == max_col - 2
	jmp mirror_right_col
.ELSE
	jmp mirror_leave
.ENDIF
mirror_top_row:									; top row should be fine
	mov ax, (max_row-2)							; formula is essentially (max_row-2)*max_col
	mov dx, max_col								; which ensures we keep the column but move the 
	mul dx										; row to the bottom gutter
	add esi, eax								; this will get me the correct row
	push esi
	.IF bl == '1'
		mov game_write_v, 1
		call game_write
	.ELSE
		mov game_write_v, 0
		call game_write
	.ENDIF
	jmp mirror_leave
mirror_left_col:								; left column should be fine now
	add esi, (max_col - 2)						; left must be sent to right gutter
	push esi
	.IF bl == '1'								; formula at 1 in col, add to columns to get correct gutter
		mov game_write_v, 1
		call game_write
	.ELSE
		mov game_write_v, 0
		call game_write
	.ENDIF
	jmp mirror_leave
mirror_bottom_row:								; bottom row 
	mov esi, OFFSET game_temp_array				; starts from pos 0 in game_array
	movzx eax, game_col							; I want to get to top gutter
	add esi, eax								; since start from pos 0 then just add game_col to get correct pos in top gutter
	push esi
	.IF bl == '1'
		mov game_write_v, 1
		call game_write
	.ELSE
		mov game_write_v, 0
		call game_write
	.ENDIF
	jmp mirror_leave
mirror_right_col:
	sub esi, (max_col - 2)						; right column should be fine now
	push esi
	.IF bl == '1'								; right must be sent to left gutter
		mov game_write_v, 1						; formula at max_col-2, sub to 1 to get correct gutter
		call game_write
	.ELSE
		mov game_write_v, 0
		call game_write
	.ENDIF
mirror_leave:
	pop esi
	add esi, TYPE BYTE							; this goes to next position in array
	add game_col, 1
	.IF game_col >= max_col
		add game_row, 1
		mov game_col, 0	
	.ENDIF
	dec ecx
	jnz mirror_read
	popad
	ret
do_the_mirror_walls ENDP

end main