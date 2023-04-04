[org 0x7c00]

; Set up
mov [DRIVE_NUM], dl              ; save the drive number that we booted from

; Set up the tiny memory model and stack, where all segment registers get 0
; stack starts at 0x8000
mov ax, 0
mov es, ax
mov ds, ax
mov ss, ax
mov sp, 0x7c00


; Loads sector 2 directly after the bootloader code in memory (0x7e00)
; load sector into address 0x7e00
mov ax, 0
mov es, ax              ; es:bx is just 0 offset by 0x7e00
mov bx, 0x7e00
mov ah, 0x02

; Cylinder (0), head (0), sector (2)
mov cl, 2
mov dh, 0
mov ch, 0

; Read one sector
mov al, 1
mov dl, [DRIVE_NUM]

int 0x13

mov si, 0x7e00
call printString

%include"print_string.asm"


DRIVE_NUM: db 0

jmp $
times 510 - ($-$$) db 0
dw 0xaa55

db "I'm data on sector 2! WHOA!", 0
