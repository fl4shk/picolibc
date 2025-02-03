#include "../../crt0.h"
#include <stdio.h>
#include <stdlib.h>

void __attribute__((used)) __section(".init")
_cstart(void)
{
    __start();
}
