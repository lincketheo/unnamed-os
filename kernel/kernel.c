
/**
 * @brief The entry point into the kernel
 *
 * Currently, this sets the memory address 0xb8000 to Q
 * Memory address 0xb8000 is the start of video memory
 */
extern void main() {
    *(char*)0xb8000 = 'Q';
    return;
}
