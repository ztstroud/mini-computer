; Atom Assembler

SETHI r0 0x00
SETLO r0 0x02
SETHI r1 0x00
SETLO r1 0x02

SETHI r7 &LIST_CREATE
SETLO r7 &LIST_CREATE
CALL r7

SETHI r7 &LABEL_LIST
SETLO r7 &LABEL_LIST
WRITE r7 0x0 r0

MOV r0 r8
SETHI rA 0x00

SETHI r9 &LIST_ADD
SETLO r9 &LIST_ADD

CALL r9
SETLO rA 0x30 ;'0
WRITE r0 0x0 rA
SETLO rA 0x39 ;'9
WRITE r0 0x1 rA

MOV r8 r0
CALL r9
SETLO rA 0x61 ;'a
WRITE r0 0x0 rA
SETLO rA 0x7A ;'z
WRITE r0 0x1 rA

MOV r8 r0
CALL r9
SETLO rA 0x41 ;'A
WRITE r0 0x0 rA
SETLO rA 0x5A ;'Z
WRITE r0 0x1 rA

SETHI rB &LIST_EACH
SETLO rB &LIST_EACH

MOV r8 r0
SETHI r2 &CB_PRINT_RANGE
SETLO r2 &CB_PRINT_RANGE
CALL rB

MOV r8 r0
SETHI r1 0x00 ;'u
SETLO r1 0x75 ;'u
SETHI r2 &CB_IN_RANGE
SETLO r2 &CB_IN_RANGE
CALL rB

HALT

;LABEL_LIST
0000

;=CB_IN_RANGE
;
; Check if a character is in a character
; range
;
; Params:
; r0 - range address
; r1 - character to check
;
; Returns:
; r0 - 1 iff entry matches, 0 otherwise

    READ r0 0x0 r2
    READ r0 0x1 r3

    SUB r0 r0

    CMP r1 r2
    JL 0x03 ;&CB_IN_RANGE_FALSE

    CMP r1 r3
    JG 0x01 ;&CB_IN_RANGE_FALSE

    SETLO r0 0x01

    ;CB_IN_RANGE_FALSE
    RET

;=CB_PRINT_RANGE
;
; Print a character range with a hyphen and a
; newline
;
; Params:
; r0 - range address
;
; Returns:
; r0 - 0x0000

    READ r0 0x0 r1
    P1WRITE r2 r1

    SETHI r2 0x00
    SETLO r2 0x2D ;'-
    P1WRITE r2 r2

    READ r0 0x1 r1
    P1WRITE r2 r1

    SETLO r2 0x0A ;NEWLINE
    P1WRITE r2 r2

    SUB r0 r0
    RET

;$LIST_R_FIRST=0x0
;$LIST_R_LAST=0x1
;$LIST_R_SIZE=0x2
;$LIST_R_COUNT=0x3
;$LIST_R_SIZE=0x4

;$LIST_NEXT=0x0
;$LIST_COUNT=0x1
;$LIST_HEADER_SIZE=0x2

;=LIST_CREATE
; Params:
; r0 - size of entries
; r1 - number of entries
;
; Returns:
; r0 - address of created list

    PUSH r0
    PUSH r1

    SETHI r0 0x00 ;$LIST_R_SIZE
    SETLO r0 0x04 ;$LIST_R_SIZE

    SETHI r7 &ALLOC
    SETLO r7 &ALLOC
    CALL r7

    POP r2
    POP r1

    WRITE r0 0x2 r1 ;$LIST_R_SIZE
    WRITE r0 0x3 r2 ;$LIST_R_COUNT

    SETHI r7 &LIST_CREATE_PAGE
    SETLO r7 &LIST_CREATE_PAGE
    CALL r7

    WRITE r0 0x0 r1 ;$LIST_R_FIRST
    WRITE r0 0x1 r1 ;$LIST_R_LAST

RET

