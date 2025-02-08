SETLO r0 0x0A ; argument
; r1 is counter

SETLO r2 0x01 ; r2 is previous (1)
SETHI r3 0xFF ; r3 is previous previous (-1)
SETLO r3 0xFF

SETLO r4 0x01 ; constant 0x0001

;loop
CMP r1 r0
JG 0x06;>done

ADD r3 r2

; swap r2 r3
MOV r2 rF
MOV r3 r2
MOV rF r3

ADD r1 r4

JMP 0xF8;>loop (-8)

;done
MOV r2 r0
HALT

