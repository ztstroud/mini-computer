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

### Arithmetic (arithmetic.bin)
This test checks that adding, subtracting, and moving values works correctly.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0x000A |
|       r1 | 0x0002 |
|       r2 | 0x0008 |

### Compare and jump (cmpjump.bin)
Tests that compare and jump operations work. All jump types are exercised.

#### Expectation
Upon halting, r0 indicates the result of the test. If it is zero, the test was successful. If non-zero, a test case
failed (detailed below). Once one test case fails, the computer halts, so only one error is reported at a time.

#### Errors
| r0 value | Test name |
| -------- | --------- |
| 0x0001 | always jump failed |
| 0x0002 | jump equal failed |
| 0x0003 | jump not equal failed |
| 0x0004 | addition carry failed |
| 0x0005 | subtraction carry failed |
| 0x0006 | signed positive subtract negative overflow failed |
| 0x0007 | signed negative subtract positive overflow failed |
| 0x0008 | negative failed |
| 0x0009 | unsigned less than failed |
| 0x000A | unsigned less than or equal failed (less than) |
| 0x000B | unsigned less than or equal failed (equal) |
| 0x000C | unsigned greater than failed |
| 0x000D | unsigned greater than or equal failed (greater than) |
| 0x000E | unsigned greater than or equal failed (equal) |
| 0x000F | signed less than failed |
| 0x0010 | signed less than or equal failed (less than) |
| 0x0011 | signed less than or equal failed (equal) |
| 0x0012 | signed less than failed |
| 0x0013 | signed less than or equal failed (greater than) |
| 0x0014 | signed less than or equal failed (equal) |

### Register jump (registerjump.bin)
Tests that register jumps work correctly. Because the jump types are shared, these tests do not exercise all types. It
exercises both relative and absolute register jumps.

#### Expectation
Upon halting, r0 indicates the result of the test. If it is zero, the test was successful. If non-zero, a test case
failed (detailed below). Once one test case fails, the computer halts, so only one error is reported at a time.

#### Errors
| r0 value | Test name |
| -------- | --------- |
| 0x0001 | relative jump failed |
| 0x0002 | absolute jump failed |

### Memory read/write (readwrite.bin)
Tests that read and write instructions work correctly.

#### Expectation
| Memory address | Value |
| -------------- | ----- |
| 0x0010 | 0x0010 |

### Procedures (proc.bin)
Tests that procedure calls function as jumps and that returns go back to where they came from.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0x0001 |
|       r1 | 0x0001 |
|       r2 | 0x0001 |

If r1 is 0x0000, then the call did not jump.

If r2 is 0x0000, the return failed to jump.


### Recursive Procedures (recurse.bin)
Tests that a procedure can call itself.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0x0000 |
|       r1 | 0x0001 |

### Pushing Values (push.bin)
Tests that values can be pushed to the stack.

#### Expectation
| Memory address | Value |
| -------------- | ----- |
| 0x8000 | 0xDEAD |
| 0x8001 | 0xBEEF |
| 0x8002 | 0x1234 |
| 0x8003 | 0x5678 |

### Popping Values (pop.bin)
Tests that values that have been pushed to the stack can be recovered by popping.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0xDEAD |
|       r1 | 0xBEEF |

### Peripheral I/O (io.bin)
Tests that values can be sent to and from a peripheral device.

This test assumes that the peripheral P0 is memory, meaning that you can write
and read back a value from the address.

#### Expectation
| Register | Value |
| -------- | ----- |
|       r0 | 0x0001 |
|       r1 | 0xDEAD |

