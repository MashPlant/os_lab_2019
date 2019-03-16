
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 73 2c 00 00       	call   102c9f <memset>

    cons_init();                // init the console
  10002c:	e8 4c 15 00 00       	call   10157d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100046:	e8 11 02 00 00       	call   10025c <cprintf>

    print_kerninfo();
  10004b:	e8 c3 08 00 00       	call   100913 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 0c 29 00 00       	call   102966 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 55 16 00 00       	call   1016b4 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 d9 17 00 00       	call   10183d <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 07 0d 00 00       	call   100d70 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 81 17 00 00       	call   1017ef <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 cc 0c 00 00       	call   100d5e <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 e1 34 10 00 	movl   $0x1034e1,(%esp)
  100132:	e8 25 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 ef 34 10 00 	movl   $0x1034ef,(%esp)
  100152:	e8 05 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 fd 34 10 00 	movl   $0x1034fd,(%esp)
  100172:	e8 e5 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 0b 35 10 00 	movl   $0x10350b,(%esp)
  100192:	e8 c5 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 19 35 10 00 	movl   $0x103519,(%esp)
  1001b2:	e8 a5 00 00 00       	call   10025c <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001e2:	e8 75 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001f8:	e8 5f 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10020f:	8b 45 08             	mov    0x8(%ebp),%eax
  100212:	89 04 24             	mov    %eax,(%esp)
  100215:	e8 8f 13 00 00       	call   1015a9 <cons_putc>
    (*cnt) ++;
  10021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021d:	8b 00                	mov    (%eax),%eax
  10021f:	8d 50 01             	lea    0x1(%eax),%edx
  100222:	8b 45 0c             	mov    0xc(%ebp),%eax
  100225:	89 10                	mov    %edx,(%eax)
}
  100227:	c9                   	leave  
  100228:	c3                   	ret    

00100229 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100229:	55                   	push   %ebp
  10022a:	89 e5                	mov    %esp,%ebp
  10022c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10022f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10023d:	8b 45 08             	mov    0x8(%ebp),%eax
  100240:	89 44 24 08          	mov    %eax,0x8(%esp)
  100244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 09 02 10 00 	movl   $0x100209,(%esp)
  100252:	e8 9a 2d 00 00       	call   102ff1 <vprintfmt>
    return cnt;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10025a:	c9                   	leave  
  10025b:	c3                   	ret    

0010025c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10025c:	55                   	push   %ebp
  10025d:	89 e5                	mov    %esp,%ebp
  10025f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100262:	8d 45 0c             	lea    0xc(%ebp),%eax
  100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026f:	8b 45 08             	mov    0x8(%ebp),%eax
  100272:	89 04 24             	mov    %eax,(%esp)
  100275:	e8 af ff ff ff       	call   100229 <vcprintf>
  10027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100280:	c9                   	leave  
  100281:	c3                   	ret    

00100282 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100282:	55                   	push   %ebp
  100283:	89 e5                	mov    %esp,%ebp
  100285:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100288:	8b 45 08             	mov    0x8(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 16 13 00 00       	call   1015a9 <cons_putc>
}
  100293:	c9                   	leave  
  100294:	c3                   	ret    

00100295 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100295:	55                   	push   %ebp
  100296:	89 e5                	mov    %esp,%ebp
  100298:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002a2:	eb 13                	jmp    1002b7 <cputs+0x22>
        cputch(c, &cnt);
  1002a4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002af:	89 04 24             	mov    %eax,(%esp)
  1002b2:	e8 52 ff ff ff       	call   100209 <cputch>
    while ((c = *str ++) != '\0') {
  1002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ba:	8d 50 01             	lea    0x1(%eax),%edx
  1002bd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002c0:	0f b6 00             	movzbl (%eax),%eax
  1002c3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002c6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ca:	75 d8                	jne    1002a4 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002da:	e8 2a ff ff ff       	call   100209 <cputch>
    return cnt;
  1002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002e4:	55                   	push   %ebp
  1002e5:	89 e5                	mov    %esp,%ebp
  1002e7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ea:	e8 e3 12 00 00       	call   1015d2 <cons_getc>
  1002ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002f6:	74 f2                	je     1002ea <getchar+0x6>
        /* do nothing */;
    return c;
  1002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002fb:	c9                   	leave  
  1002fc:	c3                   	ret    

001002fd <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002fd:	55                   	push   %ebp
  1002fe:	89 e5                	mov    %esp,%ebp
  100300:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100303:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100307:	74 13                	je     10031c <readline+0x1f>
        cprintf("%s", prompt);
  100309:	8b 45 08             	mov    0x8(%ebp),%eax
  10030c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100310:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  100317:	e8 40 ff ff ff       	call   10025c <cprintf>
    }
    int i = 0, c;
  10031c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100323:	e8 bc ff ff ff       	call   1002e4 <getchar>
  100328:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10032b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10032f:	79 07                	jns    100338 <readline+0x3b>
            return NULL;
  100331:	b8 00 00 00 00       	mov    $0x0,%eax
  100336:	eb 79                	jmp    1003b1 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100338:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10033c:	7e 28                	jle    100366 <readline+0x69>
  10033e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100345:	7f 1f                	jg     100366 <readline+0x69>
            cputchar(c);
  100347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034a:	89 04 24             	mov    %eax,(%esp)
  10034d:	e8 30 ff ff ff       	call   100282 <cputchar>
            buf[i ++] = c;
  100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100355:	8d 50 01             	lea    0x1(%eax),%edx
  100358:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10035b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10035e:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100364:	eb 46                	jmp    1003ac <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100366:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10036a:	75 17                	jne    100383 <readline+0x86>
  10036c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100370:	7e 11                	jle    100383 <readline+0x86>
            cputchar(c);
  100372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 05 ff ff ff       	call   100282 <cputchar>
            i --;
  10037d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100381:	eb 29                	jmp    1003ac <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100383:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100387:	74 06                	je     10038f <readline+0x92>
  100389:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038d:	75 1d                	jne    1003ac <readline+0xaf>
            cputchar(c);
  10038f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 e8 fe ff ff       	call   100282 <cputchar>
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xb4>
        }
    }
  1003ac:	e9 72 ff ff ff       	jmp    100323 <readline+0x26>
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	74 02                	je     1003c4 <__panic+0x11>
        goto panic_dead;
  1003c2:	eb 59                	jmp    10041d <__panic+0x6a>
    }
    is_panic = 1;
  1003c4:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003cb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ce:	8d 45 14             	lea    0x14(%ebp),%eax
  1003d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003db:	8b 45 08             	mov    0x8(%ebp),%eax
  1003de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e2:	c7 04 24 6a 35 10 00 	movl   $0x10356a,(%esp)
  1003e9:	e8 6e fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  1003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f8:	89 04 24             	mov    %eax,(%esp)
  1003fb:	e8 29 fe ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100400:	c7 04 24 86 35 10 00 	movl   $0x103586,(%esp)
  100407:	e8 50 fe ff ff       	call   10025c <cprintf>
    
    cprintf("stack trackback:\n");
  10040c:	c7 04 24 88 35 10 00 	movl   $0x103588,(%esp)
  100413:	e8 44 fe ff ff       	call   10025c <cprintf>
    print_stackframe();
  100418:	e8 40 06 00 00       	call   100a5d <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  10041d:	e8 d3 13 00 00       	call   1017f5 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100429:	e8 61 08 00 00       	call   100c8f <kmonitor>
    }
  10042e:	eb f2                	jmp    100422 <__panic+0x6f>

00100430 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100430:	55                   	push   %ebp
  100431:	89 e5                	mov    %esp,%ebp
  100433:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100436:	8d 45 14             	lea    0x14(%ebp),%eax
  100439:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10043f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100443:	8b 45 08             	mov    0x8(%ebp),%eax
  100446:	89 44 24 04          	mov    %eax,0x4(%esp)
  10044a:	c7 04 24 9a 35 10 00 	movl   $0x10359a,(%esp)
  100451:	e8 06 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  100456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100459:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045d:	8b 45 10             	mov    0x10(%ebp),%eax
  100460:	89 04 24             	mov    %eax,(%esp)
  100463:	e8 c1 fd ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100468:	c7 04 24 86 35 10 00 	movl   $0x103586,(%esp)
  10046f:	e8 e8 fd ff ff       	call   10025c <cprintf>
    va_end(ap);
}
  100474:	c9                   	leave  
  100475:	c3                   	ret    

00100476 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100476:	55                   	push   %ebp
  100477:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100479:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10047e:	5d                   	pop    %ebp
  10047f:	c3                   	ret    

00100480 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100480:	55                   	push   %ebp
  100481:	89 e5                	mov    %esp,%ebp
  100483:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 00                	mov    (%eax),%eax
  10048b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048e:	8b 45 10             	mov    0x10(%ebp),%eax
  100491:	8b 00                	mov    (%eax),%eax
  100493:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100496:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10049d:	e9 d2 00 00 00       	jmp    100574 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a8:	01 d0                	add    %edx,%eax
  1004aa:	89 c2                	mov    %eax,%edx
  1004ac:	c1 ea 1f             	shr    $0x1f,%edx
  1004af:	01 d0                	add    %edx,%eax
  1004b1:	d1 f8                	sar    %eax
  1004b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004bc:	eb 04                	jmp    1004c2 <stab_binsearch+0x42>
            m --;
  1004be:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c8:	7c 1f                	jl     1004e9 <stab_binsearch+0x69>
  1004ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cd:	89 d0                	mov    %edx,%eax
  1004cf:	01 c0                	add    %eax,%eax
  1004d1:	01 d0                	add    %edx,%eax
  1004d3:	c1 e0 02             	shl    $0x2,%eax
  1004d6:	89 c2                	mov    %eax,%edx
  1004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004db:	01 d0                	add    %edx,%eax
  1004dd:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e1:	0f b6 c0             	movzbl %al,%eax
  1004e4:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004e7:	75 d5                	jne    1004be <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ef:	7d 0b                	jge    1004fc <stab_binsearch+0x7c>
            l = true_m + 1;
  1004f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f4:	83 c0 01             	add    $0x1,%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004fa:	eb 78                	jmp    100574 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 d0                	mov    %edx,%eax
  100508:	01 c0                	add    %eax,%eax
  10050a:	01 d0                	add    %edx,%eax
  10050c:	c1 e0 02             	shl    $0x2,%eax
  10050f:	89 c2                	mov    %eax,%edx
  100511:	8b 45 08             	mov    0x8(%ebp),%eax
  100514:	01 d0                	add    %edx,%eax
  100516:	8b 40 08             	mov    0x8(%eax),%eax
  100519:	3b 45 18             	cmp    0x18(%ebp),%eax
  10051c:	73 13                	jae    100531 <stab_binsearch+0xb1>
            *region_left = m;
  10051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100524:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100529:	83 c0 01             	add    $0x1,%eax
  10052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052f:	eb 43                	jmp    100574 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100534:	89 d0                	mov    %edx,%eax
  100536:	01 c0                	add    %eax,%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	c1 e0 02             	shl    $0x2,%eax
  10053d:	89 c2                	mov    %eax,%edx
  10053f:	8b 45 08             	mov    0x8(%ebp),%eax
  100542:	01 d0                	add    %edx,%eax
  100544:	8b 40 08             	mov    0x8(%eax),%eax
  100547:	3b 45 18             	cmp    0x18(%ebp),%eax
  10054a:	76 16                	jbe    100562 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100552:	8b 45 10             	mov    0x10(%ebp),%eax
  100555:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055a:	83 e8 01             	sub    $0x1,%eax
  10055d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100560:	eb 12                	jmp    100574 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100568:	89 10                	mov    %edx,(%eax)
            l = m;
  10056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100570:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100577:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10057a:	0f 8e 22 ff ff ff    	jle    1004a2 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100584:	75 0f                	jne    100595 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100586:	8b 45 0c             	mov    0xc(%ebp),%eax
  100589:	8b 00                	mov    (%eax),%eax
  10058b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10058e:	8b 45 10             	mov    0x10(%ebp),%eax
  100591:	89 10                	mov    %edx,(%eax)
  100593:	eb 3f                	jmp    1005d4 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100595:	8b 45 10             	mov    0x10(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10059d:	eb 04                	jmp    1005a3 <stab_binsearch+0x123>
  10059f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a6:	8b 00                	mov    (%eax),%eax
  1005a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005ab:	7d 1f                	jge    1005cc <stab_binsearch+0x14c>
  1005ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b0:	89 d0                	mov    %edx,%eax
  1005b2:	01 c0                	add    %eax,%eax
  1005b4:	01 d0                	add    %edx,%eax
  1005b6:	c1 e0 02             	shl    $0x2,%eax
  1005b9:	89 c2                	mov    %eax,%edx
  1005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005be:	01 d0                	add    %edx,%eax
  1005c0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005c4:	0f b6 c0             	movzbl %al,%eax
  1005c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ca:	75 d3                	jne    10059f <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d2:	89 10                	mov    %edx,(%eax)
    }
}
  1005d4:	c9                   	leave  
  1005d5:	c3                   	ret    

001005d6 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d6:	55                   	push   %ebp
  1005d7:	89 e5                	mov    %esp,%ebp
  1005d9:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 00 b8 35 10 00    	movl   $0x1035b8,(%eax)
    info->eip_line = 0;
  1005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 08 b8 35 10 00 	movl   $0x1035b8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	8b 55 08             	mov    0x8(%ebp),%edx
  100609:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100616:	c7 45 f4 ec 3d 10 00 	movl   $0x103dec,-0xc(%ebp)
    stab_end = __STAB_END__;
  10061d:	c7 45 f0 44 b5 10 00 	movl   $0x10b544,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100624:	c7 45 ec 45 b5 10 00 	movl   $0x10b545,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10062b:	c7 45 e8 2f d5 10 00 	movl   $0x10d52f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100635:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100638:	76 0d                	jbe    100647 <debuginfo_eip+0x71>
  10063a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063d:	83 e8 01             	sub    $0x1,%eax
  100640:	0f b6 00             	movzbl (%eax),%eax
  100643:	84 c0                	test   %al,%al
  100645:	74 0a                	je     100651 <debuginfo_eip+0x7b>
        return -1;
  100647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10064c:	e9 c0 02 00 00       	jmp    100911 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100651:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065e:	29 c2                	sub    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	c1 f8 02             	sar    $0x2,%eax
  100665:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10066b:	83 e8 01             	sub    $0x1,%eax
  10066e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100671:	8b 45 08             	mov    0x8(%ebp),%eax
  100674:	89 44 24 10          	mov    %eax,0x10(%esp)
  100678:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10067f:	00 
  100680:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100683:	89 44 24 08          	mov    %eax,0x8(%esp)
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10068e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100691:	89 04 24             	mov    %eax,(%esp)
  100694:	e8 e7 fd ff ff       	call   100480 <stab_binsearch>
    if (lfile == 0)
  100699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069c:	85 c0                	test   %eax,%eax
  10069e:	75 0a                	jne    1006aa <debuginfo_eip+0xd4>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 67 02 00 00       	jmp    100911 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006bd:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006c4:	00 
  1006c5:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006cc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d6:	89 04 24             	mov    %eax,(%esp)
  1006d9:	e8 a2 fd ff ff       	call   100480 <stab_binsearch>

    if (lfun <= rfun) {
  1006de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006e4:	39 c2                	cmp    %eax,%edx
  1006e6:	7f 7c                	jg     100764 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	89 d0                	mov    %edx,%eax
  1006ef:	01 c0                	add    %eax,%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	c1 e0 02             	shl    $0x2,%eax
  1006f6:	89 c2                	mov    %eax,%edx
  1006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	8b 10                	mov    (%eax),%edx
  1006ff:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100705:	29 c1                	sub    %eax,%ecx
  100707:	89 c8                	mov    %ecx,%eax
  100709:	39 c2                	cmp    %eax,%edx
  10070b:	73 22                	jae    10072f <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10070d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	89 d0                	mov    %edx,%eax
  100714:	01 c0                	add    %eax,%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	c1 e0 02             	shl    $0x2,%eax
  10071b:	89 c2                	mov    %eax,%edx
  10071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100720:	01 d0                	add    %edx,%eax
  100722:	8b 10                	mov    (%eax),%edx
  100724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100727:	01 c2                	add    %eax,%edx
  100729:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072c:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10072f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	89 d0                	mov    %edx,%eax
  100736:	01 c0                	add    %eax,%eax
  100738:	01 d0                	add    %edx,%eax
  10073a:	c1 e0 02             	shl    $0x2,%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	8b 50 08             	mov    0x8(%eax),%edx
  100747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074a:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	8b 40 10             	mov    0x10(%eax),%eax
  100753:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10075c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100762:	eb 15                	jmp    100779 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100764:	8b 45 0c             	mov    0xc(%ebp),%eax
  100767:	8b 55 08             	mov    0x8(%ebp),%edx
  10076a:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10076d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100770:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100776:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100779:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077c:	8b 40 08             	mov    0x8(%eax),%eax
  10077f:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100786:	00 
  100787:	89 04 24             	mov    %eax,(%esp)
  10078a:	e8 84 23 00 00       	call   102b13 <strfind>
  10078f:	89 c2                	mov    %eax,%edx
  100791:	8b 45 0c             	mov    0xc(%ebp),%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	29 c2                	sub    %eax,%edx
  100799:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10079f:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007a6:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ad:	00 
  1007ae:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bf:	89 04 24             	mov    %eax,(%esp)
  1007c2:	e8 b9 fc ff ff       	call   100480 <stab_binsearch>
    if (lline <= rline) {
  1007c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007cd:	39 c2                	cmp    %eax,%edx
  1007cf:	7f 24                	jg     1007f5 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	89 d0                	mov    %edx,%eax
  1007d8:	01 c0                	add    %eax,%eax
  1007da:	01 d0                	add    %edx,%eax
  1007dc:	c1 e0 02             	shl    $0x2,%eax
  1007df:	89 c2                	mov    %eax,%edx
  1007e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ea:	0f b7 d0             	movzwl %ax,%edx
  1007ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f0:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f3:	eb 13                	jmp    100808 <debuginfo_eip+0x232>
        return -1;
  1007f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007fa:	e9 12 01 00 00       	jmp    100911 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	83 e8 01             	sub    $0x1,%eax
  100805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10080e:	39 c2                	cmp    %eax,%edx
  100810:	7c 56                	jl     100868 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100815:	89 c2                	mov    %eax,%edx
  100817:	89 d0                	mov    %edx,%eax
  100819:	01 c0                	add    %eax,%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	c1 e0 02             	shl    $0x2,%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082b:	3c 84                	cmp    $0x84,%al
  10082d:	74 39                	je     100868 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10082f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100832:	89 c2                	mov    %eax,%edx
  100834:	89 d0                	mov    %edx,%eax
  100836:	01 c0                	add    %eax,%eax
  100838:	01 d0                	add    %edx,%eax
  10083a:	c1 e0 02             	shl    $0x2,%eax
  10083d:	89 c2                	mov    %eax,%edx
  10083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100842:	01 d0                	add    %edx,%eax
  100844:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100848:	3c 64                	cmp    $0x64,%al
  10084a:	75 b3                	jne    1007ff <debuginfo_eip+0x229>
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	8b 40 08             	mov    0x8(%eax),%eax
  100864:	85 c0                	test   %eax,%eax
  100866:	74 97                	je     1007ff <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100868:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10086e:	39 c2                	cmp    %eax,%edx
  100870:	7c 46                	jl     1008b8 <debuginfo_eip+0x2e2>
  100872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100875:	89 c2                	mov    %eax,%edx
  100877:	89 d0                	mov    %edx,%eax
  100879:	01 c0                	add    %eax,%eax
  10087b:	01 d0                	add    %edx,%eax
  10087d:	c1 e0 02             	shl    $0x2,%eax
  100880:	89 c2                	mov    %eax,%edx
  100882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100885:	01 d0                	add    %edx,%eax
  100887:	8b 10                	mov    (%eax),%edx
  100889:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	29 c1                	sub    %eax,%ecx
  100891:	89 c8                	mov    %ecx,%eax
  100893:	39 c2                	cmp    %eax,%edx
  100895:	73 21                	jae    1008b8 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089a:	89 c2                	mov    %eax,%edx
  10089c:	89 d0                	mov    %edx,%eax
  10089e:	01 c0                	add    %eax,%eax
  1008a0:	01 d0                	add    %edx,%eax
  1008a2:	c1 e0 02             	shl    $0x2,%eax
  1008a5:	89 c2                	mov    %eax,%edx
  1008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	8b 10                	mov    (%eax),%edx
  1008ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b1:	01 c2                	add    %eax,%edx
  1008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008be:	39 c2                	cmp    %eax,%edx
  1008c0:	7d 4a                	jge    10090c <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c5:	83 c0 01             	add    $0x1,%eax
  1008c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cb:	eb 18                	jmp    1008e5 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d0:	8b 40 14             	mov    0x14(%eax),%eax
  1008d3:	8d 50 01             	lea    0x1(%eax),%edx
  1008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d9:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008df:	83 c0 01             	add    $0x1,%eax
  1008e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008eb:	39 c2                	cmp    %eax,%edx
  1008ed:	7d 1d                	jge    10090c <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	01 c0                	add    %eax,%eax
  1008f8:	01 d0                	add    %edx,%eax
  1008fa:	c1 e0 02             	shl    $0x2,%eax
  1008fd:	89 c2                	mov    %eax,%edx
  1008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100902:	01 d0                	add    %edx,%eax
  100904:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100908:	3c a0                	cmp    $0xa0,%al
  10090a:	74 c1                	je     1008cd <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10090c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100911:	c9                   	leave  
  100912:	c3                   	ret    

00100913 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100913:	55                   	push   %ebp
  100914:	89 e5                	mov    %esp,%ebp
  100916:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100919:	c7 04 24 c2 35 10 00 	movl   $0x1035c2,(%esp)
  100920:	e8 37 f9 ff ff       	call   10025c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100925:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092c:	00 
  10092d:	c7 04 24 db 35 10 00 	movl   $0x1035db,(%esp)
  100934:	e8 23 f9 ff ff       	call   10025c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100939:	c7 44 24 04 a9 34 10 	movl   $0x1034a9,0x4(%esp)
  100940:	00 
  100941:	c7 04 24 f3 35 10 00 	movl   $0x1035f3,(%esp)
  100948:	e8 0f f9 ff ff       	call   10025c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094d:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100954:	00 
  100955:	c7 04 24 0b 36 10 00 	movl   $0x10360b,(%esp)
  10095c:	e8 fb f8 ff ff       	call   10025c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100961:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  100968:	00 
  100969:	c7 04 24 23 36 10 00 	movl   $0x103623,(%esp)
  100970:	e8 e7 f8 ff ff       	call   10025c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100975:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  10097a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100980:	b8 00 00 10 00       	mov    $0x100000,%eax
  100985:	29 c2                	sub    %eax,%edx
  100987:	89 d0                	mov    %edx,%eax
  100989:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098f:	85 c0                	test   %eax,%eax
  100991:	0f 48 c2             	cmovs  %edx,%eax
  100994:	c1 f8 0a             	sar    $0xa,%eax
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 3c 36 10 00 	movl   $0x10363c,(%esp)
  1009a2:	e8 b5 f8 ff ff       	call   10025c <cprintf>
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 12 fc ff ff       	call   1005d6 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 66 36 10 00 	movl   $0x103666,(%esp)
  1009d6:	e8 81 f8 ff ff       	call   10025c <cprintf>
  1009db:	eb 6d                	jmp    100a4a <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1c                	jmp    100a02 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a05:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a08:	7f dc                	jg     1009e6 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a0a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a13:	01 d0                	add    %edx,%eax
  100a15:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1e:	89 d1                	mov    %edx,%ecx
  100a20:	29 c1                	sub    %eax,%ecx
  100a22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a28:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a32:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a36:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3e:	c7 04 24 82 36 10 00 	movl   $0x103682,(%esp)
  100a45:	e8 12 f8 ff ff       	call   10025c <cprintf>
    }
}
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a63:	89 e8                	mov    %ebp,%eax
  100a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip(); // next inst to exec
  100a6e:	e8 d9 ff ff ff       	call   100a4c <read_eip>
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; ++i) {
  100a76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a7d:	e9 8f 00 00 00       	jmp    100b11 <print_stackframe+0xb4>
        uint32_t *ptr = (uint32_t *)ebp;
  100a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  100a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a96:	c7 04 24 94 36 10 00 	movl   $0x103694,(%esp)
  100a9d:	e8 ba f7 ff ff       	call   10025c <cprintf>
        cprintf("args:");
  100aa2:	c7 04 24 ab 36 10 00 	movl   $0x1036ab,(%esp)
  100aa9:	e8 ae f7 ff ff       	call   10025c <cprintf>
        // stack: grow <---- low address  <----  high address
        // [caller ebp, caller eip, arg0, arg1, arg2, arg3, arg...]
        for (j = 2; j < 6; ++j) {
  100aae:	c7 45 e8 02 00 00 00 	movl   $0x2,-0x18(%ebp)
  100ab5:	eb 25                	jmp    100adc <print_stackframe+0x7f>
            cprintf("0x%08x ", ptr[j]);
  100ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ac4:	01 d0                	add    %edx,%eax
  100ac6:	8b 00                	mov    (%eax),%eax
  100ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100acc:	c7 04 24 b1 36 10 00 	movl   $0x1036b1,(%esp)
  100ad3:	e8 84 f7 ff ff       	call   10025c <cprintf>
        for (j = 2; j < 6; ++j) {
  100ad8:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100adc:	83 7d e8 05          	cmpl   $0x5,-0x18(%ebp)
  100ae0:	7e d5                	jle    100ab7 <print_stackframe+0x5a>
        }
        cprintf("\n");
  100ae2:	c7 04 24 b9 36 10 00 	movl   $0x1036b9,(%esp)
  100ae9:	e8 6e f7 ff ff       	call   10025c <cprintf>
        print_debuginfo(eip - 1);
  100aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af1:	83 e8 01             	sub    $0x1,%eax
  100af4:	89 04 24             	mov    %eax,(%esp)
  100af7:	e8 ad fe ff ff       	call   1009a9 <print_debuginfo>
        eip = ptr[1];
  100afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100aff:	8b 40 04             	mov    0x4(%eax),%eax
  100b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ptr[0];
  100b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b08:	8b 00                	mov    (%eax),%eax
  100b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; i < STACKFRAME_DEPTH && ebp; ++i) {
  100b0d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b11:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b15:	7f 0a                	jg     100b21 <print_stackframe+0xc4>
  100b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b1b:	0f 85 61 ff ff ff    	jne    100a82 <print_stackframe+0x25>
    }
}
  100b21:	c9                   	leave  
  100b22:	c3                   	ret    

