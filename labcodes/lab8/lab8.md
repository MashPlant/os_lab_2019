# Lab8 Report
## 李晨昊 2017011466

## 练习1: 完成读文件操作的实现
> 首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，编写在sfs_inode.c中sfs_io_nolock读文件中数据的实现代码

### Q1. 设计实现思路
代码如下：
```c
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
...
    uint32_t nblks = (endpos - 1) / SFS_BLKSIZE - blkno; // 我修改了nblks的定义，比较方便我后面处理
    alen = endpos - offset; // (为了简化)假定读取都是成功的，这样alen就是需要读取的总长度
    if (nblks == 0) { // 全在一个块中，直接操作这个块的一部分；如果这一部分不分开处理，按照下面的逻辑会对这个块操作两次
        sfs_bmap_load_nolock(sfs, sin, blkno, &ino);
        sfs_buf_op(sfs, buf, endpos - offset, ino, offset - blkno * SFS_BLKSIZE);
    } else { // 至少在两个块中
        // 操作函数中的blkno实际上都是inode编号，与上面的变量blkno并不相等，需要sfs_bmap_load_nolock读出某个block到底是哪个inode
        // 操作起始块
        sfs_bmap_load_nolock(sfs, sin, blkno, &ino);
        sfs_buf_op(sfs, buf, (blkno + 1) * SFS_BLKSIZE - offset, ino, offset - blkno * SFS_BLKSIZE);
        buf += (blkno + 1) * SFS_BLKSIZE - offset;
        // 操作中间块
        uint32_t i;
        for (i = 1; i < nblks; ++i) {
            sfs_bmap_load_nolock(sfs, sin, blkno + i, &ino);
            // 1是块数目，因为这些inode都(可能)是离散分布的，所以一次只能操作一个块
            sfs_block_op(sfs, buf, ino, 1);
            buf += SFS_BLKSIZE;
        }
        // 操作末尾块
        sfs_bmap_load_nolock(sfs, sin, blkno + nblks, &ino);
        sfs_buf_op(sfs, buf, endpos - (blkno + nblks) * SFS_BLKSIZE, ino, 0);
    }
...
}
```
这段代码其实很像以前做题时碰到的分块解法(其实本来也就是)，我比较习惯的写法就是这样：先判断是否只有一个块；对于多个块，分别操作第一个块，中间块和末尾块

这里简单记录一下我对`sfs`文件系统的理解：
1. 文件和文件夹的"内容"的位置(对于文件，内容是文件本身内容；对于文件夹，内容是一系列`sfs_disk_entry`)都记录在`sfs_disk_inode`中。对于文件夹，每个`sfs_disk_entry`都占用一个inode
2. `sfs_disk_inode`直接对应硬盘中的实体；`sfs_inode`是内存中的对应概念，在前者基础上增加了一些链接关系和标记便于管理
3. 虚拟文件系统的抽象是通过虚函数表+(tagged)union来实现的，一般来说在平时的编程中为了实现多态性，都只会使用二者之一，因此这样的实现给我造成了一些困扰

### Q2. 给出设计实现”UNIX的PIPE机制“的概要设方案
查阅资料如下：
```
管道是进程间通信的主要手段之一。一个管道实际上就是个只存在于内存中的文件，
对这个文件的操作要通过两个已经打开文件进行，它们分别代表管道的两端。
管道是一种特殊的文件，它不属于某一种文件系统，而是一种独立的文件系统，有其自己的数据结构。
根据管道的适用范围将其分为：无名管道和命名管道。

无名管道
主要用于父进程与子进程之间，或者两个兄弟进程之间。在linux系统中可以通过系统调用建立起一个单向的通信管道，且这种关系只能由父进程来建立。

命名管道
命名管道是建立在实际的磁盘介质或文件系统（而不是只存在于内存中）上有自己名字的文件，任何进程可以在任何时间通过文件名或路径名与该文件建立联系。为了实现命名管道，引入了一种新的文件类型——FIFO文件（遵循先进先出的原则）。
实现一个命名管道实际上就是实现一个FIFO文件。命名管道一旦建立，之后它的读、写以及关闭操作都与普通管道完全相同。虽然FIFO文件的inode节点在磁盘上，但是仅是一个节点而已，文件的数据还是存在于内存缓冲页面中，和普通管道相同。
```

据此可以看出管道的地位实际上是一个文件系统，因此需要实现文件系统的相关操作，本质上主要还是需要实现`fs_get_root`所返回的inode的操作，最关键的两个是
```c
    int (*vop_read)(struct inode *node, struct iobuf *iob);
    int (*vop_write)(struct inode *node, struct iobuf *iob);
```
具体实现很简单，只需要往内存中的缓冲区读写数据即可。根据具体的实现策略，在缓冲区空/满的时候可以有不同的表现。

