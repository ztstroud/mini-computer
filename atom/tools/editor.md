# Editor

In order to write code on Atom, I will need a text editor. I need something very
simple and easy to create.

## What does the UI look like?

I only have my terminal peripheral, and it only supports writing a single
character to the string at a time. That character is always appended, though you
can do things like delete a character.

This means that I cannot have an editor that shows a screen full of lines, I can
only write some data to the screen. This will be much like `ed`, though simpler.

## How to represent data?

I need to represent the data within memory in a way that will be conducive to
editing. The assembly that I have written so far tends to get long in number of
lines, and will get longer.

I am representing lines as entries in a doubly linked list. Every node starts
with the next and previous blocks. The head and tail are special in that they
only have these two fields.

```
head_tail {
    * next;
    * prev;
}
```

Content nodes also have 46 words of data for a total of 48. The data is a null
terminated string, which means it can have a max length of 45.

```
content {
    * next;
    * prev;
    [46] data;
}
```

## Commands

### N

Select line N.

You can select line 0, which is how you (i)nsert a line at the start of the
file.

### (i)nsert

Add a line after the selected line.

### (d)elete

Remove the selected line.

### (p)rint

Print all lines, including line number.

### (w)rite

Writes the content to storage.

