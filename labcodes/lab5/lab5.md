# Lab5 Report
## 李晨昊 2017011466
## 练习1: 加载应用程序并执行
> do_execv函数调用load_icode（位于kern/process/proc.c中）来加载并解析一个处于内存中的ELF执行文件格式的应用程序，建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好proc_struct结构中的成员变量trapframe中的内容，确保在执行此进程后，能够从应用程序设定的起始执行地址开始执行。需设置正确的trapframe内容。
### 1. 设计实现过程
代码如下
```c
static int
load_icode(unsigned char *binary, size_t size) {
...
    tf->tf_cs = USER_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
    tf->tf_esp = USTACKTOP;
    tf->tf_eip = elf->e_entry;
    tf->tf_eflags |= FL_IF;
...
}
```
这段代码的目的是，通过设置`current`进程的`tf`指向的内容，让接下来的`iret`能够跳转到用户代码执行，并且具有用户空间的段选择子。

因此，`tf_cs, tf_ds, tf_es, tf_ss`均设置成`USER`开头的对应段选择子，`tf_esp`指向用户态的栈顶，`tf_eip`指向elf文件中指定的程序起始地址，也就是`initcode.S`中的`_start`的第一行代码。最后，按照要求还要设置`tf_eflags`的中断位，使得用户态进程可以响应中断。

其实在lab1的challenge1中的`lab1_switch_to_user`函数以及`trap_dispatch`中的`case T_SWITCH_TOU`部分的实现思路与上面的思路很类似，只是不需要考虑`eip`和中断。

### 2. 当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的
> 即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

这里以`user_main`来分析。

首先它执行`kernel_execve`，这里传入了用户代码的各种信息，包括名字，地址，长度。

在`kernel_execve`中`SYS_exec`发起系统调用，经过正常的系统调用流程(这里省略，留在练习3分析)后进入`syscall.c::sys_exec`，它接着调用`proc.c::do_execve`(看起来是从`proc.c`经过系统调用转了一圈又回来了，但是本质的区别在于等一下会执行一次`iret`，这样才能正确地进入用户代码)。

`do_execve`主要做两件事：
1. 释放原有的地址空间
    ```c
    if (mm != NULL) {
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    ```
    释放地址空间的前提是当前进程不是内核态进程，因此对于`user_main`进程来说这些代码都不会执行。

2. 调用`load_icode`

`load_icode`内主要做了以下几件事：
1. 读取并校验elf文件(在内存中)的格式
2. 为即将执行的进程创建虚拟内存管理器`mm_struct`，并设置其页目录表的内容，这页目录表基本是内核页目录表的拷贝
    ```c
        pde_t *pgdir = page2kva(page);
        memcpy(pgdir, boot_pgdir, PGSIZE);
        pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
        mm->pgdir = pgdir;
    ```
3. 依次建立elf文件中的每个`proghdr`的中的各个段的虚拟地址到物理地址的映射
   - 需要为它们申请物理页，以及把它们加入`mm_struct`的管理内，标识这是该用户进程可以合法访问的地址。
4. 建立用户栈，对它的内存管理基本同上
    ```c
        vm_flags = VM_READ | VM_WRITE | VM_STACK;
        if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
        ...
    ```
5. 将当前进程的`mm`和`cr3`均覆盖为刚刚申请到的`mm`和页目录表地址
6. 操纵当前进程的`tf`指向的内容，从而在接下来的`iret`后进入用户态。

接下来，上述函数依次返回，进入`trapentry.S`，从刚刚设置好的`tf`中恢复了寄存器现场后，执行`iret`进入了用户态的第一行代码，是`initcode.S`中的`_start`
```asm
_start:
    # set ebp for backtrace
    movl $0x0, %ebp

    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp

    # call user-program function
    call umain # no return
1:  jmp 1b # spin
```
在`umain`中调用了用户编写的`main`，并用它的返回值作为`exit`的参数
```
void
umain(void) {
    int ret = main();
    exit(ret);
}
```
进入用户编写的`main`后，开始真正执行用户编写的第一行代码。

