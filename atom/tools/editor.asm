; Text edit tool

SETLO r9 0x0A

SETHI rA &READ_STR
SETLO rA &READ_STR

SETHI rB &PRINT_STR
SETLO rB &PRINT_STR

;LOOP
SETHI r0 &INPUT_PROMPT
SETLO r0 &INPUT_PROMPT

CALL rB

SETHI r0 &INPUT_BUFFER
SETLO r0 &INPUT_BUFFER

SETHI r1 0x00
SETLO r1 0x0A

CALL rA
P1WRITE r9 r9

CALL rB
P1WRITE r9 r9

JMP 0xF4 ;&LOOP

;=PRINT_STR
; Print a null terminated string to the P1
; terminal
;
; Params:
; r0 - address of the string to write

SETHI r1 0x00
SETLO r1 0x01

;LOOP
READ r0 0x0 r2

CMP r2 r1
JL 0x03 ;&DONE

P1WRITE r2 r2
ADD r0 r1
JMP 0xFA ;&LOOP

;DONE
RET

;=READ_STR
; Read a string of max length r1 from the P1
; terminal into the buffer at r0
;
; YOU MUST HAVE RESERVED r1+1 WORDS FROM r0
;
; Params:
; r0 - address to write to
; r1 - max length of string, without null
; terminator
;
; Returns:
; r0 - address written to
; r2 - address of null terminator

; r1 is the last possible position for the
; null terminator
ADD r1 r0

; r2 is the current terminator position
MOV r0 r2

;LOOP
P1READF r3
MOV r3 r3
JEQ 0xFD ;&LOOP

P1READ r3 r3

SETHI r4 0x00
SETLO r4 0x0A ; Enter
CMP r3 r4
JEQ 0x10 ;&DONE

SETLO r4 0x08 ; Backspace
CMP r3 r4
JEQ 0x07 ;&BACKSPACE

;CHAR
CMP r2 r1
JGE 0xF3 ;&LOOP

P1WRITE r3 r3
WRITE r2 0x0 r3
SETLO r4 0x01
ADD r2 r4
JMP 0xEE ;&LOOP

;BACKSPACE
CMP r2 r0
JLE 0xEC ;&LOOP

P1WRITE r3 r3
SETLO r4 0x01
SUB r2 r4
JMP 0xE8 ;&LOOP

;DONE
; null terminate the string
SUB r3 r3
WRITE r2 0x0 r3

RET

;ALLOC
; Reserve space on the heap
;
; Params:
; r0 - number of words to be reserved
;
; Returns:
; r0 - address of allocated space

SETHI r1 &HEAP_PTR
SETLO r1 &HEAP_PTR

READ r1 0x0 r2

MOV r2 r3
ADD r3 r0
WRITE r1 0x0 r3

MOV r2 r0

RET

;INPUT_BUFFER
0000
0000
0000
0000
0000
0000
0000
0000
0000
0000
0000

;INPUT_PROMPT
003E ;'>'
0020 ;' '
0000 ;null

;HEAP_PTR
&HEAP
;HEAP
0000

