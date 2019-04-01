#include <stdio.h>
#include <ulib.h>

int main(int argc, char **argv) {
  int i;
  cprintf("-----start print argv-----\n");
  for (i = 0; i < argc; ++i) {
    cprintf("%s\n", argv[i]);
  }
  cprintf("-----end print argv-----\n");
  return 0;
}