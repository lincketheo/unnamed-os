`gdtr`: Points at the location of the GDT
32/64 bit linear base address (bits 16 - 79) - 16 bit table limit (bits 0 - 15)
- Table limit - tells the size of the gdt (max of 16 bits) - via the last byte
- Base address - Stores _linear address_ where gdt is stored
	- TODO - for now, no paging means linear == physical


