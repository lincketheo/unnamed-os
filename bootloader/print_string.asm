; Store a character in al
printCharacter:
    mov ah, 0x0e ; Teletype output: http://www.ctyme.com/intr/rb-0106.htm
    mov bh, 0x00 ; Page number - just use 0
    mov bl, 0x01 ; color blue (if graphics mode enabled - dunno how to enable it, TODO later)

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
