#include <stdio.h>
#include <ulib.h>

void handle() {
  cprintf("hello from user handler\n");
  int esp;
  asm("movl %%esp, %0" : "=r"(esp));
  cprintf("current esp = 0x%x\n", esp);
  asm("leave\n\t"
      "iret");
  __builtin_unreachable();
}

int main() {
  def_user_intr(handle);
  for (int i = 0; i < 100; ++i) {
    asm("int %0\n" ::"i"(253));
  }
}