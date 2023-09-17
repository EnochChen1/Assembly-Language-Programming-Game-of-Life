; Lab5ProgrammingExercises.asm Chapter 5
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
; Variables for Question 1
Q1_displayed_text BYTE "Hello World",0

; Variables for Question 2
.data
Q2_start_pos EQU 1
Q2_char_array BYTE   'H', 'A', 'C', 'E', 'B', 'D', 'F', 'G',0
Q2_link_array DWORD 0, 4, 5, 6, 2, 3, 7, 0
Q2_arranged_char_array BYTE LENGTHOF Q2_char_array DUP(?)

; Variables for Question 3
Q3_first_prompt BYTE "Please input the first integer to be added: ",0
Q3_second_prompt BYTE "Please input the second integer to be added: ",0
Q3_int_val_1 SDWORD ?
Q3_int_val_2 SDWORD ?
Q3_third_prompt BYTE "The result is: ",0

; Variables for Question 4
Q4_first_prompt BYTE "Please input the integer to be added: ",0
Q4_int_val_1 SDWORD ?
Q4_int_val_2 SDWORD ?
Q4_second_prompt BYTE "The result is: ",0
Q4_sum DWORD 0

; Variables for Question 5
; none

; Variables for Question 6
Q6_string_size EQU 20
Q6_random_string BYTE LENGTHOF Q6_string_size DUP(?)

; Variables for Question 7
Q7_rows BYTE 1 DUP(?)
Q7_cols BYTE 1 DUP(?)

; Variables for Question 8
Q8_count DWORD 1 DUP(?)

; Variables for Question 10
Q10_N EQU 47
Q10_fib_array DWORD Q10_N DUP(?)

; Variables for Question 11
Q11_N = 50
Q11_array BYTE Q11_N DUP(0)
Q11_K DWORD ?
.code
main PROC
; Code for Question 1
COMMENT !
Write a program that displays the same string in four different colors, using a loop.
Call the SetTextColor procedure from the book's link library. Any colors may be chosen,
but you may find it easier to change the foreground color.
!
	mov ecx, 4															; we want it to loop 4 times
	mov eax, white+(green*16)											; white on green
L1:
	mov edx, OFFSET Q1_displayed_text									; this tracks the displayed_text
	call setTextColor
	call WriteString
	add eax, 16															; to make background change
	loop L1
	mov eax, white+(black)												; reset to default
	call setTextColor	
	mov eax, 0

COMMENT !
Project 2
Suppose you are given three data items that indicate a starting index in a list, 
an array of characters, and an array of link index. 
You are to write a program that traverses the links and locates the characters in their correct sequence.
For each character you locate, copy it to a new array. 
Suppose you used the following sample data, and assumed the arrays use zero-based indexes: 

start = 1 
chars: H A C E  B D F G 
links:   0 4  5 6  2  3 7  0 

Then the values copied (in order) to the output array would be A,B,C,D,E,F,G,H.
Declare the character array as type BYTE, and to make the problem more interesting, declare the links array type DWORD.
!

	mov ecx, LENGTHOF Q2_char_array										; start loop counter
	sub ecx, TYPE Q2_char_array											; get correct loop counter
	mov esi, Q2_start_pos												; esi stores the pos of char_array
	mov edi, Q2_link_array[Q2_start_pos*TYPE Q2_link_array]				; edi stores the value in pos of link_a
	mov ebx, 0															; this shall be counter for arranged_c
Q2_L1:
	mov al, Q2_char_array[esi*TYPE Q2_char_array]						; move character into al
	mov Q2_arranged_char_array[ebx*TYPE Q2_char_array], al				; use al to put into arranged_char_a
	inc ebx																; increment counter
	mov esi, edi														; moves new pos into esi
	mov edi, Q2_link_array[esi*TYPE Q2_link_array]						; moves new value into edi
	loop Q2_L1

