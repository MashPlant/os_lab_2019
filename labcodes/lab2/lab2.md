# Lab2 Report
# 李晨昊 2017011466
## 练习1：实现 first-fit 连续物理内存分配算法
### 1. 设计实现过程
总共有三个函数需要实现，原有的实现基本上都只有一些小错误，只需稍微修改即可
1. default_init_memmap

对代码的修改及部分代码的意义说明如下
```c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p)); // 传入本函数的空间原本都是被标记为reserved的
        p->flags = p->property = 0; // 清空非首页的flags(表示既不是reserved也不是free)和property
        set_page_ref(p, 0); // 标记所有页的的引用为0，对于首页的引用计数的设置由调用方完成
    }
    base->property = n;    
    SetPageProperty(base); // 标记首页的property，表示base->property有效，可以用于分配
    nr_free += n;
-   list_add(&free_list, &(base->page_link));
+   list_add_before(&free_list, &(base->page_link)); // 因为default_init_memmap的调用者是按照base递增的顺序调用default_init_memmap，所以这里为了保证有序性，应该把base加入到链表的最后
}
```
实际上调试时发现default_init_memmap只被调用了一次，因此对于本次lab来说，最后一行是`list_add`还是`list_add_before`对结果并没有影响。

2. default_alloc_pages
   
对代码的修改及部分代码的意义说明如下
```c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        list_del(&(page->page_link));
        if (page->property > n) {
            struct Page *p = page + n;
+           SetPageProperty(p); // 标记分裂出的首页为可用
            p->property = page->property - n;
-           list_add(&free_list, &(p->page_link));
+           list_add_before(page->page_link.next, &(p->page_link)); // 把分裂出的空间的首页添加到原首页的后继的前面，再配合上之前的list_del，相当于取代了原首页在链表中的位置
        }
        nr_free -= n;
        ClearPageProperty(page); // 标记原首页的flag的property位为0，表示已分配
    }
    return page;
}
```
3. default_free_pages

对代码的修改及部分代码的意义说明如下
```c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        le = list_next(le); // 这里le一定要提前设置，因为后面对链表的操作会改变le->next
        if (base + base->property == p) { // 尝试和右边的节点合并
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base) { // 尝试和左边的节点合并
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
-   list_add(&free_list, &(base->page_link));
+   if (base < le2page(list_next(&free_list), page_link)) { // base的地址是否最小?若最小应作为链表头
+       list_add_after(&free_list, &(base->page_link));
+   } else if (base > le2page(list_prev(&free_list), page_link)) { // base的地址是否最大?若最大应作为链表尾
+       list_add_before(&free_list, &(base->page_link));
+   } else {
+       le = list_next(&free_list);
+       while ((le = list_next(le)) != &free_list) { // 若既非最大也非最小，则应该在两个地址之间，找到它应有的位置并插入进去
+           struct Page *p = le2page(le, page_link);
+           if (p < base && base < le2page(list_next(le), page_link)) {
+               list_add_after(&(p->page_link), &(base->page_link));
+               break;
+           }
+       }
+   }
}
```

### 2. 你的first fit算法是否有进一步的改进空间
可以用以地址为键的平衡树来代替有序链表，这样内存的释放可以在$O(\log (page\_num)))$时间内完成

在此基础上可以再加一棵以空间大小为键的平衡树，这样内存的申请也可以在$O(\log (page\_num)))$时间内完成

## 练习2：实现寻找虚拟地址对应的页表项
### 1. 设计实现过程
基本上按照代码中的注释编写即可，代码如下
```c
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
1   pde_t *pdep = &pgdir[PDX(la)];                   // (1) find page directory entry
2   if (!(*pdep & PTE_P)) {                          // (2) check if entry is not present
3       if (!create) { return NULL; }                // (3) check if creating is needed
4       struct Page *page = alloc_page();            // then alloc page for page table CAUTION: this page is used for page table, not for common data page
5       set_page_ref(page, 1);                       // (4) set page reference
6       uintptr_t pa = page2pa(page);                // (5) get linear address of page
7       memset(KADDR(pa), 0, PGSIZE);                // (6) clear page content using memset
8       *pdep = pa & ~0xFFF | PTE_P | PTE_W | PTE_U; // (7) set page directory entry's permission
9   }
10   pte_t *pt = (pte_t *) KADDR(*pdep & ~0xFFF);
11   return &pt[PTX(la)];                             // (8) return page table entry
}
```
一些分析如下

