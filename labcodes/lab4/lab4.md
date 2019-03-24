# Lab4 Report
# 李晨昊 2017011466
## 练习1：分配并初始化一个进程控制块
```
alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程
```
### 1. 设计实现过程
实现如下
```c
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        memset(proc, 0, sizeof(struct proc_struct));
        proc->pid = -1;
        proc->cr3 = boot_cr3;
    }
    return proc;
}
```
先用`memset`清零了`proc`的所有成员，然后对于需要特殊值的成员再进行赋值，简要解释如下
1. `proc->state`应该赋值`PROC_UNINIT`，但这个枚举值本来就是0，因此无再特意赋值
2. `proc->pid`赋值-1，这是一个无效的值，用来表示只是分配好了这片内存，实际上进程还不存在
3. `proc->cr3`赋值`boot_cr3`，因为这是一个内核态进程，而所有内核态进程公用内核态页目录表，也就是`boor_crs`
4. 其余值均赋值为0即可；其实它们基本上也都不需要赋值，因为使用者会重新赋值来覆盖原值(也许这会留下一些安全隐患？)

### 2. 请说明proc_struct中struct context context和struct trapframe *tf成员变量含义和在本实验中的作用是啥
1. `context`：表示这个进程被切换前的寄存器现场

在本实验中，`proc_run`中从`from->context`切换到`to->context`，具体操作在`switch_to`中
```asm
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
    popl 0(%eax)                # save eip !popl
    movl %esp, 4(%eax)          # save esp::context of from
    ...
    movl %ebp, 28(%eax)         # save ebp::context of from

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
    ...
    movl 4(%eax), %esp          # restore esp::context of to

    pushl 0(%eax)               # push eip

    ret
```
大部分代码都是在拷贝`context`中的八个寄存器(把当前寄存器保存到`from->context`中，从`to->context`中读取寄存器)。拷贝结束后，通过`pushl 0(%eax)`将`to->context.eip`(它是`struct context`的第一个成员，因此地址最低的位置)放到当前栈顶，下一行`ret`即`pop eip`，于是就让`eip`指向了进程`to`上次被打断的地方执行。

当然，本次实验中并没有这个中断又切换回来的过程，而`copy_thread`为它构造的`context`是
```
    proc->context.eip = (uintptr_t)forkret;
    proc->context.esp = (uintptr_t)(proc->tf);
```
因此会从`forkret`处开始执行，执行所用的栈为`proc->tf`。

2. `tf`：表示这个进程在内核栈中的中断帧的位置

接下来，`current->tf`在`forkret`中被传给`forkrets`
```c
static void
forkret(void) {
    forkrets(current->tf);
}
```
在`forkrets`中，利用它在栈上的位置找到了它，并把它的内容(它指向的地址)设置为了新栈的地址，并跳转到了`__trapret`
```asm
.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
    jmp __trapret
```
在`__trapret`中，利用了`tf`指向的地址内存储的信息(这信息是`kernel_thread`和`copy_thread`等函数共同填写的)恢复了中断前(虽然这里并不是因为中断而发生的进程切换)的现场
```asm
.globl __trapret
__trapret:
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
    iret
```
在`kernel_thread`中指定的`tf_eip`为`(uint32_t)kernel_thread_entry`，因此下一行执行的代码为
```asm
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
    call *%ebx              # call fn

    pushl %eax              # save the return value of fn(arg)
    call do_exit            # call do_exit to terminate current thread
```
至此，终于开始执行`kernel_thread`中制定的函数`fn`

