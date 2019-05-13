# Lab7 Report
## 李晨昊 2017011466

## 练习1: 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题
### Q1. 给出内核级信号量的设计描述，及大致执行流程
相关数据结构如下
```c
typedef struct { // 等待队列的哨兵节点类型
    list_entry_t wait_head;
} wait_queue_t;

typedef struct {
    struct proc_struct *proc; // 是进程proc在等待
    uint32_t wakeup_flags;
    wait_queue_t *wait_queue; // 所有等待队列节点都有指向哨兵节点的指针
    list_entry_t wait_link;
} wait_t;

typedef struct {
    int value;
    wait_queue_t wait_queue; // 等待队列的哨兵节点
} semaphore_t;
```

信号量的V操作如下
```c
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag); // 信号量需要更底层的同步机制以保证其操作的原子性
    {
        wait_t *wait;
        // wait_queue_first为FIFO策略
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) { // 对应原理中sem自增后>0的情况
            sem->value ++; // 这个释放的资源没有人要(等待队列为空)，直接增加资源计数
        }
        else { // 对应原理中sem自增后<=0的情况
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1); // 唤醒等待中的进程，并把它移除等待队列
            // wakeup_wait调用wakeup_proc，wakeup_proc把进程加入就绪队列
        }
    }
    local_intr_restore(intr_flag);
}
```

信号量的P操作如下
```c
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) { // 对应原理中sem自减后>=0的情况
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    // 对应原理中sem自减后<0的情况
    // 这个__wait变量可以直接开在栈上，因为可以保证它在被销毁前被移除链表
    // 事实上等待队列中的节点都在栈上，它是由不同的栈上的数据穿起来的链表
    wait_t __wait, *wait = &__wait; 
    wait_current_set(&(sem->wait_queue), wait, wait_state); // 把wait和current进程关联起来，并加入等待队列的队尾
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) { // __up和__down中传入的wait_state都是WT_KSEM，确保本进程的确是因为信号量而阻塞
        return wait->wakeup_flags; // 外面还有一个assert返回值=0
    }
    return 0;
}
```
通过对`__up`和`__down`的分析，可以发现信号量的确做到了等效于原理课中的功能：
1. up操作在当前有等待的进程时，唤醒最早来到的进程；若无，资源计数器+1
2. down操作在资源计数器=0时阻塞并把自身加入等待队列队尾；若资源计数器>0，则资源计数器-1

下面通过用信号量实现的哲学家就餐来分析信号量的使用流程(为清晰起见，代码有一定修改)：
```c
int state[N]; // 记录每个人状态的数组
semaphore_t mutex; // 锁
semaphore_t s[N];  // 每个哲学家一个信号量，用于等待/通知叉子资源准备好了

void phi_test(int i) { // 必须在临界区执行
    // 人的状态 != EATING <=> 人两边叉子空闲(或者可以放下) 
    if(state[i] == HUNGRY && state[LEFT] != EATING && state[RIGHT] != EATING) {
        state[i] = EATING;
        up(&s[i]); // 通知第i个信号量叉子资源已经准备好
    }
}

void phi_take_forks(int i) { 
    down(&mutex); // 上锁
    {
        state[i] = HUNGRY;
        phi_test(i); // 有可能可以准备好叉子资源
    }
    up(&mutex); // 解锁
    down(&s[i]); // 使用叉子资源，三处phi_test调用可以为它提供资源；如当前时刻资源不可以用，则阻塞
}

void phi_put_forks(int i) { 
    down(&mutex); // 上锁
    {
        state[i] = THINKING;
        phi_test(LEFT); // 有可能可以准备好左邻居的叉子资源
        phi_test(RIGHT); // 有可能可以准备好右邻居的叉子资源
    }
    up(&mutex); // 解锁
}

int philosopher(void * arg) {
    int i, iter = 0;
    i = (int)arg;
    while(iter++ < TIMES) {
        do_sleep(SLEEP_TIME); // 思考
        phi_take_forks(i); // 获取叉子，或者阻塞
        do_sleep(SLEEP_TIME); // 吃
        phi_put_forks(i); // 放下叉子
    }
    return 0;    
}
```
### Q2. 给出给用户态进程/线程提供信号量机制的设计方案，并比较说明给内核级提供信号量机制的异同
方案1：直接通过系统调用提供`semaphore_t *create(int n);`，`void up(semaphore_t *sem);`，`void down(semaphore_t *sem);`接口即可
- 异同：没有任何实质性区别，只是经过了系统调用这一层壳

