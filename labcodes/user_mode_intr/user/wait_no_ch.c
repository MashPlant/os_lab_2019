#include <stdio.h>
#include <ulib.h>

int main() {
  int ch = fork();
  if (ch == 0) {
    sleep(500);
    exit(-1);
  }
  int code;
  int ret = waitpid(ch, &code);  
  cprintf("wait return %d, code = %d\n", ret, code);
}