## 练习2: 完成基于文件系统的执行程序机制的实现
> 改写proc.c中的load_icode函数和其他相关函数，实现基于文件系统的执行程序机制。执行：make qemu。如果能看看到sh用户程序的执行界面，则基本成功了。如果在sh用户界面上可以执行”ls”,”hello”等其他放置在sfs文件系统中的其他执行程序，则可以认为本实验基本成功

### Q1. 设计实现思路
`load_icode`中大部分代码(包括：elf文件的解析；程序的各个段的内存申请和在`mm`中的标记；程序栈空间的申请和在`mm`中的标记；加载新页表；设定用于跳转到用户态的`trapframe`)可以从之前的lab中复制来。需要自己实现的主要是两部分：
1. 从`fd`中读取文件数据

与之前不同，这里文件的大小不是已知的，我翻阅了一下`file.h`，发现`file_fstat`可以提供相关信息：
```c
    struct stat stat;
    file_fstat(fd, &stat);
    struct elfhdr *elf = kmalloc(stat.st_size); // 后面会释放的
    size_t _copied_store;
    file_read(fd, elf, stat.st_size, &_copied_store); // 读取整个文件
```
直接获取文件大小，把整个文件都读取进来，之后就可以和之前一样操作`elf`了

2. 在用户栈上建立好`argc`和`argv`

`argc`和`argv`直接放在用户栈顶就可以了(按照调用约定，应该把`argv`放在高地址，`argc`放在低地址)。但是`argv`指向的字符指针数组，以及每个字符串，都不能直接使用内核态的内存，也必须放到用户可以访问的地址里去。一个可行的实现是也把它们放在用户栈上：
```c
    // (6) setup uargc and uargv in user stacks
    // user stack: low | func para |                argv array |              argv content | highest 
    //                 | argc argv | argv[0]...argv[argc - 1]| | argv[0]...argv[argc - 1]| |
    int i, top = USTACKTOP;
    for (i = argc - 1; i >= 0; --i) { // argv content
        int len = strlen(kargv[i]) + 1; // 1 for '\0'
        top -= len;
        strcpy((char *)top, kargv[i]);
    }
    int top1 = USTACKTOP;
    for (i = argc - 1; i >= 0; --i) { // argv array
        int len = strlen(kargv[i]) + 1;
        top -= sizeof(char *);
        top1 -= len;
        *((char **) top) = (char *) top1;
    }
    // argv is handled in initcode.S !!!
    top -= sizeof(int);
    *((int *) top) = argc; // argc
```
其中大部分代码都很正常，但是对于`main`的参数`argv`的处理并不像我描述的一样，这里建立的结构其实是`argc argv[0] argv[1]`...，原因在于`initcode.S`发生了变化
```x86asm
_start:
    # set ebp for backtrace
    movl $0x0, %ebp

    # load argc and argv
    # 这两行负责把argc存入ebx
    # 把argv的起始地址存入ecx
    movl (%esp), %ebx
    lea 0x4(%esp), %ecx


    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp

    # save argc and argv on stack
    # 这里才把真正的argv和argc压入栈里
    pushl %ecx
    pushl %ebx

    # call user-program function
    call umain
1:  jmp 1b
```
但是，我只能解释为什么我要这样写，不能解释为什么`initcode.S`要这样写。调试这个问题花费了我很多时间。

我原来的写法还有两句：
```c
    top -= sizeof(char **);
    *((char ***) top) = (char **)(top + sizeof(char **));
```
如果`initcode.S`中不做`lea`这个额外的计算，而是
```x86asm
    movl (%esp), %ebx
    movl 0x4(%esp), %ecx
```
经我测试是可以正常运行的

### Q2. 给出设计实现基于”UNIX的硬链接和软链接机制“的概要设方案
1. 硬链接

一个硬链接只需要保存一个它指向的文件的inode编号。`sfs_disk_inode`中增添一个引用计数字段，创建这个文件时引用计数设为1，创建硬链接时需申请一个block来存放硬链接(这也许有点太浪费了，因为只需要一个整数而已，可以考虑直接把这个整数放在`sfs_disk_entry`里)，同时把它指向的文件inode的引用计数+1；删除文件和删除硬链接时，引用计数-1，引用计数为0时才能删除这个文件inode。

2. 软链接

一个软连接保存它指向文件的路径，创建软链接时无需修改文件，文件被删除时也无需考虑软连接。访问软链接时，如果无法按照其中指示的文件路径找到对应文件，os应把它标记为无效，也可以直接将它删除。