COMMENT !
Project 3
Write a program that clears the screen, locates the cursor near the middle of the screen,
prompts the user for two integers, adds the integers, and displays their sum
!
	call WaitMsg
	call Clrscr															; calls clear screen to clear the screen
	mov dh, 10															; row 10
	mov dl, 20															; col 20
	call Gotoxy															; cursor located
	mov edx, OFFSET Q3_first_prompt										; makes it so edx follows first_prompt
	call WriteString													; will make first_prompt be displayed on screen
	call ReadInt														; reads and puts into eax
	mov Q3_int_val_1, eax												; puts it into the int_val_1
	mov dh, 11															; row 11
	mov dl, 20															; col 20
	call Gotoxy															; cursor located
	mov edx, OFFSET Q3_second_prompt									; makes it so edx follows second_prompt
	call WriteString													; will make first_prompt be displayed on screen
	call ReadInt														; reads and puts into eax
	mov Q3_int_val_2, eax												; puts it into the int_val_1
	mov dh, 12															; row 12
	mov dl, 20															; col 20
	call Gotoxy															; cursor located
	mov edx, OFFSET Q3_third_prompt										; makes it so edx follows third_prompt
	add eax, Q3_int_val_1												; eax already has int_val_2, so just need to add
	call WriteString													; first integer
	call WriteInt

COMMENT !
Project 4
Use the solution program from the preceding exercise as a starting point. Let this new program
repeat the same steps three times, using a loop. Clear the screen after each loop iteration
!
	mov ecx, 3															; we want it to loop three times
Q4_L1:																		; start with a Loop
	mov dh, 8
	mov dl, 25
	mov Q4_sum, 0
	call Clrscr															; clears the screen
	call locate															; puts it in right location
	call input															; sends prompt to console
	add Q4_sum, eax														; adds sum up
	add dh, 2															; row+=2
	call locate															; puts prompt in new location
	call input															; sends prompt
	add Q4_sum, eax														; gets the sum
	add dh,2															; row+=2
	call DisplaySum														; calls procedure
	call waitforkey														; calls waitMsg
	loop Q4_L1

COMMENT !
Project 5
The RandomRange procedure from the Irvine32 library generates a pseudorandom integer between
0 and N - 1. Your task is to create an improved version that generates an integer between M and
N - 1. Let the caller pass M in EBX and N in EAX. If we call the procedure BetterRandomRange, the
following code is a sample test:
mov ebx,-300 ; lower bound
mov eax,100 ; upper bound
call BetterRandomRange
Write a short test program that calls BetterRandomRange from a loop that repeats 50 times.
Display each randomly generated value.
!
	mov dh, 10
	mov dl, 0
	mov ecx, 50															; counter is 50 loops
Q5_L1:
	mov ebx, -300														; test for lower bound
	mov eax, 100														; test for upper bound
	call BetterRandomRange												; procedure to make m to n - 1
	call WriteInt														; this will then send the random value in range
	add dh,1															; increase row
	loop Q5_L1
COMMENT !
Project 6
Create a procedure that generates a random string of length L, containing all capital letters.
When calling the procedure, pass the value of L in EAX, and pass a pointer to an array of byte
that will hold the random string. 
Write a test program that calls your procedure 20 times and displays the strings in the console window
!
	call WaitMsg														; to make it stay if need results
	call Clrscr															; clear
	mov eax, Q6_string_size												; eax is given the string size
	mov esi, OFFSET Q6_random_string									; esi is now pos[0] of random string
	mov ecx, eax														; ecx is now 20, number of loops
	mov eax, 26															; this is the number of letters in alphabet
Q6_L1:
	mov eax, 26															; resets value of eax
	call RandomRange													; this will have 0-25, as letters in alphabet
	add eax, 'A'														; this is char, which means eax will have a letter
	mov BYTE PTR[esi], al												; this will put the letter obtained into the array
	add esi, TYPE Q6_random_string
	loop Q6_L1

COMMENT !
Project 7
Write a program that displays a single character at 100 random screen locations, using a timing
delay of 100 milliseconds. Hint: Use the GetMaxXY procedure to determine the current size of
the console window.
!
	call WaitMsg
	call Clrscr
	call GetMaxXY														; gets the number of rows al
																		; and  number of cols dl in console
	mov Q7_rows, al														
	mov Q7_cols, dl
	mov ecx, 100														; this wants to be looped 100 times
Q7_L1:
	mov al, Q7_rows														; ensure that it gets the same result per loop
	mov dl, Q7_cols														; same result per loop
	call RandomRange													; moves a random number
	mov dh, al															; this 
	mov eax, edx
	call RandomRange
	mov dl, al
	call Gotoxy
	call WriteChar
	mov eax, 100
	call Delay
	loop Q7_L1

