
#define VGA_START (char*)0xb8000
#define VGA_INC 2
#define STRLEN_CUTOFF 1000
#define uint8_t unsigned char


/**
 * TODO - something wierd is happening where this code sometimes works if 
 * the background / foreground color wheels are defined outside, and sometimes it
 * doesn't work. 
 *
 * I presume something related to the stack that I ignored
 *
 * Also could be optimizations or some compiler tomfoolery
 */

unsigned int strlen(const char* str) {
    unsigned int ret = 0;
    while(*(str + ret) != 0x00 && ret < STRLEN_CUTOFF) {
        ret ++;
    }
    return ret;
}

void printString(const char* str) {
    const uint8_t background_color_wheel[] = {0xf, 0x4, 0xa};
    const uint8_t foreground_color_wheel[] = {0x4, 0xd, 0x0}; 

    char* vga_start = VGA_START;
    const unsigned int len = strlen(str);

    for(int i = 0; i < len; i++){
        *(vga_start + VGA_INC*i) = *(str + i);
        *(vga_start + VGA_INC*i + 1) = 
            background_color_wheel[i % 3] << 4 | foreground_color_wheel[i % 3];
    }
}

/**
 * @brief The entry point into the kernel
 */
extern void main() {
    const char data[] = "Hello World!";
    printString(data);
    return;
}
