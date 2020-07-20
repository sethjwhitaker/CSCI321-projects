; SethWhitakerProj8.asm - Project 8
; Seth Whitaker: 07/08/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

INCLUDE irvine32.inc

.data

GCDStr1 BYTE "Greatest common divisor of (", 0
GCDStr2 BYTE ")", 0dh, 0ah, 0
loopStr BYTE "calculated by loop is: ", 0
recursiveStr BYTE "calculated by recursion is: ", 0

intArray WORD 5, 20, 24, 18, 11, 7, 432, 226, 26, 13

endline BYTE 0dh, 0ah, 0 

.code


; -------------------------------------------------
	abs PROC USES ebx,
		value:DWORD
;	Returns: absolute value of value in eax
; -------------------------------------------------

	MOV eax, value
	MOV ebx, eax		; Test if negative
	SHL ebx, 1
	JNC	L1				; If not negative, jump to L1

	NEG eax				; If negative, make positive
L1:

	RET
abs ENDP


; -------------------------------------------------
	GCDLoop PROC,
		valx:DWORD,
		valy:DWORD

;	Calculates Greatest common denominator using
;		loop algorithm

;   Returns: GCD in eax
; -------------------------------------------------

	INVOKE abs, valx		
	MOV valx, eax			; x = abs(x)

	INVOKE abs, valy		; y = abs(y)
	MOV valy, eax


L1:							; Do
	MOV eax, valx
	MOV edx, 0				; n = x % y
	DIV valy

	MOV eax, valy			; x = y
	MOV valx, eax			

	MOV valy, edx			; y = n

	CMP edx, 0				; While n > 0
	JNE L1

	MOV eax, valx

	RET
GCDLoop ENDP

; -------------------------------------------------
	GCDRecursiveInner PROC, 
		valx:DWORD,
		valy:DWORD

;	Calculates Greatest common denominator using
;		recursive algorithm

;	Returns: gcd in eax
; -------------------------------------------------

	MOV eax, valx		
	MOV ebx, valy			; if y = 0
	CMP ebx, 0
	JE L1					; return x

	MOV edx, 0				; n = x % y
	DIV ebx

	PUSH edx				
	PUSH ebx
	CALL GCDRecursive		; GCDRecursive(y, n)

L1:
	RET
GCDRecursiveInner ENDP

; -------------------------------------------------
	GCDRecursive PROC, 
		valx:DWORD,
		valy:DWORD

;	This procedure calls absolute value once
;		so it does not have to every recursive call

;	Returns: gcd in eax
; -------------------------------------------------

	INVOKE abs, valx		; Get absolute values
	MOV valx, eax			; x = abs(x)

	INVOKE abs, valy		; y = abs(y)
	MOV valy, eax

	INVOKE GCDRecursiveInner, valx, valy

	RET
GCDRecursive ENDP



; -------------------------------------------------
	OutputGCD PROC,
		valx:DWORD,
		valy:DWORD

;	This procedure handles output and calls
;		GCDLoop and GCDRecursive with valx and valy
;		as arguments
; -------------------------------------------------

	MOV edx, OFFSET GCDStr1			; Output 1st half of GCD string
	CALL WriteString

	MOV eax, valx					; Output x
	CALL WriteDec

	MOV eax, 44						; Output ,
	CALL WriteChar

	MOV eax, valy					; Output y
	CALL WriteDec

	MOV edx, OFFSET GCDStr2			; Output ) and endline
	CALL WriteString

	MOV edx, OFFSET loopStr			; Output loop string
	CALL WriteString

	INVOKE GCDLoop, valx, valy		; Calculate loop GCD
	CALL WriteDec					; Output result
	
	MOV edx, OFFSET endline			; Output end line
	CALL WriteString

	MOV edx, OFFSET recursiveStr	; Output recursive string
	CALL WriteString

	INVOKE GCDRecursive, valx, valy	; Calculate recursive GCD
	CALL WriteDec					; Output result

	MOV edx, OFFSET endline			; Output end line
	CALL WriteString

	RET								; Return

OutputGCD ENDP



; -------------------------------------------------
	main PROC
; -------------------------------------------------

	; Calculate GCD for each pair of elements in intArray
	INVOKE OutputGCD, [intArray], [intArray+2]
	INVOKE OutputGCD, [intArray+4], [intArray+6]
	INVOKE OutputGCD, [intArray+8], [intArray+10]
	INVOKE OutputGCD, [intArray+12], [intArray+14]
	INVOKE OutputGCD, [intArray+16], [intArray+18]
	

	INVOKE ExitProcess, 0

main ENDP

END main