#include <pthread.h>

pthread_mutex_t mu;

void *th(void *_arg) {
  pthread_mutex_lock(&mu);
  for (int i = 1000000000; --i;)
    ;
  pthread_mutex_unlock(&mu);
}

int main() {
  pthread_mutex_init(&mu, NULL);
  pthread_t th1, th2;
  pthread_create(&th1, NULL, th, NULL);
  pthread_create(&th2, NULL, th, NULL);
  pthread_join(th1, NULL);
  pthread_join(th2, NULL);
}