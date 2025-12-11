# Instructions
This document describes in detail the instruction set of the Atom computer.

## Op Codes
The Atom computer uses 16 bit instructions. The 4 highest of these bits [12-15] define the op code of the instruction:
`OOOOXXXXXXXXXXXX`. Op codes divide instructions up into basic categories.

| Code   | Name |
| ---    | --- |
| `0000` | General |
| `0001` | Register operation |
| `0010` | Load low |
| `0011` | Load high |
| `0100` | Jump |
| `0101` | Register jump |
| `0110` | Memory Read |
| `0111` | Memory Write |
| `1000` | Call |

### `0000` General
General operations contain generic operations that don't fit into other categories. The following instructions are
defined:

| `0000000000000000` | Noop | Do nothing |
| `0000000000000001` | Ret | Pop the top value from the stack and jump to it |
| `00000001TTTTXXXX` | | Single register operations |
| `0000FFFFFFFFFFFF` | Halt | Stop computation |

All others are reserved. This section will be revised as more generic operations are added.

#### `Single Register Operations`
These operations operate on a single register. Instructions have the form `00000001TTTTXXXX` where `TTTT` is the
register used in the operation, and `XXXX` is the operation type.

| Operation | Description |
| --------- | ----------- |
| `0000` | Push the value of the register `TTTT` onto the stack |
| `0001` | Pop a value from the stack into register `TTTT` |

### `0001` Register Operation
Register operations perform computations. All register operations specify a register operation in bits [8-11], a target
register in bits [4-7], and an argument register in bits [0-3]: `0001RRRRTTTTAAAA`.

When a register operation is performed, the target register is updated to contain the result of the computation with the
exception of the compare operation.

The ALU flags will be set based upon the result of the computation, and saved for use in later instructions.

Supported register operations are defined below:

| Op     | Name                   | Result              | Description |
| ------ | ---------------------- | ------------------- | --- |
| `0000` | Add                    | target + argument   | Adds the argument to the target |
| `0001` | Subtract               | target - argument   | Subtract the argument from the target |
| `0010` | Move                   | argument            | Move the argument to the target |
| `0011` | Compare                | target - argument   | Subtract the argument from the target without modifying it |
| `0100` | Multiply               | target * argument   | Multiply the targe by the argument |
| `0101` | Reserved               | Reserved            | Reserved |
| `0110` | Reserved               | Reserved            | Reserved |
| `0111` | Reserved               | Reserved            | Reserved |
| `1000` | Reserved               | Reserved            | Reserved |
| `1001` | Reserved               | Reserved            | Reserved |
| `1010` | Reserved               | Reserved            | Reserved |
| `1011` | Reserved               | Reserved            | Reserved |
| `1100` | Reserved               | Reserved            | Reserved |
| `1101` | Reserved               | Reserved            | Reserved |
| `1110` | Reserved               | Reserved            | Reserved |
| `1111` | Reserved               | Reserved            | Reserved |

### `0010` Load low
Loading low sets the lower 8 bits of a register to a value specified in the instruction. The four bits [8-11] specify
which register is being set, and the 8 bits [0-7] are the value to set: `0010TTTTIIIIIIII`.

### `0011` Load high
Loading high sets the upper 8 bits of a register to a value specified in the instruction. The four bits [8-11] specify
which register is being set, and the 8 bits [0-7] are the value to set: `0011TTTTIIIIIIII`.

### `0100` Jump
Jump instructions allow you to change the PC, changing where the program is executing. The four bits [8-11] specify the
type of jump and the 8 bits [0-7] are a signed 8 bit offset value: `0100JJJJIIIIIIII`.

The jump offset is relative to the value of the PC, which will be pointing to the *next* instruction to execute. This
means that a value of 0 is essentially a no-op, continuing to the next instruction. A value of -1 will execute the jump
again, and will stall the computer.

Jump types are documented in HARDWARE.md.

### `0101` Register Jump
Register jump instructions allow you to change the PC using values from a register. The four bits [8-11] specify the
type of jump, the bit [4] specifies if the jump is relative (high) or absolute (low), and the four bits [0-3] specify
the register to use: `0101JJJJXXXRAAAA`.

If the jump is relative, the value from the register is added to the PC. The same considerations that the Jump
instruction above apply.

If the jump is absolute, the PC is updated to the value of the register. Since the PC specifies the next instruction,
this address will be the exact address of the instruction to jump to.

Jump types are documented in HARDWARE.md.

### `0110` Memory Read and `0111` Memory Write
Memory reads and writes allow you to read data from and RAM. Both instructions have them same format. The four bits
[8-11] specify an unsigned immediate value, the four bits [4-7] specify a data register, the four bits [0-3] specify the
address register: `011XIIIIDDDDAAAA`.

These instructions operate on an address in memory, calculate by adding the immediate value to the unsigned value of the
address register. When reading, the value in that address is put into the data register. When writing, the value in the
data register is written to that address.

### `1000` Call
Call performs a jump and saves the return location to the stack, enabling procedure calls. Bit 11 determines if the jump
is relative with an immediate (0) or jumps to the address in a register (1).

If jumping with an immediate, the bits [0-7] are the immediate value: `10000XXXIIIIIIII`.

If jumping with a register, the bits [0-3] identify the address register: `10001XXXXXXXAAAA`.

### `1001` Peripherals
Peripheral instructions are used to interact with peripheral devices. Bits [10-11] address a peripheral, supporting four
devices. Bit 8 switches between writing (0) and reading (1). If reading, bit 9 switches between reading data (0) and
flags (1). Bits [4-7] specify the register to write the data to, and bits [0-3] specify an address. The full format is:
`1001PPFRTTTTAAAA`.

