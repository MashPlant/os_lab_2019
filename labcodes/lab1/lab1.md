# Lab1 Report
# 李晨昊 2017011466 

## 练习1：理解通过make生成执行文件的过程
### 1. 操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
查看makefile中ucore.img的依赖
```
  $(UCOREIMG): $(kernel) $(bootblock)
  $(V)dd if=/dev/zero of=$@ count=10000
  $(V)dd if=$(bootblock) of=$@ conv=notrunc
  $(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
```
可见ucore.img依赖于kernel和bootblock；这二者生成后，用dd命令先创建一个块数目为10000，每个块大小为512字节的ucore.img文件，然后将bootblock拷贝到它的第一个块，讲kernel拷贝到它的后续的块(跳过了第一个块)
1. kernel

分为编译和链接两个过程，编译过程分别调用gcc编译了kern文件夹下的.c和.S文件，使用了一些不常见的编译选项`-fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc -fno-stack-protector`
   - `-fno-builtin`没有查到gcc的文档...只查到了clang的文档，"Disable implicit builtin knowledge of functions"，意思应该是禁止隐式地调用builtin函数/指令(来优化)
   - `-m32`编译产物兼容32位，这是因为intel 80386机器为32位机器(我比较意外除此以外就不用再指定其他与架构相关的信息了，看来intel的向下兼容的确做的很好)
   - `-gstabs`生成stabs格式的调试信息
   - `-nostdinc`不使用C标准库，这可能是因为C标准库内包含很多系统调用，目前的os基本都还没有实现；我们的os中自己写了一部分C标准库的函数以供使用
   - `-fno-stack-protector`不在栈上放置额外的保护信息(它们可以用来检查栈内存访问越界)，这可能是因为lab1中需要打印函数的堆栈信息，额外的保护信息可能使得函数堆栈发生变化
    
链接过程就是把以上生成的.o文件链接成kernel文件，使用了链接选项`-m elf_i386 -nostdlib -T tools/kernel.ld`
   - `-m elf_i386`生成elf_i386格式的可执行文件
   - `nostdlib`不链接C标准库
   - `-T tools/kernel.ld`使用链接脚本kernel.ld

2. bootblock

分为编译，链接，签名三个部分。编译即把bootasm.S和bootmain.c编译成对应的.o文件，链接即把这两个.o文件链接成bootblock.o。
    
签名需先调用`objcopy -S -O binary obj/bootblock.o obj/bootblock.out`拷贝二进制代码bootblock.o到bootblock.out。其中`-S`意义为移除符号和重定位信息，`-O binary`意义为输出二进制个数。我认为这个过程的作用类似与对bootblock.o的链接，使其成为可执行文件。

然后编译链接工具sign，然后使用sign校验bootblock.out并在输出文件的511，512两个字节上写入0x55AA，从而使其成为符合规范的主引导扇区。
   
### 2. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？
符合规范的硬盘主引导扇区指的是大小为512bytes，且最后两个字节为0x55AA的一个硬盘扇区。

对于sign工具来说，只要求可执行文件的大小不大于510bytes，它就可以被装入硬盘主引导扇区(不同于课上讲的446bytes，因为ucore的bootloader不包含分区信息，可以使用除了最后两个字节之外的所有字节)；在511，512两个字节加上0x55AA后，它就是一个符合规范的硬盘主引导扇区。

当然，“符合规范”的硬盘主引导扇区不一定就是“合格”的硬盘主引导扇区。运行时，“合格”的硬盘主引导扇区还应该能正确地执行加载os等工作，但是这在运行前并没有被验证过。

## 练习2. 使用qemu执行并调试lab1中的软件
### 1. 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。
将gdbinit文件修改成 
```
  set architecture i8086 # 将gdb状态设置为i8086实模式，符合BIOS执行状态
  target remote :1234
```
然后执行`make debug-nox`，这时gdb停在CPU执行的的第一条指令处，输入`x /2i 0xffff0`，即查看BIOS的前的两条指令，输出如下
```
  0xffff0:     ljmp   $0x3630,$0xf000e05b
  0xffff7:     das  
```

