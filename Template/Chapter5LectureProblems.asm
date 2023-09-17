; Chapter5LectureProblems.asm Chapter 5
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
; Variables for Your Turn 2 Q1

; Variables for Example 3 Q2
Q2_IntVal = 35

; Variables for Example 4 Q3
Q3_fileName BYTE 80 DUP(0)

; Variables for Example 6 Q5
Q5_Prompt_Sentence BYTE "This is a test sentence that should be in yellow",0

.code
main PROC
COMMENT !
Your Turn 2
Write a program that does the following:
– Assigns integer values to EAX, EBX, ECX, EDX, ESI,
and EDI
– Uses PUSHAD to push the general-purpose registers
on the stack
– Using a loop, your program should pop each integer
from the stack and display it on the screen
!
	
	mov eax, 1										; all integer values placed
	mov ebx, 2
	mov ecx, 8
	mov edx, 4
	mov esi, 5
	mov edi, 6
	pushad											; pushes all general-purpose registers
Q1_L1:
	pop eax											; pops from stack to eax
	call WriteHex									; writes it onto console
	call Crlf										; goes to next line
	loop Q1_L1										; loop
	call WaitMsg									; in case we want to see results

COMMENT !
Example 3
Display an unsigned integer in binary, decimal, and
hexadecimal, each on a separate line.
!
	call Clrscr										; to clear from last problem
	mov eax, Q2_IntVal								; put integer into eax
	call WriteBin									; convert to binary writes to console
	call Crlf										; next line
	call WriteDec									; decimal writes to console
	call Crlf										; next line
	call WriteHex									; hex writes to console
	call Crlf
	call WaitMsg									; in case we want to see results

COMMENT !
Example 4
Input a string from the user. EDX points to the string and E
CX specifies the maximum number of characters the user
is permitted to enter.
!
	call Clrscr										; to clear from last problem
	mov	edx, OFFSET Q3_fileName
	mov ecx, SIZEOF Q3_fileName - 1
	call ReadString									; verified, it does add a null byte to the end
	call WaitMsg									; in case we want to see results

COMMENT !
Example 5
Generate and display ten pseudorandom signed integers in
the range 0 – 99. Pass each integer to WriteInt in EAX and
display it on a separate line.
!
	call Clrscr										; clear last problem
	mov ecx, 10										; only need 10 loops
Q4_L1:
	mov eax, 100									; needed to get 0-99 as range
	call RandomRange								; calls a pseudorandom
	call WriteInt									; writes it to console
	call Crlf										; goes to next line
	loop Q4_L1
	call WaitMsg

COMMENT !
Example 6
Display a null-terminated string with yellow characters on a
blue background.
!
	call Clrscr
	mov edx, OFFSET Q5_Prompt_Sentence
	mov eax, yellow + (blue*16)
	call SetTextColor
	call WriteString
	call Crlf
	call WaitMsg
	mov eax, white + (black*16)
	call SetTextColor


INVOKE ExitProcess,0
main ENDP
end main