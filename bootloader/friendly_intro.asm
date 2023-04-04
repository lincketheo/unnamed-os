friendlyIntro:
    call askName
    call getUsersName
    call printResponse
    call printUsersName
    call printExclamation
    ret

%include"print_string.asm"
%include"text_input.asm"

askName:
    mov si, nameQuestion
    call printString
    ret

getUsersName:
    mov si, usersName
    call getString
    ret

printResponse:
    mov si, response
    call printString
    ret

printUsersName:
    mov si, usersName
    call printString
    ret

printExclamation:
    mov al, '!'
    call printCharacter
    ret

; DATA
usersName:
    times 11 db 0

nameQuestion:
    db "Enter your name to continue.... ", 0

response:
    db " Hello ", 0

