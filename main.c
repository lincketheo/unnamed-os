// C Program to demonstrate use
// of left shift operator
#include <stdio.h>

// Driver code
int main()
{
unsigned char b = 0xf;
unsigned char a = 0x4;
printf("%x\n", (b << 4 | a));
return 0;
}

