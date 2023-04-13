[bits 32]
[extern main]

; LD wants a _start entry
; See https://stackoverflow.com/questions/34758769/load-warning-cannot-find-entry-symbol-start
global _start

_start:
    call main       ; call main function defined in the kernel
    jmp $           ; infinite loop