## 练习2: 父进程复制自己的内存空间给子进程
> 创建子进程的函数do_fork在执行中将拷贝当前进程（即父进程）的用户内存地址空间中的合法内容到新进程中（子进程），完成内存资源的复制。具体是通过copy_range函数（位于kern/mm/pmm.c中）实现的，请补充copy_range的实现，确保能够正确执行。
### 1. 设计实现过程
代码如下
```c
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
...
    void *src_kvaddr = page2kva(page); // (1) find src_kvaddr: the kernel virtual address of page
    void *dst_kvaddr = page2kva(npage); // (2) find dst_kvaddr: the kernel virtual address of npage
    memcpy(dst_kvaddr, src_kvaddr, PGSIZE); // (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
    ret = page_insert(to, npage, start, perm); // (4) build the map of phy addr of  nage with the linear addr start
...
}
```
这段代码负责把`page`管理的内存拷贝到`npage`管理的内存处，因为它们都是`Page`指针，根据lab2建立的连续内存管理机制，`Page`指针可以通过一些运算来对应到虚拟地址(缩放+偏移`KERNBASE`)，这里调用`page2kva`来实现。随后，在虚拟地址上调用`memcpy`拷贝内存，最后把`npage`管理的内存加入页目录表`to`

### 2. 如何设计实现”Copy on Write 机制“
在`copy_range`函数中不拷贝页面，而是把原始`page`的位置直接装在新的页表项中，但是把页表项的W位置0。之后可以正常的读取，但写入时会引发缺页异常，缺页异常处理例程中需要特别处理这种情形(为了避免与普通的"向只读的页面写入"，也许可以利用空余的3位做一些额外的标记)。这时才拷贝内存，设置页表项为新的内存位置，并且将W位置1，表示以后这个资源就属于它，可以自由地写了。

## 练习3: 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现
### 1. 对 fork/exec/wait/exit函数的分析
#### 1.1 fork
`do_fork`函数负责生成一个以当前进程为父进程的进程，并且将当前进程的地址空间拷贝到新产生的进程中去(逻辑上是如此，如果采用了COW则并不用真的拷贝)。

关键代码分析如下(这其实是lab4的实验内容)：
```c
    proc = alloc_proc(); //    1. call alloc_proc to allocate a proc_struct
	proc->parent = current;
    proc->pid = get_pid();
    setup_kstack(proc); //    2. call setup_kstack to allocate a kernel stack for child process
    copy_mm(clone_flags, proc); //    3. call copy_mm to dup OR share mm according clone_flag
    copy_thread(proc, stack, tf); //    4. call copy_thread to setup tf & context in proc_struct
    hash_proc(proc); //    5. insert proc_struct into hash_list 
    set_links(proc); // && proc_list
    wakeup_proc(proc); //    6. call wakeup_proc to make the new child process RUNNABLE
    ret = proc->pid; //    7. set ret vaule using child proc's pid
```
为了生成新进程，它首先分配一个进程控制块，设定它的`parent`为当前进程，为它分配`pid`。

随后它为新进程分配内核栈，即该进程发生中断时内核栈的位置(体现在`copy_thread`中的`proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1`一句)。随后调用`copy_mm`拷贝地址空间，调用`copy_thread`设定现场信息，使得本进程看起来是即将执行函数`forkrets`，这个函数会将栈设置到`tf`的位置，然后执行`iret`，这次`iret`会转到`tf->tf_eip`的位置。如果是被`kernel_thread`调用的`do_fork`，这个位置被设定成`kernel_thread_entry`，接下来会执行`kernel_thread`的`fn`参数；如果是被`syscall`调用的`do_fork`，这个位置被设定成当前进程正处的位置，因为
```c
static int
sys_fork(uint32_t arg[]) {
    struct trapframe *tf = current->tf; // current->tf包含了调用syscall的进程的当前执行信息
    uintptr_t stack = tf->tf_esp;
    return do_fork(0, stack, tf);
}
```
于是子进程就和父进程从同一位置开始执行。

完成这些工作之后，它唤醒了这个新进程(唤醒实际上就是设定`proc->state`和`proc->wait_state`，让它有机会被`schdule`函数分配到时间片)

