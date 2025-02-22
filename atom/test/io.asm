; Assumes that P0 is storage, such tha we can write and then read a value
SETLO r0 0xAD
SETHI r0 0xDE
P0WRITE r1 r0
SUB r0 r0
P0READ r0 r1
P0READF r0
HALT

