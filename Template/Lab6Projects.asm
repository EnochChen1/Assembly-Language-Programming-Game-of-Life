; Lab6Projects.asm Chapter 6
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
; Variables for Project 1
P1_N = 50
P1_dword_array SDWORD P1_N DUP(?),0

; Variables for Project 2
P2_N = 10
P2_dword_array SDWORD P2_N DUP(?), 0
P2_dword_2_array SDWORD P2_N DUP(?), 0

; Variables for Project 3
P3_prompt BYTE "This is the letter grade ",0
P3_prompt_2 BYTE " and this is the score ",0

; Variables for Project 4
P4_true = 1
P4_false = 0
P4_ok_to_register BYTE ?
P4_prompt_1 BYTE "Please enter your gpa (i.e. 350), with min being 0 and max being 400: ",0
P4_prompt_2 BYTE "Please enter your amount of credits in the 1-30 range: ",0
P4_no_register BYTE "You cannot register",0
P4_register BYTE "You CAN register",0

; Variables for Project 5
P5_prompt_1 BYTE "This is a boolean calculator program", 0dh, 0ah
			BYTE "1. x AND y", 0dh, 0ah
			BYTE "2. x OR y", 0dh, 0ah
			BYTE "3. NOT x", 0dh, 0ah
			BYTE "4. x XOR y", 0dh, 0ah
			BYTE "5. Exit program",0dh, 0ah
			BYTE "Please enter the integer of the operation you would like to do: ",0
P5_CaseTable BYTE '1'
			DWORD AND_operation
P5_EntrySize = ($ - P5_CaseTable)								; current location counter - P5_CaseTable,
			BYTE '2'											; actual address to get actual location 
			DWORD OR_operation
			BYTE '3'
			DWORD NOT_operation
			BYTE '4'
			DWORD XOR_operation
			BYTE '5'
			DWORD END_operation
P5_NumberofEntries = ($ - P5_CaseTable) / P5_EntrySize
P5_msg_AND BYTE "This is the AND Operation: ", 0
P5_msg_OR BYTE "This is the OR Operation: ",0
P5_msg_NOT BYTE "This is the NOT Operation: ",0
P5_msg_XOR BYTE "This is the XOR Operation: ",0
P5_msg_END BYTE "This is the END/Exit Operation: ",0

P5_msg_Input_Message_hex BYTE "Please enter first hexadecimal integer: ",0
P5_msg_Input_Message_hex_2 BYTE "Please enter second hexdecimal integer: ",0

P5_hex_val_1 DWORD ?

P5_msg_Result_prompt BYTE "The result of this operation is ",0

; Variables for Project 7
P7_Count DWORD ?
P7_test_prompt BYTE "This is a test prompt",0
P7_white DWORD 0
P7_blue DWORD 0
P7_green DWORD 0

; Variables for Project 8
P8_key_str BYTE 128 DUP(?)
P8_key_size DWORD ?
P8_buffer BYTE 128 DUP(?)
P8_buffer_size DWORD ?

P8_prompt_1 BYTE "Please input the string you would like to encrypt: ",0
P8_prompt_2 BYTE "Please put the key you would like to use to encrypt it: ",0
P8_prompt_3 BYTE "This is the encrypted message: ",0
P8_prompt_4 BYTE "This is the decrypted message: ",0

; Variables for Project 9
P9_min_vals BYTE "52413",0
P9_max_vals BYTE "95846",0

P9_test_pin_1 BYTE "52413",0								; valid
P9_test_pin_2 BYTE "43534",0								; invalid
P9_test_pin_3 BYTE "64537",0								; invalid
P9_test_pin_4 BYTE "95846",0								; valid

P9_pin_size = 5												; size of pin

; Variables for Project 10
P10_parity_array_1 BYTE "10101010101010101010"
P10_parity_array_2 BYTE "10101010101010101011"

; Variable made for Error Messages in console if need to be used
Invalid_Input_Message BYTE "One of your inputs is invalid",0


