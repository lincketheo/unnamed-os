
#include "types.h"

uint8_t port_byte_in(uint8_t port) {
  uint8_t ret;
  asm("in al, %1" : "=a" (ret) : "d"(port));
  return ret;
}

uint16_t port_word_in(uint8_t port) {
  uint16_t ret;
  asm("in ax, %1" : "=a" (ret) : "d"(port));
  return ret;
}

uint32_t port_dword_in(uint8_t port) {
  uint32_t ret;
  asm("in eax, %1" : "=a" (ret) : "d"(port));
  return ret;
}

void port_byte_out(uint8_t port, uint8_t data) {
  asm("out %1, al" : : "a" (data), "d" (port));
}

void port_word_out(uint8_t port, uint16_t data) {
  asm("out %1, ax" : : "a" (data), "d" (port));
}

void port_dword_out(uint8_t port, uint32_t data) {
  asm("out %1, eax" : : "a" (data), "d" (port));
}

