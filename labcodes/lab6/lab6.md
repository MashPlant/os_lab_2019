# Lab6 Report
## 李晨昊 2017011466
## 练习1: 使用 Round Robin 调度算法
> 完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件）个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。执行make grade，大部分测试用例应该通过。但执行priority.c应该过不去。

## 1. 理解并分析sched_class中各个函数指针的用法，并结合Round Robin 调度算法描ucore的调度执行过程
```c
struct sched_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct run_queue *rq);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // choose the next runnable task
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // dealer of the time-tick
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
};
```
`name`和`init`没有分析的价值。进程生命周期的切换是与`enqueue`，`dequeue`，`pick_next`，`proc_tick`紧密相关的，分析如下：
  
1. `enqueue`

    把一个runnable的进程放入就绪队列。调用点有两处
    
    1. `wakeup_proc`中，把刚刚产生的或者从睡眠中被唤醒的进程加入就绪队列
    2. `schedule`中，把`current`进程加入就绪队列。这是因为running进程是不在就绪队列当中的，而`schedule`会中断`current`的运行，让它从running变成runnable，所以需要加入就绪队列。
    ```c
        current->need_resched = 0;
        if (current->state == PROC_RUNNABLE) {
            sched_class_enqueue(current);
        }
    ```
    但是如果`current`的状态不是runnable(状态是runnable + 不在就绪队列中 = running)，则是刚刚在别处设置了它的状态为sleeping或zombie，接着调用`schedule`，这时就不把它加入就绪队列。
    
    在Round Robin调度算法中实现为：
    ```c
    static void
    RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
        assert(list_empty(&(proc->run_link)));
        list_add_before(&(rq->run_list), &(proc->run_link));
        if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
            proc->time_slice = rq->max_time_slice;
        }
        proc->rq = rq;
        rq->proc_num ++;
    }
    ```
    可见就是简单的加到链表尾。如果它的时间片用完或者大于设定的最大时间片(正常操作下应该是不会发生的)，就把时间片重新设为设定的最大时间片。如果一个进程上次的时间片没有用完就因为某种原因不再运行，现在又加入队列中，那么它依然只拥有上次剩下的时间片。

2. `dequeue`

    把一个不再runnable的进程移除就绪队列。调用点有一处，是在`schedule`中把调度算法选出的适合现在运行的runnable进程移除就绪队列。

    在Round Robin调度算法中实现为：
    ```c
    static void
    RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
        assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
        list_del_init(&(proc->run_link));
        rq->proc_num --;
    }
    ```
    可见就是简单地从链表中删除。

3. `pick_next`

    从就绪队列中选择适合现在运行的runnable进程。调用点有一处，是在`schedule`中，就是2中提到的选择过程。

    在Round Robin调度算法中实现为：
    ```c
    static struct proc_struct *
    RR_pick_next(struct run_queue *rq) {
        list_entry_t *le = list_next(&(rq->run_list));
        if (le != &(rq->run_list)) {
            return le2proc(le, run_link);
        }
        return NULL;
    }
    ```
    可见就是简单地选择链表头。如果链表为空则返回`NULL`指示`schedule`目前除了`idleproc`外已经没有可以运行的进程，让它选择`idleproc`运行。

4. `proc_tick`

    给调度算法提供信息，指示刚刚过去了一个时间片，让它做相应的处理。调用点有一处，在`trap_dispatch`中处理时钟中断的case里。

    在Round Robin调度算法中实现为：
    ```c
    static void
    RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
        if (proc->time_slice > 0) {
            proc->time_slice --;
        }
        if (proc->time_slice == 0) {
            proc->need_resched = 1;
        }
    }
    ```
    其中`proc`就是`current`。可见这里只是统计时间片是否消耗完，如果消耗完则设置`need_resched`为1，后续在`cpu_idle`中会触发`schedule`函数的调用，由它来停止`current`的运行，加入就绪队列。

## 2. 简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计
设定`N`个优先级，`run_queue`中装`list_entry_t run_list[N];`，每个进程都属于一个优先级对应的队列，并且需要在`proc_struct`中保存当前的优先级。它的初始`time_slice`设定为`rq->max_time_slice << priority`。

如果在`proc_tick`中发现`proc->time_slice`减到0，证明它的优先级需要降低(对应于数字，是+1，不超过`N - 1`)。优先级的下降会反映在它下次入队的时候。

在`pick_next`中需要根据优先级高低来选择进程，一种可行的办法是按照概率来选择。优先级较高的进程被选中的概率较高。实现起来可以生成一个随机数，根据它的取值范围来决定从哪个队列的队头选择即将执行的进程。

