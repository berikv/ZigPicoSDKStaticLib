#include <stdio.h>
#include "pico/stdlib.h"
#include "my_module.h"

int main() {
    stdio_init_all();

    while (true) {
        char *from = (char *)helloFrom();
        printf("Hello from %s!\n", from);
        sleep_ms(1000);
    }

    return 0;
}
