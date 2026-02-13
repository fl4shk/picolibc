// A memcpy for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)
.text
.global _memcpy
.type   _memcpy,@function
_memcpy:
    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
    cpy r4, r1                  // r4 = dest
    //cpy r5, r2			// r5 = src

    and r6, r3, ~0x3		// r6 = count - non word aligned num bytes
    add r6, r1, r6
    add r3, r1, r3		// r3 = dest + count
    beq r3, r6, .Lmemcpy_only_words_loop

//.Lmemcpy_loop:
//    ldub r2, r5, 0		// r2 = mem8(r5)
//    stb r2, r4, 0               // mem8(r4) = r2
//    add r4, r4, 1               // r4 += 1
//    add r5, r5, 1		// r5 += 1
//    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop

.Lmemcpy_both_words_and_bytes_loop:
    ldr r5, r2, 0
    str r5, r4, 0
    add r4, r4, 4
    add r2, r2, 4
    bne r4, r6, .Lmemcpy_both_words_and_bytes_loop

.Lmemcpy_remaining_bytes_loop:
    ldub r5, r2, 0
    stb r5, r4, 0
    add r4, r4, 1
    add r2, r2, 1
    bne r4, r3, .Lmemcpy_remaining_bytes_loop
    bl r0, .Lmemcpy_end

.Lmemcpy_only_words_loop:
    ldr r5, r2, 0
    str r5, r4, 0
    add r4, r4, 4
    add r2, r2, 4
    bne r4, r6, .Lmemcpy_only_words_loop

.Lmemcpy_end:
    jmp lr
    .size _memcpy,.Lmemcpy_end-_memcpy
