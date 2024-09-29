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

When the output of the ALU is written to the data bus, the flags are saved in the flag register.

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

