all: build build/disk.img

build:
	mkdir $@

build/disk.img: build/boot.bin build/kernel.bin
	dd if=/dev/zero of=zeros bs=512 count=2880
	cat build/boot.bin build/kernel.bin > temp
	cat temp zeros > $@
	rm temp 
	rm zeros

build/boot.bin: src/bootloader/boot.asm
	nasm -f bin -o $@ $^

build/kernel_entry.o: src/kernel/kernel_entry.asm
	nasm -f elf -o $@ $^

build/kernel.o: src/kernel/kernel.c
	gcc -ffreestanding -m32 -c -o $@ $^

build/kernel.bin: build/kernel_entry.o build/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 --oformat binary $^

.PHONY: clean

clean:
	rm -rf build