.code
main PROC
COMMENT !
Project 1
Create a procedure that fills an array of doublewords with N random integers, making sure the
values fall within the range j...k, inclusive. When calling the procedure, pass a pointer to the
array that will hold the data, pass N, and pass the values of j and k. 
Preserve all register values between calls to the procedure. 
Write a test program that calls the procedure twice, using different values for j and k. 
Verify your results using a debugger.
!
	mov esi, OFFSET P1_dword_array								; pointer to array that will hold data
	mov ecx, P1_N												; ecx used to save register, also because it will need to loop N
	mov ebx, 10													; ebx holds low value
	mov edx, 20													; edx holds high value
	call fill_array
	mov ebx, 5													; next call low
	mov edx, 50													; next call high
	call fill_array												; next proc

COMMENT !
Project 2
Create a procedure that returns the sum of all array elements falling within the range j...k (inclusive). 
Write a test program that calls the procedure twice, passing a pointer to a signed doubleword array,
the size of the array, and the values of j and k.
Return the sum in the EAX register,
and preserve all other register values between calls to the procedure
!
	mov esi, OFFSET P2_dword_array								; pointer to array that will hold data
	mov ecx, P2_N												; ecx used to save register, also because it will need to loop N
	mov ebx, 10													; ebx holds low value
	mov edx, 20													; edx holds high value
	call CalcSumRange											; call it
	call CalcSumRange											; to see if it worked properly and have right registers
	mov esi, OFFSET P2_dword_2_array							; pointer to new array
	mov ebx, 20													; ebx is low value
	mov edx, 25													; edx is high value
	call CalcSumRange

COMMENT !
Project 3
Create a procedure named CalcGrade that receives an integer value between 0 and 100, and
returns a single capital letter in the AL register. Preserve all other register values between calls
to the procedure. The letter returned by the procedure should be according to the following
ranges:
Write a test program that generates 10 random integers between 50 and 100, inclusive. Each
time an integer is generated, pass it to the CalcGrade procedure. You can test your program
using a debugger, or if you prefer to use the book’s library, you can display each integer and its
corresponding letter grade. (The Irvine32 library is required for this solution program because it
uses the RandomRange procedure.)
!
	mov ecx, 10													; this wants to be ran 10 times
	
P3_L1:
	mov edx, OFFSET P3_prompt
	mov eax, 50													; eax = 50
	add eax, 1													; done to make sure we get correct range, inclusive
	call RandomRange											; 0 - 50
	add eax, 50													; 50-100 actual range
	push eax													; save score in stack
	call CalcGrade												; pass eax to CalcGrade
	call WriteString
	call WriteChar
	mov edx, OFFSET P3_prompt_2
	pop eax														; put back correct score
	call WriteString
	call WriteDec
	call Crlf
	loop P3_L1
	call WaitMsg												; in case we want to see results

COMMENT !
Project 4
Using the College Registration example from Section 6.7.3 as a starting point, do the following:
• Recode the logic using CMP and conditional jump instructions (instead of the .IF and
.ELSEIF directives).
• Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an
invalid entry is discovered, display an appropriate error message. 
• Prompt the user for the grade average and credits values.
• Display a message that shows the outcome of the evaluation, 
such as “The student can register” or “The student cannot register”.
(The Irvine32 library is required for this solution program.)
!
	call Clrscr													; clear the last problem
	call GetUserInput											; call user to input gpa and credits
	call CheckRegistration										; use inputs to get whether they can register
	call ShowResults											; display on console
	call Crlf													; make it go to next row
	call WaitMsg												; in case we want to see results

COMMENT !
Project 5
Create a program that functions as a simple boolean calculator for 32-bit integers. 
It should display a menu that asks the user to make a selection from the following list:
1. x AND y
2. x OR y
3. NOT x
4. x XOR y
5. Exit program
When the user makes a choice, call a procedure that displays the name of the operation about to
be performed. You must implement this procedure using the Table-Driven Selection technique,
shown in Section 6.5.4. (You will implement the operations in Exercise 6.) (The Irvine32 library
is required for this solution program.)
!
		call Clrscr
		mov ecx, 1
	L1:
		mov edx, OFFSET P5_prompt_1
		call WriteString										; write prompt for boolean calculator
		call ReadChar											; read the char from the console
		call ChooseProcedure
		jnc L1													; continue until exit
		call WaitMsg											; just in case we want to look at results

