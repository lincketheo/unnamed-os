; GDT describes segments (currently code and data) and their permissions (you can't execute the
; data segment silly)

; References:
; Chapter 3.4.5 (https://www.intel.com/content/www/us/en/content-details/774490/intel-64-and-ia-32-architectures-software-developer-s-manual-volume-3a-system-programming-guide-part-1.html?wapkw=segment%20descriptor)
; And [OSDev wiki](https://wiki.osdev.org/Global_Descriptor_Table)
_gdt_start:
    _gdt_null:
        times 8 db 0 

    ; Segment descriptor - has a complex structure. 
    ; See [Segment Descriptor](https://wiki.osdev.org/Global_Descriptor_Table)
    _gdt_code_descriptor:
        ; byte offset 0

        ; bits 0-15: First 16 bits of segment limit
        ; We want all 4 gigabytes, so our segment limit should
        ; be (111111... x20) = 0xfffff (5 f's)
        ; However, the processor puts this value and the later 1/2 byte value of the limit
        ; together with this one, so this one is only 2 bytes (0xffff) to be combined with
        ; (0xf) later on in the gdt
        dw 0xffff
        
        ; bits 16-31 The first (of three) part of the base address (to be concatenated with
        ; the later fields
        dw 0x0000

        ; byte offset 4
        ; bits 0-7: The second half of the base
        db 0x00

        ; bits 15-12 (s, dpl, p)
        ; p = 1 -> indicates that this is a valid segment (if 0, an exception will be thrown)
        ; dpl = 00 -> Permission level 0 (most priveleged) Might change this, not sure
        ; s = 1 -> Code or data segment (as opposed to a system segment)

        ; bits 11-8 (Type): 
        ; e = 1 -> Indicates this is an executable segment
        ; dc = 0 -> Indicates that this segment grows upwards
        ; rw = 1 -> Readable
        ; a = 0 -> Access bit: Keep this 0, system sets to 1 when being accessed
        db 0b10011010

        ; bits 23-20 (avl, l, d/b, g)
        ; g = 1 -> indicates that segment uses 4 KByte increments (ranges from 4KB to 4 GB) 
        ; d/b = 1 -> Indicates 32 bit protected code segment (as opposed to 16)
        ; l = 0 -> Long mode flag, I was told this should be 1 if d/b is not 0
        ; avl = 0 (just used by the processor - no reason it's 0)
        
        ; bits 19-16 Segment limit pt 2 = 0xf (1111)
        db 0b11001111
        
        ; bits : Third half of the base offset
        db 0x00

    _gdt_data_descriptor:
        dw 0xffff
        dw 0x0000
        db 0x00
        db 0b10010010
        db 0b11001111
        db 0x00

_gdt_end:


gdtr:
    dw _gdt_end - _gdt_start - 1
    dd _gdt_start


code_seg equ _gdt_code_descriptor - _gdt_start
data_seg equ _gdt_data_descriptor - _gdt_start

