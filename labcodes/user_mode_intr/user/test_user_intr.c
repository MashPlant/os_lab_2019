#include <stdio.h>
#include <ulib.h>

// void handle() {
//   cprintf("hello from user handler\n");
//   int esp;
//   asm("movl %%esp, %0" : "=r"(esp));
//   cprintf("current esp = 0x%x\n", esp);
//   asm("leave\n\t"
//       "iret");
//   __builtin_unreachable();
// }

// int main() {
//   def_user_intr(253, handle);
//   for (int i = 0; i < 100; ++i) {
//     asm("int %0\n" ::"i"(253));
//   }
// }
#define TICK_NUM 100
volatile size_t ticks;

void handle() {
  // if (++ticks % TICK_NUM == 0) {
  // cprintf("user space %d ticks\n",TICK_NUM);
  // }
  asm("leave\n\t"
      "iret");
  // asm("iret");
  __builtin_unreachable();
}

int main() {
  def_user_intr(32 + 4, handle);
  def_user_intr(32 + 1, handle);
  while (1)
  {
    cprintf("wating...\n");
    // asm("int %0\n" ::"i"(33));
    sleep(10);
  }
}