1. 所有的地址访问(operator *, [])都必须是对于虚拟地址的访问；或者说在正常的使用方法下，所有的指针指向的都是虚拟地址；页目录项和页表项中保存的都是物理地址(和一些权限信息)，页目录项和页表项的组成在下面分析
2. pgdir指向页目录表的首地址，因此可以用pgdir[PDX(la)]表示la对应的页目录项
3. page本身并不是申请得到的页的虚拟地址，对应关系是页的首地址 = KADDR(page2pa(page))，展开之(忽略了检查)即是(page - pages) * PGSIZE + 0xC0000000，可以看出page的地址与页的地址间是一个缩放的关系，缩放后再加上固定的偏移0xC0000000
4. pt实际上就是if里面的KADDR(pa)，它指向页表的首地址，因此可以用pt[PTX(la)]表示la在该页表中对应的页表项

### 2. 请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中每个组成部分的含义以及对ucore而言的潜在用处
完整的页目录项和页表项如下

![](pde.png)
![](pte.png)

本次实验只关心如下部分

1. 页目录项内容 = (页表起始物理地址 & ~0x0FFF) | PTE_U | PTE_W | PTE_P

即页目录项的高20位表示一个页对齐的地址，这地址是它指向的页表的物理地址，低3位从低到高分别用于表示是否存在，是否可写，是否可在用户态使用。

2. 页表项内容 = (pa & ~0x0FFF) | PTE_P | PTE_W

即页表项的高20位表示一个页对齐的地址，这地址是它指向的页帧的物理地址，低2位从低到高分别用于表示是否存在，是否可写。

以下分析其余的一些有用的位

1. PWT：page级的write-through标志位。为1时使用write-through的cache(对cache的修改立即写回内存)；为0时使用write-back的cache(对cache的修改在cache失效时写回内存)。这可能关系到ucore的在处理并发程序时的策略。
2. A：访问位。该位由硬件设置，用来指示此表项所指向的页是否已被访问(读或写)。这可以为ucore提供该page的使用情况，用于页替换算法中提供依据。
3. D：脏位。该位由硬件设置，用来指示此表项所指向的页是否写过数据。这可以指示ucore是否在把页换出时需要把它写入硬盘。

### 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情
如果是一个缺页异常，那么会用cr2保存触发异常的线性地址，然后在栈中依次压入`(ss esp) eflags cs eip error_code`，然后跳转到缺页异常对应的isr(是`__vectors[14]`)执行，后面发生的都由软件处理，但是这一阶段的ucore并没有处理缺页异常。

## 练习3：释放某虚地址所在的页并取消对应二级页表项的映射
### 1. 设计实现过程
基本上按照代码中的注释编写即可，代码如下
```c
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    if (*ptep & PTE_P) {                     //(1) check if this page table entry is present
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
        if (page_ref_dec(page) == 0) {       //(3) decrease page reference
          free_page(page);                   //(4) and free this page when page reference reachs 0
        }
        *ptep &= ~PTE_P;                     //(5) clear second page table entry
        tlb_invalidate(pgdir, la);           //(6) flush tlb
    }
}
```
一些分析如下
1. (3)(4)两步是减少引用计数，并且视引用计数是否减为0来决定是否释放页帧，这很像基于引用计数的gc
2. (5)指示我clear pte，感觉clear本身表意不太明确，我认为如果使用正常的话，只要标记本页不存在即可，不把`*ptep`设成0也没有关系

### 2. 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥
1. 一个页目录表/一个页表都是申请得到的一个Page，其中包含4096 / 4 = 1024个页目录项/页表项
2. 一个页目录项/页表项的高20位指向一个页对齐的物理地址，这些地址都是通过申请Page得到的，地址的内容分别为一个页表/一个页帧

### 3. 如果希望虚拟地址与物理地址相等，则需要如何修改lab2？
1. 将`kernel.ld`中的0xC0100000改为0x100000
2. 将宏`KERNBASE`定义为0
