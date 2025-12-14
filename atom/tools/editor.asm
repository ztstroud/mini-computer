; Text edit tool

; r8 is the selected line cursor
SETHI r8 &LINE_LIST_HEAD
SETLO r8 &LINE_LIST_HEAD

;MAIN_LOOP
SETHI r0 &INPUT_PROMPT
SETLO r0 &INPUT_PROMPT

SETHI r1 &PRINT_STR
SETLO r1 &PRINT_STR
CALL r1

SETHI r0 &INPUT_BUFFER
SETLO r0 &INPUT_BUFFER

SETHI r1 0x00
SETLO r1 0x0A

SETHI r2 &READ_STR
SETLO r2 &READ_STR
CALL r2

SETHI r1 0x00
SETLO r1 0x0A
P1WRITE r1 r1

READ r0 0x0 r3

;INSERT
SETHI r4 0x00 ;'i'
SETLO r4 0x69
CMP r3 r4
JNE 0x11 ;&PRINT

    MOV r8 r0
    SETHI r1 &LINE_LIST_INSERT
    SETLO r1 &LINE_LIST_INSERT
    CALL r1

    MOV r0 r8

    SETHI r1 0x00
    SETLO r1 0x02
    ADD r0 r1 ; data is offset by 2, so pass that

    SETHI r1 0x00
    SETLO r1 0x2D

    SETHI r2 &READ_STR
    SETLO r2 &READ_STR
    CALL r2

    SETHI r1 0x00
    SETLO r1 0x0A
    P1WRITE r1 r1

    JMP &MAIN_LOOP

;PRINT
SETHI r4 0x00 ;'p'
SETLO r4 0x70
CMP r3 r4
JNE 0x1E ;&NUM

    SETHI r9 &LINE_LIST_HEAD
    SETLO r9 &LINE_LIST_HEAD
    READ r9 0x0 r9

    SETHI rA &LINE_LIST_TAIL
    SETLO rA &LINE_LIST_TAIL

    ; current line number
    SETHI rB 0x00
    SETLO rB 0x01

    SETHI rC &PRINT_UDEC
    SETLO rC &PRINT_UDEC

    ;PRINT_LOOP
    CMP r9 rA
    JEQ &MAIN_LOOP

    MOV rB r0
    CALL rC

    SETHI r7 0x00
    SETLO r7 0x2A ;'*'
    CMP r9 r8
    JEQ 0x01 ;&PRINT_SPACER
    SETLO r7 0x20 ;' '

    ;PRINT_SPACER
    P1WRITE r7 r7

    SETLO r7 0x01
    ADD rB r7

    MOV r9 r0
    SETHI r1 0x00
    SETLO r1 0x02
    ADD r0 r1 ; data is offset by 2

    SETHI r4 &PRINTLN_STR
    SETLO r4 &PRINTLN_STR
    CALL r4

    READ r9 0x0 r9

    JMP 0xEB ;&PRINT_LOOP

;NUM
SETHI r4 0x00
SETLO r4 0x30 ;'0'
CMP r3 r4
JL 0x14 ;&DELETE
SETLO r4 0x39 ;'9'
CMP r3 r4
JG 0x11 ;&DELETE

    ; r0 is still the input buffer address
    SETHI r4 &PARSE_UDEC
    SETLO r4 &PARSE_UDEC
    CALL r4

    SETHI r8 &LINE_LIST_HEAD
    SETLO r8 &LINE_LIST_HEAD

    SETHI r9 &LINE_LIST_TAIL
    SETLO r9 &LINE_LIST_TAIL

    SETHI r2 0x00
    SETLO r2 0x01

    ;LOOP
    MOV r0 r0
    JEQ &MAIN_LOOP

    READ r8 0x0 r5

    ; Don't advance past the end
    CMP r5 r9
    JEQ &MAIN_LOOP

    MOV r5 r8
    SUB r0 r2

    JMP 0xF8 ;&LOOP

