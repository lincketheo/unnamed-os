CROSS_COMPILE_ROOT=$(HOME)/opt/cross
SRCDIR := src
BUILDDIR := build

# C Compiler and flags
CC=$(CROSS_COMPILE_ROOT)/bin/i686-elf-gcc
INCLUDES=include
CFLAGS=-ffreestanding -m32 -g -c -I$(INCLUDES)

# Linker
LD=$(CROSS_COMPILE_ROOT)/bin/i686-elf-ld

# Assembly compiler
ASM=nasm

# C source and object files as relative paths
CSRC := $(shell find $(SRCDIR) -name "*.c")
COBJ := $(subst $(SRCDIR)/,$(BUILDDIR)/,$(CSRC:%.c=%.o))

# Assembly source and object files as relative paths (only those needing to be objects)
ASMSRC = kernel/kernel_entry.asm
ASMSRC := $(addprefix $(SRCDIR)/, $(ASMSRC))
ASMOBJ := $(subst $(SRCDIR), $(BUILDDIR), $(ASMSRC:%.asm=%.o))

# The operating system
TARGET=unnamed.bin

all: $(TARGET)

run: $(TARGET)
	qemu-system-x86_64 $(TARGET)

$(TARGET): $(BUILDDIR)/bootloader/boot.bin $(BUILDDIR)/kernel/kernel.bin
	cat $^ > $@

# The binary kernel
$(BUILDDIR)/kernel/kernel.bin: $(COBJ) $(ASMOBJ)
	mkdir -p $(dir $@)
	$(LD) -o $@ -Ttext 0x1000 --oformat binary $^

# Any assembly that needs to be compiled into an object file (for use with c)
$(BUILDDIR)/%.o: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	$(ASM) -f elf -o $@ $^

# The bootloader (assembly binary files)
$(BUILDDIR)/%.bin: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	$(ASM) -f bin -I$(SRCDIR)/bootloader -o $@ $^

# C files needing to be compiled into object files
$(BUILDDIR)/%.o: $(SRCDIR)/%.c 
	mkdir -p $(dir $@)
	clang-format -i $^ -style llvm # TODO - make this more not dumb
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean

clean:
	rm -rf build
	rm -f $(TARGET)