COMMENT !
Project 6
Is part of project 5 and continues by making procedures more thorough and actually do the operations
wanted in Project 5
!

COMMENT !
Project 7
Write a program that randomly chooses among three different colors for displaying text on
the screen. Use a loop to display 20 lines of text, each with a randomly chosen color. The
probabilities for each color are to be as follows: white 30%, blue 10%, green 60%.
Suggestion: Generate a random integer between 0 and 9. If the resulting integer falls in the
range 0 to 2 (inclusive), choose white. If the integer equals 3, choose blue. If the integer falls in
the range 4 to 9 (inclusive), choose green. Test your program by running it ten times, each time
observing whether the distribution of line colors appears to match the required probabilities.
(The Irvine32 library is required for this solution program.)
!
	call Clrscr													; clears last project
	mov ecx, 10													; project wants to be looped 10 times
P7_L1:
	mov P7_Count, ecx											; needs to be saved
	mov ecx, 20													; 20 lines wanted in inner loop
P7_L2:
	mov eax, 10													;10 must be moved in for correct range
	call RandomRange											; range from 0-9
	cmp eax, 2													; compare eax to 2
	jbe obtained_white											; if below or equal to 2, white is color
	cmp eax, 3													; compare eax to 3
	je obtained_blue											; if equal to 3, choose blue
	jmp obtained_green											; else choose green
obtained_white:
	mov eax, white												; sets text color to white
	add P7_white, 1												; will count for me
	jmp P7_next													; skips to next
obtained_blue:
	mov eax, blue												; sets text color to blue
	add P7_blue, 1												; will count for me
	jmp P7_next													; skips to next
obtained_green:
	mov eax, green												; sets text color to green
	add P7_green, 1												; will count for me
P7_next:
	mov edx, OFFSET P7_test_prompt								; uses for test prompt
	call SetTextColor											; sets text color
	call WriteString											; calls the string test prompt
	call Crlf													; goes to next line
	loop P7_L2													; twenty lines
	mov ecx, P7_Count											; nested loop return ecx
	loop P7_L1													; loop ten times for 200 lines
																; white was 3ch, which is 60, 30%
																; blue was 13h, which is 19, 9.5%
																; green was 79h, which is 121, 60.5%
																; which is very close to the required probabilities
	call WaitMsg												; just in case, we want to see results
COMMENT !
P8
Revise the encryption program in Section 6.3.4 in the following manner: 
Create an encryption key consisting of multiple characters. 
Use this key to encrypt and decrypt the plaintext by XORing each character of the key
against a corresponding byte in the message. 
Repeat the key as many times as necessary until all plain text bytes are translated. 
Suppose, for example, the key were equal to “ABXmv#7”. 
This is how the key would align with the plain text bytes

!
	call Clrscr													; clear the screen from last problem
	call Input_text_and_key										; see the console
	call TranslateBuffer										; this will encrypt the line
	call CallDisplayMessage										; sends the encrypted to console
	call TranslateBuffer										; decrypts message
	call CallDisplayMessage										; sends decrypted to console
	call WaitMsg												; just in case we want to see results

COMMENT !
P9
Banks use a Personal Identification Number (PIN) to uniquely identify each customer. Let us
assume that our bank has a specified range of acceptable values for each digit in its customers’
5-digit PINs. The table shown below contains the acceptable ranges, where digits are numbered
from left to right in the PIN. Then we can see that the PIN 52413 is valid. But the PIN 43534 is
invalid because the first digit is out of range. Similarly, 64535 is invalid because of its last digit.
Your task is to create a procedure named Validate_PIN that receives a pointer to an array of byte
containing a 5-digit PIN. Declare two arrays to hold the minimum and maximum range values,
and use these arrays to validate each digit of the PIN that was passed to the procedure. If any
digit is found to be outside its valid range, immediately return the digit’s position (between
1 and 5) in the EAX register. If the entire PIN is valid, return 0 in EAX. Preserve all other
register values between calls to the procedure. Write a test program that calls Validate_PIN at
least four times, using both valid and invalid byte arrays. By running the program in a debugger,
verify that the return value in EAX after each procedure call is valid. Or, if you prefer to use the
book’s library, you can display "Valid" or "Invalid" on the console after each procedure call.
1 : 5 to 9
2 : 2 to 5
3 : 4 to 8
4 : 1 to 4
5 : 3 to 6

