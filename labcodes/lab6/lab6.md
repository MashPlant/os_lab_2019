# Lab6 Report
## 李晨昊 2017011466
## 练习1: 使用 Round Robin 调度算法
> 完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件）个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。执行make grade，大部分测试用例应该通过。但执行priority.c应该过不去。

## 1. 理解并分析sched_class中各个函数指针的用法，并结合Round Robin 调度算法描ucore的调度执行过程
## 2. 简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计

## 练习2: 实现 Stride Scheduling 调度算法
> 首先需要换掉RR调度器的实现，即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride度器的相关描述，完成Stride调度算法的实现。

## 1. 设计实现过程