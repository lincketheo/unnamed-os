


all: ./build/boot.bin

./build/boot.bin: ./build
	nasm -f bin ./bootloader/boot.asm -o ./build/boot.bin -i./bootloader
	
./build:
	mkdir ./build

.PHONY: clean

clean:
	rm -rf ./build