!
	call Clrscr
	mov esi, OFFSET P9_test_pin_1								; pos 0 of test_pin_1
	call Validate_PIN											; check validity
	mov esi, OFFSET P9_test_pin_2								; pos 0 of test_pin_2
	call Validate_PIN											; check validity
	mov esi, OFFSET P9_test_pin_3								; pos 0 of test_pin_3
	call Validate_PIN											; check validity
	mov esi, OFFSET P9_test_pin_4								; pos 0 of test_pin_4
	call Validate_PIN											; check validity

COMMENT !
P10
Data transmission systems and file subsystems often use a form of error detection that relies on
calculating the parity (even or odd) of blocks of data. Your task is to create a procedure that
returns True in the EAX register if the bytes in an array contain even parity, or False if the parity
is odd. In other words, if you count all the bits in the entire array, their count will be even or odd.
Preserve all other register values between calls to the procedure. Write a test program that calls
your procedure twice, each time passing it a pointer to an array and the length of the array. The
procedure’s return value in EAX should be 1 (True) or 0 (False). For test data, create two arrays
containing at least 10 bytes, one having even parity, and another having odd parity. 
!
	mov esi, OFFSET P10_parity_array_1							; pos 0 of array
	mov ecx, SIZEOF P10_parity_array_1
	call Parity_Check
	mov esi, OFFSET P10_parity_array_2
	mov ecx, SIZEOF P10_parity_array_1
	call Parity_Check

	INVOKE ExitProcess,0
main ENDP

COMMENT !
P1. Filling an array procedure
!
fill_array PROC
	pushad														; save all registers before doing the rest
	inc edx														; adds the inclusive range
P1_L1:
	mov eax, edx												; give eax the high number
	sub eax, ebx												; subtract low number to get range
	call RandomRange											; 0 - range
	add eax, ebx												; then get the actual range  by adding the low number
	mov [esi], eax												; places random integer into array
	add esi, DWORD
	loop P1_L1
	popad
	ret
fill_array ENDP

COMMENT !
P2. Finding the sum of an array filled with random integers
!
CalcSumRange PROC
.data
P2_sum DWORD ?
.code
	pushad
	inc edx														; adds the inclusive range
P2_L1:
	mov eax, edx												; give eax the high number
	sub eax, ebx												; subtract low number to get range
	call RandomRange											; 0 - range
	add eax, ebx												; then get the actual range  by adding the low number
	mov [esi], eax												; places random integer into array
	add P2_sum, eax												; add the sum into eax
	add esi, DWORD
	loop P2_L1
	popad
	mov eax, P2_sum												; returns the sum in eax
	mov P2_sum, 0												; needs to reset so following calculations are correct
	ret
CalcSumRange ENDP

COMMENT !
P3. Get an integer return as a letter grade
!
CalcGrade PROC
	cmp eax, 90													; check eax compared to 90
	jae grade_A
	cmp eax, 80													; check eax compared to 80
	jae grade_B
	cmp eax, 70													; check eax compared to 70
	jae grade_C
	cmp eax, 60													; check eax compared to 60
	jae grade_D
	cmp eax, 0													; check eax compared to 0
	jae grade_F
grade_A:
	mov al, 'A'													; get letter grade A
	ret
grade_B:
	mov al, 'B'													; get letter grade B
	ret
grade_C:
	mov al, 'C'													; get letter grade C
	ret
grade_D:
	mov al, 'D'													; get letter grade D
	ret
grade_F:
	mov al, 'F'													; get letter grade F
	ret
CalcGrade ENDP

COMMENT !
P4. Get the user input on gpa and credits
!
GetUserInput PROC
	mov edx, OFFSET P4_prompt_1									; asks for gpa
	call WriteString
	call ReadInt												; gets the gpa in eax
	mov ebx, eax												; moves the gpa to ebx
	mov edx, OFFSET P4_prompt_2									; asks for credits
	call WriteString
	call ReadInt												; gets the credits in eax
	ret
GetUserInput ENDP