方案2：方案1每次pv操作都需要进入内核，这样就让很多本来不会发生等待，可以完全在用户空间内解决的情形浪费了时间，因此可以考虑一种用户+内核的混合方式，例如`linux`的`futex`机制。查阅一些资料了解到，类似`pthread_sem_t`等信号量实现就是这种方案，维护一个原子int，p的时候减一看下是否<0，只有<0的时候才需要用到内核的服务，而内核的服务也差不多是通过维护等待队列等方案来实现的。
- 不同：这是一种用户+内核的混合方案，可以期望在竞争较少的时候获得较好的性能
- 相同：如果需要用到内核的服务，也基本上就是把在内核实现的信号量经过了系统调用这一层壳提供给用户

方案3：用户空间也可以实现条件变量，例如`pthread_cond_t`。用`strace`可以看出它用到的系统调用似乎也只有`futex`。现在不管它具体是怎么实现的，假定现在已经有了这样一个条件变量，再加上一个很容易就能实现的纯用户空间的`Mutex`(虽然忙等待的自旋锁性能可能不够好)，就可以实现用户空间的信号量，大致如下

```cpp
struct Semaphore {
    Mutex mu;
    int cnt;
    CondVar cv;

    void p() {
        Locker lk(mu); // RAII
        --cnt;
        while (cnt < 0) { // Mesa style, while
            cv.wait(lk);
        }
    }

    void v() {
        Locker lk(mu);
        if (++cnt <= 0) {
            cv.signal();
        }
    }
};
```

- 不同：用户态的条件变量底层要求的互斥访问的实现，不可能使用开启/屏蔽中断，因为os并没有提供这么危险的用户接口。
- 相同：从功能上来讲是等价的，并且都需要更底层的同步原语来支持

## 练习2: 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题
### Q1. 给出内核级条件变量的设计描述，及大致执行流程
相关数据结构如下
```c
typedef struct condvar {
    semaphore_t sem; // 底层实现机制为信号量
    int count; // 正在等待自己的进程数，为0时signal为空操作
    monitor_t *owner; // 指向拥有自己的管程 
} condvar_t;

typedef struct monitor{
    semaphore_t mutex; // 锁
    semaphore_t next; // 因为发出信号而被阻塞的进程等待这个信号量，用于实现Hoare style管程
    int next_count;    // 当前"因为发出信号而被阻塞的进程"的数量
    condvar_t *cv; // 条件变量数组
} monitor_t;
```

条件变量的`wait`操作如下
```c
void cond_wait(condvar_t *cvp) { // 锁应该已经在调用方上了
    monitor_t *mt = cvp->owner;
    ++cvp->count;
    // 在自身开始等待之前先尝试唤醒一个进程
    if (mt->next_count > 0) {
        up(&mt->next); // 当前有因为发出信号而等待的进程，优先唤醒它
    } else {
        up(&mt->mutex); // 否则，放弃自身对管程的占有权，让其他进程可以进入管程
    }
    down(&cvp->sem);
    --cvp->count;
}
```

条件变量的`signal`操作如下
```c
void cond_signal(condvar_t *cvp) { // 锁应该已经在调用方上了
    monitor_t *mt = cvp->owner;
    if(cvp->count > 0) {
        ++mt->next_count;
        up(&cvp->sem); // 虽然up操作只能把等待cvp->sem的进程放入就绪队列，不能立即运行
        down(&mt->next); // 但是通过让发出信号的进程等待next，停止运行并加入等待队列，保证Hoare管程的语义
        --mt->next_count;
    }
}
```

这里做一点简要的分析：因为ucore的`wakeup_proc`策略是把它加入就绪队列，而不是立即开始运行进程，所以没办法直接实现Hoare管程所要求的"资源就绪后，等待资源的进程立即开始运行"。这里用软件的方法做到了"进程在发出信号后，下一个在临界区内运行的必须是等待信号的进程"，在效果上与Hoare管程是相同的。可以证明的确可以做到这一点：`cond_signal`函数的调用者还持有`mt->mutex`，因此在这期间不会有其它进程进入管程的入口；目前在管程内部因为发出信号而阻塞的进程仍然阻塞；目前在管程内部等待信号的进程，如果等待的是这个条件变量，会被加入就绪队列，如果不是则没有任何反应。因此就绪队列唯一的变化是新增了等待信号的进程，等到下次调度它运行时，管程内的共享资源的状态还是和发出信号的时候相同

下面通过用条件变量实现的哲学家就餐来分析条件变量的使用流程(为清晰起见，代码有一定修改)：
```c
int state[N];
monitor_t mt;

void phi_test(int i) { 
    if(state[i] == HUNGRY && state[LEFT] != EATING && state[RIGHT] != EATING) {
        state[i] = EATING;
        cond_signal(&mt.cv[i]); // 通知正在等待该条件变量的进程，即通知因为拿不到叉子而阻塞的哲学家；如果没人在等待，cond_signal为空操作
    }
}

void phi_take_forks(int i) {
    down(&mt.mutex);
    {
        state[i] = HUNGRY;
        phi_test(i); // 这其中可能触发cond_signal，该信号会被忽略
        if (state[i] != EATING) { // 但是如果上面一行成功拿到了叉子，下面就不用wait了
            cond_wait(&mt.cv[i]);
        }
        // 根据Hoare管程的语义，这里保证state[i] == EATING
    }
    // 管程的出口处，如果当前有因为发出信号而阻塞的进程，优先唤醒它
    // 锁迟早还是会被释放的
    up(mt.next_count > 0 ? &mt.next : &mt.mutex);
}

void phi_put_forks(int i) {
    down(&mt.mutex);
    {
        state[i] = THINKING;
        phi_test(LEFT); // 尝试唤醒左邻居
        phi_test(RIGHT); // 尝试唤醒右邻居
    }
    up(mt.next_count > 0 ? &mt.next : &mt.mutex);
}

int philosopher_using(void * arg) {
    int i, iter=0;
    i = (int)arg;
    while(iter++ <TIMES) {
        do_sleep(SLEEP_TIME); // 思考
        phi_take_forks(i);  // 获取叉子，或者阻塞
        do_sleep(SLEEP_TIME); // 吃
        phi_put_forks(i); // 放下叉子
    }
    return 0;    
}
```

### Q2. 给出给用户态进程/线程提供条件变量机制的设计方案，并比较说明给内核级提供条件变量机制的异同
方案1：直接通过系统调用提供`monitor_t *create(int n);`，`void enter(monitor_t *m);`，`void wait(condvar_t *cv);`，`void signal(condvar_t *cv);`，`void leave(monitor_t *m);`接口即可；注意在每个管程函数要求在入口/出口处都有对于管程的状态的设置，而用户是可能忘记调用这些函数的，这需要由内核来进行检查，操作不合法时可进行杀死进程等操作。
- 异同：没有任何实质性区别，只是经过了系统调用这一层壳

方案2：用户空间如果想实现信号量，本质上只需要能够：
1. 让当前进程进入等待状态(是否立刻让出CPU时间并没有关系)
2. 维护一个等待进程的队列，并且需要能够唤醒其中的进程(是否要满足公平性？)
3. 锁(是否要满足公平性？)

如果不要求满足公平性的话，可以给出一个比较简单的实现：一个条件变量就是一个`atomic_bool`，一个管程就是一组条件变量加一个大锁。进入等待状态和唤醒的过程都在等待进程这一边，只需要原子地测试`atomic_bool`是否为`false`，如果是的话改成`true`并结束等待，否则继续等待。发出信号即把`atomic_bool`改成`false`。用代码表示出来的话大致是：

