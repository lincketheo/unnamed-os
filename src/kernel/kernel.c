/**
 * @brief The entry point into the kernel
 */
volatile char* vga = (volatile char*)0xb8000;

extern void main(void)
{
  vga[0] = 'Q';
  vga[1] = 0x07;
  return;
}
