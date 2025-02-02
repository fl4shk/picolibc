.text
.section .init

//.extern ___start
//.extern ___stack
//.extern ___interrupt_vector
// Initialize

.global _start
.type _start,@function
_start:
    cpy sp, ___stack
    cpy r1, ___interrupt_vector
    cpy ids, r1
    cpy r1, 1
    cpy ie, r1
    beq r0, r0, __cstart
    .size _start,.-_start

.global __cstart
.type __cstart,@function
__cstart:
    beq r0, r0, __start
    .size __cstart,.-__cstart

//.global __start
//.type __start,@function
//__start:
//    beq r0, r0, ___start
//    .size