### 2. 在初始化位置0x7c00设置实地址断点,测试断点正常。& 3. 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。
将gdbinit文件修改成 
```
set architecture i8086 # 将gdb状态设置为i8086实模式，符合bootloader一开始的执行状态
target remote :1234
b *0x7c00
c
```
然后执行`make debug-nox`，在gdb界面下输入`x /20i $pc`，即查看当前指令处的20条指令，输出如下
```
=> 0x7c00:      cli    
   0x7c01:      cld    
   0x7c02:      xor    %eax,%eax
   0x7c04:      mov    %eax,%ds
   0x7c06:      mov    %eax,%es
   0x7c08:      mov    %eax,%ss
   0x7c0a:      in     $0x64,%al
   0x7c0c:      test   $0x2,%al
   0x7c0e:      jne    0x7c0a
   0x7c10:      mov    $0xd1,%al
   0x7c12:      out    %al,$0x64
   0x7c14:      in     $0x64,%al
   0x7c16:      test   $0x2,%al
   0x7c18:      jne    0x7c14
   0x7c1a:      mov    $0xdf,%al
   0x7c1c:      out    %al,$0x60
   0x7c1e:      lgdtl  (%esi)
   0x7c21:      insb   (%dx),%es:(%edi)
   0x7c22:      jl     0x7c33
   0x7c24:      and    %al,%al
```
可见这一段汇编代码与bootasm.S中的代码在语义上是相同的(区别仅在于mov和movw之类的)

### 4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。
我找了函数cga_init，我选它原因是之前我的环境没有设置好的时候总是在这个地方segment fault...

将gdbinit文件修改成 
```
file bin/kernel
target remote :1234
b cga_init
c
```
然后执行`make debug`，即可在函数cga_init处停下
```c
1 static void
2 cga_init(void) {
3     volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
4     uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
5     *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
6     if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
7        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
8        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
9     } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
10        *cp = was;                                                      //还原原来显存位置的值
11        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
12    }
13
14    // Extract cursor location
15    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
16    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
17    // 6845 reg 15 : Cursor Address (Low Byte)
18    uint32_t pos;
19    outb(addr_6845, 14);                                        
20    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
21    outb(addr_6845, 15);
22    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
23
24    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
25    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
26 }
```
第3-6行尝试往CGA端口中写一个数并读出，这里的`volatile`指示编译器不要优化掉第6行的内存读取，虽然调试时发现代码还是进入了第10行的分支(并没有发生违反直觉的事情)。

查看从第5行开始的一段汇编得到
```
=> 0x100e32 <cga_init+23>:      mov    -0x4(%ebp),%eax
   0x100e35 <cga_init+26>:      movw   $0xa55a,(%eax)
   0x100e3a <cga_init+31>:      mov    -0x4(%ebp),%eax
   0x100e3d <cga_init+34>:      movzwl (%eax),%eax
   0x100e40 <cga_init+37>:      cmp    $0xa55a,%ax
   0x100e44 <cga_init+41>:      je     0x100e58 <cga_init+61>
   0x100e46 <cga_init+43>:      movl   $0xb0000,-0x4(%ebp)
```
从cmp和je可以看出第6行的内存读取的确没有被优化掉。

我尝试了去掉volatile并且在编译选项中加入`-Og`，得到的cga_init的前几行汇编如下
```
=> 0x100a2c <cga_init>:         push   %esi
   0x100a2d <cga_init+1>:       push   %ebx
   0x100a2e <cga_init+2>:       movw   $0x3d4,0x10ddcc
   0x100a37 <cga_init+11>:      mov    $0x3d4,%ebx
   0x100a3c <cga_init+16>:      mov    $0xe,%eax
   0x100a41 <cga_init+21>:      mov    %ebx,%edx
   0x100a43 <cga_init+23>:      out    %al,(%dx)
```
可见已经失去了原来的语义，而一个程序正确与否显然不应该依赖于优化选项，因此看出这个volatile是很有必要的。

## 练习3. 分析bootloader进入保护模式的过程
进入保护模式分为四个步骤，在汇编代码(bootasm.S中)中体现如下
```
    # Step1: 开启A20
seta20.1:
    inb $0x64, %al                                 
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 
    outb %al, $0x64  # 将0xd1发送到0x64端口，d1的意思是向8042端口的P2写数据                            

seta20.2:
    inb $0x64, %al                                 
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                
    outb %al, $0x60  # 将0xdf发送到0x60端口，df为11011111，A20位置1，开通A20线                       

    # Step2: 初始化GDT表
    lgdt gdtdesc
    # Step3: 将cr0寄存器PE位置1
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Step4: 长跳转更新cs基地址
    ljmp $PROT_MODE_CSEG, $protcseg
```
### 1. 为何开启A20，以及如何开启A20
为何开启A20：这涉及到历史原因，目前的情况是在开启A20之前，当寻址到超过1MB的内存时会发生“回卷”，需要开启A20才能正确访问超过1MB的地址空间。