00100b23 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b23:	55                   	push   %ebp
  100b24:	89 e5                	mov    %esp,%ebp
  100b26:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	eb 0c                	jmp    100b3e <parse+0x1b>
            *buf ++ = '\0';
  100b32:	8b 45 08             	mov    0x8(%ebp),%eax
  100b35:	8d 50 01             	lea    0x1(%eax),%edx
  100b38:	89 55 08             	mov    %edx,0x8(%ebp)
  100b3b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b41:	0f b6 00             	movzbl (%eax),%eax
  100b44:	84 c0                	test   %al,%al
  100b46:	74 1d                	je     100b65 <parse+0x42>
  100b48:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4b:	0f b6 00             	movzbl (%eax),%eax
  100b4e:	0f be c0             	movsbl %al,%eax
  100b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b55:	c7 04 24 3c 37 10 00 	movl   $0x10373c,(%esp)
  100b5c:	e8 7f 1f 00 00       	call   102ae0 <strchr>
  100b61:	85 c0                	test   %eax,%eax
  100b63:	75 cd                	jne    100b32 <parse+0xf>
        }
        if (*buf == '\0') {
  100b65:	8b 45 08             	mov    0x8(%ebp),%eax
  100b68:	0f b6 00             	movzbl (%eax),%eax
  100b6b:	84 c0                	test   %al,%al
  100b6d:	75 02                	jne    100b71 <parse+0x4e>
            break;
  100b6f:	eb 67                	jmp    100bd8 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b71:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b75:	75 14                	jne    100b8b <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b77:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b7e:	00 
  100b7f:	c7 04 24 41 37 10 00 	movl   $0x103741,(%esp)
  100b86:	e8 d1 f6 ff ff       	call   10025c <cprintf>
        }
        argv[argc ++] = buf;
  100b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8e:	8d 50 01             	lea    0x1(%eax),%edx
  100b91:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b9e:	01 c2                	add    %eax,%edx
  100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba5:	eb 04                	jmp    100bab <parse+0x88>
            buf ++;
  100ba7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bab:	8b 45 08             	mov    0x8(%ebp),%eax
  100bae:	0f b6 00             	movzbl (%eax),%eax
  100bb1:	84 c0                	test   %al,%al
  100bb3:	74 1d                	je     100bd2 <parse+0xaf>
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	0f be c0             	movsbl %al,%eax
  100bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc2:	c7 04 24 3c 37 10 00 	movl   $0x10373c,(%esp)
  100bc9:	e8 12 1f 00 00       	call   102ae0 <strchr>
  100bce:	85 c0                	test   %eax,%eax
  100bd0:	74 d5                	je     100ba7 <parse+0x84>
        }
    }
  100bd2:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd3:	e9 66 ff ff ff       	jmp    100b3e <parse+0x1b>
    return argc;
  100bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bdb:	c9                   	leave  
  100bdc:	c3                   	ret    

00100bdd <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bdd:	55                   	push   %ebp
  100bde:	89 e5                	mov    %esp,%ebp
  100be0:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100be3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	89 04 24             	mov    %eax,(%esp)
  100bf0:	e8 2e ff ff ff       	call   100b23 <parse>
  100bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bfc:	75 0a                	jne    100c08 <runcmd+0x2b>
        return 0;
  100bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  100c03:	e9 85 00 00 00       	jmp    100c8d <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0f:	eb 5c                	jmp    100c6d <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c11:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c17:	89 d0                	mov    %edx,%eax
  100c19:	01 c0                	add    %eax,%eax
  100c1b:	01 d0                	add    %edx,%eax
  100c1d:	c1 e0 02             	shl    $0x2,%eax
  100c20:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c25:	8b 00                	mov    (%eax),%eax
  100c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c2b:	89 04 24             	mov    %eax,(%esp)
  100c2e:	e8 0e 1e 00 00       	call   102a41 <strcmp>
  100c33:	85 c0                	test   %eax,%eax
  100c35:	75 32                	jne    100c69 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3a:	89 d0                	mov    %edx,%eax
  100c3c:	01 c0                	add    %eax,%eax
  100c3e:	01 d0                	add    %edx,%eax
  100c40:	c1 e0 02             	shl    $0x2,%eax
  100c43:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c48:	8b 40 08             	mov    0x8(%eax),%eax
  100c4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c4e:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c54:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c58:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c5b:	83 c2 04             	add    $0x4,%edx
  100c5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c62:	89 0c 24             	mov    %ecx,(%esp)
  100c65:	ff d0                	call   *%eax
  100c67:	eb 24                	jmp    100c8d <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c70:	83 f8 02             	cmp    $0x2,%eax
  100c73:	76 9c                	jbe    100c11 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7c:	c7 04 24 5f 37 10 00 	movl   $0x10375f,(%esp)
  100c83:	e8 d4 f5 ff ff       	call   10025c <cprintf>
    return 0;
  100c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8d:	c9                   	leave  
  100c8e:	c3                   	ret    

00100c8f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c8f:	55                   	push   %ebp
  100c90:	89 e5                	mov    %esp,%ebp
  100c92:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c95:	c7 04 24 78 37 10 00 	movl   $0x103778,(%esp)
  100c9c:	e8 bb f5 ff ff       	call   10025c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ca1:	c7 04 24 a0 37 10 00 	movl   $0x1037a0,(%esp)
  100ca8:	e8 af f5 ff ff       	call   10025c <cprintf>

    if (tf != NULL) {
  100cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb1:	74 0b                	je     100cbe <kmonitor+0x2f>
        print_trapframe(tf);
  100cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb6:	89 04 24             	mov    %eax,(%esp)
  100cb9:	e8 36 0d 00 00       	call   1019f4 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cbe:	c7 04 24 c5 37 10 00 	movl   $0x1037c5,(%esp)
  100cc5:	e8 33 f6 ff ff       	call   1002fd <readline>
  100cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd1:	74 18                	je     100ceb <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cdd:	89 04 24             	mov    %eax,(%esp)
  100ce0:	e8 f8 fe ff ff       	call   100bdd <runcmd>
  100ce5:	85 c0                	test   %eax,%eax
  100ce7:	79 02                	jns    100ceb <kmonitor+0x5c>
                break;
  100ce9:	eb 02                	jmp    100ced <kmonitor+0x5e>
            }
        }
    }
  100ceb:	eb d1                	jmp    100cbe <kmonitor+0x2f>
}
  100ced:	c9                   	leave  
  100cee:	c3                   	ret    

00100cef <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cef:	55                   	push   %ebp
  100cf0:	89 e5                	mov    %esp,%ebp
  100cf2:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cf5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cfc:	eb 3f                	jmp    100d3d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d01:	89 d0                	mov    %edx,%eax
  100d03:	01 c0                	add    %eax,%eax
  100d05:	01 d0                	add    %edx,%eax
  100d07:	c1 e0 02             	shl    $0x2,%eax
  100d0a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d0f:	8b 48 04             	mov    0x4(%eax),%ecx
  100d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d15:	89 d0                	mov    %edx,%eax
  100d17:	01 c0                	add    %eax,%eax
  100d19:	01 d0                	add    %edx,%eax
  100d1b:	c1 e0 02             	shl    $0x2,%eax
  100d1e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d23:	8b 00                	mov    (%eax),%eax
  100d25:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2d:	c7 04 24 c9 37 10 00 	movl   $0x1037c9,(%esp)
  100d34:	e8 23 f5 ff ff       	call   10025c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d40:	83 f8 02             	cmp    $0x2,%eax
  100d43:	76 b9                	jbe    100cfe <mon_help+0xf>
    }
    return 0;
  100d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4a:	c9                   	leave  
  100d4b:	c3                   	ret    

00100d4c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d52:	e8 bc fb ff ff       	call   100913 <print_kerninfo>
    return 0;
  100d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5c:	c9                   	leave  
  100d5d:	c3                   	ret    

00100d5e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d5e:	55                   	push   %ebp
  100d5f:	89 e5                	mov    %esp,%ebp
  100d61:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d64:	e8 f4 fc ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 28             	sub    $0x28,%esp
  100d76:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d7c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d80:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d84:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
  100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
  100d9c:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100daa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dae:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100daf:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db9:	c7 04 24 d2 37 10 00 	movl   $0x1037d2,(%esp)
  100dc0:	e8 97 f4 ff ff       	call   10025c <cprintf>
    pic_enable(IRQ_TIMER);
  100dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcc:	e8 b5 08 00 00       	call   101686 <pic_enable>
}
  100dd1:	c9                   	leave  
  100dd2:	c3                   	ret    

00100dd3 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd3:	55                   	push   %ebp
  100dd4:	89 e5                	mov    %esp,%ebp
  100dd6:	83 ec 10             	sub    $0x10,%esp
  100dd9:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ddf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de3:	89 c2                	mov    %eax,%edx
  100de5:	ec                   	in     (%dx),%al
  100de6:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de9:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100def:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df3:	89 c2                	mov    %eax,%edx
  100df5:	ec                   	in     (%dx),%al
  100df6:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df9:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dff:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e03:	89 c2                	mov    %eax,%edx
  100e05:	ec                   	in     (%dx),%al
  100e06:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e09:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e0f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e13:	89 c2                	mov    %eax,%edx
  100e15:	ec                   	in     (%dx),%al
  100e16:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e19:	c9                   	leave  
  100e1a:	c3                   	ret    

00100e1b <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e1b:	55                   	push   %ebp
  100e1c:	89 e5                	mov    %esp,%ebp
  100e1e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e21:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2b:	0f b7 00             	movzwl (%eax),%eax
  100e2e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3d:	0f b7 00             	movzwl (%eax),%eax
  100e40:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e44:	74 12                	je     100e58 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e46:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e4d:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e54:	b4 03 
  100e56:	eb 13                	jmp    100e6b <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e5f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e62:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e69:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e6b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e72:	0f b7 c0             	movzwl %ax,%eax
  100e75:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e79:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e81:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e85:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e86:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8d:	83 c0 01             	add    $0x1,%eax
  100e90:	0f b7 c0             	movzwl %ax,%eax
  100e93:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e97:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e9b:	89 c2                	mov    %eax,%edx
  100e9d:	ec                   	in     (%dx),%al
  100e9e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea5:	0f b6 c0             	movzbl %al,%eax
  100ea8:	c1 e0 08             	shl    $0x8,%eax
  100eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eae:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb5:	0f b7 c0             	movzwl %ax,%eax
  100eb8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ebc:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec8:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed0:	83 c0 01             	add    $0x1,%eax
  100ed3:	0f b7 c0             	movzwl %ax,%eax
  100ed6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eda:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ede:	89 c2                	mov    %eax,%edx
  100ee0:	ec                   	in     (%dx),%al
  100ee1:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ee4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee8:	0f b6 c0             	movzbl %al,%eax
  100eeb:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef1:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100eff:	c9                   	leave  
  100f00:	c3                   	ret    

00100f01 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f01:	55                   	push   %ebp
  100f02:	89 e5                	mov    %esp,%ebp
  100f04:	83 ec 48             	sub    $0x48,%esp
  100f07:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f0d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f11:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f15:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f20:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f24:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f28:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f33:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f37:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f3b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f46:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f4a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f4e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f59:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f5d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f61:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f6c:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f70:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f74:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f7f:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f83:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f87:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f8b:	ee                   	out    %al,(%dx)
  100f8c:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f92:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f96:	89 c2                	mov    %eax,%edx
  100f98:	ec                   	in     (%dx),%al
  100f99:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f9c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa0:	3c ff                	cmp    $0xff,%al
  100fa2:	0f 95 c0             	setne  %al
  100fa5:	0f b6 c0             	movzbl %al,%eax
  100fa8:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fad:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb7:	89 c2                	mov    %eax,%edx
  100fb9:	ec                   	in     (%dx),%al
  100fba:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fbd:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fc3:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc7:	89 c2                	mov    %eax,%edx
  100fc9:	ec                   	in     (%dx),%al
  100fca:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fcd:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fd2:	85 c0                	test   %eax,%eax
  100fd4:	74 0c                	je     100fe2 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fdd:	e8 a4 06 00 00       	call   101686 <pic_enable>
    }
}
  100fe2:	c9                   	leave  
  100fe3:	c3                   	ret    

00100fe4 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe4:	55                   	push   %ebp
  100fe5:	89 e5                	mov    %esp,%ebp
  100fe7:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff1:	eb 09                	jmp    100ffc <lpt_putc_sub+0x18>
        delay();
  100ff3:	e8 db fd ff ff       	call   100dd3 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ffc:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101002:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10100c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101010:	84 c0                	test   %al,%al
  101012:	78 09                	js     10101d <lpt_putc_sub+0x39>
  101014:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10101b:	7e d6                	jle    100ff3 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10101d:	8b 45 08             	mov    0x8(%ebp),%eax
  101020:	0f b6 c0             	movzbl %al,%eax
  101023:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101029:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10102c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101030:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
  101035:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10103b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10103f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101043:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
  101048:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10104e:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101052:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101056:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10105d:	55                   	push   %ebp
  10105e:	89 e5                	mov    %esp,%ebp
  101060:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101063:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101067:	74 0d                	je     101076 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101069:	8b 45 08             	mov    0x8(%ebp),%eax
  10106c:	89 04 24             	mov    %eax,(%esp)
  10106f:	e8 70 ff ff ff       	call   100fe4 <lpt_putc_sub>
  101074:	eb 24                	jmp    10109a <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101076:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107d:	e8 62 ff ff ff       	call   100fe4 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101082:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101089:	e8 56 ff ff ff       	call   100fe4 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10108e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101095:	e8 4a ff ff ff       	call   100fe4 <lpt_putc_sub>
    }
}
  10109a:	c9                   	leave  
  10109b:	c3                   	ret    

