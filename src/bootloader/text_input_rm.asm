; si stores address to store the data
; Max length of the string is 10 bytes
getChar:
    mov ah, 0x00
    int 0x16
    ret


getString:
    mov bx, 0               ; bx is the increment and si points to the latext point on data
_nextCharInput:
    cmp bx, 10              ; Exceeded 10 bytes - return
    je _done 

    call getChar

    cmp al, 13              ; carriage return
    je _done 

    mov ah, 0x0e
    int 0x10
    mov byte [si], al       ; Otherwise, write to location

    inc bx                  ; Next
    inc si
    jmp _nextCharInput

    _done:
    ret
