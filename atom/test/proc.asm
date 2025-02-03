SETLO r0 0x01

CALL 0x02
MOV r1 r2
HALT

; procedure propagating value
MOV r0 r1
RET

; halt if RET failed
HALT

