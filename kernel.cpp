#define UART_BASE 0x09000000

void putchar(char c) {
    volatile char* uart = (volatile char*)UART_BASE;
    while (*(uart + 0x18) & 0x20); 
    *uart = c;
}

void printf(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;

extern "C" void callConstructors()
{
    for (constructor* i = &start_ctors; i != &end_ctors; i++) {
        (*i)();
    }
}

extern "C" void kernelMain(void* multiboot_structure, unsigned int magicnumber) {
    printf("Hello, World!\n");

    while (1); 
}