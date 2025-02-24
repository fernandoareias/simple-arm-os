GPPPPARAMS = -target aarch64-none-elf -ffreestanding -mno-red-zone -fno-exceptions -fno-rtti -fno-use-cxa-atexit -nostdlib 
ASPARAMS = --target=aarch64-none-elf

CC = clang
AS = clang
LD = clang

objects = loader.o kernel.o

# Regras para compilar arquivos .cpp
%.o: %.cpp
	$(CC) $(GPPPPARAMS) -c $< -o $@

# Regras para montar arquivos .s
%.o: %.s
	$(AS) $(ASPARAMS) -c $< -o $@

mykernel.bin: linker.ld $(objects)
	$(LD) $(GPPPPARAMS) -T linker.ld -o $@ $(objects)

install: mykernel.bin
	mkdir -p ./output
	cp $< ./output/mykernel.bin
	@echo "Kernel copiado para ./output/mykernel.bin"