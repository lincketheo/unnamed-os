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
    ; TODO For paging, set bit 31 I think 
    mov eax, cr0
    or eax, 0x1            
    mov cr0, eax
    ; We are now in 32 bit protected mode

    ; Far Jump to the code segment. 
    ; I got confused on this line of code from the OSDevWiki
    ; A far jump takes the form:
    ; jmp <gdt descriptor>:offset
    ; Where gdt descriptor is the offset from the gdt root. For example
    ; the first gdt descriptor would be 0x8 (because null entry)
    ;
    ; I couldn't find the official docs for this, though (TODO)
    jmp code_seg:_protected_mode

[bits 32]
_protected_mode:
    ; Set up the stack and data segments
    mov ax, data_seg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set up the stack base and pointer
    mov ebp, 0x90000
    mov esp, ebp

    ; Transfer control to the kernel :)
    jmp KERNEL_LOCATION