0010109c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10109c:	55                   	push   %ebp
  10109d:	89 e5                	mov    %esp,%ebp
  10109f:	53                   	push   %ebx
  1010a0:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a6:	b0 00                	mov    $0x0,%al
  1010a8:	85 c0                	test   %eax,%eax
  1010aa:	75 07                	jne    1010b3 <cga_putc+0x17>
        c |= 0x0700;
  1010ac:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b6:	0f b6 c0             	movzbl %al,%eax
  1010b9:	83 f8 0a             	cmp    $0xa,%eax
  1010bc:	74 4c                	je     10110a <cga_putc+0x6e>
  1010be:	83 f8 0d             	cmp    $0xd,%eax
  1010c1:	74 57                	je     10111a <cga_putc+0x7e>
  1010c3:	83 f8 08             	cmp    $0x8,%eax
  1010c6:	0f 85 88 00 00 00    	jne    101154 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010cc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d3:	66 85 c0             	test   %ax,%ax
  1010d6:	74 30                	je     101108 <cga_putc+0x6c>
            crt_pos --;
  1010d8:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010df:	83 e8 01             	sub    $0x1,%eax
  1010e2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e8:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010ed:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010f4:	0f b7 d2             	movzwl %dx,%edx
  1010f7:	01 d2                	add    %edx,%edx
  1010f9:	01 c2                	add    %eax,%edx
  1010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fe:	b0 00                	mov    $0x0,%al
  101100:	83 c8 20             	or     $0x20,%eax
  101103:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101106:	eb 72                	jmp    10117a <cga_putc+0xde>
  101108:	eb 70                	jmp    10117a <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10110a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101111:	83 c0 50             	add    $0x50,%eax
  101114:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10111a:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101121:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101128:	0f b7 c1             	movzwl %cx,%eax
  10112b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101131:	c1 e8 10             	shr    $0x10,%eax
  101134:	89 c2                	mov    %eax,%edx
  101136:	66 c1 ea 06          	shr    $0x6,%dx
  10113a:	89 d0                	mov    %edx,%eax
  10113c:	c1 e0 02             	shl    $0x2,%eax
  10113f:	01 d0                	add    %edx,%eax
  101141:	c1 e0 04             	shl    $0x4,%eax
  101144:	29 c1                	sub    %eax,%ecx
  101146:	89 ca                	mov    %ecx,%edx
  101148:	89 d8                	mov    %ebx,%eax
  10114a:	29 d0                	sub    %edx,%eax
  10114c:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101152:	eb 26                	jmp    10117a <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101154:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10115a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101161:	8d 50 01             	lea    0x1(%eax),%edx
  101164:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10116b:	0f b7 c0             	movzwl %ax,%eax
  10116e:	01 c0                	add    %eax,%eax
  101170:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101173:	8b 45 08             	mov    0x8(%ebp),%eax
  101176:	66 89 02             	mov    %ax,(%edx)
        break;
  101179:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10117a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101181:	66 3d cf 07          	cmp    $0x7cf,%ax
  101185:	76 5b                	jbe    1011e2 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101187:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101192:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101197:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10119e:	00 
  10119f:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a3:	89 04 24             	mov    %eax,(%esp)
  1011a6:	e8 33 1b 00 00       	call   102cde <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ab:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b2:	eb 15                	jmp    1011c9 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011b4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011bc:	01 d2                	add    %edx,%edx
  1011be:	01 d0                	add    %edx,%eax
  1011c0:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c9:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d0:	7e e2                	jle    1011b4 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  1011d2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d9:	83 e8 50             	sub    $0x50,%eax
  1011dc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e9:	0f b7 c0             	movzwl %ax,%eax
  1011ec:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f0:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011f4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011fc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011fd:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101204:	66 c1 e8 08          	shr    $0x8,%ax
  101208:	0f b6 c0             	movzbl %al,%eax
  10120b:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101212:	83 c2 01             	add    $0x1,%edx
  101215:	0f b7 d2             	movzwl %dx,%edx
  101218:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10121c:	88 45 ed             	mov    %al,-0x13(%ebp)
  10121f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101223:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101227:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101228:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10122f:	0f b7 c0             	movzwl %ax,%eax
  101232:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101236:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10123a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10123e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101242:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101243:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10124a:	0f b6 c0             	movzbl %al,%eax
  10124d:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101254:	83 c2 01             	add    $0x1,%edx
  101257:	0f b7 d2             	movzwl %dx,%edx
  10125a:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10125e:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101261:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101265:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101269:	ee                   	out    %al,(%dx)
}
  10126a:	83 c4 34             	add    $0x34,%esp
  10126d:	5b                   	pop    %ebx
  10126e:	5d                   	pop    %ebp
  10126f:	c3                   	ret    

00101270 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101270:	55                   	push   %ebp
  101271:	89 e5                	mov    %esp,%ebp
  101273:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101276:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10127d:	eb 09                	jmp    101288 <serial_putc_sub+0x18>
        delay();
  10127f:	e8 4f fb ff ff       	call   100dd3 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101284:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101288:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10128e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101292:	89 c2                	mov    %eax,%edx
  101294:	ec                   	in     (%dx),%al
  101295:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101298:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10129c:	0f b6 c0             	movzbl %al,%eax
  10129f:	83 e0 20             	and    $0x20,%eax
  1012a2:	85 c0                	test   %eax,%eax
  1012a4:	75 09                	jne    1012af <serial_putc_sub+0x3f>
  1012a6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012ad:	7e d0                	jle    10127f <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012af:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b2:	0f b6 c0             	movzbl %al,%eax
  1012b5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012bb:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012be:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c6:	ee                   	out    %al,(%dx)
}
  1012c7:	c9                   	leave  
  1012c8:	c3                   	ret    

001012c9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c9:	55                   	push   %ebp
  1012ca:	89 e5                	mov    %esp,%ebp
  1012cc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012cf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d3:	74 0d                	je     1012e2 <serial_putc+0x19>
        serial_putc_sub(c);
  1012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d8:	89 04 24             	mov    %eax,(%esp)
  1012db:	e8 90 ff ff ff       	call   101270 <serial_putc_sub>
  1012e0:	eb 24                	jmp    101306 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e9:	e8 82 ff ff ff       	call   101270 <serial_putc_sub>
        serial_putc_sub(' ');
  1012ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012f5:	e8 76 ff ff ff       	call   101270 <serial_putc_sub>
        serial_putc_sub('\b');
  1012fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101301:	e8 6a ff ff ff       	call   101270 <serial_putc_sub>
    }
}
  101306:	c9                   	leave  
  101307:	c3                   	ret    

00101308 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101308:	55                   	push   %ebp
  101309:	89 e5                	mov    %esp,%ebp
  10130b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10130e:	eb 33                	jmp    101343 <cons_intr+0x3b>
        if (c != 0) {
  101310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101314:	74 2d                	je     101343 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101316:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131b:	8d 50 01             	lea    0x1(%eax),%edx
  10131e:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101327:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10132d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101332:	3d 00 02 00 00       	cmp    $0x200,%eax
  101337:	75 0a                	jne    101343 <cons_intr+0x3b>
                cons.wpos = 0;
  101339:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101340:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101343:	8b 45 08             	mov    0x8(%ebp),%eax
  101346:	ff d0                	call   *%eax
  101348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10134b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10134f:	75 bf                	jne    101310 <cons_intr+0x8>
            }
        }
    }
}
  101351:	c9                   	leave  
  101352:	c3                   	ret    

00101353 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101353:	55                   	push   %ebp
  101354:	89 e5                	mov    %esp,%ebp
  101356:	83 ec 10             	sub    $0x10,%esp
  101359:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10135f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101363:	89 c2                	mov    %eax,%edx
  101365:	ec                   	in     (%dx),%al
  101366:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101369:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10136d:	0f b6 c0             	movzbl %al,%eax
  101370:	83 e0 01             	and    $0x1,%eax
  101373:	85 c0                	test   %eax,%eax
  101375:	75 07                	jne    10137e <serial_proc_data+0x2b>
        return -1;
  101377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10137c:	eb 2a                	jmp    1013a8 <serial_proc_data+0x55>
  10137e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101384:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101388:	89 c2                	mov    %eax,%edx
  10138a:	ec                   	in     (%dx),%al
  10138b:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10138e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101392:	0f b6 c0             	movzbl %al,%eax
  101395:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101398:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10139c:	75 07                	jne    1013a5 <serial_proc_data+0x52>
        c = '\b';
  10139e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a8:	c9                   	leave  
  1013a9:	c3                   	ret    

001013aa <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013aa:	55                   	push   %ebp
  1013ab:	89 e5                	mov    %esp,%ebp
  1013ad:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b0:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013b5:	85 c0                	test   %eax,%eax
  1013b7:	74 0c                	je     1013c5 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b9:	c7 04 24 53 13 10 00 	movl   $0x101353,(%esp)
  1013c0:	e8 43 ff ff ff       	call   101308 <cons_intr>
    }
}
  1013c5:	c9                   	leave  
  1013c6:	c3                   	ret    

001013c7 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c7:	55                   	push   %ebp
  1013c8:	89 e5                	mov    %esp,%ebp
  1013ca:	83 ec 38             	sub    $0x38,%esp
  1013cd:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	83 e0 01             	and    $0x1,%eax
  1013e7:	85 c0                	test   %eax,%eax
  1013e9:	75 0a                	jne    1013f5 <kbd_proc_data+0x2e>
        return -1;
  1013eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f0:	e9 59 01 00 00       	jmp    10154e <kbd_proc_data+0x187>
  1013f5:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ff:	89 c2                	mov    %eax,%edx
  101401:	ec                   	in     (%dx),%al
  101402:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101405:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101409:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10140c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101410:	75 17                	jne    101429 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101412:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101417:	83 c8 40             	or     $0x40,%eax
  10141a:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10141f:	b8 00 00 00 00       	mov    $0x0,%eax
  101424:	e9 25 01 00 00       	jmp    10154e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101429:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142d:	84 c0                	test   %al,%al
  10142f:	79 47                	jns    101478 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101431:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101436:	83 e0 40             	and    $0x40,%eax
  101439:	85 c0                	test   %eax,%eax
  10143b:	75 09                	jne    101446 <kbd_proc_data+0x7f>
  10143d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101441:	83 e0 7f             	and    $0x7f,%eax
  101444:	eb 04                	jmp    10144a <kbd_proc_data+0x83>
  101446:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10144d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101451:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101458:	83 c8 40             	or     $0x40,%eax
  10145b:	0f b6 c0             	movzbl %al,%eax
  10145e:	f7 d0                	not    %eax
  101460:	89 c2                	mov    %eax,%edx
  101462:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101467:	21 d0                	and    %edx,%eax
  101469:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 d6 00 00 00       	jmp    10154e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101478:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147d:	83 e0 40             	and    $0x40,%eax
  101480:	85 c0                	test   %eax,%eax
  101482:	74 11                	je     101495 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101484:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101488:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148d:	83 e0 bf             	and    $0xffffffbf,%eax
  101490:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a0:	0f b6 d0             	movzbl %al,%edx
  1014a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a8:	09 d0                	or     %edx,%eax
  1014aa:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b3:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014ba:	0f b6 d0             	movzbl %al,%edx
  1014bd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c2:	31 d0                	xor    %edx,%eax
  1014c4:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ce:	83 e0 03             	and    $0x3,%eax
  1014d1:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014dc:	01 d0                	add    %edx,%eax
  1014de:	0f b6 00             	movzbl (%eax),%eax
  1014e1:	0f b6 c0             	movzbl %al,%eax
  1014e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ec:	83 e0 08             	and    $0x8,%eax
  1014ef:	85 c0                	test   %eax,%eax
  1014f1:	74 22                	je     101515 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014f3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f7:	7e 0c                	jle    101505 <kbd_proc_data+0x13e>
  1014f9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014fd:	7f 06                	jg     101505 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014ff:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101503:	eb 10                	jmp    101515 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101505:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101509:	7e 0a                	jle    101515 <kbd_proc_data+0x14e>
  10150b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10150f:	7f 04                	jg     101515 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101511:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101515:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10151a:	f7 d0                	not    %eax
  10151c:	83 e0 06             	and    $0x6,%eax
  10151f:	85 c0                	test   %eax,%eax
  101521:	75 28                	jne    10154b <kbd_proc_data+0x184>
  101523:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10152a:	75 1f                	jne    10154b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10152c:	c7 04 24 ed 37 10 00 	movl   $0x1037ed,(%esp)
  101533:	e8 24 ed ff ff       	call   10025c <cprintf>
  101538:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10153e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101542:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101546:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10154a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10154e:	c9                   	leave  
  10154f:	c3                   	ret    

00101550 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101550:	55                   	push   %ebp
  101551:	89 e5                	mov    %esp,%ebp
  101553:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101556:	c7 04 24 c7 13 10 00 	movl   $0x1013c7,(%esp)
  10155d:	e8 a6 fd ff ff       	call   101308 <cons_intr>
}
  101562:	c9                   	leave  
  101563:	c3                   	ret    

00101564 <kbd_init>:

static void
kbd_init(void) {
  101564:	55                   	push   %ebp
  101565:	89 e5                	mov    %esp,%ebp
  101567:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10156a:	e8 e1 ff ff ff       	call   101550 <kbd_intr>
    pic_enable(IRQ_KBD);
  10156f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101576:	e8 0b 01 00 00       	call   101686 <pic_enable>
}
  10157b:	c9                   	leave  
  10157c:	c3                   	ret    

0010157d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157d:	55                   	push   %ebp
  10157e:	89 e5                	mov    %esp,%ebp
  101580:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101583:	e8 93 f8 ff ff       	call   100e1b <cga_init>
    serial_init();
  101588:	e8 74 f9 ff ff       	call   100f01 <serial_init>
    kbd_init();
  10158d:	e8 d2 ff ff ff       	call   101564 <kbd_init>
    if (!serial_exists) {
  101592:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101597:	85 c0                	test   %eax,%eax
  101599:	75 0c                	jne    1015a7 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10159b:	c7 04 24 f9 37 10 00 	movl   $0x1037f9,(%esp)
  1015a2:	e8 b5 ec ff ff       	call   10025c <cprintf>
    }
}
  1015a7:	c9                   	leave  
  1015a8:	c3                   	ret    

001015a9 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a9:	55                   	push   %ebp
  1015aa:	89 e5                	mov    %esp,%ebp
  1015ac:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015af:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b2:	89 04 24             	mov    %eax,(%esp)
  1015b5:	e8 a3 fa ff ff       	call   10105d <lpt_putc>
    cga_putc(c);
  1015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bd:	89 04 24             	mov    %eax,(%esp)
  1015c0:	e8 d7 fa ff ff       	call   10109c <cga_putc>
    serial_putc(c);
  1015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c8:	89 04 24             	mov    %eax,(%esp)
  1015cb:	e8 f9 fc ff ff       	call   1012c9 <serial_putc>
}
  1015d0:	c9                   	leave  
  1015d1:	c3                   	ret    

001015d2 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015d2:	55                   	push   %ebp
  1015d3:	89 e5                	mov    %esp,%ebp
  1015d5:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d8:	e8 cd fd ff ff       	call   1013aa <serial_intr>
    kbd_intr();
  1015dd:	e8 6e ff ff ff       	call   101550 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015e2:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ed:	39 c2                	cmp    %eax,%edx
  1015ef:	74 36                	je     101627 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f1:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f6:	8d 50 01             	lea    0x1(%eax),%edx
  1015f9:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ff:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101606:	0f b6 c0             	movzbl %al,%eax
  101609:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10160c:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101611:	3d 00 02 00 00       	cmp    $0x200,%eax
  101616:	75 0a                	jne    101622 <cons_getc+0x50>
            cons.rpos = 0;
  101618:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161f:	00 00 00 
        }
        return c;
  101622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101625:	eb 05                	jmp    10162c <cons_getc+0x5a>
    }
    return 0;
  101627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10162c:	c9                   	leave  
  10162d:	c3                   	ret    

0010162e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10162e:	55                   	push   %ebp
  10162f:	89 e5                	mov    %esp,%ebp
  101631:	83 ec 14             	sub    $0x14,%esp
  101634:	8b 45 08             	mov    0x8(%ebp),%eax
  101637:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10163b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163f:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101645:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10164a:	85 c0                	test   %eax,%eax
  10164c:	74 36                	je     101684 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10164e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101652:	0f b6 c0             	movzbl %al,%eax
  101655:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10165b:	88 45 fd             	mov    %al,-0x3(%ebp)
  10165e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101662:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101666:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101667:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166b:	66 c1 e8 08          	shr    $0x8,%ax
  10166f:	0f b6 c0             	movzbl %al,%eax
  101672:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101678:	88 45 f9             	mov    %al,-0x7(%ebp)
  10167b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101683:	ee                   	out    %al,(%dx)
    }
}
  101684:	c9                   	leave  
  101685:	c3                   	ret    

00101686 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101686:	55                   	push   %ebp
  101687:	89 e5                	mov    %esp,%ebp
  101689:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10168c:	8b 45 08             	mov    0x8(%ebp),%eax
  10168f:	ba 01 00 00 00       	mov    $0x1,%edx
  101694:	89 c1                	mov    %eax,%ecx
  101696:	d3 e2                	shl    %cl,%edx
  101698:	89 d0                	mov    %edx,%eax
  10169a:	f7 d0                	not    %eax
  10169c:	89 c2                	mov    %eax,%edx
  10169e:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a5:	21 d0                	and    %edx,%eax
  1016a7:	0f b7 c0             	movzwl %ax,%eax
  1016aa:	89 04 24             	mov    %eax,(%esp)
  1016ad:	e8 7c ff ff ff       	call   10162e <pic_setmask>
}
  1016b2:	c9                   	leave  
  1016b3:	c3                   	ret    

001016b4 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
  1016b7:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016ba:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016c1:	00 00 00 
  1016c4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016ca:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016ce:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d6:	ee                   	out    %al,(%dx)
  1016d7:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016dd:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016e1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
  1016ea:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f0:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101703:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101707:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10170b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101716:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10171a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10171e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101729:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10172d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101731:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10173c:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101740:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101744:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10174f:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101753:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101757:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101762:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101766:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10176a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101775:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101779:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10177d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101788:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10178c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101790:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10179b:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10179f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a3:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017ae:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b2:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017b6:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017c1:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017c5:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c9:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017ce:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d5:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d9:	74 12                	je     1017ed <pic_init+0x139>
        pic_setmask(irq_mask);
  1017db:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e2:	0f b7 c0             	movzwl %ax,%eax
  1017e5:	89 04 24             	mov    %eax,(%esp)
  1017e8:	e8 41 fe ff ff       	call   10162e <pic_setmask>
    }
}
  1017ed:	c9                   	leave  
  1017ee:	c3                   	ret    

001017ef <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ef:	55                   	push   %ebp
  1017f0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017f2:	fb                   	sti    
    sti();
}
  1017f3:	5d                   	pop    %ebp
  1017f4:	c3                   	ret    

001017f5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f5:	55                   	push   %ebp
  1017f6:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f8:	fa                   	cli    
    cli();
}
  1017f9:	5d                   	pop    %ebp
  1017fa:	c3                   	ret    

001017fb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fb:	55                   	push   %ebp
  1017fc:	89 e5                	mov    %esp,%ebp
  1017fe:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101801:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101808:	00 
  101809:	c7 04 24 20 38 10 00 	movl   $0x103820,(%esp)
  101810:	e8 47 ea ff ff       	call   10025c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101815:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  10181c:	e8 3b ea ff ff       	call   10025c <cprintf>
    panic("EOT: kernel seems ok.");
  101821:	c7 44 24 08 38 38 10 	movl   $0x103838,0x8(%esp)
  101828:	00 
  101829:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101830:	00 
  101831:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101838:	e8 76 eb ff ff       	call   1003b3 <__panic>

