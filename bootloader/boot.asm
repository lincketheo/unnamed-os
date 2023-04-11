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

KERNEL_LOCATION equ 0x7e00

; Call a little friendly intro to begin. 
; This is in real mode!
call friendlyIntro

; Read 1 sector from disk
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

