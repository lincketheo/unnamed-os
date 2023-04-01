[here are the facts](https://en.wikibooks.org/wiki/X86_Assembly/Bootloaders#The_Bootsector)

To build a bootloader, we need bios to recognize our code. The boot sector is:
1. 512 byte section at the beginning of the disk
2. The last 2 bytes end in `0x55aa`

To write a binary file, I'm going to use some assembly practice. On x86 assembly, I'll start at the beginning of the file, write 510 0's, then write two bytes at the end:

```
jmp $ ; jump to the current memory address

times 510-($-$$) db 0 ; write 0 510 minus the previous code times
db 0xaa, 0x55 ; write the bootloader special characters
```

Compile it into a binary file:
```
$ nasm -f bin boot.asm -o boot.bin
```

And double check that binary file:
```
$ ls -lah 
-rw-r--r-- 1 lincketheo 512 Mar 30 20:24 boot.bin
$ hexdump boot.bin
0000000 feeb 0000 0000 0000 0000 0000 0000 0000
0000010 0000 0000 0000 0000 0000 0000 0000 0000
*
00001f0 0000 0000 0000 0000 0000 0000 0000 55aa
0000200
```
The first command shows that this file is 512 bytes and the second shows that the last two bytes are 0x55aa

There we go. Operating system complete. To run it:
```
qemu-system-x86_64 ./boot.bin
```

And we get a screen that looks like this:
![[Pasted image 20230330203201.png]]

Now try changing something in the assmbly file, for example:

```
jmp $

times 505-($-$$) db 0
db 0x55, 0xaa
```
