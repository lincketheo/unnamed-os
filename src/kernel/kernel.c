
/**
 * @brief The entry point into the kernel
 */
extern void main() {
    *(char*)0xb8000 = 'Q';
    return;
}
