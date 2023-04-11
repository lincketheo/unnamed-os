; Store a character in al
printCharacter:
    mov ah, 0x0e ; Teletype output: http://www.ctyme.com/intr/rb-0106.htm
    int 0x10     ; call interrupt
    ret

; Store address of the desired string in si
; Strings should be null terminated
printString:
_nextChar:
    mov al, [si]
    inc si
    cmp al, 0
    je _exitPrintString
    
    call printCharacter
    jmp _nextChar

    _exitPrintString:
    ret
