; A simple program that saves typed text to storage, persisting it between
; sessions

SETLO rF 0x01
SETLO rE 0x08 ; backspace

; read memory to screen
;SETUP
P0READ r0 r1

CMP r1 rF
JL 0x04 ;>SETUP_DONE

ADD r2 rF
P1WRITE r0 r1

ADD r0 rF
JMP 0xF9 ;>SETUP

;SETUP_DONE
;LOOP
P1READF r0 r0
CMP r0 rF
JEQ 0x01;>READ

JMP 0xFC;>LOOP

;READ
P1READ r3 r3

CMP r3 rE
JEQ 0x04;>BACKSPACE

; not backspace
P0WRITE r2 r3
ADD r2 rF
P1WRITE r3 r3
JMP 0xF5;>LOOP

;BACKSPACE
CMP r2 rF
JL 0xF3;>LOOP

SUB r2 rF
P1WRITE r3 r3
P0WRITE r2 rA ; this should be zero
JMP 0xEF;>LOOP

