CROSS_COMPILE_ROOT=$(HOME)/opt/cross
SRCDIR := src
BUILDDIR := build

# Compilers and flags
CC=$(CROSS_COMPILE_ROOT)/bin/i686-elf-gcc
INCLUDES=include
CFLAGS=-ffreestanding -m32 -g -c -I$(INCLUDES)

LD=$(CROSS_COMPILE_ROOT)/bin/i686-elf-ld

ASM=nasm

# Sources and objects
SRCS := $(shell find $(SRCDIR) -name "*.c")
COBJ := $(subst $(SRCDIR)/,$(BUILDDIR)/,$(SRCS:%.c=%.o))

ASMSRC = kernel/kernel_entry.asm
ASMSRC := $(addprefix $(SRCDIR)/, $(ASMSRC))
ASMOBJ := $(subst $(SRCDIR), $(BUILDDIR), $(ASMSRC:%.asm=%.o))

OSTARGET=unnamed.bin


all: $(OSTARGET)

run: $(OSTARGET)
	qemu-system-i386 $(OSTARGET)

$(OSTARGET): $(BUILDDIR)/bootloader/boot.bin $(BUILDDIR)/kernel/kernel.bin
	cat $^ > $@

$(BUILDDIR)/kernel/kernel.bin: $(COBJ) $(ASMOBJ)
	mkdir -p $(dir $@)
	$(LD) -o $@ -Ttext 0x1000 --oformat binary $^

$(BUILDDIR)/%.o: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	$(ASM) -f elf -o $@ $^

$(BUILDDIR)/%.bin: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	$(ASM) -f bin -I$(SRCDIR)/bootloader -o $@ $^

$(BUILDDIR)/%.o: $(SRCDIR)/%.c 
	mkdir -p $(dir $@)
	clang-format -i $^ -style llvm # TODO - make this more not dumb
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean

clean:
	rm -rf build
	rm -f $(OSTARGET)
