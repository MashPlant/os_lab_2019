#include <stdio.h>

int main() {
  *(int *)(0xc01043c0) = 0; // the address of page fault handler
  // will not get a general protection fault
  // instead will get a page fault, with err code = 7
  cprintf("I survived\n"); // of course will not survive
}