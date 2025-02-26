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


mykernel.iso: mykernel.bin 
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub	
	cp $< iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Operating System" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot  /boot/mykernel.bin' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso