#include <pthread.h>

#define MAX_BUF 100

pthread_mutex_t mu;
pthread_cond_t not_empty, not_full;
int buf[MAX_BUF], cnt = 0;

void *cons(void *arg) {
  while (1) {
    int task;
    pthread_mutex_lock(&mu);
    while (cnt == 0) {
      pthread_cond_wait(&not_empty, &mu);
    }
    task = buf[--cnt];
    pthread_cond_signal(&not_full);
    pthread_mutex_unlock(&mu);
    while (task--) {  // this is task
    }
  }
}

void *prod(void *arg) {
  while (1) {
    int task;
    for (task = 0; task < 100000000; ++task) // prepare task
      ;
    pthread_mutex_lock(&mu);
    while (cnt == MAX_BUF) {
      pthread_cond_wait(&not_full, &mu);
    }
    buf[cnt++] = task;
    pthread_cond_signal(&not_empty);
    pthread_mutex_unlock(&mu);
  }
}

int main() {
  pthread_mutex_init(&mu, NULL);
  pthread_cond_init(&not_empty, NULL);
  pthread_cond_init(&not_full, NULL);

  pthread_t cons_ths[2], prod_ths[2];

  for (int i = 0; i < 2; ++i) {
    pthread_create(&cons_ths[i], NULL, cons, NULL);
    pthread_create(&prod_ths[i], NULL, prod, NULL);
  }
  for (int i = 0; i < 2; ++i) {
    pthread_join(cons_ths[i], NULL);
    pthread_join(prod_ths[i], NULL);
  }
}