0010183d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10183d:	55                   	push   %ebp
  10183e:	89 e5                	mov    %esp,%ebp
  101840:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; ++i) {
  101843:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10184a:	e9 c3 00 00 00       	jmp    101912 <idt_init+0xd5>
        // GD_KTEXT is the global descrptor for global text
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101852:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101859:	89 c2                	mov    %eax,%edx
  10185b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101865:	00 
  101866:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101869:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101870:	00 08 00 
  101873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101876:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187d:	00 
  10187e:	83 e2 e0             	and    $0xffffffe0,%edx
  101881:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101892:	00 
  101893:	83 e2 1f             	and    $0x1f,%edx
  101896:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a0:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a7:	00 
  1018a8:	83 e2 f0             	and    $0xfffffff0,%edx
  1018ab:	83 ca 0e             	or     $0xe,%edx
  1018ae:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bf:	00 
  1018c0:	83 e2 ef             	and    $0xffffffef,%edx
  1018c3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d4:	00 
  1018d5:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e9:	00 
  1018ea:	83 ca 80             	or     $0xffffff80,%edx
  1018ed:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018fe:	c1 e8 10             	shr    $0x10,%eax
  101901:	89 c2                	mov    %eax,%edx
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  10190d:	00 
    for (i = 0; i < 256; ++i) {
  10190e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101912:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101919:	0f 8e 30 ff ff ff    	jle    10184f <idt_init+0x12>
    }
    // idt[T_SWITCH_TOK] can be triggered by user, the only difference is DPL_KERNEL -> DPL_USER
    // actually don't need it if not for Challenge 1
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10191f:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101924:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  10192a:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101931:	08 00 
  101933:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10193a:	83 e0 e0             	and    $0xffffffe0,%eax
  10193d:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101942:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101949:	83 e0 1f             	and    $0x1f,%eax
  10194c:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101951:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101958:	83 e0 f0             	and    $0xfffffff0,%eax
  10195b:	83 c8 0e             	or     $0xe,%eax
  10195e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101963:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10196a:	83 e0 ef             	and    $0xffffffef,%eax
  10196d:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101972:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101979:	83 c8 60             	or     $0x60,%eax
  10197c:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101981:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101988:	83 c8 80             	or     $0xffffff80,%eax
  10198b:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101990:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101995:	c1 e8 10             	shr    $0x10,%eax
  101998:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  10199e:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a8:	0f 01 18             	lidtl  (%eax)
	// load idt
    lidt(&idt_pd);
}
  1019ab:	c9                   	leave  
  1019ac:	c3                   	ret    

001019ad <trapname>:

static const char *
trapname(int trapno) {
  1019ad:	55                   	push   %ebp
  1019ae:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b3:	83 f8 13             	cmp    $0x13,%eax
  1019b6:	77 0c                	ja     1019c4 <trapname+0x17>
        return excnames[trapno];
  1019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bb:	8b 04 85 a0 3b 10 00 	mov    0x103ba0(,%eax,4),%eax
  1019c2:	eb 18                	jmp    1019dc <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c8:	7e 0d                	jle    1019d7 <trapname+0x2a>
  1019ca:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ce:	7f 07                	jg     1019d7 <trapname+0x2a>
        return "Hardware Interrupt";
  1019d0:	b8 5f 38 10 00       	mov    $0x10385f,%eax
  1019d5:	eb 05                	jmp    1019dc <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d7:	b8 72 38 10 00       	mov    $0x103872,%eax
}
  1019dc:	5d                   	pop    %ebp
  1019dd:	c3                   	ret    

001019de <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019de:	55                   	push   %ebp
  1019df:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e8:	66 83 f8 08          	cmp    $0x8,%ax
  1019ec:	0f 94 c0             	sete   %al
  1019ef:	0f b6 c0             	movzbl %al,%eax
}
  1019f2:	5d                   	pop    %ebp
  1019f3:	c3                   	ret    

001019f4 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f4:	55                   	push   %ebp
  1019f5:	89 e5                	mov    %esp,%ebp
  1019f7:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a01:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  101a08:	e8 4f e8 ff ff       	call   10025c <cprintf>
    print_regs(&tf->tf_regs);
  101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a10:	89 04 24             	mov    %eax,(%esp)
  101a13:	e8 a1 01 00 00       	call   101bb9 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a18:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a1f:	0f b7 c0             	movzwl %ax,%eax
  101a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a26:	c7 04 24 c4 38 10 00 	movl   $0x1038c4,(%esp)
  101a2d:	e8 2a e8 ff ff       	call   10025c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a32:	8b 45 08             	mov    0x8(%ebp),%eax
  101a35:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a39:	0f b7 c0             	movzwl %ax,%eax
  101a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a40:	c7 04 24 d7 38 10 00 	movl   $0x1038d7,(%esp)
  101a47:	e8 10 e8 ff ff       	call   10025c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a53:	0f b7 c0             	movzwl %ax,%eax
  101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5a:	c7 04 24 ea 38 10 00 	movl   $0x1038ea,(%esp)
  101a61:	e8 f6 e7 ff ff       	call   10025c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a66:	8b 45 08             	mov    0x8(%ebp),%eax
  101a69:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a6d:	0f b7 c0             	movzwl %ax,%eax
  101a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a74:	c7 04 24 fd 38 10 00 	movl   $0x1038fd,(%esp)
  101a7b:	e8 dc e7 ff ff       	call   10025c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a80:	8b 45 08             	mov    0x8(%ebp),%eax
  101a83:	8b 40 30             	mov    0x30(%eax),%eax
  101a86:	89 04 24             	mov    %eax,(%esp)
  101a89:	e8 1f ff ff ff       	call   1019ad <trapname>
  101a8e:	8b 55 08             	mov    0x8(%ebp),%edx
  101a91:	8b 52 30             	mov    0x30(%edx),%edx
  101a94:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a98:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a9c:	c7 04 24 10 39 10 00 	movl   $0x103910,(%esp)
  101aa3:	e8 b4 e7 ff ff       	call   10025c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aab:	8b 40 34             	mov    0x34(%eax),%eax
  101aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab2:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  101ab9:	e8 9e e7 ff ff       	call   10025c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	8b 40 38             	mov    0x38(%eax),%eax
  101ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac8:	c7 04 24 31 39 10 00 	movl   $0x103931,(%esp)
  101acf:	e8 88 e7 ff ff       	call   10025c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101adb:	0f b7 c0             	movzwl %ax,%eax
  101ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae2:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  101ae9:	e8 6e e7 ff ff       	call   10025c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aee:	8b 45 08             	mov    0x8(%ebp),%eax
  101af1:	8b 40 40             	mov    0x40(%eax),%eax
  101af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af8:	c7 04 24 53 39 10 00 	movl   $0x103953,(%esp)
  101aff:	e8 58 e7 ff ff       	call   10025c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b0b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b12:	eb 3e                	jmp    101b52 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b14:	8b 45 08             	mov    0x8(%ebp),%eax
  101b17:	8b 50 40             	mov    0x40(%eax),%edx
  101b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b1d:	21 d0                	and    %edx,%eax
  101b1f:	85 c0                	test   %eax,%eax
  101b21:	74 28                	je     101b4b <print_trapframe+0x157>
  101b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b26:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b2d:	85 c0                	test   %eax,%eax
  101b2f:	74 1a                	je     101b4b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b34:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3f:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  101b46:	e8 11 e7 ff ff       	call   10025c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b4f:	d1 65 f0             	shll   -0x10(%ebp)
  101b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b55:	83 f8 17             	cmp    $0x17,%eax
  101b58:	76 ba                	jbe    101b14 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5d:	8b 40 40             	mov    0x40(%eax),%eax
  101b60:	25 00 30 00 00       	and    $0x3000,%eax
  101b65:	c1 e8 0c             	shr    $0xc,%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 66 39 10 00 	movl   $0x103966,(%esp)
  101b73:	e8 e4 e6 ff ff       	call   10025c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b78:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7b:	89 04 24             	mov    %eax,(%esp)
  101b7e:	e8 5b fe ff ff       	call   1019de <trap_in_kernel>
  101b83:	85 c0                	test   %eax,%eax
  101b85:	75 30                	jne    101bb7 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b87:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8a:	8b 40 44             	mov    0x44(%eax),%eax
  101b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b91:	c7 04 24 6f 39 10 00 	movl   $0x10396f,(%esp)
  101b98:	e8 bf e6 ff ff       	call   10025c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba4:	0f b7 c0             	movzwl %ax,%eax
  101ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bab:	c7 04 24 7e 39 10 00 	movl   $0x10397e,(%esp)
  101bb2:	e8 a5 e6 ff ff       	call   10025c <cprintf>
    }
}
  101bb7:	c9                   	leave  
  101bb8:	c3                   	ret    

00101bb9 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb9:	55                   	push   %ebp
  101bba:	89 e5                	mov    %esp,%ebp
  101bbc:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc2:	8b 00                	mov    (%eax),%eax
  101bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc8:	c7 04 24 91 39 10 00 	movl   $0x103991,(%esp)
  101bcf:	e8 88 e6 ff ff       	call   10025c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd7:	8b 40 04             	mov    0x4(%eax),%eax
  101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bde:	c7 04 24 a0 39 10 00 	movl   $0x1039a0,(%esp)
  101be5:	e8 72 e6 ff ff       	call   10025c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 40 08             	mov    0x8(%eax),%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101bfb:	e8 5c e6 ff ff       	call   10025c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	8b 40 0c             	mov    0xc(%eax),%eax
  101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0a:	c7 04 24 be 39 10 00 	movl   $0x1039be,(%esp)
  101c11:	e8 46 e6 ff ff       	call   10025c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c16:	8b 45 08             	mov    0x8(%ebp),%eax
  101c19:	8b 40 10             	mov    0x10(%eax),%eax
  101c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c20:	c7 04 24 cd 39 10 00 	movl   $0x1039cd,(%esp)
  101c27:	e8 30 e6 ff ff       	call   10025c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 40 14             	mov    0x14(%eax),%eax
  101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c36:	c7 04 24 dc 39 10 00 	movl   $0x1039dc,(%esp)
  101c3d:	e8 1a e6 ff ff       	call   10025c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c42:	8b 45 08             	mov    0x8(%ebp),%eax
  101c45:	8b 40 18             	mov    0x18(%eax),%eax
  101c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4c:	c7 04 24 eb 39 10 00 	movl   $0x1039eb,(%esp)
  101c53:	e8 04 e6 ff ff       	call   10025c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c58:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5b:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c62:	c7 04 24 fa 39 10 00 	movl   $0x1039fa,(%esp)
  101c69:	e8 ee e5 ff ff       	call   10025c <cprintf>
}
  101c6e:	c9                   	leave  
  101c6f:	c3                   	ret    

00101c70 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c70:	55                   	push   %ebp
  101c71:	89 e5                	mov    %esp,%ebp
  101c73:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c76:	8b 45 08             	mov    0x8(%ebp),%eax
  101c79:	8b 40 30             	mov    0x30(%eax),%eax
  101c7c:	83 f8 2f             	cmp    $0x2f,%eax
  101c7f:	77 1d                	ja     101c9e <trap_dispatch+0x2e>
  101c81:	83 f8 2e             	cmp    $0x2e,%eax
  101c84:	0f 83 fd 00 00 00    	jae    101d87 <trap_dispatch+0x117>
  101c8a:	83 f8 21             	cmp    $0x21,%eax
  101c8d:	74 7e                	je     101d0d <trap_dispatch+0x9d>
  101c8f:	83 f8 24             	cmp    $0x24,%eax
  101c92:	74 53                	je     101ce7 <trap_dispatch+0x77>
  101c94:	83 f8 20             	cmp    $0x20,%eax
  101c97:	74 16                	je     101caf <trap_dispatch+0x3f>
  101c99:	e9 b1 00 00 00       	jmp    101d4f <trap_dispatch+0xdf>
  101c9e:	83 e8 78             	sub    $0x78,%eax
  101ca1:	83 f8 01             	cmp    $0x1,%eax
  101ca4:	0f 87 a5 00 00 00    	ja     101d4f <trap_dispatch+0xdf>
  101caa:	e9 84 00 00 00       	jmp    101d33 <trap_dispatch+0xc3>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if (++ticks % TICK_NUM == 0) {
  101caf:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cb4:	83 c0 01             	add    $0x1,%eax
  101cb7:	89 c1                	mov    %eax,%ecx
  101cb9:	89 0d 08 f9 10 00    	mov    %ecx,0x10f908
  101cbf:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc4:	89 c8                	mov    %ecx,%eax
  101cc6:	f7 e2                	mul    %edx
  101cc8:	89 d0                	mov    %edx,%eax
  101cca:	c1 e8 05             	shr    $0x5,%eax
  101ccd:	6b c0 64             	imul   $0x64,%eax,%eax
  101cd0:	29 c1                	sub    %eax,%ecx
  101cd2:	89 c8                	mov    %ecx,%eax
  101cd4:	85 c0                	test   %eax,%eax
  101cd6:	75 0a                	jne    101ce2 <trap_dispatch+0x72>
            print_ticks();
  101cd8:	e8 1e fb ff ff       	call   1017fb <print_ticks>
        }
        break;
  101cdd:	e9 a6 00 00 00       	jmp    101d88 <trap_dispatch+0x118>
  101ce2:	e9 a1 00 00 00       	jmp    101d88 <trap_dispatch+0x118>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce7:	e8 e6 f8 ff ff       	call   1015d2 <cons_getc>
  101cec:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cef:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cff:	c7 04 24 09 3a 10 00 	movl   $0x103a09,(%esp)
  101d06:	e8 51 e5 ff ff       	call   10025c <cprintf>
        break;
  101d0b:	eb 7b                	jmp    101d88 <trap_dispatch+0x118>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d0d:	e8 c0 f8 ff ff       	call   1015d2 <cons_getc>
  101d12:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d15:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d19:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d25:	c7 04 24 1b 3a 10 00 	movl   $0x103a1b,(%esp)
  101d2c:	e8 2b e5 ff ff       	call   10025c <cprintf>
        break;
  101d31:	eb 55                	jmp    101d88 <trap_dispatch+0x118>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d33:	c7 44 24 08 2a 3a 10 	movl   $0x103a2a,0x8(%esp)
  101d3a:	00 
  101d3b:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101d42:	00 
  101d43:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101d4a:	e8 64 e6 ff ff       	call   1003b3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d52:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d56:	0f b7 c0             	movzwl %ax,%eax
  101d59:	83 e0 03             	and    $0x3,%eax
  101d5c:	85 c0                	test   %eax,%eax
  101d5e:	75 28                	jne    101d88 <trap_dispatch+0x118>
            print_trapframe(tf);
  101d60:	8b 45 08             	mov    0x8(%ebp),%eax
  101d63:	89 04 24             	mov    %eax,(%esp)
  101d66:	e8 89 fc ff ff       	call   1019f4 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d6b:	c7 44 24 08 3a 3a 10 	movl   $0x103a3a,0x8(%esp)
  101d72:	00 
  101d73:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101d7a:	00 
  101d7b:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101d82:	e8 2c e6 ff ff       	call   1003b3 <__panic>
        break;
  101d87:	90                   	nop
        }
    }
}
  101d88:	c9                   	leave  
  101d89:	c3                   	ret    

00101d8a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d8a:	55                   	push   %ebp
  101d8b:	89 e5                	mov    %esp,%ebp
  101d8d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d90:	8b 45 08             	mov    0x8(%ebp),%eax
  101d93:	89 04 24             	mov    %eax,(%esp)
  101d96:	e8 d5 fe ff ff       	call   101c70 <trap_dispatch>
}
  101d9b:	c9                   	leave  
  101d9c:	c3                   	ret    

00101d9d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d9d:	6a 00                	push   $0x0
  pushl $0
  101d9f:	6a 00                	push   $0x0
  jmp __alltraps
  101da1:	e9 69 0a 00 00       	jmp    10280f <__alltraps>

00101da6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da6:	6a 00                	push   $0x0
  pushl $1
  101da8:	6a 01                	push   $0x1
  jmp __alltraps
  101daa:	e9 60 0a 00 00       	jmp    10280f <__alltraps>

00101daf <vector2>:
.globl vector2
vector2:
  pushl $0
  101daf:	6a 00                	push   $0x0
  pushl $2
  101db1:	6a 02                	push   $0x2
  jmp __alltraps
  101db3:	e9 57 0a 00 00       	jmp    10280f <__alltraps>

00101db8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $3
  101dba:	6a 03                	push   $0x3
  jmp __alltraps
  101dbc:	e9 4e 0a 00 00       	jmp    10280f <__alltraps>

00101dc1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101dc1:	6a 00                	push   $0x0
  pushl $4
  101dc3:	6a 04                	push   $0x4
  jmp __alltraps
  101dc5:	e9 45 0a 00 00       	jmp    10280f <__alltraps>

00101dca <vector5>:
.globl vector5
vector5:
  pushl $0
  101dca:	6a 00                	push   $0x0
  pushl $5
  101dcc:	6a 05                	push   $0x5
  jmp __alltraps
  101dce:	e9 3c 0a 00 00       	jmp    10280f <__alltraps>

00101dd3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101dd3:	6a 00                	push   $0x0
  pushl $6
  101dd5:	6a 06                	push   $0x6
  jmp __alltraps
  101dd7:	e9 33 0a 00 00       	jmp    10280f <__alltraps>

00101ddc <vector7>:
.globl vector7
vector7:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $7
  101dde:	6a 07                	push   $0x7
  jmp __alltraps
  101de0:	e9 2a 0a 00 00       	jmp    10280f <__alltraps>

00101de5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de5:	6a 08                	push   $0x8
  jmp __alltraps
  101de7:	e9 23 0a 00 00       	jmp    10280f <__alltraps>

00101dec <vector9>:
.globl vector9
vector9:
  pushl $0
  101dec:	6a 00                	push   $0x0
  pushl $9
  101dee:	6a 09                	push   $0x9
  jmp __alltraps
  101df0:	e9 1a 0a 00 00       	jmp    10280f <__alltraps>

00101df5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101df5:	6a 0a                	push   $0xa
  jmp __alltraps
  101df7:	e9 13 0a 00 00       	jmp    10280f <__alltraps>

00101dfc <vector11>:
.globl vector11
vector11:
  pushl $11
  101dfc:	6a 0b                	push   $0xb
  jmp __alltraps
  101dfe:	e9 0c 0a 00 00       	jmp    10280f <__alltraps>

00101e03 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e03:	6a 0c                	push   $0xc
  jmp __alltraps
  101e05:	e9 05 0a 00 00       	jmp    10280f <__alltraps>

00101e0a <vector13>:
.globl vector13
vector13:
  pushl $13
  101e0a:	6a 0d                	push   $0xd
  jmp __alltraps
  101e0c:	e9 fe 09 00 00       	jmp    10280f <__alltraps>

00101e11 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e11:	6a 0e                	push   $0xe
  jmp __alltraps
  101e13:	e9 f7 09 00 00       	jmp    10280f <__alltraps>

00101e18 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $15
  101e1a:	6a 0f                	push   $0xf
  jmp __alltraps
  101e1c:	e9 ee 09 00 00       	jmp    10280f <__alltraps>

00101e21 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $16
  101e23:	6a 10                	push   $0x10
  jmp __alltraps
  101e25:	e9 e5 09 00 00       	jmp    10280f <__alltraps>

00101e2a <vector17>:
.globl vector17
vector17:
  pushl $17
  101e2a:	6a 11                	push   $0x11
  jmp __alltraps
  101e2c:	e9 de 09 00 00       	jmp    10280f <__alltraps>

00101e31 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $18
  101e33:	6a 12                	push   $0x12
  jmp __alltraps
  101e35:	e9 d5 09 00 00       	jmp    10280f <__alltraps>

00101e3a <vector19>:
.globl vector19
vector19:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $19
  101e3c:	6a 13                	push   $0x13
  jmp __alltraps
  101e3e:	e9 cc 09 00 00       	jmp    10280f <__alltraps>

00101e43 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $20
  101e45:	6a 14                	push   $0x14
  jmp __alltraps
  101e47:	e9 c3 09 00 00       	jmp    10280f <__alltraps>

00101e4c <vector21>:
.globl vector21
vector21:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $21
  101e4e:	6a 15                	push   $0x15
  jmp __alltraps
  101e50:	e9 ba 09 00 00       	jmp    10280f <__alltraps>

00101e55 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $22
  101e57:	6a 16                	push   $0x16
  jmp __alltraps
  101e59:	e9 b1 09 00 00       	jmp    10280f <__alltraps>

00101e5e <vector23>:
.globl vector23
vector23:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $23
  101e60:	6a 17                	push   $0x17
  jmp __alltraps
  101e62:	e9 a8 09 00 00       	jmp    10280f <__alltraps>

00101e67 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $24
  101e69:	6a 18                	push   $0x18
  jmp __alltraps
  101e6b:	e9 9f 09 00 00       	jmp    10280f <__alltraps>

00101e70 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $25
  101e72:	6a 19                	push   $0x19
  jmp __alltraps
  101e74:	e9 96 09 00 00       	jmp    10280f <__alltraps>

00101e79 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $26
  101e7b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e7d:	e9 8d 09 00 00       	jmp    10280f <__alltraps>

00101e82 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $27
  101e84:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e86:	e9 84 09 00 00       	jmp    10280f <__alltraps>

00101e8b <vector28>:
.globl vector28
vector28:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $28
  101e8d:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e8f:	e9 7b 09 00 00       	jmp    10280f <__alltraps>

