SETLO rF 0x80 ; cache base, 0x0080

SETLO r0 0x0A
CALL 0x01;>fib
HALT

;=fib
; give a number N in r0
; puts fib(N) in r0

; check cache
MOV rF r7
ADD r7 r0
READ r7 0x0 r7
CMP r7 rE ; rE is zero
JEQ 0x02;>calculate

; return cache
MOV r7 r0
RET

;calculate
MOV r0 r6

SUB r1 r1 ; zero out r1
SETLO r1 0x01 ; set r1 to 0x0001

SUB r0 r1
JG 0x06;>carryon

JEQ 0x02;>reteq
SUB r0 r0 ; zero out r0
RET

;reteq
SUB r0 r0 ; zero out r0
SETLO r0 0x01 ; set r to 0x0001
RET

;carryon
PUSH r6 ; save original argument

MOV r0 r2
SUB r2 r1
PUSH r2 ; save argument - 2

CALL 0xE9;>fib (-23)

POP r2 ; pop argument - 2
PUSH r0 ; save response

MOV r2 r0
CALL 0xE5;>fib (-27)

POP r1 ; pop response
ADD r0 r1 ; sum responses (r0 is second call, r1 is first call)

; populate the cache
POP r2 ; pop original argument
MOV rF r7
ADD r7 r2
WRITE r7 0x0 r0

RET

