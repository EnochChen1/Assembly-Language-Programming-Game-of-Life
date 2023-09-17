; Testing.asm Using this to test stuff so I know what the code does
INCLUDE Irvine32.inc

.data
.code
main PROC
mov dh, 1
mov dl, 1
call Gotoxy
add dh, 1
call Gotoxy
add dl, 1
call Gotoxy
	exit
main ENDP
end main