## 练习2: 实现 Stride Scheduling 调度算法
> 首先需要换掉RR调度器的实现，即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride度器的相关描述，完成Stride调度算法的实现。

## 1. 设计实现过程
在`default_sched_stride.c`中，基本上按照注释编写即可(其实个人认为实现`skew heap`也可以作为实验的内容)。代码和说明如下：
```c
// 根据 max stride - min stride <= max pass <= BIG_STRIDE
// 如果希望 max stride - min stride 不溢出32位有符号正数，只需保证 BIG_STRIDE <= 32位有符号正数的最大值
// 即0x7FFFFFFF
#define BIG_STRIDE  0x7FFFFFFF

static void
stride_init(struct run_queue *rq) {
    // 没有必要初始化run_list，后续都不会用到它
    // lab6_run_pool是斜堆的根节点，不同于链表的哨兵节点，它不是一个实体，而是一个指针
    // 这是因为斜堆的实现并不需哨兵节点，根节点与其他节点一样都存放了数据，所以没有数据时自然为NULL
    rq->lab6_run_pool = NULL;
    rq->proc_num = 0;
}

static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    // skew_heap.h中提供的三个操纵斜堆的函数merge，insert，remove都是将新的斜堆的根节点作为返回值
    // 为了正确更新run_queue中的根节点，需要把返回值赋给rq->lab6_run_pool
    // 也没什么太大必要设置proc->rq = rq，因为目前唯一一个使用了proc->rq的地方是在assert里
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
       proc->time_slice = rq->max_time_slice;
    }
    ++rq->proc_num;
}
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    // 同上
    rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
    --rq->proc_num;
}

static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
    if (rq->lab6_run_pool == NULL) { // 空堆 <=> 根节点为NULL
        return NULL;
    } else {
        // 摘除根节点(最小堆，根节点为lab6_stride最小的进程)
        // 我一直认为le2xxx中的le是list entey的缩写，但是在这里也是适用的
        // 原因在于le2xxx中只用到了member在struct中的偏移量，没有用到member自身的任何信息
        struct proc_struct *proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
        proc->lab6_stride += BIG_STRIDE / proc->lab6_priority;
        return proc;
    }
}

static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    // 与RR_proc_tick处理时钟tick的策略完全一样
    // 因为这两个算法区别在于当前进程需要调度(need_resched)的时候选择新进程来运行的策略
    // 而不是判断当前进程是否需要调度的策略
    if (proc->time_slice > 0) {
        --proc->time_slice;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```
除了这个文件之外，还有一些其它细节需要修改：

1. 申请进程控制块处的初始化
```c
static struct proc_struct *
alloc_proc(void) {
...
        // 这个memset可以说是相当鲁棒了，因为绝大多数成员的初值都是0
        memset(proc, 0, sizeof(struct proc_struct));
        proc->pid = -1;
        proc->cr3 = boot_cr3;
        // 这里需要设置priority为正数(不一定非得是1)，否则会引发除0异常
        proc->lab6_priority = 1;
        // list_init是自己和自己连起来，不是清零
        list_init(&proc->run_link);
...
}
```
2. 时钟中断的处理
```c
    case IRQ_OFFSET + IRQ_TIMER:
        // 这里去掉了TICK_NUM相关的逻辑，因为每个进程占用多少时间片交由sched_class_proc_tick内部来处理，Lab 5中每隔TICK_NUM就设置need_resched的策略已经被废弃了
        // 但是还是要统计ticks，因为sys_gettime需要根据ticks来提供时间信息
        ++ticks;
        sched_class_proc_tick(current);
        break;
```

除此之外，我还有一些关于优化 Stride Scheduling 调度算法的想法：
1. `BIG_STRIDE / proc->lab6_priority`可以进行除常数优化(这是目前内核中除了输出相关函数`printnum`外唯一一个除非常数的地方)。由于设置`priority`的次数远远小于除`priority`的次数，这个优化是可以带来一定效果的(当然，也许这个效果会小到无法分辨)。具体做法很容易在网上查到。
2. 关于数据结构的选择，我认为斜堆并不是最好的选择，左偏树是更好的替代者。斜堆实际上就是左偏树的均摊版本，它可以在相同的均摊时间复杂度下完成左偏树的各个操作，或许常数还会更小一些。但是我认为像os这样的底层软件，应该对最坏运行时间有更严格的要求，而斜堆无法保证这一点。至于左偏树引入的四个字节的内存开销我认为完全可以忽略，毕竟现在的`proc_struct`已经有224个字节了。
