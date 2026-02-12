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
