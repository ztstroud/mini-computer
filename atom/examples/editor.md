# Editor

I want to make a text editor that I can use to write files containing text.

## What does the UI look like?

I only have my terminal peripheral, and it only supports writing a single
character to the string at a time. That character is always appended, though you
can do things like delete a character.

This means that I cannot have an editor that shows a screen full of lines, I can
only write some data to the screen. This will be much like `ed`, though simpler.

## How to represent data?

I need to represent the data within memory in a way that will be conducive to
editing. The assembly that I have written so far tends to get long in number of
lines.

I want to try separating each line into an entry in a doubly linked list. The
structure of each entry would look something like this:

```
block {
    * next;
    * prev;
    [46] data;
}
```

Each block is 48 words, with two being reserved for pointers to the next and
previous blocks. The data is a null terminated string, which means it can have a
max length of 45.

## Commands

### N

Select line N

### (i)nsert

Add a line after the selected line

### (d)elete

Remove the selected line

### (p)rint

Print all lines, including line number
