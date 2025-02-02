// A setjmp for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)


// Stack frame setup:
// High
//                    ------------------------
//                    last on-stack parameter
//                    on-stack parameters (args grow upwards)...
// old sp, fake_ap, dwarf cfa, on-stack parameter 0x0
//                    ------------------------
// fake_fp            old fp (if `frame_pointer_needed`)
//                    ------------------------
// fp,                callee-saved register save 0x0
//                    callee-saved registers save area...
//                    last callee-saved register save
//                    ------------------------
//                    local variable save area
//                    ------------------------
//                    padding for alignment
//                    ------------------------
//                    last outgoing arg
//                    outgoing args (args grow upward)...
//                    outgoing arg 0x0
//                    (and sometimes dynamically allocated object on the 
//                    stack)
// sp
// Low

#include <picolibc.h>

// setjmp/longjmp  
//
// Register           jmpbuf offset
//  r7                  0x00
//  r8                  0x04
//  r9                  0x08
//  r10                 0x0c
//  r11                 0x10
//  r12                 0x14
//  lr                  0x18
//  fp                  0x1c
//  sp                  0x20

.text
.global _setjmp
.type   _setjmp,@function
_setjmp:
    // Save registers in jump buffer.
    str r7, r1, 0x00
    str r8, r1, 0x04
    str r9, r1, 0x08
    str r10, r1, 0x0c
    str r11, r1, 0x10
    str r12, r1, 0x14
    str lr, r1, 0x18
    str fp, r1, 0x1c
    str sp, r1, 0x20
    cpy r1, 0
    jmp lr
.Lend1:
    .size _setjmp,.Lend1-_setjmp

.global _longjmp
.type _longjmp,@function
_longjmp:
    ldr r7, r2, 0x00
    ldr r8, r2, 0x04
    ldr r9, r2, 0x08
    ldr r10, r2, 0x0c
    ldr r11, r2, 0x10
    ldr r12, r2, 0x14
    ldr lr, r2, 0x18
    ldr fp, r2, 0x1c
    ldr sp, r2, 0x20
    // return the resut argument, or 1 if it is zero
    cpy r1, r2
    beq r1, r0, .Lreturn1
    jmp lr
.Lreturn1:
    add r1, r1, 1
    add r1, r2, r1
    jmp lr
.Lend2:
    .size _longjmp,.Lend2-_longjmp

