.text
.section .text.init

.extern ___start
.extern _stack
.extern _interrupt_vector
// Initialize

.global _start
.type _start,@function
_start:
    cpy sp, __stack
    bl __cstart

.global __cstart
.type __cstart,@function
__cstart:


.global __start
.type __start,@function