00101e94 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e94:	6a 00                	push   $0x0
  pushl $29
  101e96:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e98:	e9 72 09 00 00       	jmp    10280f <__alltraps>

00101e9d <vector30>:
.globl vector30
vector30:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $30
  101e9f:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ea1:	e9 69 09 00 00       	jmp    10280f <__alltraps>

00101ea6 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $31
  101ea8:	6a 1f                	push   $0x1f
  jmp __alltraps
  101eaa:	e9 60 09 00 00       	jmp    10280f <__alltraps>

00101eaf <vector32>:
.globl vector32
vector32:
  pushl $0
  101eaf:	6a 00                	push   $0x0
  pushl $32
  101eb1:	6a 20                	push   $0x20
  jmp __alltraps
  101eb3:	e9 57 09 00 00       	jmp    10280f <__alltraps>

00101eb8 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb8:	6a 00                	push   $0x0
  pushl $33
  101eba:	6a 21                	push   $0x21
  jmp __alltraps
  101ebc:	e9 4e 09 00 00       	jmp    10280f <__alltraps>

00101ec1 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $34
  101ec3:	6a 22                	push   $0x22
  jmp __alltraps
  101ec5:	e9 45 09 00 00       	jmp    10280f <__alltraps>

00101eca <vector35>:
.globl vector35
vector35:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $35
  101ecc:	6a 23                	push   $0x23
  jmp __alltraps
  101ece:	e9 3c 09 00 00       	jmp    10280f <__alltraps>

00101ed3 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $36
  101ed5:	6a 24                	push   $0x24
  jmp __alltraps
  101ed7:	e9 33 09 00 00       	jmp    10280f <__alltraps>

00101edc <vector37>:
.globl vector37
vector37:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $37
  101ede:	6a 25                	push   $0x25
  jmp __alltraps
  101ee0:	e9 2a 09 00 00       	jmp    10280f <__alltraps>

00101ee5 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $38
  101ee7:	6a 26                	push   $0x26
  jmp __alltraps
  101ee9:	e9 21 09 00 00       	jmp    10280f <__alltraps>

00101eee <vector39>:
.globl vector39
vector39:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $39
  101ef0:	6a 27                	push   $0x27
  jmp __alltraps
  101ef2:	e9 18 09 00 00       	jmp    10280f <__alltraps>

00101ef7 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $40
  101ef9:	6a 28                	push   $0x28
  jmp __alltraps
  101efb:	e9 0f 09 00 00       	jmp    10280f <__alltraps>

00101f00 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $41
  101f02:	6a 29                	push   $0x29
  jmp __alltraps
  101f04:	e9 06 09 00 00       	jmp    10280f <__alltraps>

00101f09 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $42
  101f0b:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f0d:	e9 fd 08 00 00       	jmp    10280f <__alltraps>

00101f12 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $43
  101f14:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f16:	e9 f4 08 00 00       	jmp    10280f <__alltraps>

00101f1b <vector44>:
.globl vector44
vector44:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $44
  101f1d:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f1f:	e9 eb 08 00 00       	jmp    10280f <__alltraps>

00101f24 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $45
  101f26:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f28:	e9 e2 08 00 00       	jmp    10280f <__alltraps>

00101f2d <vector46>:
.globl vector46
vector46:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $46
  101f2f:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f31:	e9 d9 08 00 00       	jmp    10280f <__alltraps>

00101f36 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $47
  101f38:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f3a:	e9 d0 08 00 00       	jmp    10280f <__alltraps>

00101f3f <vector48>:
.globl vector48
vector48:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $48
  101f41:	6a 30                	push   $0x30
  jmp __alltraps
  101f43:	e9 c7 08 00 00       	jmp    10280f <__alltraps>

00101f48 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $49
  101f4a:	6a 31                	push   $0x31
  jmp __alltraps
  101f4c:	e9 be 08 00 00       	jmp    10280f <__alltraps>

00101f51 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $50
  101f53:	6a 32                	push   $0x32
  jmp __alltraps
  101f55:	e9 b5 08 00 00       	jmp    10280f <__alltraps>

00101f5a <vector51>:
.globl vector51
vector51:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $51
  101f5c:	6a 33                	push   $0x33
  jmp __alltraps
  101f5e:	e9 ac 08 00 00       	jmp    10280f <__alltraps>

00101f63 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $52
  101f65:	6a 34                	push   $0x34
  jmp __alltraps
  101f67:	e9 a3 08 00 00       	jmp    10280f <__alltraps>

00101f6c <vector53>:
.globl vector53
vector53:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $53
  101f6e:	6a 35                	push   $0x35
  jmp __alltraps
  101f70:	e9 9a 08 00 00       	jmp    10280f <__alltraps>

00101f75 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $54
  101f77:	6a 36                	push   $0x36
  jmp __alltraps
  101f79:	e9 91 08 00 00       	jmp    10280f <__alltraps>

00101f7e <vector55>:
.globl vector55
vector55:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $55
  101f80:	6a 37                	push   $0x37
  jmp __alltraps
  101f82:	e9 88 08 00 00       	jmp    10280f <__alltraps>

00101f87 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $56
  101f89:	6a 38                	push   $0x38
  jmp __alltraps
  101f8b:	e9 7f 08 00 00       	jmp    10280f <__alltraps>

00101f90 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $57
  101f92:	6a 39                	push   $0x39
  jmp __alltraps
  101f94:	e9 76 08 00 00       	jmp    10280f <__alltraps>

00101f99 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $58
  101f9b:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f9d:	e9 6d 08 00 00       	jmp    10280f <__alltraps>

00101fa2 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $59
  101fa4:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fa6:	e9 64 08 00 00       	jmp    10280f <__alltraps>

00101fab <vector60>:
.globl vector60
vector60:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $60
  101fad:	6a 3c                	push   $0x3c
  jmp __alltraps
  101faf:	e9 5b 08 00 00       	jmp    10280f <__alltraps>

00101fb4 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $61
  101fb6:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb8:	e9 52 08 00 00       	jmp    10280f <__alltraps>

00101fbd <vector62>:
.globl vector62
vector62:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $62
  101fbf:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fc1:	e9 49 08 00 00       	jmp    10280f <__alltraps>

00101fc6 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $63
  101fc8:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fca:	e9 40 08 00 00       	jmp    10280f <__alltraps>

00101fcf <vector64>:
.globl vector64
vector64:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $64
  101fd1:	6a 40                	push   $0x40
  jmp __alltraps
  101fd3:	e9 37 08 00 00       	jmp    10280f <__alltraps>

00101fd8 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $65
  101fda:	6a 41                	push   $0x41
  jmp __alltraps
  101fdc:	e9 2e 08 00 00       	jmp    10280f <__alltraps>

00101fe1 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $66
  101fe3:	6a 42                	push   $0x42
  jmp __alltraps
  101fe5:	e9 25 08 00 00       	jmp    10280f <__alltraps>

00101fea <vector67>:
.globl vector67
vector67:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $67
  101fec:	6a 43                	push   $0x43
  jmp __alltraps
  101fee:	e9 1c 08 00 00       	jmp    10280f <__alltraps>

00101ff3 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $68
  101ff5:	6a 44                	push   $0x44
  jmp __alltraps
  101ff7:	e9 13 08 00 00       	jmp    10280f <__alltraps>

00101ffc <vector69>:
.globl vector69
vector69:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $69
  101ffe:	6a 45                	push   $0x45
  jmp __alltraps
  102000:	e9 0a 08 00 00       	jmp    10280f <__alltraps>

00102005 <vector70>:
.globl vector70
vector70:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $70
  102007:	6a 46                	push   $0x46
  jmp __alltraps
  102009:	e9 01 08 00 00       	jmp    10280f <__alltraps>

0010200e <vector71>:
.globl vector71
vector71:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $71
  102010:	6a 47                	push   $0x47
  jmp __alltraps
  102012:	e9 f8 07 00 00       	jmp    10280f <__alltraps>

00102017 <vector72>:
.globl vector72
vector72:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $72
  102019:	6a 48                	push   $0x48
  jmp __alltraps
  10201b:	e9 ef 07 00 00       	jmp    10280f <__alltraps>

00102020 <vector73>:
.globl vector73
vector73:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $73
  102022:	6a 49                	push   $0x49
  jmp __alltraps
  102024:	e9 e6 07 00 00       	jmp    10280f <__alltraps>

00102029 <vector74>:
.globl vector74
vector74:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $74
  10202b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10202d:	e9 dd 07 00 00       	jmp    10280f <__alltraps>

00102032 <vector75>:
.globl vector75
vector75:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $75
  102034:	6a 4b                	push   $0x4b
  jmp __alltraps
  102036:	e9 d4 07 00 00       	jmp    10280f <__alltraps>

0010203b <vector76>:
.globl vector76
vector76:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $76
  10203d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10203f:	e9 cb 07 00 00       	jmp    10280f <__alltraps>

00102044 <vector77>:
.globl vector77
vector77:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $77
  102046:	6a 4d                	push   $0x4d
  jmp __alltraps
  102048:	e9 c2 07 00 00       	jmp    10280f <__alltraps>

0010204d <vector78>:
.globl vector78
vector78:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $78
  10204f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102051:	e9 b9 07 00 00       	jmp    10280f <__alltraps>

00102056 <vector79>:
.globl vector79
vector79:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $79
  102058:	6a 4f                	push   $0x4f
  jmp __alltraps
  10205a:	e9 b0 07 00 00       	jmp    10280f <__alltraps>

0010205f <vector80>:
.globl vector80
vector80:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $80
  102061:	6a 50                	push   $0x50
  jmp __alltraps
  102063:	e9 a7 07 00 00       	jmp    10280f <__alltraps>

00102068 <vector81>:
.globl vector81
vector81:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $81
  10206a:	6a 51                	push   $0x51
  jmp __alltraps
  10206c:	e9 9e 07 00 00       	jmp    10280f <__alltraps>

00102071 <vector82>:
.globl vector82
vector82:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $82
  102073:	6a 52                	push   $0x52
  jmp __alltraps
  102075:	e9 95 07 00 00       	jmp    10280f <__alltraps>

0010207a <vector83>:
.globl vector83
vector83:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $83
  10207c:	6a 53                	push   $0x53
  jmp __alltraps
  10207e:	e9 8c 07 00 00       	jmp    10280f <__alltraps>

00102083 <vector84>:
.globl vector84
vector84:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $84
  102085:	6a 54                	push   $0x54
  jmp __alltraps
  102087:	e9 83 07 00 00       	jmp    10280f <__alltraps>

0010208c <vector85>:
.globl vector85
vector85:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $85
  10208e:	6a 55                	push   $0x55
  jmp __alltraps
  102090:	e9 7a 07 00 00       	jmp    10280f <__alltraps>

00102095 <vector86>:
.globl vector86
vector86:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $86
  102097:	6a 56                	push   $0x56
  jmp __alltraps
  102099:	e9 71 07 00 00       	jmp    10280f <__alltraps>

0010209e <vector87>:
.globl vector87
vector87:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $87
  1020a0:	6a 57                	push   $0x57
  jmp __alltraps
  1020a2:	e9 68 07 00 00       	jmp    10280f <__alltraps>

001020a7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $88
  1020a9:	6a 58                	push   $0x58
  jmp __alltraps
  1020ab:	e9 5f 07 00 00       	jmp    10280f <__alltraps>

001020b0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $89
  1020b2:	6a 59                	push   $0x59
  jmp __alltraps
  1020b4:	e9 56 07 00 00       	jmp    10280f <__alltraps>

001020b9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $90
  1020bb:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020bd:	e9 4d 07 00 00       	jmp    10280f <__alltraps>

001020c2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $91
  1020c4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020c6:	e9 44 07 00 00       	jmp    10280f <__alltraps>

001020cb <vector92>:
.globl vector92
vector92:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $92
  1020cd:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020cf:	e9 3b 07 00 00       	jmp    10280f <__alltraps>

001020d4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $93
  1020d6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d8:	e9 32 07 00 00       	jmp    10280f <__alltraps>

001020dd <vector94>:
.globl vector94
vector94:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $94
  1020df:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020e1:	e9 29 07 00 00       	jmp    10280f <__alltraps>

001020e6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $95
  1020e8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020ea:	e9 20 07 00 00       	jmp    10280f <__alltraps>

001020ef <vector96>:
.globl vector96
vector96:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $96
  1020f1:	6a 60                	push   $0x60
  jmp __alltraps
  1020f3:	e9 17 07 00 00       	jmp    10280f <__alltraps>

001020f8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $97
  1020fa:	6a 61                	push   $0x61
  jmp __alltraps
  1020fc:	e9 0e 07 00 00       	jmp    10280f <__alltraps>

00102101 <vector98>:
.globl vector98
vector98:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $98
  102103:	6a 62                	push   $0x62
  jmp __alltraps
  102105:	e9 05 07 00 00       	jmp    10280f <__alltraps>

0010210a <vector99>:
.globl vector99
vector99:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $99
  10210c:	6a 63                	push   $0x63
  jmp __alltraps
  10210e:	e9 fc 06 00 00       	jmp    10280f <__alltraps>

00102113 <vector100>:
.globl vector100
vector100:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $100
  102115:	6a 64                	push   $0x64
  jmp __alltraps
  102117:	e9 f3 06 00 00       	jmp    10280f <__alltraps>

0010211c <vector101>:
.globl vector101
vector101:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $101
  10211e:	6a 65                	push   $0x65
  jmp __alltraps
  102120:	e9 ea 06 00 00       	jmp    10280f <__alltraps>

00102125 <vector102>:
.globl vector102
vector102:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $102
  102127:	6a 66                	push   $0x66
  jmp __alltraps
  102129:	e9 e1 06 00 00       	jmp    10280f <__alltraps>

0010212e <vector103>:
.globl vector103
vector103:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $103
  102130:	6a 67                	push   $0x67
  jmp __alltraps
  102132:	e9 d8 06 00 00       	jmp    10280f <__alltraps>

00102137 <vector104>:
.globl vector104
vector104:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $104
  102139:	6a 68                	push   $0x68
  jmp __alltraps
  10213b:	e9 cf 06 00 00       	jmp    10280f <__alltraps>

00102140 <vector105>:
.globl vector105
vector105:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $105
  102142:	6a 69                	push   $0x69
  jmp __alltraps
  102144:	e9 c6 06 00 00       	jmp    10280f <__alltraps>

00102149 <vector106>:
.globl vector106
vector106:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $106
  10214b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10214d:	e9 bd 06 00 00       	jmp    10280f <__alltraps>

00102152 <vector107>:
.globl vector107
vector107:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $107
  102154:	6a 6b                	push   $0x6b
  jmp __alltraps
  102156:	e9 b4 06 00 00       	jmp    10280f <__alltraps>

0010215b <vector108>:
.globl vector108
vector108:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $108
  10215d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10215f:	e9 ab 06 00 00       	jmp    10280f <__alltraps>

00102164 <vector109>:
.globl vector109
vector109:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $109
  102166:	6a 6d                	push   $0x6d
  jmp __alltraps
  102168:	e9 a2 06 00 00       	jmp    10280f <__alltraps>

0010216d <vector110>:
.globl vector110
vector110:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $110
  10216f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102171:	e9 99 06 00 00       	jmp    10280f <__alltraps>

00102176 <vector111>:
.globl vector111
vector111:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $111
  102178:	6a 6f                	push   $0x6f
  jmp __alltraps
  10217a:	e9 90 06 00 00       	jmp    10280f <__alltraps>

0010217f <vector112>:
.globl vector112
vector112:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $112
  102181:	6a 70                	push   $0x70
  jmp __alltraps
  102183:	e9 87 06 00 00       	jmp    10280f <__alltraps>

00102188 <vector113>:
.globl vector113
vector113:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $113
  10218a:	6a 71                	push   $0x71
  jmp __alltraps
  10218c:	e9 7e 06 00 00       	jmp    10280f <__alltraps>

00102191 <vector114>:
.globl vector114
vector114:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $114
  102193:	6a 72                	push   $0x72
  jmp __alltraps
  102195:	e9 75 06 00 00       	jmp    10280f <__alltraps>

0010219a <vector115>:
.globl vector115
vector115:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $115
  10219c:	6a 73                	push   $0x73
  jmp __alltraps
  10219e:	e9 6c 06 00 00       	jmp    10280f <__alltraps>

001021a3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $116
  1021a5:	6a 74                	push   $0x74
  jmp __alltraps
  1021a7:	e9 63 06 00 00       	jmp    10280f <__alltraps>

001021ac <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $117
  1021ae:	6a 75                	push   $0x75
  jmp __alltraps
  1021b0:	e9 5a 06 00 00       	jmp    10280f <__alltraps>

001021b5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $118
  1021b7:	6a 76                	push   $0x76
  jmp __alltraps
  1021b9:	e9 51 06 00 00       	jmp    10280f <__alltraps>

001021be <vector119>:
.globl vector119
vector119:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $119
  1021c0:	6a 77                	push   $0x77
  jmp __alltraps
  1021c2:	e9 48 06 00 00       	jmp    10280f <__alltraps>

001021c7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $120
  1021c9:	6a 78                	push   $0x78
  jmp __alltraps
  1021cb:	e9 3f 06 00 00       	jmp    10280f <__alltraps>

001021d0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $121
  1021d2:	6a 79                	push   $0x79
  jmp __alltraps
  1021d4:	e9 36 06 00 00       	jmp    10280f <__alltraps>

001021d9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $122
  1021db:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021dd:	e9 2d 06 00 00       	jmp    10280f <__alltraps>

001021e2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $123
  1021e4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021e6:	e9 24 06 00 00       	jmp    10280f <__alltraps>

001021eb <vector124>:
.globl vector124
vector124:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $124
  1021ed:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021ef:	e9 1b 06 00 00       	jmp    10280f <__alltraps>

001021f4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $125
  1021f6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f8:	e9 12 06 00 00       	jmp    10280f <__alltraps>

001021fd <vector126>:
.globl vector126
vector126:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $126
  1021ff:	6a 7e                	push   $0x7e
  jmp __alltraps
  102201:	e9 09 06 00 00       	jmp    10280f <__alltraps>

00102206 <vector127>:
.globl vector127
vector127:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $127
  102208:	6a 7f                	push   $0x7f
  jmp __alltraps
  10220a:	e9 00 06 00 00       	jmp    10280f <__alltraps>

0010220f <vector128>:
.globl vector128
vector128:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $128
  102211:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102216:	e9 f4 05 00 00       	jmp    10280f <__alltraps>

0010221b <vector129>:
.globl vector129
vector129:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $129
  10221d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102222:	e9 e8 05 00 00       	jmp    10280f <__alltraps>

00102227 <vector130>:
.globl vector130
vector130:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $130
  102229:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10222e:	e9 dc 05 00 00       	jmp    10280f <__alltraps>

00102233 <vector131>:
.globl vector131
vector131:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $131
  102235:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10223a:	e9 d0 05 00 00       	jmp    10280f <__alltraps>

0010223f <vector132>:
.globl vector132
vector132:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $132
  102241:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102246:	e9 c4 05 00 00       	jmp    10280f <__alltraps>

0010224b <vector133>:
.globl vector133
vector133:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $133
  10224d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102252:	e9 b8 05 00 00       	jmp    10280f <__alltraps>

00102257 <vector134>:
.globl vector134
vector134:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $134
  102259:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10225e:	e9 ac 05 00 00       	jmp    10280f <__alltraps>

00102263 <vector135>:
.globl vector135
vector135:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $135
  102265:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10226a:	e9 a0 05 00 00       	jmp    10280f <__alltraps>

0010226f <vector136>:
.globl vector136
vector136:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $136
  102271:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102276:	e9 94 05 00 00       	jmp    10280f <__alltraps>

0010227b <vector137>:
.globl vector137
vector137:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $137
  10227d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102282:	e9 88 05 00 00       	jmp    10280f <__alltraps>

00102287 <vector138>:
.globl vector138
vector138:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $138
  102289:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10228e:	e9 7c 05 00 00       	jmp    10280f <__alltraps>

00102293 <vector139>:
.globl vector139
vector139:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $139
  102295:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10229a:	e9 70 05 00 00       	jmp    10280f <__alltraps>

0010229f <vector140>:
.globl vector140
vector140:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $140
  1022a1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022a6:	e9 64 05 00 00       	jmp    10280f <__alltraps>

001022ab <vector141>:
.globl vector141
vector141:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $141
  1022ad:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022b2:	e9 58 05 00 00       	jmp    10280f <__alltraps>

