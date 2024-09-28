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

### `0000` General
General operations contain generic operations that don't fit into other categories.

Currently, there is only one generic operation: `noop`. `noop` is an instruction of all zeros, `0000000000000000`.

This section will be revised as more generic operations are added. Any general instruction other than `noop` should be
treated as a reserved instruction.

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
| `0100` | Reserved               | Reserved            | Reserved |
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

