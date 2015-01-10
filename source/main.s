    /*
     * gpio base address =
     * 0x20200000
     *
     * offsets:
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

.section .init
.globl _start
_start:
    b main

main:
    mov sp, #0x8000

    pinNum .req r0
    pinFunc .req r1
    mov pinNum, #47
    mov pinFunc, #1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc

loop:
    pinNum .req r0
    pinVal .req r1
    mov pinNum, #47
    mov pinVal, #1
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

//    mov r0, #1
//    lsl r0, #22
        //    bl _wait
    mov r0, #18
    lsl r0, #15
    bl _wait

    pinNum .req r0
    pinVal .req r1
    mov pinNum, #47
    mov pinVal, #0
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    mov r0, #18
    lsl r0, #15
    bl _wait

    b loop

stop:
    b stop
