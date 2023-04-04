
; Loads sector 2 directly after the bootloader code in memory (0x7e00)
loadSector2:
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
    ret