```cpp
struct CondVar {
    atomic_bool flag{true};

    void wait(Mutex &monitor) {
        monitor.unlock();
        while (!flag.tas(true)) ;
        monitor.lock();
    }

    void signal() {
        flag.clear();
    }
};

```
其实例如`pthread`等线程库提供的条件变量，和C++，Java等封装的条件变量，都没有和管程绑定在一起，只需要使用条件变量的时候提供一把锁就够了。这个锁在概念上对应于管程的互斥访问，而管程的实体则并不存在。

- 不同：这个简单的实现对应的是Mesa管程，且没有保证公平性；它只用到了一些硬件指令，不需要os的额外协助
- 相同：二者都可以让应用程序正常运行，也许因为公平性表现会有一些区别，但是只要应用程序自身是正确的，最终应该可以得到相同的结果

### Q3. 能否不用基于信号量机制来完成条件变量？
> 如果不能，请给出理由，如果能，请给出设计说明和具体实现

根据原理课的定义，管程需要入口队列和与条件变量相关的等待队列，即使不采用信号量，事实上也差不多就是把信号量的成员拆散了放进来而已。虽然意义不大，这里我还是给出了一个Mesa管程的实现，采用了原子操作作为底层同步机制。代码如下(已经通过`check_sync.c`的测试，当然我也明白对于同步互斥相关的问题，仅通过了一个测例完全不能说明其正确性)：
```c
// 从之前的lab复制来的原子操作代码
typedef volatile bool lock_t;

static inline bool
test_and_set_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
    return oldbit != 0;
}

static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
    return oldbit != 0;
}

static inline void
lock(lock_t *lock) {
    // 简单起见，获取不到锁的时候就自旋，不主动让出CPU
    while (test_and_set_bit(0, lock)) ; 
}

static inline void
unlock(lock_t *lock) {
    *lock = 0;
}

// 不需要管程的实体，只需要使用者正确配合使用锁和条件变量即可
// 语义上对应于Mesa管程，实现起来简单很多
// 没有实现入口处的等待队列，入口处的锁需要抢占，是不公平的，但是这也是目前大部分实用的库的实现
typedef struct {
    wait_queue_t wq;
} cv_t;

static inline void
cv_init(cv_t *cv) {
    list_init(&cv->wq.wait_head);
}

static inline void
cv_wait(cv_t *cv, lock_t *lk) {
    wait_t __wait, *wait = &__wait;
    wait_current_set(&cv->wq, wait, 0);
    unlock(lk); // 放弃管程的占有权
    schedule();
    lock(lk); // cv_wait返回后就会回到管程，必须重新上锁
}

static inline void
cv_sigal(cv_t *cv) {
    wait_t *wait = wait_queue_first(&cv->wq);
    if (wait != NULL) { // 唤醒等待队列队头
        wakeup_wait(&cv->wq, wait, 0, 1);
    }
    // 发出信号的进程仍然可以继续执行，等待信号的进程继续等待
}
```
使用者需要把之前的`if`改成`while`(为清晰起见，代码有一定修改)
```c
lock_t lk;
cv_t cv[N]; // 锁和条件变量看起来是独立的，需要用户自己保证正确使用

void phi_test(int i) { 
    if(state[i] == HUNGRY && state[LEFT] != EATING && state[RIGHT] != EATING) {
        state[i] = EATING;
        cv_sigal(&cv[i]);
    }
}

void phi_take_forks(int i) {
    lock(&lk);
    state[i] = HUNGRY;
    phi_test(i);
    while (state[i] != EATING) {
        cv_wait(&cv[i], &lk);
    }
    unlock(&lk);
}

void phi_put_forks(int i) {
    lock(&lk);
    state[i] = THINKING;
    phi_test(LEFT);
    phi_test(RIGHT);
    unlock(&lk);
}
```