如何开启A20：需要通过向键盘控制器8042发送一个命令来完成。键盘控制器8042将会将它的的某个输出引脚的输出置高电平，作为A20地址线控制的输入。因为还要考虑到键盘缓冲区中是否有内容，键盘控制器是否已准备好等情况，所以汇编代码比较复杂。其流程为
1. 等待，直到8042 Input buffer为空为止
2. 发送Write 8042 Output Port命令到8042 Input buffer
3. 等待，直到8042 Input buffer为空为止
4. 向P2写入数据，将OR2置1
  
### 2. 如何初始化GDT表
调用指令`lgdt gdtdesc`

### 3. 如何使能和进入保护模式
通过
```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax 
    movl %eax, %cr0
```
将cr0寄存器PE位置1，从而开启保护模式

我在网上查阅了一些资料，也许可以加深对这一段代码的理解，这里摘录如下
```
1.实模式下的寻址方式
  cs << 4 + ip
2.保护模式下的寻址方式
  base(index(cs)) + eip

Q：当打开cr0的PE位的瞬间，处理器进入保护模式，寻址方式改变。此时cs的值并没有改变，并且打开cr0瞬间处理器对cs的解释方式完全不一样，如何确保在进入保护模式后下一条指令被顺利执行？

A：段寄存器后面都有隐藏的高速缓冲寄存器(不管是在实模式还是在保护模式下，CPU都会把一个分段的基地址放在一组隐藏的寄存器中，这组隐藏的寄存器对程序员是不可见的，这组隐藏的寄存器叫做描述符高速缓存寄存器(Descriptor Cache Registers))，当cs寄存器值被更新时，这个高速缓冲寄存器的值会根据当时的寻址方式更新，比如实模式下就是cs<<4后放入高速缓冲寄存器，等需要取指令的时候就直接取高速缓冲寄存器的值与eip相加即可，并不会真的再去cs段寄存器找这个值然后做像保护模式下的寻址方式那样推导。这样就解释了上面的情况，虽然寻址方式改变了，但是cs段寄存器的值没变，高速缓冲寄存器的值就不会变，基址仍然是实模式时的值，从而实际上计算出来的还是实模式的地址，保证了指令流的持续执行。内核在等到切换准备就绪的时候就会执行一个长跳转指令来刷新cs段寄存器的值，从而真的跳转到保护模式下了。
```

## 练习4. 分析bootloader加载ELF格式的OS的过程
### 1. bootloader如何读取硬盘扇区的？
查看实验指导书得知硬盘读取是通过CPU访问硬盘的IO地址寄存器完成，各个端口的意义如下
```
0x1f0	读数据，当0x1f7不为忙状态时，可以读。
0x1f2	要读写的扇区数，每次读写前，你需要表明你要读写几个扇区。最小是1个扇区
0x1f3	如果是LBA模式，就是LBA参数的0-7位
0x1f4	如果是LBA模式，就是LBA参数的8-15位
0x1f5	如果是LBA模式，就是LBA参数的16-23位
0x1f6	第0~3位：如果是LBA模式就是24-27位 第4位：为0主盘；为1从盘
0x1f7	状态和命令寄存器。操作时先给命令，再读取，如果不是忙状态就从0x1f0端口读数据
```
下面分别分析每个函数工作原理

```c
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}
```
waitdisk函数检查0x1F7端口是否为忙，直到不忙时即退出
```c
static void
readsect(void *dst, uint32_t secno) {
    waitdisk();

    outb(0x1F2, 1);                         // 设置读取扇区的数目为1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);      // 以上三行把secno的低位三个byte分别写入三个端口
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);  // & 0xF是把第4位置为0，表示从主盘读取，| 0xE0是把[5， 7]位置成1
    outb(0x1F7, 0x20);                      // 0x20命令，读取扇区

    waitdisk();

    insl(0x1F0, dst, SECTSIZE / 4);
}
```
readsect从设备的第secno扇区读取数据到dst位置，它先等待硬盘不忙，然后往各个端口写入带读取的扇区的信息，最后调用insl读取数据
```c
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    va -= offset % SECTSIZE;

    uint32_t secno = (offset / SECTSIZE) + 1; // 第0扇区为bootloader，需从第1扇区开始计数  

    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```
readseg从硬盘的offset处读取连续的count个字节放入地址va处；代码中考虑了offset不是扇区大小的整数倍的情况，这在加载os的时候其实没有用到。

