// A memcpy for SnowHouseCpu
//  Written by Andrew Clark (FL4SHK)
.text
.global _memcpy
.type   _memcpy,@function
_memcpy:
    beq r3, r0, .Lmemcpy_end    // if count == 0 then return;
    add r3, r1, r3              // r3 = dest + count
    cpy r4, r1                  // r4 = dest
    cpy r5, r2			// r5 = src
.Lmemcpy_loop:
    ldub r2, r5, 0		// r2 = mem8(r5)
    stb r2, r4, 0               // mem8(r4) = r2
    add r4, r4, 1               // r4 += 1
    add r5, r5, 1		// r5 += 1
    bne r4, r3, .Lmemcpy_loop   // if r4 != r3 then loop
.Lmemcpy_end:
    jmp lr
    .size _memcpy,.Lmemcpy_end-_memcpy
