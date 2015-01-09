.globl GetGpioAddress
GetGpioAddress:
    ldr r0, =0x20200000
    mov pc, lr

// int SetGpioFunction(int gpio_pin_number)
.globl SetGpioFunction
SetGpioFunction:
    cmp r0, #53 // 54 pins available.
    cmpls r1, #7 // and also 3 bits per pin in function select registers
    movhi pc, lr // or else return

    push {lr}
    push {r4}
    push {r5}
    mov r2, r0
    bl GetGpioAddress


div10loop:
    cmp r2, #9
    subhi r2, #10
    addhi r0, #4
    bhi div10loop

    // now r2 = gpio pin modulo 10
    // and r0 = gpio base addr + 4 * (gpio pin / 10)

    // also r1 = gpio pin function (3 bits)

    add r2, r2, lsl #1 // × 3

    // set up bit patterns
    lsl r1, r2
    mov r5, #3
    lsl r5, r2

    // load existing value
    ldr r4, [r0]

    bic r4, r5
    orr r1, r4

    str r1, [r0]
    pop {r5}
    pop {r4}
    pop {pc}

// void SetGpio(int gpio_pin_number, int on_or_off)
        .globl SetGpio
SetGpio:
pinNum .req r0
pinVal .req r1
    cmp pinNum, #53
    movhi pc, lr

    push {lr}
    mov r2, pinNum
.unreq pinNum
pinNum .req r2
    bl GetGpioAddress
gpioAddr .req r0
pinBank .req r3
    lsr pinBank, pinNum, #5
    lsl pinBank, #2
    add gpioAddr, pinBank
.unreq pinBank

    and pinNum, #31
setBit .req r3
    mov setBit, #1
    lsl setBit, pinNum
.unreq pinNum

    teq pinVal, #0
.unreq pinVal
    streq setBit, [gpioAddr, #40]
    strne setBit, [gpioAddr, #28]
.unreq setBit
.unreq gpioAddr
    pop {pc}
