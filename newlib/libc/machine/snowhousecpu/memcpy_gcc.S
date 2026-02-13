	.file	"memcpy.c"
	.section	.text
	.align 4
.global _memcpy
	.type	_memcpy, @function
_memcpy:
	add sp, sp, -8  // addsi3: =r, r, i
	str r7, sp, 0        // *mov32: =B, r
	str r8, sp, 4        // *mov32: =B, r
	cpy r4, 0        // *mov32: =r, i
	beq r3, r4, .L2
	cpy r5, r1        // *mov32: =r, r
	cpy r6, r2        // *mov32: =r, r
	or r7, r2, r1
	cpy r8, 3        // *mov32: =r, i
	bgtu r7, r8, .L7
	cpy r7, 3        // *mov32: =r, i
	bleu r3, r7, .L7
	and r8, r3, -4
.L5:
	ldr r7, r6, 0x0        // *mov32: =r, B
	str r7, r5, 0x0        // *mov32: =B, r
	add r4, r4, 4  // addsi3: =r, r, i
	add r6, r6, 16  // addsi3: =r, r, i
	add r5, r5, 16  // addsi3: =r, r, i
	bltu r4, r8, .L5
	cpy r4, r8        // *mov32: =r, r
	bleu r3, r8, .L2
.L7:
	add r5, r2, r4  // addsi3: =r, r, r
	ldub r6, r5, 0x0    // zero_extendqisi2
	add r5, r1, r4  // addsi3: =r, r, r
	stb r6, r5, 0x0    // *mov8: =B, r
	add r4, r4, 1  // addsi3: =r, r, i
	bgtu r3, r4, .L7
.L2:
	ldr r8, sp, 0        // *mov32: =r, B
	ldr r7, sp, 4        // *mov32: =r, B
	add sp, sp, 8  // addsi3: =r, r, i
	jmp lr
	.size	_memcpy, .-_memcpy
	.ident	"GCC: (GNU) 15.0.1 20250125 (experimental)"