COMMENT !
P4. Check the gpa and credits and figure out if they can register
!
CheckRegistration PROC
	mov P4_ok_to_register, P4_false
	cmp ebx, 0
	jbe error_message
	cmp ebx, 400
	ja error_message
	cmp eax, 0													; check credits, if 0 or below
	jbe error_message											; input would be wrong
	cmp eax, 30													; if input is higher than 30
	ja error_message											; input would be wrong
	cmp ebx, 350												; compare gpa to 350
	ja good														; if above, ok_to_register = true
	cmp eax, 12													; if credits below 12
	jb good														; then ok to register, also needs to be put
																; before the next one, so that it won't jump to fail immediately
	cmp ebx, 250												; compare gpa to 250
	jbe	fail													; if below and equal, return
	cmp eax, 16													; if credits greater than 16
	ja good														; if last two are true, good to register
	
fail:
	ret
good:
	mov P4_ok_to_register, P4_true								; if conditions are met, ok_to_register
	ret
error_message:
	call DisplayErrorMsg										; called if input is wrong
	ret
CheckRegistration ENDP

COMMENT !
P4 Show results, if you can register show one prompt. If not, show another prompt.
!
ShowResults PROC
	cmp P4_ok_to_register, P4_true
	je congrats
	mov edx, OFFSET P4_no_register
	call WriteString
	ret
congrats:
	mov edx, OFFSET P4_register
	call WriteString
	ret
ShowResults ENDP

COMMENT !
P4 An error happened, call this procedure to tell the console
!
DisplayErrorMsg PROC
	push edx
	mov edx,OFFSET Invalid_Input_Message
	call WriteString
	call Crlf
	pop edx
	ret
DisplayErrorMsg ENDP

COMMENT !
P5 ChooseProcedure
This checks what char was inputted, and chooses the correct procedure to call afterwards
!
ChooseProcedure PROC
	mov ebx, OFFSET P5_CaseTable								; this gets procedure going
	mov ecx, P5_NumberofEntries									; loop counter of NumberofEntries
P5_L1:
	cmp al, [ebx]												; compare the position in CaseTable and the value obtained
	jne P5_L2
	call Crlf
	call NEAR PTR [ebx+1]										; this calls the correct procedure through the address
																; in the Case Table
	jmp P5_L3
P5_L2:
	add ebx, P5_EntrySize										; go to next entry and check
	loop P5_L1
P5_L3:
	ret
ChooseProcedure ENDP

COMMENT !
P5 AND_operation P6 - do the actual operation
A procedure to do the AND operation for the boolean calculator
!
AND_operation PROC
	mov edx, OFFSET P5_msg_AND
	call WriteString
	call Crlf
	mov edx, OFFSET P5_msg_Input_Message_hex
	call WriteString
	call ReadHex
	mov P5_hex_val_1, eax
	mov edx, OFFSET P5_msg_Input_Message_hex_2
	call WriteString
	call ReadHex
	and eax, P5_hex_val_1
	mov edx, OFFSET P5_msg_Result_prompt
	call WriteString
	call WriteHex
	call Crlf
	ret
AND_operation ENDP

COMMENT !
P5 OR_operation P6 - do the actual operation
A procedure to do the OR operation for the boolean calculator
!
OR_operation PROC
	mov edx, OFFSET P5_msg_OR
	call WriteString
	call Crlf
	mov edx, OFFSET P5_msg_Input_Message_hex
	call WriteString
	call ReadHex
	mov P5_hex_val_1, eax
	mov edx, OFFSET P5_msg_Input_Message_hex_2
	call WriteString
	call ReadHex
	or eax, P5_hex_val_1
	mov edx, OFFSET P5_msg_Result_prompt
	call WriteString
	call WriteHex
	call Crlf
	ret
OR_operation ENDP

COMMENT !
P5 NOT_operation P6 - do the actual operation
A procedure to do the NOT operation for the boolean calculator
!
NOT_operation PROC
	mov edx, OFFSET P5_msg_NOT
	call WriteString
	call Crlf
	mov edx, OFFSET P5_msg_Input_Message_hex
	call WriteString
	call ReadHex
	mov P5_hex_val_1, eax
	not eax
	mov edx, OFFSET P5_msg_Result_prompt
	call WriteString
	call WriteHex
	call Crlf
	ret
NOT_operation ENDP

