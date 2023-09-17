; AssemblyGameofLifeStack2ndEdition.asm Final Project Stack for Assembly Class
INCLUDE Irvine32.inc
ExitProcess PROTO, dwExitCode:dword
Read_Cell PROTO arrayPosition:DWORD
Write_Cell PROTO arrayPosition:DWORD, game_write_v:BYTE
Write_Cell_Input PROTO game_row_input:BYTE, game_col_input:BYTE, game_write_v:BYTE
Count_Neighbors PROTO arrayPosition:DWORD
Presets PROTO chosen:DWORD

max_rows EQU 25
max_cols EQU 60

.data

game_array BYTE max_rows*max_cols DUP('0'),0
game_temp_array BYTE max_rows*max_cols DUP('0'),0
game_read_v BYTE ?
game_count_v BYTE ?
game_row BYTE ?
game_col BYTE ?


game_prompt_1 BYTE "(w) Move Up (a) Move Left (s) Move Down (d) Move Right "
			  BYTE "(Space) Toggle Cell (g) Start Game",0
game_prompt_2 BYTE "You may use presets by moving your cursor to where you want the preset pattern.",0Dh,0ah
			  BYTE "Then input a number from 1-5 to get a preset pattern.",0Dh,0ah
			  BYTE "(1) Blinker	(2) Glider	(3) Toad	(4) Gosper Glider Gun ",0


.code
main PROC
call Console_Control
	exit
main ENDP

game_print PROC USES eax ecx edx esi
	mov edx, 0														; this will allow me to print at same part of console
	call Gotoxy														; brings cursor back to beginning
	mov esi, OFFSET game_array										; this will track the game of life array
	mov ecx, max_rows												; loops through double loop
	mov game_row, 0
	mov game_col, 0
Print_1:
	push ecx														; done to do inner loop
	mov ecx, max_cols												; give it the cols
Print_2:
	.IF game_row < 1												; this loop is used to ensure the array does not go through walls
		mov eax, blue+(blue*16)
		call setTextColor
		mov al, ' '
		jmp print_to_console										
	.ELSEIF game_col < 1										
		mov eax, blue+(blue*16)
		call setTextColor
		mov al, ' '
		jmp print_to_console
	.ELSEIF game_row > (max_rows-2)
		mov eax, blue+(blue*16)
		call setTextColor
		mov al, ' '
		jmp print_to_console
	.ELSEIF game_col > (max_cols-2)
		mov eax, blue+(blue*16)
		call setTextColor
		mov al, ' '
		jmp print_to_console
	.ENDIF
	
	mov eax, '0'													; reset 0
	cmp [esi], al													; compare esi to 0 to see if it is 0
	jz print_zero													; go to print zero if there is zero
	mov eax, red + (red*16)
	call setTextColor
	mov al, ' '														; give 1 in char
	jmp print_to_console											; skip
print_zero:
	mov eax, black + (black*16)
	call setTextColor
	mov al, ' '														; give 0 in char
print_to_console:
	call WriteChar													; call the procedure WriteChar
	call WriteChar
	inc esi															; increment position of array
	add game_col, 1													; increases game_col every time
		.IF game_col >= max_cols									; unless it is greater than max
			add game_row, 1											; where row is incremented
			mov game_col, 0											; and column is reset to 0
		.ENDIF
	dec ecx
	jnz Print_2														; loop until it gets to the max col
	pop ecx															; get back ecx for the outer loop
	call Crlf														; go to next row in console
	dec ecx
	jnz Print_1														; continue outer loop
	ret
game_print ENDP


COMMENT !
Uses INVOKE which will be given the address of the position that wants to be read
!
Read_Cell PROC USES eax arrayPosition:DWORD
	mov esi, arrayPosition											; this is the offset of whatever array given
	mov eax, 0														; used for this function
	mov al, [esi]													; move it to ax so I can move it
	mov game_read_v, al												; moved into variable
	ret
Read_Cell ENDP

COMMENT !
Uses INVOKE which will be given the address of the position that wants to be written on
!
Write_Cell PROC USES eax arrayPosition:DWORD, game_write_v:BYTE
	mov esi, arrayPosition
	mov eax,0
	mov al, game_write_v
	.IF al == 1														; check game_write_v
		mov al, '1'													; if 1
		mov BYTE PTR [esi], al										; change to '1'
	.ELSE															; else
		mov al, '0'													; change to 0
		mov BYTE PTR [esi], al										; this will make it 0	
	.ENDIF															; end the if statement

	ret
Write_Cell ENDP

