; A good article explaining booting: https://manybutfinite.com/post/how-computers-boot-up/ 
; (pretty much everything before this program is run)


; The bootloader is loaded into address 0x7c00 of RAM
; This is a design decision of BIOS and can't be changed
; org offsets addresses jumped to by 7c00
[org 0x7c00]

; On boot, BIOS calls interrupt 13h, which means it
; stores the correct drive number in dl, which means
; we can just copy that into our code in case we use dl
; later on in the boot process
mov [DRIVE_NUMBER], dl 

; This is where the kernel is loaded.
; I'm not sure what the conventions are, I'm just loading mine directly
; after the bootloader. (7c00h + 512d)
; I should probably load this elsewhere. I'll probably do that some time :)
KERNEL_LOCATION equ 0x7e00

; Call a little friendly intro to begin. 
call friendlyIntro

; Read 1 sector from the disk. This sector contains our kernel.
; Before this code, memory 7e00 and above is garbage
; After this code, memory 7e00 - ... contains our kernel binary
; Keep in mind the number of sectors. Number of sectors to load should
; equal ciel(size of kernel in bytes / 512)
call loadSectors

; Enter protected mode and do other setup (such as enabling paging etc)
jmp protected_mode_setup

%include "load_sectors.asm"
%include "friendly_intro.asm"
%include "protected_mode.asm"

DRIVE_NUMBER:
    db 0

; The magic number that lets BIOS know that
; this is, in fact, a bootloader
times 510 - ($-$$) db 0
dw 0xaa55

; this is technically the kernel. After linking and cat-ing, 
; the kernel binary lives right here. You could even write some 
; assembly here and ignore all the kernel.c stuff and it would run fine.
