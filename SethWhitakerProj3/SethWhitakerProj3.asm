; SethWhitakerProj3.asm - Project 3
; Seth Whitaker: 06/15/2020

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

; Part 2. Seven days of the week

SUNDAY = 0
MONDAY = 1
TUESDAY = 2
WEDNESDAY = 3
THURSDAY = 4
FRIDAY = 5
SATURDAY = 6

weekArray BYTE SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY

; Part 3. Intrinsic data types

byteExample BYTE 17h
signedByteExample SBYTE -8
wordExample WORD 384
signedWordExample SWORD 9FF2h
doubleWordExample DWORD 66666
signedDoubleWordExample SDWORD 1F28D0EEh
farPointerWordExample FWORD 00F0EABDC1FFh
quadWordExample QWORD -600000000000000
tenByteExample TBYTE 8FFFFFFFFFFF00EE11DDh
real4Example REAL4 2.0E+3
real8Example REAL8 1.1E-259
real10Example REAL10 1.18E+4000

; Part 4. Symbolic names with strings

today EQU <"16th">
thisMonth EQU <"JUNE,">
thisYear EQU <"2020", 0>

; Create a date string using today, thismonth, and thisyear
date BYTE today
	BYTE thisMonth
	BYTE thisYear


.code
main PROC

; Part 1. A = (A + B) - (C + D)

	mov eax, 5					; Assign 5 to A
	mov ebx, -3					; Assign -3 to B
	mov ecx, 18					; Assign 18 to C
	mov edx, 3					; Assign 3 to D

	add eax, ebx				; Add B to A
	add ecx, edx				; Add D to C
	sub eax, ecx				; Subtract C from A


	INVOKE ExitProcess, 0		; Exit with code 0

main ENDP
END main