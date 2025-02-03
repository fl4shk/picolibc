#include <picolibc.h>

.text
.section .init

//.extern ___start
//.extern ___stack
//.extern ___interrupt_vector
// Initialize

.global _start
.type _start,@function
_start:
    cpy sp, _stack
    //cpy r1, _interrupt_vector
    //cpy ids, r1
    //cpy r1, 1
    //cpy ie, r1
    beq r0, r0, __cstart
    .size _start,.-_start

.global _stdout
.bss
_stdout:
    .space 4
.global _stdin
.bss
_stdin:
    .space 4
.global _stderr
.bss
_stderr:
    .space 4

//.global _cstart
//.type _cstart,@function
//_cstart:
//    beq r0, r0, ___start
//    .size _cstart,.-_cstart

//.global __start
//.type __start,@function
//__start:
//    beq r0, r0, ___start
//    .size