COMMENT !
Uses INVOKE which will be given the row and col that is to be written on
This is mainly used in the presets, and in the beginning
!
Write_Cell_Input PROC USES eax ebx game_row_input:BYTE, game_col_input:BYTE, game_write_v:BYTE
	mov esi, OFFSET game_array										; this is used for presets, so it needs original array
	mov eax, 0														; reset eax
	mov ebx, 0														; reset ebx
	mov al, game_row_input											; give al, game_row
	mov bl, max_cols												; give bl max_cols
	mul bl															; multiply for formula
	mov bl, game_col_input											; give bl game_col
	add ax, bx														; formula i*max_cols+j
	add esi, eax													; hand to esi for correct position in array
	mov eax, 0														; reset eax
	.IF game_write_v == 1											; check game_write_v
	mov al, '1'														; if 1
	mov BYTE PTR [esi], al											; change to '1'
	.ELSE															; else
	mov al, '0'														; change to 0
	mov BYTE PTR [esi], al											; this will make it 0	
	.ENDIF															; end the if statement


	ret
Write_Cell_Input ENDP

Go_Through_Entire_Array PROC
	pushad
	mov esi, OFFSET game_array										; OFFSET for game_array
	mov edi, OFFSET game_temp_array									; OFFSET for game_temp_array
	mov ecx, max_rows*max_cols										; must loop through entire array
	call Do_The_Mirror_Walls
	mov game_row, 0													; these must start at 0 in order to go through entire
	mov game_col, 0													; array
	
	loop_count:
		push esi
		.IF game_row < 1											; this loop is used to ensure the array does not go through walls
			jmp count_skip											; if it is in the walls/gutters
		.ELSEIF game_col < 1										; skip to the end
			jmp count_skip
		.ELSEIF game_row > (max_rows-2)
			jmp count_skip
		.ELSEIF game_col > (max_cols-2)
			jmp count_skip
		.ENDIF
		INVOKE Count_Neighbors, esi									; if in the array, then this will count the neighbors, esi here is not the right esi
			.IF game_count_v == 3									; if at 3
				INVOKE Write_Cell, edi, 1							; then this cell becomes alive
				jmp count_skip										
			.ELSEIF game_count_v == 4								; if at 4
				INVOKE Read_Cell, esi								; cell stays the same
				.IF game_read_v == '1'
					INVOKE Write_Cell, edi, 1
					jmp count_skip
				.ELSE
					INVOKE Write_Cell, edi, 0
					jmp count_skip
				.ENDIF
			.ELSE													; otherwise
				INVOKE Write_Cell, edi, 0							; cell dies
				jmp count_skip
			.ENDIF
	count_skip:
		pop esi
		add esi, TYPE BYTE											; this goes to next position in array
		add edi, TYPE BYTE											; this goes to next position in temp_array
		add game_col, 1												; increases game_col every time
		.IF game_col >= max_cols									; unless it is greater than max
			add game_row, 1											; where row is incremented
			mov game_col, 0											; and column is reset to 0
		.ENDIF
	dec ecx															; used in case loop cannot be run due to passing byte requirement
	jnz loop_count													; replaces loop

	call Do_The_Mirror_Walls										; calls mirror after count neighbors
	call Copy_Over													; then copies it over from temp to actual
	popad															; restore the registers used
	ret
Go_Through_Entire_Array ENDP

Count_Neighbors PROC USES esi arrayPosition:DWORD
	mov esi, arrayPosition											; this gives esi the position in game_array

	mov game_count_v, 0												; this is reset from previous uses
	sub esi, max_cols												; start of making it the top left square neighbor
	sub esi, 1														; this makes the position of esi top left square neighbor
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, 1														; position is top middle
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, 1														; position is top right
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, max_cols												; position is middle right
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	sub esi, 1														; position is original position
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	sub esi, 1														; position is middle left
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, max_cols												; position is bottom left
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, 1														; position is bottom middle
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF

	add esi, 1														; position is bottom right
	INVOKE Read_Cell, esi											; this calls the function with esi as a parameter
	.IF game_read_v == '1'
		add game_count_v, 1
	.ENDIF


	ret
Count_Neighbors ENDP

Copy_Over PROC USES ecx esi edi
	mov ecx, max_rows*max_cols										; needs to loop through entire array
	mov esi, OFFSET game_array										; position 0 of game_array
	mov edi, OFFSET game_temp_array									; position 0 of game_temp_array
moving_temp_to_actual:												; loop used to go through everything
	mov eax, 0														; reset just in case
	mov al, BYTE PTR [edi]											; moves data from temp to actual
	mov BYTE PTR [esi], al
	add esi, TYPE BYTE												; increment position of game_array
	add edi, TYPE BYTE												; increment position of game_temp_array
	loop moving_temp_to_actual
	ret
