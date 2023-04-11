CROSS_COMPILE_ROOT=~/opt/cross

CC=$(CROSS_COMPILE_ROOT)/bin/i686-elf-gcc
LD=$(CROSS_COMPILE_ROOT)/bin/i686-elf-ld


all: ./build/os.bin

./build/os.bin: ./build/kernel.bin ./build/boot.bin
	cat ./build/boot.bin ./build/kernel.bin > ./build/os.bin

./build/kernel.bin: ./build/kernel_entry.o ./build/kernel.o
	$(LD) -o ./build/kernel.bin -Ttext 0x1000 ./build/kernel_entry.o ./build/kernel.o --oformat binary

./build/kernel_entry.o: ./build ./kernel/kernel_entry.asm
	nasm ./kernel/kernel_entry.asm -f elf -o ./build/kernel_entry.o	

./build/kernel.o: ./build ./kernel/kernel.c
	$(CC) -ffreestanding -m32 -g -c ./kernel/kernel.c -o ./build/kernel.o

./build/boot.bin: ./build ./bootloader/boot.asm
	nasm -f bin ./bootloader/boot.asm -o ./build/boot.bin -i./bootloader
	
./build:
	mkdir ./build

.PHONY: clean

clean:
	rm -rf ./build