001022b7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $142
  1022b9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022be:	e9 4c 05 00 00       	jmp    10280f <__alltraps>

001022c3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $143
  1022c5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022ca:	e9 40 05 00 00       	jmp    10280f <__alltraps>

001022cf <vector144>:
.globl vector144
vector144:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $144
  1022d1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022d6:	e9 34 05 00 00       	jmp    10280f <__alltraps>

001022db <vector145>:
.globl vector145
vector145:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $145
  1022dd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022e2:	e9 28 05 00 00       	jmp    10280f <__alltraps>

001022e7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $146
  1022e9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022ee:	e9 1c 05 00 00       	jmp    10280f <__alltraps>

001022f3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $147
  1022f5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022fa:	e9 10 05 00 00       	jmp    10280f <__alltraps>

001022ff <vector148>:
.globl vector148
vector148:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $148
  102301:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102306:	e9 04 05 00 00       	jmp    10280f <__alltraps>

0010230b <vector149>:
.globl vector149
vector149:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $149
  10230d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102312:	e9 f8 04 00 00       	jmp    10280f <__alltraps>

00102317 <vector150>:
.globl vector150
vector150:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $150
  102319:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10231e:	e9 ec 04 00 00       	jmp    10280f <__alltraps>

00102323 <vector151>:
.globl vector151
vector151:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $151
  102325:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10232a:	e9 e0 04 00 00       	jmp    10280f <__alltraps>

0010232f <vector152>:
.globl vector152
vector152:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $152
  102331:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102336:	e9 d4 04 00 00       	jmp    10280f <__alltraps>

0010233b <vector153>:
.globl vector153
vector153:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $153
  10233d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102342:	e9 c8 04 00 00       	jmp    10280f <__alltraps>

00102347 <vector154>:
.globl vector154
vector154:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $154
  102349:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10234e:	e9 bc 04 00 00       	jmp    10280f <__alltraps>

00102353 <vector155>:
.globl vector155
vector155:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $155
  102355:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10235a:	e9 b0 04 00 00       	jmp    10280f <__alltraps>

0010235f <vector156>:
.globl vector156
vector156:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $156
  102361:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102366:	e9 a4 04 00 00       	jmp    10280f <__alltraps>

0010236b <vector157>:
.globl vector157
vector157:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $157
  10236d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102372:	e9 98 04 00 00       	jmp    10280f <__alltraps>

00102377 <vector158>:
.globl vector158
vector158:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $158
  102379:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10237e:	e9 8c 04 00 00       	jmp    10280f <__alltraps>

00102383 <vector159>:
.globl vector159
vector159:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $159
  102385:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10238a:	e9 80 04 00 00       	jmp    10280f <__alltraps>

0010238f <vector160>:
.globl vector160
vector160:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $160
  102391:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102396:	e9 74 04 00 00       	jmp    10280f <__alltraps>

0010239b <vector161>:
.globl vector161
vector161:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $161
  10239d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023a2:	e9 68 04 00 00       	jmp    10280f <__alltraps>

001023a7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $162
  1023a9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023ae:	e9 5c 04 00 00       	jmp    10280f <__alltraps>

001023b3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $163
  1023b5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023ba:	e9 50 04 00 00       	jmp    10280f <__alltraps>

001023bf <vector164>:
.globl vector164
vector164:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $164
  1023c1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023c6:	e9 44 04 00 00       	jmp    10280f <__alltraps>

001023cb <vector165>:
.globl vector165
vector165:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $165
  1023cd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023d2:	e9 38 04 00 00       	jmp    10280f <__alltraps>

001023d7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $166
  1023d9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023de:	e9 2c 04 00 00       	jmp    10280f <__alltraps>

001023e3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $167
  1023e5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023ea:	e9 20 04 00 00       	jmp    10280f <__alltraps>

001023ef <vector168>:
.globl vector168
vector168:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $168
  1023f1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023f6:	e9 14 04 00 00       	jmp    10280f <__alltraps>

001023fb <vector169>:
.globl vector169
vector169:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $169
  1023fd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102402:	e9 08 04 00 00       	jmp    10280f <__alltraps>

00102407 <vector170>:
.globl vector170
vector170:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $170
  102409:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10240e:	e9 fc 03 00 00       	jmp    10280f <__alltraps>

00102413 <vector171>:
.globl vector171
vector171:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $171
  102415:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10241a:	e9 f0 03 00 00       	jmp    10280f <__alltraps>

0010241f <vector172>:
.globl vector172
vector172:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $172
  102421:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102426:	e9 e4 03 00 00       	jmp    10280f <__alltraps>

0010242b <vector173>:
.globl vector173
vector173:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $173
  10242d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102432:	e9 d8 03 00 00       	jmp    10280f <__alltraps>

00102437 <vector174>:
.globl vector174
vector174:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $174
  102439:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10243e:	e9 cc 03 00 00       	jmp    10280f <__alltraps>

00102443 <vector175>:
.globl vector175
vector175:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $175
  102445:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10244a:	e9 c0 03 00 00       	jmp    10280f <__alltraps>

0010244f <vector176>:
.globl vector176
vector176:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $176
  102451:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102456:	e9 b4 03 00 00       	jmp    10280f <__alltraps>

0010245b <vector177>:
.globl vector177
vector177:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $177
  10245d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102462:	e9 a8 03 00 00       	jmp    10280f <__alltraps>

00102467 <vector178>:
.globl vector178
vector178:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $178
  102469:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10246e:	e9 9c 03 00 00       	jmp    10280f <__alltraps>

00102473 <vector179>:
.globl vector179
vector179:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $179
  102475:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10247a:	e9 90 03 00 00       	jmp    10280f <__alltraps>

0010247f <vector180>:
.globl vector180
vector180:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $180
  102481:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102486:	e9 84 03 00 00       	jmp    10280f <__alltraps>

0010248b <vector181>:
.globl vector181
vector181:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $181
  10248d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102492:	e9 78 03 00 00       	jmp    10280f <__alltraps>

00102497 <vector182>:
.globl vector182
vector182:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $182
  102499:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10249e:	e9 6c 03 00 00       	jmp    10280f <__alltraps>

001024a3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $183
  1024a5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024aa:	e9 60 03 00 00       	jmp    10280f <__alltraps>

001024af <vector184>:
.globl vector184
vector184:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $184
  1024b1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024b6:	e9 54 03 00 00       	jmp    10280f <__alltraps>

001024bb <vector185>:
.globl vector185
vector185:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $185
  1024bd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024c2:	e9 48 03 00 00       	jmp    10280f <__alltraps>

001024c7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $186
  1024c9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ce:	e9 3c 03 00 00       	jmp    10280f <__alltraps>

001024d3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $187
  1024d5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024da:	e9 30 03 00 00       	jmp    10280f <__alltraps>

001024df <vector188>:
.globl vector188
vector188:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $188
  1024e1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024e6:	e9 24 03 00 00       	jmp    10280f <__alltraps>

001024eb <vector189>:
.globl vector189
vector189:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $189
  1024ed:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024f2:	e9 18 03 00 00       	jmp    10280f <__alltraps>

001024f7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $190
  1024f9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024fe:	e9 0c 03 00 00       	jmp    10280f <__alltraps>

00102503 <vector191>:
.globl vector191
vector191:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $191
  102505:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10250a:	e9 00 03 00 00       	jmp    10280f <__alltraps>

0010250f <vector192>:
.globl vector192
vector192:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $192
  102511:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102516:	e9 f4 02 00 00       	jmp    10280f <__alltraps>

0010251b <vector193>:
.globl vector193
vector193:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $193
  10251d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102522:	e9 e8 02 00 00       	jmp    10280f <__alltraps>

00102527 <vector194>:
.globl vector194
vector194:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $194
  102529:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10252e:	e9 dc 02 00 00       	jmp    10280f <__alltraps>

00102533 <vector195>:
.globl vector195
vector195:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $195
  102535:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10253a:	e9 d0 02 00 00       	jmp    10280f <__alltraps>

0010253f <vector196>:
.globl vector196
vector196:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $196
  102541:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102546:	e9 c4 02 00 00       	jmp    10280f <__alltraps>

0010254b <vector197>:
.globl vector197
vector197:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $197
  10254d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102552:	e9 b8 02 00 00       	jmp    10280f <__alltraps>

00102557 <vector198>:
.globl vector198
vector198:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $198
  102559:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10255e:	e9 ac 02 00 00       	jmp    10280f <__alltraps>

00102563 <vector199>:
.globl vector199
vector199:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $199
  102565:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10256a:	e9 a0 02 00 00       	jmp    10280f <__alltraps>

0010256f <vector200>:
.globl vector200
vector200:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $200
  102571:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102576:	e9 94 02 00 00       	jmp    10280f <__alltraps>

0010257b <vector201>:
.globl vector201
vector201:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $201
  10257d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102582:	e9 88 02 00 00       	jmp    10280f <__alltraps>

00102587 <vector202>:
.globl vector202
vector202:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $202
  102589:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10258e:	e9 7c 02 00 00       	jmp    10280f <__alltraps>

00102593 <vector203>:
.globl vector203
vector203:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $203
  102595:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10259a:	e9 70 02 00 00       	jmp    10280f <__alltraps>

0010259f <vector204>:
.globl vector204
vector204:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $204
  1025a1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025a6:	e9 64 02 00 00       	jmp    10280f <__alltraps>

001025ab <vector205>:
.globl vector205
vector205:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $205
  1025ad:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025b2:	e9 58 02 00 00       	jmp    10280f <__alltraps>

001025b7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $206
  1025b9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025be:	e9 4c 02 00 00       	jmp    10280f <__alltraps>

001025c3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $207
  1025c5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025ca:	e9 40 02 00 00       	jmp    10280f <__alltraps>

001025cf <vector208>:
.globl vector208
vector208:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $208
  1025d1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025d6:	e9 34 02 00 00       	jmp    10280f <__alltraps>

001025db <vector209>:
.globl vector209
vector209:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $209
  1025dd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025e2:	e9 28 02 00 00       	jmp    10280f <__alltraps>

001025e7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $210
  1025e9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025ee:	e9 1c 02 00 00       	jmp    10280f <__alltraps>

001025f3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $211
  1025f5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025fa:	e9 10 02 00 00       	jmp    10280f <__alltraps>

001025ff <vector212>:
.globl vector212
vector212:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $212
  102601:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102606:	e9 04 02 00 00       	jmp    10280f <__alltraps>

0010260b <vector213>:
.globl vector213
vector213:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $213
  10260d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102612:	e9 f8 01 00 00       	jmp    10280f <__alltraps>

00102617 <vector214>:
.globl vector214
vector214:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $214
  102619:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10261e:	e9 ec 01 00 00       	jmp    10280f <__alltraps>

00102623 <vector215>:
.globl vector215
vector215:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $215
  102625:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10262a:	e9 e0 01 00 00       	jmp    10280f <__alltraps>

0010262f <vector216>:
.globl vector216
vector216:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $216
  102631:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102636:	e9 d4 01 00 00       	jmp    10280f <__alltraps>

0010263b <vector217>:
.globl vector217
vector217:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $217
  10263d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102642:	e9 c8 01 00 00       	jmp    10280f <__alltraps>

00102647 <vector218>:
.globl vector218
vector218:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $218
  102649:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10264e:	e9 bc 01 00 00       	jmp    10280f <__alltraps>

00102653 <vector219>:
.globl vector219
vector219:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $219
  102655:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10265a:	e9 b0 01 00 00       	jmp    10280f <__alltraps>

0010265f <vector220>:
.globl vector220
vector220:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $220
  102661:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102666:	e9 a4 01 00 00       	jmp    10280f <__alltraps>

0010266b <vector221>:
.globl vector221
vector221:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $221
  10266d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102672:	e9 98 01 00 00       	jmp    10280f <__alltraps>

00102677 <vector222>:
.globl vector222
vector222:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $222
  102679:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10267e:	e9 8c 01 00 00       	jmp    10280f <__alltraps>

00102683 <vector223>:
.globl vector223
vector223:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $223
  102685:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10268a:	e9 80 01 00 00       	jmp    10280f <__alltraps>

0010268f <vector224>:
.globl vector224
vector224:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $224
  102691:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102696:	e9 74 01 00 00       	jmp    10280f <__alltraps>

0010269b <vector225>:
.globl vector225
vector225:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $225
  10269d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026a2:	e9 68 01 00 00       	jmp    10280f <__alltraps>

001026a7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $226
  1026a9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026ae:	e9 5c 01 00 00       	jmp    10280f <__alltraps>

001026b3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $227
  1026b5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026ba:	e9 50 01 00 00       	jmp    10280f <__alltraps>

001026bf <vector228>:
.globl vector228
vector228:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $228
  1026c1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026c6:	e9 44 01 00 00       	jmp    10280f <__alltraps>

001026cb <vector229>:
.globl vector229
vector229:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $229
  1026cd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026d2:	e9 38 01 00 00       	jmp    10280f <__alltraps>

001026d7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $230
  1026d9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026de:	e9 2c 01 00 00       	jmp    10280f <__alltraps>

001026e3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $231
  1026e5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026ea:	e9 20 01 00 00       	jmp    10280f <__alltraps>

001026ef <vector232>:
.globl vector232
vector232:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $232
  1026f1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026f6:	e9 14 01 00 00       	jmp    10280f <__alltraps>

001026fb <vector233>:
.globl vector233
vector233:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $233
  1026fd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102702:	e9 08 01 00 00       	jmp    10280f <__alltraps>

00102707 <vector234>:
.globl vector234
vector234:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $234
  102709:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10270e:	e9 fc 00 00 00       	jmp    10280f <__alltraps>

00102713 <vector235>:
.globl vector235
vector235:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $235
  102715:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10271a:	e9 f0 00 00 00       	jmp    10280f <__alltraps>

0010271f <vector236>:
.globl vector236
vector236:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $236
  102721:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102726:	e9 e4 00 00 00       	jmp    10280f <__alltraps>

0010272b <vector237>:
.globl vector237
vector237:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $237
  10272d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102732:	e9 d8 00 00 00       	jmp    10280f <__alltraps>

00102737 <vector238>:
.globl vector238
vector238:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $238
  102739:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10273e:	e9 cc 00 00 00       	jmp    10280f <__alltraps>

00102743 <vector239>:
.globl vector239
vector239:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $239
  102745:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10274a:	e9 c0 00 00 00       	jmp    10280f <__alltraps>

0010274f <vector240>:
.globl vector240
vector240:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $240
  102751:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102756:	e9 b4 00 00 00       	jmp    10280f <__alltraps>

0010275b <vector241>:
.globl vector241
vector241:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $241
  10275d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102762:	e9 a8 00 00 00       	jmp    10280f <__alltraps>

00102767 <vector242>:
.globl vector242
vector242:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $242
  102769:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10276e:	e9 9c 00 00 00       	jmp    10280f <__alltraps>

00102773 <vector243>:
.globl vector243
vector243:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $243
  102775:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10277a:	e9 90 00 00 00       	jmp    10280f <__alltraps>

0010277f <vector244>:
.globl vector244
vector244:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $244
  102781:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102786:	e9 84 00 00 00       	jmp    10280f <__alltraps>

0010278b <vector245>:
.globl vector245
vector245:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $245
  10278d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102792:	e9 78 00 00 00       	jmp    10280f <__alltraps>

00102797 <vector246>:
.globl vector246
vector246:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $246
  102799:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10279e:	e9 6c 00 00 00       	jmp    10280f <__alltraps>

001027a3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $247
  1027a5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027aa:	e9 60 00 00 00       	jmp    10280f <__alltraps>

001027af <vector248>:
.globl vector248
vector248:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $248
  1027b1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027b6:	e9 54 00 00 00       	jmp    10280f <__alltraps>

001027bb <vector249>:
.globl vector249
vector249:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $249
  1027bd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027c2:	e9 48 00 00 00       	jmp    10280f <__alltraps>

001027c7 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $250
  1027c9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ce:	e9 3c 00 00 00       	jmp    10280f <__alltraps>

001027d3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $251
  1027d5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027da:	e9 30 00 00 00       	jmp    10280f <__alltraps>

001027df <vector252>:
.globl vector252
vector252:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $252
  1027e1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027e6:	e9 24 00 00 00       	jmp    10280f <__alltraps>

001027eb <vector253>:
.globl vector253
vector253:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $253
  1027ed:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027f2:	e9 18 00 00 00       	jmp    10280f <__alltraps>

001027f7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $254
  1027f9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027fe:	e9 0c 00 00 00       	jmp    10280f <__alltraps>

00102803 <vector255>:
.globl vector255
vector255:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $255
  102805:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10280a:	e9 00 00 00 00       	jmp    10280f <__alltraps>

0010280f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10280f:	1e                   	push   %ds
    pushl %es
  102810:	06                   	push   %es
    pushl %fs
  102811:	0f a0                	push   %fs
    pushl %gs
  102813:	0f a8                	push   %gs
    pushal
  102815:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102816:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10281b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10281d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10281f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102820:	e8 65 f5 ff ff       	call   101d8a <trap>

    # pop the pushed stack pointer
    popl %esp
  102825:	5c                   	pop    %esp

00102826 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102826:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102827:	0f a9                	pop    %gs
    popl %fs
  102829:	0f a1                	pop    %fs
    popl %es
  10282b:	07                   	pop    %es
    popl %ds
  10282c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10282d:	83 c4 08             	add    $0x8,%esp
    iret
  102830:	cf                   	iret   

00102831 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102831:	55                   	push   %ebp
  102832:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102834:	8b 45 08             	mov    0x8(%ebp),%eax
  102837:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10283a:	b8 23 00 00 00       	mov    $0x23,%eax
  10283f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102841:	b8 23 00 00 00       	mov    $0x23,%eax
  102846:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102848:	b8 10 00 00 00       	mov    $0x10,%eax
  10284d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10284f:	b8 10 00 00 00       	mov    $0x10,%eax
  102854:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102856:	b8 10 00 00 00       	mov    $0x10,%eax
  10285b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10285d:	ea 64 28 10 00 08 00 	ljmp   $0x8,$0x102864
}
  102864:	5d                   	pop    %ebp
  102865:	c3                   	ret    

00102866 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102866:	55                   	push   %ebp
  102867:	89 e5                	mov    %esp,%ebp
  102869:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10286c:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102871:	05 00 04 00 00       	add    $0x400,%eax
  102876:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10287b:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102882:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102884:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10288b:	68 00 
  10288d:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102892:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102898:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10289d:	c1 e8 10             	shr    $0x10,%eax
  1028a0:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028a5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ac:	83 e0 f0             	and    $0xfffffff0,%eax
  1028af:	83 c8 09             	or     $0x9,%eax
  1028b2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028b7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028be:	83 c8 10             	or     $0x10,%eax
  1028c1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028c6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028cd:	83 e0 9f             	and    $0xffffff9f,%eax
  1028d0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028d5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028dc:	83 c8 80             	or     $0xffffff80,%eax
  1028df:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028e4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028eb:	83 e0 f0             	and    $0xfffffff0,%eax
  1028ee:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f3:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028fa:	83 e0 ef             	and    $0xffffffef,%eax
  1028fd:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102902:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102909:	83 e0 df             	and    $0xffffffdf,%eax
  10290c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102911:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102918:	83 c8 40             	or     $0x40,%eax
  10291b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102920:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102927:	83 e0 7f             	and    $0x7f,%eax
  10292a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10292f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102934:	c1 e8 18             	shr    $0x18,%eax
  102937:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10293c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102943:	83 e0 ef             	and    $0xffffffef,%eax
  102946:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10294b:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102952:	e8 da fe ff ff       	call   102831 <lgdt>
  102957:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10295d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102961:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102964:	c9                   	leave  
  102965:	c3                   	ret    

00102966 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102966:	55                   	push   %ebp
  102967:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102969:	e8 f8 fe ff ff       	call   102866 <gdt_init>
}
  10296e:	5d                   	pop    %ebp
  10296f:	c3                   	ret    

00102970 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102970:	55                   	push   %ebp
  102971:	89 e5                	mov    %esp,%ebp
  102973:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102976:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10297d:	eb 04                	jmp    102983 <strlen+0x13>
        cnt ++;
  10297f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102983:	8b 45 08             	mov    0x8(%ebp),%eax
  102986:	8d 50 01             	lea    0x1(%eax),%edx
  102989:	89 55 08             	mov    %edx,0x8(%ebp)
  10298c:	0f b6 00             	movzbl (%eax),%eax
  10298f:	84 c0                	test   %al,%al
  102991:	75 ec                	jne    10297f <strlen+0xf>
    }
    return cnt;
  102993:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102996:	c9                   	leave  
  102997:	c3                   	ret    

