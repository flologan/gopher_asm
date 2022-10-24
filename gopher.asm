NextSubsetMemberGet:
    cpi r16, 0
    brbc 1, Entry
    cpi r17, 0
    brbc 1, Entry
    ret

Entry:
    ; pushes
    push r16
    push r17
    push r18
    push r19
    push r20
    push r21
    push r22
    push r23
    push r24
    push r25
    push r26
    push r27
    push r28
    push r29
    push r30
    push r31
    ; loads
    eor r0, r0
    eor r1, r1
    ldi r18, 0x00
    ldi r19, 0x00

    ldi r20, 0x00

    ldi r21, 0x00
    ldi r22, 0x00

    ldi r27, 0x80 ; for lsar subroutine
    ldi r28, 0x01
    ldi r29, 0xff

    ; move input to dirty registers
    mov r30, r16
    mov r31, r17

    ; check whether least significant bit is set
    andi r30, 0x01
    mov r30, r16
    brbs 1, LSBNotSet
    rjmp TypeOne

LSBNotSet:
    add r19, r28
    call lsar
    brbs 0, TypeOneOrTwo
    add r18, r28
    rjmp LSBNotSet

TypeOneOrTwo:
    add r19, r28
    add r18, r28
    call lsar
    brbs 0, TypeTwo
    rjmp TypeOnePrepR28

TypeOne:
    call lsar
    brbc 0, TypeOnePrepR28
    add r18, r28
    rjmp TypeOne

TypeOnePrepR28:
    add r18, r29
    brbs 1, FinalStage
    add r28, r28
    adc r20, r20
    rjmp TypeOnePrepR28

TypeTwo:
    add r19, r28
    call lsar
    brbs 0, IsolateSimilarBits
    rjmp ShiftR30Back

IsolateSimilarBits:
    add r19, r28
    call lsar
    brbc 0, ShiftR30Back
    rjmp IsolateSimilarBits

ShiftR30Back:
    add r30, r30
    adc r31, r31
    add r19, r29
    brbs 1, SetSimilarBitsInOutput
    rjmp ShiftR30Back

SetSimilarBitsInOutput:
    or r0, r30
    or r1, r31
    rjmp CountSimilarBits

CountSimilarBits:
    cpi r30, 0
    brbc 1, CountSimilarBitsLoop
    cpi r31, 0
    brbc 1, CountSimilarBitsLoop
    mov r30, r16
    mov r31, r17
    rjmp CountBitsInInput

CountSimilarBitsLoop:
    add r30, r30
    adc r31, r31
    brbs 0, CountSimilarBitsIncrement
    rjmp CountSimilarBits

CountSimilarBitsIncrement:
    add r21, r28
    rjmp CountSimilarBits

CountBitsInInput:
    cpi r30, 0
    brbc 1, CountBitsInInputLoop
    cpi r31, 0
    brbc 1, CountBitsInInputLoop
    rjmp AddBits

CountBitsInInputLoop:
    add r30, r30
    adc r31, r31
    brbs 0, CountBitsInInputIncrement
    rjmp CountBitsInInput

CountBitsInInputIncrement:
    add r22, r28
    rjmp CountBitsInInput

AddBits:
    neg r21
    add r21, r22
    add r21, r29
    mov r30, r16
    mov r31, r17
    rjmp FindLeftZeroEntry

FindLeftZeroEntry:
    add r19, r28
    call lsar
    brbs 0, FindLeftZeroOne
    rjmp FindLeftZeroEntry

FindLeftZeroOne:
    add r19, r28
    call lsar
    brbc 0, TypeTwoPrepR28
    rjmp FindLeftZeroOne

TypeTwoPrepR28:
    add r19, r29
    brbs 1, AddR0R28_R1R20
    add r28, r28
    adc r20, r20
    rjmp TypeTwoPrepR28

AddR0R28_R1R20:
    add r0, r28
    adc r1, r20

    cp r0, r19
    brbc 1, TypeTwoPrepR19
    cp r1, r19
    brbc 1, TypeTwoPrepR19
    rjmp ReturnZero

TypeTwoPrepR19:
; do I need to add another register?
    ldi r28, 0x01
    add r19, r19
    adc r23, r23
    add r19, r28
    add r21, r29
    brbs 1, temp
    rjmp TypeTwoPrepR19

temp:
    add r0, r19
    add r1, r23
    rjmp Return

FinalStage:
    mov r0, r16
    add r0, r28
    mov r1, r17
    adc r1, r20
    brbs 0, ReturnZero
    rjmp Return

ReturnZero:
    eor r0, r0
    eor r1, r1
    rjmp Return

Return:
    ;pops
    pop r31
    pop r30
    pop r29
    pop r28
    pop r27
    pop r26
    pop r25
    pop r24
    pop r23
    pop r22
    pop r21
    pop r20
    pop r19
    pop r18
    pop r17
    pop r16
    ret





; subroutine to LSR between two registers
lsar:
    lsr r31
    brbs 0, CarryOne
    lsr r30
    ret

CarryOne:
    lsr r30
    or r30, r27
    ret