### 2. bootloader是如何加载ELF格式的OS？
```c
void
bootmain(void) {
    // 读取ELF的头部，实际上需要读取的内容大于sizeof(elfhdr)(但还是都读取到了指针ELFHDR处)，这从ph指针的行为可以看出
    // 这个技巧与柔性数组原理一样，在C编程中还是比较常见的
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // 检查magic number，判断是否合法
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph; // eph = end of ph

    // e_phoff = file position of program header or 0
    // e_phnum = number of entries in program header or 0
    // 这样ph即指向第一个program的头部，eph即指向最后一个program的头部的下一个位置
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;

    // p_va = virtual address to map segment
    // 分别读入每个program到各自的地址
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // 这一跳会转到init.c中的kern_init函数，这个函数永远不会返回
    // 似乎可以在函数指针的类型中加入noreturn之类的来帮助编译器优化
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);
    while (1);
}
```
在bootmain函数中先从offset=0处(实际为第一个扇区)读取SECTSIZE * 8个字节到一个硬编码的地址ELFHDR中，然后从ELFHDR中提取程序的信息，分别读入每个程序，最后跳转到内核代码执行。

## 练习5. 实现函数调用堆栈跟踪函数
### 1. 简要说明实现过程 
基本上将kdebug.c中的注释翻译成c代码即可
```c
uint32_t ebp = read_ebp();
uint32_t eip = read_eip(); // next inst to exec
int i, j;
for (i = 0; i < STACKFRAME_DEPTH && ebp; ++i) {
    uint32_t *ptr = (uint32_t *)ebp;
    cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
    cprintf("args:");
    // stack: grow <---- low address  <----  high address
    // [caller ebp, caller eip, arg0, arg1, arg2, arg3, arg...] 
    for (j = 2; j < 6; ++j) {
        cprintf("0x%08x ", ptr[j]);
    }
    cprintf("\n");
    print_debuginfo(eip - 1);
    eip = ptr[1];
    ebp = ptr[0];
}
```
(本平台下)c函数的调用约定是，调用方将参数从右向左进栈，然后调用call，call基本相当于`push eip + jmp func`；之后被调方调用`push ebp + mov esp -> ebp`

根据调用约定，我在注释中标注出了我设想的栈的样子

之所以可以以ebp==0作为循环终止条件，是因为bootasm.S中的
```
  movl $0x0, %ebp
  movl $start, %esp
  call bootmain
```
这样bootasm在`push ebp`的时候就会把push 0到栈上

### 2. 解释最后一行各个数值的含义
最后一行为
```
ebp:0x00007bf8 eip:0x00007d68 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d67 --
```
这实际上是bootmain函数，但是bootmain函数属于bootblock中，查找不到它的符号信息，因此print_debuginfo输出了`<unknown>`

查看bootmain实际运行时调用kern_init附近的汇编
```
0x7d5c:      mov    0x10018,%eax
0x7d61:      and    $0xffffff,%eax
0x7d66:      call   *%eax
0x7d68:      mov    $0xffff8a00,%edx
```
gdb中输入`info all-register`，查看ebp的数值，得到`ebp  0x7bf8`

至此可以对各个数字解释如下
1. ebp是bootmain的ebp
2. eip是指令`0x7d68:      mov    $0xffff8a00,%edx`
3. 这次函数调用并没有传入任何参数，因此输出的args可能是原来栈上的变量
4. 0x00007d67是eip-1

## 练习6. 完善中断初始化和处理
### 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

一个中断描述符占用8bytes(64bits)，其中[16, 31]bit是段选择子，[0, 15]字节和[48, 63]字节拼成位移，利用段选择子和段内位移便得到中断处理程序的入口地址。

## 扩展练习 Challenge 1. 增加一用户态函数，当内核初始完毕后，可从内核态返回到用户态的函数，而用户态的函数又通过系统调用得到内核态的服务
任务的本质在于
1. 从内核态主动切换到用户态
2. 从用户态切换到内核态，并留在内核态

首先记录一下我对`struct trapframe`的填充过程的分析。注意由于栈是从上往下生长的，而结构体中成员的地址是递增的，所以结构体的填充是从后往前的
1. 产生中断，硬件负责依次填写`ss esp eflags cs eip`(u2k)或者`eflags cs eip`(k2k)
2. 进入isr，即__vector0~255，它们负责依次填写`err trapno`，其中err大部分都是0，代表没有错误；trapno都是此vector的下标
3. vector调用__alltraps，它先依次填写`ds es fs gs`，再调用`pushal`依次填写`eax, ecx, edx, ebx, original esp, ebp, esi, edi`

