// A memset for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)
.text
.global _memset
.type   _memset,@function
_memset:
    beq r3, r0, .Lmemset_end    // if count == 0 then return;
    add r3, r1, r3              // r3 = dest + count
    cpy r4, r1                  // r4 = dest

.Lmemset_loop:
    stb r2, r4, 0               // mem8(r4) = ch
    add r4, r4, 1               // r4 += 1
    bne r4, r3, .Lmemset_loop   // if r4 != r3 then loop

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
//    cpy r4, r1                  // r4 = dest
//    //cpy r5, r2			// r5 = ch
//
//    and r6, r3, ~0x3		// r6 = count - non word aligned num bytes
//    add r6, r1, r6
//    add r3, r1, r3		// r3 = dest + count
//    beq r3, r6, .Lmemset_only_words_loop
//
////.Lmemset_loop:
////    ldub r2, r5, 0		// r2 = mem8(r5)
////    stb r2, r4, 0               // mem8(r4) = r2
////    add r4, r4, 1               // r4 += 1
////    add r5, r5, 1		// r5 += 1
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
