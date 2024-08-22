all: build build/unnamed_os.bin

build:
	mkdir $@

build/unnamed_os.bin: build/boot.bin build/kernel.bin 
	cat $^ > $@

build/boot.bin: src/bootloader/boot.asm 
	nasm -f bin -o $@ $^

build/kernel_entry.o: src/kernel/kernel_entry.asm
	nasm -f elf -o $@ $^

build/kernel.o: src/kernel/kernel.c
	gcc -ffreestanding -m32 -g -c -Iinclude -o $@ $^

build/kernel.bin: build/kernel.o build/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 --oformat binary $^

.PHONY: clean

clean:
	rm -rf build
