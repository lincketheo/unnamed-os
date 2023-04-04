[org 0x7c00]
mov [DRIVE_NUMBER], dl

; Set up the tiny memory model and stack, where all segment registers get 0
; stack starts at 0x8000
mov ax, 0
mov es, ax
mov ds, ax
mov ss, ax
mov sp, 0x7c00

call loadSector2
mov si, 0x7e00
call printString
jmp $

%include"load_sector_2.asm"
%include"print_string.asm"

DRIVE_NUMBER:
    db 0

times 510 - ($-$$) db 0
dw 0xaa55
db "Hello World", 0
