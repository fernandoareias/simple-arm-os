ENTRY(loader)                           /* Define o ponto de entrada como 'loader' */
OUTPUT_FORMAT(elf64-littleaarch64)      /* Formato ELF de 64 bits para ARM64 (little-endian) */
OUTPUT_ARCH(aarch64)                    /* Arquitetura alvo: ARM64 */

SECTIONS
{
    . = 0x0100000;                        /* Endereço de carga típico para ARM64 bare-metal */

    .text :                             /* Seção de código (.text) */
    {
        *(.multiboot)                   /* Inclui o cabeçalho Multiboot, se houver */
        *(.text*)                       /* Inclui todo o código (.text) */
        *(.rodata)                      /* Inclui dados somente leitura (.rodata) */
    }

    .data :                             /* Seção de dados inicializados (.data) */
    {
        start_ctors = .;                /* Marca o início da tabela de construtores */
        KEEP(*( .init_array ))          /* Mantém os arrays de inicialização */
        KEEP(*(SORT_BY_INIT_PRIORITY( .init_array.* ))) /* Ordena por prioridade */
        end_ctors = .;                  /* Marca o fim da tabela de construtores */
        
        *(.data)                        /* Inclui todos os dados inicializados */
    }

    .bss :                              /* Seção de dados não inicializados (.bss) */
    {
        *(.bss)                         /* Inclui todos os dados não inicializados */
    }

    /DISCARD/ :                         /* Descarta seções desnecessárias */
    {
        *(.fini_array*)                 /* Descarta arrays de finalização */
        *(.comment)                     /* Descarta comentários */
    }
}