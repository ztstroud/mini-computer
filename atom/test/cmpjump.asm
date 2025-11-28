; setup values
SETLO r1 0x03

SETLO r2 0x08

SETHI r3 0xFF ; max unsigned / -1 signed
SETLO r3 0xFF

SETHI r4 0x80 ; min signed

SETHI r5 0x7F ; max signed
SETLO r5 0xFF

; tests
JMP 0x02
SETLO r0 0x01 ; always jump failed
HALT

CMP r1 r1
JEQ 0x02
SETLO r0 0x02 ; jump equal failed
HALT

CMP r1 r2
JNE 0x02
SETLO r0 0x03 ; jump not equal failed
HALT

; reminder that carry is the UNSIGNED LESS THAN instruction
MOV r3 r8
ADD r8 r1
JCR 0x02
SETLO r0 0x04 ; addition carry failed
HALT

SUB r8 r8 ; set r8 to zero
SUB r8 r1
JCR 0x02
SETLO r0 0x05 ; subtraction carry failed
HALT

MOV r5 r8
SUB r5 r3
JOV 0x02
SETLO r0 0x06 ; signed positive subtract negative overflow failed
HALT

MOV r4 r8
SUB r8 r1
JOV 0x02
SETLO r0 0x07 ; signed negative subtract positive overflow failed
HALT

MOV r1 r8
SUB r8 r2
JNG 0x02
SETLO r0 0x08 ; negative failed
HALT

CMP r1 r2
JL 0x02
SETLO r0 0x09 ; unsigned less than failed
HALT

JLE 0x02
SETLO r0 0x0A ; unsigned less than or equal failed (less than)
HALT

CMP r1 r1
JLE 0x02
SETLO r0 0x0B ; unsigned less than or equal failed (equal)
HALT

CMP r2 r1
JG 0x02
SETLO r0 0x0C ; unsigned greater than failed
HALT

JGE 0x02
SETLO r0 0x0D ; unsigned greater than or equal failed (greater than)
HALT

CMP r1 r1
JGE 0x02
SETLO r0 0x0E ; unsigned greater than or equal failed (equal)
HALT

CMP r3 r1
JLS 0x02
SETLO r0 0x0F ; signed less than failed
HALT

JLES 0x02
SETLO r0 0x10 ; signed less than or equal failed (less than)
HALT

CMP r3 r3
JLES 0x02
SETLO r0 0x11 ; signed less than or equal failed (equal)
HALT

CMP r1 r3
JGS 0x02
SETLO r0 0x12 ; signed less than failed
HALT

JGES 0x02
SETLO r0 0x13 ; signed less than or equal failed (greater than)
HALT

CMP r3 r3
JGES 0x02
SETLO r0 0x14 ; signed less than or equal failed (equal)
HALT

HALT ; finished with no errors

