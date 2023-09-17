INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
P1_DECIMAL_OFFSET = 5
P1_decimal_one BYTE "100123456789765"
P1_decimal_length DWORD SIZEOF P1_decimal_one

P2_binary_one DWORD 1000111001101011b
P2_binary_two DWORD 0101111111110110b
P2_binary_one_size DWORD SIZEOF P2_binary_one
P2_result DWORD SIZEOF P2_binary_one DUP(0)

P3_packed_decimal DWORD 37852918h,0
P3_ascii_string BYTE ?
P3_size_pd EQU SIZEOF P3_packed_decimal*2

P4_key BYTE  -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
P4_plaintext BYTE "I am Enoch Chen, and I am 18.",0
P4_size EQU SIZEOF P4_plaintext
P4_counter BYTE 0

P6_GCD_1 DWORD 540d
P6_GCD_2 DWORD 24d
P6_n DWORD ?
P6_x DWORD ?

P7_ebx DWORD 23780245h
P7_eax DWORD ?

.code
main PROC

COMMENT !
Project 1 
Write a procedure named WriteScaled that outputs a decimal ASCII number with an implied decimal point.
Suppose the following number were defined as follows, where DECIMAL_OFFSET
indicates that the decimal point must be inserted five positions from the right side of the number:
DECIMAL_OFFSET = 5
.data
decimal_one BYTE "100123456789765"
WriteScaled would display the number like this:
1001234567.89765
When calling WriteScaled, pass the number’s offset in EDX, the number length in ECX, and the
decimal offset in EBX. Write a test program that passes three numbers of different sizes to the
WriteScaled procedure.
!
	mov edx, OFFSET P1_decimal_one
	mov ecx, P1_decimal_length
	mov ebx, P1_DECIMAL_OFFSET
P1_L1:
	cmp ecx, ebx
	jne P1_skip
	mov al, '.'
	call WriteChar
P1_skip:
	mov al, BYTE PTR [edx]
	call WriteChar
	add edx, TYPE P1_decimal_one
	loop P1_L1

COMMENT !
Project 2
2. Extended Subtraction Procedure
Create a procedure named Extended_Sub that subtracts two binary integers of arbitrary size.
The storage size of the two integers must be the same, and their size must be a multiple of 32
bits. Write a test program that passes several pairs of integers, each at least 10 bytes long
!
	mov esi, OFFSET P2_binary_one
	mov edi, OFFSET P2_binary_two
	mov ebx, OFFSET P2_result
	mov ecx, LENGTHOF P2_binary_one
	call P2_Extended_Sub
	

COMMENT !
Project 3
Write a procedure named PackedToAsc that converts a 4-byte packed decimal integer to a string
of ASCII decimal digits. Pass the packed integer and the address of a buffer holding the ASCII
digits to the procedure. Write a short test program that passes at least 5 packed decimal integers
to your procedure.
!
	mov eax, P3_packed_decimal
	mov edx, OFFSET P3_ascii_string
	mov ecx, P3_size_pd
	call P3_PackedToAsc												; can't figure out conversion to ascii decimal

COMMENT !
Project 4
Write a procedure that performs simple encryption by rotating each plaintext byte a varying
number of positions in different directions. For example, in the following array that represents
the encryption key, a negative value indicates a rotation to the left and a positive value indicates
a rotation to the right. The integer in each position indicates the magnitude of the rotation:
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
Your procedure should loop through a plaintext message and align the key to the first 10 bytes of
the message. Rotate each plaintext byte by the amount indicated by its matching key array value.
Then, align the key to the next 10 bytes of the message and repeat the process. Write a program
that tests your encryption procedure by calling it twice, with different data sets.
!
	mov ecx, P4_size
	mov edi, OFFSET P4_key
	mov esi, OFFSET P4_plaintext
	call P4_Encryption

