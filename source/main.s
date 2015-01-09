.section .init
.globl _start
_start:
    // gpio base address
    ldr r0, =0x20200000

    /* offsets:
     * 0x0-0x14: gpio function select
     * 0x1c-0x20: gpio pin output set
     * 0x28-0x2c: gpio pin output clear
     * 0x34-0x38: gpio pin level
     * 0x40-0x44: gpio pin event detect
     * 0x4c-0x50: gpio pin rising edge detect enable
     * 0x58-0x5c: gpio pin falling edge detect enable
     *
     * pins:
     * act (rpi b+): 47, active high
     * act (rpi b): 16, active low
     * pwr (rpi b+): 35
     */

    // select output function of gpio pin 47
    mov r1, #1
    // 7th set of 3bits (47 % 10 == 7)
    lsl r1, #21
    // 5th set of 4bytes ((47 / 10) * 4 == 16)
    str r1, [r0, #16]

loop:
    // set the output for pin 47
    mov r1, #1
    // 47 % 32 == 15
    lsl r1, #15
    // (47 / 32) * 4 + 0x1c == #32
    str r1, [r0, #32]

    mov r2, #0x3f0000
wait1:
    sub r2, #1
    cmp r2, #0
    bne wait1


    // clear the output for pin 47
    mov r1, #1
    // 47 % 32 == 15
    lsl r1, #15
    // (47 / 32) * 4 + 0x28 == #44
    str r1, [r0, #44]

    mov r2, #0x3f0000
wait2:
    sub r2, #1
    cmp r2, #0
    bne wait2

    b loop
