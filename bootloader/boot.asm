
[org 0x7c00]
mov ah, 0x0e    ; telletype mode
mov bx, dataarea

printString:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp printString

dataarea:
    db "Hello world!", 0

end:
    jmp $                   ; jump to the current memory address
    times 510-($-$$) db 0   ; write 0 510 minus the previous code times
    db 0x55, 0xaa           ; write the bootloader special characters
