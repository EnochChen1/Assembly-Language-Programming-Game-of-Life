; AssemblyGameOfLife.asm Final Project for Assembly Class
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
max_row EQU 10
max_col EQU 10
game_array BYTE max_row*max_col DUP(0)
game_row BYTE ?
game_col BYTE ?
game_write BYTE ?
game_read WORD ?
game_temp_array BYTE max_row*max_col DUP(0)
game_temp_row BYTE ?
game_temp_col BYTE ?
.code
main PROC
	call print_array
	mov esi, OFFSET game_array
	mov game_row, 3
	mov game_col, 4
	mov game_write, 1
	call write_array
	call read_array
	call print_array
	call count_neighbors
	INVOKE ExitProcess,0
main ENDP


COMMENT !
The print function prints out an array onto the console. It looks at the values of the array and
just prints it out.
!
print_array PROC
	call Clrscr														; in case there was more from before
	pushad
	mov esi, OFFSET game_array										; gets the position in array
	mov ecx, max_row
Print_L1:
	push ecx														; save ecx in the stack
	mov ecx, max_col												; double loop 
Print_L2:
	mov eax, 0														; make eax 0 to compare
	cmp [esi], al													; memory to 0
	jz zero_init													; if zero go to zero
	mov al, '1'														; if not zero, make al char 1
	jmp print_to_console											; jump to next part
zero_init:															; if zero
	mov al, '0'														; change it to char 0
print_to_console:													; next part
	call WriteChar													; call the procedure WriteChar
	inc esi															; increment position of array
	loop Print_L2													; loop until it gets to the max col
	pop ecx															; get back ecx for the outer loop
	call Crlf														; go to next row in console
	loop Print_L1													; continue outer loop
	popad
	ret
print_array ENDP

COMMENT !
The read function checks the positions of the row and col that 
should be read, and then it reads and returns the location in 
game_read
!

read_array PROC
	mov esi, OFFSET game_array
	mov eax, 0														; to reset eax for this function
	mov ebx, 0														; to reset ebx for this function
	mov al, game_row												; this is i for the formula i*max_row+j
	mov bl, max_row													; this is max row
	mul bl															; i*max_row, answer goes into ax
	mov bl, game_col												; this is going to be j
	add ax, bx														; i*max_row+j
	add esi, eax													; moves esi to that position
	mov ax, [esi]
	mov game_read, ax
ret
read_array ENDP

COMMENT !
The write function obtains the positions of the row and col that 
should be written and how much columns the array has. 
Then it writes into the location and changes it.
!
write_array PROC
	pushad															; i = current row, j = current column
	mov eax, 0														; to reset eax for this function
	mov ebx, 0														; to reset ebx for this function
	mov al, game_row												; this is i for the formula i*max_row+j
	mov bl, max_row													; this is max row
	mul bl															; i*max_row, answer goes into ax
	mov bl, game_col												; this is going to be j
	add ax, bx														; i*max_row+j
	add esi, eax													; moves esi to that position
	mov eax, 0														; reset to not change the array
	mov ebx, 0														; reset to not change the array
	.IF game_write == 1
	mov al, 1
	mov BYTE PTR [esi], al
	.ELSE
	mov al, 0
	mov BYTE PTR [esi], al
	.ENDIF
	popad
	ret
write_array ENDP

COMMENT !
Count neighbors function which will allow me to check the neighbors of a specific cell in the entire array.
This will allow me to check and decide what to do with it, using another function
!
count_neighbors PROC
.data
	neighbor_count DWORD 0

.code
	mov esi, OFFSET game_array
	mov edi, OFFSET game_temp_array
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
	
	mov game_temp_row,(game_row - 1)
	mov game_temp_col,(game_col - 1)
neighbor_count_loop:
	call read_array
	cmp game_read, 0
	jz no_neighbor
	
no_neighbor:
	

	loop neighbor_count_loop
count_skip:
	add esi, TYPE BYTE
	add game_col, 1
	.IF game_col >= max_col
		add game_row, 1
		mov game_col, 0	
	.ENDIF
	loop loop_count

	ret
count_neighbors ENDP
end main