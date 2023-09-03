#include <stdio.h>

#include "pico/stdlib.h"

#define ONBOARD_LED 25

int main()
{
    stdio_init_all();
    gpio_init(ONBOARD_LED);
    gpio_set_dir(ONBOARD_LED, GPIO_OUT);
    
    uint32_t counter = 0;
    while (1)
    {
        gpio_put(ONBOARD_LED, 0);
        sleep_ms(500);
        gpio_put(ONBOARD_LED, 1);
        sleep_ms(500);
        printf("Hello from Pico %u\n", ++counter);
    }
}
