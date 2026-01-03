# Atom Assembly

An assembly file consists of many atoms on separate lines, each of which
represent some type of data to write into the program. Atoms can be identified
by their initial character:
- `[A-Z]`: an instruction
- `:`: a label
- `[0-9-]`: raw data written as a number
- `&`: a label address
- `"`: string data
- `#`: insert a number zero bytes
- `$`: a constant

Atoms may be preceded by white space, which will be ignored.

## Identifiers

An identifier can consist of uppercase alphanumeric values and underscores. It
cannot start with a digit.

### Registers

Registers are identified by a lower case `r`, followed by the hexadecimal digit
identifying it.

## Values

### Literals

Literal values can be written in various formats:
- Decimal: `-?[0-9]+`
- Hexadecimal: `0x[0-9A-F]+`
- Binary: `0b[01]+`

### Constants

You can assign a value to a named constant that you can re-use throughout the
program. To do so, start with a `$`, followed by an identifier, followed by an
`=`, then a literal value.

```asm
$VAL=0x0001
```

### Using values

Many atoms can accept a value. These are marked with `<VAL:N>` or `<SVAL:N>`,
for unsigned or signed interpretations. The `N` tells you how many bits of the
value will be used. If the value would not fit into `N` bits assembly will fail
with an error.

For these values, you could enter:
- A literal value
- A constant name prefixed with a `$`

## Instructions

All instructions start with an upper case letter `[A-Z]`.

### General

```asm
NOOP
HALT
```

### Register operations

```asm
ADD r0 r1 ; add r1 to r0
SUB r0 r1 ; sub r1 from r0
MOV r0 r1 ; move r1 to r0
CMP r0 r1 ; compare r1 to r0
MUL r0 r1 ; multiply r0 by r1
```

### Loading

```asm
LL r0 <LOAD_VAL> ; set the low bits of r0 to <LOAD_VAL>
LH r0 <LOAD_VAL> ; set the high bits of r0 to <LOAD_VAL>
```

The argument is considered as a 16 bit value, but `LL` will only use the lower 8
bits while `LH` will only use the upper 8 bits.

The load value can be:
- `<VAL:16>`: The value of VAL
- `&L`: The address of label `L`

### Jumping

```asm
JEQ <JUMP_ARG> ; Equal
JNE <JUMP_ARG> ; Not equal
JOV <JUMP_ARG> ; Overflow
JNG <JUMP_ARG> ; Negative
JLT <JUMP_ARG> ; Unsigned less than
JCR <JUMP_ARG> ; Carry
JLE <JUMP_ARG> ; Unsigned less than or equal
JGT <JUMP_ARG> ; Unsigned greater than
JGE <JUMP_ARG> ; Unsigned greater than or equal
JLU <JUMP_ARG> ; Signed less than
JLEU <JUMP_ARG> ; Signed less than or equal
JGU <JUMP_ARG> ; Signed greater than
JGEU <JUMP_ARG> ; Signed greater than or equal
JMP <JUMP_ARG> ; Always
```

The name of the jump type is provided with each instruction. Refer to
HARDWARE.md for detailed information about the jump types.

The jump argument can take many forms:
- `r0`: jump directly to the address in `r0`
- `+r0`: relative jump using the value in `r0`
- `<SVAL:8>`: immediate jump using the value of `SVAL`
- `&L`: immediate jump that will execute the instruction at `L` next
    - If the jump cannot be made using 8 bits, assembly will fail with an error
    - If you want to jump to a label outside of what is possible with an 8 bit
      offset, load a value and use there absolute register form.

### Procedures

```asm
CALL <JUMP_ARG>
RET

PUSH r0 ; Push r0's value onto the stack
POP r0 ; Pop the top value from the stack and write it to r0

RSRV r0 ; reserve r0 words on the stack
RLS r0 ; release r0 words from the stack

SP r0 ; Write the value of the SP to r0
```

The `<RSRV_RLS_ARG>` can take the following forms:
- `r0`: reserve/release r0 words on the stack
- `<VAL:8>`: reserve/release `VAL` words on the stack

### Reading and writing

```asm
READ r0 r1 <VAL:4> ; read the data at r1 + VAL to r0
WRITE r0 r1 <VAL:4> ; write r0 to the address r1 + VAL

PW <VAL:2> r0 r1 ; write r0 to peripheral VAL at address r1
PR <VAL:2> r0 r1 ; read from peripheral VAL at address r1 to r0
PF <VAL:2> r0 r1 ; read flags from peripheral VAL with address r1 to r0
```

## Labels

Labels start with a colon `:`. The identifier immediately following is the name
of the label. A leading equals sign `=` will be ignored.

Labels save the address of the following instruction and can then be referred to
later. Therefore, a label on the first line of the application will have a value
of `0x0000`.

A label may only be defined once. A second definition will cause an error during
assembly.

## Data

### Raw

You can write number that will be directly encoded into the program by just
writing a value:

```asm
<VAL:16>
```

### Label address

You can write the address of a label by writing an ampersand `&` followed by the
name of the label. This can be useful when setting up pointers to other
pre-instantiated data.

```asm
:LIST_HEAD
&LIST_TAIL
0x0000
:LIST_TAIL
0x0000
&LIST_HEAD
```

### String

You can write a string by starting a line with a double quote `"`. The double
quote is ignored, and the rest of the line is written into the program as
individual characters. Strings ARE NOT followed by a null terminator. If you
wish to follow a string with a null terminator, use a raw `0x0000` word.

```asm
:GREETING
"Hello world!
0
```

The assembler puts no limit on the size of strings. However, the editor does not
allow lines longer than 45 characters. If you need a longer string, you can just
write two strings side by side:

```asm
:LONG
"This is a long string that is written
" across many lines. Note the space must be
" added in one of the lines.
0
```

Because ALL characters after the first double quote are written to the
application, there is no need for escaping double quotes:

```asm
:QUOTE
""Hello there!"
0
```

There is no escape sequence at all. This means that there is no way to write a
newline in a string. However, you can write the value `0x000A` in between two
strings:

```asm
:LINES
"Line 1
0xA
"Line 2
0
```

### Zero bytes

You can write empty words to the program by writing a pound `#` followed by a
number of words as a value. For example, to write 48 bytes you could write:

```asm
:BUFFER
#<VAL:16>
```

This is used for reserving space, typically for data structures.

## Comments

A comment is delineated by a semicolon `;` anywhere in a non-string line. The
semicolon and all characters after it are ignored.

## Errors

The assembler reports simple information about errors, including the line
number. It attempts to compile as much as possible so that you get as many
errors as possible per run.

## Architecture

The assembler makes two passes over the data. The first parses non-program atoms
and identifies the text of atoms that will be processed in the second pass.

The atoms that will be processed into data are referenced from a large list.
During the first pass, this list is populated with data. Instructions take one
word each, as do raw values, label addresses, and constants. Strings and zero
bytes are also placed in the list, but can take up many bytes. This means that
the position in the list _does not indicate the instruction address_.

During the first pass, the addresses of labels are computed. As the length of
the list doesn't indicate the instruction address, the next address must be
maintained separately. The constant values are also collected.

During the second pass, the list is walked and all data resolved to individual
words. At this point, all label addresses and constants are known, and so can be
resolved.