至此，整个`struct trapframe`从后往前填充完毕，栈顶指针指向它的首地址，用C来表示就是`&tf.tf_regs.reg_edi`，执行`push esp, call trap`就把`struct trapframe`的首地址作为参数，调用了函数`trap`。

`trap`返回之后，执行了一行`popl %esp`，这是不太正常的，如果是普通的函数，这里可能是`add $4, %esp`之类的来除掉栈上的`tf`参数，但是这里是**把`tf`指向的地址作为了新的栈**，一般而言tf作为函数参数是不会被函数内部改变的，但是利用上面的分析容易知道，对`((uint32_t *)tf)[-1]`的访问即是对`tf`的访问，所以在函数内部是可以修改`tf`的，如果把它设置为新的栈的位置，那么`popl %esp`就会把栈设置成新的栈。

之后，假定这个栈上也有一个`struct trapframe`，此时执行
```asm
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds
```
就把它保存的信息依次恢复到了对应寄存器中。

^^^^^^^注：以上修改`((uint32_t *)tf)[-1]`的做法思路来自于答案，最后并没有用到^^^^^^^

原先我认为从`lab1_switch_test`中内核态切换到用户态后是执行在了一个不同的栈上，经过和助教的交流我理解了实际上除了`lab1_switch_to_kernel`外都没有切换栈，`lab1_switch_to_kernel`也只是临时地切换到了`pmm.c::stack0`中的栈上，之后又回到`lab1_switch_test`的函数栈上了。

下面讲实现思路
1. 从内核态主动切换到用户态
思路是用内核态模拟一次用户态的中断，于是在`iret`之后就会进入用户态。

由于这里是在内核态发生中断，因此硬件不会压入`ss esp`，为了模拟用户态的行为，在产生中断之前先手动压入用户态的`ss`和`esp`，这个压入的`esp`就是isr结束之后的`esp`用于恢复的值，我们希望它就是本函数的`ebp`(因为这个函数没有栈上变量)，所以压入`esp`对应于`pushl %%ebp`。

然后在内核态执行一次`int T_SWITCH_TOU`，在`trap_dispatch`中将`tf`的`cs ds es`修改为user状态的段寄存器即可，无需修改`ss esp`，因为中断之前已经做了处理。除此之外，为了能正确输出还要设置`tf`的IO优先级，这一句代码参考了答案。

代码如下
```c
static void
lab1_switch_to_user(void) {
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
        "pushl %0\n\t"
        "pushl %%ebp\n\t"
	    "int %1\n\t"
	    :: "i"(USER_DS), "i"(T_SWITCH_TOU)
	);
}

static void
trap_dispatch(struct trapframe *tf) {
...
    case T_SWITCH_TOU: {
        tf->tf_cs = USER_CS;
        tf->tf_ds = tf->tf_es = /* tf->tf_ss = already set in init.c::lab1_switch_to_user */ USER_DS;
        tf->tf_eflags |= FL_IOPL_MASK;
        break;
    }
...
}
```

1. 从用户态切换到内核态，并留在内核态
首先需要设置一个用户态可以使用的中断，然后在内核态执行一次`int T_SWITCH_TOK`，在`trap_dispatch`中将`tf`的`cs ds es ss`修改为kernel状态的段寄存器，再恢复`tf`的IO优先级即可。

从中断返回后，此时的`esp`仍然在`TSS`指定的内核栈上(`kern_init`的函数栈和`pmm.c::stack0`都是内核栈，后者被`TSS`设置为了处理中断的栈)。此时同1之理，只需要`movl %%ebp, %%esp`即可正确设置`esp`。

代码如下
```c
void
idt_init(void) {
...
    // for challenge 1 step2(from use to kernel), allow DPL_USER use gate T_SWITCH_TOK
    // this gate is a trap
    // 出错（fault）保存的EIP指向触发异常的那条指令；而陷入（trap）保存的EIP指向触发异常的那条指令的下一条指令。因此，当从异常返回时，出错（fault）会重新执行那条指令；而陷入（trap）就不会重新执行
    SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
...
}

static void
lab1_switch_to_kernel(void) {
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    :: "i"(T_SWITCH_TOK)
	);
}

static void
trap_dispatch(struct trapframe *tf) {
...
    case T_SWITCH_TOK: {
        tf->tf_cs = KERNEL_CS;
        tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    }
...
}
```
