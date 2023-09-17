; Chapter6AlgorithmWorkbench.asm Chapter 6
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data

; Variables for Question 2
Q2_32_bit DWORD 45AB7012h

; Variables for Question 10
Q10_N DWORD 9
Q10_A DWORD 7
Q10_B DWORD 6
.code
main PROC

COMMENT $
Q1
Write a single instruction that converts an ASCII digit in AL to its corresponding binary
value. If AL already contains a binary value (00h to 09h), leave it unchanged

Answer: After looking at it, I believe I am supposed to change the ascii code for i.e. 9, which would be 57d,
or 00111001b into the actual binary code for 9, which would be 00001001b. After examining, 
I realized we didn't need the 4th to 7th bits, which means we can use and to clear those to get the right
number.
$
mov al, 00111001b												; testing '9', which is 57 in binary
and al, 00001111b												; remove the 4th to 7th bits, to get result

COMMENT $
Q2
Write instructions that calculate the parity of a 32-bit memory operand.
Hint: Use the formula presented earlier in this section: B0 XOR B1 XOR B2 XOR B3.

Answer: If I am correct, then just doing xor multiple times should be enough to get the correct answer.
45AB7012 will be our test, with its binary equivalent as 0100 0101 1010 1011 0111 0000 0001 0010.
This has 13 ones, so parity should be odd.
45AB7012
B3B2B1B0
Then we just need to xor repeatedly using byte pointers for B0-B4
Accordingly, xor will make the destination have the parity of the entire bit, which means we are
just building up the parity byte by byte
$
mov al, BYTE PTR Q2_32_bit
xor al, BYTE PTR [Q2_32_bit+1]									; this should be done to get B0 and B1
																; now al has the parity of 0 (odd)
xor al, BYTE PTR [Q2_32_bit+2]									; now al should have parity of 1 (even)
xor al, BYTE PTR [Q2_32_bit+3]									; now al should have parity of 0 (odd)

COMMENT $
Q4
Write instructions that jump to label L1 when the unsigned integer in DX is less than or
equal to the integer in CX.
$
mov dx, 100														; dx is now 100
mov cx, 101														; cx is 101, which means it should jump
cmp dx, cx
jbe L1
mov eax, 0														; happens if no jump
L1:

COMMENT $
Q5
Write instructions that jump to label L2 when the signed integer in AX is greater than the
integer in CX
$
mov ax, +150														; ax is now +150
mov cx, +100														; cx is now less than ax
cmp ax, cx
jg L2																; if ax is greater, jump to L2
mov eax, 0
L2:

COMMENT $
Q10
Implement the following pseudocode in assembly language. Use short-circuit evaluation
and assume that A, B, and N are 32-bit signed integers. 
while N > 0
 if N != 3 AND (N < A OR N > B)
 N = N – 2
 else
 N = N – 1
end whle
$
L3:
	cmp Q10_N, 0													; compare n to 0
	jbe L_exit														; if N is less than or equal to 0, leave loop
	cmp Q10_N, 3													; then compare N to 3
	je L_else														; if equal go to else
	mov eax, Q10_A													; go to next condition, for cmp
	cmp Q10_N, eax													; cmp Q10_N and Q10_A
	jb L_yes														; if N<A, go to yes
	mov ebx, Q10_B
	cmp Q10_N, ebx
	ja L_yes														; if N > B, go to yes
	jmp L_else														; if these conditions fail, go to else
L_yes:
	sub Q10_N, 2													; N = N - 2
	jmp L3
L_else:
	sub Q10_N, 1													; N = N - 1
	jmp L3
L_exit:
	
	INVOKE ExitProcess, 0
main ENDP
END main