[org 0x7c00]
mov ah, 0x0e
mov bx, nameQuestion

askName:
    mov al, [bx]
    cmp al, 0
    je nameInput
    int 0x10
    inc bx
    jmp askName

nameInput:
; Prep
mov bx, buffer
nameInputLoop:
    ; Check if bx exceeds buffer
    cmp bx, buffer + 9
    je response

    mov ah, 0
    int 0x16

    ; Check if user clicked enter
    cmp al, 13      ; 13 = enter
    je response

    ; otherwise, store in buffer 
    mov [bx], al

    ; And print to the screen
    mov ah, 0x0e
    int 0x10

    ; increment bx and start over
    inc bx
    jmp nameInputLoop

    
response:
; Prep
mov bx, hello 
mov ah, 0x0e
printHelloLoop:
    mov al, [bx]
    cmp al, 0
    je printName

    int 0x10

    inc bx
    jmp printHelloLoop

printName:
; Prep
mov bx, buffer
mov ah, 0x0e
printNameLoop:
    mov al, [bx]
    cmp al, 0
    je end

    int 0x10

    inc bx
    jmp printNameLoop


; used to store the user name
buffer:
    times 10 db 0

; Some strings
nameQuestion:
    db "What is your name?... ", 0

hello:
    db " Hello, ", 0

end:
    mov ah, 0x0e
    mov al, '!'
    int 0x10

    jmp $                   ; jump to the current memory address
    times 510-($-$$) db 0   ; write 0 510 minus the previous code times
    db 0x55, 0xaa           ; write the bootloader special characters
