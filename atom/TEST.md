# Atom Tests
This document describes the expected results of test cases in this folder. These tests are manual. To execute one,
select the corresponding binary file and start the computer. Once the computer halts, check the expectation against the
state of the computer.

The tests build upon each other, so should be evaluated in order.

## Tests
### HALT (halt.bin)
This test checks if the halt instruction works. It is foundational to other tests, which indicate that they are
completed by halting.

#### Expectation
The computer is halted.

### Set low and high (set.bin)
This test check if the set low and set high instructions work, and that they can be used together.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0x00AB |
|       r1 | 0xCD00 |
|       r2 | 0x2357 |