顺便记录一下我对`fork`对于父进程返回子进程`pid`，而对子进程返回0的原因的分析：
- 对于父进程，即系统调用的发起者，经过
```c
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
...
    ret = proc->pid;
fork_out:
    return ret;
...
}

static int
sys_fork(uint32_t arg[]) {
    struct trapframe *tf = current->tf;
    uintptr_t stack = tf->tf_esp;
    return do_fork(0, stack, tf);
}

void
syscall(void) { // in kernel
...
    tf->tf_regs.reg_eax = syscalls[num](arg);
...
}

__trapret:
...
    popal
...

static inline int
syscall(int num, ...) { // in user
...
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
...
        : "cc", "memory");
    return ret;
}
```
这一条链的返回值传递，就能把子进程`pid`返回给父进程。

- 对于子进程，经过
```c
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
...
    proc->tf->tf_regs.reg_eax = 0;
...
}

forkrets:
    movl 4(%esp), %esp
    jmp __trapret

__trapret:
...
    popal
...
```
就把`eax`设置成了0。虽然子进程本身没有执行过`fork`函数，但是效果等效于刚刚执行了`fork`并且返回了0

#### 1.2 exec
函数`do_execve`已经在上面分析过，这里略过，从用户态执行这个系统调用的主要区别在于，条件`if (mm != NULL) `成立，会执行后面的尝试释放内存的过程。

#### 1.3 wait
`do_wait`负责等待某个子进程或者任一个子进程，当它进入zombie状态后取出它的返回值并彻底回收这个子进程。如果没有等到，则当前进程进入睡眠，交由`schdule`来调度。

关键代码分析如下:
1. 寻找子进程
```c
    haskid = 0;
    if (pid != 0) { // 查找某一zombie子进程
        proc = find_proc(pid); // 实际上也可以遍历孩子链表来找，而且个人认为那样实现更优
        if (proc != NULL && proc->parent == current) {
            haskid = 1;
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    else { // 查找任一zombie子进程
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) { // 遍历孩子链表
            haskid = 1;
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD; // 设置自身为等待状态，原因是在等待子进程
        schedule();
        if (current->flags & PF_EXITING) { // 如果本进程被kill了
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
```
2. 抹除子进程的进程控制信息，释放内核栈的空间，释放进程控制块的空间。到这里这个进程才彻底死亡。
```c
    local_intr_save(intr_flag);
    {
        unhash_proc(proc);
        remove_links(proc);
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
```
#### 1.4 exit
函数`do_exit`负责回收本进程的绝大部分内存，将本进程的状态设置为zombie(并通知正在等待这一事件的它的父亲)，设置`exit_code`，将进程控制块从进程树中摘出来(但并没有从进程链表和散列表中摘出来，那是在`do_wait`中)。还要将它的子进程全部归于`initproc`，如果这些子进程是zombie状态，也需要通知`initproc`。最后，调用`schedule`交出控制权

关键代码分析如下：
1. 释放内存
```c
    if (mm != NULL) { // 如果不是内核态进程
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
```
2. 调整进程树的形态，通知正在等待子进程变成zombie状态的父进程
```c
    local_intr_save(intr_flag);
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc); // (如果有需要)通知exit的进程的父亲
        }
        while (current->cptr != NULL) { // 移除exit的进程的所有孩子
            proc = current->cptr;
            current->cptr = proc->optr;
    
            proc->yptr = NULL;
            if ((proc->optr = initproc->cptr) != NULL) {
                initproc->cptr->yptr = proc; // 把这些孩子归于initproc(即init_main)
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE) {
                if (initproc->wait_state == WT_CHILD) { // 
                    wakeup_proc(initproc); // (如果有需要)通知刚刚成为这些孩子的父亲的initproc
                }
            }
        }
    }
    local_intr_restore(intr_flag);
```

> 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？
> 
> 请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）

### 2. 系统调用的实现
有两个同名的`syscall`函数，一个位于用户空间，一个位于内核空间，前者的功能是收集参数，执行`int`进入内核态，后者的作用是处理真正处理系统调用。

无论是在内核态还是在用户态，为了发起系统调用都是把参数放到`edx ecx ebx edi esi`中，把系统调用号放到`eax`中，然后`int 0x80`。

产生中断后，进入`__vectors[0x80]`，接着进入`__alltraps`，接着进入`trap`，接着进入`trap_dispatch`，接着进入`syscall`(内核空间的)。

这里它负责从`tf`中取出调用方放在寄存器里的参数(已经被保存到`tf`中)，然后按照中断号来访问函数指针数组，调用具体的函数。