; Atom Assembler

SETHI r0 0x00
SETLO r0 0x03
SETHI r1 0x00
SETLO r1 0x02

SETHI r7 &LIST_CREATE
SETLO r7 &LIST_CREATE
CALL r7

SETHI r7 &LABEL_LIST
SETLO r7 &LABEL_LIST
WRITE r7 0x0 r0

SETHI r7 &LIST_ADD
SETLO r7 &LIST_ADD
CALL r7

HALT

;LABEL_LIST
0000

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