00102998 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102998:	55                   	push   %ebp
  102999:	89 e5                	mov    %esp,%ebp
  10299b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10299e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1029a5:	eb 04                	jmp    1029ab <strnlen+0x13>
        cnt ++;
  1029a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1029ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1029b1:	73 10                	jae    1029c3 <strnlen+0x2b>
  1029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b6:	8d 50 01             	lea    0x1(%eax),%edx
  1029b9:	89 55 08             	mov    %edx,0x8(%ebp)
  1029bc:	0f b6 00             	movzbl (%eax),%eax
  1029bf:	84 c0                	test   %al,%al
  1029c1:	75 e4                	jne    1029a7 <strnlen+0xf>
    }
    return cnt;
  1029c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1029c6:	c9                   	leave  
  1029c7:	c3                   	ret    

001029c8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1029c8:	55                   	push   %ebp
  1029c9:	89 e5                	mov    %esp,%ebp
  1029cb:	57                   	push   %edi
  1029cc:	56                   	push   %esi
  1029cd:	83 ec 20             	sub    $0x20,%esp
  1029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1029dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e2:	89 d1                	mov    %edx,%ecx
  1029e4:	89 c2                	mov    %eax,%edx
  1029e6:	89 ce                	mov    %ecx,%esi
  1029e8:	89 d7                	mov    %edx,%edi
  1029ea:	ac                   	lods   %ds:(%esi),%al
  1029eb:	aa                   	stos   %al,%es:(%edi)
  1029ec:	84 c0                	test   %al,%al
  1029ee:	75 fa                	jne    1029ea <strcpy+0x22>
  1029f0:	89 fa                	mov    %edi,%edx
  1029f2:	89 f1                	mov    %esi,%ecx
  1029f4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1029f7:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1029fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102a00:	83 c4 20             	add    $0x20,%esp
  102a03:	5e                   	pop    %esi
  102a04:	5f                   	pop    %edi
  102a05:	5d                   	pop    %ebp
  102a06:	c3                   	ret    

00102a07 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102a07:	55                   	push   %ebp
  102a08:	89 e5                	mov    %esp,%ebp
  102a0a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a10:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102a13:	eb 21                	jmp    102a36 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a18:	0f b6 10             	movzbl (%eax),%edx
  102a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a1e:	88 10                	mov    %dl,(%eax)
  102a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a23:	0f b6 00             	movzbl (%eax),%eax
  102a26:	84 c0                	test   %al,%al
  102a28:	74 04                	je     102a2e <strncpy+0x27>
            src ++;
  102a2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102a2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102a32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a3a:	75 d9                	jne    102a15 <strncpy+0xe>
    }
    return dst;
  102a3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a3f:	c9                   	leave  
  102a40:	c3                   	ret    

00102a41 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102a41:	55                   	push   %ebp
  102a42:	89 e5                	mov    %esp,%ebp
  102a44:	57                   	push   %edi
  102a45:	56                   	push   %esi
  102a46:	83 ec 20             	sub    $0x20,%esp
  102a49:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a5b:	89 d1                	mov    %edx,%ecx
  102a5d:	89 c2                	mov    %eax,%edx
  102a5f:	89 ce                	mov    %ecx,%esi
  102a61:	89 d7                	mov    %edx,%edi
  102a63:	ac                   	lods   %ds:(%esi),%al
  102a64:	ae                   	scas   %es:(%edi),%al
  102a65:	75 08                	jne    102a6f <strcmp+0x2e>
  102a67:	84 c0                	test   %al,%al
  102a69:	75 f8                	jne    102a63 <strcmp+0x22>
  102a6b:	31 c0                	xor    %eax,%eax
  102a6d:	eb 04                	jmp    102a73 <strcmp+0x32>
  102a6f:	19 c0                	sbb    %eax,%eax
  102a71:	0c 01                	or     $0x1,%al
  102a73:	89 fa                	mov    %edi,%edx
  102a75:	89 f1                	mov    %esi,%ecx
  102a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102a7a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102a7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102a83:	83 c4 20             	add    $0x20,%esp
  102a86:	5e                   	pop    %esi
  102a87:	5f                   	pop    %edi
  102a88:	5d                   	pop    %ebp
  102a89:	c3                   	ret    

00102a8a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102a8a:	55                   	push   %ebp
  102a8b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a8d:	eb 0c                	jmp    102a9b <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102a8f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102a93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a9f:	74 1a                	je     102abb <strncmp+0x31>
  102aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa4:	0f b6 00             	movzbl (%eax),%eax
  102aa7:	84 c0                	test   %al,%al
  102aa9:	74 10                	je     102abb <strncmp+0x31>
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
  102aae:	0f b6 10             	movzbl (%eax),%edx
  102ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab4:	0f b6 00             	movzbl (%eax),%eax
  102ab7:	38 c2                	cmp    %al,%dl
  102ab9:	74 d4                	je     102a8f <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102abb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102abf:	74 18                	je     102ad9 <strncmp+0x4f>
  102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac4:	0f b6 00             	movzbl (%eax),%eax
  102ac7:	0f b6 d0             	movzbl %al,%edx
  102aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102acd:	0f b6 00             	movzbl (%eax),%eax
  102ad0:	0f b6 c0             	movzbl %al,%eax
  102ad3:	29 c2                	sub    %eax,%edx
  102ad5:	89 d0                	mov    %edx,%eax
  102ad7:	eb 05                	jmp    102ade <strncmp+0x54>
  102ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ade:	5d                   	pop    %ebp
  102adf:	c3                   	ret    

00102ae0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102ae0:	55                   	push   %ebp
  102ae1:	89 e5                	mov    %esp,%ebp
  102ae3:	83 ec 04             	sub    $0x4,%esp
  102ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102aec:	eb 14                	jmp    102b02 <strchr+0x22>
        if (*s == c) {
  102aee:	8b 45 08             	mov    0x8(%ebp),%eax
  102af1:	0f b6 00             	movzbl (%eax),%eax
  102af4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102af7:	75 05                	jne    102afe <strchr+0x1e>
            return (char *)s;
  102af9:	8b 45 08             	mov    0x8(%ebp),%eax
  102afc:	eb 13                	jmp    102b11 <strchr+0x31>
        }
        s ++;
  102afe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102b02:	8b 45 08             	mov    0x8(%ebp),%eax
  102b05:	0f b6 00             	movzbl (%eax),%eax
  102b08:	84 c0                	test   %al,%al
  102b0a:	75 e2                	jne    102aee <strchr+0xe>
    }
    return NULL;
  102b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b11:	c9                   	leave  
  102b12:	c3                   	ret    

00102b13 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102b13:	55                   	push   %ebp
  102b14:	89 e5                	mov    %esp,%ebp
  102b16:	83 ec 04             	sub    $0x4,%esp
  102b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b1f:	eb 11                	jmp    102b32 <strfind+0x1f>
        if (*s == c) {
  102b21:	8b 45 08             	mov    0x8(%ebp),%eax
  102b24:	0f b6 00             	movzbl (%eax),%eax
  102b27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b2a:	75 02                	jne    102b2e <strfind+0x1b>
            break;
  102b2c:	eb 0e                	jmp    102b3c <strfind+0x29>
        }
        s ++;
  102b2e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102b32:	8b 45 08             	mov    0x8(%ebp),%eax
  102b35:	0f b6 00             	movzbl (%eax),%eax
  102b38:	84 c0                	test   %al,%al
  102b3a:	75 e5                	jne    102b21 <strfind+0xe>
    }
    return (char *)s;
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b3f:	c9                   	leave  
  102b40:	c3                   	ret    

00102b41 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
  102b44:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102b47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102b4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b55:	eb 04                	jmp    102b5b <strtol+0x1a>
        s ++;
  102b57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5e:	0f b6 00             	movzbl (%eax),%eax
  102b61:	3c 20                	cmp    $0x20,%al
  102b63:	74 f2                	je     102b57 <strtol+0x16>
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	0f b6 00             	movzbl (%eax),%eax
  102b6b:	3c 09                	cmp    $0x9,%al
  102b6d:	74 e8                	je     102b57 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b72:	0f b6 00             	movzbl (%eax),%eax
  102b75:	3c 2b                	cmp    $0x2b,%al
  102b77:	75 06                	jne    102b7f <strtol+0x3e>
        s ++;
  102b79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b7d:	eb 15                	jmp    102b94 <strtol+0x53>
    }
    else if (*s == '-') {
  102b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b82:	0f b6 00             	movzbl (%eax),%eax
  102b85:	3c 2d                	cmp    $0x2d,%al
  102b87:	75 0b                	jne    102b94 <strtol+0x53>
        s ++, neg = 1;
  102b89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102b94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b98:	74 06                	je     102ba0 <strtol+0x5f>
  102b9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102b9e:	75 24                	jne    102bc4 <strtol+0x83>
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	0f b6 00             	movzbl (%eax),%eax
  102ba6:	3c 30                	cmp    $0x30,%al
  102ba8:	75 1a                	jne    102bc4 <strtol+0x83>
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	83 c0 01             	add    $0x1,%eax
  102bb0:	0f b6 00             	movzbl (%eax),%eax
  102bb3:	3c 78                	cmp    $0x78,%al
  102bb5:	75 0d                	jne    102bc4 <strtol+0x83>
        s += 2, base = 16;
  102bb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102bbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102bc2:	eb 2a                	jmp    102bee <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102bc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc8:	75 17                	jne    102be1 <strtol+0xa0>
  102bca:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcd:	0f b6 00             	movzbl (%eax),%eax
  102bd0:	3c 30                	cmp    $0x30,%al
  102bd2:	75 0d                	jne    102be1 <strtol+0xa0>
        s ++, base = 8;
  102bd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bd8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102bdf:	eb 0d                	jmp    102bee <strtol+0xad>
    }
    else if (base == 0) {
  102be1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102be5:	75 07                	jne    102bee <strtol+0xad>
        base = 10;
  102be7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102bee:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf1:	0f b6 00             	movzbl (%eax),%eax
  102bf4:	3c 2f                	cmp    $0x2f,%al
  102bf6:	7e 1b                	jle    102c13 <strtol+0xd2>
  102bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfb:	0f b6 00             	movzbl (%eax),%eax
  102bfe:	3c 39                	cmp    $0x39,%al
  102c00:	7f 11                	jg     102c13 <strtol+0xd2>
            dig = *s - '0';
  102c02:	8b 45 08             	mov    0x8(%ebp),%eax
  102c05:	0f b6 00             	movzbl (%eax),%eax
  102c08:	0f be c0             	movsbl %al,%eax
  102c0b:	83 e8 30             	sub    $0x30,%eax
  102c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c11:	eb 48                	jmp    102c5b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102c13:	8b 45 08             	mov    0x8(%ebp),%eax
  102c16:	0f b6 00             	movzbl (%eax),%eax
  102c19:	3c 60                	cmp    $0x60,%al
  102c1b:	7e 1b                	jle    102c38 <strtol+0xf7>
  102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c20:	0f b6 00             	movzbl (%eax),%eax
  102c23:	3c 7a                	cmp    $0x7a,%al
  102c25:	7f 11                	jg     102c38 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102c27:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2a:	0f b6 00             	movzbl (%eax),%eax
  102c2d:	0f be c0             	movsbl %al,%eax
  102c30:	83 e8 57             	sub    $0x57,%eax
  102c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c36:	eb 23                	jmp    102c5b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102c38:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3b:	0f b6 00             	movzbl (%eax),%eax
  102c3e:	3c 40                	cmp    $0x40,%al
  102c40:	7e 3d                	jle    102c7f <strtol+0x13e>
  102c42:	8b 45 08             	mov    0x8(%ebp),%eax
  102c45:	0f b6 00             	movzbl (%eax),%eax
  102c48:	3c 5a                	cmp    $0x5a,%al
  102c4a:	7f 33                	jg     102c7f <strtol+0x13e>
            dig = *s - 'A' + 10;
  102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4f:	0f b6 00             	movzbl (%eax),%eax
  102c52:	0f be c0             	movsbl %al,%eax
  102c55:	83 e8 37             	sub    $0x37,%eax
  102c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  102c61:	7c 02                	jl     102c65 <strtol+0x124>
            break;
  102c63:	eb 1a                	jmp    102c7f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102c65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  102c70:	89 c2                	mov    %eax,%edx
  102c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c75:	01 d0                	add    %edx,%eax
  102c77:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102c7a:	e9 6f ff ff ff       	jmp    102bee <strtol+0xad>

    if (endptr) {
  102c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c83:	74 08                	je     102c8d <strtol+0x14c>
        *endptr = (char *) s;
  102c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c88:	8b 55 08             	mov    0x8(%ebp),%edx
  102c8b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102c8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102c91:	74 07                	je     102c9a <strtol+0x159>
  102c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c96:	f7 d8                	neg    %eax
  102c98:	eb 03                	jmp    102c9d <strtol+0x15c>
  102c9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102c9d:	c9                   	leave  
  102c9e:	c3                   	ret    

00102c9f <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102c9f:	55                   	push   %ebp
  102ca0:	89 e5                	mov    %esp,%ebp
  102ca2:	57                   	push   %edi
  102ca3:	83 ec 24             	sub    $0x24,%esp
  102ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102cac:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102cb6:	88 45 f7             	mov    %al,-0x9(%ebp)
  102cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  102cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102cbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102cc2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102cc6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102cc9:	89 d7                	mov    %edx,%edi
  102ccb:	f3 aa                	rep stos %al,%es:(%edi)
  102ccd:	89 fa                	mov    %edi,%edx
  102ccf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cd2:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102cd8:	83 c4 24             	add    $0x24,%esp
  102cdb:	5f                   	pop    %edi
  102cdc:	5d                   	pop    %ebp
  102cdd:	c3                   	ret    

00102cde <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102cde:	55                   	push   %ebp
  102cdf:	89 e5                	mov    %esp,%ebp
  102ce1:	57                   	push   %edi
  102ce2:	56                   	push   %esi
  102ce3:	53                   	push   %ebx
  102ce4:	83 ec 30             	sub    $0x30,%esp
  102ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  102cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cff:	73 42                	jae    102d43 <memmove+0x65>
  102d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d10:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d16:	c1 e8 02             	shr    $0x2,%eax
  102d19:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102d1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d21:	89 d7                	mov    %edx,%edi
  102d23:	89 c6                	mov    %eax,%esi
  102d25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d27:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102d2a:	83 e1 03             	and    $0x3,%ecx
  102d2d:	74 02                	je     102d31 <memmove+0x53>
  102d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d31:	89 f0                	mov    %esi,%eax
  102d33:	89 fa                	mov    %edi,%edx
  102d35:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102d38:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d3b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d41:	eb 36                	jmp    102d79 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d46:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d4c:	01 c2                	add    %eax,%edx
  102d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d51:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d57:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102d5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d5d:	89 c1                	mov    %eax,%ecx
  102d5f:	89 d8                	mov    %ebx,%eax
  102d61:	89 d6                	mov    %edx,%esi
  102d63:	89 c7                	mov    %eax,%edi
  102d65:	fd                   	std    
  102d66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d68:	fc                   	cld    
  102d69:	89 f8                	mov    %edi,%eax
  102d6b:	89 f2                	mov    %esi,%edx
  102d6d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102d70:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102d73:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102d79:	83 c4 30             	add    $0x30,%esp
  102d7c:	5b                   	pop    %ebx
  102d7d:	5e                   	pop    %esi
  102d7e:	5f                   	pop    %edi
  102d7f:	5d                   	pop    %ebp
  102d80:	c3                   	ret    

00102d81 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102d81:	55                   	push   %ebp
  102d82:	89 e5                	mov    %esp,%ebp
  102d84:	57                   	push   %edi
  102d85:	56                   	push   %esi
  102d86:	83 ec 20             	sub    $0x20,%esp
  102d89:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d95:	8b 45 10             	mov    0x10(%ebp),%eax
  102d98:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d9e:	c1 e8 02             	shr    $0x2,%eax
  102da1:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da9:	89 d7                	mov    %edx,%edi
  102dab:	89 c6                	mov    %eax,%esi
  102dad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102daf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102db2:	83 e1 03             	and    $0x3,%ecx
  102db5:	74 02                	je     102db9 <memcpy+0x38>
  102db7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102db9:	89 f0                	mov    %esi,%eax
  102dbb:	89 fa                	mov    %edi,%edx
  102dbd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102dc0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102dc9:	83 c4 20             	add    $0x20,%esp
  102dcc:	5e                   	pop    %esi
  102dcd:	5f                   	pop    %edi
  102dce:	5d                   	pop    %ebp
  102dcf:	c3                   	ret    

00102dd0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102dd0:	55                   	push   %ebp
  102dd1:	89 e5                	mov    %esp,%ebp
  102dd3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102de2:	eb 30                	jmp    102e14 <memcmp+0x44>
        if (*s1 != *s2) {
  102de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102de7:	0f b6 10             	movzbl (%eax),%edx
  102dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ded:	0f b6 00             	movzbl (%eax),%eax
  102df0:	38 c2                	cmp    %al,%dl
  102df2:	74 18                	je     102e0c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102df7:	0f b6 00             	movzbl (%eax),%eax
  102dfa:	0f b6 d0             	movzbl %al,%edx
  102dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e00:	0f b6 00             	movzbl (%eax),%eax
  102e03:	0f b6 c0             	movzbl %al,%eax
  102e06:	29 c2                	sub    %eax,%edx
  102e08:	89 d0                	mov    %edx,%eax
  102e0a:	eb 1a                	jmp    102e26 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102e0c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102e10:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102e14:	8b 45 10             	mov    0x10(%ebp),%eax
  102e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  102e1d:	85 c0                	test   %eax,%eax
  102e1f:	75 c3                	jne    102de4 <memcmp+0x14>
    }
    return 0;
  102e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e26:	c9                   	leave  
  102e27:	c3                   	ret    

00102e28 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102e28:	55                   	push   %ebp
  102e29:	89 e5                	mov    %esp,%ebp
  102e2b:	83 ec 58             	sub    $0x58,%esp
  102e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102e31:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e34:	8b 45 14             	mov    0x14(%ebp),%eax
  102e37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102e3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e43:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102e46:	8b 45 18             	mov    0x18(%ebp),%eax
  102e49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e52:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e55:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e62:	74 1c                	je     102e80 <printnum+0x58>
  102e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e67:	ba 00 00 00 00       	mov    $0x0,%edx
  102e6c:	f7 75 e4             	divl   -0x1c(%ebp)
  102e6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e75:	ba 00 00 00 00       	mov    $0x0,%edx
  102e7a:	f7 75 e4             	divl   -0x1c(%ebp)
  102e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e86:	f7 75 e4             	divl   -0x1c(%ebp)
  102e89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e98:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ea1:	8b 45 18             	mov    0x18(%ebp),%eax
  102ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  102ea9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102eac:	77 56                	ja     102f04 <printnum+0xdc>
  102eae:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102eb1:	72 05                	jb     102eb8 <printnum+0x90>
  102eb3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102eb6:	77 4c                	ja     102f04 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102eb8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ebe:	8b 45 20             	mov    0x20(%ebp),%eax
  102ec1:	89 44 24 18          	mov    %eax,0x18(%esp)
  102ec5:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ec9:	8b 45 18             	mov    0x18(%ebp),%eax
  102ecc:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ed3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ed6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102eda:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee8:	89 04 24             	mov    %eax,(%esp)
  102eeb:	e8 38 ff ff ff       	call   102e28 <printnum>
  102ef0:	eb 1c                	jmp    102f0e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef9:	8b 45 20             	mov    0x20(%ebp),%eax
  102efc:	89 04 24             	mov    %eax,(%esp)
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	ff d0                	call   *%eax
        while (-- width > 0)
  102f04:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102f08:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102f0c:	7f e4                	jg     102ef2 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102f0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f11:	05 70 3c 10 00       	add    $0x103c70,%eax
  102f16:	0f b6 00             	movzbl (%eax),%eax
  102f19:	0f be c0             	movsbl %al,%eax
  102f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f1f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f23:	89 04 24             	mov    %eax,(%esp)
  102f26:	8b 45 08             	mov    0x8(%ebp),%eax
  102f29:	ff d0                	call   *%eax
}
  102f2b:	c9                   	leave  
  102f2c:	c3                   	ret    

00102f2d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102f2d:	55                   	push   %ebp
  102f2e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f30:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f34:	7e 14                	jle    102f4a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102f36:	8b 45 08             	mov    0x8(%ebp),%eax
  102f39:	8b 00                	mov    (%eax),%eax
  102f3b:	8d 48 08             	lea    0x8(%eax),%ecx
  102f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  102f41:	89 0a                	mov    %ecx,(%edx)
  102f43:	8b 50 04             	mov    0x4(%eax),%edx
  102f46:	8b 00                	mov    (%eax),%eax
  102f48:	eb 30                	jmp    102f7a <getuint+0x4d>
    }
    else if (lflag) {
  102f4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f4e:	74 16                	je     102f66 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102f50:	8b 45 08             	mov    0x8(%ebp),%eax
  102f53:	8b 00                	mov    (%eax),%eax
  102f55:	8d 48 04             	lea    0x4(%eax),%ecx
  102f58:	8b 55 08             	mov    0x8(%ebp),%edx
  102f5b:	89 0a                	mov    %ecx,(%edx)
  102f5d:	8b 00                	mov    (%eax),%eax
  102f5f:	ba 00 00 00 00       	mov    $0x0,%edx
  102f64:	eb 14                	jmp    102f7a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102f66:	8b 45 08             	mov    0x8(%ebp),%eax
  102f69:	8b 00                	mov    (%eax),%eax
  102f6b:	8d 48 04             	lea    0x4(%eax),%ecx
  102f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  102f71:	89 0a                	mov    %ecx,(%edx)
  102f73:	8b 00                	mov    (%eax),%eax
  102f75:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102f7a:	5d                   	pop    %ebp
  102f7b:	c3                   	ret    

00102f7c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102f7c:	55                   	push   %ebp
  102f7d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f7f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f83:	7e 14                	jle    102f99 <getint+0x1d>
        return va_arg(*ap, long long);
  102f85:	8b 45 08             	mov    0x8(%ebp),%eax
  102f88:	8b 00                	mov    (%eax),%eax
  102f8a:	8d 48 08             	lea    0x8(%eax),%ecx
  102f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102f90:	89 0a                	mov    %ecx,(%edx)
  102f92:	8b 50 04             	mov    0x4(%eax),%edx
  102f95:	8b 00                	mov    (%eax),%eax
  102f97:	eb 28                	jmp    102fc1 <getint+0x45>
    }
    else if (lflag) {
  102f99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f9d:	74 12                	je     102fb1 <getint+0x35>
        return va_arg(*ap, long);
  102f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa2:	8b 00                	mov    (%eax),%eax
  102fa4:	8d 48 04             	lea    0x4(%eax),%ecx
  102fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  102faa:	89 0a                	mov    %ecx,(%edx)
  102fac:	8b 00                	mov    (%eax),%eax
  102fae:	99                   	cltd   
  102faf:	eb 10                	jmp    102fc1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb4:	8b 00                	mov    (%eax),%eax
  102fb6:	8d 48 04             	lea    0x4(%eax),%ecx
  102fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  102fbc:	89 0a                	mov    %ecx,(%edx)
  102fbe:	8b 00                	mov    (%eax),%eax
  102fc0:	99                   	cltd   
    }
}
  102fc1:	5d                   	pop    %ebp
  102fc2:	c3                   	ret    

