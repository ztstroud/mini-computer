SETLO r0 0x0A
CALL 0x01;>fibonacci
HALT


;=fibonacci
; give a number N in r0
; puts the Nth Fibonacci number in r0
SUB r1 r1
SETLO r1 0x01

;fibonacci_no_setup
SUB r0 r1
JG 0x06;>calculate

JEQ 0x02;>return1

; return 0
SUB r0 r0
RET

;return1
SUB r0 r0
SETLO r0 0x01
RET

;calculate
MOV r0 r2
SUB r2 r1
PUSH r2

CALL 0xF4;>fibonacci_no_setup (-12)

POP r2
PUSH r0
MOV r2 r0

CALL 0xF0;>fibonacci_no_setup (-16)

POP r2
ADD r0 r2
RET

