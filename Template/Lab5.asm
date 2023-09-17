; Lab5.asm Chapter 5
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD
.data
; Variables for Q1
Q1_myByte BYTE 0FFh, 0

; Variables for Q2
Q2_Rval DWORD ?
Q2_Xval BYTE 12h,0
Q2_Yval WORD 1234h,0
Q2_Zval DWORD 56781234h,0
.code
main PROC
COMMENT !
Q1 
1. Show the value of the destination operand after each of the following instructions executes. and state your reasoning
!

	mov al, Q1_myByte								; FF is placed into al
	mov ah, [Q1_myByte+1]							; 00 is placed into ah
	dec ah											; ah will become FF
	inc al											; al becomes 00
	dec ax											; al becomes FF, ah becomes FE

COMMENT !
Q2
Translate the following expression into assembly language.
Do not permit Xval (BYTE), Yval (WORD), or Zval (DWORD) to be modified:

Rval = Xval - (-Yval + Zval)
!
	mov eax, Q2_Zval								; done to make it able to make Rval equivalent to Zval
	mov Q2_Rval, eax								; Rval = Zval
	mov eax, DWORD PTR Q2_Yval						; eax = Yval
	sub Q2_Rval, eax								; Rval = -Yval + Zval
	neg Q2_Rval										; Rval = -(-Yval + Zval)
	mov eax, DWORD PTR Q2_Xval						; eax = Xval
	add Q2_Rval, eax								; Rval = Xval - (-Yval + Zval)

COMMENT !
Q3
For each of the following marked entries, 
show the values of the destination operand and the Sign, Zero, and Carry flags; state your finding.
!
													; CY = Carry, Zero = ZR, Sign = PL,
	mov eax, 0										; done to made sure previous problems don't affect result
	mov ebx, 0										; same as above
	mov ax,00FFh									; ax is now 00FFh, PL = 1, ZR = 0, CY = 0
	add ax,1										; ax should be 0100h, PL = 0, ZR and CY are still 0
	sub ax,1										; ax will be back to 00FFh, with the flags being the same
	add al,1										; thus ax will be 0000h, with ZR = 1, and CY = 1, PL = 0
	mov bh,6Ch										; bh is now 6Ch, ZR = 1, CY = 1, PL = 0, flags have not changed
	add bh,95h										; bh = 01h, ZR = 0, PL = 0 and CY = 1
	mov al,2										; al = 2, meaning ax is now 0002, flags have not changed
	sub al,3										; al is now FF, PL = 1, CY = 1, ZR = 0

COMMENT !
Q4
What will be the values of the given flags (CF, OF) after each operation and state your reasoning.
!
													; OV = Overflow Carry = CY
	mov eax, 0										; done to make sure previous problems don't affect result
	mov al,-128										; CY is 1, because it was set from before and has not been cleared
	neg al											; OV changes  to 1, because +128 will not fit into al, making it invalid
	mov ax,8000h									; OV and CY will be the same
	add ax,2										; CY is changed to 0, due to fitting in the 16-bit ax
	mov ax,0										; OV and CY will be the same
	sub ax,2										; CY is changed to 1, because 0-2, is a larger unsigned integer - small unsigned
	mov al,-5										; OV and CY will be the same
	sub al,+125										; OV = 1 due to overflow in al, CY = 0 due to fitting properly in al

COMMENT !
Q5
Not sure what this is asking for and how to achieve it
!

	INVOKE ExitProcess, 0
main ENDP
end main