;DELETE
SETHI r4 0x00 ;'d'
SETLO r4 0x64
CMP r3 r4
JNE 0x09 ;&WRITE

    ; Do nothing if currently pointing at HEAD
    SETHI r1 &LINE_LIST_HEAD
    SETLO r1 &LINE_LIST_HEAD
    CMP r8 r1
    JEQ &MAIN_LOOP

    ; Prepare cursor for delete call, and set it
    ; to the previous node
    MOV r8 r0
    READ r8 0x1 r8

    SETHI r1 &LINE_LIST_REMOVE
    SETLO r1 &LINE_LIST_REMOVE
    CALL r1

    JMP &MAIN_LOOP

;WRITE
SETHI r4 0x00 ;'w'
SETLO r4 0x77
CMP r3 r4
JNE 0x06 ;&READ

    ; Get list cursor on first real node
    SETHI r0 &LINE_LIST_HEAD
    SETLO r0 &LINE_LIST_HEAD
    READ r0 0x0 r0

    SETHI r1 &WRITE_P0
    SETLO r1 &WRITE_P0
    CALL r1

    JMP &MAIN_LOOP

;READ
SETHI r4 0x00 ;'r'
SETLO r4 0x72
CMP r3 r4
JNE 0x09 ;&END

    SETHI r0 &LINE_LIST_CLEAR
    SETLO r0 &LINE_LIST_CLEAR
    CALL r0

    SETHI r8 &LINE_LIST_HEAD
    SETLO r8 &LINE_LIST_HEAD

    MOV r8 r0

    SETHI r1 &READ_P0
    SETLO r1 &READ_P0
    CALL r1

;END
JMP &MAIN_LOOP

;=WRITE_P0
; Params:
; r0 - address of node to start from

    ; Have write cursor
    SUB r1 r1

    SETHI r6 &LINE_LIST_TAIL
    SETLO r6 &LINE_LIST_TAIL

    ; Constant 1
    SETHI r7 0x00
    SETLO r7 0x01

    ;LOOP
    ; while not null
    CMP r0 r6
    JEQ 0x10 ;&DONE

    ; Get string start
    MOV r0 r2
    ADD r2 r7
    ADD r2 r7

    ;STRLOOP
    READ r2 0x0 r3
    MOV r3 r3
    JEQ 0x04 ;&ENDLINE
    P0WRITE r1 r3
    ADD r1 r7
    ADD r2 r7
    JMP 0xF9 ;&STRLOOP

    ;ENDLINE
    SETHI r2 0x00
    SETLO r2 0x0A
    P0WRITE r1 r2
    ADD r1 r7

    ; advance cursor
    READ r0 0x0 r0

    JMP 0xEE ;&LOOP

    ;DONE
    ; write null terminator
    SUB r0 r0
    P0WRITE r1 r0

RET

;=READ_P0
; Read lines from P0 into the editor
;
; Params:
; r0 - address of the node to add after

    PUSH r8

    SUB r8 r8 ; P0 address

    ;LINE_LOOP
    P0READ r8 r1
    MOV r1 r1
    JEQ &RETURN

    SETHI r7 &LINE_LIST_INSERT
    SETLO r7 &LINE_LIST_INSERT
    CALL r7

    SETHI r7 0x00
    SETLO r7 0x02

    MOV r0 r1
    ADD r1 r7

    ;READ_LOOP
    P0READ r8 r2
    SETLO r7 0x0A
    CMP r2 r7
    JEQ &DONE

    WRITE r1 0x0 r2

    SETLO r7 0x01
    ADD r1 r7
    ADD r8 r7

    JMP &READ_LOOP

    ;DONE
    ; r8 was \n, move to next
    SETLO r7 0x01
    ADD r8 r7

    JMP &LINE_LOOP

    ;RETURN
    POP r8

RET

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

;=PRINTLN_STR
; Print a null terminated string and a
; newline to the P1 terminal
;
; Params:
; r0 - address of the string to write

SETHI r1 &PRINT_STR
SETLO r1 &PRINT_STR
CALL r1

SETHI r1 0x00
SETLO r1 0x0A
P1WRITE r1 r1

RET

;=PRINT_UDEC
; Print a number to the P1 terminal in
; decimal
;
; Params:
; r0 - unsigned number to convert

; Preserve
PUSH r9
PUSH rA

SETHI r9 &DIV_REMAINDER
SETLO r9 &DIV_REMAINDER

SETHI rA 0x00
SETLO rA 0x30

SETHI r1 0x27 ; 10000
SETLO r1 0x10
CALL r9

