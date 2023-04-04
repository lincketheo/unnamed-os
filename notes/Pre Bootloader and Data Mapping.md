
How is data organized in our bootloader? 
How do we read from a physical drive (e.g. to launch a kernel)?
		Because the bootloader is only the first 512 bytes of the drive that we're reading



## What happens when you boot and how is memory / drive data organized?

[reference](https://manybutfinite.com/post/how-computers-boot-up/)

1. Click your power button
2. Usually one cpu is designated to run bios / kernel init code and needs to be activated by the kernel
3. System is now in real mode:
	- Any code can write to any place in memory (oh no!)
	- Most registers have defined values:
		- eip: memory address of the instruction being executed by CPU - Intel: 0xFFFFFFF0 called **reset vector** which has code like this:
```
jmp 0xF0000 ; (BIOS code)
```
![[Pasted image 20230403210931.png]]
4. BIOS stuff happens - unrelated to bootloader
5. BIOS searches a bunch of media (user configured) (hard drives, usb drives etc)
6. BIOS recognizes that the Bootloader is stored on the first 512 bytes if it has the the magic bytes in 510 and 512 (0xaa55)
![[Pasted image 20230403211158.png]]
7. BIOS loads this program to memory address 0x7c00
When the bootloader is loaded into memory, it is loaded into the RAM addresses:
\[0x7c000, 0x7EFF) (ie $7c00_{16} + 512_{10}$)

So you'll often see in bootloader code the following
```
[org 0x7c00]
```

meaning anytime I want to access data (via labels etc), I access them offset by 0x7c00.

Consider the example bootloader code (without org):
```
mov al, [data]
mov ah, 0x0e
int 0x10

data
   db 'X'
```

What's displayed on the screen is not `X`, rather some garbage data. The reason is `data` is stored at some position inside the code (lets say 132 bytes into the binary file that you compiled your bootloader into). So `mov al, [data]` moves the data at address 132 into `al`. Instead, we need to load `[0x7c00 + data]` into al, so we specify an offset in the code at the beginning.

## Reading from disk
Now Let's write some data onto the disk by writing a string into the second sector. 

Remember that BIOS loads only the first sector (512 bytes), so anything after `0xaa55` is _on the disk_ at the time of bootloading, not memory.
```
... bootloader code
dw 0xaa55
db 'Hello World', 0 ; this data is stored in the disk at the time of bootloading, not RAM
```

Now we want to read it. To do so, use interrupt [Interrupt 13h](https://en.wikipedia.org/wiki/INT_13H) with AH = 02h
```
mov ah, 0x02
...
int 0x13
```
`al` = number of sectors to read
`ch` = cylinder number
`cl` = sector
`dh` = head
`dl` = drive number
`es:bx` = buffer address pointer

`es:bx` is read as `ex` offsetted by `bx` (as a pointer). So let's just make our offset `0x7e00` (0x7c00 + 512) and our pointer `0`:

Note we can't do `mov es, 0` . See [this SO](https://stackoverflow.com/questions/19074666/8086-why-cant-we-move-an-immediate-data-into-segment-register). `es` is a segment register. See the segment notes in this project
```
mov bx, 0x7c00
mov ax, 0
mov es, ax
```


The drive number is (I believe) a unique number describing which physical medium (hard drive, floppy disk, etc) we used and is abstracted away from us. For all intents and purposes, it's stored in dl at the start of our bootloader and we don't need to worry about the details of what it is (until I figure out later). So we can store it in a variable like so:
```
mov [DRIVE_NUMBER], dl
db DRIVE_NUMBER 0
```

Our data is located on sector 2, head 0, cylinder 0 (the second sector of our disk). **sectors start at 1 :(**

So:
```
mov cl, 2
mov dh, 0
mov ch, 0
```

We wrote 512 bytes, ie 1 sector:
```
mov al, 1
```

Putting it all together:
```
loadSector2:
    ; define the location to load into memory
    ; do this before setting ah to not mess with ax register
    mov ax, 0
    mov es, ax
    mov bx, 0x7e00

    ; prime interrupt
    mov ah, 0x02

    ; define the location of data
    mov cl, 2
    mov dh, 0
    mov ch, 0

    ; define the number of sectors
    mov al, 1

    ; restore value of dl
    ; or do nothing, I just did this because I might have used 
    ; dl earlier in the bootloader and overwritten this variable
    mov dl, [DRIVE_NUMBER] 
    int 0x13 ; execute the interrupt!
    ret
```

Now let's print the string starting at 0x7e00.

Here's a function to print a string:
```
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
```


And print it:
```
mov si, 0x7e00
call printString
```


The full code:
```
[org 0x7c00]
mov [DRIVE_NUMBER], dl

call loadSector2
mov si, 0x7e00
call printString
jmp $

loadSector2:
    ; define the location to load into memory
    ; do this before setting ah to not mess with ax register
    mov ax, 0
    mov es, ax
    mov bx, 0x7e00

    ; prime interrupt
    mov ah, 0x02

    ; define the location of data
    mov cl, 2
    mov dh, 0
    mov ch, 0

    ; define the number of sectors
    mov al, 1

    ; restore value of dl
    ; or do nothing, I just did this because I might have used 
    ; dl earlier in the bootloader and overwritten this variable
    mov dl, [DRIVE_NUMBER] 
    int 0x13 ; execute the interrupt!
    ret


; prints character in al
printCharacter:
    mov ah, 0x0e 
    int 0x10     
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

DRIVE_NUMBER:
    db 0

times 510 - ($-$$) db 0
dw 0xaa55
db "Hello World", 0
```