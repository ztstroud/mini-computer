SETHI r8 0x01 ; next block location
; r9 is the head
; rA is the selected block

;MAIN_LOOP
SETHI r0 0x70
SETLO r0 0x00
CALL 0x33;>READ_STR
READ r0 0x0 r1

SETHI r2 0x00
SETLO r2 0x69
CMP r1 r2
JEQ 0x04;>CMD_i

SETLO r2 0x70
CMP r1 r2
JEQ 0x17;>CMD_p

JMP 0xF4;>MAIN_LOOP

;CMD_i
; (i) command
; first, prepare a new block
MOV r8 r2 ; r2 is new block location
SUB r0 r0
SETLO r0 0x30
ADD r8 r0 ; move next block forward by 0x30
WRITE r2 0x1 rA ; r2.prev = rA (new.prev = current)
SETLO r0 0x00 ; zero out r0 again
CMP rA r0
JEQ 0x06;>BLOCK_READY

READ rA 0x0 r7 ; r7 = rA.next (r7 is a copy of selected's next)
WRITE r2 0x0 r7 ; r2.next = r7 (new.next = selected.next)
WRITE rA 0x0 r2 ; rA.next = r2 (selected.next = new)

CMP r7 r0
JEQ 0x01;>BLOCK_READY

WRITE r7 0x1 r2 ; r7.prev = r2 (selected.next.prev = new)

;BLOCK_READY
MOV r2 rA ; (selected = new)

CMP r9 r0
JNE 0x01;>HEAD_ALREADY_SET

MOV rA r9 ; set head to current if not set

;HEAD_ALREADY_SET
; rA is the current block, which we need to write into
SETLO r0 0x02
ADD r0 rA ; need to take into account the offset for data in block
CALL 0x15;>READ_STR

JMP 0xDE;>MAIN_LOOP

;CMD_p
MOV r9 rC

;PRINT_LOOP
SUB r0 r0
CMP rC r0
JEQ 0xDA;>MAIN_LOOP

SETLO r0 0x02
ADD r0 rC
CALL 0x02;>PRINT_STR

READ rC 0x0 rC
JMP 0xF8;>PRINT_LOOP


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
; reads a string from input into a given location in r0
; the memory location is returned in r0
; to a null terminated string in r0
; Assumes that P1 is I/O

MOV r0 r1
MOV r1 r2 ; current char in buffer
SUB r0 r0 ; will use r0 for comparison values, zero it out

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

