; SethWhitakerProj5.asm - Project 5
; Seth Whitaker: 06/25/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

INCLUDE irvine32.inc

.data
	
	randstr BYTE 11 DUP(0)
	STRING_SIZE = 10
	prompt BYTE "Press any key to continue...", 0

.code
main PROC

	CALL randomize					; Initialize random seed

; Init randomString args
	MOV eax, STRING_SIZE			; move length STRING_SIZE into eax
	MOV esi, OFFSET randstr			; move offset of randstr into esi
	MOV edx, OFFSET randstr			; move offset of randstr into edx for output

; generate 20 random strings, each on its own line
	MOV ecx, 20						; loop 20 times
L1:
	CALL randomString				; generate random string

	CALL WriteString
	
	PUSH eax						; Save eax
	mov al, 10						; Output new line character
	CALL WriteChar
	POP eax							; Restore eax
	
	LOOP L1							; loop

; Prompt user to enter key to exit process
	MOV edx, OFFSET prompt			; Output prompt
	CALL WriteString
	CALL ReadChar					; Wait for user to type any key then exit

	INVOKE ExitProcess, 0			; Exit Process

main ENDP



;--------------------------------------------
; randomString
; Procedure that generates a random string
;
; Recieves: ESI: Array a offset
;           EAX: Length L of the random string
; Returns:  A random string of length L in the array a
; Requires: Array a is a BYTE array of at least length L+1
;--------------------------------------------
randomString PROC USES eax ecx esi

	MOV ecx, eax					; Loop L times
L1:
	
	MOV eax, 26						; Random num from 0-25
	CALL RandomRange
	ADD eax, 65						; Add 65 for capital letter ASCII

	MOV [esi], al					; Insert char into array
	INC esi							; Move to next char in array

	LOOP L1							; loop

	MOV al, 0
	MOV [esi], al					; Insert null char at end of string

	RET								; Return

randomString ENDP					

END main