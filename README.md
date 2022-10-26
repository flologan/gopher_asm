# gopher_asm

A subroutine written in AVR assembly for the ATmega328p.

Given any 16 bit value, calculate the next permutation in the sequence outline by the following patterns:

1 bit set
- 0000 0000 0000 0001
- 0000 0000 0000 0010
- ...
- 1000 0000 0000 0000

2 bit set
- 0000 0000 0000 0011
- 0000 0000 0000 0101
- ...
- 1100 0000 0000 0000

There exists 2^16 - 1 unique bit patterns.
