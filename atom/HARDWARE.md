# Atom
## Instruction phases
When executing an instruction, we need to be able to load the instruction from RAM, and then execute it. We do this
because we want to be able to save a memory address between instructions, so the PC cannot always be used as the
address.

To do this, we break the execution of an instruction into two phases.

### Phase One
Load the instruction from RAM into InstrReg. The address of the instruction is the value of PC. As we do this, we also
increment PC so that it is ready for the next execution of Phase One.

### Phase Two
Execute the instruction in InstrReg.

## Modules
### ALU
The ALU always performs computations on the target and argument registers.

### Instruction Register
The instruction register stores the instruction to execute. It stores whatever is being pulled out of RAM.