copy_over ENDP

Do_The_Mirror_Walls PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET game_temp_array									; must be done before any of the them can be copied
	mov ecx, max_rows*max_cols
	mov game_row, 0
	mov game_col, 0
mirror_read:
	push esi														; done every time to keep the same esi for later
	mov bl, BYTE PTR [esi]											; used to check what is inside
																	; currently commented so I can make sure nothing is outside of this
	COMMENT !
	Top row to bottom gutter
	!
	.IF game_row == 1
		push esi
		mov eax, 0														; this must be 0 to ensure nothing happens to esi
		mov ax, (max_rows-2)											; formula is essentially (max_rows-2)*max_cols
		mov dx, max_cols												; which ensures we keep the column but move the 
		mul dx															; row to the bottom gutter
		add esi, eax													; this will get me the correct row
		.IF bl == '1'
		INVOKE Write_Cell, esi, 1									; if one write one to bottom gutter
		.ELSE
		INVOKE Write_Cell, esi, 0									; else write zero
		.ENDIF
		pop esi
	.ENDIF

	COMMENT !
	Left column to right gutter
	!
	.IF game_col == 1
		push esi
		add esi, (max_cols - 2)											; left must be sent to right gutter
		.IF bl == '1'													; formula at 1 in col, add to columns to get correct gutter
			INVOKE Write_Cell, esi, 1									; if one write one to right gutter
		.ELSE
			INVOKE Write_Cell, esi, 0									; else write zero
		.ENDIF
		pop esi
	.ENDIF

	COMMENT !
	Bottom row to top gutter
	!
	.IF game_row == max_rows - 2
		push esi
		mov esi, OFFSET game_temp_array									; starts from pos 0 in game_array
		movzx eax, game_col												; I want to get to top gutter
		add esi, eax													; pos 0 then just add game_col to get correct pos in top gutter
		.IF bl == '1'
			INVOKE Write_Cell, esi, 1									; if one write one to top gutter
		.ELSE
			INVOKE Write_Cell, esi, 0									; else write zero
		.ENDIF
		pop esi
	.ENDIF

	COMMENT !
	Right column to left gutter
	!
	.IF game_col == max_cols - 2
		push esi
		sub esi, (max_cols - 2)											; right column should be fine now
		.IF bl == '1'													; right must be sent to left gutter
			INVOKE Write_Cell, esi, 1									; formula at max_cols-2, sub to 1 to get correct gutter
		.ELSE
			INVOKE Write_Cell, esi, 0
		.ENDIF
		pop esi
	.ENDIF

mirror_continue:
	.IF game_row == 1 && game_col == 1
		jmp mirror_top_left_corner
	.ELSEIF game_row == 1 && game_col == (max_cols-2)
		jmp mirror_top_right_corner
	.ELSEIF game_row == (max_rows-2) && game_col == 1
		jmp mirror_bottom_left_corner
	.ELSEIF game_row == (max_rows-2) && game_col == (max_cols-2)
		jmp mirror_bottom_right_corner
	.ELSE
		jmp mirror_leave
	.ENDIF

mirror_top_left_corner:												; 
	push esi
	mov esi, OFFSET game_temp_array
	mov eax, 0														; we start at (1,1)
	mov ax, max_rows												; then we add (max_rows*max_cols)
	mov dx, max_cols												; that -1
	mul dx
	sub eax, 1														; (max_rows-1,max_rows-1)
	add esi, eax													; make esi the correct position
	.IF bl == '1'
		INVOKE Write_Cell, esi, 1									; if one write one to bottom gutter
	.ELSE
		INVOKE Write_Cell, esi, 0									; else write zero
	.ENDIF
	pop esi
	jmp mirror_leave

mirror_top_right_corner:
	push esi
	mov esi, OFFSET game_temp_array									; we want to go from (1, max_rows-2)
	mov eax, 0														; start at (0,0), which means 
	mov ax, (max_rows-1)											; we add (max_rows-1)*max_cols
	mov dx, max_cols												; 
	mul dx															; (max_rows-1, 0)
	add esi, eax													; make esi the correct position
	.IF bl == '1'
		INVOKE Write_Cell, esi, 1									; if one write one to bottom gutter
	.ELSE
		INVOKE Write_Cell, esi, 0									; else write zero
	.ENDIF
	pop esi
	jmp mirror_leave