## 练习2：为新创建的内核线程分配资源
```
创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用do_fork函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。
```
### 1. 设计实现过程
代码如下
```c
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
...
    proc = alloc_proc(); //    1. call alloc_proc to allocate a proc_struct
    proc->pid = get_pid();
    ++nr_process;
    setup_kstack(proc); //    2. call setup_kstack to allocate a kernel stack for child process
    copy_mm(clone_flags, proc); //    3. call copy_mm to dup OR share mm according clone_flag
    copy_thread(proc, stack, tf); //    4. call copy_thread to setup tf & context in proc_struct
    hash_proc(proc); //    5. insert proc_struct into hash_list 
    list_add(&proc_list, &proc->list_link); // && proc_list
    wakeup_proc(proc); //    6. call wakeup_proc to make the new child process RUNNABLE
    ret = proc->pid; //    7. set ret vaule using child proc's pid
...
}
```
基本上每行代码的作用都如同注释里描述的一样，还有一些细节需要解释一下
1. 在`alloc_proc`之后需要为`proc`分配`pid`并且更新进程数量。
2. 这里为了简单起见没有考虑错误处理，因此下面的那几个label就都没有用到。
3. 观察发现，`get_pid`，`++nr_process`，`hash_proc(proc)`，都是线程不安全的(按照我平时编程的观点来看)，也许需要模仿其它地方的代码一样用一对关中断和开中断包起来，不过不这样做也能顺利通过测试，就不再麻烦了。

### 2. 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由
先吐槽一下`get_pid`这个函数的名字，一般认为`get_xxx`应该是一个只读的接口，但是这里实际上起了`generate_pid`的效果(虽然这在注释中有说明)

`get_pid`内部的实现也让我感觉比较奇怪，如果是为了保证`pid`的唯一性，可以维护一个未使用的`pid`的链表，每当进程产生和结束的时候去修改这个链表即可。不知道为什么要做的这么麻烦，也许好处在于可以节省一些空间？

代码如下
```c
static int
get_pid(void) {
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) { // 循环分配，超出上限就归1(0属于idleproc)
        last_pid = 1;
        goto inside; // 归1后不再能保证last_pid到next_safe区间内的pid未被占用，故跳过if判断直接进入内部
    }
    if (last_pid >= next_safe) { // 不再能保证last_pid的唯一性，在下面逐个检查
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
            proc = le2proc(le, list_link);
            if (proc->pid == last_pid) { // 冲突了，那么last_pid + 1，再找一遍(看起来很低效啊)
                if (++ last_pid >= next_safe) {
                    if (last_pid >= MAX_PID) {
                        last_pid = 1;
                    }
                    next_safe = MAX_PID;
                    goto repeat;
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) { // 没有冲突
                next_safe = proc->pid; // 更新缩小安全区间
            }
        }
    }
    return last_pid;
}
```
总的来讲是利用`next_safe`来划定一个不会冲突的区间，以期提高一点效率。最坏情况下仍需要$O(当前进程数^2)$的时间才能找到一个没有冲突的`pid`。

但是算法的正确性还是没问题的，只要没有condition race，它还是可以保证新fork的进程与已经存在的进程都有不同的`pid`(当然，可能会与曾经存在过的进程有相同的`pid`)

## 练习3：阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的
### 1. 对proc_run函数的分析
```c
void
proc_run(struct proc_struct *proc) {
    if (proc != current) { // 如果proc就是当前进程，那么不需要调度
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        local_intr_save(intr_flag); // 上锁
        {
            current = proc; // 更新当前进程
            load_esp0(next->kstack + KSTACKSIZE); // 更新tss中的ring 0的esp为proc对应的内核线程的内核栈的栈顶
            lcr3(next->cr3); // 将proc的页目录表的位置加载到cr3，从而切换页表(本实验中无用)
            switch_to(&(prev->context), &(next->context)); // 切换进程，具体原理在上面已经有分析
        }
        local_intr_restore(intr_flag); // 解锁
    }
}
```

### 2. 在本实验的执行过程中，创建且运行了几个内核线程？
2(idleproc, initproc)

### 3. 语句local_intr_save(intr_flag);....local_intr_restore(intr_flag);在这里有何作用?请说明理由
关中断/开中断，这样这段代码在执行的时候不会被打断(仅限于单核处理器)，作用相当于`mutex.lock()`/`mutex.unlock()`