00102fc3 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102fc3:	55                   	push   %ebp
  102fc4:	89 e5                	mov    %esp,%ebp
  102fc6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102fc9:	8d 45 14             	lea    0x14(%ebp),%eax
  102fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe7:	89 04 24             	mov    %eax,(%esp)
  102fea:	e8 02 00 00 00       	call   102ff1 <vprintfmt>
    va_end(ap);
}
  102fef:	c9                   	leave  
  102ff0:	c3                   	ret    

00102ff1 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102ff1:	55                   	push   %ebp
  102ff2:	89 e5                	mov    %esp,%ebp
  102ff4:	56                   	push   %esi
  102ff5:	53                   	push   %ebx
  102ff6:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ff9:	eb 18                	jmp    103013 <vprintfmt+0x22>
            if (ch == '\0') {
  102ffb:	85 db                	test   %ebx,%ebx
  102ffd:	75 05                	jne    103004 <vprintfmt+0x13>
                return;
  102fff:	e9 d1 03 00 00       	jmp    1033d5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  103004:	8b 45 0c             	mov    0xc(%ebp),%eax
  103007:	89 44 24 04          	mov    %eax,0x4(%esp)
  10300b:	89 1c 24             	mov    %ebx,(%esp)
  10300e:	8b 45 08             	mov    0x8(%ebp),%eax
  103011:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103013:	8b 45 10             	mov    0x10(%ebp),%eax
  103016:	8d 50 01             	lea    0x1(%eax),%edx
  103019:	89 55 10             	mov    %edx,0x10(%ebp)
  10301c:	0f b6 00             	movzbl (%eax),%eax
  10301f:	0f b6 d8             	movzbl %al,%ebx
  103022:	83 fb 25             	cmp    $0x25,%ebx
  103025:	75 d4                	jne    102ffb <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103027:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10302b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103035:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103038:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10303f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103042:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103045:	8b 45 10             	mov    0x10(%ebp),%eax
  103048:	8d 50 01             	lea    0x1(%eax),%edx
  10304b:	89 55 10             	mov    %edx,0x10(%ebp)
  10304e:	0f b6 00             	movzbl (%eax),%eax
  103051:	0f b6 d8             	movzbl %al,%ebx
  103054:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103057:	83 f8 55             	cmp    $0x55,%eax
  10305a:	0f 87 44 03 00 00    	ja     1033a4 <vprintfmt+0x3b3>
  103060:	8b 04 85 94 3c 10 00 	mov    0x103c94(,%eax,4),%eax
  103067:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103069:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10306d:	eb d6                	jmp    103045 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10306f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103073:	eb d0                	jmp    103045 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103075:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10307c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10307f:	89 d0                	mov    %edx,%eax
  103081:	c1 e0 02             	shl    $0x2,%eax
  103084:	01 d0                	add    %edx,%eax
  103086:	01 c0                	add    %eax,%eax
  103088:	01 d8                	add    %ebx,%eax
  10308a:	83 e8 30             	sub    $0x30,%eax
  10308d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103090:	8b 45 10             	mov    0x10(%ebp),%eax
  103093:	0f b6 00             	movzbl (%eax),%eax
  103096:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103099:	83 fb 2f             	cmp    $0x2f,%ebx
  10309c:	7e 0b                	jle    1030a9 <vprintfmt+0xb8>
  10309e:	83 fb 39             	cmp    $0x39,%ebx
  1030a1:	7f 06                	jg     1030a9 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  1030a3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  1030a7:	eb d3                	jmp    10307c <vprintfmt+0x8b>
            goto process_precision;
  1030a9:	eb 33                	jmp    1030de <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1030ab:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ae:	8d 50 04             	lea    0x4(%eax),%edx
  1030b1:	89 55 14             	mov    %edx,0x14(%ebp)
  1030b4:	8b 00                	mov    (%eax),%eax
  1030b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1030b9:	eb 23                	jmp    1030de <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1030bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030bf:	79 0c                	jns    1030cd <vprintfmt+0xdc>
                width = 0;
  1030c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1030c8:	e9 78 ff ff ff       	jmp    103045 <vprintfmt+0x54>
  1030cd:	e9 73 ff ff ff       	jmp    103045 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1030d2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1030d9:	e9 67 ff ff ff       	jmp    103045 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1030de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030e2:	79 12                	jns    1030f6 <vprintfmt+0x105>
                width = precision, precision = -1;
  1030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030ea:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1030f1:	e9 4f ff ff ff       	jmp    103045 <vprintfmt+0x54>
  1030f6:	e9 4a ff ff ff       	jmp    103045 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1030fb:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1030ff:	e9 41 ff ff ff       	jmp    103045 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103104:	8b 45 14             	mov    0x14(%ebp),%eax
  103107:	8d 50 04             	lea    0x4(%eax),%edx
  10310a:	89 55 14             	mov    %edx,0x14(%ebp)
  10310d:	8b 00                	mov    (%eax),%eax
  10310f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103112:	89 54 24 04          	mov    %edx,0x4(%esp)
  103116:	89 04 24             	mov    %eax,(%esp)
  103119:	8b 45 08             	mov    0x8(%ebp),%eax
  10311c:	ff d0                	call   *%eax
            break;
  10311e:	e9 ac 02 00 00       	jmp    1033cf <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103123:	8b 45 14             	mov    0x14(%ebp),%eax
  103126:	8d 50 04             	lea    0x4(%eax),%edx
  103129:	89 55 14             	mov    %edx,0x14(%ebp)
  10312c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10312e:	85 db                	test   %ebx,%ebx
  103130:	79 02                	jns    103134 <vprintfmt+0x143>
                err = -err;
  103132:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103134:	83 fb 06             	cmp    $0x6,%ebx
  103137:	7f 0b                	jg     103144 <vprintfmt+0x153>
  103139:	8b 34 9d 54 3c 10 00 	mov    0x103c54(,%ebx,4),%esi
  103140:	85 f6                	test   %esi,%esi
  103142:	75 23                	jne    103167 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  103144:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103148:	c7 44 24 08 81 3c 10 	movl   $0x103c81,0x8(%esp)
  10314f:	00 
  103150:	8b 45 0c             	mov    0xc(%ebp),%eax
  103153:	89 44 24 04          	mov    %eax,0x4(%esp)
  103157:	8b 45 08             	mov    0x8(%ebp),%eax
  10315a:	89 04 24             	mov    %eax,(%esp)
  10315d:	e8 61 fe ff ff       	call   102fc3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103162:	e9 68 02 00 00       	jmp    1033cf <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  103167:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10316b:	c7 44 24 08 8a 3c 10 	movl   $0x103c8a,0x8(%esp)
  103172:	00 
  103173:	8b 45 0c             	mov    0xc(%ebp),%eax
  103176:	89 44 24 04          	mov    %eax,0x4(%esp)
  10317a:	8b 45 08             	mov    0x8(%ebp),%eax
  10317d:	89 04 24             	mov    %eax,(%esp)
  103180:	e8 3e fe ff ff       	call   102fc3 <printfmt>
            break;
  103185:	e9 45 02 00 00       	jmp    1033cf <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10318a:	8b 45 14             	mov    0x14(%ebp),%eax
  10318d:	8d 50 04             	lea    0x4(%eax),%edx
  103190:	89 55 14             	mov    %edx,0x14(%ebp)
  103193:	8b 30                	mov    (%eax),%esi
  103195:	85 f6                	test   %esi,%esi
  103197:	75 05                	jne    10319e <vprintfmt+0x1ad>
                p = "(null)";
  103199:	be 8d 3c 10 00       	mov    $0x103c8d,%esi
            }
            if (width > 0 && padc != '-') {
  10319e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031a2:	7e 3e                	jle    1031e2 <vprintfmt+0x1f1>
  1031a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1031a8:	74 38                	je     1031e2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1031aa:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1031ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b4:	89 34 24             	mov    %esi,(%esp)
  1031b7:	e8 dc f7 ff ff       	call   102998 <strnlen>
  1031bc:	29 c3                	sub    %eax,%ebx
  1031be:	89 d8                	mov    %ebx,%eax
  1031c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031c3:	eb 17                	jmp    1031dc <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1031c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1031c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031d0:	89 04 24             	mov    %eax,(%esp)
  1031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d6:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1031d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031e0:	7f e3                	jg     1031c5 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1031e2:	eb 38                	jmp    10321c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1031e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1031e8:	74 1f                	je     103209 <vprintfmt+0x218>
  1031ea:	83 fb 1f             	cmp    $0x1f,%ebx
  1031ed:	7e 05                	jle    1031f4 <vprintfmt+0x203>
  1031ef:	83 fb 7e             	cmp    $0x7e,%ebx
  1031f2:	7e 15                	jle    103209 <vprintfmt+0x218>
                    putch('?', putdat);
  1031f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031fb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103202:	8b 45 08             	mov    0x8(%ebp),%eax
  103205:	ff d0                	call   *%eax
  103207:	eb 0f                	jmp    103218 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  103209:	8b 45 0c             	mov    0xc(%ebp),%eax
  10320c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103210:	89 1c 24             	mov    %ebx,(%esp)
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103218:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10321c:	89 f0                	mov    %esi,%eax
  10321e:	8d 70 01             	lea    0x1(%eax),%esi
  103221:	0f b6 00             	movzbl (%eax),%eax
  103224:	0f be d8             	movsbl %al,%ebx
  103227:	85 db                	test   %ebx,%ebx
  103229:	74 10                	je     10323b <vprintfmt+0x24a>
  10322b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10322f:	78 b3                	js     1031e4 <vprintfmt+0x1f3>
  103231:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103235:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103239:	79 a9                	jns    1031e4 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  10323b:	eb 17                	jmp    103254 <vprintfmt+0x263>
                putch(' ', putdat);
  10323d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103240:	89 44 24 04          	mov    %eax,0x4(%esp)
  103244:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
  10324e:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103250:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103254:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103258:	7f e3                	jg     10323d <vprintfmt+0x24c>
            }
            break;
  10325a:	e9 70 01 00 00       	jmp    1033cf <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10325f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103262:	89 44 24 04          	mov    %eax,0x4(%esp)
  103266:	8d 45 14             	lea    0x14(%ebp),%eax
  103269:	89 04 24             	mov    %eax,(%esp)
  10326c:	e8 0b fd ff ff       	call   102f7c <getint>
  103271:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103274:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10327a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10327d:	85 d2                	test   %edx,%edx
  10327f:	79 26                	jns    1032a7 <vprintfmt+0x2b6>
                putch('-', putdat);
  103281:	8b 45 0c             	mov    0xc(%ebp),%eax
  103284:	89 44 24 04          	mov    %eax,0x4(%esp)
  103288:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10328f:	8b 45 08             	mov    0x8(%ebp),%eax
  103292:	ff d0                	call   *%eax
                num = -(long long)num;
  103294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10329a:	f7 d8                	neg    %eax
  10329c:	83 d2 00             	adc    $0x0,%edx
  10329f:	f7 da                	neg    %edx
  1032a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1032a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1032ae:	e9 a8 00 00 00       	jmp    10335b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1032b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ba:	8d 45 14             	lea    0x14(%ebp),%eax
  1032bd:	89 04 24             	mov    %eax,(%esp)
  1032c0:	e8 68 fc ff ff       	call   102f2d <getuint>
  1032c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1032cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1032d2:	e9 84 00 00 00       	jmp    10335b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1032d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032de:	8d 45 14             	lea    0x14(%ebp),%eax
  1032e1:	89 04 24             	mov    %eax,(%esp)
  1032e4:	e8 44 fc ff ff       	call   102f2d <getuint>
  1032e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1032ef:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1032f6:	eb 63                	jmp    10335b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1032f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103306:	8b 45 08             	mov    0x8(%ebp),%eax
  103309:	ff d0                	call   *%eax
            putch('x', putdat);
  10330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103312:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103319:	8b 45 08             	mov    0x8(%ebp),%eax
  10331c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10331e:	8b 45 14             	mov    0x14(%ebp),%eax
  103321:	8d 50 04             	lea    0x4(%eax),%edx
  103324:	89 55 14             	mov    %edx,0x14(%ebp)
  103327:	8b 00                	mov    (%eax),%eax
  103329:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10332c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103333:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10333a:	eb 1f                	jmp    10335b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10333f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103343:	8d 45 14             	lea    0x14(%ebp),%eax
  103346:	89 04 24             	mov    %eax,(%esp)
  103349:	e8 df fb ff ff       	call   102f2d <getuint>
  10334e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103351:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103354:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10335b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103362:	89 54 24 18          	mov    %edx,0x18(%esp)
  103366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103369:	89 54 24 14          	mov    %edx,0x14(%esp)
  10336d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103377:	89 44 24 08          	mov    %eax,0x8(%esp)
  10337b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10337f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103382:	89 44 24 04          	mov    %eax,0x4(%esp)
  103386:	8b 45 08             	mov    0x8(%ebp),%eax
  103389:	89 04 24             	mov    %eax,(%esp)
  10338c:	e8 97 fa ff ff       	call   102e28 <printnum>
            break;
  103391:	eb 3c                	jmp    1033cf <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103393:	8b 45 0c             	mov    0xc(%ebp),%eax
  103396:	89 44 24 04          	mov    %eax,0x4(%esp)
  10339a:	89 1c 24             	mov    %ebx,(%esp)
  10339d:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a0:	ff d0                	call   *%eax
            break;
  1033a2:	eb 2b                	jmp    1033cf <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ab:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1033b7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033bb:	eb 04                	jmp    1033c1 <vprintfmt+0x3d0>
  1033bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1033c4:	83 e8 01             	sub    $0x1,%eax
  1033c7:	0f b6 00             	movzbl (%eax),%eax
  1033ca:	3c 25                	cmp    $0x25,%al
  1033cc:	75 ef                	jne    1033bd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1033ce:	90                   	nop
        }
    }
  1033cf:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1033d0:	e9 3e fc ff ff       	jmp    103013 <vprintfmt+0x22>
}
  1033d5:	83 c4 40             	add    $0x40,%esp
  1033d8:	5b                   	pop    %ebx
  1033d9:	5e                   	pop    %esi
  1033da:	5d                   	pop    %ebp
  1033db:	c3                   	ret    

001033dc <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1033dc:	55                   	push   %ebp
  1033dd:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1033df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e2:	8b 40 08             	mov    0x8(%eax),%eax
  1033e5:	8d 50 01             	lea    0x1(%eax),%edx
  1033e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033eb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1033ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f1:	8b 10                	mov    (%eax),%edx
  1033f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f6:	8b 40 04             	mov    0x4(%eax),%eax
  1033f9:	39 c2                	cmp    %eax,%edx
  1033fb:	73 12                	jae    10340f <sprintputch+0x33>
        *b->buf ++ = ch;
  1033fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103400:	8b 00                	mov    (%eax),%eax
  103402:	8d 48 01             	lea    0x1(%eax),%ecx
  103405:	8b 55 0c             	mov    0xc(%ebp),%edx
  103408:	89 0a                	mov    %ecx,(%edx)
  10340a:	8b 55 08             	mov    0x8(%ebp),%edx
  10340d:	88 10                	mov    %dl,(%eax)
    }
}
  10340f:	5d                   	pop    %ebp
  103410:	c3                   	ret    

00103411 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103411:	55                   	push   %ebp
  103412:	89 e5                	mov    %esp,%ebp
  103414:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103417:	8d 45 14             	lea    0x14(%ebp),%eax
  10341a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10341d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103420:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103424:	8b 45 10             	mov    0x10(%ebp),%eax
  103427:	89 44 24 08          	mov    %eax,0x8(%esp)
  10342b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10342e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103432:	8b 45 08             	mov    0x8(%ebp),%eax
  103435:	89 04 24             	mov    %eax,(%esp)
  103438:	e8 08 00 00 00       	call   103445 <vsnprintf>
  10343d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103440:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103443:	c9                   	leave  
  103444:	c3                   	ret    

00103445 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103445:	55                   	push   %ebp
  103446:	89 e5                	mov    %esp,%ebp
  103448:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10344b:	8b 45 08             	mov    0x8(%ebp),%eax
  10344e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103451:	8b 45 0c             	mov    0xc(%ebp),%eax
  103454:	8d 50 ff             	lea    -0x1(%eax),%edx
  103457:	8b 45 08             	mov    0x8(%ebp),%eax
  10345a:	01 d0                	add    %edx,%eax
  10345c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10345f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10346a:	74 0a                	je     103476 <vsnprintf+0x31>
  10346c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103472:	39 c2                	cmp    %eax,%edx
  103474:	76 07                	jbe    10347d <vsnprintf+0x38>
        return -E_INVAL;
  103476:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10347b:	eb 2a                	jmp    1034a7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10347d:	8b 45 14             	mov    0x14(%ebp),%eax
  103480:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103484:	8b 45 10             	mov    0x10(%ebp),%eax
  103487:	89 44 24 08          	mov    %eax,0x8(%esp)
  10348b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10348e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103492:	c7 04 24 dc 33 10 00 	movl   $0x1033dc,(%esp)
  103499:	e8 53 fb ff ff       	call   102ff1 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10349e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034a1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034a7:	c9                   	leave  
  1034a8:	c3                   	ret    
