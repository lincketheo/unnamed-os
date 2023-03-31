
mov ah, 0x0e ; teletype mode
mov al, 64 ; start with the letter before 'A'

loop:
    inc al              ; increment by 1
    cmp al, 91          ; 91 is the letter after 'Z'
    je end 

    test al, 1          ; Tests the last bit to see if the text is even (....0) or odd (....1)
    jnz oddprint        ; jump if not match (odd)
    jz evenprint        ; jump if match (even)

evenprint:
    add al, ('a' - 'A') ; add the difference of these two numbers (as chars are contiguous)
    int 0x10            ; call print
    sub al, ('a' - 'A') ; subtract to go back to our origional state
    jmp loop            ; go back and try again

oddprint:
    int 0x10
    jmp loop

end:
    jmp $                   ; jump to the current memory address
    times 510-($-$$) db 0   ; write 0 510 minus the previous code times
    db 0x55, 0xaa           ; write the bootloader special characters
