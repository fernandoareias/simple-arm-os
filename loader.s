// Definições de constantes para o cabeçalho Multiboot
.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
    .quad MAGIC          // Magic number (64 bits)
    .quad FLAGS          // Flags (64 bits)
    .quad CHECKSUM       // Checksum (64 bits)

.section .text
.extern kernelMain      // Declara kernelMain como externa (definida em outro arquivo)
.global loader          // Define o símbolo 'loader' como global

loader:
    // Configura o ponteiro de pilha (SP) para apontar para o topo da pilha
    ldr x29, =kernel_stack_end  // Carrega o endereço do topo da pilha em x29 (Frame Pointer)
    mov sp, x29                 // Move o valor de x29 para o registrador SP (Stack Pointer)

    bl kernelMain               // Branch with Link: chama a função kernelMain

_stop:
    wfi                         // Wait For Interrupt: coloca o processador em estado de baixo consumo
    b _stop                     // Branch: salta de volta para _stop

.section .bss
.space 2*1024*1024             // Aloca 2 MiB para a pilha do kernel
kernel_stack_end:            