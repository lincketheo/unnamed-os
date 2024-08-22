# Usage
## Setup 
### Target architecture: i686

My setup, overall, is:
- 64 bit CPU
- 32 bit OS (compiled using i686 cross compiler)
- 32 bit applications will be able to be run

## Building and running

I've been running this on a virtualized `x86_64` processor.

```
$ make clean
$ make
$ qemu-system-x86_64 build/unnamed_os.bin 
# or for rhel:
$ qemu-kvm -cpu host -drive file=./build/unnamed_os.bin,format=raw -nographic
```

## Notes:
- `x86`: (2.1.1) Refers to a processors in the 8086 family. (80186 80286 80386 80486...). Usually, it means compatability with the 80386 32 bit instruction set because 16 bit only is so old 
- `i686`: (2.1.6) Intel686. P6 Family Microarchitecture on the Pentium Pro. 
- One of the 6th generation of `x86` processor.
- `i386`: (2.1.3) Intel386. AKA 80386. First 32 bit
- `x86_64` The 64-bit instruction set (sometimes called amd64) brother of `x86`
    - backwards compatible to `x86` (ie `x86` instructions can run 
    - on `x86_64` processors)
- [Here's a nice summary of intel cpu architecture](https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-vol-1-manual.html) (**chapter 2.1**). 
- [Here's another nice explanation of `i` related architectures](https://myonlineusb.wordpress.com/2011/06/08/what-is-the-difference-between-i386-i486-i586-i686-i786/)
- [32 bit and 64 bit:](https://www.aliencoders.org/content/basic-information-about-i386-i686-and-x8664-architectures/)
    - A 32-bit OS will run on a 32-bit or 64-bit processor without any problem.
    - A 32-bit application will run on a 32-bit or 64-bit OS without any problem.
    - But a 64-bit application will only run on a 64-bit OS and a 64-bit OS will only run on a 64-bit processor

## References I've been using
- [Intel Software Development Manual Volume 1A (Basic Architecture)](https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-vol-1-manual.html)
    - Not going to help you write code, but useful in learning about basics of computer stuff
- [Intel Software Development Manual Volume 3A (System Programming Guide Part 1)](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3a-part-1-manual.pdf)
    - Good reference for GDT, protected mode, paging, etc. (The above also talks about paging, and segmentation)
- [OS Dev Wiki](https://wiki.osdev.org/Expanded_Main_Page)
    - Eventually, I'll remove these as this grows, but this is the small subset of the wiki I've referenced so far:
    - [Setting up a gcc cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
    - [GDT](https://wiki.osdev.org/Global_Descriptor_Table) and [GDT Tutorial](https://wiki.osdev.org/GDT_Tutorial)
    - [Protected mode](https://wiki.osdev.org/Protected_Mode)
    - [Segmentation](https://wiki.osdev.org/Segmentation)
    - [Rolling your own bootloader](https://wiki.osdev.org/Rolling_Your_Own_Bootloader)
    - [Bootloader theory](https://wiki.osdev.org/Bootloader)
- [Assembly cheat sheet]()
- [Daedalus Community - Making an OS](https://www.youtube.com/playlist?list=PLm3B56ql_akNcvH8vvJRYOc7TbYhRs19M)
- [NASM Reference](https://www.nasm.us/doc/)
- [NASM cheat sheet](https://www.bencode.net/blob/nasmcheatsheet.pdf)
- [Assembly Programming Topics](https://stanislavs.org/helppc/idx_assembler.html)
- [TODO - go through this tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
- [Just a good website](https://stanislavs.org/helppc/)
