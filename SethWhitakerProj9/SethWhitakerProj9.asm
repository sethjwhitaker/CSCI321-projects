; SethWhitakerProj9.asm - Project 9
; Seth Whitaker: 07/16/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

INCLUDE irvine32.inc

.data

sourceString BYTE 21 DUP(0)
targetString BYTE 21 DUP(0)   
stringBuffer BYTE 21 DUP(0)

sourceStringPrompt BYTE "Enter source string (the string to search from): ", 0
targetStringPrompt BYTE "Enter target string (the string to search for): ", 0
resultString1 BYTE "Target string found at position ", 0
resultString2 BYTE " in source string (counting from zero).", 0dh, 0ah, 0dh, 0ah, 0
resultString3 BYTE "Target string not found in source string.", 0dh, 0ah, 0dh, 0ah, 0
repeatPrompt BYTE "Do you want to do another search? y/n: ", 0
invalidPrompt BYTE "Please enter a valid choice (y/n): "
endline BYTE 0dh, 0ah, 0

.code

;-------------------------------------
	GetStrings PROC
;	
;	get source and target string
;	and store them in memory
;	
;-------------------------------------

	MOV edx, OFFSET sourceStringPrompt	; prompt user for source string
	CALL WriteString

	MOV edx, OFFSET sourceString		; store string in sourceString
	MOV ecx, SIZEOF sourceString	
	CALL ReadString

	MOV edx, OFFSET targetStringPrompt	; prompt user for target string
	CALL WriteString

	MOV edx, OFFSET targetString		; store string in targetString
	MOV ecx, SIZEOF targetString
	CALL ReadString

	RET
GetStrings ENDP

;-------------------------------------
	OutputResult PROC USES edx

;	Outputs the result of Str_find

;	Recieves: index in eax
;-------------------------------------

	MOV edx, OFFSET resultString1		; Output 1st part of string
	CALL WriteString

	CALL WriteDec						; Output index

	MOV edx, OFFSET resultString2		; Output 2nd part of string
	CALL WriteString

	RET
OutputResult ENDP



;-------------------------------------
	VerifyRepeat PROC USES edx

;	Verifies char in eax is y, n, Y, N
;	and returns 0 or 1 depending on letter

;	Recieves: char in eax
;	Returns: 0 or 1 in eax
;-------------------------------------

L1:	
	CMP al, 79h						; eax == 'y'
	JE L2
	CMP al, 59h						; eax == 'Y'
	JNE L3
L2:	
	MOV eax, 1						; Return "true"
	JMP QUIT						; Exit procedure

L3:
	CMP al, 6Eh						; eax == 'n'
	JE L4
	CMP al, 4Eh						; eax == 'N'
	JNE L5
L4:	
	MOV eax, 0						; Return "false"
	JMP QUIT						; Exit procedure

L5:									; invalid input
	
	MOV edx, OFFSET invalidPrompt	; Prompt user to enter again
	CALL WriteString
SHIFT:
	CALL ReadChar					; Get response in eax

	CMP al, 0Fh						; If shift is pressed
	JE SHIFT						; Read next char
	
	CALL WriteChar					; Output Char
	MOV edx, OFFSET endline			; Output blank line
	CALL WriteString

	JMP L1

QUIT:
	RET
VerifyRepeat ENDP


;-------------------------------------
	SubString PROC USES eax ecx esi edi, 
		source:PTR BYTE,				; Address of source string
		target:PTR BYTE,				; Address of target string
		startPos:DWORD,					; start index
		endPos:DWORD					; end index
	
;	Stores a substring of source in 
;	target
;
;	Requires: target must be large 
;		enough to hold substring
;-------------------------------------
	
	MOV esi, source						; Point esi to start position
	ADD esi, startPos

	MOV edi, target						; Point edi to target string

	MOV ecx, endPos						; Move end index to ecx
	SUB ecx, startPos					; Subtract start	
	ADD ecx, 1							; Add 1 

L1:
	MOV al, BYTE PTR [esi]				; Move source char to al
	MOV BYTE PTR [edi], al				; Move al to target
		
	INC esi								; Move both pointers to next address
	INC edi

	LOOP L1								; loop

	RET
SubString ENDP



;-------------------------------------
	Str_find PROC,
		source:PTR BYTE,
		target:PTR BYTE
;-------------------------------------
	
	INVOKE Str_length, target			; Find length of target
	MOV ebx, eax						; Move length of target to ebx
	INVOKE Str_length, source			; Find length of source
	CMP eax, ebx						; If source length < target length
	JB NF								; String not found

	MOV esi, 0							; start index
	MOV edi, ebx						; end index
	DEC edi

	SUB eax, ebx						; Subtract length of target from source
	ADD eax, 1							; Add 1
	MOV ecx, eax						; Treat result as loop counter

L1:	
	; Store substring of length of target in string buffer
	INVOKE SubString, source, ADDR stringBuffer, esi, edi

	; compare target and buffer
	INVOKE Str_compare, target, ADDR stringBuffer

	JE FOUND							; Jump if found

	INC esi								; mov to next substr
	INC edi

	LOOP L1								; loop

NF:										; If string not found
	MOV eax, 1							; Clear zero flag
	JMP QUIT							; Exit procedure

FOUND:									; If string is found
	MOV eax, esi						; Set eax to index of start of string
	MOV esi, 0

QUIT:
	RET
Str_find ENDP



;-------------------------------------
	main PROC
;-------------------------------------

L1:
	CALL GetStrings
	INVOKE Str_find, ADDR sourceString, ADDR targetString
	JNZ NotFound						; if not found jump

	CALL OutputResult					; else: output result
	JMP ShouldRepeat

NotFound:
	MOV edx, OFFSET resultString3		; Output not found string
	CALL WriteString

ShouldRepeat:
	MOV edx, OFFSET repeatPrompt		; Ask user if they wish to repeat
	CALL WriteString
SHIFT:
	CALL ReadChar						; Get response in eax

	CMP eax, 0Fh						; If shift is pressed
	JE SHIFT							; Read next char
	
	CALL WriteChar						; Output Char
	MOV edx, OFFSET endline				; Output blank line
	CALL WriteString

	CALL VerifyRepeat					; Evaluate response
	CMP al, 0							; if 0 is returned
	JE QUIT								; Quit
	LOOP L1								; else: repeat

QUIT:
	INVOKE ExitProcess, 0
main ENDP

END main