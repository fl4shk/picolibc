// A memcpy for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)

.macro mac_memcpy_bytes_loop tmp, dst, src, to_cmp
.L\@_mac_mac_memcpy_bytes_loop:
    ldub \tmp, \src, 0
    stb \tmp, \dst, 0
    add \dst, \dst, 1
    add \src, \src, 1
    bne \dst, \to_cmp, .L\@_mac_mac_memcpy_bytes_loop
.endm

.macro mac_memcpy_words_loop tmp, dst, src, to_cmp
.L\@_mac_memcpy_words_loop:
    // FL4SHK note: `\@` becomes an integer that is the number of times
    // that macros have been called.
    // This is useful here as we can create a unique label each time this
    // macro is called this way!
    ldr \tmp, \src, 0
    str \tmp, \dst, 0
    add \dst, \dst, 4
    add \src, \src, 4
    bne \dst, \to_cmp, .L\@_mac_memcpy_words_loop
.endm

.set stack_space, 4

.text
.global _memcpy
.type   _memcpy,@function
_memcpy:
    beq r3, r0, .Lmemcpy_end    // if cnt == 0 then return;

    add sp, sp, -stack_space
    str r7, sp, 0
    //str lr, sp, 4
    //str r8, sp, 4

    cpy r4, r1              // r4 = dst
    cpy r5, r2              // r5 = src
    cpy r6, r3              // r6 = cnt

    and r7, r3, ~0x3        // r7 = dst + cnt - non word aligned num bytes
    add r7, r1, r7          //

    add r3, r1, r3          // r3 = dst + cnt

    or r2, r1, r2           // same result as the following:
    and r2, r2, 0x3         // (dst & 0x3) == 0 && (src & 0x3) == 0
    bne r2, r0, .Lmemcpy_remaining_bytes_loop

    cpy r2, 4
    bltu r6, r2, .Lmemcpy_remaining_bytes_loop

    cpy r2, 16
    bltu r6, r2, .Lmemcpy_remaining_words_loop

    and r6, r6, ~0xf    // r6 = dst + cnt - non 16-bytes aligned amount
    add r6, r4, r6      //

.Lmemcpy_words_x4_loop:
    ldr r2, r5, 0
    str r2, r4, 0
    ldr r2, r5, 4
    str r2, r4, 4
    ldr r2, r5, 8
    str r2, r4, 8
    ldr r2, r5, 12
    str r2, r4, 12
    add r5, r5, 16
    add r4, r4, 16
    bne r4, r6, .Lmemcpy_words_x4_loop

.Lmemcpy_words_x4_loop_post:
    beq r6, r3, .Lmemcpy_pop


//.Lmemcpy_words_loop:
    //ldr r2, r5, 0
    //str r2, r4, 0
    //add r4, r4, 4
    //add r5, r5, 4
    //bne r4, r7, .Lmemcpy_words_loop
.Lmemcpy_remaining_words_loop:
mac_memcpy_words_loop r2, r4, r5, r7

.Lmemcpy_remaining_bytes_loop_pre:
    beq r7, r3, .Lmemcpy_pop

//.Lmemcpy_remaining_bytes_loop:
//    ldub r2, r5, 0
//    stb r2, r4, 0
//    add r4, r4, 1
//    add r5, r5, 1
//    bne r4, r3, .Lmemcpy_remaining_bytes_loop
.Lmemcpy_remaining_bytes_loop:
mac_memcpy_bytes_loop r2, r4, r5, r3

.Lmemcpy_pop:
    ldr r7, sp, 0
    //ldr lr, sp, 4
    //ldr r8, sp, 0
    add sp, sp, stack_space

.Lmemcpy_end:
    jmp lr
    .size _memcpy,.Lmemcpy_end-_memcpy


//// A memcpy for SnowHouseCpu
////  Written by Andrew Clark (FL4SHK)
//.text
//.global _memcpy
//.type   _memcpy,@function
//_memcpy:
//    // arguments:
//    // r1: dest
//    // r2: src
//    // r3: count (in bytes)
//
//    add sp, sp, -4 //-8
//    str r7, sp, 0
//    //str r8, sp, 4
//    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
//
//    and r4, r1, ~0x3
//    and r5, r2, ~0x3
//    and r6, r3, ~0x3
//
//    bne r4, r1, .Lmemcpy_bytes_loop_pre
//    bne r5, r2, .Lmemcpy_bytes_loop_pre
//    //beq r6, r3, .Lmemcpy_only_words_loop_pre
//    //bne r6, r3, .Lmemcpy_bytes_loop_pre
//
//
////    add r3, r1, r3              // r3 = dest + count
////    cpy r4, r1                  // r4 = dest
////    cpy r5, r2                        // r5 = src
////
////.Lmemcpy_loop:
////    ldub r2, r5, 0            // r2 = mem8(r5)
////    stb r2, r4, 0               // mem8(r4) = r2
////    add r4, r4, 1               // r4 += 1
////    add r5, r5, 1             // r5 += 1
////    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop
//
//.Lmemcpy_words_loop_pre:
//    add r3, r1, r3
//
//.Lmemcpy_words_loop:
//    //bne r7, r8, .Lmemcpy_only_words_loop
//    ldr r2, r5, 0               // r2 = mem8(r5)
//    str r2, r4, 0               // mem8(r4) = r2
//    add r4, r4, 4               // r4 += 1
//    add r5, r5, 4               // r5 += 1
//    bne r4, r3, .Lmemcpy_words_loop
//    bl r0, .Lmemcpy_end
//
////.Lmemcpy_bytes_loop_pre:
////    add r3, r1, r3              // r3 = dest + count
////    cpy r4, r1                  // r4 = dest
////    cpy r5, r2                  // r5 = src
////
////.Lmemcpy_bytes_loop:
////    ldub r2, r5, 0              // r2 = mem8(r5)
////    stb r2, r4, 0               // mem8(r4) = r2
////    add r4, r4, 1               // r4 += 1
////    add r5, r5, 1               // r5 += 1
////    bne r4, r3, .Lmemcpy_bytes_loop   // if r4 != r3 then loop
//
//.Lmemcpy_end:
//    ldr r7, sp, 0
//    //ldr r8, sp, 4
//    add sp, sp, 4///8
//    jmp lr
//    .size _memcpy,.Lmemcpy_end-_memcpy

