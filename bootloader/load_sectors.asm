
_max_sectors equ 3
_min_sectors equ 1

; Loads sector 2 directly after the bootloader code in memory (0x7e00)
; al contains the number of sectors to load
loadSectors:
    ; load sector into address 0x7e00
    mov ax, 0
    mov es, ax              ; es:bx is just 0 offset by 0x7e00
    mov bx, KERNEL_LOCATION ; loads directly after the portion of the bootloader (7c00 + 512)
    mov ah, 0x02

    ; Cylinder (0), head (0), sector (2)
    mov cl, 2
    mov dh, 0
    mov ch, 0

    ; Read one sector
    mov al, 1
    mov dl, [DRIVE_NUMBER]
    
    int 0x13
    ret