COMMENT !
Project 6
The greatest common divisor (GCD) of two integers is the largest integer that will evenly divide
both integers. The GCD algorithm involves integer division in a loop, described by the following
pseudocode:
int GCD(int x, int y)
{
x = abs(x) // absolute value
y = abs(y)
do {
int n = x % y
x = y
y = n
} while (y > 0)
return x
}
Implement this function in assembly language and write a test program that calls the function
several times, passing it different values. Display all results on the screen.
!
	mov eax, P6_GCD_1							; eax is equal to x
	mov ebx, P6_GCD_2							; ebx is equal to y
	call P6_GCD


COMMENT !
Project 7
Write a procedure named BitwiseMultiply that multiplies any unsigned 32-bit integer by
EAX, using only shifting and addition. Pass the integer to the procedure in the EBX register,
and return the product in the EAX register. Write a short test program that calls the procedure
and displays the product. (We will assume that the product is never larger than 32 bits.) This is
a fairly challenging program to write. One possible approach is to use a loop to shift the multiplier to the right,
keeping track of the number of shifts that occur before the Carry flag is set.
The resulting shift count can then be applied to the SHL instruction, using the multiplicand as
the destination operand. Then, the same process must be repeated until you find the last 1 bit
in the multiplier.
!
	mov ebx, P7_ebx													; pass this to procedure
	mov eax, 5h
	call P7_bitwise_mul
INVOKE ExitProcess,0
main ENDP

P2_Extended_Sub PROC
	pushad
	clc
P2_L1:
	mov eax, [esi]
	sbb eax, [edi]
	pushfd															; save carry flag
	mov [ebx], eax
	add esi, TYPE DWORD
	add edi, TYPE DWORD
	add ebx, TYPE DWORD
	popfd
	loop P2_L1
	mov DWORD PTR [ebx],0
	sbb DWORD PTR ebx, 0
	popad
	ret
P2_Extended_Sub ENDP

P3_PackedtoAsc PROC
P3_L1:
	mov ebx, eax
	and ebx, 11110000000000000000000000000000b
	rol ebx, 4
	add ebx, 30h
	mov [edx], bl
	add edx, TYPE BYTE
	shl eax, 4
	loop P3_L1
ret
P3_PackedtoAsc ENDP

P4_Encryption PROC
	pushad
P4_L1:
	mov edx, 0									; to check for null
	cmp [edi], edx								; compare plaintext pos to null
	je P4_leave									; leave if null
	cmp BYTE PTR [edi], 0						; if this is positive
	jns P4_positive
	jmp P4_negative
P4_positive:
	push ecx
	mov cl,[edi]								; move number to eax
	ror BYTE PTR [esi], cl						; and rotate to right by that number
	pop ecx
	jmp P4_cont
P4_negative:
	push ecx
	movsx ecx,BYTE PTR [edi]
	neg ecx
	rol BYTE PTR [esi], cl
	pop ecx
P4_cont:	
	add esi, TYPE BYTE
	add edi, TYPE BYTE
	add P4_counter,1
	cmp P4_counter, 10
	jne P4_dont_reset
	mov edi, OFFSET P4_key
	mov P4_counter,0
P4_dont_reset:
	loop P4_L1
P4_leave:
	popad
	ret
P4_Encryption ENDP

P6_GCD PROC
	cmp eax, 0
	js P6_negative_x
	jns P6_cont
P6_negative_x:
	neg eax
P6_cont:
	cmp ebx, 0
	js P6_negative_y
	jns P6_cont_2
P6_negative_y:
	neg ebx
P6_cont_2:
	mov edx, 0									;cleared just in case I did something with it
	div ebx										; this is going to put x/y in eax, and x%y in edx
	mov eax, ebx
	mov ebx, edx
	cmp edx, 0									; remainder in edx, if zero leave
	jbe P6_leave
	jmp P6_cont_2

P6_leave:	
	ret
P6_GCD ENDP

P7_bitwise_mul PROC
	mov ecx, 0
Bitwise:
	cmp eax, 0
	jz P6_leave									; if 0, leave
	shr eax, 1									; get eax to shift right
	jnc P6_continue								;
	push ebx
	shl ebx, cl
	add edx, ebx
	pop ebx
P6_continue:
	inc cl
	jmp Bitwise
P6_leave:
	add eax, edx
	ret
P7_bitwise_mul ENDP
	
end main