ADD r1 rA
P1WRITE r1 r1

SETHI r1 0x03 ; 1000
SETLO r1 0xE8
CALL r9

ADD r1 rA
P1WRITE r1 r1

SETHI r1 0x00 ; 100
SETLO r1 0x64
CALL r9

ADD r1 rA
P1WRITE r1 r1

SETHI r1 0x00 ; 10
SETLO r1 0x0A
CALL r9

ADD r1 rA
P1WRITE r1 r1

ADD r0 rA
P1WRITE r0 r0

; Restore
POP rA
POP r9

RET

;=DIV_REMAINDER
; Computes the quotient and remainder of
; dividing r0 by r1
;
; Implemented as a loop, so not recommended
; for numbers where you expect a large
; quotient
;
; Params:
; r0 - unsigned numerator
; r1 - unsigned denominator
;
; Returns:
; r0 - remainder
; r1 - quotient

MOV r1 r2

SUB r1 r1

SETHI r7 0x00
SETLO r7 0x01

;LOOP
CMP r0 r2
JL 0x03 ;&DONE

SUB r0 r2
ADD r1 r7

JMP 0xFB ;&LOOP

;DONE
RET

;=PARSE_UDEC
; Convert an unsigned decimal in a string to
; a value in a register
;
; Conversion is abandoned in its current
; state when a non-digit character is
; encountered.
;
; Params:
; r0 - Address of null terminated string to
;      convert
;
; Returns:
; r0 - The converted value

SETHI r4 0x00
SETLO r4 0x0A

SETHI r5 0x00
SETLO r5 0x30

SETHI r6 0x00
SETLO r6 0x39

SETHI r7 0x00
SETLO r7 0x01

SUB r1 r1

;LOOP
READ r0 0x0 r2
CMP r2 r5
JL 0x07 ;&DONE
CMP r2 r6
JG 0x05 ;&DONE

SUB r2 r5
MUL r1 r4
ADD r1 r2

ADD r0 r7
JMP 0xF6 ;&LOOP

;DONE
MOV r1 r0

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

;=ALLOC
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

; The line list is made out of nodes. Each
; node starts with a pointer to the next and
; the previous node. The head and tail nodes
; are special, and only consist of two words.
; Content nodes are 48 words total, with the
; later 46 words being null terminated text.
; This gives lines a max length of 45
; characters.

;=LINE_LIST_INSERT
; Insert a new entry into the line list after
; the given node
;
; The given node MUST HAVE a next node
;
; Params:
; r0 the address of the node to insert after
;
; Returns:
; r0 - the address of the newly inserted node

PUSH r0

SETHI r0 0x00
SETLO r0 0x30

SETHI r7 &ALLOC
SETLO r7 &ALLOC
CALL r7

POP r1
READ r1 0x0 r2

WRITE r0 0x0 r2
WRITE r0 0x1 r1
WRITE r1 0x0 r0
WRITE r2 0x1 r0

RET

;=LINE_LIST_REMOVE
;
; Do not call remove on the head or tail,
; everything will explode
;
; Params:
; r0 - node to remove

READ r0 0x0 r1
READ r0 0x1 r2

WRITE r1 0x1 r2
WRITE r2 0x0 r1

; TODO: save and reuse deleted nodes to save
; heap space

RET

;=LINE_LIST_CLEAR
; Clear all entries from the line list

    PUSH r8
    PUSH r9
    PUSH rA

    SETHI r8 &LINE_LIST_HEAD
    SETLO r8 &LINE_LIST_HEAD
    READ r8 0x0 r8

    SETHI r9 &LINE_LIST_TAIL
    SETLO r9 &LINE_LIST_TAIL

    SETHI rA &LINE_LIST_REMOVE
    SETLO rA &LINE_LIST_REMOVE

    ;LOOP
    CMP r8 r9
    JEQ 0x04 ;&DONE

    MOV r8 r0
    READ r8 0x0 r8

    CALL rA

    JMP 0xFA ;&LOOP

    ;DONE
    POP rA
    POP r9
    POP r8

RET

;LINE_LIST_HEAD
&LINE_LIST_TAIL
0000
;LINE_LIST_TAIL
0000
&LINE_LIST_HEAD

;HEAP_PTR
&HEAP
;HEAP
0000