COMMENT !
Project 8
Write a program that displays a single character in all possible combinations of foreground and
background colors (16 * 16 = 256). The colors are numbered from 0 to 15, so you can use a
nested loop to generate all possible combinations
!
	call WaitMsg														; make sure to wait
	call Clrscr															; clear for next problem
	mov eax, 0															; reset eax
	mov ecx, 16
Q8_L1:
	mov Q8_count, ecx													; to keep the outer loop counter saved
	mov ecx, 16															; ensure it does 16 times per outer loop
Q8_L2:
	call SetTextColor													; change color per 16
	mov bl, al
	mov al, 'x'
	call writeChar
	mov al, bl
	inc al
	loop Q8_L2
	call Crlf
	inc ah
	mov ecx, Q8_count
	loop Q8_L1
	
COMMENT !
Project 10
Write a procedure that produces N values in the Fibonacci number series and stores them in an
array of doubleword. Input parameters should be a pointer to an array of doubleword, a
counter of the number of values to generate. Write a test program that calls your procedure,
passing N = 47. The first value in the array will be 1, and the last value will be 2,971,215,073.
Use the Visual Studio debugger to open and inspect the array contents
!
	call fib_generator													; calls the procedure made

COMMENT !
Project 11
In a byte array of size N, write a procedure that finds all multiples of K that are less than N. 
Initialize the array to all zeros at the beginning of the program, and then whenever a multiple is
found, set the corresponding array element to 1. Your procedure must save and restore any registers it modifies.
Call your procedure twice, with K = 2, and again with K = 3. Let N equal to 50.
Run your program in the debugger and verify that the array values were set correctly.
Note: This procedure can be a useful tool when finding prime integers. 
An efficient algorithm for finding prime numbers is known as the Sieve of Eratosthenes. 
You will be able to implement this algorithm when conditional statements are covered in Chapter 6.
!
	mov Q11_K, 2															; k = 2
	call multiples_of_k
	call WaitMsg
	mov ecx, Q11_N
Q11_L2:
	mov BYTE PTR [esi], 0
	add esi, TYPE Q11_array
	loop Q11_L2
	mov Q11_K, 3
	call multiples_of_k


	INVOKE ExitProcess,0
main ENDP
COMMENT !
locate
This procedure uses dh and dl to go to a specific place in the console
and calls Gotoxy 
!
locate PROC
	call Gotoxy
	ret
locate ENDP

COMMENT !
input
This sends a prompt to tell the user to input an integer, then accepts
that integer, and puts it into eax
!
input PROC
	mov edx, OFFSET Q4_first_prompt										; make sure edx follows this prompt
	call WriteString													; sends it to console
	call ReadInt														; reads and puts it into eax
	ret
input ENDP

COMMENT !
DisplaySum PROC
This will send a line with the sum as the result
!
DisplaySum PROC
	mov edx, OFFSET Q4_second_prompt
	call WriteString
	mov eax, Q4_sum														; send sum to eax
	call WriteInt														; sends it onto console
	ret
DisplaySum ENDP

COMMENT !
waitforkey
This will call the WaitMsg procedure
!
waitforkey PROC
	call WaitMsg
	ret
waitforkey ENDP

COMMENT !
BetterRandomRange
This will make it so that the range is from m to n-1, essentially whatever you get what the range
is, then add m to it
!
BetterRandomRange PROC
	sub eax, ebx														; this will get the amount of numbers in range
	call RandomRange													; from 0 to (n-1) range
	add eax, ebx														; then get the number we want back
	ret
BetterRandomRange ENDP

COMMENT !
fib_generator
!
fib_generator PROC
	mov eax, 1
	mov ebx, 0
	mov ecx, Q10_N
	mov esi, OFFSET Q10_fib_array
Q10_L1:
	add eax, ebx
	mov [esi], eax
	add esi, TYPE Q10_fib_array
	xchg eax, ebx
	loop Q10_L1
	ret
fib_generator ENDP

COMMENT !
multiples_of_k
!
multiples_of_k PROC
	push ebx											; question told us to save all registers used
	push ecx
	push edx
	push esi
	mov esi, OFFSET Q11_array
	mov ecx, Q11_N
	mov edx, 1
	mov ebx, Q11_K
Q11_L1:
	cmp ebx, edx
	jne next
	mov BYTE PTR [esi], 1
	add ebx, Q11_K
next:
	add edx, 1
	add esi, TYPE Q11_array
	loop Q11_L1
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
multiples_of_k ENDP
	
END main
