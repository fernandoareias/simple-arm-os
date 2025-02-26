.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
    .long MAGIC          // Magic number (32 bits)
    .long FLAGS          // Flags (32 bits)
    .long CHECKSUM       // Checksum (32 bits)

.section .text
.extern kernelMain      // Declara kernelMain como externa
.extern callConstructors
.global loader          // Define o símbolo 'loader' como global

loader:
    // Configura o ponteiro de pilha (ESP) para apontar para o topo da pilha
    mov $kernel_stack, %esp  // Carrega o endereço do topo da pilha em %esp
    call callConstructors

    push %eax 
    push %ebx
    call kernelMain      // Chama a função kernelMain

_stop:
    cli                  // Desabilita interrupções
    hlt                  // Coloca o processador em estado de espera
    jmp _stop            // Loop infinito

.section .bss
.space 2*1024*1024       // Aloca 2 MiB para a pilha do kernel
kernel_stack_end: