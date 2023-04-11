_clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

%include"gdt.asm"

protected_mode_setup:
    call _clear_screen
    cli                     ; 1. disable interrupts

    lgdt [gdtr]             ; 2. load GDT descriptor

    ; Set protection enable bit in cr0 (control register 0)
    ; (you can't just mov 1 into cr0, so use a general purpose extended (32 bit) register)
    mov eax, cr0
    or eax, 0x1            
    mov cr0, eax
    ; We are now in 32 bit protected mode

    ; Far Jump to the code segment. It's located in the second
    ; target of the gdt, so that's 0+8 bytes (first 8 bytes are null)
    jmp code_seg:_protected_mode

[bits 32]
_protected_mode:
    ; Set up the stack and data segments
    mov ax, data_seg
    mov ds, ax
    mov ss, ax

    jmp KERNEL_LOCATION
