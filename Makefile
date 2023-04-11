CROSS_COMPILE_ROOT=~/opt/cross

# GCC
CC=$(CROSS_COMPILE_ROOT)/bin/i686-elf-gcc
CFLAGS=-ffreestanding -m32 -g -c

# LD
LD=$(CROSS_COMPILE_ROOT)/bin/i686-elf-ld

# Assembly
ASM=nasm

BUILD=./build

all: $(BUILD) $(BUILD)/os.bin

$(BUILD)/os.bin: $(BUILD)/boot.bin $(BUILD)/kernel.bin
	cat $^ > $@

$(BUILD)/kernel.bin: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary 

$(BUILD)/kernel_entry.o: ./kernel/kernel_entry.asm
	$(ASM) $^ -f elf -o $@

$(BUILD)/kernel.o: ./kernel/kernel.c
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD)/boot.bin: ./bootloader/boot.asm
	$(ASM) -f bin $^ -o $@ -i./bootloader
	
$(BUILD):
	mkdir $(BUILD)

.PHONY: clean

clean:
	rm -rf $(BUILD)
