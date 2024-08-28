# OS Notes
## Bootloader
### Setup 16 bit segment registers and stack
- Segment registers
    - CS (Code): Where the currently executing code is located 
    - DS (Data): Where data variables are stored 
    - SS (Stack): Where the stack is located 
    - ES (Extra): Additional segment register used for string operations 
    - FS, GS: Specific uses for 16 and 32 bit x86 registers
    - SP (Stack Pointer): Head of the stack

Example. Simple Memory Model - all segments are in the same region of memory:
```
mov ax, 0x1234
mov ds, ax
mov es, ax
mov ss, ax
mov cs, ax
```
### GDT
- Describes segments of memory:
    - Base address
    - Limit
    - Access rights (executable, read, write)
### Real Mode vs Protected Mode 
- Real Mode:
    - Segment registers hold the raw base address of each segment (16 bit values: address = segment * 16 + offset)
- Protected Mode: 
    - Segment registers hold _segment selectors_:
