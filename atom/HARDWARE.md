# Atom
## Instruction phases
When executing an instruction, we need to be able to load the instruction from RAM, and then execute it. We do this
because we want to be able to save a memory address between instructions, so the PC cannot always be used as the
address.

To do this, we break the execution of an instruction into two phases.

### Phase One (Loading Phase)
Load the instruction from RAM into InstrReg. The address of the instruction is the value of PC. As we do this, we also
increment PC so that it is ready for the next execution of Phase One.

### Phase Two (Execution Phase)
Execute the instruction in InstrReg.

## Modules
### ALU
The ALU always performs computations on the target and argument registers.

When the output of the ALU is written to the data bus, the flags are saved in the flag register. The value of the flags
is always visible in `Fl`.

### Instruction Register
The instruction register stores the instruction to execute. It stores whatever is being pulled out of RAM.

### PC
The PC stores the address of the next instruction to execute, and is used as the address in RAM so that it can be
loaded.

The PC increments during the loading phase of execution, which means that it has the address of the next instruction
during the execution phase.

### Control
The control circuit is responsible for setting controls signals based on an instruction. It implements the instructions
in INSTR.md.

### Jump Decider
The jump decider contains the logic that determine if we should jump based upon a jump type and flags from the ALU.

| Jump Type | Name                           | Description |
| --------- | ------------------------------ | --- |
| 0000      | Equal                          | Jump if the last operation resulted in a zero |
| 0001      | Not equal                      | Jump if the last operation did not result in a zero |
| 0010      | Overflow                       | Jump if the last operation resulted in signed overflow |
| 0011      | Negative                       | Jump if the last operation resulted in a negative signed value |
| 0100      | Unsigned less than             | Jump if the the target was less than the argument in the last operation (only well defined for subtraction) |
| 0101      | Unsigned less than or equal    | Jump if the the target was less than or equal to the argument in the last operaiton (only well defined for subtraction) |
| 0110      | Unsigned greater than          | Jump if the the target was greater than the argument in the last operation (only well defined for subtraction) |
| 0111      | Unsigned greater than or equal | Jump if the the target was greater than or equal to the argument in the last operation (only well defined for subtraction) |
| 1000      | Signed less than               | Jump if the the target was less than the argument in the last operation (only well defined for subtraction) |
| 1001      | Signed less than or equal      | Jump if the the target was less than or equal to the argument in the last operaiton (only well defined for subtraction) |
| 1010      | Signed greater than            | Jump if the the target was greater than the argument in the last operation (only well defined for subtraction) |
| 1011      | Signed greater than or equal   | Jump if the the target was greater than or equal to the argument in the last operation (only well defined for subtraction) |
| 1100      | Reserved                       | Reserved |
| 1101      | Reserved                       | Reserved |
| 1110      | Reserved                       | Reserved |
| 1111      | Always                         | Always jump |

### Overwriter
The overwriter is a circuit that handles replacing the high or low bits of a 16 bit values with an 8 bit value.

### Address Calculator
The addrCalc circuit computes an address by adding an 8 bit offset to a 16 bit base value.

## The Stack
Memory addresses `0x8000` through `0xFFFF` are reserved for the stack. The stack saves values for procedure calls.

## Peripherals
Peripherals are external devices that Atom can communicate with. Atom supports four peripheral slots. Data can be sent
to and requested from peripherals at addresses. In addition, you can read 16 flags from each peripheral, which the
peripheral can use to tell you about its state.

The full specification for peripherals is not defined yet. Currently, peripherals take an address, data, read and write
signals, and a clock signal. They output data and flags.

### Storage
Storage is additional memory that persists even without power.

### Terminal
A terminal allows you to read data from a keyboard and write data to a screen. Data from the keyboard is buffered in
hardware, and it uses a single flag in bit 0 to tell you if data is available to read.

