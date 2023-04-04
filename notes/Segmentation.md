In Real mode, addresses are in 16 bits. That means we can only access up to $2^{16}$ memory addresses (64 KiB - Not that much). Instead, we use segmentation to access memory addresses. The notation in reference manuals looking like this:

`es:bx`

Read as the address of `es` offset by `bx`. 

There are four segment registers:
1. `ds` (data segment)
2. `cs` (code segment)
3. `ss` (stack segment)
4. `es` (other)

In 16 bit mode, a physical address represented by `es:bx` is now equal to $es \times 16 + bs$

We can't directly set segment pointers like this:
```
mov es, 0
```
or else we'll get an error:
```
./bootloader/boot.asm:13: error: invalid combination of opcode and operands
```
and need to set a generic register first, and move it into a segment pointer:
```
mov ax, 0
mov es, ax
```
[Here's a SO explaining why](https://stackoverflow.com/questions/19074666/8086-why-cant-we-move-an-immediate-data-into-segment-register)
TLDR, when assembly syntax doesn't make sense, tough luck. The hardware engineers designed it like that :)

In the tiny memory model, we set all three segment pointers to 0. (often implied in my examples -**never imply that these values are 0 by default** I've just been doing it to get rid of cruft in my examples. My final project uses the tiny memory model)