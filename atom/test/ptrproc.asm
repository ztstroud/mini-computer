SETLO r0 0x01

SETHI r8 0x00
SETLO r8 0x06
CALL r8

MOV r1 r2
HALT

; procedure propagating value
MOV r0 r1
RET

; halt if RET failed
HALT

