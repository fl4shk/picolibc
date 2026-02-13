	.file	"memset.c"
	.section	.text
	.align 4
.global _memset
	.type	_memset, @function
_memset:
	add sp, sp, -12  // addsi3: =r, r, i
	str r7, sp, 0        // *mov32: =B, r
	str lr, sp, 4        // *mov32: =B, r
	cpy r5, r1        // *mov32: =r, r
	cpy r6, r2        // *mov32: =r, r
	cpy r1, 0        // *mov32: =r, i
	beq r3, r1, .L16
	cpy r4, r5        // *mov32: =r, r
	cpy r2, 3        // *mov32: =r, i
	bgtu r5, r2, .L14
	bleu r3, r2, .L14
	and r2, r3, -4
	and r7, r6, 255
	cpy r6, 16843009        // *mov32: =r, i
	mul r6, r7, r6
.L6:
	str r6, r4, 0x0        // *mov32: =B, r
	add r1, r1, 4  // addsi3: =r, r, i
	add r4, r4, 16  // addsi3: =r, r, i
	bgtu r2, r1, .L6
	cpy r1, r2        // *mov32: =r, r
	bleu r3, r2, .L16
.L3:
	add r2, r1, 1  // addsi3: =r, r, i
	cpy r4, 1    // *mov8: =r, i
	bleu r2, r3, .L13
	cpy r4, 0    // *mov8: =r, i
.L13:
	stb r4, sp, 8    // *mov8: =B, r
	ldub r4, sp, 8    // zero_extendqisi2
	cpy r2, 0        // *mov32: =r, i
	beq r4, r2, .L11
	sub r3, r3, r1  // subsi3: =r, r, r
	cpy r2, r7        // *mov32: =r, r
	add r1, r5, r1  // addsi3: =r, r, r
	str r5, sp, 8        // *mov32: =B, r
	bl _memset    // *call_value: =r, i
	ldr r5, sp, 8        // *mov32: =r, B
.L16:
	cpy r1, r5        // *mov32: =r, r
	add sp, sp, 4  // addsi3: =r, r, i
	ldr lr, sp, 0        // *mov32: =r, B
	ldr r7, sp, 4        // *mov32: =r, B
	add sp, sp, 8  // addsi3: =r, r, i
	jmp lr
.L14:
	and r7, r6, 255
	beq r0, r0, .L3
.L11:
	cpy r3, 1        // *mov32: =r, i
	cpy r2, r7        // *mov32: =r, r
	add r1, r5, r1  // addsi3: =r, r, r
	str r5, sp, 8        // *mov32: =B, r
	bl _memset    // *call_value: =r, i
	ldr r5, sp, 8        // *mov32: =r, B
	beq r0, r0, .L16
	.size	_memset, .-_memset
	.ident	"GCC: (GNU) 15.0.1 20250125 (experimental)"
