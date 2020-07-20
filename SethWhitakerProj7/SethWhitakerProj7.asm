; SethWhitakerProj7.asm - Project 7
; Seth Whitaker: 07/01/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

INCLUDE irvine32.inc

.data

programTitle BYTE "Bitwise Multiplication of Unsigned Integers", 0dh, 0ah, 0

repeatPrompt BYTE "Do you want to do another calculation? y/n (all lowercase): ", 0

multiplicandPrompt BYTE "Enter the multiplicand: ", 0
multiplierPrompt BYTE   "Enter the multiplier:   ", 0
productStr BYTE         "The product is:         ", 0

endline BYTE 0dh, 0ah, 0

.code
; ---------------------------------------------------------------
	main PROC
; ---------------------------------------------------------------

L1:

	CALL multiplyIO						; handle multiply input and output

	MOV edx, OFFSET repeatPrompt		; Ask if user wants to repeat
	CALL WriteString 
	CALL ReadChar						; read response to al
	CALL WriteChar						; Echo input
	MOV edx, OFFSET endline				; Output blank line
	CALL WriteString
	CALL WriteString

	MOV bl, 79h							; move ascii 'y' to bl
	CMP al, bl							; compare al to bl
	JE L1								; Repeat if they are equal



	INVOKE ExitProcess, 0				; exit with code 0

main ENDP

; ---------------------------------------------------------------
	multiplyIO PROC USES eax ebx edx
;
;	The loop in the main procedure was too long so I moved the
;		code for handling input/output for bitwise multiply
;		function to a separate procedure
;
; ---------------------------------------------------------------

	MOV edx, OFFSET programTitle		; Output title
	CALL WriteString 
	MOV edx, OFFSET endline				; Output blank line
	CALL WriteString

	MOV edx, OFFSET multiplicandPrompt	; Prompt user for multiplicand
	CALL WriteString
	CALL ReadDec						; Read user input into eax
	MOV ebx, eax						; Move multiplicand to ebx

	MOV edx, OFFSET multiplierPrompt	; Prompt user for multiplier
	CALL WriteString
	CALL ReadDec						; Read input to eax
	MOV edx, OFFSET endline				; Output blank line
	CALL WriteString

	CALL BitwiseMultiply				; Multiply the two numbers

	MOV edx, OFFSET productStr			; Output product string
	CALL WriteString
	CALL WriteDec						; Output product
	MOV edx, OFFSET endline				; Output blank line
	CALL WriteString
	CALL WriteString

	RET
multiplyIO ENDP



; ---------------------------------------------------------------
	BitwiseMultiply PROC USES ebx edx ecx
;
;	Recieves: multiplier in eax
;			  multiplicand in ebx
;	Returns: product in eax
;	Requires: product must be less than 32 bits long
;
; ---------------------------------------------------------------

	MOV cl, 0							; Use cl as a counter
	MOV edx, 0							; Use edx as the product
	
L1:
	SHR eax, 1							; Shift eax right
	JNC	L2								; Jump if carry flag is not set

	PUSH ebx							; Save ebx
		SHL ebx, cl						; Shift ebx left cl times
		ADD edx, ebx					; Add ebx to sum
	POP ebx								; Restore ebx

L2:	
	INC cl								; Increment cl

	CMP eax, 0							; Loop if eax is not zero
	JNE L1

	MOV eax, edx						; Move edx (product) to eax

	RET									; Return
BitwiseMultiply ENDP

END main