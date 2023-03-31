jmp $ ; jump to the current memory address
times 505-($-$$) db 0 ; write 0 510 minus the previous code times
db 0x55, 0xaa ; write the bootloader special characters
