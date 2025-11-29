; Text edit tool

SETHI r0 0x01
SETLO r1 0x30

CALL &READ_STR
HALT

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

