// A memcpy for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)
.text
.global _memcpy
.type   _memcpy,@function
_memcpy:
    beq r3, r0, .Lmemcpy_end    // if cnt == 0 then return;

    add sp, sp, -4
    str r7, sp, 0
    //str r8, sp, 4

    cpy r4, r1              // r4 = dst
    cpy r5, r2              // r5 = src
    cpy r7, r3

    and r6, r3, ~0x3        // r6 = dst + cnt - non word aligned num bytes
    add r6, r1, r6          //

    add r3, r1, r3          // r3 = dst + cnt

    or r2, r1, r2           // same result as the following:
    and r2, r2, 0x3         // (dst & 0x3) == 0 && (src & 0x3) == 0
    bne r2, r0, .Lmemcpy_remaining_bytes_loop

    cpy r2, 4
    bltu r7, r2, .Lmemcpy_remaining_bytes_loop

//    cpy r2, 16
//    bltu r7, r2, .Lmemcpy_words_loop
//
//    and r2, r7, ~0xf        // r7 = dst + cnt - non 16-bytes aligned amount
//    add r7, r5, r2          //
//
//.Lmemcpy_words_x4_loop:
//    ldr r2, r5, 0
//    str r2, r4, 0
//    ldr r2, r5, 4
//    str r2, r4, 4
//    ldr r2, r5, 8
//    str r2, r4, 8
//    ldr r2, r5, 12
//    str r2, r4, 12
//    add r5, r5, 16
//    add r4, r4, 16
//    bne r4, r7, .Lmemcpy_words_x4_loop

.Lmemcpy_words_x4_loop_post:
    beq r7, r3, .Lmemcpy_pop

.Lmemcpy_words_loop:
    ldr r2, r5, 0
    str r2, r4, 0
    add r4, r4, 4
    add r5, r5, 4
    bne r4, r6, .Lmemcpy_words_loop

.Lmemcpy_remaining_bytes_loop_pre:
    beq r6, r3, .Lmemcpy_pop

.Lmemcpy_remaining_bytes_loop:
    ldub r2, r5, 0
    stb r2, r4, 0
    add r4, r4, 1
    add r5, r5, 1
    bne r4, r3, .Lmemcpy_remaining_bytes_loop

.Lmemcpy_pop:
    ldr r7, sp, 0
    //ldr r8, sp, 0
    add sp, sp, 4

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
