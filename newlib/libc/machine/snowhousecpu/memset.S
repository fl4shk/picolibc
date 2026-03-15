// A memset for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)
.text
.global _memset
.type   _memset,@function
_memset:
    beq r3, r0, .Lmemset_end    // if cnt == 0 then return;

    add sp, sp, -4
    str r7, sp, 0

    cpy r4, r1              // r4 = dst
    cpy r7, r3              // r6 = cnt

    and r2, r2, 0xff        // \ this trick with AND and multiplication
    cpy r5, 0x01010101      // | duplicates the low byte
    umulw r5, r5, r2        // / into all the other bytes

    and r6, r3, ~0x3        // r6 = dst + cnt - non word aligned num bytes
    add r6, r1, r6          //

    add r3, r1, r3          // r3 = dst + cnt

    and r2, r1, 0x3         // if 
    bne r2, r0, .Lmemset_remaining_bytes_loop

    cpy r2, 4
    bltu r7, r2, .Lmemset_remaining_bytes_loop

.Lmemset_words_loop:
    str r5, r4, 0
    add r4, r4, 4
    bne r4, r6, .Lmemset_words_loop

.Lmemset_remaining_bytes_loop_pre:
    beq r6, r3, .Lmemset_end

.Lmemset_remaining_bytes_loop:
    stb r5, r4, 0
    add r4, r4, 1
    bne r4, r3, .Lmemset_remaining_bytes_loop

.Lmemset_pop:
    ldr r7, sp, 0
    add sp, sp, 4

.Lmemset_end:
    jmp lr
    .size _memset,.Lmemset_end-_memset

//// A memset for SnowHouseCpu
////  Written by Andrew Clark (FL4SHK)
//.text
//.global _memset
//.type   _memset,@function
//_memset:
//    beq r3, r0, .Lmemset_end    // if count == 0 then return;
//    add r3, r1, r3              // r3 = dest + count
//    cpy r4, r1                  // r4 = dest
//
//.Lmemset_loop:
//    stb r2, r4, 0               // mem8(r4) = ch
//    add r4, r4, 1               // r4 += 1
//    bne r4, r3, .Lmemset_loop   // if r4 != r3 then loop
//
//.Lmemset_end:
//    jmp lr
//    .size _memset,.Lmemset_end-_memset

//// A memset for SnowHouseCpu
////  Written by Andrew Clark (FL4SHK)
//.text
//.global _memset
//.type   _memset,@function
//_memset:
//    beq r3, r0, .Lmemset_end    // if count == 0 then return;
//    cpy r4, r1                  // r4 = dest
//    //cpy r5, r2                      // r5 = ch
//
//    and r6, r3, ~0x3          // r6 = count - non word aligned num bytes
//    add r6, r1, r6
//    add r3, r1, r3            // r3 = dest + count
//    beq r3, r6, .Lmemset_only_words_loop
//
////.Lmemset_loop:
////    ldub r2, r5, 0          // r2 = mem8(r5)
////    stb r2, r4, 0               // mem8(r4) = r2
////    add r4, r4, 1               // r4 += 1
////    add r5, r5, 1           // r5 += 1
////    bne r4, r3, .Lmemset_loop   // if r4 != r3 then loop
//
//.Lmemset_both_words_and_bytes_loop:
//    //ldr r5, r2, 0
//    str r2, r4, 0
//    add r4, r4, 4
//    //add r2, r2, 4
//    bne r4, r6, .Lmemset_both_words_and_bytes_loop
//
//.Lmemset_remaining_bytes_loop:
//    //ldub r5, r2, 0
//    stb r2, r4, 0
//    add r4, r4, 1
//    //add r2, r2, 1
//    bne r4, r3, .Lmemset_remaining_bytes_loop
//    bl r0, .Lmemset_end
//
//.Lmemset_only_words_loop:
//    //ldr r5, r2, 0
//    str r2, r4, 0
//    add r4, r4, 4
//    //add r2, r2, 4
//    bne r4, r6, .Lmemset_only_words_loop
//
//.Lmemset_end:
//    jmp lr
//    .size _memset,.Lmemset_end-_memset
