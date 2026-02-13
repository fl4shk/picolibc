#include <string.h>
#include <stdint.h>

extern void* memcpy(void* dst, const void* src, size_t cnt) {
    if (cnt == 0) {
        return dst;
    }

    size_t i = 0;
    if (
        (((uintptr_t)dst) & 0x3) == 0
        && (((uintptr_t)src) & 0x3) == 0
        //&& (cnt & ~0x3) == 0
    ) {
        for (i=0; i<(cnt & ~0x3); i+=4) {
            ((uint32_t*)dst)[i] = ((uint32_t*)src)[i];
        }
        //for (; i<cnt; ++i) {
        //    ((uint8_t*)dst)[i] = ((uint8_t*)src)[i];
        //}
    } 

    for (; i<cnt; ++i) {
        ((uint8_t*)dst)[i] = ((uint8_t*)src)[i];
    }

    return dst;
}
