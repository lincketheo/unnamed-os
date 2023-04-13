; NOTE: This is run in real mode. All bios interrupts are free. 
; Probably some security vulnerability here, I don't really know, I
; don't really care (yet)



; Usage: call friendlyIntro
; no need to store anything in registers, this 
; function does that all for you
friendlyIntro:
    call _askName
    call _getUsersName
    call _printResponse
    call _printUsersName
    call _printProceed 
    ret

%include"print_string_rm.asm"
%include"text_input_rm.asm"

_sleep_2_seconds:
    mov ah, 0x86
    mov dx, 0x8480
    mov cx, 0x001e
    int 0x15
    ret

_askName:
    mov si, _nameQuestion
    call printString
    ret

_getUsersName:
    mov si, _usersName
    call getString
    ret

_printResponse:
    mov si, _response
    call printString
    ret

_printUsersName:
    mov si, _usersName
    call printString
    ret

_printProceed:
    mov si, _proceed
    call printString 
    call _sleep_2_seconds
    ret

_max_user_name_chars equ 10

; DATA
_usersName:
    times _max_user_name_chars + 1 db 0       

_nameQuestion:
    db "Enter your name to continue.... ", 0

_response:
    db " Hello ", 0

_proceed:
    db "!", 0
