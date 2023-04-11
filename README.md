# Usage
## Setup 

### Cross compiler
You need a cross compiler installed on your system, specifically for the i686 system.
I followed [these instructions](https://wiki.osdev.org/GCC_Cross-Compiler) 
to install my cross compiler in `~/opt/cross`. If you already
have a cross compiler, just change `CROSS_COMPILER_ROOT` in the make file to your root and
associated commands. 

### Virtualization
This all should work fine on `i386` target if you happen to compile gcc for `i386` target instead of `i686`.

I'm not sure when i686 instructions are going to break i386 cpus (both are 32 bit cpus). I tried this a few times and everything worked. Someday I would like to know (TODO)

My setup, overall, is:
- 64 bit CPU
- 32 bit OS (compiled using i686 cross compiler)
- 32 bit applications will be able to be run

**Note**
- You wouldn't be able to write a 64 bit application using my OS unless you switched to 64 bit mode in the OS. I'll do that one day, but for now I'm keeping things simple and using 32 bit.

### Dependencies

**Qemu**:
```
$ sudo apt-get install qemu-system
```
**NASM**:
```
$ sudo apt install nasm
```

A bunch of other stuff, like build essentials, make etc. I'll list them some day, but if you have qemu and make installed, you can probably figure out what you don't have installed just by running the below commands in [Building and running](#building-and-running)


## Building and running

I've been running this on a virtualized `x86_64` processor. (see my note in Terminology about backwards compatability between x86\_64 and x86, e.g. i686)

Pretty simple:
```
$ make clean
$ make
$ qemu-system-x86_64 build/os.bin 
```


# Terminology 
## CPU architecture jargon words
[Here's a nice summary of intel cpu architecture](https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-vol-1-manual.html) (**chapter 2.1**). Although, often in the intel software development manuals you can't just search for jargon terms, so the list below is a bit of a cross reference for each jargon-y word and a word you can search for in the intel manual:

[Here's another nice explanation of `i` related jargon](https://myonlineusb.wordpress.com/2011/06/08/what-is-the-difference-between-i386-i486-i586-i686-i786/)

TLDR, intel's names make no sense :). Frequently, these words are just missused / loaded and it's just best to understand the history.

- `x86`: (2.1.1) Refers to a processors in the 8086 family. (80186 80286 80386 80486...). Usually, it means compatability with the 80386 32 bit instruction set because 16 bit only is so old (TODO - this isn't perfectly accurate)
- `i686`: (2.1.6) Intel686. P6 Family Microarchitecture on the Pentium Pro. One of the 6th generation of `x86` processor.
- `i386`: (2.1.3) Intel386. AKA 80386. First 32 bit (TODO - fact check)
- `x86_64` The 64-bit instruction set (sometimes called amd64) brother of `x86`
    - backwards compatible to `x86` (ie `x86` instructions can run on `x86_64` processors)


[32 bit and 64 bit:](https://www.aliencoders.org/content/basic-information-about-i386-i686-and-x8664-architectures/)
    - A 32-bit OS will run on a 32-bit or 64-bit processor without any problem.
    - A 32-bit application will run on a 32-bit or 64-bit OS without any problem.
    - But a 64-bit application will only run on a 64-bit OS and a 64-bit OS will only run on a 64-bit processor

## The mega mebi tera tebi... confusion
Clearing things up because I haven't seen it stated in the official Intel manuals 
- An **official** mega byte (MB) is 1000^2 bytes. 
- An **official** mebi byte (MiB) is 1024^2 bytes

Intel says `MB` in their reference manuals because MiB wasn't introduced until later and they didn't want to change all their manuals / references. For all intents and purposes, in the intel manuals, MB means 1024^2, which conforms with intuition (e.g. 4 GBytes is 4x2^30 bytes, or 2^2x2^30=2^32 bytes, which fits on a 32 bit number).

# References I've been using
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