COMMENT !
P5 XOR_operation P6 - do the actual operation
A procedure to do the XOR operation for the boolean calculator
!
XOR_operation PROC
	mov edx, OFFSET P5_msg_XOR
	call WriteString
	call Crlf
	mov edx, OFFSET P5_msg_Input_Message_hex
	call WriteString
	call ReadHex
	mov P5_hex_val_1, eax
	mov edx, OFFSET P5_msg_Input_Message_hex_2
	call WriteString
	call ReadHex
	xor eax, P5_hex_val_1
	mov edx, OFFSET P5_msg_Result_prompt
	call WriteString
	call WriteHex
	call Crlf
	ret
XOR_operation ENDP

COMMENT !
P5 END_operation P6 - do the actual operation
A procedure to do the END/EXIT operation for the boolean calculator
!
END_operation PROC
	mov edx, OFFSET P5_msg_END
	call WriteString
	call Crlf
	stc															; sets carry flag
	ret
END_operation ENDP

COMMENT !
P8 Input_text_and_key
Gets the user to input text and key and then saves the string and length in a variable
Does not return anything
!
Input_text_and_key PROC
	pushad														; make sure the registers will all be same after
	mov edx, OFFSET P8_prompt_1									; get the prompt for input text
	call WriteString											; send it to console
	call Crlf													; go to next line
	mov edx, OFFSET P8_buffer									; move it to buffer
	mov ecx, SIZEOF P8_buffer									; get the maximum size of buffer
	call ReadString												; get the string
	mov P8_buffer_size, eax										; put into the size counter
	mov edx, OFFSET P8_prompt_2									; get the prompt for key
	call WriteString											; send it to console
	mov edx, OFFSET P8_key_str									; move it to key
	mov ecx, SIZEOF P8_key_size									; get the maximum size of key
	call ReadString												; get the string
	mov P8_key_size, eax										; put into the size counter for key
	popad														; get all the registers from before procedure
	ret
Input_text_and_key ENDP

COMMENT !
P8 TranslateBuffer PROC
This will make the string exclusive or with the key to  get an encrypted message
!
TranslateBuffer PROC
	pushad
	mov ecx, P8_buffer_size										; the buffer size means all of it will be encrypted
	mov esi, 0													; pos of buffer
	mov edi, 0													; pos of key
P8_TB:
	cmp P8_key_size, edi
	jne P8_cont
	mov edi, 0
P8_cont:
	mov al, P8_key_str[edi]										; to make it valid for xor
	xor P8_buffer[esi], al										; this will be used to encrypt
	inc esi														; increments position
	inc edi
	loop P8_TB
	popad
	ret
TranslateBuffer ENDP

COMMENT !
P8 CallDisplayedMessage
!
CallDisplayMessage PROC
	pushad
	mov edx, OFFSET P8_buffer
	call WriteString
	call Crlf
	popad
	ret
CallDisplayMessage ENDP

COMMENT !
P9 Validate_PIN
This will check min and max of valid ranges of PIN
!
Validate_PIN PROC
	mov ecx, P9_pin_size										; should be 5
	mov edi, 0													; pos 0 for min and max
P9_L1:
	mov eax, 0													; to clear for each loop
	mov al, P9_min_vals[edi]									; to ensure it can be compared
	cmp [esi], al												; compare min vals with the pin number in pos edi
	jb invalid
	mov al, P9_max_vals[edi]									; to ensure it can be compared
	cmp [esi], al												; compare max cals with pin number in pos edi
	ja invalid
	inc esi														; goes to next pos in pin
	inc edi														; goes to next pos in min and max
	loop P9_L1
	jmp valid
invalid:
	inc edi														; to make sure edi is pos+1
	mov eax, edi												; obtains the pos that is invalid
	ret
valid:
	mov eax, 0													; if correct, eax will be 0
	ret

Validate_PIN ENDP

COMMENT !
P10 Parity_Check
This checks the parity of the array
!
Parity_Check PROC
	mov al, [esi]
P10_L1:
	xor al, [esi+1]
	inc esi
	loop P10_L1
	jp it_even
	mov eax, 0
	ret
it_even:
	mov eax, 1
	ret
Parity_Check ENDP
end main