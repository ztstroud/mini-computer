SETHI r8 0x01 ; next block location
; r9 is the head

;MAIN_LOOP
CALL 0x0D;>READ_STR
CALL 0x01;>PRINT_STR
JMP 0xFD;>MAIN_LOOP

;=PRINT_STR
; print a null terminated string
; r0: string start
; Assumes that P1 is I/O

SUB r1 r1
SETLO r1 0x01

;PRINT_LOOP
READ r0 0x0 r2
CMP r2 r1
JGE 0x03;>PRINT_PRINT

SETLO r1 0x0A ; write newline at end
P1WRITE r1 r1
RET

;PRINT_PRINT
P1WRITE r2 r2
ADD r0 r1
JMP 0xF7;>PRINT_LOOP


;=READ_STR
; reads a string from input, returns pointer
; to a null terminated string in r0
; Assumes that P1 is I/O

SUB r0 r0
SUB r4 r4 ; str length

SETHI r1 0x70 ; string buffer in memory
SETLO r1 0x00
MOV r1 r2 ; current char in buffer

;READ_LOOP
P1READF r3 r3
SETLO r0 0x01
CMP r3 r0
JEQ 0x01;>GET_CHAR
JMP 0xFB;>READ_LOOP

;GET_CHAR
P1READ r3 r3
SETLO r0 0x08
CMP r3 r0
JEQ 0x08;>BACKSPACE
SETLO r0 0x0A
CMP r3 r0
JEQ 0x0D;>ENTER

; all other characters
WRITE r2 0x0 r3 ; write to buffer
P1WRITE r3 r3   ; write to screen
SETLO r0 0x01   ; setup 0x0001
ADD r2 r0       ; Add one to r2
JMP 0xEF;>READ_LOOP

;BACKSPACE
CMP r2 r1       ; compare current to start buffer
JLE 0xED;>READ_LOOP

SETLO r0 0x01   ; setup 0x0001
SUB r2 r0       ; subtract one from r2
SETLO r0 0x00   ; setup 0x0000
WRITE r2 0x0 r0 ; write 0x0000 to buffer
P1WRITE r3 r3   ; write backspace to screen
JMP 0xE7;>READ_LOOP

;ENTER
SETLO r0 0x00
WRITE r2 0x0 r0
P1WRITE r3 r3
MOV r1 r0
RET

