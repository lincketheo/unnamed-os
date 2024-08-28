; ###################################################
; ############### Section Real Mode 
[org 0x7c00]

; On boot, BIOS calls interrupt 13h, so it stores drive in dl 
mov [DRIVE_NUMBER], dl 

; I'm not sure what the conventions are, 
; I'm just loading mine directly after 
; the bootloader. (7c00 + 512 (dec))
KERNEL_LOCATION equ 0x7e00

; Call a little friendly intro to begin. 
call friendly_intro

; Read 1 sector from the disk. This sector contains our kernel.
call load_kernel

; Enter protected mode and do other setup (such as enabling paging etc)
jmp protected_mode_setup

; ###################################################
; ############### Section Library

; Reference: https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=02h:_Read_Sectors_From_Drive
load_kernel:
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

; NOTE: This is run in real mode. All bios interrupts are free. 
; Probably some security vulnerability here, 
; I don't really care yet

friendly_intro:
    call _ask_name
    call _get_user_name
    call _print_response
    call _print_users_name
    call _print_proceed 
    ret

; Store a character in al
print_character:
    mov ah, 0x0e ; Teletype output: http://www.ctyme.com/intr/rb-0106.htm
    int 0x10     ; call interrupt
    ret

; Store address of the desired string in si
; Strings should be null terminated
print_string:
_next_char:
    mov al, [si]
    inc si
    cmp al, 0
    je _exit_print_string
    
    call print_character
    jmp _next_char

    _exit_print_string:
    ret

; si stores address to store the data
; Max length of the string is 10 bytes
get_char:
    mov ah, 0x00
    int 0x16
    ret

get_string:
    mov bx, 0               ; bx is the increment and si points to the latext point on data
_next_char_input:
    cmp bx, 10              ; Exceeded 10 bytes - return
    je _done 

    call get_char

    cmp al, 13              ; carriage return
    je _done 

    mov ah, 0x0e
    int 0x10
    mov byte [si], al       ; Otherwise, write to location

    inc bx                  ; Next
    inc si
    jmp _next_char_input

    _done:
    ret

_sleep_2_seconds:
    mov ah, 0x86
    mov dx, 0x8480
    mov cx, 0x001e
    int 0x15
    ret

_ask_name:
    mov si, _name_question
    call print_string
    ret

_get_user_name:
    mov si, _users_name
    call get_string
    ret

_print_response:
    mov si, _response
    call print_string
    ret

_print_users_name:
    mov si, _users_name
    call print_string
    ret

_print_proceed:
    mov si, _proceed
    call print_string 
    call _sleep_2_seconds
    ret

_max_user_name_chars equ 10

; ###################################################
; ############### Section Data

_users_name:
    times _max_user_name_chars + 1 db 0       

_name_question:
    db "Enter your name to continue.... ", 0

_response:
    db " Hello ", 0

_proceed:
    db "!", 0

_clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

; References:
; Chapter 3.4.5 (https://www.intel.com/content/www/us/en/content-details/774490/intel-64-and-ia-32-architectures-software-developer-s-manual-volume-3a-system-programming-guide-part-1.html?wapkw=segment%20descriptor)
; And [OSDev wiki](https://wiki.osdev.org/Global_Descriptor_Table)
_gdt_start:
    _gdt_null:
        times 8 db 0  ; Null descriptor

    ; See [Segment Descriptor](https://wiki.osdev.org/Global_Descriptor_Table)
    _gdt_code_descriptor:
        dw 0xffff ; Segment Limit: First 16 bits (use all available memory)
        dw 0x0000 ; Base Address: First (of three) base address
        db 0x00   ; Second half of the base

        ; (s, dpl, p, Type)
        ; 1 -> Valid segment (required 1)
        ; 00 -> Permission 0 
        ; 1 -> Code or Data (not a system segment)
        ; 1 -> Executable 
        ; 0 -> Grows upwards 
        ; 1 -> Readable 
        ; 0 -> Access bit (system sets it to 1 when being accessed)
        db 0b10011010

        ; (avl, l, d/b, g)
        ; 1 -> 4 KByte increments 
        ; 1 -> 32 bit protected code segment (not 16)
        ; 0 -> long mode flag (I was told this should be 1 if d/b is not 0)
        ; 0 -> Just used by the processor 
        ; 1111 -> Segment limit part 2 (20 bits total)
        db 0b11001111
        db 0x00 ; Base offset part 2

    _gdt_data_descriptor:
        dw 0xffff ; Segment Limit: First 16 bits (use all available memory)
        dw 0x0000 ; Base Address: First (of three) base address
        db 0x00   ; Second half of the base

        ; (s, dpl, p, Type)
        ; 1 -> Valid segment (required 1)
        ; 00 -> Permission 0 
        ; 1 -> Code or Data (not a system segment)
        ; 0 -> Not Executable 
        ; 0 -> Grows upwards 
        ; 1 -> Readable 
        ; 0 -> Access bit (system sets it to 1 when being accessed)
        db 0b10010010

        ; (avl, l, d/b, g)
        ; 1 -> 4 KByte increments 
        ; 1 -> 32 bit protected code segment (not 16)
        ; 0 -> long mode flag (I was told this should be 1 if d/b is not 0)
        ; 0 -> Just used by the processor 
        ; 1111 -> Segment limit part 2 (20 bits total)
        db 0b11001111
        db 0x00 ; Base offset part 2

_gdt_end:


gdtr:
    dw _gdt_end - _gdt_start - 1 ; Limit (len(gdt) - 1)
    dd _gdt_start                ; Base address of gdt

; ###################################################
; ############### Section Protected Mode

protected_mode_setup:
    call _clear_screen

    cli                     ; 1. disable interrupts

    lgdt [gdtr]             ; 2. load GDT descriptor

    ; Set protection enable bit in cr0 (control register 0)
    ; TODO For paging, set bit 31 I think 
    mov eax, cr0
    or eax, 0x1            
    mov cr0, eax

    ; Now in 32 bit protected mode
    ; Far Jump to the code segment. 
    ; (remember 8 null bits in GDT)
    jmp 0x08:_protected_mode

[bits 32]
_protected_mode:
    ; Set up the stack and data segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up the stack base and pointer
    mov ebp, 0x90000
    mov esp, ebp

    ; Transfer control to the kernel :)
    jmp KERNEL_LOCATION


DRIVE_NUMBER:
    db 0

; The magic number that lets BIOS know that
; this is a bootloader
times 510 - ($-$$) db 0
dw 0xaa55

