; SethWhitakerProj3.asm - Project 4
; Seth Whitaker: 06/21/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

source BYTE "This is the string that will be reversed", 0
target BYTE SIZEOF source DUP('#')

.code
main PROC

	mov esi, OFFSET target - 2	; Adress 2 bytes before target 
	mov edi, OFFSET target		; Adress of first byte of target
	mov ecx, SIZEOF source - 1	; Size of source string minus null char

L1:
	mov al, [esi]				; Move char from current source address into al reg
	mov [edi], al				; Move char from al reg to current target address

	dec esi						; Move backwards one byte in source
	inc edi						; Move forwards one byte in target
	
	loop L1						; loop

	mov al, 0					; After loop terminates, edi is pointing to last char of target	
	mov [edi], al				; Therefore, replace that char with null char

	INVOKE ExitProcess, 0		; Exit with code 0

main ENDP
END main