;=LIST_ADD
; Add a new entry
;
; Params:
; r0 - address of list root
;
; Returns:
; r0 - address of the new entry

    READ r0 0x1 r1 ;$LIST_R_LAST

    READ r0 0x3 r2 ;$LIST_R_COUNT
    READ r1 0x1 r3 ;$LIST_COUNT

    CMP r3 r2
    JL 0x06 ;&LIST_ADD_DO_ADD

        ; Add a new page
        SETHI r7 &LIST_CREATE_PAGE
        SETLO r7 &LIST_CREATE_PAGE
        CALL r7

        ; Instead of saving, just re-read because
        ; it is only one instruction
        READ r0 0x1 r2 ;$LIST_R_LAST

        WRITE r2 0x0 r1 ;$LIST_NEXT
        WRITE r0 0x1 r1 ;$LIST_R_LAST

    ;LIST_ADD_DO_ADD
    READ r1 0x1 r2 ;$LIST_COUNT

    SETHI r3 0x00
    SETLO r3 0x01
    ADD r3 r2
    WRITE r1 0x1 r3 ;$LIST_COUNT

    READ r0 0x2 r4 ;$LIST_R_SIZE
    MUL r2 r4

    SETHI r0 0x00 ;$LIST_HEADER_SIZE
    SETLO r0 0x02 ;$LIST_HEADER_SIZE

    ADD r0 r2
    ADD r0 r1

RET

;=LIST_EACH
;
; Iterate over the entries in a list, calling a procedure for each one.
;
; The callback is given the address of an entry in r0 and the contextual
; argument as r1. If the callback returns 0x000 in r0, iteration continues. If
; returns any other value, the loop is terminated and the address of the entry
; is returned from LIST_EACH in r0. If no callback returns a non-zero value,
; LIST_EACH will return 0x0000 in r0.
;
; The contextual argument cannot be modified by the callback. If you need to
; modify data, you can pass a pointer to space you have reserved.
;
; Params:
; r0 - address of list root
; r1 - contextual data to pass to the callback
; r2 - address of the callback
;
; Returns:
; r0 - address of the found entry, or null

    PUSH r8
    PUSH r9
    PUSH rA
    PUSH rB
    PUSH rC
    PUSH rD

    READ r0 0x0 r8 ;$LIST_R_FIRST r8 = segment cursor
    READ r0 0x2 r9 ;$LIST_R_SIZE r9 = entry size

    MOV r1 rC ; rC = context data
    MOV r2 rD ; rD = callback address

    ;LIST_EACH_SEGMENT_LOOP
    MOV r8 r8
    JEQ 0x14 ;&LIST_EACH_DONE

        SETHI rB 0x00
        SETLO rB 0x02

        READ r8 0x1 rA ;$LIST_COUNT
        MUL rA r9
        ADD rA rB
        ADD rA r8 ; rA = first out of bounds address

        ADD rB r8 ; rB = entry cursor

        ;LIST_EACH_ENTRY_LOOP
        CMP rB rA
        JEQ 0x09 ;&LIST_EACH_ENTRY_LOOP_DONE

            MOV rB r0
            MOV rC r1

            CALL rD

            MOV r0 r0
            JNE 0x02 ;&LIST_EACH_PREP_RETURN

            ADD rB r9 ; cursor += size
            JMP 0xF7 ;&LIST_EACH_ENTRY_LOOP

            ;LIST_EACH_PREP_RETURN
            MOV rB r0 ; return cursor
            JMP 0x03 ;&LIST_EACH_RETURN

        ;LIST_EACH_ENTRY_LOOP_DONE

        READ r8 0x0 r8 ;$LIST_NEXT cursor = cursor.next
        JMP 0xEA ;&LIST_EACH_SEGMENT_LOOP

    ;LIST_EACH_DONE

    SUB r0 r0

    ;LIST_EACH_RETURN

    POP rD
    POP rC
    POP rB
    POP rA
    POP r9
    POP r8

RET

;=LIST_CREATE_PAGE
; Params:
; r0 - address of list root
;
; Returns:
; r0 - address of list root
; r1 - address of new page

    READ r0 0x2 r1 ;$LIST_R_SIZE
    READ r0 0x3 r2 ;$LIST_R_COUNT

    MUL r1 r2

    SETHI r2 0x00 ;$LIST_HEADER_SIZE
    SETLO r2 0x02 ;$LIST_HEADER_SIZE

    ADD r1 r2

    PUSH r0

    MOV r1 r0

    SETHI r7 &ALLOC
    SETLO r7 &ALLOC
    CALL r7

    SUB r7 r7
    WRITE r0 0x0 r7 ;$LIST_R_FIRST
    WRITE r0 0x1 r7 ;$LIST_R_LAST

    MOV r0 r1

    POP r0

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

;HEAP_PTR
&HEAP
;HEAP
0000

