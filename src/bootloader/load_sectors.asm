
_max_sectors equ 3
_min_sectors equ 1

; Reference: https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=02h:_Read_Sectors_From_Drive
; Loads sector 2 directly after the bootloader code into memory into location KERNEL_LOCATION 
loadSectors:
    ; load sector into address 0x7e00
    mov ax, 0
    mov es, ax              
    mov bx, KERNEL_LOCATION 
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