mirror_bottom_left_corner:
	push esi
	mov esi, OFFSET game_temp_array									; want to go to top right corner gutter
	mov eax, max_cols-1												; pos 0 + max_cols-1
	add esi, eax													; make esi correct position
	.IF bl == '1'
		INVOKE Write_Cell, esi, 1									; if one write one to bottom gutter
	.ELSE
		INVOKE Write_Cell, esi, 0									; else write zero
	.ENDIF
	pop esi
	jmp mirror_leave

mirror_bottom_right_corner:
	push esi
	mov esi, OFFSET game_temp_array									; we want to get pos 0
	.IF bl == '1'
		INVOKE Write_Cell, esi, 1									; if one write one to bottom gutter
	.ELSE
		INVOKE Write_Cell, esi, 0									; else write zero
	.ENDIF
	pop esi
	jmp mirror_leave
mirror_leave:
	pop esi
	add esi, TYPE BYTE												; this goes to next position in array
	add game_col, 1													; makes sure game_row and game_col are correct
	.IF game_col >= max_cols										; when choosing correct part of gutter
		add game_row, 1
		mov game_col, 0	
	.ENDIF
	dec ecx
	jnz mirror_read

	ret
Do_The_Mirror_Walls ENDP

Menu_Instructions PROC USES eax edx
	mov eax, white+(black*16)
	call setTextColor
	mov edx, OFFSET game_prompt_1
	call WriteString
	call Crlf
	mov edx, OFFSET game_prompt_2
	call WriteString
	ret
Menu_Instructions ENDP

Console_Control PROC USES eax
	mov edx, 0
	call Gotoxy
	call game_print
	call Menu_Instructions
	mov esi, OFFSET game_array
	mov edx, 0
	call Gotoxy
Console_loop:
	call ReadChar
	.IF al == 'w'
		sub dh, 1													; go up by 1 row
		sub esi, max_cols											; this will make esi increment by a row
		call Gotoxy
	.ELSEIF al == 'a'
		sub dl, 2													; go left by 1 col
		sub esi, 1													; move position of esi down 1 for array
		call Gotoxy
	.ELSEIF al == 's'
		add dh, 1													; go down by 1 row
		add esi, max_cols
		call Gotoxy
	.ELSEIF al == 'd'
		add dl, 2													; go right by 1 col
		add esi, 1
		call Gotoxy
	.ELSEIF al == ' '
		INVOKE Read_Cell, esi
		.IF game_read_v == '1'
			INVOKE Write_Cell, esi, 0
		.ELSE
			INVOKE Write_Cell, esi, 1
		.ENDIF
		call game_print
	.ELSEIF al == 'g'
		call Do_The_Mirror_Walls
	Console_Game_Loop:
		call Go_Through_Entire_Array								; the operation that goes through the processes
		call game_print												; the print function
		call Menu_Instructions										; show how to operate in the array
		jmp Console_Game_Loop
	.ELSEIF al == '1'												; blinker
		push esi
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, 2
		INVOKE Write_Cell, esi, 1
		call game_print
		pop esi
	.ELSEIF al == '2'												; glider
		push esi
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, 2
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		call game_print
		pop esi
	.ELSEIF al == '3'												; toad
		push esi
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, 2
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, 2
		INVOKE Write_Cell, esi, 1
		call game_print
		pop esi
	.ELSEIF al == '4'												; Gosper Glider Gun
		push esi
		INVOKE Write_Cell, esi, 1									; beginning of block on left
		add esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, 1													
		INVOKE Write_Cell, esi, 1									; end of block on left

		add esi, 10													; start of left part
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, (max_cols*2)
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		add esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		add esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, 1
		INVOKE Write_Cell, esi, 1
		sub esi, (max_cols*6)
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, 4
		INVOKE Write_Cell, esi, 1
		add esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, 2
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, 1
		add esi, (max_cols*2)
		INVOKE Write_Cell, esi, 1
		add esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, 1
		INVOKE Write_Cell, esi, 1									; end of left part

		add esi, 3													; start of right part
		sub esi, max_cols	
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, 1
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, (max_cols*4)
		INVOKE Write_Cell, esi, 1
		add esi, 2
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		add esi, (max_cols*5)
		INVOKE Write_Cell, esi, 1
		add esi, max_cols
		INVOKE Write_Cell, esi, 1									; end of right part

		add esi, 10													; start of right block
		sub esi, (max_cols*3)
		INVOKE Write_Cell, esi, 1
		add esi, 1
		INVOKE Write_Cell, esi, 1
		sub esi, max_cols
		INVOKE Write_Cell, esi, 1
		sub esi, 1
		INVOKE Write_Cell, esi, 1



		call game_print
		pop esi
	.ENDIF
	jmp Console_Loop
	ret
Console_Control ENDP

end main