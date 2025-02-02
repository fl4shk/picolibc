//#include <picolibc.h>
#include "../../crt0.h"

extern char __stack[];
extern char __interrupt_vector[];

static void __attribute__((used)) __section(".init")
_cstart(void)
{
    __start();
}
void _section(".init") __attribute__((used))
start(void)
{
  // The GCC port prepends a `_` to every symbol defined in C.
  _start();
}
void _section(".init") __attribute__((used))
_start(void)
{
    // Initialize 
    __asm__("cpy %0, %%
}