//// A memcpy for SnowHouseCpu
////  Written by Andrew Clark (FL4SHK)
//.text
//.global _memcpy
//.type   _memcpy,@function
//_memcpy:
//    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
//    add r3, r1, r3              // r3 = dest + count
//    cpy r4, r1                  // r4 = dest
//    cpy r5, r2                        // r5 = src
//
//.Lmemcpy_loop:
//    ldub r2, r5, 0            // r2 = mem8(r5)
//    stb r2, r4, 0               // mem8(r4) = r2
//    add r4, r4, 1               // r4 += 1
//    add r5, r5, 1             // r5 += 1
//    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop
//
//.Lmemcpy_end:
//    jmp lr
//    .size _memcpy,.Lmemcpy_end-_memcpy

////// A memcpy for SnowHouseCpu
//////  Written by Andrew Clark (FL4SHK)
////.text
////.global _memcpy
////.type   _memcpy,@function
////_memcpy:
////    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
////    cpy r4, r1                  // r4 = dest
////    //cpy r5, r2                    // r5 = src
////
////    and r6, r3, ~0x3                // r6 = count - non word aligned num bytes
////    add r6, r1, r6
////    add r3, r1, r3          // r3 = dest + count
////    beq r3, r6, .Lmemcpy_only_words_loop
////
//////.Lmemcpy_loop:
//////    ldub r2, r5, 0                // r2 = mem8(r5)
//////    stb r2, r4, 0               // mem8(r4) = r2
//////    add r4, r4, 1               // r4 += 1
//////    add r5, r5, 1         // r5 += 1
//////    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop
////
////.Lmemcpy_both_words_and_bytes_loop:
////    ldr r5, r2, 0
////    str r5, r4, 0
////    add r4, r4, 4
////    add r2, r2, 4
////    bne r4, r6, .Lmemcpy_both_words_and_bytes_loop
////
////.Lmemcpy_remaining_bytes_loop:
////    ldub r5, r2, 0
////    stb r5, r4, 0
////    add r4, r4, 1
////    add r2, r2, 1
////    bne r4, r3, .Lmemcpy_remaining_bytes_loop
////    bl r0, .Lmemcpy_end
////
////.Lmemcpy_only_words_loop:
////    ldr r5, r2, 0
////    str r5, r4, 0
////    add r4, r4, 4
////    add r2, r2, 4
////    bne r4, r6, .Lmemcpy_only_words_loop
////
////.Lmemcpy_end:
////    jmp lr
////    .size _memcpy,.Lmemcpy_end-_memcpy
//// A memcpy for SnowHouseCpu
////  Written by Andrew Clark (FL4SHK)
//
//.text
//.global _memcpy
//.type   _memcpy,@function
//_memcpy:
//    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
//    cpy r4, r1                  // r4 = dest
//    //cpy r5, r2                      // r5 = src
//
//    and r6, r3, ~0x3          // r6 = count - non word aligned num bytes
//    add r6, r1, r6
//    add r3, r1, r3            // r3 = dest + count
//    beq r3, r6, .Lmemcpy_only_words_loop
//
////.Lmemcpy_loop:
////    ldub r2, r5, 0          // r2 = mem8(r5)
////    stb r2, r4, 0               // mem8(r4) = r2
////    add r4, r4, 1               // r4 += 1
////    add r5, r5, 1           // r5 += 1
////    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop
//
//.Lmemcpy_both_words_and_bytes_loop:
//    ldr r5, r2, 0
//    str r5, r4, 0
//    add r4, r4, 4
//    add r2, r2, 4
//    bne r4, r6, .Lmemcpy_both_words_and_bytes_loop
//
//.Lmemcpy_remaining_bytes_loop:
//    ldub r5, r2, 0
//    stb r5, r4, 0
//    add r4, r4, 1
//    add r2, r2, 1
//    bne r4, r3, .Lmemcpy_remaining_bytes_loop
//    bl r0, .Lmemcpy_end
//
//.Lmemcpy_only_words_loop:
//    ldr r5, r2, 0
//    str r5, r4, 0
//    add r4, r4, 4
//    add r2, r2, 4
//    bne r4, r6, .Lmemcpy_only_words_loop
//
//.Lmemcpy_end:
//    jmp lr
//    .size _memcpy,.Lmemcpy_end-_memcpy
