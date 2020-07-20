; SethWhitakerProj6.asm - Project 6
; Seth Whitaker: 06/29/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

INCLUDE irvine32.inc

.data
; -------------------------------------------------------------

; Case table used to allow user to decide what function to call

CaseTable BYTE '1'
          DWORD X_And_Y
EntrySize = ($ - CaseTable)					; size of each entry
		  BYTE '2'
		  DWORD X_Or_Y
		  BYTE '3'
		  DWORD Not_X
		  BYTE '4'
		  DWORD X_Xor_Y
		  BYTE '5'
		  DWORD Exit_Program
NumEntries = ($ - CaseTable) / EntrySize	; number of entries

; --------------------------------------------------------------

; These are output at the beginning of each procedure as 
;		feedback to user

s1 BYTE "Boolean AND", 0dh, 0ah, 0dh, 0ah, 0
s2 BYTE "Boolean OR", 0dh, 0ah, 0dh, 0ah, 0
s3 BYTE "Boolean NOT", 0dh, 0ah, 0dh, 0ah, 0
s4 BYTE "Boolean XOR", 0dh, 0ah, 0dh, 0ah, 0
s5 BYTE "Thanks for using FHSU Boolean Calculator!", 0dh, 0ah, 0dh, 0ah, 0

; ---------------------------------------------------------------

; This is the menu prompt that displays all the options
;		and asks user to pick one

menuPrompt BYTE "1. X AND Y", 0dh, 0ah
	 BYTE "2. X OR Y", 0dh, 0ah
	 BYTE "3. NOT X", 0dh, 0ah
	 BYTE "4. X XOR Y", 0dh, 0ah
	 BYTE "5. Exit Program", 0dh, 0ah
	 BYTE 0dh, 0ah
	 BYTE "Enter Choice: ", 0

; ---------------------------------------------------------------

; These are prompts for the user to enter input

op1Prompt BYTE "Enter 1st 32-bit hexadecimal operand: ", 0
op2Prompt BYTE "Enter 2nd 32-bit hexadecimal operand: ", 0
opPrompt BYTE  "Enter 32-bit hexadecimal operand:     ", 0
result BYTE    "The 32-bit hexadecimal result is:     ", 0
continuePrompt BYTE "Press any key to continue ...", 0

; --------------------------------------------------------------

endline BYTE 0dh, 0ah, 0

.code
; ---------------------------------------------------------------
	main PROC
; ---------------------------------------------------------------
L1:
	MOV edx, OFFSET menuPrompt  ; Output menu
	CALL WriteString 

	CALL ReadChar				; Read char into al
	CALL WriteChar				; Echo input

	MOV edx, OFFSET endline		; Output blank line
	CALL WriteString
	CALL WriteString

	MOV ebx, OFFSET CaseTable   ; Point ebx to table
	MOV ecx, NumEntries         ; Init loop counter
L2:
	CMP al, [ebx]				; Compare input char (al) to CaseTable char that ebx points to
	JNE L3						; If not equal: jump to L2
								; If equal:
	CALL NEAR PTR [ebx+1]		; Call procedure

	JMP L4						; Exit loop
L3:
	ADD ebx, EntrySize			; Point ebx to next entry
	LOOP L2						; Loop
L4:

	CMP eax, 0					; Check to see if eax is 0
	JNE L1						; If not 0, loop program

	INVOKE ExitProcess, 0		; If 0, exit with code 0

main ENDP


; ---------------------------------------------------------------
	Get2ops PROC USES edx
;
;	Takes 2 32-bit hex operands from console input and returns 
;		them
;
;	Returns: 2 hex in eax and ebx
; ---------------------------------------------------------------

	MOV edx, OFFSET op1Prompt	; Prompt user for 1st operand
	CALL WriteString

	CALL ReadHex				; Read 32-bit hex into eax
	MOV ebx, eax				; Move input to ebx

	MOV edx, OFFSET op2Prompt	; Prompt user for 2nd operand
	CALL WriteString

	CALL ReadHex				; Read 32-bit hex int eax

	RET
Get2ops ENDP

; ----------------------------------------------------------------
	OutputResult PROC USES edx

;	Outputs 32-bit hex result in eax to console in specific 
;		format and waits for user to continue
;	Recieves: result from eax 
; ----------------------------------------------------------------


	MOV edx, OFFSET result		; Output result string
	CALL WriteString
	CALL WriteHex				; Output eax
	
	MOV edx, OFFSET endline		; Output blank line
	CALL WriteString			
	CALL WriteString			

	MOV edx, OFFSET continuePrompt	; Prompt user to continue
	CALL WriteString
	CALL ReadChar

	MOV edx, OFFSET endline		; Output blank line
	CALL WriteString			
	CALL WriteString

	MOV eax, 1					; While loop checks for 0
								; So make sure to repeat
	RET
OutputResult ENDP


; ----------------------------------------------------------------
	X_And_Y PROC USES eax edx
;
;	 Takes 2 32-bit hex operands from console and outputs the
;		result of ANDing them together
; ----------------------------------------------------------------

	MOV edx, OFFSET s1			; Output Procedure name
	CALL WriteString

	CALL Get2ops				; Get input from user

	AND eax, ebx				; AND both operands

	CALL OutputResult			; Output result

	RET
X_And_Y ENDP


; ----------------------------------------------------------------
	X_Or_Y PROC USES eax edx
;
;	Takes 2 32-bit hex operand from console and outputs the
;		result of ORing them together
; ----------------------------------------------------------------

	MOV edx, OFFSET s2			; Output Procedure name
	CALL WriteString

	CALL Get2ops				; Get input from user

	OR eax, ebx					; OR both operands

	CALL OutputResult			; Output result			

	RET
X_Or_Y ENDP


; ----------------------------------------------------------------
	Not_X PROC USES edx
; Takes 1 32-bit hex operand from console and outputs the
;	result of NOTing 
; ----------------------------------------------------------------

	MOV edx, OFFSET s3			; Output Procedure name
	CALL WriteString

	MOV edx, OFFSET opPrompt	; Prompt user for operand
	CALL WriteString

	CALL ReadHex				; Read 32-bit hex into eax

	NOT eax						; NOT eax

	CALL OutputResult			; Output result

	RET
Not_X ENDP


; ----------------------------------------------------------------
	X_Xor_Y PROC USES eax edx
;
; Takes 2 32-bit hex operands from console and outputs the
;	result of XORing them together
; ----------------------------------------------------------------

	MOV edx, OFFSET s4			; Output Procedure name
	CALL WriteString

	CALL Get2ops				; Get input from user

	XOR eax, ebx				; XOR both operands

	CALL OutputResult			; Output result

	RET
X_Xor_Y ENDP


; ----------------------------------------------------------------
	Exit_Program PROC USES edx
;
;	There is a while loop that checks if eax is 0 after every 
;	iteration so changing it to 0 here will allow the program to 
;	exit after current iteration finishes
; ----------------------------------------------------------------

	MOV edx, OFFSET s5  ; Output Procedure name
	CALL WriteString

	MOV eax, 0			; Move 0 into eax
						
	RET
Exit_Program ENDP


END main