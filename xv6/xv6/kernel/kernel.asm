
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	89010113          	addi	sp,sp,-1904 # 80007890 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc67>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	e2878793          	addi	a5,a5,-472 # 80000ea0 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	1d6020ef          	jal	800022f2 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7d6000ef          	jal	800008fe <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	0000f517          	auipc	a0,0xf
    80000198:	6fc50513          	addi	a0,a0,1788 # 8000f890 <cons>
    8000019c:	29d000ef          	jal	80000c38 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	0000f497          	auipc	s1,0xf
    800001a4:	6f048493          	addi	s1,s1,1776 # 8000f890 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	0000f917          	auipc	s2,0xf
    800001ac:	78090913          	addi	s2,s2,1920 # 8000f928 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	762010ef          	jal	80001922 <myproc>
    800001c4:	7b1010ef          	jal	80002174 <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	54f010ef          	jal	80001f1a <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	2eb000ef          	jal	80000cbc <release>
      sleep();
    800001d6:	581010ef          	jal	80001f56 <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	25d000ef          	jal	80000c38 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	0000f717          	auipc	a4,0xf
    800001f2:	6a270713          	addi	a4,a4,1698 # 8000f890 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	086020ef          	jal	800022a6 <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	0000f517          	auipc	a0,0xf
    8000023c:	65850513          	addi	a0,a0,1624 # 8000f890 <cons>
    80000240:	27d000ef          	jal	80000cbc <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	0000f717          	auipc	a4,0xf
    80000262:	6cf72523          	sw	a5,1738(a4) # 8000f928 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	0000f517          	auipc	a0,0xf
    80000278:	61c50513          	addi	a0,a0,1564 # 8000f890 <cons>
    8000027c:	241000ef          	jal	80000cbc <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	70a000ef          	jal	800009a4 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6fc000ef          	jal	800009a4 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6f4000ef          	jal	800009a4 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ee000ef          	jal	800009a4 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	0000f517          	auipc	a0,0xf
    800002cc:	5c850513          	addi	a0,a0,1480 # 8000f890 <cons>
    800002d0:	169000ef          	jal	80000c38 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	0af48163          	beq	s1,a5,80000378 <consoleintr+0xbc>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48663          	beq	s1,a5,800003cc <consoleintr+0x110>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49763          	bne	s1,a5,800003f4 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002ea:	054020ef          	jal	8000233e <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	0000f517          	auipc	a0,0xf
    800002f2:	5a250513          	addi	a0,a0,1442 # 8000f890 <cons>
    800002f6:	1c7000ef          	jal	80000cbc <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48263          	beq	s1,a5,800003cc <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	0000f717          	auipc	a4,0xf
    80000310:	58470713          	addi	a4,a4,1412 # 8000f890 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48963          	beq	s1,a5,800003fa <consoleintr+0x13e>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	0000f717          	auipc	a4,0xf
    80000336:	55e70713          	addi	a4,a4,1374 # 8000f890 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	00173713          	seqz	a4,a4
    8000035a:	14f1                	addi	s1,s1,-4
    8000035c:	0014b493          	seqz	s1,s1
    80000360:	8f45                	or	a4,a4,s1
    80000362:	e361                	bnez	a4,80000422 <consoleintr+0x166>
    80000364:	0000f717          	auipc	a4,0xf
    80000368:	5c472703          	lw	a4,1476(a4) # 8000f928 <cons+0x98>
    8000036c:	9f99                	subw	a5,a5,a4
    8000036e:	08000713          	li	a4,128
    80000372:	f6e79ee3          	bne	a5,a4,800002ee <consoleintr+0x32>
    80000376:	a075                	j	80000422 <consoleintr+0x166>
    80000378:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000037a:	0000f717          	auipc	a4,0xf
    8000037e:	51670713          	addi	a4,a4,1302 # 8000f890 <cons>
    80000382:	0a072783          	lw	a5,160(a4)
    80000386:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	0000f497          	auipc	s1,0xf
    8000038e:	50648493          	addi	s1,s1,1286 # 8000f890 <cons>
    while (cons.e != cons.w &&
    80000392:	4929                	li	s2,10
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270263          	beq	a4,s2,800003c8 <consoleintr+0x10c>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	10000513          	li	a0,256
    800003b0:	edbff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ee3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6902                	ld	s2,0(sp)
    800003c6:	b725                	j	800002ee <consoleintr+0x32>
    800003c8:	6902                	ld	s2,0(sp)
    800003ca:	b715                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003cc:	0000f717          	auipc	a4,0xf
    800003d0:	4c470713          	addi	a4,a4,1220 # 8000f890 <cons>
    800003d4:	0a072783          	lw	a5,160(a4)
    800003d8:	09c72703          	lw	a4,156(a4)
    800003dc:	f0f709e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e0:	37fd                	addiw	a5,a5,-1
    800003e2:	0000f717          	auipc	a4,0xf
    800003e6:	54f72723          	sw	a5,1358(a4) # 8000f930 <cons+0xa0>
      consputc(BACKSPACE);
    800003ea:	10000513          	li	a0,256
    800003ee:	e9dff0ef          	jal	8000028a <consputc>
    800003f2:	bdf5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f4:	ee048de3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f8:	bf11                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	e8fff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000400:	0000f797          	auipc	a5,0xf
    80000404:	49078793          	addi	a5,a5,1168 # 8000f890 <cons>
    80000408:	0a07a703          	lw	a4,160(a5)
    8000040c:	0017069b          	addiw	a3,a4,1
    80000410:	8636                	mv	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	0000f797          	auipc	a5,0xf
    80000426:	50c7a523          	sw	a2,1290(a5) # 8000f92c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	0000f517          	auipc	a0,0xf
    8000042e:	4fe50513          	addi	a0,a0,1278 # 8000f928 <cons+0x98>
    80000432:	355010ef          	jal	80001f86 <wakeup>
    80000436:	bd65                	j	800002ee <consoleintr+0x32>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	addi	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00007597          	auipc	a1,0x7
    80000444:	bc058593          	addi	a1,a1,-1088 # 80007000 <etext>
    80000448:	0000f517          	auipc	a0,0xf
    8000044c:	44850513          	addi	a0,a0,1096 # 8000f890 <cons>
    80000450:	768000ef          	jal	80000bb8 <initlock>

  uartinit();
    80000454:	454000ef          	jal	800008a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000458:	0001f797          	auipc	a5,0x1f
    8000045c:	5a878793          	addi	a5,a5,1448 # 8001fa00 <devsw>
    80000460:	00000717          	auipc	a4,0x0
    80000464:	d1870713          	addi	a4,a4,-744 # 80000178 <consoleread>
    80000468:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046a:	00000717          	auipc	a4,0x0
    8000046e:	c6c70713          	addi	a4,a4,-916 # 800000d6 <consolewrite>
    80000472:	ef98                	sd	a4,24(a5)
}
    80000474:	60a2                	ld	ra,8(sp)
    80000476:	6402                	ld	s0,0(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f04a                	sd	s2,32(sp)
    80000484:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000486:	c219                	beqz	a2,8000048c <printint+0x10>
    80000488:	08054063          	bltz	a0,80000508 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000048c:	4301                	li	t1,0

  i = 0;
    8000048e:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000492:	86ca                	mv	a3,s2
  i = 0;
    80000494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000496:	00007817          	auipc	a6,0x7
    8000049a:	29a80813          	addi	a6,a6,666 # 80007730 <digits>
    8000049e:	88ba                	mv	a7,a4
    800004a0:	0017061b          	addiw	a2,a4,1
    800004a4:	8732                	mv	a4,a2
    800004a6:	02b577b3          	remu	a5,a0,a1
    800004aa:	97c2                	add	a5,a5,a6
    800004ac:	0007c783          	lbu	a5,0(a5)
    800004b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004b4:	87aa                	mv	a5,a0
    800004b6:	02b55533          	divu	a0,a0,a1
    800004ba:	0685                	addi	a3,a3,1
    800004bc:	feb7f1e3          	bgeu	a5,a1,8000049e <printint+0x22>

  if (sign)
    800004c0:	00030b63          	beqz	t1,800004d6 <printint+0x5a>
    buf[i++] = '-';
    800004c4:	fe040793          	addi	a5,s0,-32
    800004c8:	963e                	add	a2,a2,a5
    800004ca:	02d00793          	li	a5,45
    800004ce:	fef60423          	sb	a5,-24(a2)
    800004d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d6:	02e05463          	blez	a4,800004fe <printint+0x82>
    800004da:	f426                	sd	s1,40(sp)
    800004dc:	377d                	addiw	a4,a4,-1
    800004de:	00e904b3          	add	s1,s2,a4
    800004e2:	197d                	addi	s2,s2,-1
    800004e4:	993a                	add	s2,s2,a4
    800004e6:	1702                	slli	a4,a4,0x20
    800004e8:	9301                	srli	a4,a4,0x20
    800004ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004ee:	0004c503          	lbu	a0,0(s1)
    800004f2:	d99ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f6:	14fd                	addi	s1,s1,-1
    800004f8:	ff249be3          	bne	s1,s2,800004ee <printint+0x72>
    800004fc:	74a2                	ld	s1,40(sp)
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
    x = -xx;
    80000508:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    8000050c:	4305                	li	t1,1
    x = -xx;
    8000050e:	b741                	j	8000048e <printint+0x12>

0000000080000510 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000510:	7131                	addi	sp,sp,-192
    80000512:	fc86                	sd	ra,120(sp)
    80000514:	f8a2                	sd	s0,112(sp)
    80000516:	f4a6                	sd	s1,104(sp)
    80000518:	0100                	addi	s0,sp,128
    8000051a:	84aa                	mv	s1,a0
    8000051c:	e40c                	sd	a1,8(s0)
    8000051e:	e810                	sd	a2,16(s0)
    80000520:	ec14                	sd	a3,24(s0)
    80000522:	f018                	sd	a4,32(s0)
    80000524:	f41c                	sd	a5,40(s0)
    80000526:	03043823          	sd	a6,48(s0)
    8000052a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000052e:	00007797          	auipc	a5,0x7
    80000532:	3367a783          	lw	a5,822(a5) # 80007864 <panicking>
    80000536:	cf9d                	beqz	a5,80000574 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000540:	0004c503          	lbu	a0,0(s1)
    80000544:	22050363          	beqz	a0,8000076a <printk+0x25a>
    80000548:	f0ca                	sd	s2,96(sp)
    8000054a:	ecce                	sd	s3,88(sp)
    8000054c:	e8d2                	sd	s4,80(sp)
    8000054e:	e4d6                	sd	s5,72(sp)
    80000550:	e0da                	sd	s6,64(sp)
    80000552:	fc5e                	sd	s7,56(sp)
    80000554:	f862                	sd	s8,48(sp)
    80000556:	f06a                	sd	s10,32(sp)
    80000558:	ec6e                	sd	s11,24(sp)
    8000055a:	4a01                	li	s4,0
    if (cx != '%') {
    8000055c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000560:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000568:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000056c:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000056e:	06400b93          	li	s7,100
    80000572:	a015                	j	80000596 <printk+0x86>
    acquire(&pr.lock);
    80000574:	0000f517          	auipc	a0,0xf
    80000578:	3c450513          	addi	a0,a0,964 # 8000f938 <pr>
    8000057c:	6bc000ef          	jal	80000c38 <acquire>
    80000580:	bf65                	j	80000538 <printk+0x28>
      consputc(cx);
    80000582:	d09ff0ef          	jal	8000028a <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000586:	001a079b          	addiw	a5,s4,1
    8000058a:	8a3e                	mv	s4,a5
    8000058c:	97a6                	add	a5,a5,s1
    8000058e:	0007c503          	lbu	a0,0(a5)
    80000592:	1c050363          	beqz	a0,80000758 <printk+0x248>
    if (cx != '%') {
    80000596:	ff3516e3          	bne	a0,s3,80000582 <printk+0x72>
    i++;
    8000059a:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    8000059e:	012487b3          	add	a5,s1,s2
    800005a2:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    800005a6:	200a8763          	beqz	s5,800007b4 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    800005aa:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005ae:	1e070a63          	beqz	a4,800007a2 <printk+0x292>
    if (c0 == 'd') {
    800005b2:	037a8963          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b6:	f94a8793          	addi	a5,s5,-108
    800005ba:	0017b793          	seqz	a5,a5
    800005be:	f9c70693          	addi	a3,a4,-100
    800005c2:	0016b693          	seqz	a3,a3
    800005c6:	8efd                	and	a3,a3,a5
    800005c8:	ca9d                	beqz	a3,800005fe <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005ca:	f8843783          	ld	a5,-120(s0)
    800005ce:	00878713          	addi	a4,a5,8
    800005d2:	f8e43423          	sd	a4,-120(s0)
    800005d6:	4605                	li	a2,1
    800005d8:	85da                	mv	a1,s6
    800005da:	6388                	ld	a0,0(a5)
    800005dc:	ea1ff0ef          	jal	8000047c <printint>
      i += 1;
    800005e0:	2a09                	addiw	s4,s4,2
    800005e2:	b755                	j	80000586 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	85da                	mv	a1,s6
    800005f4:	4388                	lw	a0,0(a5)
    800005f6:	e87ff0ef          	jal	8000047c <printint>
    i++;
    800005fa:	8a4a                	mv	s4,s2
    800005fc:	b769                	j	80000586 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005fe:	012486b3          	add	a3,s1,s2
    80000602:	863a                	mv	a2,a4
    80000604:	0026c703          	lbu	a4,2(a3)
    80000608:	aa65                	j	800007c0 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4605                	li	a2,1
    80000618:	45a9                	li	a1,10
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e61ff0ef          	jal	8000047c <printint>
      i += 2;
    80000620:	2a0d                	addiw	s4,s4,3
    80000622:	b795                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4601                	li	a2,0
    80000632:	85da                	mv	a1,s6
    80000634:	0007e503          	lwu	a0,0(a5)
    80000638:	e45ff0ef          	jal	8000047c <printint>
    8000063c:	bf7d                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	addi	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	85da                	mv	a1,s6
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	e2dff0ef          	jal	8000047c <printint>
      i += 1;
    80000654:	2a09                	addiw	s4,s4,2
    80000656:	bf05                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e13ff0ef          	jal	8000047c <printint>
      i += 2;
    8000066e:	2a0d                	addiw	s4,s4,3
    80000670:	bf19                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4601                	li	a2,0
    80000680:	45c1                	li	a1,16
    80000682:	0007e503          	lwu	a0,0(a5)
    80000686:	df7ff0ef          	jal	8000047c <printint>
    8000068a:	bf85                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	ddfff0ef          	jal	8000047c <printint>
      i += 1;
    800006a2:	2a09                	addiw	s4,s4,2
    800006a4:	b5cd                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	45c1                	li	a1,16
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dc7ff0ef          	jal	8000047c <printint>
      i += 2;
    800006ba:	2a0d                	addiw	s4,s4,3
    800006bc:	b5e9                	j	80000586 <printk+0x76>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	04ec8c93          	addi	s9,s9,78 # 80007730 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1da>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	bde5                	j	800005fa <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5d5                	j	800005fa <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	ec0505e3          	beqz	a0,800005fa <printk+0xea>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x224>
    80000740:	bd6d                	j	800005fa <printk+0xea>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b555                	j	800005fa <printk+0xea>
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	00007797          	auipc	a5,0x7
    8000076e:	0fa7a783          	lw	a5,250(a5) # 80007864 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	74a6                	ld	s1,104(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x25a>
    release(&pr.lock);
    80000794:	0000f517          	auipc	a0,0xf
    80000798:	1a450513          	addi	a0,a0,420 # 8000f938 <pr>
    8000079c:	520000ef          	jal	80000cbc <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x264>
    if (c0 == 'd') {
    800007a2:	e57a81e3          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    800007ae:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4681                	li	a3,0
    800007b2:	a01d                	j	800007d8 <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8793          	addi	a5,s5,-108
    800007b8:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460693          	addi	a3,a2,-108
    800007c4:	0016b693          	seqz	a3,a3
    800007c8:	8efd                	and	a3,a3,a5
    800007ca:	f9c70593          	addi	a1,a4,-100
    800007ce:	0015b593          	seqz	a1,a1
    800007d2:	8df5                	and	a1,a1,a3
    800007d4:	e2059be3          	bnez	a1,8000060a <printk+0xfa>
    } else if (c0 == 'u') {
    800007d8:	e58a86e3          	beq	s5,s8,80000624 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007dc:	f8b60593          	addi	a1,a2,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8dfd                	and	a1,a1,a5
    800007e6:	e4059ce3          	bnez	a1,8000063e <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007ea:	f8b70593          	addi	a1,a4,-117
    800007ee:	0015b593          	seqz	a1,a1
    800007f2:	8df5                	and	a1,a1,a3
    800007f4:	e60592e3          	bnez	a1,80000658 <printk+0x148>
    } else if (c0 == 'x') {
    800007f8:	e7aa8de3          	beq	s5,s10,80000672 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007fc:	f8860613          	addi	a2,a2,-120
    80000800:	00163613          	seqz	a2,a2
    80000804:	8e7d                	and	a2,a2,a5
    80000806:	e80613e3          	bnez	a2,8000068c <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000080a:	f8870713          	addi	a4,a4,-120
    8000080e:	00173713          	seqz	a4,a4
    80000812:	8f75                	and	a4,a4,a3
    80000814:	e80719e3          	bnez	a4,800006a6 <printk+0x196>
    } else if (c0 == 'p') {
    80000818:	ebba83e3          	beq	s5,s11,800006be <printk+0x1ae>
    } else if (c0 == 'c') {
    8000081c:	06300793          	li	a5,99
    80000820:	eefa82e3          	beq	s5,a5,80000704 <printk+0x1f4>
    } else if (c0 == 's') {
    80000824:	07300793          	li	a5,115
    80000828:	eefa88e3          	beq	s5,a5,80000718 <printk+0x208>
    } else if (c0 == '%') {
    8000082c:	02500793          	li	a5,37
    80000830:	f2fa80e3          	beq	s5,a5,80000750 <printk+0x240>
    } else if (c0 == 0) {
    80000834:	f40a86e3          	beqz	s5,80000780 <printk+0x270>
      consputc('%');
    80000838:	02500513          	li	a0,37
    8000083c:	a4fff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000840:	8556                	mv	a0,s5
    80000842:	a49ff0ef          	jal	8000028a <consputc>
    80000846:	bb55                	j	800005fa <printk+0xea>

0000000080000848 <panic>:

void
panic(char *s)
{
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	e04a                	sd	s2,0(sp)
    80000852:	1000                	addi	s0,sp,32
    80000854:	892a                	mv	s2,a0
  panicking = 1;
    80000856:	4485                	li	s1,1
    80000858:	00007797          	auipc	a5,0x7
    8000085c:	0097a623          	sw	s1,12(a5) # 80007864 <panicking>
  printk("panic: ");
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80000868:	ca9ff0ef          	jal	80000510 <printk>
  printk("%s\n", s);
    8000086c:	85ca                	mv	a1,s2
    8000086e:	00006517          	auipc	a0,0x6
    80000872:	7b250513          	addi	a0,a0,1970 # 80007020 <etext+0x20>
    80000876:	c9bff0ef          	jal	80000510 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000087a:	00007797          	auipc	a5,0x7
    8000087e:	fe97a323          	sw	s1,-26(a5) # 80007860 <panicked>
  for (;;)
    80000882:	a001                	j	80000882 <panic+0x3a>

0000000080000884 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000088c:	00006597          	auipc	a1,0x6
    80000890:	79c58593          	addi	a1,a1,1948 # 80007028 <etext+0x28>
    80000894:	0000f517          	auipc	a0,0xf
    80000898:	0a450513          	addi	a0,a0,164 # 8000f938 <pr>
    8000089c:	31c000ef          	jal	80000bb8 <initlock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008b0:	100007b7          	lui	a5,0x10000
    800008b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008b8:	10000737          	lui	a4,0x10000
    800008bc:	f8000693          	li	a3,-128
    800008c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008c4:	468d                	li	a3,3
    800008c6:	10000637          	lui	a2,0x10000
    800008ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008d6:	8732                	mv	a4,a2
    800008d8:	461d                	li	a2,7
    800008da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008de:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008e2:	00006597          	auipc	a1,0x6
    800008e6:	74e58593          	addi	a1,a1,1870 # 80007030 <etext+0x30>
    800008ea:	0000f517          	auipc	a0,0xf
    800008ee:	06650513          	addi	a0,a0,102 # 8000f950 <tx_lock>
    800008f2:	2c6000ef          	jal	80000bb8 <initlock>
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008fe:	715d                	addi	sp,sp,-80
    80000900:	e486                	sd	ra,72(sp)
    80000902:	e0a2                	sd	s0,64(sp)
    80000904:	fc26                	sd	s1,56(sp)
    80000906:	ec56                	sd	s5,24(sp)
    80000908:	0880                	addi	s0,sp,80
    8000090a:	8aaa                	mv	s5,a0
    8000090c:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    8000090e:	0000f517          	auipc	a0,0xf
    80000912:	04250513          	addi	a0,a0,66 # 8000f950 <tx_lock>
    80000916:	322000ef          	jal	80000c38 <acquire>

  int i = 0;
  while (i < n) {
    8000091a:	06905963          	blez	s1,8000098c <uartwrite+0x8e>
    8000091e:	f84a                	sd	s2,48(sp)
    80000920:	f44e                	sd	s3,40(sp)
    80000922:	f052                	sd	s4,32(sp)
    80000924:	e85a                	sd	s6,16(sp)
    80000926:	e45e                	sd	s7,8(sp)
    80000928:	8a56                	mv	s4,s5
    8000092a:	9aa6                	add	s5,s5,s1
    while (tx_busy != 0) {
    8000092c:	00007917          	auipc	s2,0x7
    80000930:	f4090913          	addi	s2,s2,-192 # 8000786c <tx_busy>
      // wait for a UART interrupt to set tx_busy to 0.
      sleep_prepare(&tx_chan);
    80000934:	00007997          	auipc	s3,0x7
    80000938:	f3498993          	addi	s3,s3,-204 # 80007868 <tx_chan>
      release(&tx_lock);
    8000093c:	0000f497          	auipc	s1,0xf
    80000940:	01448493          	addi	s1,s1,20 # 8000f950 <tx_lock>
      sleep();
      acquire(&tx_lock);
    }
    WriteReg(THR, buf[i]);
    80000944:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000948:	4b05                	li	s6,1
    8000094a:	a805                	j	8000097a <uartwrite+0x7c>
      sleep_prepare(&tx_chan);
    8000094c:	854e                	mv	a0,s3
    8000094e:	5cc010ef          	jal	80001f1a <sleep_prepare>
      release(&tx_lock);
    80000952:	8526                	mv	a0,s1
    80000954:	368000ef          	jal	80000cbc <release>
      sleep();
    80000958:	5fe010ef          	jal	80001f56 <sleep>
      acquire(&tx_lock);
    8000095c:	8526                	mv	a0,s1
    8000095e:	2da000ef          	jal	80000c38 <acquire>
    while (tx_busy != 0) {
    80000962:	00092783          	lw	a5,0(s2)
    80000966:	f3fd                	bnez	a5,8000094c <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000968:	000a4783          	lbu	a5,0(s4)
    8000096c:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80000970:	01692023          	sw	s6,0(s2)
  while (i < n) {
    80000974:	0a05                	addi	s4,s4,1
    80000976:	015a0663          	beq	s4,s5,80000982 <uartwrite+0x84>
    while (tx_busy != 0) {
    8000097a:	00092783          	lw	a5,0(s2)
    8000097e:	f7f9                	bnez	a5,8000094c <uartwrite+0x4e>
    80000980:	b7e5                	j	80000968 <uartwrite+0x6a>
    80000982:	7942                	ld	s2,48(sp)
    80000984:	79a2                	ld	s3,40(sp)
    80000986:	7a02                	ld	s4,32(sp)
    80000988:	6b42                	ld	s6,16(sp)
    8000098a:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    8000098c:	0000f517          	auipc	a0,0xf
    80000990:	fc450513          	addi	a0,a0,-60 # 8000f950 <tx_lock>
    80000994:	328000ef          	jal	80000cbc <release>
}
    80000998:	60a6                	ld	ra,72(sp)
    8000099a:	6406                	ld	s0,64(sp)
    8000099c:	74e2                	ld	s1,56(sp)
    8000099e:	6ae2                	ld	s5,24(sp)
    800009a0:	6161                	addi	sp,sp,80
    800009a2:	8082                	ret

00000000800009a4 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800009a4:	1101                	addi	sp,sp,-32
    800009a6:	ec06                	sd	ra,24(sp)
    800009a8:	e822                	sd	s0,16(sp)
    800009aa:	e426                	sd	s1,8(sp)
    800009ac:	1000                	addi	s0,sp,32
    800009ae:	84aa                	mv	s1,a0
  if (panicking == 0)
    800009b0:	00007797          	auipc	a5,0x7
    800009b4:	eb47a783          	lw	a5,-332(a5) # 80007864 <panicking>
    800009b8:	cb91                	beqz	a5,800009cc <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    800009ba:	00007797          	auipc	a5,0x7
    800009be:	ea67a783          	lw	a5,-346(a5) # 80007860 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009c2:	10000737          	lui	a4,0x10000
    800009c6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009c8:	c789                	beqz	a5,800009d2 <uartputc_sync+0x2e>
    for (;;)
    800009ca:	a001                	j	800009ca <uartputc_sync+0x26>
    push_off();
    800009cc:	232000ef          	jal	80000bfe <push_off>
    800009d0:	b7ed                	j	800009ba <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009d2:	00074783          	lbu	a5,0(a4)
    800009d6:	0207f793          	andi	a5,a5,32
    800009da:	dfe5                	beqz	a5,800009d2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009e4:	00007797          	auipc	a5,0x7
    800009e8:	e807a783          	lw	a5,-384(a5) # 80007864 <panicking>
    800009ec:	c791                	beqz	a5,800009f8 <uartputc_sync+0x54>
    pop_off();
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    pop_off();
    800009f8:	27c000ef          	jal	80000c74 <pop_off>
}
    800009fc:	bfcd                	j	800009ee <uartputc_sync+0x4a>

00000000800009fe <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	e04a                	sd	s2,0(sp)
    80000a08:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80000a0a:	100007b7          	lui	a5,0x10000
    80000a0e:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a12:	0000f517          	auipc	a0,0xf
    80000a16:	f3e50513          	addi	a0,a0,-194 # 8000f950 <tx_lock>
    80000a1a:	21e000ef          	jal	80000c38 <acquire>
  if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000a1e:	100007b7          	lui	a5,0x10000
    80000a22:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a26:	0207f793          	andi	a5,a5,32
    80000a2a:	e78d                	bnez	a5,80000a54 <uartintr+0x56>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a2c:	0000f517          	auipc	a0,0xf
    80000a30:	f2450513          	addi	a0,a0,-220 # 8000f950 <tx_lock>
    80000a34:	288000ef          	jal	80000cbc <release>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a38:	100004b7          	lui	s1,0x10000
    80000a3c:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a3e:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a42:	0004c783          	lbu	a5,0(s1)
    80000a46:	8b85                	andi	a5,a5,1
    80000a48:	c38d                	beqz	a5,80000a6a <uartintr+0x6c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a4a:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a4e:	86fff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a52:	bfc5                	j	80000a42 <uartintr+0x44>
    tx_busy = 0;
    80000a54:	00007797          	auipc	a5,0x7
    80000a58:	e007ac23          	sw	zero,-488(a5) # 8000786c <tx_busy>
    wakeup(&tx_chan);
    80000a5c:	00007517          	auipc	a0,0x7
    80000a60:	e0c50513          	addi	a0,a0,-500 # 80007868 <tx_chan>
    80000a64:	522010ef          	jal	80001f86 <wakeup>
    80000a68:	b7d1                	j	80000a2c <uartintr+0x2e>
  }
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret

0000000080000a76 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a76:	1101                	addi	sp,sp,-32
    80000a78:	ec06                	sd	ra,24(sp)
    80000a7a:	e822                	sd	s0,16(sp)
    80000a7c:	e426                	sd	s1,8(sp)
    80000a7e:	e04a                	sd	s2,0(sp)
    80000a80:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a82:	00020797          	auipc	a5,0x20
    80000a86:	11678793          	addi	a5,a5,278 # 80020b98 <end>
    80000a8a:	00f53733          	sltu	a4,a0,a5
    80000a8e:	47c5                	li	a5,17
    80000a90:	07ee                	slli	a5,a5,0x1b
    80000a92:	17fd                	addi	a5,a5,-1
    80000a94:	00a7b7b3          	sltu	a5,a5,a0
    80000a98:	8fd9                	or	a5,a5,a4
    80000a9a:	03451713          	slli	a4,a0,0x34
    80000a9e:	8fd9                	or	a5,a5,a4
    80000aa0:	eb9d                	bnez	a5,80000ad6 <kfree+0x60>
    80000aa2:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000aa4:	6605                	lui	a2,0x1
    80000aa6:	4585                	li	a1,1
    80000aa8:	24c000ef          	jal	80000cf4 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000aac:	0000f917          	auipc	s2,0xf
    80000ab0:	ebc90913          	addi	s2,s2,-324 # 8000f968 <kmem>
    80000ab4:	854a                	mv	a0,s2
    80000ab6:	182000ef          	jal	80000c38 <acquire>
  r->next = kmem.freelist;
    80000aba:	01893783          	ld	a5,24(s2)
    80000abe:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ac0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ac4:	854a                	mv	a0,s2
    80000ac6:	1f6000ef          	jal	80000cbc <release>
}
    80000aca:	60e2                	ld	ra,24(sp)
    80000acc:	6442                	ld	s0,16(sp)
    80000ace:	64a2                	ld	s1,8(sp)
    80000ad0:	6902                	ld	s2,0(sp)
    80000ad2:	6105                	addi	sp,sp,32
    80000ad4:	8082                	ret
    panic("kfree");
    80000ad6:	00006517          	auipc	a0,0x6
    80000ada:	56250513          	addi	a0,a0,1378 # 80007038 <etext+0x38>
    80000ade:	d6bff0ef          	jal	80000848 <panic>

0000000080000ae2 <freerange>:
{
    80000ae2:	7179                	addi	sp,sp,-48
    80000ae4:	f406                	sd	ra,40(sp)
    80000ae6:	f022                	sd	s0,32(sp)
    80000ae8:	ec26                	sd	s1,24(sp)
    80000aea:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aec:	6785                	lui	a5,0x1
    80000aee:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000af2:	00e504b3          	add	s1,a0,a4
    80000af6:	777d                	lui	a4,0xfffff
    80000af8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000afa:	94be                	add	s1,s1,a5
    80000afc:	0295e263          	bltu	a1,s1,80000b20 <freerange+0x3e>
    80000b00:	e84a                	sd	s2,16(sp)
    80000b02:	e44e                	sd	s3,8(sp)
    80000b04:	e052                	sd	s4,0(sp)
    80000b06:	892e                	mv	s2,a1
    kfree(p);
    80000b08:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b0a:	89be                	mv	s3,a5
    kfree(p);
    80000b0c:	01448533          	add	a0,s1,s4
    80000b10:	f67ff0ef          	jal	80000a76 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b14:	94ce                	add	s1,s1,s3
    80000b16:	fe997be3          	bgeu	s2,s1,80000b0c <freerange+0x2a>
    80000b1a:	6942                	ld	s2,16(sp)
    80000b1c:	69a2                	ld	s3,8(sp)
    80000b1e:	6a02                	ld	s4,0(sp)
}
    80000b20:	70a2                	ld	ra,40(sp)
    80000b22:	7402                	ld	s0,32(sp)
    80000b24:	64e2                	ld	s1,24(sp)
    80000b26:	6145                	addi	sp,sp,48
    80000b28:	8082                	ret

0000000080000b2a <kinit>:
{
    80000b2a:	1141                	addi	sp,sp,-16
    80000b2c:	e406                	sd	ra,8(sp)
    80000b2e:	e022                	sd	s0,0(sp)
    80000b30:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b32:	00006597          	auipc	a1,0x6
    80000b36:	50e58593          	addi	a1,a1,1294 # 80007040 <etext+0x40>
    80000b3a:	0000f517          	auipc	a0,0xf
    80000b3e:	e2e50513          	addi	a0,a0,-466 # 8000f968 <kmem>
    80000b42:	076000ef          	jal	80000bb8 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b46:	45c5                	li	a1,17
    80000b48:	05ee                	slli	a1,a1,0x1b
    80000b4a:	00020517          	auipc	a0,0x20
    80000b4e:	04e50513          	addi	a0,a0,78 # 80020b98 <end>
    80000b52:	f91ff0ef          	jal	80000ae2 <freerange>
}
    80000b56:	60a2                	ld	ra,8(sp)
    80000b58:	6402                	ld	s0,0(sp)
    80000b5a:	0141                	addi	sp,sp,16
    80000b5c:	8082                	ret

0000000080000b5e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b5e:	1101                	addi	sp,sp,-32
    80000b60:	ec06                	sd	ra,24(sp)
    80000b62:	e822                	sd	s0,16(sp)
    80000b64:	e426                	sd	s1,8(sp)
    80000b66:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b68:	0000f517          	auipc	a0,0xf
    80000b6c:	e0050513          	addi	a0,a0,-512 # 8000f968 <kmem>
    80000b70:	0c8000ef          	jal	80000c38 <acquire>
  r = kmem.freelist;
    80000b74:	0000f497          	auipc	s1,0xf
    80000b78:	e0c4b483          	ld	s1,-500(s1) # 8000f980 <kmem+0x18>
  if (r)
    80000b7c:	c49d                	beqz	s1,80000baa <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b7e:	609c                	ld	a5,0(s1)
    80000b80:	0000f717          	auipc	a4,0xf
    80000b84:	e0f73023          	sd	a5,-512(a4) # 8000f980 <kmem+0x18>
  release(&kmem.lock);
    80000b88:	0000f517          	auipc	a0,0xf
    80000b8c:	de050513          	addi	a0,a0,-544 # 8000f968 <kmem>
    80000b90:	12c000ef          	jal	80000cbc <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b94:	6605                	lui	a2,0x1
    80000b96:	4595                	li	a1,5
    80000b98:	8526                	mv	a0,s1
    80000b9a:	15a000ef          	jal	80000cf4 <memset>
  return (void *)r;
}
    80000b9e:	8526                	mv	a0,s1
    80000ba0:	60e2                	ld	ra,24(sp)
    80000ba2:	6442                	ld	s0,16(sp)
    80000ba4:	64a2                	ld	s1,8(sp)
    80000ba6:	6105                	addi	sp,sp,32
    80000ba8:	8082                	ret
  release(&kmem.lock);
    80000baa:	0000f517          	auipc	a0,0xf
    80000bae:	dbe50513          	addi	a0,a0,-578 # 8000f968 <kmem>
    80000bb2:	10a000ef          	jal	80000cbc <release>
  if (r)
    80000bb6:	b7e5                	j	80000b9e <kalloc+0x40>

0000000080000bb8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bb8:	1141                	addi	sp,sp,-16
    80000bba:	e406                	sd	ra,8(sp)
    80000bbc:	e022                	sd	s0,0(sp)
    80000bbe:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bc0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bc2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bc6:	00053823          	sd	zero,16(a0)
}
    80000bca:	60a2                	ld	ra,8(sp)
    80000bcc:	6402                	ld	s0,0(sp)
    80000bce:	0141                	addi	sp,sp,16
    80000bd0:	8082                	ret

0000000080000bd2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bd2:	411c                	lw	a5,0(a0)
    80000bd4:	e399                	bnez	a5,80000bda <holding+0x8>
    80000bd6:	4501                	li	a0,0
  return r;
}
    80000bd8:	8082                	ret
{
    80000bda:	1101                	addi	sp,sp,-32
    80000bdc:	ec06                	sd	ra,24(sp)
    80000bde:	e822                	sd	s0,16(sp)
    80000be0:	e426                	sd	s1,8(sp)
    80000be2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000be4:	691c                	ld	a5,16(a0)
    80000be6:	84be                	mv	s1,a5
    80000be8:	51b000ef          	jal	80001902 <mycpu>
    80000bec:	40a48533          	sub	a0,s1,a0
    80000bf0:	00153513          	seqz	a0,a0
}
    80000bf4:	60e2                	ld	ra,24(sp)
    80000bf6:	6442                	ld	s0,16(sp)
    80000bf8:	64a2                	ld	s1,8(sp)
    80000bfa:	6105                	addi	sp,sp,32
    80000bfc:	8082                	ret

0000000080000bfe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bfe:	1101                	addi	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000c08:	100177f3          	csrrci	a5,sstatus,2
    80000c0c:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000c0e:	4f5000ef          	jal	80001902 <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	cb99                	beqz	a5,80000c2a <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c16:	4ed000ef          	jal	80001902 <mycpu>
    80000c1a:	5d3c                	lw	a5,120(a0)
    80000c1c:	2785                	addiw	a5,a5,1
    80000c1e:	dd3c                	sw	a5,120(a0)
}
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	addi	sp,sp,32
    80000c28:	8082                	ret
    mycpu()->intena = old;
    80000c2a:	4d9000ef          	jal	80001902 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000c2e:	0014d793          	srli	a5,s1,0x1
    80000c32:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000c34:	dd7c                	sw	a5,124(a0)
    80000c36:	b7c5                	j	80000c16 <push_off+0x18>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	fbbff0ef          	jal	80000bfe <push_off>
  if (holding(lk))
    80000c48:	8526                	mv	a0,s1
    80000c4a:	f89ff0ef          	jal	80000bd2 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c4e:	4705                	li	a4,1
  if (holding(lk))
    80000c50:	ed01                	bnez	a0,80000c68 <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c52:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c56:	fff5                	bnez	a5,80000c52 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c58:	4ab000ef          	jal	80001902 <mycpu>
    80000c5c:	e888                	sd	a0,16(s1)
}
    80000c5e:	60e2                	ld	ra,24(sp)
    80000c60:	6442                	ld	s0,16(sp)
    80000c62:	64a2                	ld	s1,8(sp)
    80000c64:	6105                	addi	sp,sp,32
    80000c66:	8082                	ret
    panic("acquire");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	3e050513          	addi	a0,a0,992 # 80007048 <etext+0x48>
    80000c70:	bd9ff0ef          	jal	80000848 <panic>

0000000080000c74 <pop_off>:

void
pop_off(void)
{
    80000c74:	1141                	addi	sp,sp,-16
    80000c76:	e406                	sd	ra,8(sp)
    80000c78:	e022                	sd	s0,0(sp)
    80000c7a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c7c:	487000ef          	jal	80001902 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c84:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c86:	ef99                	bnez	a5,80000ca4 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c88:	5d3c                	lw	a5,120(a0)
    80000c8a:	02f05363          	blez	a5,80000cb0 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c8e:	37fd                	addiw	a5,a5,-1
    80000c90:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c92:	e789                	bnez	a5,80000c9c <pop_off+0x28>
    80000c94:	5d7c                	lw	a5,124(a0)
    80000c96:	c399                	beqz	a5,80000c9c <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c98:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00006517          	auipc	a0,0x6
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80007050 <etext+0x50>
    80000cac:	b9dff0ef          	jal	80000848 <panic>
    panic("pop_off");
    80000cb0:	00006517          	auipc	a0,0x6
    80000cb4:	3b850513          	addi	a0,a0,952 # 80007068 <etext+0x68>
    80000cb8:	b91ff0ef          	jal	80000848 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000cc8:	f0bff0ef          	jal	80000bd2 <holding>
    80000ccc:	cd11                	beqz	a0,80000ce8 <release+0x2c>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000cd2:	0310000f          	fence	rw,w
    80000cd6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cda:	f9bff0ef          	jal	80000c74 <pop_off>
}
    80000cde:	60e2                	ld	ra,24(sp)
    80000ce0:	6442                	ld	s0,16(sp)
    80000ce2:	64a2                	ld	s1,8(sp)
    80000ce4:	6105                	addi	sp,sp,32
    80000ce6:	8082                	ret
    panic("release");
    80000ce8:	00006517          	auipc	a0,0x6
    80000cec:	38850513          	addi	a0,a0,904 # 80007070 <etext+0x70>
    80000cf0:	b59ff0ef          	jal	80000848 <panic>

0000000080000cf4 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e406                	sd	ra,8(sp)
    80000cf8:	e022                	sd	s0,0(sp)
    80000cfa:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cfc:	ca19                	beqz	a2,80000d12 <memset+0x1e>
    80000cfe:	87aa                	mv	a5,a0
    80000d00:	1602                	slli	a2,a2,0x20
    80000d02:	9201                	srli	a2,a2,0x20
    80000d04:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d08:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000d0c:	0785                	addi	a5,a5,1
    80000d0e:	fee79de3          	bne	a5,a4,80000d08 <memset+0x14>
  }
  return dst;
}
    80000d12:	60a2                	ld	ra,8(sp)
    80000d14:	6402                	ld	s0,0(sp)
    80000d16:	0141                	addi	sp,sp,16
    80000d18:	8082                	ret

0000000080000d1a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e406                	sd	ra,8(sp)
    80000d1e:	e022                	sd	s0,0(sp)
    80000d20:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000d22:	ce19                	beqz	a2,80000d40 <memcmp+0x26>
    80000d24:	1602                	slli	a2,a2,0x20
    80000d26:	9201                	srli	a2,a2,0x20
    80000d28:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000d2c:	00054783          	lbu	a5,0(a0)
    80000d30:	0005c703          	lbu	a4,0(a1)
    80000d34:	00e79b63          	bne	a5,a4,80000d4a <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000d38:	0505                	addi	a0,a0,1
    80000d3a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000d3c:	fed518e3          	bne	a0,a3,80000d2c <memcmp+0x12>
  }

  return 0;
    80000d40:	4501                	li	a0,0
}
    80000d42:	60a2                	ld	ra,8(sp)
    80000d44:	6402                	ld	s0,0(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
      return *s1 - *s2;
    80000d4a:	40e7853b          	subw	a0,a5,a4
    80000d4e:	bfd5                	j	80000d42 <memcmp+0x28>

0000000080000d50 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d50:	1141                	addi	sp,sp,-16
    80000d52:	e406                	sd	ra,8(sp)
    80000d54:	e022                	sd	s0,0(sp)
    80000d56:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d58:	c61d                	beqz	a2,80000d86 <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d5a:	00a5f963          	bgeu	a1,a0,80000d6c <memmove+0x1c>
    80000d5e:	02061693          	slli	a3,a2,0x20
    80000d62:	9281                	srli	a3,a3,0x20
    80000d64:	00d58733          	add	a4,a1,a3
    80000d68:	02e56363          	bltu	a0,a4,80000d8e <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d6c:	1602                	slli	a2,a2,0x20
    80000d6e:	9201                	srli	a2,a2,0x20
    80000d70:	00c587b3          	add	a5,a1,a2
{
    80000d74:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d76:	0585                	addi	a1,a1,1
    80000d78:	0705                	addi	a4,a4,1
    80000d7a:	fff5c683          	lbu	a3,-1(a1)
    80000d7e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d82:	fef59ae3          	bne	a1,a5,80000d76 <memmove+0x26>

  return dst;
}
    80000d86:	60a2                	ld	ra,8(sp)
    80000d88:	6402                	ld	s0,0(sp)
    80000d8a:	0141                	addi	sp,sp,16
    80000d8c:	8082                	ret
    d += n;
    80000d8e:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d90:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d94:	1782                	slli	a5,a5,0x20
    80000d96:	9381                	srli	a5,a5,0x20
    80000d98:	fff7c793          	not	a5,a5
    80000d9c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d9e:	177d                	addi	a4,a4,-1
    80000da0:	16fd                	addi	a3,a3,-1
    80000da2:	00074603          	lbu	a2,0(a4)
    80000da6:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000daa:	fee79ae3          	bne	a5,a4,80000d9e <memmove+0x4e>
    80000dae:	bfe1                	j	80000d86 <memmove+0x36>

0000000080000db0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000db0:	1141                	addi	sp,sp,-16
    80000db2:	e406                	sd	ra,8(sp)
    80000db4:	e022                	sd	s0,0(sp)
    80000db6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000db8:	f99ff0ef          	jal	80000d50 <memmove>
}
    80000dbc:	60a2                	ld	ra,8(sp)
    80000dbe:	6402                	ld	s0,0(sp)
    80000dc0:	0141                	addi	sp,sp,16
    80000dc2:	8082                	ret

0000000080000dc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dc4:	1141                	addi	sp,sp,-16
    80000dc6:	e406                	sd	ra,8(sp)
    80000dc8:	e022                	sd	s0,0(sp)
    80000dca:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000dcc:	ce01                	beqz	a2,80000de4 <strncmp+0x20>
    80000dce:	00054783          	lbu	a5,0(a0)
    80000dd2:	cb99                	beqz	a5,80000de8 <strncmp+0x24>
    80000dd4:	0005c703          	lbu	a4,0(a1)
    80000dd8:	00f71863          	bne	a4,a5,80000de8 <strncmp+0x24>
    n--, p++, q++;
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	0505                	addi	a0,a0,1
    80000de0:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000de2:	f675                	bnez	a2,80000dce <strncmp+0xa>
  if (n == 0)
    return 0;
    80000de4:	4501                	li	a0,0
    80000de6:	a031                	j	80000df2 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000de8:	00054503          	lbu	a0,0(a0)
    80000dec:	0005c783          	lbu	a5,0(a1)
    80000df0:	9d1d                	subw	a0,a0,a5
}
    80000df2:	60a2                	ld	ra,8(sp)
    80000df4:	6402                	ld	s0,0(sp)
    80000df6:	0141                	addi	sp,sp,16
    80000df8:	8082                	ret

0000000080000dfa <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dfa:	1141                	addi	sp,sp,-16
    80000dfc:	e406                	sd	ra,8(sp)
    80000dfe:	e022                	sd	s0,0(sp)
    80000e00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000e02:	87aa                	mv	a5,a0
    80000e04:	a011                	j	80000e08 <strncpy+0xe>
    80000e06:	8636                	mv	a2,a3
    80000e08:	02c05763          	blez	a2,80000e36 <strncpy+0x3c>
    80000e0c:	fff6069b          	addiw	a3,a2,-1
    80000e10:	0785                	addi	a5,a5,1
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	fee78fa3          	sb	a4,-1(a5)
    80000e1a:	0585                	addi	a1,a1,1
    80000e1c:	f76d                	bnez	a4,80000e06 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000e1e:	873e                	mv	a4,a5
    80000e20:	00d05b63          	blez	a3,80000e36 <strncpy+0x3c>
    80000e24:	9fb1                	addw	a5,a5,a2
    80000e26:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e28:	0705                	addi	a4,a4,1
    80000e2a:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000e2e:	40e786bb          	subw	a3,a5,a4
    80000e32:	fed04be3          	bgtz	a3,80000e28 <strncpy+0x2e>
  return os;
}
    80000e36:	60a2                	ld	ra,8(sp)
    80000e38:	6402                	ld	s0,0(sp)
    80000e3a:	0141                	addi	sp,sp,16
    80000e3c:	8082                	ret

0000000080000e3e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000e3e:	1141                	addi	sp,sp,-16
    80000e40:	e406                	sd	ra,8(sp)
    80000e42:	e022                	sd	s0,0(sp)
    80000e44:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e46:	02c05363          	blez	a2,80000e6c <safestrcpy+0x2e>
    80000e4a:	fff6069b          	addiw	a3,a2,-1
    80000e4e:	1682                	slli	a3,a3,0x20
    80000e50:	9281                	srli	a3,a3,0x20
    80000e52:	96ae                	add	a3,a3,a1
    80000e54:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e56:	00d58963          	beq	a1,a3,80000e68 <safestrcpy+0x2a>
    80000e5a:	0585                	addi	a1,a1,1
    80000e5c:	0785                	addi	a5,a5,1
    80000e5e:	fff5c703          	lbu	a4,-1(a1)
    80000e62:	fee78fa3          	sb	a4,-1(a5)
    80000e66:	fb65                	bnez	a4,80000e56 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e68:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e6c:	60a2                	ld	ra,8(sp)
    80000e6e:	6402                	ld	s0,0(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret

0000000080000e74 <strlen>:

int
strlen(const char *s)
{
    80000e74:	1141                	addi	sp,sp,-16
    80000e76:	e406                	sd	ra,8(sp)
    80000e78:	e022                	sd	s0,0(sp)
    80000e7a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e7c:	00054783          	lbu	a5,0(a0)
    80000e80:	cf91                	beqz	a5,80000e9c <strlen+0x28>
    80000e82:	00150793          	addi	a5,a0,1
    80000e86:	86be                	mv	a3,a5
    80000e88:	0785                	addi	a5,a5,1
    80000e8a:	fff7c703          	lbu	a4,-1(a5)
    80000e8e:	ff65                	bnez	a4,80000e86 <strlen+0x12>
    80000e90:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e94:	60a2                	ld	ra,8(sp)
    80000e96:	6402                	ld	s0,0(sp)
    80000e98:	0141                	addi	sp,sp,16
    80000e9a:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e9c:	4501                	li	a0,0
    80000e9e:	bfdd                	j	80000e94 <strlen+0x20>

0000000080000ea0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ea0:	1141                	addi	sp,sp,-16
    80000ea2:	e406                	sd	ra,8(sp)
    80000ea4:	e022                	sd	s0,0(sp)
    80000ea6:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000ea8:	247000ef          	jal	800018ee <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000eac:	00007717          	auipc	a4,0x7
    80000eb0:	9c470713          	addi	a4,a4,-1596 # 80007870 <started>
  if (cpuid() == 0) {
    80000eb4:	c51d                	beqz	a0,80000ee2 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000eb6:	431c                	lw	a5,0(a4)
    80000eb8:	0230000f          	fence	r,rw
    80000ebc:	2781                	sext.w	a5,a5
    80000ebe:	dfe5                	beqz	a5,80000eb6 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000ec0:	22f000ef          	jal	800018ee <cpuid>
    80000ec4:	85aa                	mv	a1,a0
    80000ec6:	00006517          	auipc	a0,0x6
    80000eca:	1d250513          	addi	a0,a0,466 # 80007098 <etext+0x98>
    80000ece:	e42ff0ef          	jal	80000510 <printk>
    kvminithart();  // turn on paging
    80000ed2:	082000ef          	jal	80000f54 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000ed6:	596010ef          	jal	8000246c <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000eda:	6fe040ef          	jal	800055d8 <plicinithart>
  }

  scheduler();
    80000ede:	6a7000ef          	jal	80001d84 <scheduler>
    consoleinit();
    80000ee2:	d56ff0ef          	jal	80000438 <consoleinit>
    printkinit();
    80000ee6:	99fff0ef          	jal	80000884 <printkinit>
    printk("\n");
    80000eea:	00006517          	auipc	a0,0x6
    80000eee:	18e50513          	addi	a0,a0,398 # 80007078 <etext+0x78>
    80000ef2:	e1eff0ef          	jal	80000510 <printk>
    printk("xv6 kernel is booting\n");
    80000ef6:	00006517          	auipc	a0,0x6
    80000efa:	18a50513          	addi	a0,a0,394 # 80007080 <etext+0x80>
    80000efe:	e12ff0ef          	jal	80000510 <printk>
    printk("\n");
    80000f02:	00006517          	auipc	a0,0x6
    80000f06:	17650513          	addi	a0,a0,374 # 80007078 <etext+0x78>
    80000f0a:	e06ff0ef          	jal	80000510 <printk>
    kinit();            // physical page allocator
    80000f0e:	c1dff0ef          	jal	80000b2a <kinit>
    kvminit();          // create kernel page table
    80000f12:	2c2000ef          	jal	800011d4 <kvminit>
    kvminithart();      // turn on paging
    80000f16:	03e000ef          	jal	80000f54 <kvminithart>
    procinit();         // process table
    80000f1a:	11d000ef          	jal	80001836 <procinit>
    trapinit();         // trap vectors
    80000f1e:	52a010ef          	jal	80002448 <trapinit>
    trapinithart();     // install kernel trap vector
    80000f22:	54a010ef          	jal	8000246c <trapinithart>
    plicinit();         // set up interrupt controller
    80000f26:	698040ef          	jal	800055be <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000f2a:	6ae040ef          	jal	800055d8 <plicinithart>
    binit();            // buffer cache
    80000f2e:	3eb010ef          	jal	80002b18 <binit>
    iinit();            // inode table
    80000f32:	144020ef          	jal	80003076 <iinit>
    fileinit();         // file table
    80000f36:	178030ef          	jal	800040ae <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f3a:	794040ef          	jal	800056ce <virtio_disk_init>
    userinit();         // first user process
    80000f3e:	4a5000ef          	jal	80001be2 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f42:	00007797          	auipc	a5,0x7
    80000f46:	92e78793          	addi	a5,a5,-1746 # 80007870 <started>
    80000f4a:	4705                	li	a4,1
    80000f4c:	0310000f          	fence	rw,w
    80000f50:	c398                	sw	a4,0(a5)
    80000f52:	b771                	j	80000ede <main+0x3e>

0000000080000f54 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e406                	sd	ra,8(sp)
    80000f58:	e022                	sd	s0,0(sp)
    80000f5a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f5c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f60:	00007797          	auipc	a5,0x7
    80000f64:	9187b783          	ld	a5,-1768(a5) # 80007878 <kernel_pagetable>
    80000f68:	83b1                	srli	a5,a5,0xc
    80000f6a:	577d                	li	a4,-1
    80000f6c:	177e                	slli	a4,a4,0x3f
    80000f6e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f70:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f74:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f78:	60a2                	ld	ra,8(sp)
    80000f7a:	6402                	ld	s0,0(sp)
    80000f7c:	0141                	addi	sp,sp,16
    80000f7e:	8082                	ret

0000000080000f80 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f80:	7139                	addi	sp,sp,-64
    80000f82:	fc06                	sd	ra,56(sp)
    80000f84:	f822                	sd	s0,48(sp)
    80000f86:	f426                	sd	s1,40(sp)
    80000f88:	f04a                	sd	s2,32(sp)
    80000f8a:	ec4e                	sd	s3,24(sp)
    80000f8c:	e852                	sd	s4,16(sp)
    80000f8e:	e456                	sd	s5,8(sp)
    80000f90:	e05a                	sd	s6,0(sp)
    80000f92:	0080                	addi	s0,sp,64
    80000f94:	84aa                	mv	s1,a0
    80000f96:	89ae                	mv	s3,a1
    80000f98:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f9a:	57fd                	li	a5,-1
    80000f9c:	83e9                	srli	a5,a5,0x1a
    80000f9e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000fa0:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000fa2:	06b7e363          	bltu	a5,a1,80001008 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fa6:	0149d933          	srl	s2,s3,s4
    80000faa:	1ff97913          	andi	s2,s2,511
    80000fae:	090e                	slli	s2,s2,0x3
    80000fb0:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000fb2:	00093483          	ld	s1,0(s2)
    80000fb6:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fba:	80a9                	srli	s1,s1,0xa
    80000fbc:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000fbe:	e395                	bnez	a5,80000fe2 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fc0:	040b0a63          	beqz	s6,80001014 <walk+0x94>
    80000fc4:	b9bff0ef          	jal	80000b5e <kalloc>
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	c50d                	beqz	a0,80000ff4 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fcc:	6605                	lui	a2,0x1
    80000fce:	4581                	li	a1,0
    80000fd0:	d25ff0ef          	jal	80000cf4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fd4:	00c4d793          	srli	a5,s1,0xc
    80000fd8:	07aa                	slli	a5,a5,0xa
    80000fda:	0017e793          	ori	a5,a5,1
    80000fde:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fe2:	3a5d                	addiw	s4,s4,-9
    80000fe4:	fd5a11e3          	bne	s4,s5,80000fa6 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fe8:	00c9d513          	srli	a0,s3,0xc
    80000fec:	1ff57513          	andi	a0,a0,511
    80000ff0:	050e                	slli	a0,a0,0x3
    80000ff2:	9526                	add	a0,a0,s1
}
    80000ff4:	70e2                	ld	ra,56(sp)
    80000ff6:	7442                	ld	s0,48(sp)
    80000ff8:	74a2                	ld	s1,40(sp)
    80000ffa:	7902                	ld	s2,32(sp)
    80000ffc:	69e2                	ld	s3,24(sp)
    80000ffe:	6a42                	ld	s4,16(sp)
    80001000:	6aa2                	ld	s5,8(sp)
    80001002:	6b02                	ld	s6,0(sp)
    80001004:	6121                	addi	sp,sp,64
    80001006:	8082                	ret
    panic("walk");
    80001008:	00006517          	auipc	a0,0x6
    8000100c:	0a850513          	addi	a0,a0,168 # 800070b0 <etext+0xb0>
    80001010:	839ff0ef          	jal	80000848 <panic>
        return 0;
    80001014:	4501                	li	a0,0
    80001016:	bff9                	j	80000ff4 <walk+0x74>

0000000080001018 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001018:	57fd                	li	a5,-1
    8000101a:	83e9                	srli	a5,a5,0x1a
    8000101c:	00b7f463          	bgeu	a5,a1,80001024 <walkaddr+0xc>
    return 0;
    80001020:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001022:	8082                	ret
{
    80001024:	1141                	addi	sp,sp,-16
    80001026:	e406                	sd	ra,8(sp)
    80001028:	e022                	sd	s0,0(sp)
    8000102a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000102c:	4601                	li	a2,0
    8000102e:	f53ff0ef          	jal	80000f80 <walk>
  if (pte == 0)
    80001032:	c519                	beqz	a0,80001040 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80001034:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80001036:	01157713          	andi	a4,a0,17
    8000103a:	47c5                	li	a5,17
    8000103c:	00f70763          	beq	a4,a5,8000104a <walkaddr+0x32>
    return 0;
    80001040:	4501                	li	a0,0
}
    80001042:	60a2                	ld	ra,8(sp)
    80001044:	6402                	ld	s0,0(sp)
    80001046:	0141                	addi	sp,sp,16
    80001048:	8082                	ret
  pa = PTE2PA(*pte);
    8000104a:	8129                	srli	a0,a0,0xa
    8000104c:	0532                	slli	a0,a0,0xc
  return pa;
    8000104e:	bfd5                	j	80001042 <walkaddr+0x2a>

0000000080001050 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001050:	715d                	addi	sp,sp,-80
    80001052:	e486                	sd	ra,72(sp)
    80001054:	e0a2                	sd	s0,64(sp)
    80001056:	fc26                	sd	s1,56(sp)
    80001058:	f84a                	sd	s2,48(sp)
    8000105a:	f44e                	sd	s3,40(sp)
    8000105c:	f052                	sd	s4,32(sp)
    8000105e:	ec56                	sd	s5,24(sp)
    80001060:	e85a                	sd	s6,16(sp)
    80001062:	e45e                	sd	s7,8(sp)
    80001064:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001066:	03459793          	slli	a5,a1,0x34
    8000106a:	e7b1                	bnez	a5,800010b6 <mappages+0x66>
    8000106c:	8a2a                	mv	s4,a0
    8000106e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001070:	03461793          	slli	a5,a2,0x34
    80001074:	e7b9                	bnez	a5,800010c2 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001076:	ce21                	beqz	a2,800010ce <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001078:	77fd                	lui	a5,0xfffff
    8000107a:	963e                	add	a2,a2,a5
    8000107c:	00b60933          	add	s2,a2,a1
  a = va;
    80001080:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001082:	4b05                	li	s6,1
    80001084:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001088:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000108a:	865a                	mv	a2,s6
    8000108c:	85a6                	mv	a1,s1
    8000108e:	8552                	mv	a0,s4
    80001090:	ef1ff0ef          	jal	80000f80 <walk>
    80001094:	c929                	beqz	a0,800010e6 <mappages+0x96>
    if (*pte & PTE_V)
    80001096:	611c                	ld	a5,0(a0)
    80001098:	8b85                	andi	a5,a5,1
    8000109a:	e3a1                	bnez	a5,800010da <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000109c:	013487b3          	add	a5,s1,s3
    800010a0:	83b1                	srli	a5,a5,0xc
    800010a2:	07aa                	slli	a5,a5,0xa
    800010a4:	0157e7b3          	or	a5,a5,s5
    800010a8:	0017e793          	ori	a5,a5,1
    800010ac:	e11c                	sd	a5,0(a0)
    if (a == last)
    800010ae:	05248863          	beq	s1,s2,800010fe <mappages+0xae>
    a += PGSIZE;
    800010b2:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800010b4:	bfd9                	j	8000108a <mappages+0x3a>
    panic("mappages: va not aligned");
    800010b6:	00006517          	auipc	a0,0x6
    800010ba:	00250513          	addi	a0,a0,2 # 800070b8 <etext+0xb8>
    800010be:	f8aff0ef          	jal	80000848 <panic>
    panic("mappages: size not aligned");
    800010c2:	00006517          	auipc	a0,0x6
    800010c6:	01650513          	addi	a0,a0,22 # 800070d8 <etext+0xd8>
    800010ca:	f7eff0ef          	jal	80000848 <panic>
    panic("mappages: size");
    800010ce:	00006517          	auipc	a0,0x6
    800010d2:	02a50513          	addi	a0,a0,42 # 800070f8 <etext+0xf8>
    800010d6:	f72ff0ef          	jal	80000848 <panic>
      panic("mappages: remap");
    800010da:	00006517          	auipc	a0,0x6
    800010de:	02e50513          	addi	a0,a0,46 # 80007108 <etext+0x108>
    800010e2:	f66ff0ef          	jal	80000848 <panic>
      return -1;
    800010e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010e8:	60a6                	ld	ra,72(sp)
    800010ea:	6406                	ld	s0,64(sp)
    800010ec:	74e2                	ld	s1,56(sp)
    800010ee:	7942                	ld	s2,48(sp)
    800010f0:	79a2                	ld	s3,40(sp)
    800010f2:	7a02                	ld	s4,32(sp)
    800010f4:	6ae2                	ld	s5,24(sp)
    800010f6:	6b42                	ld	s6,16(sp)
    800010f8:	6ba2                	ld	s7,8(sp)
    800010fa:	6161                	addi	sp,sp,80
    800010fc:	8082                	ret
  return 0;
    800010fe:	4501                	li	a0,0
    80001100:	b7e5                	j	800010e8 <mappages+0x98>

0000000080001102 <kvmmap>:
{
    80001102:	1141                	addi	sp,sp,-16
    80001104:	e406                	sd	ra,8(sp)
    80001106:	e022                	sd	s0,0(sp)
    80001108:	0800                	addi	s0,sp,16
    8000110a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000110c:	86b2                	mv	a3,a2
    8000110e:	863e                	mv	a2,a5
    80001110:	f41ff0ef          	jal	80001050 <mappages>
    80001114:	e509                	bnez	a0,8000111e <kvmmap+0x1c>
}
    80001116:	60a2                	ld	ra,8(sp)
    80001118:	6402                	ld	s0,0(sp)
    8000111a:	0141                	addi	sp,sp,16
    8000111c:	8082                	ret
    panic("kvmmap");
    8000111e:	00006517          	auipc	a0,0x6
    80001122:	ffa50513          	addi	a0,a0,-6 # 80007118 <etext+0x118>
    80001126:	f22ff0ef          	jal	80000848 <panic>

000000008000112a <kvmmake>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	e04a                	sd	s2,0(sp)
    80001134:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001136:	a29ff0ef          	jal	80000b5e <kalloc>
    8000113a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000113c:	6605                	lui	a2,0x1
    8000113e:	4581                	li	a1,0
    80001140:	bb5ff0ef          	jal	80000cf4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001144:	4719                	li	a4,6
    80001146:	6685                	lui	a3,0x1
    80001148:	10000637          	lui	a2,0x10000
    8000114c:	85b2                	mv	a1,a2
    8000114e:	8526                	mv	a0,s1
    80001150:	fb3ff0ef          	jal	80001102 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001154:	4719                	li	a4,6
    80001156:	6685                	lui	a3,0x1
    80001158:	10001637          	lui	a2,0x10001
    8000115c:	85b2                	mv	a1,a2
    8000115e:	8526                	mv	a0,s1
    80001160:	fa3ff0ef          	jal	80001102 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001164:	4719                	li	a4,6
    80001166:	040006b7          	lui	a3,0x4000
    8000116a:	0c000637          	lui	a2,0xc000
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	f91ff0ef          	jal	80001102 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001176:	00006917          	auipc	s2,0x6
    8000117a:	e8a90913          	addi	s2,s2,-374 # 80007000 <etext>
    8000117e:	4729                	li	a4,10
    80001180:	800006b7          	lui	a3,0x80000
    80001184:	96ca                	add	a3,a3,s2
    80001186:	4605                	li	a2,1
    80001188:	067e                	slli	a2,a2,0x1f
    8000118a:	85b2                	mv	a1,a2
    8000118c:	8526                	mv	a0,s1
    8000118e:	f75ff0ef          	jal	80001102 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001192:	4719                	li	a4,6
    80001194:	46c5                	li	a3,17
    80001196:	06ee                	slli	a3,a3,0x1b
    80001198:	412686b3          	sub	a3,a3,s2
    8000119c:	864a                	mv	a2,s2
    8000119e:	85ca                	mv	a1,s2
    800011a0:	8526                	mv	a0,s1
    800011a2:	f61ff0ef          	jal	80001102 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011a6:	4729                	li	a4,10
    800011a8:	6685                	lui	a3,0x1
    800011aa:	00005617          	auipc	a2,0x5
    800011ae:	e5660613          	addi	a2,a2,-426 # 80006000 <_trampoline>
    800011b2:	040005b7          	lui	a1,0x4000
    800011b6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b8:	05b2                	slli	a1,a1,0xc
    800011ba:	8526                	mv	a0,s1
    800011bc:	f47ff0ef          	jal	80001102 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011c0:	8526                	mv	a0,s1
    800011c2:	5e0000ef          	jal	800017a2 <proc_mapstacks>
}
    800011c6:	8526                	mv	a0,s1
    800011c8:	60e2                	ld	ra,24(sp)
    800011ca:	6442                	ld	s0,16(sp)
    800011cc:	64a2                	ld	s1,8(sp)
    800011ce:	6902                	ld	s2,0(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <kvminit>:
{
    800011d4:	1141                	addi	sp,sp,-16
    800011d6:	e406                	sd	ra,8(sp)
    800011d8:	e022                	sd	s0,0(sp)
    800011da:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011dc:	f4fff0ef          	jal	8000112a <kvmmake>
    800011e0:	00006797          	auipc	a5,0x6
    800011e4:	68a7bc23          	sd	a0,1688(a5) # 80007878 <kernel_pagetable>
}
    800011e8:	60a2                	ld	ra,8(sp)
    800011ea:	6402                	ld	s0,0(sp)
    800011ec:	0141                	addi	sp,sp,16
    800011ee:	8082                	ret

00000000800011f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011fa:	965ff0ef          	jal	80000b5e <kalloc>
    800011fe:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001200:	c509                	beqz	a0,8000120a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001202:	6605                	lui	a2,0x1
    80001204:	4581                	li	a1,0
    80001206:	aefff0ef          	jal	80000cf4 <memset>
  return pagetable;
}
    8000120a:	8526                	mv	a0,s1
    8000120c:	60e2                	ld	ra,24(sp)
    8000120e:	6442                	ld	s0,16(sp)
    80001210:	64a2                	ld	s1,8(sp)
    80001212:	6105                	addi	sp,sp,32
    80001214:	8082                	ret

0000000080001216 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000121e:	03459793          	slli	a5,a1,0x34
    80001222:	e38d                	bnez	a5,80001244 <uvmunmap+0x2e>
    80001224:	f04a                	sd	s2,32(sp)
    80001226:	ec4e                	sd	s3,24(sp)
    80001228:	e852                	sd	s4,16(sp)
    8000122a:	e456                	sd	s5,8(sp)
    8000122c:	e05a                	sd	s6,0(sp)
    8000122e:	8a2a                	mv	s4,a0
    80001230:	892e                	mv	s2,a1
    80001232:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001234:	0632                	slli	a2,a2,0xc
    80001236:	00b609b3          	add	s3,a2,a1
    8000123a:	6b05                	lui	s6,0x1
    8000123c:	0535f963          	bgeu	a1,s3,8000128e <uvmunmap+0x78>
    80001240:	f426                	sd	s1,40(sp)
    80001242:	a015                	j	80001266 <uvmunmap+0x50>
    80001244:	f426                	sd	s1,40(sp)
    80001246:	f04a                	sd	s2,32(sp)
    80001248:	ec4e                	sd	s3,24(sp)
    8000124a:	e852                	sd	s4,16(sp)
    8000124c:	e456                	sd	s5,8(sp)
    8000124e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001250:	00006517          	auipc	a0,0x6
    80001254:	ed050513          	addi	a0,a0,-304 # 80007120 <etext+0x120>
    80001258:	df0ff0ef          	jal	80000848 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000125c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001260:	995a                	add	s2,s2,s6
    80001262:	03397563          	bgeu	s2,s3,8000128c <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001266:	4601                	li	a2,0
    80001268:	85ca                	mv	a1,s2
    8000126a:	8552                	mv	a0,s4
    8000126c:	d15ff0ef          	jal	80000f80 <walk>
    80001270:	84aa                	mv	s1,a0
    80001272:	d57d                	beqz	a0,80001260 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001274:	611c                	ld	a5,0(a0)
    80001276:	0017f713          	andi	a4,a5,1
    8000127a:	d37d                	beqz	a4,80001260 <uvmunmap+0x4a>
    if (do_free) {
    8000127c:	fe0a80e3          	beqz	s5,8000125c <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001280:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001282:	00c79513          	slli	a0,a5,0xc
    80001286:	ff0ff0ef          	jal	80000a76 <kfree>
    8000128a:	bfc9                	j	8000125c <uvmunmap+0x46>
    8000128c:	74a2                	ld	s1,40(sp)
    8000128e:	7902                	ld	s2,32(sp)
    80001290:	69e2                	ld	s3,24(sp)
    80001292:	6a42                	ld	s4,16(sp)
    80001294:	6aa2                	ld	s5,8(sp)
    80001296:	6b02                	ld	s6,0(sp)
  }
}
    80001298:	70e2                	ld	ra,56(sp)
    8000129a:	7442                	ld	s0,48(sp)
    8000129c:	6121                	addi	sp,sp,64
    8000129e:	8082                	ret

00000000800012a0 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    800012a0:	04b67163          	bgeu	a2,a1,800012e2 <uvmdealloc+0x42>
{
    800012a4:	1101                	addi	sp,sp,-32
    800012a6:	ec06                	sd	ra,24(sp)
    800012a8:	e822                	sd	s0,16(sp)
    800012aa:	e426                	sd	s1,8(sp)
    800012ac:	1000                	addi	s0,sp,32
    800012ae:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800012b0:	6785                	lui	a5,0x1
    800012b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012b4:	00f60733          	add	a4,a2,a5
    800012b8:	76fd                	lui	a3,0xfffff
    800012ba:	8f75                	and	a4,a4,a3
    800012bc:	97ae                	add	a5,a5,a1
    800012be:	8ff5                	and	a5,a5,a3
    800012c0:	00f76863          	bltu	a4,a5,800012d0 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    800012c4:	8526                	mv	a0,s1
}
    800012c6:	60e2                	ld	ra,24(sp)
    800012c8:	6442                	ld	s0,16(sp)
    800012ca:	64a2                	ld	s1,8(sp)
    800012cc:	6105                	addi	sp,sp,32
    800012ce:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012d0:	8f99                	sub	a5,a5,a4
    800012d2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012d4:	4685                	li	a3,1
    800012d6:	0007861b          	sext.w	a2,a5
    800012da:	85ba                	mv	a1,a4
    800012dc:	f3bff0ef          	jal	80001216 <uvmunmap>
    800012e0:	b7d5                	j	800012c4 <uvmdealloc+0x24>
    return oldsz;
    800012e2:	852e                	mv	a0,a1
}
    800012e4:	8082                	ret

00000000800012e6 <uvmalloc>:
  if (newsz < oldsz)
    800012e6:	08b66e63          	bltu	a2,a1,80001382 <uvmalloc+0x9c>
{
    800012ea:	715d                	addi	sp,sp,-80
    800012ec:	e486                	sd	ra,72(sp)
    800012ee:	e0a2                	sd	s0,64(sp)
    800012f0:	f052                	sd	s4,32(sp)
    800012f2:	ec56                	sd	s5,24(sp)
    800012f4:	e45e                	sd	s7,8(sp)
    800012f6:	0880                	addi	s0,sp,80
    800012f8:	8aaa                	mv	s5,a0
    800012fa:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012fc:	6785                	lui	a5,0x1
    800012fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001300:	95be                	add	a1,a1,a5
    80001302:	77fd                	lui	a5,0xfffff
    80001304:	8fed                	and	a5,a5,a1
    80001306:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001308:	04c7f163          	bgeu	a5,a2,8000134a <uvmalloc+0x64>
    8000130c:	fc26                	sd	s1,56(sp)
    8000130e:	f84a                	sd	s2,48(sp)
    80001310:	f44e                	sd	s3,40(sp)
    80001312:	e85a                	sd	s6,16(sp)
    80001314:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    80001316:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001318:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000131c:	843ff0ef          	jal	80000b5e <kalloc>
    80001320:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001322:	c515                	beqz	a0,8000134e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80001324:	864e                	mv	a2,s3
    80001326:	4581                	li	a1,0
    80001328:	9cdff0ef          	jal	80000cf4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000132c:	875a                	mv	a4,s6
    8000132e:	86a6                	mv	a3,s1
    80001330:	864e                	mv	a2,s3
    80001332:	85ca                	mv	a1,s2
    80001334:	8556                	mv	a0,s5
    80001336:	d1bff0ef          	jal	80001050 <mappages>
    8000133a:	e91d                	bnez	a0,80001370 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000133c:	994e                	add	s2,s2,s3
    8000133e:	fd496fe3          	bltu	s2,s4,8000131c <uvmalloc+0x36>
    80001342:	74e2                	ld	s1,56(sp)
    80001344:	7942                	ld	s2,48(sp)
    80001346:	79a2                	ld	s3,40(sp)
    80001348:	6b42                	ld	s6,16(sp)
  return newsz;
    8000134a:	8552                	mv	a0,s4
    8000134c:	a819                	j	80001362 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000134e:	865e                	mv	a2,s7
    80001350:	85ca                	mv	a1,s2
    80001352:	8556                	mv	a0,s5
    80001354:	f4dff0ef          	jal	800012a0 <uvmdealloc>
      return 0;
    80001358:	4501                	li	a0,0
    8000135a:	74e2                	ld	s1,56(sp)
    8000135c:	7942                	ld	s2,48(sp)
    8000135e:	79a2                	ld	s3,40(sp)
    80001360:	6b42                	ld	s6,16(sp)
}
    80001362:	60a6                	ld	ra,72(sp)
    80001364:	6406                	ld	s0,64(sp)
    80001366:	7a02                	ld	s4,32(sp)
    80001368:	6ae2                	ld	s5,24(sp)
    8000136a:	6ba2                	ld	s7,8(sp)
    8000136c:	6161                	addi	sp,sp,80
    8000136e:	8082                	ret
      kfree(mem);
    80001370:	8526                	mv	a0,s1
    80001372:	f04ff0ef          	jal	80000a76 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001376:	865e                	mv	a2,s7
    80001378:	85ca                	mv	a1,s2
    8000137a:	8556                	mv	a0,s5
    8000137c:	f25ff0ef          	jal	800012a0 <uvmdealloc>
      return 0;
    80001380:	bfe1                	j	80001358 <uvmalloc+0x72>
    return oldsz;
    80001382:	852e                	mv	a0,a1
}
    80001384:	8082                	ret

0000000080001386 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001386:	7179                	addi	sp,sp,-48
    80001388:	f406                	sd	ra,40(sp)
    8000138a:	f022                	sd	s0,32(sp)
    8000138c:	ec26                	sd	s1,24(sp)
    8000138e:	e84a                	sd	s2,16(sp)
    80001390:	e44e                	sd	s3,8(sp)
    80001392:	1800                	addi	s0,sp,48
    80001394:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001396:	84aa                	mv	s1,a0
    80001398:	6905                	lui	s2,0x1
    8000139a:	992a                	add	s2,s2,a0
    8000139c:	a811                	j	800013b0 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000139e:	00006517          	auipc	a0,0x6
    800013a2:	d9a50513          	addi	a0,a0,-614 # 80007138 <etext+0x138>
    800013a6:	ca2ff0ef          	jal	80000848 <panic>
  for (int i = 0; i < 512; i++) {
    800013aa:	04a1                	addi	s1,s1,8
    800013ac:	03248163          	beq	s1,s2,800013ce <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013b0:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013b2:	0017f713          	andi	a4,a5,1
    800013b6:	db75                	beqz	a4,800013aa <freewalk+0x24>
    800013b8:	00e7f713          	andi	a4,a5,14
    800013bc:	f36d                	bnez	a4,8000139e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013be:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013c0:	00c79513          	slli	a0,a5,0xc
    800013c4:	fc3ff0ef          	jal	80001386 <freewalk>
      pagetable[i] = 0;
    800013c8:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013cc:	bff9                	j	800013aa <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013ce:	854e                	mv	a0,s3
    800013d0:	ea6ff0ef          	jal	80000a76 <kfree>
}
    800013d4:	70a2                	ld	ra,40(sp)
    800013d6:	7402                	ld	s0,32(sp)
    800013d8:	64e2                	ld	s1,24(sp)
    800013da:	6942                	ld	s2,16(sp)
    800013dc:	69a2                	ld	s3,8(sp)
    800013de:	6145                	addi	sp,sp,48
    800013e0:	8082                	ret

00000000800013e2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013e2:	1101                	addi	sp,sp,-32
    800013e4:	ec06                	sd	ra,24(sp)
    800013e6:	e822                	sd	s0,16(sp)
    800013e8:	e426                	sd	s1,8(sp)
    800013ea:	1000                	addi	s0,sp,32
    800013ec:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ee:	e989                	bnez	a1,80001400 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013f0:	8526                	mv	a0,s1
    800013f2:	f95ff0ef          	jal	80001386 <freewalk>
}
    800013f6:	60e2                	ld	ra,24(sp)
    800013f8:	6442                	ld	s0,16(sp)
    800013fa:	64a2                	ld	s1,8(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001400:	6785                	lui	a5,0x1
    80001402:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001404:	95be                	add	a1,a1,a5
    80001406:	4685                	li	a3,1
    80001408:	00c5d613          	srli	a2,a1,0xc
    8000140c:	4581                	li	a1,0
    8000140e:	e09ff0ef          	jal	80001216 <uvmunmap>
    80001412:	bff9                	j	800013f0 <uvmfree+0xe>

0000000080001414 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80001414:	ca59                	beqz	a2,800014aa <uvmcopy+0x96>
{
    80001416:	715d                	addi	sp,sp,-80
    80001418:	e486                	sd	ra,72(sp)
    8000141a:	e0a2                	sd	s0,64(sp)
    8000141c:	fc26                	sd	s1,56(sp)
    8000141e:	f84a                	sd	s2,48(sp)
    80001420:	f44e                	sd	s3,40(sp)
    80001422:	f052                	sd	s4,32(sp)
    80001424:	ec56                	sd	s5,24(sp)
    80001426:	e85a                	sd	s6,16(sp)
    80001428:	e45e                	sd	s7,8(sp)
    8000142a:	0880                	addi	s0,sp,80
    8000142c:	8b2a                	mv	s6,a0
    8000142e:	8bae                	mv	s7,a1
    80001430:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001432:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001434:	6a05                	lui	s4,0x1
    80001436:	a021                	j	8000143e <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    80001438:	94d2                	add	s1,s1,s4
    8000143a:	0554fc63          	bgeu	s1,s5,80001492 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    8000143e:	4601                	li	a2,0
    80001440:	85a6                	mv	a1,s1
    80001442:	855a                	mv	a0,s6
    80001444:	b3dff0ef          	jal	80000f80 <walk>
    80001448:	d965                	beqz	a0,80001438 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000144a:	00053983          	ld	s3,0(a0)
    8000144e:	0019f793          	andi	a5,s3,1
    80001452:	d3fd                	beqz	a5,80001438 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001454:	f0aff0ef          	jal	80000b5e <kalloc>
    80001458:	892a                	mv	s2,a0
    8000145a:	c11d                	beqz	a0,80001480 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000145c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001460:	8652                	mv	a2,s4
    80001462:	05b2                	slli	a1,a1,0xc
    80001464:	8edff0ef          	jal	80000d50 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001468:	3ff9f713          	andi	a4,s3,1023
    8000146c:	86ca                	mv	a3,s2
    8000146e:	8652                	mv	a2,s4
    80001470:	85a6                	mv	a1,s1
    80001472:	855e                	mv	a0,s7
    80001474:	bddff0ef          	jal	80001050 <mappages>
    80001478:	d161                	beqz	a0,80001438 <uvmcopy+0x24>
      kfree(mem);
    8000147a:	854a                	mv	a0,s2
    8000147c:	dfaff0ef          	jal	80000a76 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001480:	4685                	li	a3,1
    80001482:	00c4d613          	srli	a2,s1,0xc
    80001486:	4581                	li	a1,0
    80001488:	855e                	mv	a0,s7
    8000148a:	d8dff0ef          	jal	80001216 <uvmunmap>
  return -1;
    8000148e:	557d                	li	a0,-1
    80001490:	a011                	j	80001494 <uvmcopy+0x80>
  return 0;
    80001492:	4501                	li	a0,0
}
    80001494:	60a6                	ld	ra,72(sp)
    80001496:	6406                	ld	s0,64(sp)
    80001498:	74e2                	ld	s1,56(sp)
    8000149a:	7942                	ld	s2,48(sp)
    8000149c:	79a2                	ld	s3,40(sp)
    8000149e:	7a02                	ld	s4,32(sp)
    800014a0:	6ae2                	ld	s5,24(sp)
    800014a2:	6b42                	ld	s6,16(sp)
    800014a4:	6ba2                	ld	s7,8(sp)
    800014a6:	6161                	addi	sp,sp,80
    800014a8:	8082                	ret
  return 0;
    800014aa:	4501                	li	a0,0
}
    800014ac:	8082                	ret

00000000800014ae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014ae:	1141                	addi	sp,sp,-16
    800014b0:	e406                	sd	ra,8(sp)
    800014b2:	e022                	sd	s0,0(sp)
    800014b4:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800014b6:	4601                	li	a2,0
    800014b8:	ac9ff0ef          	jal	80000f80 <walk>
  if (pte == 0)
    800014bc:	c901                	beqz	a0,800014cc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014be:	611c                	ld	a5,0(a0)
    800014c0:	9bbd                	andi	a5,a5,-17
    800014c2:	e11c                	sd	a5,0(a0)
}
    800014c4:	60a2                	ld	ra,8(sp)
    800014c6:	6402                	ld	s0,0(sp)
    800014c8:	0141                	addi	sp,sp,16
    800014ca:	8082                	ret
    panic("uvmclear");
    800014cc:	00006517          	auipc	a0,0x6
    800014d0:	c7c50513          	addi	a0,a0,-900 # 80007148 <etext+0x148>
    800014d4:	b74ff0ef          	jal	80000848 <panic>

00000000800014d8 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014d8:	1141                	addi	sp,sp,-16
    800014da:	e406                	sd	ra,8(sp)
    800014dc:	e022                	sd	s0,0(sp)
    800014de:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014e0:	4601                	li	a2,0
    800014e2:	a9fff0ef          	jal	80000f80 <walk>
  if (pte == 0) {
    800014e6:	c119                	beqz	a0,800014ec <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014e8:	6108                	ld	a0,0(a0)
    800014ea:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014ec:	60a2                	ld	ra,8(sp)
    800014ee:	6402                	ld	s0,0(sp)
    800014f0:	0141                	addi	sp,sp,16
    800014f2:	8082                	ret

00000000800014f4 <vmfault>:
{
    800014f4:	7179                	addi	sp,sp,-48
    800014f6:	f406                	sd	ra,40(sp)
    800014f8:	f022                	sd	s0,32(sp)
    800014fa:	e052                	sd	s4,0(sp)
    800014fc:	1800                	addi	s0,sp,48
  if (va >= psz)
    800014fe:	00b66d63          	bltu	a2,a1,80001518 <vmfault+0x24>
    return 0;
    80001502:	4a01                	li	s4,0
}
    80001504:	8552                	mv	a0,s4
    80001506:	70a2                	ld	ra,40(sp)
    80001508:	7402                	ld	s0,32(sp)
    8000150a:	6a02                	ld	s4,0(sp)
    8000150c:	6145                	addi	sp,sp,48
    8000150e:	8082                	ret
    80001510:	64e2                	ld	s1,24(sp)
    80001512:	6942                	ld	s2,16(sp)
    80001514:	69a2                	ld	s3,8(sp)
    80001516:	b7f5                	j	80001502 <vmfault+0xe>
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
  va = PGROUNDDOWN(va);
    8000151c:	77fd                	lui	a5,0xfffff
    8000151e:	00f67933          	and	s2,a2,a5
  if (ismapped(pagetable, va)) {
    80001522:	85ca                	mv	a1,s2
    80001524:	89aa                	mv	s3,a0
    80001526:	fb3ff0ef          	jal	800014d8 <ismapped>
    8000152a:	c501                	beqz	a0,80001532 <vmfault+0x3e>
    8000152c:	6942                	ld	s2,16(sp)
    8000152e:	69a2                	ld	s3,8(sp)
    80001530:	bfc9                	j	80001502 <vmfault+0xe>
    80001532:	ec26                	sd	s1,24(sp)
  mem = (uint64)kalloc();
    80001534:	e2aff0ef          	jal	80000b5e <kalloc>
    80001538:	84aa                	mv	s1,a0
  if (mem == 0)
    8000153a:	d979                	beqz	a0,80001510 <vmfault+0x1c>
  mem = (uint64)kalloc();
    8000153c:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    8000153e:	6605                	lui	a2,0x1
    80001540:	4581                	li	a1,0
    80001542:	fb2ff0ef          	jal	80000cf4 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001546:	4759                	li	a4,22
    80001548:	86a6                	mv	a3,s1
    8000154a:	6605                	lui	a2,0x1
    8000154c:	85ca                	mv	a1,s2
    8000154e:	854e                	mv	a0,s3
    80001550:	b01ff0ef          	jal	80001050 <mappages>
    80001554:	e509                	bnez	a0,8000155e <vmfault+0x6a>
    80001556:	64e2                	ld	s1,24(sp)
    80001558:	6942                	ld	s2,16(sp)
    8000155a:	69a2                	ld	s3,8(sp)
    8000155c:	b765                	j	80001504 <vmfault+0x10>
    kfree((void *)mem);
    8000155e:	8526                	mv	a0,s1
    80001560:	d16ff0ef          	jal	80000a76 <kfree>
    return 0;
    80001564:	64e2                	ld	s1,24(sp)
    80001566:	6942                	ld	s2,16(sp)
    80001568:	69a2                	ld	s3,8(sp)
    8000156a:	bf61                	j	80001502 <vmfault+0xe>

000000008000156c <copyout>:
  while (len > 0) {
    8000156c:	cf55                	beqz	a4,80001628 <copyout+0xbc>
{
    8000156e:	7159                	addi	sp,sp,-112
    80001570:	f486                	sd	ra,104(sp)
    80001572:	f0a2                	sd	s0,96(sp)
    80001574:	eca6                	sd	s1,88(sp)
    80001576:	e8ca                	sd	s2,80(sp)
    80001578:	e4ce                	sd	s3,72(sp)
    8000157a:	e0d2                	sd	s4,64(sp)
    8000157c:	fc56                	sd	s5,56(sp)
    8000157e:	f85a                	sd	s6,48(sp)
    80001580:	f45e                	sd	s7,40(sp)
    80001582:	f062                	sd	s8,32(sp)
    80001584:	ec66                	sd	s9,24(sp)
    80001586:	e86a                	sd	s10,16(sp)
    80001588:	e46e                	sd	s11,8(sp)
    8000158a:	1880                	addi	s0,sp,112
    8000158c:	8baa                	mv	s7,a0
    8000158e:	8dae                	mv	s11,a1
    80001590:	84b2                	mv	s1,a2
    80001592:	8b36                	mv	s6,a3
    80001594:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80001596:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001598:	5cfd                	li	s9,-1
    8000159a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000159e:	6c05                	lui	s8,0x1
    800015a0:	a089                	j	800015e2 <copyout+0x76>
      return -1;
    800015a2:	557d                	li	a0,-1
}
    800015a4:	70a6                	ld	ra,104(sp)
    800015a6:	7406                	ld	s0,96(sp)
    800015a8:	64e6                	ld	s1,88(sp)
    800015aa:	6946                	ld	s2,80(sp)
    800015ac:	69a6                	ld	s3,72(sp)
    800015ae:	6a06                	ld	s4,64(sp)
    800015b0:	7ae2                	ld	s5,56(sp)
    800015b2:	7b42                	ld	s6,48(sp)
    800015b4:	7ba2                	ld	s7,40(sp)
    800015b6:	7c02                	ld	s8,32(sp)
    800015b8:	6ce2                	ld	s9,24(sp)
    800015ba:	6d42                	ld	s10,16(sp)
    800015bc:	6da2                	ld	s11,8(sp)
    800015be:	6165                	addi	sp,sp,112
    800015c0:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c2:	03449513          	slli	a0,s1,0x34
    800015c6:	9151                	srli	a0,a0,0x34
    800015c8:	0009061b          	sext.w	a2,s2
    800015cc:	85da                	mv	a1,s6
    800015ce:	954e                	add	a0,a0,s3
    800015d0:	f80ff0ef          	jal	80000d50 <memmove>
    len -= n;
    800015d4:	412a8ab3          	sub	s5,s5,s2
    src += n;
    800015d8:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    800015da:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    800015de:	040a8363          	beqz	s5,80001624 <copyout+0xb8>
    va0 = PGROUNDDOWN(dstva);
    800015e2:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    800015e6:	fb4ceee3          	bltu	s9,s4,800015a2 <copyout+0x36>
    pa0 = walkaddr(pagetable, va0);
    800015ea:	85d2                	mv	a1,s4
    800015ec:	855e                	mv	a0,s7
    800015ee:	a2bff0ef          	jal	80001018 <walkaddr>
    800015f2:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015f4:	e909                	bnez	a0,80001606 <copyout+0x9a>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015f6:	4681                	li	a3,0
    800015f8:	8652                	mv	a2,s4
    800015fa:	85ee                	mv	a1,s11
    800015fc:	855e                	mv	a0,s7
    800015fe:	ef7ff0ef          	jal	800014f4 <vmfault>
    80001602:	89aa                	mv	s3,a0
    80001604:	dd59                	beqz	a0,800015a2 <copyout+0x36>
    pte = walk(pagetable, va0, 0);
    80001606:	4601                	li	a2,0
    80001608:	85d2                	mv	a1,s4
    8000160a:	855e                	mv	a0,s7
    8000160c:	975ff0ef          	jal	80000f80 <walk>
    if ((*pte & PTE_W) == 0)
    80001610:	611c                	ld	a5,0(a0)
    80001612:	8b91                	andi	a5,a5,4
    80001614:	d7d9                	beqz	a5,800015a2 <copyout+0x36>
    n = PGSIZE - (dstva - va0);
    80001616:	409a0933          	sub	s2,s4,s1
    8000161a:	9962                	add	s2,s2,s8
    if (n > len)
    8000161c:	fb2af3e3          	bgeu	s5,s2,800015c2 <copyout+0x56>
    80001620:	8956                	mv	s2,s5
    80001622:	b745                	j	800015c2 <copyout+0x56>
  return 0;
    80001624:	4501                	li	a0,0
    80001626:	bfbd                	j	800015a4 <copyout+0x38>
    80001628:	4501                	li	a0,0
}
    8000162a:	8082                	ret

000000008000162c <copyin>:
  while (len > 0) {
    8000162c:	cf49                	beqz	a4,800016c6 <copyin+0x9a>
{
    8000162e:	711d                	addi	sp,sp,-96
    80001630:	ec86                	sd	ra,88(sp)
    80001632:	e8a2                	sd	s0,80(sp)
    80001634:	e4a6                	sd	s1,72(sp)
    80001636:	e0ca                	sd	s2,64(sp)
    80001638:	fc4e                	sd	s3,56(sp)
    8000163a:	f852                	sd	s4,48(sp)
    8000163c:	f456                	sd	s5,40(sp)
    8000163e:	f05a                	sd	s6,32(sp)
    80001640:	ec5e                	sd	s7,24(sp)
    80001642:	e862                	sd	s8,16(sp)
    80001644:	e466                	sd	s9,8(sp)
    80001646:	e06a                	sd	s10,0(sp)
    80001648:	1080                	addi	s0,sp,96
    8000164a:	8baa                	mv	s7,a0
    8000164c:	8cae                	mv	s9,a1
    8000164e:	8ab2                	mv	s5,a2
    80001650:	84b6                	mv	s1,a3
    80001652:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001654:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001656:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001658:	6b05                	lui	s6,0x1
    8000165a:	a03d                	j	80001688 <copyin+0x5c>
    8000165c:	409a0933          	sub	s2,s4,s1
    80001660:	995a                	add	s2,s2,s6
    if (n > len)
    80001662:	0129f363          	bgeu	s3,s2,80001668 <copyin+0x3c>
    80001666:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001668:	03449593          	slli	a1,s1,0x34
    8000166c:	91d1                	srli	a1,a1,0x34
    8000166e:	0009061b          	sext.w	a2,s2
    80001672:	95aa                	add	a1,a1,a0
    80001674:	8556                	mv	a0,s5
    80001676:	edaff0ef          	jal	80000d50 <memmove>
    len -= n;
    8000167a:	412989b3          	sub	s3,s3,s2
    dst += n;
    8000167e:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001680:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    80001684:	02098263          	beqz	s3,800016a8 <copyin+0x7c>
    va0 = PGROUNDDOWN(srcva);
    80001688:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    8000168c:	85d2                	mv	a1,s4
    8000168e:	855e                	mv	a0,s7
    80001690:	989ff0ef          	jal	80001018 <walkaddr>
    if (pa0 == 0) {
    80001694:	f561                	bnez	a0,8000165c <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001696:	86ea                	mv	a3,s10
    80001698:	8652                	mv	a2,s4
    8000169a:	85e6                	mv	a1,s9
    8000169c:	855e                	mv	a0,s7
    8000169e:	e57ff0ef          	jal	800014f4 <vmfault>
    800016a2:	fd4d                	bnez	a0,8000165c <copyin+0x30>
        return -1;
    800016a4:	557d                	li	a0,-1
    800016a6:	a011                	j	800016aa <copyin+0x7e>
  return 0;
    800016a8:	4501                	li	a0,0
}
    800016aa:	60e6                	ld	ra,88(sp)
    800016ac:	6446                	ld	s0,80(sp)
    800016ae:	64a6                	ld	s1,72(sp)
    800016b0:	6906                	ld	s2,64(sp)
    800016b2:	79e2                	ld	s3,56(sp)
    800016b4:	7a42                	ld	s4,48(sp)
    800016b6:	7aa2                	ld	s5,40(sp)
    800016b8:	7b02                	ld	s6,32(sp)
    800016ba:	6be2                	ld	s7,24(sp)
    800016bc:	6c42                	ld	s8,16(sp)
    800016be:	6ca2                	ld	s9,8(sp)
    800016c0:	6d02                	ld	s10,0(sp)
    800016c2:	6125                	addi	sp,sp,96
    800016c4:	8082                	ret
  return 0;
    800016c6:	4501                	li	a0,0
}
    800016c8:	8082                	ret

00000000800016ca <copyinstr>:
  while (got_null == 0 && max > 0) {
    800016ca:	c771                	beqz	a4,80001796 <copyinstr+0xcc>
{
    800016cc:	711d                	addi	sp,sp,-96
    800016ce:	ec86                	sd	ra,88(sp)
    800016d0:	e8a2                	sd	s0,80(sp)
    800016d2:	e4a6                	sd	s1,72(sp)
    800016d4:	e0ca                	sd	s2,64(sp)
    800016d6:	fc4e                	sd	s3,56(sp)
    800016d8:	f852                	sd	s4,48(sp)
    800016da:	f456                	sd	s5,40(sp)
    800016dc:	f05a                	sd	s6,32(sp)
    800016de:	ec5e                	sd	s7,24(sp)
    800016e0:	e862                	sd	s8,16(sp)
    800016e2:	e466                	sd	s9,8(sp)
    800016e4:	1080                	addi	s0,sp,96
    800016e6:	8b2a                	mv	s6,a0
    800016e8:	8c2e                	mv	s8,a1
    800016ea:	8932                	mv	s2,a2
    800016ec:	84b6                	mv	s1,a3
    800016ee:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016f0:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016f2:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016f4:	6a85                	lui	s5,0x1
    800016f6:	a881                	j	80001746 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016f8:	86e6                	mv	a3,s9
    800016fa:	864e                	mv	a2,s3
    800016fc:	85e2                	mv	a1,s8
    800016fe:	855a                	mv	a0,s6
    80001700:	df5ff0ef          	jal	800014f4 <vmfault>
    80001704:	e921                	bnez	a0,80001754 <copyinstr+0x8a>
        return -1;
    80001706:	557d                	li	a0,-1
    80001708:	a801                	j	80001718 <copyinstr+0x4e>
        *dst = '\0';
    8000170a:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffde468>
        got_null = 1;
    8000170e:	4785                	li	a5,1
  if (got_null) {
    80001710:	0017c793          	xori	a5,a5,1
    80001714:	40f0053b          	negw	a0,a5
}
    80001718:	60e6                	ld	ra,88(sp)
    8000171a:	6446                	ld	s0,80(sp)
    8000171c:	64a6                	ld	s1,72(sp)
    8000171e:	6906                	ld	s2,64(sp)
    80001720:	79e2                	ld	s3,56(sp)
    80001722:	7a42                	ld	s4,48(sp)
    80001724:	7aa2                	ld	s5,40(sp)
    80001726:	7b02                	ld	s6,32(sp)
    80001728:	6be2                	ld	s7,24(sp)
    8000172a:	6c42                	ld	s8,16(sp)
    8000172c:	6ca2                	ld	s9,8(sp)
    8000172e:	6125                	addi	sp,sp,96
    80001730:	8082                	ret
    80001732:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80001736:	974a                	add	a4,a4,s2
      --max;
    80001738:	40a70a33          	sub	s4,a4,a0
    srcva = va0 + PGSIZE;
    8000173c:	015984b3          	add	s1,s3,s5
  while (got_null == 0 && max > 0) {
    80001740:	04e50563          	beq	a0,a4,8000178a <copyinstr+0xc0>
{
    80001744:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    80001746:	0174f9b3          	and	s3,s1,s7
    pa0 = walkaddr(pagetable, va0);
    8000174a:	85ce                	mv	a1,s3
    8000174c:	855a                	mv	a0,s6
    8000174e:	8cbff0ef          	jal	80001018 <walkaddr>
    if (pa0 == 0) {
    80001752:	d15d                	beqz	a0,800016f8 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80001754:	40998633          	sub	a2,s3,s1
    80001758:	9656                	add	a2,a2,s5
    if (n > max)
    8000175a:	00ca7363          	bgeu	s4,a2,80001760 <copyinstr+0x96>
    8000175e:	8652                	mv	a2,s4
    while (n > 0) {
    80001760:	c61d                	beqz	a2,8000178e <copyinstr+0xc4>
    char *p = (char *)(pa0 + (srcva - va0));
    80001762:	03449593          	slli	a1,s1,0x34
    80001766:	91d1                	srli	a1,a1,0x34
    80001768:	95aa                	add	a1,a1,a0
    8000176a:	87ca                	mv	a5,s2
      if (*p == '\0') {
    8000176c:	412585b3          	sub	a1,a1,s2
    while (n > 0) {
    80001770:	964a                	add	a2,a2,s2
    80001772:	853e                	mv	a0,a5
      if (*p == '\0') {
    80001774:	00f58733          	add	a4,a1,a5
    80001778:	00074683          	lbu	a3,0(a4)
    8000177c:	d6d9                	beqz	a3,8000170a <copyinstr+0x40>
        *dst = *p;
    8000177e:	00d78023          	sb	a3,0(a5)
      dst++;
    80001782:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001784:	fec797e3          	bne	a5,a2,80001772 <copyinstr+0xa8>
    80001788:	b76d                	j	80001732 <copyinstr+0x68>
    srcva = va0 + PGSIZE;
    8000178a:	4781                	li	a5,0
    8000178c:	b751                	j	80001710 <copyinstr+0x46>
    8000178e:	6485                	lui	s1,0x1
    80001790:	94ce                	add	s1,s1,s3
    80001792:	87ca                	mv	a5,s2
    80001794:	bf45                	j	80001744 <copyinstr+0x7a>
    80001796:	4781                	li	a5,0
  if (got_null) {
    80001798:	0017c793          	xori	a5,a5,1
    8000179c:	40f0053b          	negw	a0,a5
}
    800017a0:	8082                	ret

00000000800017a2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a2:	715d                	addi	sp,sp,-80
    800017a4:	e486                	sd	ra,72(sp)
    800017a6:	e0a2                	sd	s0,64(sp)
    800017a8:	fc26                	sd	s1,56(sp)
    800017aa:	f84a                	sd	s2,48(sp)
    800017ac:	f44e                	sd	s3,40(sp)
    800017ae:	f052                	sd	s4,32(sp)
    800017b0:	ec56                	sd	s5,24(sp)
    800017b2:	e85a                	sd	s6,16(sp)
    800017b4:	e45e                	sd	s7,8(sp)
    800017b6:	0880                	addi	s0,sp,80
    800017b8:	8aaa                	mv	s5,a0
    800017ba:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    800017bc:	000a57b7          	lui	a5,0xa5
    800017c0:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    800017c4:	07b2                	slli	a5,a5,0xc
    800017c6:	fa578793          	addi	a5,a5,-91
    800017ca:	4fa50937          	lui	s2,0x4fa50
    800017ce:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800017d2:	1902                	slli	s2,s2,0x20
    800017d4:	993e                	add	s2,s2,a5
    800017d6:	040009b7          	lui	s3,0x4000
    800017da:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017dc:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017de:	4b99                	li	s7,6
    800017e0:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017e2:	6a19                	lui	s4,0x6
    800017e4:	a00a0a13          	addi	s4,s4,-1536 # 5a00 <_entry-0x7fffa600>
    char *pa = kalloc();
    800017e8:	b76ff0ef          	jal	80000b5e <kalloc>
    800017ec:	862a                	mv	a2,a0
    if (pa == 0)
    800017ee:	cd15                	beqz	a0,8000182a <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017f0:	4034d593          	srai	a1,s1,0x3
    800017f4:	032585b3          	mul	a1,a1,s2
    800017f8:	05b6                	slli	a1,a1,0xd
    800017fa:	6789                	lui	a5,0x2
    800017fc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017fe:	875e                	mv	a4,s7
    80001800:	86da                	mv	a3,s6
    80001802:	40b985b3          	sub	a1,s3,a1
    80001806:	8556                	mv	a0,s5
    80001808:	8fbff0ef          	jal	80001102 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000180c:	16848493          	addi	s1,s1,360 # 1168 <_entry-0x7fffee98>
    80001810:	fd449ce3          	bne	s1,s4,800017e8 <proc_mapstacks+0x46>
  }
}
    80001814:	60a6                	ld	ra,72(sp)
    80001816:	6406                	ld	s0,64(sp)
    80001818:	74e2                	ld	s1,56(sp)
    8000181a:	7942                	ld	s2,48(sp)
    8000181c:	79a2                	ld	s3,40(sp)
    8000181e:	7a02                	ld	s4,32(sp)
    80001820:	6ae2                	ld	s5,24(sp)
    80001822:	6b42                	ld	s6,16(sp)
    80001824:	6ba2                	ld	s7,8(sp)
    80001826:	6161                	addi	sp,sp,80
    80001828:	8082                	ret
      panic("kalloc");
    8000182a:	00006517          	auipc	a0,0x6
    8000182e:	92e50513          	addi	a0,a0,-1746 # 80007158 <etext+0x158>
    80001832:	816ff0ef          	jal	80000848 <panic>

0000000080001836 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000184a:	00006597          	auipc	a1,0x6
    8000184e:	91658593          	addi	a1,a1,-1770 # 80007160 <etext+0x160>
    80001852:	0000e517          	auipc	a0,0xe
    80001856:	13650513          	addi	a0,a0,310 # 8000f988 <pid_lock>
    8000185a:	b5eff0ef          	jal	80000bb8 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000185e:	00006597          	auipc	a1,0x6
    80001862:	90a58593          	addi	a1,a1,-1782 # 80007168 <etext+0x168>
    80001866:	0000e517          	auipc	a0,0xe
    8000186a:	13a50513          	addi	a0,a0,314 # 8000f9a0 <wait_lock>
    8000186e:	b4aff0ef          	jal	80000bb8 <initlock>
    80001872:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001874:	0000e497          	auipc	s1,0xe
    80001878:	54448493          	addi	s1,s1,1348 # 8000fdb8 <proc>
    initlock(&p->lock, "proc");
    8000187c:	00006a97          	auipc	s5,0x6
    80001880:	8fca8a93          	addi	s5,s5,-1796 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001884:	000a57b7          	lui	a5,0xa5
    80001888:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    8000188c:	07b2                	slli	a5,a5,0xc
    8000188e:	fa578793          	addi	a5,a5,-91
    80001892:	4fa509b7          	lui	s3,0x4fa50
    80001896:	a4f98993          	addi	s3,s3,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    8000189a:	1982                	slli	s3,s3,0x20
    8000189c:	99be                	add	s3,s3,a5
    8000189e:	04000a37          	lui	s4,0x4000
    800018a2:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    800018a4:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800018a6:	00014b17          	auipc	s6,0x14
    800018aa:	f12b0b13          	addi	s6,s6,-238 # 800157b8 <tickslock>
    initlock(&p->lock, "proc");
    800018ae:	85d6                	mv	a1,s5
    800018b0:	8526                	mv	a0,s1
    800018b2:	b06ff0ef          	jal	80000bb8 <initlock>
    p->state = UNUSED;
    800018b6:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800018ba:	40395793          	srai	a5,s2,0x3
    800018be:	033787b3          	mul	a5,a5,s3
    800018c2:	07b6                	slli	a5,a5,0xd
    800018c4:	6709                	lui	a4,0x2
    800018c6:	9fb9                	addw	a5,a5,a4
    800018c8:	40fa07b3          	sub	a5,s4,a5
    800018cc:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018ce:	16848493          	addi	s1,s1,360
    800018d2:	16890913          	addi	s2,s2,360
    800018d6:	fd649ce3          	bne	s1,s6,800018ae <procinit+0x78>
  }
}
    800018da:	70e2                	ld	ra,56(sp)
    800018dc:	7442                	ld	s0,48(sp)
    800018de:	74a2                	ld	s1,40(sp)
    800018e0:	7902                	ld	s2,32(sp)
    800018e2:	69e2                	ld	s3,24(sp)
    800018e4:	6a42                	ld	s4,16(sp)
    800018e6:	6aa2                	ld	s5,8(sp)
    800018e8:	6b02                	ld	s6,0(sp)
    800018ea:	6121                	addi	sp,sp,64
    800018ec:	8082                	ret

00000000800018ee <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018ee:	1141                	addi	sp,sp,-16
    800018f0:	e406                	sd	ra,8(sp)
    800018f2:	e022                	sd	s0,0(sp)
    800018f4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018f6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018f8:	2501                	sext.w	a0,a0
    800018fa:	60a2                	ld	ra,8(sp)
    800018fc:	6402                	ld	s0,0(sp)
    800018fe:	0141                	addi	sp,sp,16
    80001900:	8082                	ret

0000000080001902 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001902:	1141                	addi	sp,sp,-16
    80001904:	e406                	sd	ra,8(sp)
    80001906:	e022                	sd	s0,0(sp)
    80001908:	0800                	addi	s0,sp,16
    8000190a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000190c:	2781                	sext.w	a5,a5
    8000190e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001910:	0000e517          	auipc	a0,0xe
    80001914:	0a850513          	addi	a0,a0,168 # 8000f9b8 <cpus>
    80001918:	953e                	add	a0,a0,a5
    8000191a:	60a2                	ld	ra,8(sp)
    8000191c:	6402                	ld	s0,0(sp)
    8000191e:	0141                	addi	sp,sp,16
    80001920:	8082                	ret

0000000080001922 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001922:	1101                	addi	sp,sp,-32
    80001924:	ec06                	sd	ra,24(sp)
    80001926:	e822                	sd	s0,16(sp)
    80001928:	e426                	sd	s1,8(sp)
    8000192a:	1000                	addi	s0,sp,32
  push_off();
    8000192c:	ad2ff0ef          	jal	80000bfe <push_off>
    80001930:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001932:	2781                	sext.w	a5,a5
    80001934:	079e                	slli	a5,a5,0x7
    80001936:	0000e717          	auipc	a4,0xe
    8000193a:	05270713          	addi	a4,a4,82 # 8000f988 <pid_lock>
    8000193e:	97ba                	add	a5,a5,a4
    80001940:	7b9c                	ld	a5,48(a5)
    80001942:	84be                	mv	s1,a5
  pop_off();
    80001944:	b30ff0ef          	jal	80000c74 <pop_off>
  return p;
}
    80001948:	8526                	mv	a0,s1
    8000194a:	60e2                	ld	ra,24(sp)
    8000194c:	6442                	ld	s0,16(sp)
    8000194e:	64a2                	ld	s1,8(sp)
    80001950:	6105                	addi	sp,sp,32
    80001952:	8082                	ret

0000000080001954 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001954:	7179                	addi	sp,sp,-48
    80001956:	f406                	sd	ra,40(sp)
    80001958:	f022                	sd	s0,32(sp)
    8000195a:	ec26                	sd	s1,24(sp)
    8000195c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000195e:	fc5ff0ef          	jal	80001922 <myproc>
    80001962:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001964:	b58ff0ef          	jal	80000cbc <release>

  if (first) {
    80001968:	00006797          	auipc	a5,0x6
    8000196c:	ee87a783          	lw	a5,-280(a5) # 80007850 <first.1>
    80001970:	cf85                	beqz	a5,800019a8 <forkret+0x54>
    first = 0;
    80001972:	00006797          	auipc	a5,0x6
    80001976:	ec07af23          	sw	zero,-290(a5) # 80007850 <first.1>

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000197a:	4505                	li	a0,1
    8000197c:	3ff010ef          	jal	8000357a <fsinit>

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001980:	00006797          	auipc	a5,0x6
    80001984:	80078793          	addi	a5,a5,-2048 # 80007180 <etext+0x180>
    80001988:	fcf43823          	sd	a5,-48(s0)
    8000198c:	fc043c23          	sd	zero,-40(s0)
    80001990:	fd040593          	addi	a1,s0,-48
    80001994:	853e                	mv	a0,a5
    80001996:	687020ef          	jal	8000481c <kexec>
    8000199a:	6cbc                	ld	a5,88(s1)
    8000199c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000199e:	6cbc                	ld	a5,88(s1)
    800019a0:	7bb8                	ld	a4,112(a5)
    800019a2:	57fd                	li	a5,-1
    800019a4:	02f70d63          	beq	a4,a5,800019de <forkret+0x8a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019a8:	2e1000ef          	jal	80002488 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019ac:	68a8                	ld	a0,80(s1)
    800019ae:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019b0:	04000737          	lui	a4,0x4000
    800019b4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019b6:	0732                	slli	a4,a4,0xc
    800019b8:	00004797          	auipc	a5,0x4
    800019bc:	6e478793          	addi	a5,a5,1764 # 8000609c <userret>
    800019c0:	00004697          	auipc	a3,0x4
    800019c4:	64068693          	addi	a3,a3,1600 # 80006000 <_trampoline>
    800019c8:	8f95                	sub	a5,a5,a3
    800019ca:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019cc:	577d                	li	a4,-1
    800019ce:	177e                	slli	a4,a4,0x3f
    800019d0:	8d59                	or	a0,a0,a4
    800019d2:	9782                	jalr	a5
}
    800019d4:	70a2                	ld	ra,40(sp)
    800019d6:	7402                	ld	s0,32(sp)
    800019d8:	64e2                	ld	s1,24(sp)
    800019da:	6145                	addi	sp,sp,48
    800019dc:	8082                	ret
      panic("exec");
    800019de:	00005517          	auipc	a0,0x5
    800019e2:	7aa50513          	addi	a0,a0,1962 # 80007188 <etext+0x188>
    800019e6:	e63fe0ef          	jal	80000848 <panic>

00000000800019ea <allocpid>:
{
    800019ea:	1101                	addi	sp,sp,-32
    800019ec:	ec06                	sd	ra,24(sp)
    800019ee:	e822                	sd	s0,16(sp)
    800019f0:	e426                	sd	s1,8(sp)
    800019f2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019f4:	0000e517          	auipc	a0,0xe
    800019f8:	f9450513          	addi	a0,a0,-108 # 8000f988 <pid_lock>
    800019fc:	a3cff0ef          	jal	80000c38 <acquire>
  pid = nextpid;
    80001a00:	00006797          	auipc	a5,0x6
    80001a04:	e5478793          	addi	a5,a5,-428 # 80007854 <nextpid>
    80001a08:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a0a:	0014871b          	addiw	a4,s1,1
    80001a0e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a10:	0000e517          	auipc	a0,0xe
    80001a14:	f7850513          	addi	a0,a0,-136 # 8000f988 <pid_lock>
    80001a18:	aa4ff0ef          	jal	80000cbc <release>
}
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	60e2                	ld	ra,24(sp)
    80001a20:	6442                	ld	s0,16(sp)
    80001a22:	64a2                	ld	s1,8(sp)
    80001a24:	6105                	addi	sp,sp,32
    80001a26:	8082                	ret

0000000080001a28 <proc_pagetable>:
{
    80001a28:	1101                	addi	sp,sp,-32
    80001a2a:	ec06                	sd	ra,24(sp)
    80001a2c:	e822                	sd	s0,16(sp)
    80001a2e:	e426                	sd	s1,8(sp)
    80001a30:	e04a                	sd	s2,0(sp)
    80001a32:	1000                	addi	s0,sp,32
    80001a34:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a36:	fbaff0ef          	jal	800011f0 <uvmcreate>
    80001a3a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a3c:	cd05                	beqz	a0,80001a74 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a3e:	4729                	li	a4,10
    80001a40:	00004697          	auipc	a3,0x4
    80001a44:	5c068693          	addi	a3,a3,1472 # 80006000 <_trampoline>
    80001a48:	6605                	lui	a2,0x1
    80001a4a:	040005b7          	lui	a1,0x4000
    80001a4e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a50:	05b2                	slli	a1,a1,0xc
    80001a52:	dfeff0ef          	jal	80001050 <mappages>
    80001a56:	02054663          	bltz	a0,80001a82 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a5a:	4719                	li	a4,6
    80001a5c:	05893683          	ld	a3,88(s2)
    80001a60:	6605                	lui	a2,0x1
    80001a62:	020005b7          	lui	a1,0x2000
    80001a66:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a68:	05b6                	slli	a1,a1,0xd
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	de4ff0ef          	jal	80001050 <mappages>
    80001a70:	00054f63          	bltz	a0,80001a8e <proc_pagetable+0x66>
}
    80001a74:	8526                	mv	a0,s1
    80001a76:	60e2                	ld	ra,24(sp)
    80001a78:	6442                	ld	s0,16(sp)
    80001a7a:	64a2                	ld	s1,8(sp)
    80001a7c:	6902                	ld	s2,0(sp)
    80001a7e:	6105                	addi	sp,sp,32
    80001a80:	8082                	ret
    uvmfree(pagetable, 0);
    80001a82:	4581                	li	a1,0
    80001a84:	8526                	mv	a0,s1
    80001a86:	95dff0ef          	jal	800013e2 <uvmfree>
    return 0;
    80001a8a:	4481                	li	s1,0
    80001a8c:	b7e5                	j	80001a74 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a8e:	4681                	li	a3,0
    80001a90:	4605                	li	a2,1
    80001a92:	040005b7          	lui	a1,0x4000
    80001a96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a98:	05b2                	slli	a1,a1,0xc
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	f7aff0ef          	jal	80001216 <uvmunmap>
    uvmfree(pagetable, 0);
    80001aa0:	4581                	li	a1,0
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	93fff0ef          	jal	800013e2 <uvmfree>
    return 0;
    80001aa8:	b7cd                	j	80001a8a <proc_pagetable+0x62>

0000000080001aaa <proc_freepagetable>:
{
    80001aaa:	1101                	addi	sp,sp,-32
    80001aac:	ec06                	sd	ra,24(sp)
    80001aae:	e822                	sd	s0,16(sp)
    80001ab0:	e426                	sd	s1,8(sp)
    80001ab2:	e04a                	sd	s2,0(sp)
    80001ab4:	1000                	addi	s0,sp,32
    80001ab6:	84aa                	mv	s1,a0
    80001ab8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aba:	4681                	li	a3,0
    80001abc:	4605                	li	a2,1
    80001abe:	040005b7          	lui	a1,0x4000
    80001ac2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ac4:	05b2                	slli	a1,a1,0xc
    80001ac6:	f50ff0ef          	jal	80001216 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001aca:	4681                	li	a3,0
    80001acc:	4605                	li	a2,1
    80001ace:	020005b7          	lui	a1,0x2000
    80001ad2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ad4:	05b6                	slli	a1,a1,0xd
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	f3eff0ef          	jal	80001216 <uvmunmap>
  uvmfree(pagetable, sz);
    80001adc:	85ca                	mv	a1,s2
    80001ade:	8526                	mv	a0,s1
    80001ae0:	903ff0ef          	jal	800013e2 <uvmfree>
}
    80001ae4:	60e2                	ld	ra,24(sp)
    80001ae6:	6442                	ld	s0,16(sp)
    80001ae8:	64a2                	ld	s1,8(sp)
    80001aea:	6902                	ld	s2,0(sp)
    80001aec:	6105                	addi	sp,sp,32
    80001aee:	8082                	ret

0000000080001af0 <freeproc>:
{
    80001af0:	1101                	addi	sp,sp,-32
    80001af2:	ec06                	sd	ra,24(sp)
    80001af4:	e822                	sd	s0,16(sp)
    80001af6:	e426                	sd	s1,8(sp)
    80001af8:	1000                	addi	s0,sp,32
    80001afa:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001afc:	6d28                	ld	a0,88(a0)
    80001afe:	c119                	beqz	a0,80001b04 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001b00:	f77fe0ef          	jal	80000a76 <kfree>
  p->trapframe = 0;
    80001b04:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001b08:	68a8                	ld	a0,80(s1)
    80001b0a:	c501                	beqz	a0,80001b12 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b0c:	64ac                	ld	a1,72(s1)
    80001b0e:	f9dff0ef          	jal	80001aaa <proc_freepagetable>
  p->pagetable = 0;
    80001b12:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b16:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b1a:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001b1e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b22:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b26:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b2a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b2e:	0004ac23          	sw	zero,24(s1)
}
    80001b32:	60e2                	ld	ra,24(sp)
    80001b34:	6442                	ld	s0,16(sp)
    80001b36:	64a2                	ld	s1,8(sp)
    80001b38:	6105                	addi	sp,sp,32
    80001b3a:	8082                	ret

0000000080001b3c <allocproc>:
{
    80001b3c:	1101                	addi	sp,sp,-32
    80001b3e:	ec06                	sd	ra,24(sp)
    80001b40:	e822                	sd	s0,16(sp)
    80001b42:	e426                	sd	s1,8(sp)
    80001b44:	e04a                	sd	s2,0(sp)
    80001b46:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b48:	0000e497          	auipc	s1,0xe
    80001b4c:	27048493          	addi	s1,s1,624 # 8000fdb8 <proc>
    80001b50:	00014917          	auipc	s2,0x14
    80001b54:	c6890913          	addi	s2,s2,-920 # 800157b8 <tickslock>
    acquire(&p->lock);
    80001b58:	8526                	mv	a0,s1
    80001b5a:	8deff0ef          	jal	80000c38 <acquire>
    if (p->state == UNUSED) {
    80001b5e:	4c9c                	lw	a5,24(s1)
    80001b60:	cb91                	beqz	a5,80001b74 <allocproc+0x38>
      release(&p->lock);
    80001b62:	8526                	mv	a0,s1
    80001b64:	958ff0ef          	jal	80000cbc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b68:	16848493          	addi	s1,s1,360
    80001b6c:	ff2496e3          	bne	s1,s2,80001b58 <allocproc+0x1c>
  return 0;
    80001b70:	4481                	li	s1,0
    80001b72:	a089                	j	80001bb4 <allocproc+0x78>
  p->pid = allocpid();
    80001b74:	e77ff0ef          	jal	800019ea <allocpid>
    80001b78:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b7a:	4785                	li	a5,1
    80001b7c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b7e:	fe1fe0ef          	jal	80000b5e <kalloc>
    80001b82:	892a                	mv	s2,a0
    80001b84:	eca8                	sd	a0,88(s1)
    80001b86:	cd15                	beqz	a0,80001bc2 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b88:	8526                	mv	a0,s1
    80001b8a:	e9fff0ef          	jal	80001a28 <proc_pagetable>
    80001b8e:	892a                	mv	s2,a0
    80001b90:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b92:	c121                	beqz	a0,80001bd2 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b94:	07000613          	li	a2,112
    80001b98:	4581                	li	a1,0
    80001b9a:	06048513          	addi	a0,s1,96
    80001b9e:	956ff0ef          	jal	80000cf4 <memset>
  p->context.ra = (uint64)forkret;
    80001ba2:	00000797          	auipc	a5,0x0
    80001ba6:	db278793          	addi	a5,a5,-590 # 80001954 <forkret>
    80001baa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bac:	60bc                	ld	a5,64(s1)
    80001bae:	6705                	lui	a4,0x1
    80001bb0:	97ba                	add	a5,a5,a4
    80001bb2:	f4bc                	sd	a5,104(s1)
}
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6902                	ld	s2,0(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret
    freeproc(p);
    80001bc2:	8526                	mv	a0,s1
    80001bc4:	f2dff0ef          	jal	80001af0 <freeproc>
    release(&p->lock);
    80001bc8:	8526                	mv	a0,s1
    80001bca:	8f2ff0ef          	jal	80000cbc <release>
    return 0;
    80001bce:	84ca                	mv	s1,s2
    80001bd0:	b7d5                	j	80001bb4 <allocproc+0x78>
    freeproc(p);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	f1dff0ef          	jal	80001af0 <freeproc>
    release(&p->lock);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	8e2ff0ef          	jal	80000cbc <release>
    return 0;
    80001bde:	84ca                	mv	s1,s2
    80001be0:	bfd1                	j	80001bb4 <allocproc+0x78>

0000000080001be2 <userinit>:
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bec:	f51ff0ef          	jal	80001b3c <allocproc>
    80001bf0:	84aa                	mv	s1,a0
  initproc = p;
    80001bf2:	00006797          	auipc	a5,0x6
    80001bf6:	c8a7b723          	sd	a0,-882(a5) # 80007880 <initproc>
  p->cwd = namei("/");
    80001bfa:	00005517          	auipc	a0,0x5
    80001bfe:	59650513          	addi	a0,a0,1430 # 80007190 <etext+0x190>
    80001c02:	6e1010ef          	jal	80003ae2 <namei>
    80001c06:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c0a:	478d                	li	a5,3
    80001c0c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c0e:	8526                	mv	a0,s1
    80001c10:	8acff0ef          	jal	80000cbc <release>
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret

0000000080001c1e <growproc>:
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	e04a                	sd	s2,0(sp)
    80001c28:	1000                	addi	s0,sp,32
    80001c2a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c2c:	cf7ff0ef          	jal	80001922 <myproc>
    80001c30:	892a                	mv	s2,a0
  sz = p->sz;
    80001c32:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c34:	02905b63          	blez	s1,80001c6a <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001c38:	00b48633          	add	a2,s1,a1
    80001c3c:	020007b7          	lui	a5,0x2000
    80001c40:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c42:	07b6                	slli	a5,a5,0xd
    80001c44:	02c7e163          	bltu	a5,a2,80001c66 <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c48:	4691                	li	a3,4
    80001c4a:	6928                	ld	a0,80(a0)
    80001c4c:	e9aff0ef          	jal	800012e6 <uvmalloc>
    80001c50:	85aa                	mv	a1,a0
    80001c52:	c911                	beqz	a0,80001c66 <growproc+0x48>
  p->sz = sz;
    80001c54:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c58:	4501                	li	a0,0
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6902                	ld	s2,0(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
      return -1;
    80001c66:	557d                	li	a0,-1
    80001c68:	bfcd                	j	80001c5a <growproc+0x3c>
  } else if (n < 0) {
    80001c6a:	fe04d5e3          	bgez	s1,80001c54 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c6e:	00b48633          	add	a2,s1,a1
    80001c72:	6928                	ld	a0,80(a0)
    80001c74:	e2cff0ef          	jal	800012a0 <uvmdealloc>
    80001c78:	85aa                	mv	a1,a0
    80001c7a:	bfe9                	j	80001c54 <growproc+0x36>

0000000080001c7c <kfork>:
{
    80001c7c:	7139                	addi	sp,sp,-64
    80001c7e:	fc06                	sd	ra,56(sp)
    80001c80:	f822                	sd	s0,48(sp)
    80001c82:	f426                	sd	s1,40(sp)
    80001c84:	e456                	sd	s5,8(sp)
    80001c86:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c88:	c9bff0ef          	jal	80001922 <myproc>
    80001c8c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c8e:	eafff0ef          	jal	80001b3c <allocproc>
    80001c92:	c92d                	beqz	a0,80001d04 <kfork+0x88>
    80001c94:	e852                	sd	s4,16(sp)
    80001c96:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c98:	048ab603          	ld	a2,72(s5)
    80001c9c:	692c                	ld	a1,80(a0)
    80001c9e:	050ab503          	ld	a0,80(s5)
    80001ca2:	f72ff0ef          	jal	80001414 <uvmcopy>
    80001ca6:	04054863          	bltz	a0,80001cf6 <kfork+0x7a>
    80001caa:	f04a                	sd	s2,32(sp)
    80001cac:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cae:	048ab783          	ld	a5,72(s5)
    80001cb2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cb6:	058ab683          	ld	a3,88(s5)
    80001cba:	87b6                	mv	a5,a3
    80001cbc:	058a3703          	ld	a4,88(s4)
    80001cc0:	12068693          	addi	a3,a3,288
    80001cc4:	6388                	ld	a0,0(a5)
    80001cc6:	678c                	ld	a1,8(a5)
    80001cc8:	6b90                	ld	a2,16(a5)
    80001cca:	e308                	sd	a0,0(a4)
    80001ccc:	e70c                	sd	a1,8(a4)
    80001cce:	eb10                	sd	a2,16(a4)
    80001cd0:	6f90                	ld	a2,24(a5)
    80001cd2:	ef10                	sd	a2,24(a4)
    80001cd4:	02078793          	addi	a5,a5,32
    80001cd8:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cdc:	fed794e3          	bne	a5,a3,80001cc4 <kfork+0x48>
  np->trapframe->a0 = 0;
    80001ce0:	058a3783          	ld	a5,88(s4)
    80001ce4:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001ce8:	0d0a8493          	addi	s1,s5,208
    80001cec:	0d0a0913          	addi	s2,s4,208
    80001cf0:	150a8993          	addi	s3,s5,336
    80001cf4:	a831                	j	80001d10 <kfork+0x94>
    freeproc(np);
    80001cf6:	8552                	mv	a0,s4
    80001cf8:	df9ff0ef          	jal	80001af0 <freeproc>
    release(&np->lock);
    80001cfc:	8552                	mv	a0,s4
    80001cfe:	fbffe0ef          	jal	80000cbc <release>
    return -1;
    80001d02:	6a42                	ld	s4,16(sp)
    return -1;
    80001d04:	54fd                	li	s1,-1
    80001d06:	a885                	j	80001d76 <kfork+0xfa>
  for (i = 0; i < NOFILE; i++)
    80001d08:	04a1                	addi	s1,s1,8
    80001d0a:	0921                	addi	s2,s2,8
    80001d0c:	01348963          	beq	s1,s3,80001d1e <kfork+0xa2>
    if (p->ofile[i])
    80001d10:	6088                	ld	a0,0(s1)
    80001d12:	d97d                	beqz	a0,80001d08 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d14:	41c020ef          	jal	80004130 <filedup>
    80001d18:	00a93023          	sd	a0,0(s2)
    80001d1c:	b7f5                	j	80001d08 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001d1e:	150ab503          	ld	a0,336(s5)
    80001d22:	4e6010ef          	jal	80003208 <idup>
    80001d26:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d2a:	4641                	li	a2,16
    80001d2c:	158a8593          	addi	a1,s5,344
    80001d30:	158a0513          	addi	a0,s4,344
    80001d34:	90aff0ef          	jal	80000e3e <safestrcpy>
  pid = np->pid;
    80001d38:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d3c:	8552                	mv	a0,s4
    80001d3e:	f7ffe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001d42:	0000e517          	auipc	a0,0xe
    80001d46:	c5e50513          	addi	a0,a0,-930 # 8000f9a0 <wait_lock>
    80001d4a:	eeffe0ef          	jal	80000c38 <acquire>
  np->parent = p;
    80001d4e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d52:	0000e517          	auipc	a0,0xe
    80001d56:	c4e50513          	addi	a0,a0,-946 # 8000f9a0 <wait_lock>
    80001d5a:	f63fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001d5e:	8552                	mv	a0,s4
    80001d60:	ed9fe0ef          	jal	80000c38 <acquire>
  np->state = RUNNABLE;
    80001d64:	478d                	li	a5,3
    80001d66:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d6a:	8552                	mv	a0,s4
    80001d6c:	f51fe0ef          	jal	80000cbc <release>
    80001d70:	7902                	ld	s2,32(sp)
    80001d72:	69e2                	ld	s3,24(sp)
    80001d74:	6a42                	ld	s4,16(sp)
}
    80001d76:	8526                	mv	a0,s1
    80001d78:	70e2                	ld	ra,56(sp)
    80001d7a:	7442                	ld	s0,48(sp)
    80001d7c:	74a2                	ld	s1,40(sp)
    80001d7e:	6aa2                	ld	s5,8(sp)
    80001d80:	6121                	addi	sp,sp,64
    80001d82:	8082                	ret

0000000080001d84 <scheduler>:
{
    80001d84:	711d                	addi	sp,sp,-96
    80001d86:	ec86                	sd	ra,88(sp)
    80001d88:	e8a2                	sd	s0,80(sp)
    80001d8a:	e4a6                	sd	s1,72(sp)
    80001d8c:	e0ca                	sd	s2,64(sp)
    80001d8e:	fc4e                	sd	s3,56(sp)
    80001d90:	f852                	sd	s4,48(sp)
    80001d92:	f456                	sd	s5,40(sp)
    80001d94:	f05a                	sd	s6,32(sp)
    80001d96:	ec5e                	sd	s7,24(sp)
    80001d98:	e862                	sd	s8,16(sp)
    80001d9a:	e466                	sd	s9,8(sp)
    80001d9c:	1080                	addi	s0,sp,96
    80001d9e:	8792                	mv	a5,tp
  int id = r_tp();
    80001da0:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001da2:	00779693          	slli	a3,a5,0x7
    80001da6:	0000e717          	auipc	a4,0xe
    80001daa:	be270713          	addi	a4,a4,-1054 # 8000f988 <pid_lock>
    80001dae:	9736                	add	a4,a4,a3
    80001db0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001db4:	0000ea97          	auipc	s5,0xe
    80001db8:	c0ca8a93          	addi	s5,s5,-1012 # 8000f9c0 <cpus+0x8>
    80001dbc:	9ab6                	add	s5,s5,a3
        p->state = RUNNING;
    80001dbe:	4c11                	li	s8,4
        c->proc = p;
    80001dc0:	0000eb17          	auipc	s6,0xe
    80001dc4:	bc8b0b13          	addi	s6,s6,-1080 # 8000f988 <pid_lock>
    80001dc8:	8a3a                	mv	s4,a4
        found = 1;
    80001dca:	4b85                	li	s7,1
    80001dcc:	a0a9                	j	80001e16 <scheduler+0x92>
      release(&p->lock);
    80001dce:	8526                	mv	a0,s1
    80001dd0:	eedfe0ef          	jal	80000cbc <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dd4:	16848493          	addi	s1,s1,360
    80001dd8:	03248b63          	beq	s1,s2,80001e0e <scheduler+0x8a>
      acquire(&p->lock);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	e5bfe0ef          	jal	80000c38 <acquire>
      if (p->state == RUNNABLE) {
    80001de2:	4c9c                	lw	a5,24(s1)
    80001de4:	ff3795e3          	bne	a5,s3,80001dce <scheduler+0x4a>
        p->state = RUNNING;
    80001de8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dec:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001df0:	06048593          	addi	a1,s1,96
    80001df4:	8556                	mv	a0,s5
    80001df6:	5e8000ef          	jal	800023de <swtch>
    80001dfa:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001dfc:	2781                	sext.w	a5,a5
    80001dfe:	079e                	slli	a5,a5,0x7
    80001e00:	97da                	add	a5,a5,s6
    80001e02:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001e06:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e0a:	8cde                	mv	s9,s7
    80001e0c:	b7c9                	j	80001dce <scheduler+0x4a>
    if (found == 0) {
    80001e0e:	000c9463          	bnez	s9,80001e16 <scheduler+0x92>
      asm volatile("wfi");
    80001e12:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001e16:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001e1a:	10017073          	csrci	sstatus,2
    int found = 0;
    80001e1e:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e20:	0000e497          	auipc	s1,0xe
    80001e24:	f9848493          	addi	s1,s1,-104 # 8000fdb8 <proc>
      if (p->state == RUNNABLE) {
    80001e28:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e2a:	00014917          	auipc	s2,0x14
    80001e2e:	98e90913          	addi	s2,s2,-1650 # 800157b8 <tickslock>
    80001e32:	b76d                	j	80001ddc <scheduler+0x58>

0000000080001e34 <sched>:
{
    80001e34:	7179                	addi	sp,sp,-48
    80001e36:	f406                	sd	ra,40(sp)
    80001e38:	f022                	sd	s0,32(sp)
    80001e3a:	ec26                	sd	s1,24(sp)
    80001e3c:	e84a                	sd	s2,16(sp)
    80001e3e:	e44e                	sd	s3,8(sp)
    80001e40:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e42:	ae1ff0ef          	jal	80001922 <myproc>
    80001e46:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e48:	d8bfe0ef          	jal	80000bd2 <holding>
    80001e4c:	c92d                	beqz	a0,80001ebe <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e4e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e50:	2781                	sext.w	a5,a5
    80001e52:	079e                	slli	a5,a5,0x7
    80001e54:	0000e717          	auipc	a4,0xe
    80001e58:	b3470713          	addi	a4,a4,-1228 # 8000f988 <pid_lock>
    80001e5c:	97ba                	add	a5,a5,a4
    80001e5e:	0a87a703          	lw	a4,168(a5)
    80001e62:	4785                	li	a5,1
    80001e64:	06f71363          	bne	a4,a5,80001eca <sched+0x96>
  if (p->state == RUNNING)
    80001e68:	4c98                	lw	a4,24(s1)
    80001e6a:	4791                	li	a5,4
    80001e6c:	06f70563          	beq	a4,a5,80001ed6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e74:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e76:	e7b5                	bnez	a5,80001ee2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e78:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e7a:	0000e917          	auipc	s2,0xe
    80001e7e:	b0e90913          	addi	s2,s2,-1266 # 8000f988 <pid_lock>
    80001e82:	2781                	sext.w	a5,a5
    80001e84:	079e                	slli	a5,a5,0x7
    80001e86:	97ca                	add	a5,a5,s2
    80001e88:	0ac7a983          	lw	s3,172(a5)
    80001e8c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e8e:	2781                	sext.w	a5,a5
    80001e90:	079e                	slli	a5,a5,0x7
    80001e92:	0000e597          	auipc	a1,0xe
    80001e96:	b2e58593          	addi	a1,a1,-1234 # 8000f9c0 <cpus+0x8>
    80001e9a:	95be                	add	a1,a1,a5
    80001e9c:	06048513          	addi	a0,s1,96
    80001ea0:	53e000ef          	jal	800023de <swtch>
    80001ea4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ea6:	2781                	sext.w	a5,a5
    80001ea8:	079e                	slli	a5,a5,0x7
    80001eaa:	993e                	add	s2,s2,a5
    80001eac:	0b392623          	sw	s3,172(s2)
}
    80001eb0:	70a2                	ld	ra,40(sp)
    80001eb2:	7402                	ld	s0,32(sp)
    80001eb4:	64e2                	ld	s1,24(sp)
    80001eb6:	6942                	ld	s2,16(sp)
    80001eb8:	69a2                	ld	s3,8(sp)
    80001eba:	6145                	addi	sp,sp,48
    80001ebc:	8082                	ret
    panic("sched p->lock");
    80001ebe:	00005517          	auipc	a0,0x5
    80001ec2:	2da50513          	addi	a0,a0,730 # 80007198 <etext+0x198>
    80001ec6:	983fe0ef          	jal	80000848 <panic>
    panic("sched locks");
    80001eca:	00005517          	auipc	a0,0x5
    80001ece:	2de50513          	addi	a0,a0,734 # 800071a8 <etext+0x1a8>
    80001ed2:	977fe0ef          	jal	80000848 <panic>
    panic("sched RUNNING");
    80001ed6:	00005517          	auipc	a0,0x5
    80001eda:	2e250513          	addi	a0,a0,738 # 800071b8 <etext+0x1b8>
    80001ede:	96bfe0ef          	jal	80000848 <panic>
    panic("sched interruptible");
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	2e650513          	addi	a0,a0,742 # 800071c8 <etext+0x1c8>
    80001eea:	95ffe0ef          	jal	80000848 <panic>

0000000080001eee <yield>:
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ef8:	a2bff0ef          	jal	80001922 <myproc>
    80001efc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001efe:	d3bfe0ef          	jal	80000c38 <acquire>
  p->state = RUNNABLE;
    80001f02:	478d                	li	a5,3
    80001f04:	cc9c                	sw	a5,24(s1)
  sched();
    80001f06:	f2fff0ef          	jal	80001e34 <sched>
  release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	db1fe0ef          	jal	80000cbc <release>
}
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret

0000000080001f1a <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	e426                	sd	s1,8(sp)
    80001f22:	e04a                	sd	s2,0(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f28:	9fbff0ef          	jal	80001922 <myproc>
    80001f2c:	892a                	mv	s2,a0

  acquire(&p->lock);
    80001f2e:	d0bfe0ef          	jal	80000c38 <acquire>
  if (chan == 0)
    80001f32:	cc81                	beqz	s1,80001f4a <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001f34:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001f38:	854a                	mv	a0,s2
    80001f3a:	d83fe0ef          	jal	80000cbc <release>
}
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001f4a:	00005517          	auipc	a0,0x5
    80001f4e:	29650513          	addi	a0,a0,662 # 800071e0 <etext+0x1e0>
    80001f52:	8f7fe0ef          	jal	80000848 <panic>

0000000080001f56 <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80001f56:	1101                	addi	sp,sp,-32
    80001f58:	ec06                	sd	ra,24(sp)
    80001f5a:	e822                	sd	s0,16(sp)
    80001f5c:	e426                	sd	s1,8(sp)
    80001f5e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f60:	9c3ff0ef          	jal	80001922 <myproc>
    80001f64:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80001f66:	cd3fe0ef          	jal	80000c38 <acquire>
  if (p->chan != 0) {
    80001f6a:	709c                	ld	a5,32(s1)
    80001f6c:	c789                	beqz	a5,80001f76 <sleep+0x20>
    p->state = SLEEPING;
    80001f6e:	4789                	li	a5,2
    80001f70:	cc9c                	sw	a5,24(s1)
    sched();
    80001f72:	ec3ff0ef          	jal	80001e34 <sched>
  }
  release(&p->lock);
    80001f76:	8526                	mv	a0,s1
    80001f78:	d45fe0ef          	jal	80000cbc <release>
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    80001f86:	7139                	addi	sp,sp,-64
    80001f88:	fc06                	sd	ra,56(sp)
    80001f8a:	f822                	sd	s0,48(sp)
    80001f8c:	f426                	sd	s1,40(sp)
    80001f8e:	f04a                	sd	s2,32(sp)
    80001f90:	ec4e                	sd	s3,24(sp)
    80001f92:	e852                	sd	s4,16(sp)
    80001f94:	e456                	sd	s5,8(sp)
    80001f96:	0080                	addi	s0,sp,64
    80001f98:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f9a:	0000e497          	auipc	s1,0xe
    80001f9e:	e1e48493          	addi	s1,s1,-482 # 8000fdb8 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    80001fa2:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001fa4:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fa6:	00014997          	auipc	s3,0x14
    80001faa:	81298993          	addi	s3,s3,-2030 # 800157b8 <tickslock>
    80001fae:	a801                	j	80001fbe <wakeup+0x38>
      }
    }
    release(&p->lock);
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	d0bfe0ef          	jal	80000cbc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fb6:	16848493          	addi	s1,s1,360
    80001fba:	03348063          	beq	s1,s3,80001fda <wakeup+0x54>
    acquire(&p->lock);
    80001fbe:	8526                	mv	a0,s1
    80001fc0:	c79fe0ef          	jal	80000c38 <acquire>
    if (p->chan == chan) {
    80001fc4:	709c                	ld	a5,32(s1)
    80001fc6:	ff2795e3          	bne	a5,s2,80001fb0 <wakeup+0x2a>
      p->chan = 0;
    80001fca:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80001fce:	4c9c                	lw	a5,24(s1)
    80001fd0:	ff4790e3          	bne	a5,s4,80001fb0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fd4:	0154ac23          	sw	s5,24(s1)
    80001fd8:	bfe1                	j	80001fb0 <wakeup+0x2a>
  }
}
    80001fda:	70e2                	ld	ra,56(sp)
    80001fdc:	7442                	ld	s0,48(sp)
    80001fde:	74a2                	ld	s1,40(sp)
    80001fe0:	7902                	ld	s2,32(sp)
    80001fe2:	69e2                	ld	s3,24(sp)
    80001fe4:	6a42                	ld	s4,16(sp)
    80001fe6:	6aa2                	ld	s5,8(sp)
    80001fe8:	6121                	addi	sp,sp,64
    80001fea:	8082                	ret

0000000080001fec <reparent>:
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	e052                	sd	s4,0(sp)
    80001ffa:	1800                	addi	s0,sp,48
    80001ffc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ffe:	0000e497          	auipc	s1,0xe
    80002002:	dba48493          	addi	s1,s1,-582 # 8000fdb8 <proc>
      pp->parent = initproc;
    80002006:	00006a17          	auipc	s4,0x6
    8000200a:	87aa0a13          	addi	s4,s4,-1926 # 80007880 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000200e:	00013997          	auipc	s3,0x13
    80002012:	7aa98993          	addi	s3,s3,1962 # 800157b8 <tickslock>
    80002016:	a029                	j	80002020 <reparent+0x34>
    80002018:	16848493          	addi	s1,s1,360
    8000201c:	01348b63          	beq	s1,s3,80002032 <reparent+0x46>
    if (pp->parent == p) {
    80002020:	7c9c                	ld	a5,56(s1)
    80002022:	ff279be3          	bne	a5,s2,80002018 <reparent+0x2c>
      pp->parent = initproc;
    80002026:	000a3503          	ld	a0,0(s4)
    8000202a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000202c:	f5bff0ef          	jal	80001f86 <wakeup>
    80002030:	b7e5                	j	80002018 <reparent+0x2c>
}
    80002032:	70a2                	ld	ra,40(sp)
    80002034:	7402                	ld	s0,32(sp)
    80002036:	64e2                	ld	s1,24(sp)
    80002038:	6942                	ld	s2,16(sp)
    8000203a:	69a2                	ld	s3,8(sp)
    8000203c:	6a02                	ld	s4,0(sp)
    8000203e:	6145                	addi	sp,sp,48
    80002040:	8082                	ret

0000000080002042 <kexit>:
{
    80002042:	7179                	addi	sp,sp,-48
    80002044:	f406                	sd	ra,40(sp)
    80002046:	f022                	sd	s0,32(sp)
    80002048:	ec26                	sd	s1,24(sp)
    8000204a:	e84a                	sd	s2,16(sp)
    8000204c:	e44e                	sd	s3,8(sp)
    8000204e:	e052                	sd	s4,0(sp)
    80002050:	1800                	addi	s0,sp,48
    80002052:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002054:	8cfff0ef          	jal	80001922 <myproc>
    80002058:	89aa                	mv	s3,a0
  if (p == initproc)
    8000205a:	00006797          	auipc	a5,0x6
    8000205e:	8267b783          	ld	a5,-2010(a5) # 80007880 <initproc>
    80002062:	0d050493          	addi	s1,a0,208
    80002066:	15050913          	addi	s2,a0,336
    8000206a:	00a79b63          	bne	a5,a0,80002080 <kexit+0x3e>
    panic("init exiting");
    8000206e:	00005517          	auipc	a0,0x5
    80002072:	19250513          	addi	a0,a0,402 # 80007200 <etext+0x200>
    80002076:	fd2fe0ef          	jal	80000848 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    8000207a:	04a1                	addi	s1,s1,8
    8000207c:	01248963          	beq	s1,s2,8000208e <kexit+0x4c>
    if (p->ofile[fd]) {
    80002080:	6088                	ld	a0,0(s1)
    80002082:	dd65                	beqz	a0,8000207a <kexit+0x38>
      fileclose(f);
    80002084:	0f2020ef          	jal	80004176 <fileclose>
      p->ofile[fd] = 0;
    80002088:	0004b023          	sd	zero,0(s1)
    8000208c:	b7fd                	j	8000207a <kexit+0x38>
  begin_op();
    8000208e:	433010ef          	jal	80003cc0 <begin_op>
  iput(p->cwd);
    80002092:	1509b503          	ld	a0,336(s3)
    80002096:	32a010ef          	jal	800033c0 <iput>
  end_op();
    8000209a:	4b3010ef          	jal	80003d4c <end_op>
  p->cwd = 0;
    8000209e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020a2:	0000e517          	auipc	a0,0xe
    800020a6:	8fe50513          	addi	a0,a0,-1794 # 8000f9a0 <wait_lock>
    800020aa:	b8ffe0ef          	jal	80000c38 <acquire>
  reparent(p);
    800020ae:	854e                	mv	a0,s3
    800020b0:	f3dff0ef          	jal	80001fec <reparent>
  wakeup(p->parent);
    800020b4:	0389b503          	ld	a0,56(s3)
    800020b8:	ecfff0ef          	jal	80001f86 <wakeup>
  acquire(&p->lock);
    800020bc:	854e                	mv	a0,s3
    800020be:	b7bfe0ef          	jal	80000c38 <acquire>
  p->xstate = status;
    800020c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020c6:	4795                	li	a5,5
    800020c8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020cc:	0000e517          	auipc	a0,0xe
    800020d0:	8d450513          	addi	a0,a0,-1836 # 8000f9a0 <wait_lock>
    800020d4:	be9fe0ef          	jal	80000cbc <release>
  sched();
    800020d8:	d5dff0ef          	jal	80001e34 <sched>
  panic("zombie exit");
    800020dc:	00005517          	auipc	a0,0x5
    800020e0:	13450513          	addi	a0,a0,308 # 80007210 <etext+0x210>
    800020e4:	f64fe0ef          	jal	80000848 <panic>

00000000800020e8 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020e8:	7179                	addi	sp,sp,-48
    800020ea:	f406                	sd	ra,40(sp)
    800020ec:	f022                	sd	s0,32(sp)
    800020ee:	ec26                	sd	s1,24(sp)
    800020f0:	e84a                	sd	s2,16(sp)
    800020f2:	e44e                	sd	s3,8(sp)
    800020f4:	1800                	addi	s0,sp,48
    800020f6:	892a                	mv	s2,a0
  struct proc *p;

  if (pid == 0)
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    800020f8:	0000e497          	auipc	s1,0xe
    800020fc:	cc048493          	addi	s1,s1,-832 # 8000fdb8 <proc>
    80002100:	00013997          	auipc	s3,0x13
    80002104:	6b898993          	addi	s3,s3,1720 # 800157b8 <tickslock>
  if (pid == 0)
    80002108:	cd11                	beqz	a0,80002124 <kkill+0x3c>
    acquire(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	b2dfe0ef          	jal	80000c38 <acquire>
    if (p->pid == pid) {
    80002110:	589c                	lw	a5,48(s1)
    80002112:	01278b63          	beq	a5,s2,80002128 <kkill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002116:	8526                	mv	a0,s1
    80002118:	ba5fe0ef          	jal	80000cbc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000211c:	16848493          	addi	s1,s1,360
    80002120:	ff3495e3          	bne	s1,s3,8000210a <kkill+0x22>
    return -1;
    80002124:	557d                	li	a0,-1
    80002126:	a819                	j	8000213c <kkill+0x54>
      p->killed = 1;
    80002128:	4785                	li	a5,1
    8000212a:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    8000212c:	4c98                	lw	a4,24(s1)
    8000212e:	4789                	li	a5,2
    80002130:	00f70d63          	beq	a4,a5,8000214a <kkill+0x62>
      release(&p->lock);
    80002134:	8526                	mv	a0,s1
    80002136:	b87fe0ef          	jal	80000cbc <release>
      return 0;
    8000213a:	4501                	li	a0,0
  }
  return -1;
}
    8000213c:	70a2                	ld	ra,40(sp)
    8000213e:	7402                	ld	s0,32(sp)
    80002140:	64e2                	ld	s1,24(sp)
    80002142:	6942                	ld	s2,16(sp)
    80002144:	69a2                	ld	s3,8(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret
        p->state = RUNNABLE;
    8000214a:	478d                	li	a5,3
    8000214c:	cc9c                	sw	a5,24(s1)
    8000214e:	b7dd                	j	80002134 <kkill+0x4c>

0000000080002150 <setkilled>:

void
setkilled(struct proc *p)
{
    80002150:	1101                	addi	sp,sp,-32
    80002152:	ec06                	sd	ra,24(sp)
    80002154:	e822                	sd	s0,16(sp)
    80002156:	e426                	sd	s1,8(sp)
    80002158:	1000                	addi	s0,sp,32
    8000215a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000215c:	addfe0ef          	jal	80000c38 <acquire>
  p->killed = 1;
    80002160:	4785                	li	a5,1
    80002162:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002164:	8526                	mv	a0,s1
    80002166:	b57fe0ef          	jal	80000cbc <release>
}
    8000216a:	60e2                	ld	ra,24(sp)
    8000216c:	6442                	ld	s0,16(sp)
    8000216e:	64a2                	ld	s1,8(sp)
    80002170:	6105                	addi	sp,sp,32
    80002172:	8082                	ret

0000000080002174 <killed>:

int
killed(struct proc *p)
{
    80002174:	1101                	addi	sp,sp,-32
    80002176:	ec06                	sd	ra,24(sp)
    80002178:	e822                	sd	s0,16(sp)
    8000217a:	e426                	sd	s1,8(sp)
    8000217c:	e04a                	sd	s2,0(sp)
    8000217e:	1000                	addi	s0,sp,32
    80002180:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002182:	ab7fe0ef          	jal	80000c38 <acquire>
  k = p->killed;
    80002186:	549c                	lw	a5,40(s1)
    80002188:	893e                	mv	s2,a5
  release(&p->lock);
    8000218a:	8526                	mv	a0,s1
    8000218c:	b31fe0ef          	jal	80000cbc <release>
  return k;
}
    80002190:	854a                	mv	a0,s2
    80002192:	60e2                	ld	ra,24(sp)
    80002194:	6442                	ld	s0,16(sp)
    80002196:	64a2                	ld	s1,8(sp)
    80002198:	6902                	ld	s2,0(sp)
    8000219a:	6105                	addi	sp,sp,32
    8000219c:	8082                	ret

000000008000219e <kwait>:
{
    8000219e:	715d                	addi	sp,sp,-80
    800021a0:	e486                	sd	ra,72(sp)
    800021a2:	e0a2                	sd	s0,64(sp)
    800021a4:	fc26                	sd	s1,56(sp)
    800021a6:	f84a                	sd	s2,48(sp)
    800021a8:	f44e                	sd	s3,40(sp)
    800021aa:	f052                	sd	s4,32(sp)
    800021ac:	ec56                	sd	s5,24(sp)
    800021ae:	e85a                	sd	s6,16(sp)
    800021b0:	e45e                	sd	s7,8(sp)
    800021b2:	0880                	addi	s0,sp,80
    800021b4:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021b6:	f6cff0ef          	jal	80001922 <myproc>
    800021ba:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021bc:	0000d517          	auipc	a0,0xd
    800021c0:	7e450513          	addi	a0,a0,2020 # 8000f9a0 <wait_lock>
    800021c4:	a75fe0ef          	jal	80000c38 <acquire>
        if (pp->state == ZOMBIE) {
    800021c8:	4a15                	li	s4,5
        havekids = 1;
    800021ca:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021cc:	00013997          	auipc	s3,0x13
    800021d0:	5ec98993          	addi	s3,s3,1516 # 800157b8 <tickslock>
    release(&wait_lock);
    800021d4:	0000db17          	auipc	s6,0xd
    800021d8:	7ccb0b13          	addi	s6,s6,1996 # 8000f9a0 <wait_lock>
    800021dc:	a07d                	j	8000228a <kwait+0xec>
          pid = pp->pid;
    800021de:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800021e2:	000b8e63          	beqz	s7,800021fe <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800021e6:	4711                	li	a4,4
    800021e8:	02c48693          	addi	a3,s1,44
    800021ec:	865e                	mv	a2,s7
    800021ee:	04893583          	ld	a1,72(s2)
    800021f2:	05093503          	ld	a0,80(s2)
    800021f6:	b76ff0ef          	jal	8000156c <copyout>
          if (addr != 0 &&
    800021fa:	02054c63          	bltz	a0,80002232 <kwait+0x94>
          pp->parent = 0;
    800021fe:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    80002202:	8526                	mv	a0,s1
    80002204:	8edff0ef          	jal	80001af0 <freeproc>
          release(&pp->lock);
    80002208:	8526                	mv	a0,s1
    8000220a:	ab3fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    8000220e:	0000d517          	auipc	a0,0xd
    80002212:	79250513          	addi	a0,a0,1938 # 8000f9a0 <wait_lock>
    80002216:	aa7fe0ef          	jal	80000cbc <release>
}
    8000221a:	854e                	mv	a0,s3
    8000221c:	60a6                	ld	ra,72(sp)
    8000221e:	6406                	ld	s0,64(sp)
    80002220:	74e2                	ld	s1,56(sp)
    80002222:	7942                	ld	s2,48(sp)
    80002224:	79a2                	ld	s3,40(sp)
    80002226:	7a02                	ld	s4,32(sp)
    80002228:	6ae2                	ld	s5,24(sp)
    8000222a:	6b42                	ld	s6,16(sp)
    8000222c:	6ba2                	ld	s7,8(sp)
    8000222e:	6161                	addi	sp,sp,80
    80002230:	8082                	ret
            release(&pp->lock);
    80002232:	8526                	mv	a0,s1
    80002234:	a89fe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002238:	0000d517          	auipc	a0,0xd
    8000223c:	76850513          	addi	a0,a0,1896 # 8000f9a0 <wait_lock>
    80002240:	a7dfe0ef          	jal	80000cbc <release>
            return -1;
    80002244:	a8b9                	j	800022a2 <kwait+0x104>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002246:	16848493          	addi	s1,s1,360
    8000224a:	03348063          	beq	s1,s3,8000226a <kwait+0xcc>
      if (pp->parent == p) {
    8000224e:	7c9c                	ld	a5,56(s1)
    80002250:	ff279be3          	bne	a5,s2,80002246 <kwait+0xa8>
        acquire(&pp->lock);
    80002254:	8526                	mv	a0,s1
    80002256:	9e3fe0ef          	jal	80000c38 <acquire>
        if (pp->state == ZOMBIE) {
    8000225a:	4c9c                	lw	a5,24(s1)
    8000225c:	f94781e3          	beq	a5,s4,800021de <kwait+0x40>
        release(&pp->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	a5bfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002266:	8756                	mv	a4,s5
    80002268:	bff9                	j	80002246 <kwait+0xa8>
    if (!havekids || killed(p)) {
    8000226a:	c715                	beqz	a4,80002296 <kwait+0xf8>
    8000226c:	854a                	mv	a0,s2
    8000226e:	f07ff0ef          	jal	80002174 <killed>
    80002272:	e115                	bnez	a0,80002296 <kwait+0xf8>
    sleep_prepare(p); //DOC: wait-sleep
    80002274:	854a                	mv	a0,s2
    80002276:	ca5ff0ef          	jal	80001f1a <sleep_prepare>
    release(&wait_lock);
    8000227a:	855a                	mv	a0,s6
    8000227c:	a41fe0ef          	jal	80000cbc <release>
    sleep();
    80002280:	cd7ff0ef          	jal	80001f56 <sleep>
    acquire(&wait_lock);
    80002284:	855a                	mv	a0,s6
    80002286:	9b3fe0ef          	jal	80000c38 <acquire>
    havekids = 0;
    8000228a:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000228c:	0000e497          	auipc	s1,0xe
    80002290:	b2c48493          	addi	s1,s1,-1236 # 8000fdb8 <proc>
    80002294:	bf6d                	j	8000224e <kwait+0xb0>
      release(&wait_lock);
    80002296:	0000d517          	auipc	a0,0xd
    8000229a:	70a50513          	addi	a0,a0,1802 # 8000f9a0 <wait_lock>
    8000229e:	a1ffe0ef          	jal	80000cbc <release>
            return -1;
    800022a2:	59fd                	li	s3,-1
    800022a4:	bf9d                	j	8000221a <kwait+0x7c>

00000000800022a6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022a6:	7179                	addi	sp,sp,-48
    800022a8:	f406                	sd	ra,40(sp)
    800022aa:	f022                	sd	s0,32(sp)
    800022ac:	ec26                	sd	s1,24(sp)
    800022ae:	e84a                	sd	s2,16(sp)
    800022b0:	e44e                	sd	s3,8(sp)
    800022b2:	e052                	sd	s4,0(sp)
    800022b4:	1800                	addi	s0,sp,48
    800022b6:	84aa                	mv	s1,a0
    800022b8:	8a2e                	mv	s4,a1
    800022ba:	89b2                	mv	s3,a2
    800022bc:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022be:	e64ff0ef          	jal	80001922 <myproc>
  if (user_dst) {
    800022c2:	c085                	beqz	s1,800022e2 <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    800022c4:	874a                	mv	a4,s2
    800022c6:	86ce                	mv	a3,s3
    800022c8:	8652                	mv	a2,s4
    800022ca:	652c                	ld	a1,72(a0)
    800022cc:	6928                	ld	a0,80(a0)
    800022ce:	a9eff0ef          	jal	8000156c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022d2:	70a2                	ld	ra,40(sp)
    800022d4:	7402                	ld	s0,32(sp)
    800022d6:	64e2                	ld	s1,24(sp)
    800022d8:	6942                	ld	s2,16(sp)
    800022da:	69a2                	ld	s3,8(sp)
    800022dc:	6a02                	ld	s4,0(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
    memmove((char *)dst, src, len);
    800022e2:	0009061b          	sext.w	a2,s2
    800022e6:	85ce                	mv	a1,s3
    800022e8:	8552                	mv	a0,s4
    800022ea:	a67fe0ef          	jal	80000d50 <memmove>
    return 0;
    800022ee:	8526                	mv	a0,s1
    800022f0:	b7cd                	j	800022d2 <either_copyout+0x2c>

00000000800022f2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022f2:	7179                	addi	sp,sp,-48
    800022f4:	f406                	sd	ra,40(sp)
    800022f6:	f022                	sd	s0,32(sp)
    800022f8:	ec26                	sd	s1,24(sp)
    800022fa:	e84a                	sd	s2,16(sp)
    800022fc:	e44e                	sd	s3,8(sp)
    800022fe:	e052                	sd	s4,0(sp)
    80002300:	1800                	addi	s0,sp,48
    80002302:	8a2a                	mv	s4,a0
    80002304:	84ae                	mv	s1,a1
    80002306:	89b2                	mv	s3,a2
    80002308:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000230a:	e18ff0ef          	jal	80001922 <myproc>
  if (user_src) {
    8000230e:	c085                	beqz	s1,8000232e <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80002310:	874a                	mv	a4,s2
    80002312:	86ce                	mv	a3,s3
    80002314:	8652                	mv	a2,s4
    80002316:	652c                	ld	a1,72(a0)
    80002318:	6928                	ld	a0,80(a0)
    8000231a:	b12ff0ef          	jal	8000162c <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6942                	ld	s2,16(sp)
    80002326:	69a2                	ld	s3,8(sp)
    80002328:	6a02                	ld	s4,0(sp)
    8000232a:	6145                	addi	sp,sp,48
    8000232c:	8082                	ret
    memmove(dst, (char *)src, len);
    8000232e:	0009061b          	sext.w	a2,s2
    80002332:	85ce                	mv	a1,s3
    80002334:	8552                	mv	a0,s4
    80002336:	a1bfe0ef          	jal	80000d50 <memmove>
    return 0;
    8000233a:	8526                	mv	a0,s1
    8000233c:	b7cd                	j	8000231e <either_copyin+0x2c>

000000008000233e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000233e:	715d                	addi	sp,sp,-80
    80002340:	e486                	sd	ra,72(sp)
    80002342:	e0a2                	sd	s0,64(sp)
    80002344:	fc26                	sd	s1,56(sp)
    80002346:	f84a                	sd	s2,48(sp)
    80002348:	f44e                	sd	s3,40(sp)
    8000234a:	f052                	sd	s4,32(sp)
    8000234c:	ec56                	sd	s5,24(sp)
    8000234e:	e85a                	sd	s6,16(sp)
    80002350:	e45e                	sd	s7,8(sp)
    80002352:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    80002354:	00005517          	auipc	a0,0x5
    80002358:	d2450513          	addi	a0,a0,-732 # 80007078 <etext+0x78>
    8000235c:	9b4fe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002360:	0000e497          	auipc	s1,0xe
    80002364:	bb048493          	addi	s1,s1,-1104 # 8000ff10 <proc+0x158>
    80002368:	00013917          	auipc	s2,0x13
    8000236c:	5a890913          	addi	s2,s2,1448 # 80015910 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002370:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002372:	00005a97          	auipc	s5,0x5
    80002376:	eaea8a93          	addi	s5,s5,-338 # 80007220 <etext+0x220>
    printk("%d %s %s", p->pid, state, p->name);
    8000237a:	00005a17          	auipc	s4,0x5
    8000237e:	eaea0a13          	addi	s4,s4,-338 # 80007228 <etext+0x228>
    printk("\n");
    80002382:	00005997          	auipc	s3,0x5
    80002386:	cf698993          	addi	s3,s3,-778 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000238a:	00005b97          	auipc	s7,0x5
    8000238e:	3beb8b93          	addi	s7,s7,958 # 80007748 <states.0>
    80002392:	a829                	j	800023ac <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    80002394:	ed86a583          	lw	a1,-296(a3)
    80002398:	8552                	mv	a0,s4
    8000239a:	976fe0ef          	jal	80000510 <printk>
    printk("\n");
    8000239e:	854e                	mv	a0,s3
    800023a0:	970fe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023a4:	16848493          	addi	s1,s1,360
    800023a8:	03248063          	beq	s1,s2,800023c8 <procdump+0x8a>
    if (p->state == UNUSED)
    800023ac:	86a6                	mv	a3,s1
    800023ae:	ec04a783          	lw	a5,-320(s1)
    800023b2:	dbed                	beqz	a5,800023a4 <procdump+0x66>
      state = "???";
    800023b4:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023b6:	fcfb6fe3          	bltu	s6,a5,80002394 <procdump+0x56>
    800023ba:	02079713          	slli	a4,a5,0x20
    800023be:	01d75793          	srli	a5,a4,0x1d
    800023c2:	97de                	add	a5,a5,s7
    800023c4:	6390                	ld	a2,0(a5)
      state = states[p->state];
    800023c6:	b7f9                	j	80002394 <procdump+0x56>
  }
}
    800023c8:	60a6                	ld	ra,72(sp)
    800023ca:	6406                	ld	s0,64(sp)
    800023cc:	74e2                	ld	s1,56(sp)
    800023ce:	7942                	ld	s2,48(sp)
    800023d0:	79a2                	ld	s3,40(sp)
    800023d2:	7a02                	ld	s4,32(sp)
    800023d4:	6ae2                	ld	s5,24(sp)
    800023d6:	6b42                	ld	s6,16(sp)
    800023d8:	6ba2                	ld	s7,8(sp)
    800023da:	6161                	addi	sp,sp,80
    800023dc:	8082                	ret

00000000800023de <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023de:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023e2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023e6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023e8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023ea:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023ee:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023f2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023f6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023fa:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023fe:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002402:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002406:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000240a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000240e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002412:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002416:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000241a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000241c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000241e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002422:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002426:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000242a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000242e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002432:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002436:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000243a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000243e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002442:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002446:	8082                	ret

0000000080002448 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002448:	1141                	addi	sp,sp,-16
    8000244a:	e406                	sd	ra,8(sp)
    8000244c:	e022                	sd	s0,0(sp)
    8000244e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002450:	00005597          	auipc	a1,0x5
    80002454:	e1858593          	addi	a1,a1,-488 # 80007268 <etext+0x268>
    80002458:	00013517          	auipc	a0,0x13
    8000245c:	36050513          	addi	a0,a0,864 # 800157b8 <tickslock>
    80002460:	f58fe0ef          	jal	80000bb8 <initlock>
}
    80002464:	60a2                	ld	ra,8(sp)
    80002466:	6402                	ld	s0,0(sp)
    80002468:	0141                	addi	sp,sp,16
    8000246a:	8082                	ret

000000008000246c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000246c:	1141                	addi	sp,sp,-16
    8000246e:	e406                	sd	ra,8(sp)
    80002470:	e022                	sd	s0,0(sp)
    80002472:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002474:	00003797          	auipc	a5,0x3
    80002478:	0ec78793          	addi	a5,a5,236 # 80005560 <kernelvec>
    8000247c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002480:	60a2                	ld	ra,8(sp)
    80002482:	6402                	ld	s0,0(sp)
    80002484:	0141                	addi	sp,sp,16
    80002486:	8082                	ret

0000000080002488 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002488:	1141                	addi	sp,sp,-16
    8000248a:	e406                	sd	ra,8(sp)
    8000248c:	e022                	sd	s0,0(sp)
    8000248e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002490:	c92ff0ef          	jal	80001922 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002494:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002498:	04000737          	lui	a4,0x4000
    8000249c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000249e:	0732                	slli	a4,a4,0xc
    800024a0:	00004797          	auipc	a5,0x4
    800024a4:	b6078793          	addi	a5,a5,-1184 # 80006000 <_trampoline>
    800024a8:	00004697          	auipc	a3,0x4
    800024ac:	b5868693          	addi	a3,a3,-1192 # 80006000 <_trampoline>
    800024b0:	8f95                	sub	a5,a5,a3
    800024b2:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    800024b4:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024b8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800024ba:	18002773          	csrr	a4,satp
    800024be:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024c0:	6d38                	ld	a4,88(a0)
    800024c2:	613c                	ld	a5,64(a0)
    800024c4:	6685                	lui	a3,0x1
    800024c6:	97b6                	add	a5,a5,a3
    800024c8:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024ca:	6d3c                	ld	a5,88(a0)
    800024cc:	00000717          	auipc	a4,0x0
    800024d0:	0f470713          	addi	a4,a4,244 # 800025c0 <usertrap>
    800024d4:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800024d6:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024d8:	8712                	mv	a4,tp
    800024da:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024dc:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024e0:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024e4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024e8:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024ec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024ee:	6f9c                	ld	a5,24(a5)
    800024f0:	14179073          	csrw	sepc,a5
}
    800024f4:	60a2                	ld	ra,8(sp)
    800024f6:	6402                	ld	s0,0(sp)
    800024f8:	0141                	addi	sp,sp,16
    800024fa:	8082                	ret

00000000800024fc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024fc:	1141                	addi	sp,sp,-16
    800024fe:	e406                	sd	ra,8(sp)
    80002500:	e022                	sd	s0,0(sp)
    80002502:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80002504:	beaff0ef          	jal	800018ee <cpuid>
    80002508:	cd11                	beqz	a0,80002524 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    8000250a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000250e:	000f4737          	lui	a4,0xf4
    80002512:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002516:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80002518:	14d79073          	csrw	stimecmp,a5
}
    8000251c:	60a2                	ld	ra,8(sp)
    8000251e:	6402                	ld	s0,0(sp)
    80002520:	0141                	addi	sp,sp,16
    80002522:	8082                	ret
    acquire(&tickslock);
    80002524:	00013517          	auipc	a0,0x13
    80002528:	29450513          	addi	a0,a0,660 # 800157b8 <tickslock>
    8000252c:	f0cfe0ef          	jal	80000c38 <acquire>
    ticks++;
    80002530:	00005717          	auipc	a4,0x5
    80002534:	35870713          	addi	a4,a4,856 # 80007888 <ticks>
    80002538:	431c                	lw	a5,0(a4)
    8000253a:	2785                	addiw	a5,a5,1
    8000253c:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000253e:	853a                	mv	a0,a4
    80002540:	a47ff0ef          	jal	80001f86 <wakeup>
    release(&tickslock);
    80002544:	00013517          	auipc	a0,0x13
    80002548:	27450513          	addi	a0,a0,628 # 800157b8 <tickslock>
    8000254c:	f70fe0ef          	jal	80000cbc <release>
    80002550:	bf6d                	j	8000250a <clockintr+0xe>

0000000080002552 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002552:	1101                	addi	sp,sp,-32
    80002554:	ec06                	sd	ra,24(sp)
    80002556:	e822                	sd	s0,16(sp)
    80002558:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    8000255a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    8000255e:	57fd                	li	a5,-1
    80002560:	17fe                	slli	a5,a5,0x3f
    80002562:	07a5                	addi	a5,a5,9
    80002564:	00f70c63          	beq	a4,a5,8000257c <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002568:	57fd                	li	a5,-1
    8000256a:	17fe                	slli	a5,a5,0x3f
    8000256c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000256e:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80002570:	04f70463          	beq	a4,a5,800025b8 <devintr+0x66>
  }
}
    80002574:	60e2                	ld	ra,24(sp)
    80002576:	6442                	ld	s0,16(sp)
    80002578:	6105                	addi	sp,sp,32
    8000257a:	8082                	ret
    8000257c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000257e:	090030ef          	jal	8000560e <plic_claim>
    80002582:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002584:	47a9                	li	a5,10
    80002586:	02f50363          	beq	a0,a5,800025ac <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    8000258a:	4785                	li	a5,1
    8000258c:	02f50363          	beq	a0,a5,800025b2 <devintr+0x60>
    } else if (irq) {
    80002590:	c919                	beqz	a0,800025a6 <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    80002592:	85aa                	mv	a1,a0
    80002594:	00005517          	auipc	a0,0x5
    80002598:	cdc50513          	addi	a0,a0,-804 # 80007270 <etext+0x270>
    8000259c:	f75fd0ef          	jal	80000510 <printk>
      plic_complete(irq);
    800025a0:	8526                	mv	a0,s1
    800025a2:	08e030ef          	jal	80005630 <plic_complete>
    return 1;
    800025a6:	4505                	li	a0,1
    800025a8:	64a2                	ld	s1,8(sp)
    800025aa:	b7e9                	j	80002574 <devintr+0x22>
      uartintr();
    800025ac:	c52fe0ef          	jal	800009fe <uartintr>
    if (irq)
    800025b0:	bfc5                	j	800025a0 <devintr+0x4e>
      virtio_disk_intr();
    800025b2:	506030ef          	jal	80005ab8 <virtio_disk_intr>
    if (irq)
    800025b6:	b7ed                	j	800025a0 <devintr+0x4e>
    clockintr();
    800025b8:	f45ff0ef          	jal	800024fc <clockintr>
    return 2;
    800025bc:	4509                	li	a0,2
    800025be:	bf5d                	j	80002574 <devintr+0x22>

00000000800025c0 <usertrap>:
{
    800025c0:	1101                	addi	sp,sp,-32
    800025c2:	ec06                	sd	ra,24(sp)
    800025c4:	e822                	sd	s0,16(sp)
    800025c6:	e426                	sd	s1,8(sp)
    800025c8:	e04a                	sd	s2,0(sp)
    800025ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800025cc:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800025d0:	1007f793          	andi	a5,a5,256
    800025d4:	eba5                	bnez	a5,80002644 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025d6:	00003797          	auipc	a5,0x3
    800025da:	f8a78793          	addi	a5,a5,-118 # 80005560 <kernelvec>
    800025de:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025e2:	b40ff0ef          	jal	80001922 <myproc>
    800025e6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025e8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025ea:	14102773          	csrr	a4,sepc
    800025ee:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800025f0:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800025f4:	47a1                	li	a5,8
    800025f6:	04f70d63          	beq	a4,a5,80002650 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800025fa:	f59ff0ef          	jal	80002552 <devintr>
    800025fe:	892a                	mv	s2,a0
    80002600:	e54d                	bnez	a0,800026aa <usertrap+0xea>
    80002602:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002606:	47bd                	li	a5,15
    80002608:	08f70463          	beq	a4,a5,80002690 <usertrap+0xd0>
    8000260c:	14202773          	csrr	a4,scause
    80002610:	47b5                	li	a5,13
    80002612:	06f70f63          	beq	a4,a5,80002690 <usertrap+0xd0>
    80002616:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000261a:	5890                	lw	a2,48(s1)
    8000261c:	00005517          	auipc	a0,0x5
    80002620:	c9450513          	addi	a0,a0,-876 # 800072b0 <etext+0x2b0>
    80002624:	eedfd0ef          	jal	80000510 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002628:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000262c:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002630:	00005517          	auipc	a0,0x5
    80002634:	cb050513          	addi	a0,a0,-848 # 800072e0 <etext+0x2e0>
    80002638:	ed9fd0ef          	jal	80000510 <printk>
    setkilled(p);
    8000263c:	8526                	mv	a0,s1
    8000263e:	b13ff0ef          	jal	80002150 <setkilled>
    80002642:	a015                	j	80002666 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002644:	00005517          	auipc	a0,0x5
    80002648:	c4c50513          	addi	a0,a0,-948 # 80007290 <etext+0x290>
    8000264c:	9fcfe0ef          	jal	80000848 <panic>
    if (killed(p))
    80002650:	b25ff0ef          	jal	80002174 <killed>
    80002654:	e915                	bnez	a0,80002688 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002656:	6cb8                	ld	a4,88(s1)
    80002658:	6f1c                	ld	a5,24(a4)
    8000265a:	0791                	addi	a5,a5,4
    8000265c:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000265e:	10016073          	csrsi	sstatus,2
    syscall();
    80002662:	240000ef          	jal	800028a2 <syscall>
  if (killed(p))
    80002666:	8526                	mv	a0,s1
    80002668:	b0dff0ef          	jal	80002174 <killed>
    8000266c:	e521                	bnez	a0,800026b4 <usertrap+0xf4>
  prepare_return();
    8000266e:	e1bff0ef          	jal	80002488 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002672:	68a8                	ld	a0,80(s1)
    80002674:	8131                	srli	a0,a0,0xc
    80002676:	57fd                	li	a5,-1
    80002678:	17fe                	slli	a5,a5,0x3f
    8000267a:	8d5d                	or	a0,a0,a5
}
    8000267c:	60e2                	ld	ra,24(sp)
    8000267e:	6442                	ld	s0,16(sp)
    80002680:	64a2                	ld	s1,8(sp)
    80002682:	6902                	ld	s2,0(sp)
    80002684:	6105                	addi	sp,sp,32
    80002686:	8082                	ret
      kexit(-1);
    80002688:	557d                	li	a0,-1
    8000268a:	9b9ff0ef          	jal	80002042 <kexit>
    8000268e:	b7e1                	j	80002656 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002690:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002694:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002698:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    8000269a:	0016b693          	seqz	a3,a3
    8000269e:	64ac                	ld	a1,72(s1)
    800026a0:	68a8                	ld	a0,80(s1)
    800026a2:	e53fe0ef          	jal	800014f4 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800026a6:	f161                	bnez	a0,80002666 <usertrap+0xa6>
    800026a8:	b7bd                	j	80002616 <usertrap+0x56>
  if (killed(p))
    800026aa:	8526                	mv	a0,s1
    800026ac:	ac9ff0ef          	jal	80002174 <killed>
    800026b0:	c511                	beqz	a0,800026bc <usertrap+0xfc>
    800026b2:	a011                	j	800026b6 <usertrap+0xf6>
    800026b4:	4901                	li	s2,0
    kexit(-1);
    800026b6:	557d                	li	a0,-1
    800026b8:	98bff0ef          	jal	80002042 <kexit>
  if (which_dev == 2)
    800026bc:	4789                	li	a5,2
    800026be:	faf918e3          	bne	s2,a5,8000266e <usertrap+0xae>
    yield();
    800026c2:	82dff0ef          	jal	80001eee <yield>
    800026c6:	b765                	j	8000266e <usertrap+0xae>

00000000800026c8 <kerneltrap>:
{
    800026c8:	7179                	addi	sp,sp,-48
    800026ca:	f406                	sd	ra,40(sp)
    800026cc:	f022                	sd	s0,32(sp)
    800026ce:	ec26                	sd	s1,24(sp)
    800026d0:	e84a                	sd	s2,16(sp)
    800026d2:	e44e                	sd	s3,8(sp)
    800026d4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026d6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026da:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800026de:	142027f3          	csrr	a5,scause
    800026e2:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800026e4:	1004f793          	andi	a5,s1,256
    800026e8:	c795                	beqz	a5,80002714 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026ee:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800026f0:	eb85                	bnez	a5,80002720 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    800026f2:	e61ff0ef          	jal	80002552 <devintr>
    800026f6:	c91d                	beqz	a0,8000272c <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    800026f8:	4789                	li	a5,2
    800026fa:	04f50a63          	beq	a0,a5,8000274e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800026fe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002702:	10049073          	csrw	sstatus,s1
}
    80002706:	70a2                	ld	ra,40(sp)
    80002708:	7402                	ld	s0,32(sp)
    8000270a:	64e2                	ld	s1,24(sp)
    8000270c:	6942                	ld	s2,16(sp)
    8000270e:	69a2                	ld	s3,8(sp)
    80002710:	6145                	addi	sp,sp,48
    80002712:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002714:	00005517          	auipc	a0,0x5
    80002718:	bf450513          	addi	a0,a0,-1036 # 80007308 <etext+0x308>
    8000271c:	92cfe0ef          	jal	80000848 <panic>
    panic("kerneltrap: interrupts enabled");
    80002720:	00005517          	auipc	a0,0x5
    80002724:	c1050513          	addi	a0,a0,-1008 # 80007330 <etext+0x330>
    80002728:	920fe0ef          	jal	80000848 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000272c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002730:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002734:	85ce                	mv	a1,s3
    80002736:	00005517          	auipc	a0,0x5
    8000273a:	c1a50513          	addi	a0,a0,-998 # 80007350 <etext+0x350>
    8000273e:	dd3fd0ef          	jal	80000510 <printk>
    panic("kerneltrap");
    80002742:	00005517          	auipc	a0,0x5
    80002746:	c3650513          	addi	a0,a0,-970 # 80007378 <etext+0x378>
    8000274a:	8fefe0ef          	jal	80000848 <panic>
  if (which_dev == 2 && myproc() != 0)
    8000274e:	9d4ff0ef          	jal	80001922 <myproc>
    80002752:	d555                	beqz	a0,800026fe <kerneltrap+0x36>
    yield();
    80002754:	f9aff0ef          	jal	80001eee <yield>
    80002758:	b75d                	j	800026fe <kerneltrap+0x36>

000000008000275a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000275a:	1101                	addi	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	1000                	addi	s0,sp,32
    80002764:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002766:	9bcff0ef          	jal	80001922 <myproc>
  switch (n) {
    8000276a:	4795                	li	a5,5
    8000276c:	0497e163          	bltu	a5,s1,800027ae <argraw+0x54>
    80002770:	048a                	slli	s1,s1,0x2
    80002772:	00005717          	auipc	a4,0x5
    80002776:	00670713          	addi	a4,a4,6 # 80007778 <states.0+0x30>
    8000277a:	94ba                	add	s1,s1,a4
    8000277c:	409c                	lw	a5,0(s1)
    8000277e:	97ba                	add	a5,a5,a4
    80002780:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002782:	6d3c                	ld	a5,88(a0)
    80002784:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret
    return p->trapframe->a1;
    80002790:	6d3c                	ld	a5,88(a0)
    80002792:	7fa8                	ld	a0,120(a5)
    80002794:	bfcd                	j	80002786 <argraw+0x2c>
    return p->trapframe->a2;
    80002796:	6d3c                	ld	a5,88(a0)
    80002798:	63c8                	ld	a0,128(a5)
    8000279a:	b7f5                	j	80002786 <argraw+0x2c>
    return p->trapframe->a3;
    8000279c:	6d3c                	ld	a5,88(a0)
    8000279e:	67c8                	ld	a0,136(a5)
    800027a0:	b7dd                	j	80002786 <argraw+0x2c>
    return p->trapframe->a4;
    800027a2:	6d3c                	ld	a5,88(a0)
    800027a4:	6bc8                	ld	a0,144(a5)
    800027a6:	b7c5                	j	80002786 <argraw+0x2c>
    return p->trapframe->a5;
    800027a8:	6d3c                	ld	a5,88(a0)
    800027aa:	6fc8                	ld	a0,152(a5)
    800027ac:	bfe9                	j	80002786 <argraw+0x2c>
  panic("argraw");
    800027ae:	00005517          	auipc	a0,0x5
    800027b2:	bda50513          	addi	a0,a0,-1062 # 80007388 <etext+0x388>
    800027b6:	892fe0ef          	jal	80000848 <panic>

00000000800027ba <fetchaddr>:
{
    800027ba:	1101                	addi	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	e04a                	sd	s2,0(sp)
    800027c4:	1000                	addi	s0,sp,32
    800027c6:	84aa                	mv	s1,a0
    800027c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027ca:	958ff0ef          	jal	80001922 <myproc>
  if (addr >= p->sz ||
    800027ce:	652c                	ld	a1,72(a0)
    800027d0:	02b4f663          	bgeu	s1,a1,800027fc <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027d4:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    800027d8:	02f5e263          	bltu	a1,a5,800027fc <fetchaddr+0x42>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    800027dc:	4721                	li	a4,8
    800027de:	86a6                	mv	a3,s1
    800027e0:	864a                	mv	a2,s2
    800027e2:	6928                	ld	a0,80(a0)
    800027e4:	e49fe0ef          	jal	8000162c <copyin>
    800027e8:	00a03533          	snez	a0,a0
    800027ec:	40a0053b          	negw	a0,a0
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6902                	ld	s2,0(sp)
    800027f8:	6105                	addi	sp,sp,32
    800027fa:	8082                	ret
    return -1;
    800027fc:	557d                	li	a0,-1
    800027fe:	bfcd                	j	800027f0 <fetchaddr+0x36>

0000000080002800 <fetchstr>:
{
    80002800:	7179                	addi	sp,sp,-48
    80002802:	f406                	sd	ra,40(sp)
    80002804:	f022                	sd	s0,32(sp)
    80002806:	ec26                	sd	s1,24(sp)
    80002808:	e84a                	sd	s2,16(sp)
    8000280a:	e44e                	sd	s3,8(sp)
    8000280c:	1800                	addi	s0,sp,48
    8000280e:	89aa                	mv	s3,a0
    80002810:	84ae                	mv	s1,a1
    80002812:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002814:	90eff0ef          	jal	80001922 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002818:	874a                	mv	a4,s2
    8000281a:	86ce                	mv	a3,s3
    8000281c:	8626                	mv	a2,s1
    8000281e:	652c                	ld	a1,72(a0)
    80002820:	6928                	ld	a0,80(a0)
    80002822:	ea9fe0ef          	jal	800016ca <copyinstr>
    80002826:	00054c63          	bltz	a0,8000283e <fetchstr+0x3e>
  return strlen(buf);
    8000282a:	8526                	mv	a0,s1
    8000282c:	e48fe0ef          	jal	80000e74 <strlen>
}
    80002830:	70a2                	ld	ra,40(sp)
    80002832:	7402                	ld	s0,32(sp)
    80002834:	64e2                	ld	s1,24(sp)
    80002836:	6942                	ld	s2,16(sp)
    80002838:	69a2                	ld	s3,8(sp)
    8000283a:	6145                	addi	sp,sp,48
    8000283c:	8082                	ret
    return -1;
    8000283e:	557d                	li	a0,-1
    80002840:	bfc5                	j	80002830 <fetchstr+0x30>

0000000080002842 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002842:	1101                	addi	sp,sp,-32
    80002844:	ec06                	sd	ra,24(sp)
    80002846:	e822                	sd	s0,16(sp)
    80002848:	e426                	sd	s1,8(sp)
    8000284a:	1000                	addi	s0,sp,32
    8000284c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000284e:	f0dff0ef          	jal	8000275a <argraw>
    80002852:	c088                	sw	a0,0(s1)
}
    80002854:	60e2                	ld	ra,24(sp)
    80002856:	6442                	ld	s0,16(sp)
    80002858:	64a2                	ld	s1,8(sp)
    8000285a:	6105                	addi	sp,sp,32
    8000285c:	8082                	ret

000000008000285e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000285e:	1101                	addi	sp,sp,-32
    80002860:	ec06                	sd	ra,24(sp)
    80002862:	e822                	sd	s0,16(sp)
    80002864:	e426                	sd	s1,8(sp)
    80002866:	1000                	addi	s0,sp,32
    80002868:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000286a:	ef1ff0ef          	jal	8000275a <argraw>
    8000286e:	e088                	sd	a0,0(s1)
}
    80002870:	60e2                	ld	ra,24(sp)
    80002872:	6442                	ld	s0,16(sp)
    80002874:	64a2                	ld	s1,8(sp)
    80002876:	6105                	addi	sp,sp,32
    80002878:	8082                	ret

000000008000287a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000287a:	1101                	addi	sp,sp,-32
    8000287c:	ec06                	sd	ra,24(sp)
    8000287e:	e822                	sd	s0,16(sp)
    80002880:	e426                	sd	s1,8(sp)
    80002882:	e04a                	sd	s2,0(sp)
    80002884:	1000                	addi	s0,sp,32
    80002886:	892e                	mv	s2,a1
    80002888:	84b2                	mv	s1,a2
  *ip = argraw(n);
    8000288a:	ed1ff0ef          	jal	8000275a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000288e:	8626                	mv	a2,s1
    80002890:	85ca                	mv	a1,s2
    80002892:	f6fff0ef          	jal	80002800 <fetchstr>
}
    80002896:	60e2                	ld	ra,24(sp)
    80002898:	6442                	ld	s0,16(sp)
    8000289a:	64a2                	ld	s1,8(sp)
    8000289c:	6902                	ld	s2,0(sp)
    8000289e:	6105                	addi	sp,sp,32
    800028a0:	8082                	ret

00000000800028a2 <syscall>:
  [SYS_getYear]= sys_getYear
};

void
syscall(void)
{
    800028a2:	1101                	addi	sp,sp,-32
    800028a4:	ec06                	sd	ra,24(sp)
    800028a6:	e822                	sd	s0,16(sp)
    800028a8:	e426                	sd	s1,8(sp)
    800028aa:	e04a                	sd	s2,0(sp)
    800028ac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028ae:	874ff0ef          	jal	80001922 <myproc>
    800028b2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028b4:	05853903          	ld	s2,88(a0)
    800028b8:	0a893783          	ld	a5,168(s2)
    800028bc:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028c0:	37fd                	addiw	a5,a5,-1
    800028c2:	4759                	li	a4,22
    800028c4:	00f76f63          	bltu	a4,a5,800028e2 <syscall+0x40>
    800028c8:	00369713          	slli	a4,a3,0x3
    800028cc:	00005797          	auipc	a5,0x5
    800028d0:	ec478793          	addi	a5,a5,-316 # 80007790 <syscalls>
    800028d4:	97ba                	add	a5,a5,a4
    800028d6:	639c                	ld	a5,0(a5)
    800028d8:	c789                	beqz	a5,800028e2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028da:	9782                	jalr	a5
    800028dc:	06a93823          	sd	a0,112(s2)
    800028e0:	a829                	j	800028fa <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800028e2:	15848613          	addi	a2,s1,344
    800028e6:	588c                	lw	a1,48(s1)
    800028e8:	00005517          	auipc	a0,0x5
    800028ec:	aa850513          	addi	a0,a0,-1368 # 80007390 <etext+0x390>
    800028f0:	c21fd0ef          	jal	80000510 <printk>
    p->trapframe->a0 = -1;
    800028f4:	6cbc                	ld	a5,88(s1)
    800028f6:	577d                	li	a4,-1
    800028f8:	fbb8                	sd	a4,112(a5)
  }
}
    800028fa:	60e2                	ld	ra,24(sp)
    800028fc:	6442                	ld	s0,16(sp)
    800028fe:	64a2                	ld	s1,8(sp)
    80002900:	6902                	ld	s2,0(sp)
    80002902:	6105                	addi	sp,sp,32
    80002904:	8082                	ret

0000000080002906 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002906:	1101                	addi	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000290e:	fec40593          	addi	a1,s0,-20
    80002912:	4501                	li	a0,0
    80002914:	f2fff0ef          	jal	80002842 <argint>
  kexit(n);
    80002918:	fec42503          	lw	a0,-20(s0)
    8000291c:	f26ff0ef          	jal	80002042 <kexit>
  return 0; // not reached
}
    80002920:	4501                	li	a0,0
    80002922:	60e2                	ld	ra,24(sp)
    80002924:	6442                	ld	s0,16(sp)
    80002926:	6105                	addi	sp,sp,32
    80002928:	8082                	ret

000000008000292a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000292a:	1141                	addi	sp,sp,-16
    8000292c:	e406                	sd	ra,8(sp)
    8000292e:	e022                	sd	s0,0(sp)
    80002930:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002932:	ff1fe0ef          	jal	80001922 <myproc>
}
    80002936:	5908                	lw	a0,48(a0)
    80002938:	60a2                	ld	ra,8(sp)
    8000293a:	6402                	ld	s0,0(sp)
    8000293c:	0141                	addi	sp,sp,16
    8000293e:	8082                	ret

0000000080002940 <sys_fork>:

uint64
sys_fork(void)
{
    80002940:	1141                	addi	sp,sp,-16
    80002942:	e406                	sd	ra,8(sp)
    80002944:	e022                	sd	s0,0(sp)
    80002946:	0800                	addi	s0,sp,16
  return kfork();
    80002948:	b34ff0ef          	jal	80001c7c <kfork>
}
    8000294c:	60a2                	ld	ra,8(sp)
    8000294e:	6402                	ld	s0,0(sp)
    80002950:	0141                	addi	sp,sp,16
    80002952:	8082                	ret

0000000080002954 <sys_wait>:

uint64
sys_wait(void)
{
    80002954:	1101                	addi	sp,sp,-32
    80002956:	ec06                	sd	ra,24(sp)
    80002958:	e822                	sd	s0,16(sp)
    8000295a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000295c:	fe840593          	addi	a1,s0,-24
    80002960:	4501                	li	a0,0
    80002962:	efdff0ef          	jal	8000285e <argaddr>
  return kwait(p);
    80002966:	fe843503          	ld	a0,-24(s0)
    8000296a:	835ff0ef          	jal	8000219e <kwait>
}
    8000296e:	60e2                	ld	ra,24(sp)
    80002970:	6442                	ld	s0,16(sp)
    80002972:	6105                	addi	sp,sp,32
    80002974:	8082                	ret

0000000080002976 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002976:	7179                	addi	sp,sp,-48
    80002978:	f406                	sd	ra,40(sp)
    8000297a:	f022                	sd	s0,32(sp)
    8000297c:	ec26                	sd	s1,24(sp)
    8000297e:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002980:	fd840593          	addi	a1,s0,-40
    80002984:	4501                	li	a0,0
    80002986:	ebdff0ef          	jal	80002842 <argint>
  argint(1, &t);
    8000298a:	fdc40593          	addi	a1,s0,-36
    8000298e:	4505                	li	a0,1
    80002990:	eb3ff0ef          	jal	80002842 <argint>
  addr = myproc()->sz;
    80002994:	f8ffe0ef          	jal	80001922 <myproc>
    80002998:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    8000299a:	fdc42703          	lw	a4,-36(s0)
    8000299e:	4785                	li	a5,1
    800029a0:	02f70a63          	beq	a4,a5,800029d4 <sys_sbrk+0x5e>
    800029a4:	fd842783          	lw	a5,-40(s0)
    800029a8:	0207c663          	bltz	a5,800029d4 <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    800029ac:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    800029b0:	020007b7          	lui	a5,0x2000
    800029b4:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    800029b6:	07b6                	slli	a5,a5,0xd
    800029b8:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    800029bc:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    800029c0:	8fd9                	or	a5,a5,a4
    800029c2:	e79d                	bnez	a5,800029f0 <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    800029c4:	f5ffe0ef          	jal	80001922 <myproc>
    800029c8:	fd842703          	lw	a4,-40(s0)
    800029cc:	653c                	ld	a5,72(a0)
    800029ce:	97ba                	add	a5,a5,a4
    800029d0:	e53c                	sd	a5,72(a0)
    800029d2:	a039                	j	800029e0 <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    800029d4:	fd842503          	lw	a0,-40(s0)
    800029d8:	a46ff0ef          	jal	80001c1e <growproc>
    800029dc:	00054863          	bltz	a0,800029ec <sys_sbrk+0x76>
  }
  return addr;
}
    800029e0:	8526                	mv	a0,s1
    800029e2:	70a2                	ld	ra,40(sp)
    800029e4:	7402                	ld	s0,32(sp)
    800029e6:	64e2                	ld	s1,24(sp)
    800029e8:	6145                	addi	sp,sp,48
    800029ea:	8082                	ret
      return -1;
    800029ec:	54fd                	li	s1,-1
    800029ee:	bfcd                	j	800029e0 <sys_sbrk+0x6a>
      return -1;
    800029f0:	54fd                	li	s1,-1
    800029f2:	b7fd                	j	800029e0 <sys_sbrk+0x6a>

00000000800029f4 <sys_pause>:

uint64
sys_pause(void)
{
    800029f4:	7139                	addi	sp,sp,-64
    800029f6:	fc06                	sd	ra,56(sp)
    800029f8:	f822                	sd	s0,48(sp)
    800029fa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029fc:	fcc40593          	addi	a1,s0,-52
    80002a00:	4501                	li	a0,0
    80002a02:	e41ff0ef          	jal	80002842 <argint>
  if (n < 0)
    80002a06:	fcc42783          	lw	a5,-52(s0)
    80002a0a:	0807c063          	bltz	a5,80002a8a <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002a0e:	00013517          	auipc	a0,0x13
    80002a12:	daa50513          	addi	a0,a0,-598 # 800157b8 <tickslock>
    80002a16:	a22fe0ef          	jal	80000c38 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a1a:	fcc42783          	lw	a5,-52(s0)
    80002a1e:	cbb9                	beqz	a5,80002a74 <sys_pause+0x80>
    80002a20:	f426                	sd	s1,40(sp)
    80002a22:	f04a                	sd	s2,32(sp)
    80002a24:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a26:	00005997          	auipc	s3,0x5
    80002a2a:	e629a983          	lw	s3,-414(s3) # 80007888 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002a2e:	00005917          	auipc	s2,0x5
    80002a32:	e5a90913          	addi	s2,s2,-422 # 80007888 <ticks>
    release(&tickslock);
    80002a36:	00013497          	auipc	s1,0x13
    80002a3a:	d8248493          	addi	s1,s1,-638 # 800157b8 <tickslock>
    if (killed(myproc())) {
    80002a3e:	ee5fe0ef          	jal	80001922 <myproc>
    80002a42:	f32ff0ef          	jal	80002174 <killed>
    80002a46:	e529                	bnez	a0,80002a90 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002a48:	854a                	mv	a0,s2
    80002a4a:	cd0ff0ef          	jal	80001f1a <sleep_prepare>
    release(&tickslock);
    80002a4e:	8526                	mv	a0,s1
    80002a50:	a6cfe0ef          	jal	80000cbc <release>
    sleep();
    80002a54:	d02ff0ef          	jal	80001f56 <sleep>
    acquire(&tickslock);
    80002a58:	8526                	mv	a0,s1
    80002a5a:	9defe0ef          	jal	80000c38 <acquire>
  while (ticks - ticks0 < n) {
    80002a5e:	00092783          	lw	a5,0(s2)
    80002a62:	413787bb          	subw	a5,a5,s3
    80002a66:	fcc42703          	lw	a4,-52(s0)
    80002a6a:	fce7eae3          	bltu	a5,a4,80002a3e <sys_pause+0x4a>
    80002a6e:	74a2                	ld	s1,40(sp)
    80002a70:	7902                	ld	s2,32(sp)
    80002a72:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a74:	00013517          	auipc	a0,0x13
    80002a78:	d4450513          	addi	a0,a0,-700 # 800157b8 <tickslock>
    80002a7c:	a40fe0ef          	jal	80000cbc <release>
  return 0;
    80002a80:	4501                	li	a0,0
}
    80002a82:	70e2                	ld	ra,56(sp)
    80002a84:	7442                	ld	s0,48(sp)
    80002a86:	6121                	addi	sp,sp,64
    80002a88:	8082                	ret
    n = 0;
    80002a8a:	fc042623          	sw	zero,-52(s0)
    80002a8e:	b741                	j	80002a0e <sys_pause+0x1a>
      release(&tickslock);
    80002a90:	00013517          	auipc	a0,0x13
    80002a94:	d2850513          	addi	a0,a0,-728 # 800157b8 <tickslock>
    80002a98:	a24fe0ef          	jal	80000cbc <release>
      return -1;
    80002a9c:	557d                	li	a0,-1
    80002a9e:	74a2                	ld	s1,40(sp)
    80002aa0:	7902                	ld	s2,32(sp)
    80002aa2:	69e2                	ld	s3,24(sp)
    80002aa4:	bff9                	j	80002a82 <sys_pause+0x8e>

0000000080002aa6 <sys_kill>:

uint64
sys_kill(void)
{
    80002aa6:	1101                	addi	sp,sp,-32
    80002aa8:	ec06                	sd	ra,24(sp)
    80002aaa:	e822                	sd	s0,16(sp)
    80002aac:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002aae:	fec40593          	addi	a1,s0,-20
    80002ab2:	4501                	li	a0,0
    80002ab4:	d8fff0ef          	jal	80002842 <argint>
  return kkill(pid);
    80002ab8:	fec42503          	lw	a0,-20(s0)
    80002abc:	e2cff0ef          	jal	800020e8 <kkill>
}
    80002ac0:	60e2                	ld	ra,24(sp)
    80002ac2:	6442                	ld	s0,16(sp)
    80002ac4:	6105                	addi	sp,sp,32
    80002ac6:	8082                	ret

0000000080002ac8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ac8:	1101                	addi	sp,sp,-32
    80002aca:	ec06                	sd	ra,24(sp)
    80002acc:	e822                	sd	s0,16(sp)
    80002ace:	e426                	sd	s1,8(sp)
    80002ad0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ad2:	00013517          	auipc	a0,0x13
    80002ad6:	ce650513          	addi	a0,a0,-794 # 800157b8 <tickslock>
    80002ada:	95efe0ef          	jal	80000c38 <acquire>
  xticks = ticks;
    80002ade:	00005797          	auipc	a5,0x5
    80002ae2:	daa7a783          	lw	a5,-598(a5) # 80007888 <ticks>
    80002ae6:	84be                	mv	s1,a5
  release(&tickslock);
    80002ae8:	00013517          	auipc	a0,0x13
    80002aec:	cd050513          	addi	a0,a0,-816 # 800157b8 <tickslock>
    80002af0:	9ccfe0ef          	jal	80000cbc <release>
  return xticks;
}
    80002af4:	02049513          	slli	a0,s1,0x20
    80002af8:	9101                	srli	a0,a0,0x20
    80002afa:	60e2                	ld	ra,24(sp)
    80002afc:	6442                	ld	s0,16(sp)
    80002afe:	64a2                	ld	s1,8(sp)
    80002b00:	6105                	addi	sp,sp,32
    80002b02:	8082                	ret

0000000080002b04 <sys_getYear>:

uint64
sys_getYear(void){
    80002b04:	1141                	addi	sp,sp,-16
    80002b06:	e406                	sd	ra,8(sp)
    80002b08:	e022                	sd	s0,0(sp)
    80002b0a:	0800                	addi	s0,sp,16
  return 2026;
}
    80002b0c:	7ea00513          	li	a0,2026
    80002b10:	60a2                	ld	ra,8(sp)
    80002b12:	6402                	ld	s0,0(sp)
    80002b14:	0141                	addi	sp,sp,16
    80002b16:	8082                	ret

0000000080002b18 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b18:	7179                	addi	sp,sp,-48
    80002b1a:	f406                	sd	ra,40(sp)
    80002b1c:	f022                	sd	s0,32(sp)
    80002b1e:	ec26                	sd	s1,24(sp)
    80002b20:	e84a                	sd	s2,16(sp)
    80002b22:	e44e                	sd	s3,8(sp)
    80002b24:	e052                	sd	s4,0(sp)
    80002b26:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b28:	00005597          	auipc	a1,0x5
    80002b2c:	88858593          	addi	a1,a1,-1912 # 800073b0 <etext+0x3b0>
    80002b30:	00013517          	auipc	a0,0x13
    80002b34:	ca050513          	addi	a0,a0,-864 # 800157d0 <bcache>
    80002b38:	880fe0ef          	jal	80000bb8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b3c:	0001b797          	auipc	a5,0x1b
    80002b40:	c9478793          	addi	a5,a5,-876 # 8001d7d0 <bcache+0x8000>
    80002b44:	0001b717          	auipc	a4,0x1b
    80002b48:	ef470713          	addi	a4,a4,-268 # 8001da38 <bcache+0x8268>
    80002b4c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b50:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b54:	00013497          	auipc	s1,0x13
    80002b58:	c9448493          	addi	s1,s1,-876 # 800157e8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b5c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b5e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b60:	00005a17          	auipc	s4,0x5
    80002b64:	858a0a13          	addi	s4,s4,-1960 # 800073b8 <etext+0x3b8>
    b->next = bcache.head.next;
    80002b68:	2b893783          	ld	a5,696(s2)
    80002b6c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b6e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b72:	85d2                	mv	a1,s4
    80002b74:	01048513          	addi	a0,s1,16
    80002b78:	42a010ef          	jal	80003fa2 <initsleeplock>
    bcache.head.next->prev = b;
    80002b7c:	2b893783          	ld	a5,696(s2)
    80002b80:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b82:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b86:	45848493          	addi	s1,s1,1112
    80002b8a:	fd349fe3          	bne	s1,s3,80002b68 <binit+0x50>
  }
}
    80002b8e:	70a2                	ld	ra,40(sp)
    80002b90:	7402                	ld	s0,32(sp)
    80002b92:	64e2                	ld	s1,24(sp)
    80002b94:	6942                	ld	s2,16(sp)
    80002b96:	69a2                	ld	s3,8(sp)
    80002b98:	6a02                	ld	s4,0(sp)
    80002b9a:	6145                	addi	sp,sp,48
    80002b9c:	8082                	ret

0000000080002b9e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002b9e:	7179                	addi	sp,sp,-48
    80002ba0:	f406                	sd	ra,40(sp)
    80002ba2:	f022                	sd	s0,32(sp)
    80002ba4:	ec26                	sd	s1,24(sp)
    80002ba6:	e84a                	sd	s2,16(sp)
    80002ba8:	e44e                	sd	s3,8(sp)
    80002baa:	1800                	addi	s0,sp,48
    80002bac:	892a                	mv	s2,a0
    80002bae:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002bb0:	00013517          	auipc	a0,0x13
    80002bb4:	c2050513          	addi	a0,a0,-992 # 800157d0 <bcache>
    80002bb8:	880fe0ef          	jal	80000c38 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002bbc:	0001b497          	auipc	s1,0x1b
    80002bc0:	ecc4b483          	ld	s1,-308(s1) # 8001da88 <bcache+0x82b8>
    80002bc4:	0001b797          	auipc	a5,0x1b
    80002bc8:	e7478793          	addi	a5,a5,-396 # 8001da38 <bcache+0x8268>
    80002bcc:	02f48b63          	beq	s1,a5,80002c02 <bread+0x64>
    80002bd0:	873e                	mv	a4,a5
    80002bd2:	a021                	j	80002bda <bread+0x3c>
    80002bd4:	68a4                	ld	s1,80(s1)
    80002bd6:	02e48663          	beq	s1,a4,80002c02 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002bda:	449c                	lw	a5,8(s1)
    80002bdc:	ff279ce3          	bne	a5,s2,80002bd4 <bread+0x36>
    80002be0:	44dc                	lw	a5,12(s1)
    80002be2:	ff3799e3          	bne	a5,s3,80002bd4 <bread+0x36>
      b->refcnt++;
    80002be6:	40bc                	lw	a5,64(s1)
    80002be8:	2785                	addiw	a5,a5,1
    80002bea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bec:	00013517          	auipc	a0,0x13
    80002bf0:	be450513          	addi	a0,a0,-1052 # 800157d0 <bcache>
    80002bf4:	8c8fe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002bf8:	01048513          	addi	a0,s1,16
    80002bfc:	3dc010ef          	jal	80003fd8 <acquiresleep>
      return b;
    80002c00:	a889                	j	80002c52 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c02:	0001b497          	auipc	s1,0x1b
    80002c06:	e7e4b483          	ld	s1,-386(s1) # 8001da80 <bcache+0x82b0>
    80002c0a:	0001b797          	auipc	a5,0x1b
    80002c0e:	e2e78793          	addi	a5,a5,-466 # 8001da38 <bcache+0x8268>
    80002c12:	00f48863          	beq	s1,a5,80002c22 <bread+0x84>
    80002c16:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002c18:	40bc                	lw	a5,64(s1)
    80002c1a:	cb91                	beqz	a5,80002c2e <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c1c:	64a4                	ld	s1,72(s1)
    80002c1e:	fee49de3          	bne	s1,a4,80002c18 <bread+0x7a>
  panic("bget: no buffers");
    80002c22:	00004517          	auipc	a0,0x4
    80002c26:	79e50513          	addi	a0,a0,1950 # 800073c0 <etext+0x3c0>
    80002c2a:	c1ffd0ef          	jal	80000848 <panic>
      b->dev = dev;
    80002c2e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c32:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c36:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c3a:	4785                	li	a5,1
    80002c3c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c3e:	00013517          	auipc	a0,0x13
    80002c42:	b9250513          	addi	a0,a0,-1134 # 800157d0 <bcache>
    80002c46:	876fe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002c4a:	01048513          	addi	a0,s1,16
    80002c4e:	38a010ef          	jal	80003fd8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002c52:	409c                	lw	a5,0(s1)
    80002c54:	cb89                	beqz	a5,80002c66 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c56:	8526                	mv	a0,s1
    80002c58:	70a2                	ld	ra,40(sp)
    80002c5a:	7402                	ld	s0,32(sp)
    80002c5c:	64e2                	ld	s1,24(sp)
    80002c5e:	6942                	ld	s2,16(sp)
    80002c60:	69a2                	ld	s3,8(sp)
    80002c62:	6145                	addi	sp,sp,48
    80002c64:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c66:	4581                	li	a1,0
    80002c68:	8526                	mv	a0,s1
    80002c6a:	41f020ef          	jal	80005888 <virtio_disk_rw>
    b->valid = 1;
    80002c6e:	4785                	li	a5,1
    80002c70:	c09c                	sw	a5,0(s1)
  return b;
    80002c72:	b7d5                	j	80002c56 <bread+0xb8>

0000000080002c74 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002c74:	1101                	addi	sp,sp,-32
    80002c76:	ec06                	sd	ra,24(sp)
    80002c78:	e822                	sd	s0,16(sp)
    80002c7a:	e426                	sd	s1,8(sp)
    80002c7c:	1000                	addi	s0,sp,32
    80002c7e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002c80:	0541                	addi	a0,a0,16
    80002c82:	3e2010ef          	jal	80004064 <holdingsleep>
    80002c86:	c911                	beqz	a0,80002c9a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c88:	4585                	li	a1,1
    80002c8a:	8526                	mv	a0,s1
    80002c8c:	3fd020ef          	jal	80005888 <virtio_disk_rw>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6105                	addi	sp,sp,32
    80002c98:	8082                	ret
    panic("bwrite");
    80002c9a:	00004517          	auipc	a0,0x4
    80002c9e:	73e50513          	addi	a0,a0,1854 # 800073d8 <etext+0x3d8>
    80002ca2:	ba7fd0ef          	jal	80000848 <panic>

0000000080002ca6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
    80002cb2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002cb4:	01050913          	addi	s2,a0,16
    80002cb8:	854a                	mv	a0,s2
    80002cba:	3aa010ef          	jal	80004064 <holdingsleep>
    80002cbe:	c125                	beqz	a0,80002d1e <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	36a010ef          	jal	8000402c <releasesleep>

  acquire(&bcache.lock);
    80002cc6:	00013517          	auipc	a0,0x13
    80002cca:	b0a50513          	addi	a0,a0,-1270 # 800157d0 <bcache>
    80002cce:	f6bfd0ef          	jal	80000c38 <acquire>
  b->refcnt--;
    80002cd2:	40bc                	lw	a5,64(s1)
    80002cd4:	37fd                	addiw	a5,a5,-1
    80002cd6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002cd8:	e79d                	bnez	a5,80002d06 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002cda:	68b8                	ld	a4,80(s1)
    80002cdc:	64bc                	ld	a5,72(s1)
    80002cde:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002ce0:	68b8                	ld	a4,80(s1)
    80002ce2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002ce4:	0001b797          	auipc	a5,0x1b
    80002ce8:	aec78793          	addi	a5,a5,-1300 # 8001d7d0 <bcache+0x8000>
    80002cec:	2b87b703          	ld	a4,696(a5)
    80002cf0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cf2:	0001b717          	auipc	a4,0x1b
    80002cf6:	d4670713          	addi	a4,a4,-698 # 8001da38 <bcache+0x8268>
    80002cfa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cfc:	2b87b703          	ld	a4,696(a5)
    80002d00:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d02:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002d06:	00013517          	auipc	a0,0x13
    80002d0a:	aca50513          	addi	a0,a0,-1334 # 800157d0 <bcache>
    80002d0e:	faffd0ef          	jal	80000cbc <release>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret
    panic("brelse");
    80002d1e:	00004517          	auipc	a0,0x4
    80002d22:	6c250513          	addi	a0,a0,1730 # 800073e0 <etext+0x3e0>
    80002d26:	b23fd0ef          	jal	80000848 <panic>

0000000080002d2a <bpin>:

void
bpin(struct buf *b)
{
    80002d2a:	1101                	addi	sp,sp,-32
    80002d2c:	ec06                	sd	ra,24(sp)
    80002d2e:	e822                	sd	s0,16(sp)
    80002d30:	e426                	sd	s1,8(sp)
    80002d32:	1000                	addi	s0,sp,32
    80002d34:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d36:	00013517          	auipc	a0,0x13
    80002d3a:	a9a50513          	addi	a0,a0,-1382 # 800157d0 <bcache>
    80002d3e:	efbfd0ef          	jal	80000c38 <acquire>
  b->refcnt++;
    80002d42:	40bc                	lw	a5,64(s1)
    80002d44:	2785                	addiw	a5,a5,1
    80002d46:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d48:	00013517          	auipc	a0,0x13
    80002d4c:	a8850513          	addi	a0,a0,-1400 # 800157d0 <bcache>
    80002d50:	f6dfd0ef          	jal	80000cbc <release>
}
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	6105                	addi	sp,sp,32
    80002d5c:	8082                	ret

0000000080002d5e <bunpin>:

void
bunpin(struct buf *b)
{
    80002d5e:	1101                	addi	sp,sp,-32
    80002d60:	ec06                	sd	ra,24(sp)
    80002d62:	e822                	sd	s0,16(sp)
    80002d64:	e426                	sd	s1,8(sp)
    80002d66:	1000                	addi	s0,sp,32
    80002d68:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d6a:	00013517          	auipc	a0,0x13
    80002d6e:	a6650513          	addi	a0,a0,-1434 # 800157d0 <bcache>
    80002d72:	ec7fd0ef          	jal	80000c38 <acquire>
  b->refcnt--;
    80002d76:	40bc                	lw	a5,64(s1)
    80002d78:	37fd                	addiw	a5,a5,-1
    80002d7a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d7c:	00013517          	auipc	a0,0x13
    80002d80:	a5450513          	addi	a0,a0,-1452 # 800157d0 <bcache>
    80002d84:	f39fd0ef          	jal	80000cbc <release>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6105                	addi	sp,sp,32
    80002d90:	8082                	ret

0000000080002d92 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d92:	1101                	addi	sp,sp,-32
    80002d94:	ec06                	sd	ra,24(sp)
    80002d96:	e822                	sd	s0,16(sp)
    80002d98:	e426                	sd	s1,8(sp)
    80002d9a:	e04a                	sd	s2,0(sp)
    80002d9c:	1000                	addi	s0,sp,32
    80002d9e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002da0:	00d5d79b          	srliw	a5,a1,0xd
    80002da4:	0001b597          	auipc	a1,0x1b
    80002da8:	1085a583          	lw	a1,264(a1) # 8001deac <sb+0x1c>
    80002dac:	9dbd                	addw	a1,a1,a5
    80002dae:	df1ff0ef          	jal	80002b9e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002db2:	0074f713          	andi	a4,s1,7
    80002db6:	4785                	li	a5,1
    80002db8:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002dbc:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002dbe:	90d9                	srli	s1,s1,0x36
    80002dc0:	00950733          	add	a4,a0,s1
    80002dc4:	05874703          	lbu	a4,88(a4)
    80002dc8:	00e7f6b3          	and	a3,a5,a4
    80002dcc:	c29d                	beqz	a3,80002df2 <bfree+0x60>
    80002dce:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002dd0:	94aa                	add	s1,s1,a0
    80002dd2:	fff7c793          	not	a5,a5
    80002dd6:	8f7d                	and	a4,a4,a5
    80002dd8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002ddc:	092010ef          	jal	80003e6e <log_write>
  brelse(bp);
    80002de0:	854a                	mv	a0,s2
    80002de2:	ec5ff0ef          	jal	80002ca6 <brelse>
}
    80002de6:	60e2                	ld	ra,24(sp)
    80002de8:	6442                	ld	s0,16(sp)
    80002dea:	64a2                	ld	s1,8(sp)
    80002dec:	6902                	ld	s2,0(sp)
    80002dee:	6105                	addi	sp,sp,32
    80002df0:	8082                	ret
    panic("freeing free block");
    80002df2:	00004517          	auipc	a0,0x4
    80002df6:	5f650513          	addi	a0,a0,1526 # 800073e8 <etext+0x3e8>
    80002dfa:	a4ffd0ef          	jal	80000848 <panic>

0000000080002dfe <balloc>:
{
    80002dfe:	715d                	addi	sp,sp,-80
    80002e00:	e486                	sd	ra,72(sp)
    80002e02:	e0a2                	sd	s0,64(sp)
    80002e04:	fc26                	sd	s1,56(sp)
    80002e06:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002e08:	0001b797          	auipc	a5,0x1b
    80002e0c:	08c7a783          	lw	a5,140(a5) # 8001de94 <sb+0x4>
    80002e10:	0e078263          	beqz	a5,80002ef4 <balloc+0xf6>
    80002e14:	f84a                	sd	s2,48(sp)
    80002e16:	f44e                	sd	s3,40(sp)
    80002e18:	f052                	sd	s4,32(sp)
    80002e1a:	ec56                	sd	s5,24(sp)
    80002e1c:	e85a                	sd	s6,16(sp)
    80002e1e:	e45e                	sd	s7,8(sp)
    80002e20:	e062                	sd	s8,0(sp)
    80002e22:	8baa                	mv	s7,a0
    80002e24:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e26:	0001bb17          	auipc	s6,0x1b
    80002e2a:	06ab0b13          	addi	s6,s6,106 # 8001de90 <sb>
      m = 1 << (bi % 8);
    80002e2e:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e30:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002e32:	6c09                	lui	s8,0x2
    80002e34:	a09d                	j	80002e9a <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002e36:	97ca                	add	a5,a5,s2
    80002e38:	8e55                	or	a2,a2,a3
    80002e3a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e3e:	854a                	mv	a0,s2
    80002e40:	02e010ef          	jal	80003e6e <log_write>
        brelse(bp);
    80002e44:	854a                	mv	a0,s2
    80002e46:	e61ff0ef          	jal	80002ca6 <brelse>
  bp = bread(dev, bno);
    80002e4a:	85a6                	mv	a1,s1
    80002e4c:	855e                	mv	a0,s7
    80002e4e:	d51ff0ef          	jal	80002b9e <bread>
    80002e52:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e54:	40000613          	li	a2,1024
    80002e58:	4581                	li	a1,0
    80002e5a:	05850513          	addi	a0,a0,88
    80002e5e:	e97fd0ef          	jal	80000cf4 <memset>
  log_write(bp);
    80002e62:	854a                	mv	a0,s2
    80002e64:	00a010ef          	jal	80003e6e <log_write>
  brelse(bp);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	e3dff0ef          	jal	80002ca6 <brelse>
        return b + bi;
    80002e6e:	7942                	ld	s2,48(sp)
    80002e70:	79a2                	ld	s3,40(sp)
    80002e72:	7a02                	ld	s4,32(sp)
    80002e74:	6ae2                	ld	s5,24(sp)
    80002e76:	6b42                	ld	s6,16(sp)
    80002e78:	6ba2                	ld	s7,8(sp)
    80002e7a:	6c02                	ld	s8,0(sp)
}
    80002e7c:	8526                	mv	a0,s1
    80002e7e:	60a6                	ld	ra,72(sp)
    80002e80:	6406                	ld	s0,64(sp)
    80002e82:	74e2                	ld	s1,56(sp)
    80002e84:	6161                	addi	sp,sp,80
    80002e86:	8082                	ret
    brelse(bp);
    80002e88:	854a                	mv	a0,s2
    80002e8a:	e1dff0ef          	jal	80002ca6 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002e8e:	015c0abb          	addw	s5,s8,s5
    80002e92:	004b2783          	lw	a5,4(s6)
    80002e96:	04faf863          	bgeu	s5,a5,80002ee6 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002e9a:	40dad59b          	sraiw	a1,s5,0xd
    80002e9e:	01cb2783          	lw	a5,28(s6)
    80002ea2:	9dbd                	addw	a1,a1,a5
    80002ea4:	855e                	mv	a0,s7
    80002ea6:	cf9ff0ef          	jal	80002b9e <bread>
    80002eaa:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002eac:	004b2503          	lw	a0,4(s6)
    80002eb0:	84d6                	mv	s1,s5
    80002eb2:	4701                	li	a4,0
    80002eb4:	fca4fae3          	bgeu	s1,a0,80002e88 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002eb8:	00777693          	andi	a3,a4,7
    80002ebc:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002ec0:	41f7579b          	sraiw	a5,a4,0x1f
    80002ec4:	01d7d79b          	srliw	a5,a5,0x1d
    80002ec8:	9fb9                	addw	a5,a5,a4
    80002eca:	4037d79b          	sraiw	a5,a5,0x3
    80002ece:	00f90633          	add	a2,s2,a5
    80002ed2:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002ed6:	00c6f5b3          	and	a1,a3,a2
    80002eda:	ddb1                	beqz	a1,80002e36 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002edc:	2705                	addiw	a4,a4,1
    80002ede:	2485                	addiw	s1,s1,1
    80002ee0:	fd471ae3          	bne	a4,s4,80002eb4 <balloc+0xb6>
    80002ee4:	b755                	j	80002e88 <balloc+0x8a>
    80002ee6:	7942                	ld	s2,48(sp)
    80002ee8:	79a2                	ld	s3,40(sp)
    80002eea:	7a02                	ld	s4,32(sp)
    80002eec:	6ae2                	ld	s5,24(sp)
    80002eee:	6b42                	ld	s6,16(sp)
    80002ef0:	6ba2                	ld	s7,8(sp)
    80002ef2:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80002ef4:	00004517          	auipc	a0,0x4
    80002ef8:	50c50513          	addi	a0,a0,1292 # 80007400 <etext+0x400>
    80002efc:	e14fd0ef          	jal	80000510 <printk>
  return 0;
    80002f00:	4481                	li	s1,0
    80002f02:	bfad                	j	80002e7c <balloc+0x7e>

0000000080002f04 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f04:	7179                	addi	sp,sp,-48
    80002f06:	f406                	sd	ra,40(sp)
    80002f08:	f022                	sd	s0,32(sp)
    80002f0a:	ec26                	sd	s1,24(sp)
    80002f0c:	e84a                	sd	s2,16(sp)
    80002f0e:	e44e                	sd	s3,8(sp)
    80002f10:	1800                	addi	s0,sp,48
    80002f12:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002f14:	47ad                	li	a5,11
    80002f16:	02b7e363          	bltu	a5,a1,80002f3c <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80002f1a:	02059793          	slli	a5,a1,0x20
    80002f1e:	01e7d593          	srli	a1,a5,0x1e
    80002f22:	00b509b3          	add	s3,a0,a1
    80002f26:	0509a483          	lw	s1,80(s3)
    80002f2a:	e0b5                	bnez	s1,80002f8e <bmap+0x8a>
      addr = balloc(ip->dev);
    80002f2c:	4108                	lw	a0,0(a0)
    80002f2e:	ed1ff0ef          	jal	80002dfe <balloc>
    80002f32:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f34:	cd29                	beqz	a0,80002f8e <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002f36:	04a9a823          	sw	a0,80(s3)
    80002f3a:	a891                	j	80002f8e <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f3c:	ff45879b          	addiw	a5,a1,-12
    80002f40:	873e                	mv	a4,a5
    80002f42:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80002f44:	0ff00793          	li	a5,255
    80002f48:	06e7e763          	bltu	a5,a4,80002fb6 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002f4c:	08052483          	lw	s1,128(a0)
    80002f50:	e891                	bnez	s1,80002f64 <bmap+0x60>
      addr = balloc(ip->dev);
    80002f52:	4108                	lw	a0,0(a0)
    80002f54:	eabff0ef          	jal	80002dfe <balloc>
    80002f58:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f5a:	c915                	beqz	a0,80002f8e <bmap+0x8a>
    80002f5c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f5e:	08a92023          	sw	a0,128(s2)
    80002f62:	a011                	j	80002f66 <bmap+0x62>
    80002f64:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f66:	85a6                	mv	a1,s1
    80002f68:	00092503          	lw	a0,0(s2)
    80002f6c:	c33ff0ef          	jal	80002b9e <bread>
    80002f70:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002f72:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002f76:	02099713          	slli	a4,s3,0x20
    80002f7a:	01e75593          	srli	a1,a4,0x1e
    80002f7e:	97ae                	add	a5,a5,a1
    80002f80:	89be                	mv	s3,a5
    80002f82:	4384                	lw	s1,0(a5)
    80002f84:	cc89                	beqz	s1,80002f9e <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f86:	8552                	mv	a0,s4
    80002f88:	d1fff0ef          	jal	80002ca6 <brelse>
    return addr;
    80002f8c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f8e:	8526                	mv	a0,s1
    80002f90:	70a2                	ld	ra,40(sp)
    80002f92:	7402                	ld	s0,32(sp)
    80002f94:	64e2                	ld	s1,24(sp)
    80002f96:	6942                	ld	s2,16(sp)
    80002f98:	69a2                	ld	s3,8(sp)
    80002f9a:	6145                	addi	sp,sp,48
    80002f9c:	8082                	ret
      addr = balloc(ip->dev);
    80002f9e:	00092503          	lw	a0,0(s2)
    80002fa2:	e5dff0ef          	jal	80002dfe <balloc>
    80002fa6:	84aa                	mv	s1,a0
      if (addr) {
    80002fa8:	dd79                	beqz	a0,80002f86 <bmap+0x82>
        a[bn] = addr;
    80002faa:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002fae:	8552                	mv	a0,s4
    80002fb0:	6bf000ef          	jal	80003e6e <log_write>
    80002fb4:	bfc9                	j	80002f86 <bmap+0x82>
    80002fb6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002fb8:	00004517          	auipc	a0,0x4
    80002fbc:	46050513          	addi	a0,a0,1120 # 80007418 <etext+0x418>
    80002fc0:	889fd0ef          	jal	80000848 <panic>

0000000080002fc4 <iget>:
{
    80002fc4:	7179                	addi	sp,sp,-48
    80002fc6:	f406                	sd	ra,40(sp)
    80002fc8:	f022                	sd	s0,32(sp)
    80002fca:	ec26                	sd	s1,24(sp)
    80002fcc:	e84a                	sd	s2,16(sp)
    80002fce:	e44e                	sd	s3,8(sp)
    80002fd0:	e052                	sd	s4,0(sp)
    80002fd2:	1800                	addi	s0,sp,48
    80002fd4:	89aa                	mv	s3,a0
    80002fd6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fd8:	0001b517          	auipc	a0,0x1b
    80002fdc:	ed850513          	addi	a0,a0,-296 # 8001deb0 <itable>
    80002fe0:	c59fd0ef          	jal	80000c38 <acquire>
  empty = 0;
    80002fe4:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002fe6:	0001b497          	auipc	s1,0x1b
    80002fea:	ee248493          	addi	s1,s1,-286 # 8001dec8 <itable+0x18>
    80002fee:	0001d697          	auipc	a3,0x1d
    80002ff2:	96a68693          	addi	a3,a3,-1686 # 8001f958 <log>
    80002ff6:	a819                	j	8000300c <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002ff8:	0017b793          	seqz	a5,a5
    80002ffc:	00193713          	seqz	a4,s2
    80003000:	8ff9                	and	a5,a5,a4
    80003002:	eb85                	bnez	a5,80003032 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003004:	08848493          	addi	s1,s1,136
    80003008:	02d48763          	beq	s1,a3,80003036 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000300c:	449c                	lw	a5,8(s1)
    8000300e:	fef055e3          	blez	a5,80002ff8 <iget+0x34>
    80003012:	4098                	lw	a4,0(s1)
    80003014:	ff3718e3          	bne	a4,s3,80003004 <iget+0x40>
    80003018:	40d8                	lw	a4,4(s1)
    8000301a:	ff4715e3          	bne	a4,s4,80003004 <iget+0x40>
      ip->ref++;
    8000301e:	2785                	addiw	a5,a5,1
    80003020:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003022:	0001b517          	auipc	a0,0x1b
    80003026:	e8e50513          	addi	a0,a0,-370 # 8001deb0 <itable>
    8000302a:	c93fd0ef          	jal	80000cbc <release>
      return ip;
    8000302e:	8926                	mv	s2,s1
    80003030:	a025                	j	80003058 <iget+0x94>
      empty = ip;
    80003032:	8926                	mv	s2,s1
    80003034:	bfc1                	j	80003004 <iget+0x40>
  if (empty == 0)
    80003036:	02090a63          	beqz	s2,8000306a <iget+0xa6>
  ip->dev = dev;
    8000303a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000303e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003042:	4785                	li	a5,1
    80003044:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003048:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000304c:	0001b517          	auipc	a0,0x1b
    80003050:	e6450513          	addi	a0,a0,-412 # 8001deb0 <itable>
    80003054:	c69fd0ef          	jal	80000cbc <release>
}
    80003058:	854a                	mv	a0,s2
    8000305a:	70a2                	ld	ra,40(sp)
    8000305c:	7402                	ld	s0,32(sp)
    8000305e:	64e2                	ld	s1,24(sp)
    80003060:	6942                	ld	s2,16(sp)
    80003062:	69a2                	ld	s3,8(sp)
    80003064:	6a02                	ld	s4,0(sp)
    80003066:	6145                	addi	sp,sp,48
    80003068:	8082                	ret
    panic("iget: no inodes");
    8000306a:	00004517          	auipc	a0,0x4
    8000306e:	3c650513          	addi	a0,a0,966 # 80007430 <etext+0x430>
    80003072:	fd6fd0ef          	jal	80000848 <panic>

0000000080003076 <iinit>:
{
    80003076:	7179                	addi	sp,sp,-48
    80003078:	f406                	sd	ra,40(sp)
    8000307a:	f022                	sd	s0,32(sp)
    8000307c:	ec26                	sd	s1,24(sp)
    8000307e:	e84a                	sd	s2,16(sp)
    80003080:	e44e                	sd	s3,8(sp)
    80003082:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003084:	00004597          	auipc	a1,0x4
    80003088:	3bc58593          	addi	a1,a1,956 # 80007440 <etext+0x440>
    8000308c:	0001b517          	auipc	a0,0x1b
    80003090:	e2450513          	addi	a0,a0,-476 # 8001deb0 <itable>
    80003094:	b25fd0ef          	jal	80000bb8 <initlock>
  for (i = 0; i < NINODE; i++) {
    80003098:	0001b497          	auipc	s1,0x1b
    8000309c:	e4048493          	addi	s1,s1,-448 # 8001ded8 <itable+0x28>
    800030a0:	0001d997          	auipc	s3,0x1d
    800030a4:	8c898993          	addi	s3,s3,-1848 # 8001f968 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030a8:	00004917          	auipc	s2,0x4
    800030ac:	3a090913          	addi	s2,s2,928 # 80007448 <etext+0x448>
    800030b0:	85ca                	mv	a1,s2
    800030b2:	8526                	mv	a0,s1
    800030b4:	6ef000ef          	jal	80003fa2 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800030b8:	08848493          	addi	s1,s1,136
    800030bc:	ff349ae3          	bne	s1,s3,800030b0 <iinit+0x3a>
}
    800030c0:	70a2                	ld	ra,40(sp)
    800030c2:	7402                	ld	s0,32(sp)
    800030c4:	64e2                	ld	s1,24(sp)
    800030c6:	6942                	ld	s2,16(sp)
    800030c8:	69a2                	ld	s3,8(sp)
    800030ca:	6145                	addi	sp,sp,48
    800030cc:	8082                	ret

00000000800030ce <ialloc>:
{
    800030ce:	7139                	addi	sp,sp,-64
    800030d0:	fc06                	sd	ra,56(sp)
    800030d2:	f822                	sd	s0,48(sp)
    800030d4:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800030d6:	0001b717          	auipc	a4,0x1b
    800030da:	dc672703          	lw	a4,-570(a4) # 8001de9c <sb+0xc>
    800030de:	4785                	li	a5,1
    800030e0:	06e7f063          	bgeu	a5,a4,80003140 <ialloc+0x72>
    800030e4:	f426                	sd	s1,40(sp)
    800030e6:	f04a                	sd	s2,32(sp)
    800030e8:	ec4e                	sd	s3,24(sp)
    800030ea:	e852                	sd	s4,16(sp)
    800030ec:	e456                	sd	s5,8(sp)
    800030ee:	e05a                	sd	s6,0(sp)
    800030f0:	8aaa                	mv	s5,a0
    800030f2:	8b2e                	mv	s6,a1
    800030f4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800030f6:	0001ba17          	auipc	s4,0x1b
    800030fa:	d9aa0a13          	addi	s4,s4,-614 # 8001de90 <sb>
    800030fe:	00495593          	srli	a1,s2,0x4
    80003102:	018a2783          	lw	a5,24(s4)
    80003106:	9dbd                	addw	a1,a1,a5
    80003108:	8556                	mv	a0,s5
    8000310a:	a95ff0ef          	jal	80002b9e <bread>
    8000310e:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003110:	05850993          	addi	s3,a0,88
    80003114:	00f97793          	andi	a5,s2,15
    80003118:	079a                	slli	a5,a5,0x6
    8000311a:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000311c:	00099783          	lh	a5,0(s3)
    80003120:	cb9d                	beqz	a5,80003156 <ialloc+0x88>
    brelse(bp);
    80003122:	b85ff0ef          	jal	80002ca6 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003126:	0905                	addi	s2,s2,1
    80003128:	00ca2703          	lw	a4,12(s4)
    8000312c:	0009079b          	sext.w	a5,s2
    80003130:	fce7e7e3          	bltu	a5,a4,800030fe <ialloc+0x30>
    80003134:	74a2                	ld	s1,40(sp)
    80003136:	7902                	ld	s2,32(sp)
    80003138:	69e2                	ld	s3,24(sp)
    8000313a:	6a42                	ld	s4,16(sp)
    8000313c:	6aa2                	ld	s5,8(sp)
    8000313e:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003140:	00004517          	auipc	a0,0x4
    80003144:	31050513          	addi	a0,a0,784 # 80007450 <etext+0x450>
    80003148:	bc8fd0ef          	jal	80000510 <printk>
  return 0;
    8000314c:	4501                	li	a0,0
}
    8000314e:	70e2                	ld	ra,56(sp)
    80003150:	7442                	ld	s0,48(sp)
    80003152:	6121                	addi	sp,sp,64
    80003154:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003156:	04000613          	li	a2,64
    8000315a:	4581                	li	a1,0
    8000315c:	854e                	mv	a0,s3
    8000315e:	b97fd0ef          	jal	80000cf4 <memset>
      dip->type = type;
    80003162:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003166:	8526                	mv	a0,s1
    80003168:	507000ef          	jal	80003e6e <log_write>
      brelse(bp);
    8000316c:	8526                	mv	a0,s1
    8000316e:	b39ff0ef          	jal	80002ca6 <brelse>
      return iget(dev, inum);
    80003172:	0009059b          	sext.w	a1,s2
    80003176:	8556                	mv	a0,s5
    80003178:	e4dff0ef          	jal	80002fc4 <iget>
    8000317c:	74a2                	ld	s1,40(sp)
    8000317e:	7902                	ld	s2,32(sp)
    80003180:	69e2                	ld	s3,24(sp)
    80003182:	6a42                	ld	s4,16(sp)
    80003184:	6aa2                	ld	s5,8(sp)
    80003186:	6b02                	ld	s6,0(sp)
    80003188:	b7d9                	j	8000314e <ialloc+0x80>

000000008000318a <iupdate>:
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	e04a                	sd	s2,0(sp)
    80003194:	1000                	addi	s0,sp,32
    80003196:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003198:	415c                	lw	a5,4(a0)
    8000319a:	0047d79b          	srliw	a5,a5,0x4
    8000319e:	0001b597          	auipc	a1,0x1b
    800031a2:	d0a5a583          	lw	a1,-758(a1) # 8001dea8 <sb+0x18>
    800031a6:	9dbd                	addw	a1,a1,a5
    800031a8:	4108                	lw	a0,0(a0)
    800031aa:	9f5ff0ef          	jal	80002b9e <bread>
    800031ae:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800031b0:	05850793          	addi	a5,a0,88
    800031b4:	40d8                	lw	a4,4(s1)
    800031b6:	8b3d                	andi	a4,a4,15
    800031b8:	071a                	slli	a4,a4,0x6
    800031ba:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800031bc:	04449703          	lh	a4,68(s1)
    800031c0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031c4:	04649703          	lh	a4,70(s1)
    800031c8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031cc:	04849703          	lh	a4,72(s1)
    800031d0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031d4:	04a49703          	lh	a4,74(s1)
    800031d8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031dc:	44f8                	lw	a4,76(s1)
    800031de:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031e0:	03400613          	li	a2,52
    800031e4:	05048593          	addi	a1,s1,80
    800031e8:	00c78513          	addi	a0,a5,12
    800031ec:	b65fd0ef          	jal	80000d50 <memmove>
  log_write(bp);
    800031f0:	854a                	mv	a0,s2
    800031f2:	47d000ef          	jal	80003e6e <log_write>
  brelse(bp);
    800031f6:	854a                	mv	a0,s2
    800031f8:	aafff0ef          	jal	80002ca6 <brelse>
}
    800031fc:	60e2                	ld	ra,24(sp)
    800031fe:	6442                	ld	s0,16(sp)
    80003200:	64a2                	ld	s1,8(sp)
    80003202:	6902                	ld	s2,0(sp)
    80003204:	6105                	addi	sp,sp,32
    80003206:	8082                	ret

0000000080003208 <idup>:
{
    80003208:	1101                	addi	sp,sp,-32
    8000320a:	ec06                	sd	ra,24(sp)
    8000320c:	e822                	sd	s0,16(sp)
    8000320e:	e426                	sd	s1,8(sp)
    80003210:	1000                	addi	s0,sp,32
    80003212:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003214:	0001b517          	auipc	a0,0x1b
    80003218:	c9c50513          	addi	a0,a0,-868 # 8001deb0 <itable>
    8000321c:	a1dfd0ef          	jal	80000c38 <acquire>
  ip->ref++;
    80003220:	449c                	lw	a5,8(s1)
    80003222:	2785                	addiw	a5,a5,1
    80003224:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003226:	0001b517          	auipc	a0,0x1b
    8000322a:	c8a50513          	addi	a0,a0,-886 # 8001deb0 <itable>
    8000322e:	a8ffd0ef          	jal	80000cbc <release>
}
    80003232:	8526                	mv	a0,s1
    80003234:	60e2                	ld	ra,24(sp)
    80003236:	6442                	ld	s0,16(sp)
    80003238:	64a2                	ld	s1,8(sp)
    8000323a:	6105                	addi	sp,sp,32
    8000323c:	8082                	ret

000000008000323e <ilock>:
{
    8000323e:	1101                	addi	sp,sp,-32
    80003240:	ec06                	sd	ra,24(sp)
    80003242:	e822                	sd	s0,16(sp)
    80003244:	e426                	sd	s1,8(sp)
    80003246:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003248:	cd19                	beqz	a0,80003266 <ilock+0x28>
    8000324a:	84aa                	mv	s1,a0
    8000324c:	451c                	lw	a5,8(a0)
    8000324e:	00f05c63          	blez	a5,80003266 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003252:	0541                	addi	a0,a0,16
    80003254:	585000ef          	jal	80003fd8 <acquiresleep>
  if (ip->valid == 0) {
    80003258:	40bc                	lw	a5,64(s1)
    8000325a:	cf89                	beqz	a5,80003274 <ilock+0x36>
}
    8000325c:	60e2                	ld	ra,24(sp)
    8000325e:	6442                	ld	s0,16(sp)
    80003260:	64a2                	ld	s1,8(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret
    80003266:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003268:	00004517          	auipc	a0,0x4
    8000326c:	20050513          	addi	a0,a0,512 # 80007468 <etext+0x468>
    80003270:	dd8fd0ef          	jal	80000848 <panic>
    80003274:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003276:	40dc                	lw	a5,4(s1)
    80003278:	0047d79b          	srliw	a5,a5,0x4
    8000327c:	0001b597          	auipc	a1,0x1b
    80003280:	c2c5a583          	lw	a1,-980(a1) # 8001dea8 <sb+0x18>
    80003284:	9dbd                	addw	a1,a1,a5
    80003286:	4088                	lw	a0,0(s1)
    80003288:	917ff0ef          	jal	80002b9e <bread>
    8000328c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000328e:	05850593          	addi	a1,a0,88
    80003292:	40dc                	lw	a5,4(s1)
    80003294:	8bbd                	andi	a5,a5,15
    80003296:	079a                	slli	a5,a5,0x6
    80003298:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000329a:	00059783          	lh	a5,0(a1)
    8000329e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032a2:	00259783          	lh	a5,2(a1)
    800032a6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032aa:	00459783          	lh	a5,4(a1)
    800032ae:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032b2:	00659783          	lh	a5,6(a1)
    800032b6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032ba:	459c                	lw	a5,8(a1)
    800032bc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032be:	03400613          	li	a2,52
    800032c2:	05b1                	addi	a1,a1,12
    800032c4:	05048513          	addi	a0,s1,80
    800032c8:	a89fd0ef          	jal	80000d50 <memmove>
    brelse(bp);
    800032cc:	854a                	mv	a0,s2
    800032ce:	9d9ff0ef          	jal	80002ca6 <brelse>
    ip->valid = 1;
    800032d2:	4785                	li	a5,1
    800032d4:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800032d6:	04449783          	lh	a5,68(s1)
    800032da:	c399                	beqz	a5,800032e0 <ilock+0xa2>
    800032dc:	6902                	ld	s2,0(sp)
    800032de:	bfbd                	j	8000325c <ilock+0x1e>
      panic("ilock: no type");
    800032e0:	00004517          	auipc	a0,0x4
    800032e4:	19050513          	addi	a0,a0,400 # 80007470 <etext+0x470>
    800032e8:	d60fd0ef          	jal	80000848 <panic>

00000000800032ec <iunlock>:
{
    800032ec:	1101                	addi	sp,sp,-32
    800032ee:	ec06                	sd	ra,24(sp)
    800032f0:	e822                	sd	s0,16(sp)
    800032f2:	e426                	sd	s1,8(sp)
    800032f4:	e04a                	sd	s2,0(sp)
    800032f6:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032f8:	c505                	beqz	a0,80003320 <iunlock+0x34>
    800032fa:	84aa                	mv	s1,a0
    800032fc:	01050913          	addi	s2,a0,16
    80003300:	854a                	mv	a0,s2
    80003302:	563000ef          	jal	80004064 <holdingsleep>
    80003306:	cd09                	beqz	a0,80003320 <iunlock+0x34>
    80003308:	449c                	lw	a5,8(s1)
    8000330a:	00f05b63          	blez	a5,80003320 <iunlock+0x34>
  releasesleep(&ip->lock);
    8000330e:	854a                	mv	a0,s2
    80003310:	51d000ef          	jal	8000402c <releasesleep>
}
    80003314:	60e2                	ld	ra,24(sp)
    80003316:	6442                	ld	s0,16(sp)
    80003318:	64a2                	ld	s1,8(sp)
    8000331a:	6902                	ld	s2,0(sp)
    8000331c:	6105                	addi	sp,sp,32
    8000331e:	8082                	ret
    panic("iunlock");
    80003320:	00004517          	auipc	a0,0x4
    80003324:	16050513          	addi	a0,a0,352 # 80007480 <etext+0x480>
    80003328:	d20fd0ef          	jal	80000848 <panic>

000000008000332c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000332c:	7179                	addi	sp,sp,-48
    8000332e:	f406                	sd	ra,40(sp)
    80003330:	f022                	sd	s0,32(sp)
    80003332:	ec26                	sd	s1,24(sp)
    80003334:	e84a                	sd	s2,16(sp)
    80003336:	e44e                	sd	s3,8(sp)
    80003338:	1800                	addi	s0,sp,48
    8000333a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000333c:	05050493          	addi	s1,a0,80
    80003340:	08050913          	addi	s2,a0,128
    80003344:	a021                	j	8000334c <itrunc+0x20>
    80003346:	0491                	addi	s1,s1,4
    80003348:	01248b63          	beq	s1,s2,8000335e <itrunc+0x32>
    if (ip->addrs[i]) {
    8000334c:	408c                	lw	a1,0(s1)
    8000334e:	dde5                	beqz	a1,80003346 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003350:	0009a503          	lw	a0,0(s3)
    80003354:	a3fff0ef          	jal	80002d92 <bfree>
      ip->addrs[i] = 0;
    80003358:	0004a023          	sw	zero,0(s1)
    8000335c:	b7ed                	j	80003346 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    8000335e:	0809a583          	lw	a1,128(s3)
    80003362:	ed89                	bnez	a1,8000337c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003364:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003368:	854e                	mv	a0,s3
    8000336a:	e21ff0ef          	jal	8000318a <iupdate>
}
    8000336e:	70a2                	ld	ra,40(sp)
    80003370:	7402                	ld	s0,32(sp)
    80003372:	64e2                	ld	s1,24(sp)
    80003374:	6942                	ld	s2,16(sp)
    80003376:	69a2                	ld	s3,8(sp)
    80003378:	6145                	addi	sp,sp,48
    8000337a:	8082                	ret
    8000337c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000337e:	0009a503          	lw	a0,0(s3)
    80003382:	81dff0ef          	jal	80002b9e <bread>
    80003386:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003388:	05850493          	addi	s1,a0,88
    8000338c:	45850913          	addi	s2,a0,1112
    80003390:	a021                	j	80003398 <itrunc+0x6c>
    80003392:	0491                	addi	s1,s1,4
    80003394:	01248963          	beq	s1,s2,800033a6 <itrunc+0x7a>
      if (a[j])
    80003398:	408c                	lw	a1,0(s1)
    8000339a:	dde5                	beqz	a1,80003392 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000339c:	0009a503          	lw	a0,0(s3)
    800033a0:	9f3ff0ef          	jal	80002d92 <bfree>
    800033a4:	b7fd                	j	80003392 <itrunc+0x66>
    brelse(bp);
    800033a6:	8552                	mv	a0,s4
    800033a8:	8ffff0ef          	jal	80002ca6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033ac:	0809a583          	lw	a1,128(s3)
    800033b0:	0009a503          	lw	a0,0(s3)
    800033b4:	9dfff0ef          	jal	80002d92 <bfree>
    ip->addrs[NDIRECT] = 0;
    800033b8:	0809a023          	sw	zero,128(s3)
    800033bc:	6a02                	ld	s4,0(sp)
    800033be:	b75d                	j	80003364 <itrunc+0x38>

00000000800033c0 <iput>:
{
    800033c0:	7179                	addi	sp,sp,-48
    800033c2:	f406                	sd	ra,40(sp)
    800033c4:	f022                	sd	s0,32(sp)
    800033c6:	ec26                	sd	s1,24(sp)
    800033c8:	1800                	addi	s0,sp,48
    800033ca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033cc:	0001b517          	auipc	a0,0x1b
    800033d0:	ae450513          	addi	a0,a0,-1308 # 8001deb0 <itable>
    800033d4:	865fd0ef          	jal	80000c38 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800033d8:	449c                	lw	a5,8(s1)
    800033da:	4705                	li	a4,1
    800033dc:	00e78f63          	beq	a5,a4,800033fa <iput+0x3a>
  ip->ref--;
    800033e0:	37fd                	addiw	a5,a5,-1
    800033e2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033e4:	0001b517          	auipc	a0,0x1b
    800033e8:	acc50513          	addi	a0,a0,-1332 # 8001deb0 <itable>
    800033ec:	8d1fd0ef          	jal	80000cbc <release>
}
    800033f0:	70a2                	ld	ra,40(sp)
    800033f2:	7402                	ld	s0,32(sp)
    800033f4:	64e2                	ld	s1,24(sp)
    800033f6:	6145                	addi	sp,sp,48
    800033f8:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800033fa:	40b8                	lw	a4,64(s1)
    800033fc:	d375                	beqz	a4,800033e0 <iput+0x20>
    800033fe:	e84a                	sd	s2,16(sp)
    80003400:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003402:	0004aa03          	lw	s4,0(s1)
    80003406:	0044a903          	lw	s2,4(s1)
  if (last) {
    8000340a:	04a49703          	lh	a4,74(s1)
    8000340e:	ef3d                	bnez	a4,8000348c <iput+0xcc>
    80003410:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003412:	01048793          	addi	a5,s1,16
    80003416:	89be                	mv	s3,a5
    80003418:	853e                	mv	a0,a5
    8000341a:	3bf000ef          	jal	80003fd8 <acquiresleep>
    release(&itable.lock);
    8000341e:	0001b517          	auipc	a0,0x1b
    80003422:	a9250513          	addi	a0,a0,-1390 # 8001deb0 <itable>
    80003426:	897fd0ef          	jal	80000cbc <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    8000342a:	8526                	mv	a0,s1
    8000342c:	f01ff0ef          	jal	8000332c <itrunc>
    ip->valid = 0;
    80003430:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003434:	854e                	mv	a0,s3
    80003436:	3f7000ef          	jal	8000402c <releasesleep>
    acquire(&itable.lock);
    8000343a:	0001b517          	auipc	a0,0x1b
    8000343e:	a7650513          	addi	a0,a0,-1418 # 8001deb0 <itable>
    80003442:	ff6fd0ef          	jal	80000c38 <acquire>
  ip->ref--;
    80003446:	449c                	lw	a5,8(s1)
    80003448:	37fd                	addiw	a5,a5,-1
    8000344a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000344c:	0001b517          	auipc	a0,0x1b
    80003450:	a6450513          	addi	a0,a0,-1436 # 8001deb0 <itable>
    80003454:	869fd0ef          	jal	80000cbc <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003458:	0049579b          	srliw	a5,s2,0x4
    8000345c:	0001b597          	auipc	a1,0x1b
    80003460:	a4c5a583          	lw	a1,-1460(a1) # 8001dea8 <sb+0x18>
    80003464:	9dbd                	addw	a1,a1,a5
    80003466:	8552                	mv	a0,s4
    80003468:	f36ff0ef          	jal	80002b9e <bread>
    8000346c:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000346e:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    80003472:	079a                	slli	a5,a5,0x6
    80003474:	97aa                	add	a5,a5,a0
    80003476:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    8000347a:	1f5000ef          	jal	80003e6e <log_write>
  brelse(bp);
    8000347e:	8526                	mv	a0,s1
    80003480:	827ff0ef          	jal	80002ca6 <brelse>
}
    80003484:	6942                	ld	s2,16(sp)
    80003486:	69a2                	ld	s3,8(sp)
    80003488:	6a02                	ld	s4,0(sp)
    8000348a:	b79d                	j	800033f0 <iput+0x30>
    8000348c:	6942                	ld	s2,16(sp)
    8000348e:	6a02                	ld	s4,0(sp)
    80003490:	bf81                	j	800033e0 <iput+0x20>

0000000080003492 <iunlockput>:
{
    80003492:	1101                	addi	sp,sp,-32
    80003494:	ec06                	sd	ra,24(sp)
    80003496:	e822                	sd	s0,16(sp)
    80003498:	e426                	sd	s1,8(sp)
    8000349a:	1000                	addi	s0,sp,32
    8000349c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000349e:	e4fff0ef          	jal	800032ec <iunlock>
  iput(ip);
    800034a2:	8526                	mv	a0,s1
    800034a4:	f1dff0ef          	jal	800033c0 <iput>
}
    800034a8:	60e2                	ld	ra,24(sp)
    800034aa:	6442                	ld	s0,16(sp)
    800034ac:	64a2                	ld	s1,8(sp)
    800034ae:	6105                	addi	sp,sp,32
    800034b0:	8082                	ret

00000000800034b2 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034b2:	0001b717          	auipc	a4,0x1b
    800034b6:	9ea72703          	lw	a4,-1558(a4) # 8001de9c <sb+0xc>
    800034ba:	4785                	li	a5,1
    800034bc:	0ae7fe63          	bgeu	a5,a4,80003578 <ireclaim+0xc6>
{
    800034c0:	7139                	addi	sp,sp,-64
    800034c2:	fc06                	sd	ra,56(sp)
    800034c4:	f822                	sd	s0,48(sp)
    800034c6:	f426                	sd	s1,40(sp)
    800034c8:	f04a                	sd	s2,32(sp)
    800034ca:	ec4e                	sd	s3,24(sp)
    800034cc:	e852                	sd	s4,16(sp)
    800034ce:	e456                	sd	s5,8(sp)
    800034d0:	e05a                	sd	s6,0(sp)
    800034d2:	0080                	addi	s0,sp,64
    800034d4:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034d6:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034d8:	0001ba17          	auipc	s4,0x1b
    800034dc:	9b8a0a13          	addi	s4,s4,-1608 # 8001de90 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800034e0:	00004b17          	auipc	s6,0x4
    800034e4:	fa8b0b13          	addi	s6,s6,-88 # 80007488 <etext+0x488>
    800034e8:	a099                	j	8000352e <ireclaim+0x7c>
    800034ea:	85ce                	mv	a1,s3
    800034ec:	855a                	mv	a0,s6
    800034ee:	822fd0ef          	jal	80000510 <printk>
      ip = iget(dev, inum);
    800034f2:	85ce                	mv	a1,s3
    800034f4:	8556                	mv	a0,s5
    800034f6:	acfff0ef          	jal	80002fc4 <iget>
    800034fa:	89aa                	mv	s3,a0
    brelse(bp);
    800034fc:	854a                	mv	a0,s2
    800034fe:	fa8ff0ef          	jal	80002ca6 <brelse>
    if (ip) {
    80003502:	00098f63          	beqz	s3,80003520 <ireclaim+0x6e>
      begin_op();
    80003506:	7ba000ef          	jal	80003cc0 <begin_op>
      ilock(ip);
    8000350a:	854e                	mv	a0,s3
    8000350c:	d33ff0ef          	jal	8000323e <ilock>
      iunlock(ip);
    80003510:	854e                	mv	a0,s3
    80003512:	ddbff0ef          	jal	800032ec <iunlock>
      iput(ip);
    80003516:	854e                	mv	a0,s3
    80003518:	ea9ff0ef          	jal	800033c0 <iput>
      end_op();
    8000351c:	031000ef          	jal	80003d4c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003520:	0485                	addi	s1,s1,1
    80003522:	00ca2703          	lw	a4,12(s4)
    80003526:	0004879b          	sext.w	a5,s1
    8000352a:	02e7fd63          	bgeu	a5,a4,80003564 <ireclaim+0xb2>
    8000352e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003532:	0044d593          	srli	a1,s1,0x4
    80003536:	018a2783          	lw	a5,24(s4)
    8000353a:	9dbd                	addw	a1,a1,a5
    8000353c:	8556                	mv	a0,s5
    8000353e:	e60ff0ef          	jal	80002b9e <bread>
    80003542:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003544:	05850793          	addi	a5,a0,88
    80003548:	00f9f713          	andi	a4,s3,15
    8000354c:	071a                	slli	a4,a4,0x6
    8000354e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80003550:	00079703          	lh	a4,0(a5)
    80003554:	c701                	beqz	a4,8000355c <ireclaim+0xaa>
    80003556:	00679783          	lh	a5,6(a5)
    8000355a:	dbc1                	beqz	a5,800034ea <ireclaim+0x38>
    brelse(bp);
    8000355c:	854a                	mv	a0,s2
    8000355e:	f48ff0ef          	jal	80002ca6 <brelse>
    if (ip) {
    80003562:	bf7d                	j	80003520 <ireclaim+0x6e>
}
    80003564:	70e2                	ld	ra,56(sp)
    80003566:	7442                	ld	s0,48(sp)
    80003568:	74a2                	ld	s1,40(sp)
    8000356a:	7902                	ld	s2,32(sp)
    8000356c:	69e2                	ld	s3,24(sp)
    8000356e:	6a42                	ld	s4,16(sp)
    80003570:	6aa2                	ld	s5,8(sp)
    80003572:	6b02                	ld	s6,0(sp)
    80003574:	6121                	addi	sp,sp,64
    80003576:	8082                	ret
    80003578:	8082                	ret

000000008000357a <fsinit>:
{
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	e04a                	sd	s2,0(sp)
    80003584:	1000                	addi	s0,sp,32
    80003586:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003588:	4585                	li	a1,1
    8000358a:	e14ff0ef          	jal	80002b9e <bread>
    8000358e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003590:	02000613          	li	a2,32
    80003594:	05850593          	addi	a1,a0,88
    80003598:	0001b517          	auipc	a0,0x1b
    8000359c:	8f850513          	addi	a0,a0,-1800 # 8001de90 <sb>
    800035a0:	fb0fd0ef          	jal	80000d50 <memmove>
  brelse(bp);
    800035a4:	8526                	mv	a0,s1
    800035a6:	f00ff0ef          	jal	80002ca6 <brelse>
  if (sb.magic != FSMAGIC)
    800035aa:	0001b717          	auipc	a4,0x1b
    800035ae:	8e672703          	lw	a4,-1818(a4) # 8001de90 <sb>
    800035b2:	102037b7          	lui	a5,0x10203
    800035b6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035ba:	02f71263          	bne	a4,a5,800035de <fsinit+0x64>
  initlog(dev, &sb);
    800035be:	0001b597          	auipc	a1,0x1b
    800035c2:	8d258593          	addi	a1,a1,-1838 # 8001de90 <sb>
    800035c6:	854a                	mv	a0,s2
    800035c8:	676000ef          	jal	80003c3e <initlog>
  ireclaim(dev);
    800035cc:	854a                	mv	a0,s2
    800035ce:	ee5ff0ef          	jal	800034b2 <ireclaim>
}
    800035d2:	60e2                	ld	ra,24(sp)
    800035d4:	6442                	ld	s0,16(sp)
    800035d6:	64a2                	ld	s1,8(sp)
    800035d8:	6902                	ld	s2,0(sp)
    800035da:	6105                	addi	sp,sp,32
    800035dc:	8082                	ret
    panic("invalid file system");
    800035de:	00004517          	auipc	a0,0x4
    800035e2:	eca50513          	addi	a0,a0,-310 # 800074a8 <etext+0x4a8>
    800035e6:	a62fd0ef          	jal	80000848 <panic>

00000000800035ea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035ea:	1141                	addi	sp,sp,-16
    800035ec:	e406                	sd	ra,8(sp)
    800035ee:	e022                	sd	s0,0(sp)
    800035f0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035f2:	411c                	lw	a5,0(a0)
    800035f4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035f6:	415c                	lw	a5,4(a0)
    800035f8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035fa:	04451783          	lh	a5,68(a0)
    800035fe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003602:	04a51783          	lh	a5,74(a0)
    80003606:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000360a:	04c56783          	lwu	a5,76(a0)
    8000360e:	e99c                	sd	a5,16(a1)
}
    80003610:	60a2                	ld	ra,8(sp)
    80003612:	6402                	ld	s0,0(sp)
    80003614:	0141                	addi	sp,sp,16
    80003616:	8082                	ret

0000000080003618 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003618:	457c                	lw	a5,76(a0)
    8000361a:	0ed7e663          	bltu	a5,a3,80003706 <readi+0xee>
{
    8000361e:	7159                	addi	sp,sp,-112
    80003620:	f486                	sd	ra,104(sp)
    80003622:	f0a2                	sd	s0,96(sp)
    80003624:	eca6                	sd	s1,88(sp)
    80003626:	e0d2                	sd	s4,64(sp)
    80003628:	fc56                	sd	s5,56(sp)
    8000362a:	f85a                	sd	s6,48(sp)
    8000362c:	f45e                	sd	s7,40(sp)
    8000362e:	1880                	addi	s0,sp,112
    80003630:	8b2a                	mv	s6,a0
    80003632:	8bae                	mv	s7,a1
    80003634:	8a32                	mv	s4,a2
    80003636:	84b6                	mv	s1,a3
    80003638:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000363a:	9f35                	addw	a4,a4,a3
    return 0;
    8000363c:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    8000363e:	0ad76b63          	bltu	a4,a3,800036f4 <readi+0xdc>
    80003642:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003644:	00e7f463          	bgeu	a5,a4,8000364c <readi+0x34>
    n = ip->size - off;
    80003648:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000364c:	080a8b63          	beqz	s5,800036e2 <readi+0xca>
    80003650:	e8ca                	sd	s2,80(sp)
    80003652:	f062                	sd	s8,32(sp)
    80003654:	ec66                	sd	s9,24(sp)
    80003656:	e86a                	sd	s10,16(sp)
    80003658:	e46e                	sd	s11,8(sp)
    8000365a:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000365c:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003660:	5c7d                	li	s8,-1
    80003662:	a80d                	j	80003694 <readi+0x7c>
    80003664:	020d1d93          	slli	s11,s10,0x20
    80003668:	020ddd93          	srli	s11,s11,0x20
    8000366c:	05890613          	addi	a2,s2,88
    80003670:	86ee                	mv	a3,s11
    80003672:	963e                	add	a2,a2,a5
    80003674:	85d2                	mv	a1,s4
    80003676:	855e                	mv	a0,s7
    80003678:	c2ffe0ef          	jal	800022a6 <either_copyout>
    8000367c:	05850363          	beq	a0,s8,800036c2 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003680:	854a                	mv	a0,s2
    80003682:	e24ff0ef          	jal	80002ca6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003686:	013d09bb          	addw	s3,s10,s3
    8000368a:	009d04bb          	addw	s1,s10,s1
    8000368e:	9a6e                	add	s4,s4,s11
    80003690:	0559f363          	bgeu	s3,s5,800036d6 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003694:	00a4d59b          	srliw	a1,s1,0xa
    80003698:	855a                	mv	a0,s6
    8000369a:	86bff0ef          	jal	80002f04 <bmap>
    8000369e:	85aa                	mv	a1,a0
    if (addr == 0)
    800036a0:	c139                	beqz	a0,800036e6 <readi+0xce>
    bp = bread(ip->dev, addr);
    800036a2:	000b2503          	lw	a0,0(s6)
    800036a6:	cf8ff0ef          	jal	80002b9e <bread>
    800036aa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800036ac:	3ff4f793          	andi	a5,s1,1023
    800036b0:	40fc873b          	subw	a4,s9,a5
    800036b4:	413a86bb          	subw	a3,s5,s3
    800036b8:	8d3a                	mv	s10,a4
    800036ba:	fae6f5e3          	bgeu	a3,a4,80003664 <readi+0x4c>
    800036be:	8d36                	mv	s10,a3
    800036c0:	b755                	j	80003664 <readi+0x4c>
      brelse(bp);
    800036c2:	854a                	mv	a0,s2
    800036c4:	de2ff0ef          	jal	80002ca6 <brelse>
      tot = -1;
    800036c8:	59fd                	li	s3,-1
      break;
    800036ca:	6946                	ld	s2,80(sp)
    800036cc:	7c02                	ld	s8,32(sp)
    800036ce:	6ce2                	ld	s9,24(sp)
    800036d0:	6d42                	ld	s10,16(sp)
    800036d2:	6da2                	ld	s11,8(sp)
    800036d4:	a831                	j	800036f0 <readi+0xd8>
    800036d6:	6946                	ld	s2,80(sp)
    800036d8:	7c02                	ld	s8,32(sp)
    800036da:	6ce2                	ld	s9,24(sp)
    800036dc:	6d42                	ld	s10,16(sp)
    800036de:	6da2                	ld	s11,8(sp)
    800036e0:	a801                	j	800036f0 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800036e2:	89d6                	mv	s3,s5
    800036e4:	a031                	j	800036f0 <readi+0xd8>
    800036e6:	6946                	ld	s2,80(sp)
    800036e8:	7c02                	ld	s8,32(sp)
    800036ea:	6ce2                	ld	s9,24(sp)
    800036ec:	6d42                	ld	s10,16(sp)
    800036ee:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800036f0:	854e                	mv	a0,s3
    800036f2:	69a6                	ld	s3,72(sp)
}
    800036f4:	70a6                	ld	ra,104(sp)
    800036f6:	7406                	ld	s0,96(sp)
    800036f8:	64e6                	ld	s1,88(sp)
    800036fa:	6a06                	ld	s4,64(sp)
    800036fc:	7ae2                	ld	s5,56(sp)
    800036fe:	7b42                	ld	s6,48(sp)
    80003700:	7ba2                	ld	s7,40(sp)
    80003702:	6165                	addi	sp,sp,112
    80003704:	8082                	ret
    return 0;
    80003706:	4501                	li	a0,0
}
    80003708:	8082                	ret

000000008000370a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000370a:	457c                	lw	a5,76(a0)
    8000370c:	10d7e163          	bltu	a5,a3,8000380e <writei+0x104>
{
    80003710:	7159                	addi	sp,sp,-112
    80003712:	f486                	sd	ra,104(sp)
    80003714:	f0a2                	sd	s0,96(sp)
    80003716:	e8ca                	sd	s2,80(sp)
    80003718:	e0d2                	sd	s4,64(sp)
    8000371a:	fc56                	sd	s5,56(sp)
    8000371c:	f85a                	sd	s6,48(sp)
    8000371e:	f45e                	sd	s7,40(sp)
    80003720:	1880                	addi	s0,sp,112
    80003722:	8aaa                	mv	s5,a0
    80003724:	8bae                	mv	s7,a1
    80003726:	8a32                	mv	s4,a2
    80003728:	8936                	mv	s2,a3
    8000372a:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000372c:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000372e:	000437b7          	lui	a5,0x43
    80003732:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    80003736:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    8000373a:	8fd9                	or	a5,a5,a4
    8000373c:	ef91                	bnez	a5,80003758 <writei+0x4e>
    8000373e:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003740:	0a0b0f63          	beqz	s6,800037fe <writei+0xf4>
    80003744:	eca6                	sd	s1,88(sp)
    80003746:	f062                	sd	s8,32(sp)
    80003748:	ec66                	sd	s9,24(sp)
    8000374a:	e86a                	sd	s10,16(sp)
    8000374c:	e46e                	sd	s11,8(sp)
    8000374e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003750:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003754:	5c7d                	li	s8,-1
    80003756:	a835                	j	80003792 <writei+0x88>
    return -1;
    80003758:	557d                	li	a0,-1
    8000375a:	a849                	j	800037ec <writei+0xe2>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000375c:	020d1d93          	slli	s11,s10,0x20
    80003760:	020ddd93          	srli	s11,s11,0x20
    80003764:	05848513          	addi	a0,s1,88
    80003768:	86ee                	mv	a3,s11
    8000376a:	8652                	mv	a2,s4
    8000376c:	85de                	mv	a1,s7
    8000376e:	953e                	add	a0,a0,a5
    80003770:	b83fe0ef          	jal	800022f2 <either_copyin>
    80003774:	05850663          	beq	a0,s8,800037c0 <writei+0xb6>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003778:	8526                	mv	a0,s1
    8000377a:	6f4000ef          	jal	80003e6e <log_write>
    brelse(bp);
    8000377e:	8526                	mv	a0,s1
    80003780:	d26ff0ef          	jal	80002ca6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003784:	013d09bb          	addw	s3,s10,s3
    80003788:	012d093b          	addw	s2,s10,s2
    8000378c:	9a6e                	add	s4,s4,s11
    8000378e:	0369ff63          	bgeu	s3,s6,800037cc <writei+0xc2>
    uint addr = bmap(ip, off / BSIZE);
    80003792:	00a9559b          	srliw	a1,s2,0xa
    80003796:	8556                	mv	a0,s5
    80003798:	f6cff0ef          	jal	80002f04 <bmap>
    8000379c:	85aa                	mv	a1,a0
    if (addr == 0)
    8000379e:	c51d                	beqz	a0,800037cc <writei+0xc2>
    bp = bread(ip->dev, addr);
    800037a0:	000aa503          	lw	a0,0(s5)
    800037a4:	bfaff0ef          	jal	80002b9e <bread>
    800037a8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800037aa:	3ff97793          	andi	a5,s2,1023
    800037ae:	40fc873b          	subw	a4,s9,a5
    800037b2:	413b06bb          	subw	a3,s6,s3
    800037b6:	8d3a                	mv	s10,a4
    800037b8:	fae6f2e3          	bgeu	a3,a4,8000375c <writei+0x52>
    800037bc:	8d36                	mv	s10,a3
    800037be:	bf79                	j	8000375c <writei+0x52>
      log_write(bp);
    800037c0:	8526                	mv	a0,s1
    800037c2:	6ac000ef          	jal	80003e6e <log_write>
      brelse(bp);
    800037c6:	8526                	mv	a0,s1
    800037c8:	cdeff0ef          	jal	80002ca6 <brelse>
  }

  if (off > ip->size)
    800037cc:	04caa783          	lw	a5,76(s5)
    800037d0:	0327f963          	bgeu	a5,s2,80003802 <writei+0xf8>
    ip->size = off;
    800037d4:	052aa623          	sw	s2,76(s5)
    800037d8:	64e6                	ld	s1,88(sp)
    800037da:	7c02                	ld	s8,32(sp)
    800037dc:	6ce2                	ld	s9,24(sp)
    800037de:	6d42                	ld	s10,16(sp)
    800037e0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800037e2:	8556                	mv	a0,s5
    800037e4:	9a7ff0ef          	jal	8000318a <iupdate>

  return tot;
    800037e8:	854e                	mv	a0,s3
    800037ea:	69a6                	ld	s3,72(sp)
}
    800037ec:	70a6                	ld	ra,104(sp)
    800037ee:	7406                	ld	s0,96(sp)
    800037f0:	6946                	ld	s2,80(sp)
    800037f2:	6a06                	ld	s4,64(sp)
    800037f4:	7ae2                	ld	s5,56(sp)
    800037f6:	7b42                	ld	s6,48(sp)
    800037f8:	7ba2                	ld	s7,40(sp)
    800037fa:	6165                	addi	sp,sp,112
    800037fc:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037fe:	89da                	mv	s3,s6
    80003800:	b7cd                	j	800037e2 <writei+0xd8>
    80003802:	64e6                	ld	s1,88(sp)
    80003804:	7c02                	ld	s8,32(sp)
    80003806:	6ce2                	ld	s9,24(sp)
    80003808:	6d42                	ld	s10,16(sp)
    8000380a:	6da2                	ld	s11,8(sp)
    8000380c:	bfd9                	j	800037e2 <writei+0xd8>
    return -1;
    8000380e:	557d                	li	a0,-1
}
    80003810:	8082                	ret

0000000080003812 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003812:	1141                	addi	sp,sp,-16
    80003814:	e406                	sd	ra,8(sp)
    80003816:	e022                	sd	s0,0(sp)
    80003818:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000381a:	4639                	li	a2,14
    8000381c:	da8fd0ef          	jal	80000dc4 <strncmp>
}
    80003820:	60a2                	ld	ra,8(sp)
    80003822:	6402                	ld	s0,0(sp)
    80003824:	0141                	addi	sp,sp,16
    80003826:	8082                	ret

0000000080003828 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003828:	711d                	addi	sp,sp,-96
    8000382a:	ec86                	sd	ra,88(sp)
    8000382c:	e8a2                	sd	s0,80(sp)
    8000382e:	e4a6                	sd	s1,72(sp)
    80003830:	e0ca                	sd	s2,64(sp)
    80003832:	fc4e                	sd	s3,56(sp)
    80003834:	f852                	sd	s4,48(sp)
    80003836:	f456                	sd	s5,40(sp)
    80003838:	f05a                	sd	s6,32(sp)
    8000383a:	ec5e                	sd	s7,24(sp)
    8000383c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    8000383e:	04451703          	lh	a4,68(a0)
    80003842:	4785                	li	a5,1
    80003844:	02f71963          	bne	a4,a5,80003876 <dirlookup+0x4e>
    80003848:	892a                	mv	s2,a0
    8000384a:	8aae                	mv	s5,a1
    8000384c:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000384e:	457c                	lw	a5,76(a0)
    80003850:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003852:	fa040a13          	addi	s4,s0,-96
    80003856:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003858:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000385c:	ef95                	bnez	a5,80003898 <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000385e:	4501                	li	a0,0
}
    80003860:	60e6                	ld	ra,88(sp)
    80003862:	6446                	ld	s0,80(sp)
    80003864:	64a6                	ld	s1,72(sp)
    80003866:	6906                	ld	s2,64(sp)
    80003868:	79e2                	ld	s3,56(sp)
    8000386a:	7a42                	ld	s4,48(sp)
    8000386c:	7aa2                	ld	s5,40(sp)
    8000386e:	7b02                	ld	s6,32(sp)
    80003870:	6be2                	ld	s7,24(sp)
    80003872:	6125                	addi	sp,sp,96
    80003874:	8082                	ret
    panic("dirlookup not DIR");
    80003876:	00004517          	auipc	a0,0x4
    8000387a:	c4a50513          	addi	a0,a0,-950 # 800074c0 <etext+0x4c0>
    8000387e:	fcbfc0ef          	jal	80000848 <panic>
      panic("dirlookup read");
    80003882:	00004517          	auipc	a0,0x4
    80003886:	c5650513          	addi	a0,a0,-938 # 800074d8 <etext+0x4d8>
    8000388a:	fbffc0ef          	jal	80000848 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000388e:	24c1                	addiw	s1,s1,16
    80003890:	04c92783          	lw	a5,76(s2)
    80003894:	fcf4f5e3          	bgeu	s1,a5,8000385e <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003898:	874e                	mv	a4,s3
    8000389a:	86a6                	mv	a3,s1
    8000389c:	8652                	mv	a2,s4
    8000389e:	4581                	li	a1,0
    800038a0:	854a                	mv	a0,s2
    800038a2:	d77ff0ef          	jal	80003618 <readi>
    800038a6:	fd351ee3          	bne	a0,s3,80003882 <dirlookup+0x5a>
    if (de.inum == 0)
    800038aa:	fa045783          	lhu	a5,-96(s0)
    800038ae:	d3e5                	beqz	a5,8000388e <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    800038b0:	85da                	mv	a1,s6
    800038b2:	8556                	mv	a0,s5
    800038b4:	f5fff0ef          	jal	80003812 <namecmp>
    800038b8:	f979                	bnez	a0,8000388e <dirlookup+0x66>
      if (poff)
    800038ba:	000b8463          	beqz	s7,800038c2 <dirlookup+0x9a>
        *poff = off;
    800038be:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800038c2:	fa045583          	lhu	a1,-96(s0)
    800038c6:	00092503          	lw	a0,0(s2)
    800038ca:	efaff0ef          	jal	80002fc4 <iget>
    800038ce:	bf49                	j	80003860 <dirlookup+0x38>

00000000800038d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800038d0:	711d                	addi	sp,sp,-96
    800038d2:	ec86                	sd	ra,88(sp)
    800038d4:	e8a2                	sd	s0,80(sp)
    800038d6:	e4a6                	sd	s1,72(sp)
    800038d8:	e0ca                	sd	s2,64(sp)
    800038da:	fc4e                	sd	s3,56(sp)
    800038dc:	f852                	sd	s4,48(sp)
    800038de:	f456                	sd	s5,40(sp)
    800038e0:	f05a                	sd	s6,32(sp)
    800038e2:	ec5e                	sd	s7,24(sp)
    800038e4:	e862                	sd	s8,16(sp)
    800038e6:	e466                	sd	s9,8(sp)
    800038e8:	e06a                	sd	s10,0(sp)
    800038ea:	1080                	addi	s0,sp,96
    800038ec:	84aa                	mv	s1,a0
    800038ee:	8b2e                	mv	s6,a1
    800038f0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800038f2:	00054703          	lbu	a4,0(a0)
    800038f6:	02f00793          	li	a5,47
    800038fa:	00f70f63          	beq	a4,a5,80003918 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038fe:	824fe0ef          	jal	80001922 <myproc>
    80003902:	15053503          	ld	a0,336(a0)
    80003906:	903ff0ef          	jal	80003208 <idup>
    8000390a:	8a2a                	mv	s4,a0
  while (*path == '/')
    8000390c:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003910:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003912:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003914:	4b85                	li	s7,1
    80003916:	a075                	j	800039c2 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
    80003918:	4585                	li	a1,1
    8000391a:	852e                	mv	a0,a1
    8000391c:	ea8ff0ef          	jal	80002fc4 <iget>
    80003920:	8a2a                	mv	s4,a0
    80003922:	b7ed                	j	8000390c <namex+0x3c>
      iunlockput(ip);
    80003924:	8552                	mv	a0,s4
    80003926:	b6dff0ef          	jal	80003492 <iunlockput>
      return 0;
    8000392a:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000392c:	8552                	mv	a0,s4
    8000392e:	60e6                	ld	ra,88(sp)
    80003930:	6446                	ld	s0,80(sp)
    80003932:	64a6                	ld	s1,72(sp)
    80003934:	6906                	ld	s2,64(sp)
    80003936:	79e2                	ld	s3,56(sp)
    80003938:	7a42                	ld	s4,48(sp)
    8000393a:	7aa2                	ld	s5,40(sp)
    8000393c:	7b02                	ld	s6,32(sp)
    8000393e:	6be2                	ld	s7,24(sp)
    80003940:	6c42                	ld	s8,16(sp)
    80003942:	6ca2                	ld	s9,8(sp)
    80003944:	6d02                	ld	s10,0(sp)
    80003946:	6125                	addi	sp,sp,96
    80003948:	8082                	ret
      iunlockput(ip);
    8000394a:	8552                	mv	a0,s4
    8000394c:	b47ff0ef          	jal	80003492 <iunlockput>
      return 0;
    80003950:	bfe9                	j	8000392a <namex+0x5a>
      iunlock(ip);
    80003952:	8552                	mv	a0,s4
    80003954:	999ff0ef          	jal	800032ec <iunlock>
      return ip;
    80003958:	bfd1                	j	8000392c <namex+0x5c>
      iunlockput(ip);
    8000395a:	8552                	mv	a0,s4
    8000395c:	b37ff0ef          	jal	80003492 <iunlockput>
      return 0;
    80003960:	8a4a                	mv	s4,s2
    80003962:	b7e9                	j	8000392c <namex+0x5c>
  while (*path != '/' && *path != 0)
    80003964:	8926                	mv	s2,s1
  len = path - s;
    80003966:	4d01                	li	s10,0
    80003968:	4601                	li	a2,0
    memmove(name, s, len);
    8000396a:	2601                	sext.w	a2,a2
    8000396c:	85a6                	mv	a1,s1
    8000396e:	8556                	mv	a0,s5
    80003970:	be0fd0ef          	jal	80000d50 <memmove>
    name[len] = 0;
    80003974:	9d56                	add	s10,s10,s5
    80003976:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde468>
  while (*path == '/')
    8000397a:	00094783          	lbu	a5,0(s2)
    8000397e:	0b379363          	bne	a5,s3,80003a24 <namex+0x154>
    80003982:	84ca                	mv	s1,s2
    path++;
    80003984:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003986:	0004c783          	lbu	a5,0(s1)
    8000398a:	ff378de3          	beq	a5,s3,80003984 <namex+0xb4>
    ilock(ip);
    8000398e:	8552                	mv	a0,s4
    80003990:	8afff0ef          	jal	8000323e <ilock>
    if (ip->type != T_DIR) {
    80003994:	044a1783          	lh	a5,68(s4)
    80003998:	f97796e3          	bne	a5,s7,80003924 <namex+0x54>
    if (ip->nlink == 0) {
    8000399c:	04aa1783          	lh	a5,74(s4)
    800039a0:	d7cd                	beqz	a5,8000394a <namex+0x7a>
    if (nameiparent && *path == '\0') {
    800039a2:	000b0563          	beqz	s6,800039ac <namex+0xdc>
    800039a6:	0004c783          	lbu	a5,0(s1)
    800039aa:	d7c5                	beqz	a5,80003952 <namex+0x82>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800039ac:	4601                	li	a2,0
    800039ae:	85d6                	mv	a1,s5
    800039b0:	8552                	mv	a0,s4
    800039b2:	e77ff0ef          	jal	80003828 <dirlookup>
    800039b6:	892a                	mv	s2,a0
    800039b8:	d14d                	beqz	a0,8000395a <namex+0x8a>
    iunlockput(ip);
    800039ba:	8552                	mv	a0,s4
    800039bc:	ad7ff0ef          	jal	80003492 <iunlockput>
    ip = next;
    800039c0:	8a4a                	mv	s4,s2
  while (*path == '/')
    800039c2:	0004c783          	lbu	a5,0(s1)
    800039c6:	01379763          	bne	a5,s3,800039d4 <namex+0x104>
    path++;
    800039ca:	0485                	addi	s1,s1,1
  while (*path == '/')
    800039cc:	0004c783          	lbu	a5,0(s1)
    800039d0:	ff378de3          	beq	a5,s3,800039ca <namex+0xfa>
  if (*path == 0)
    800039d4:	cfa1                	beqz	a5,80003a2c <namex+0x15c>
  while (*path != '/' && *path != 0)
    800039d6:	0004c703          	lbu	a4,0(s1)
    800039da:	fd170793          	addi	a5,a4,-47
    800039de:	00f037b3          	snez	a5,a5
    800039e2:	00e03733          	snez	a4,a4
    800039e6:	8ff9                	and	a5,a5,a4
    800039e8:	dfb5                	beqz	a5,80003964 <namex+0x94>
    800039ea:	8926                	mv	s2,s1
    path++;
    800039ec:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    800039ee:	00094703          	lbu	a4,0(s2)
    800039f2:	fd170793          	addi	a5,a4,-47
    800039f6:	00f037b3          	snez	a5,a5
    800039fa:	00e03733          	snez	a4,a4
    800039fe:	8ff9                	and	a5,a5,a4
    80003a00:	f7f5                	bnez	a5,800039ec <namex+0x11c>
  len = path - s;
    80003a02:	40990633          	sub	a2,s2,s1
    80003a06:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003a0a:	f7ac50e3          	bge	s8,s10,8000396a <namex+0x9a>
    memmove(name, s, DIRSIZ);
    80003a0e:	8666                	mv	a2,s9
    80003a10:	85a6                	mv	a1,s1
    80003a12:	8556                	mv	a0,s5
    80003a14:	b3cfd0ef          	jal	80000d50 <memmove>
  while (*path == '/')
    80003a18:	00094783          	lbu	a5,0(s2)
    80003a1c:	84ca                	mv	s1,s2
    80003a1e:	f73783e3          	beq	a5,s3,80003984 <namex+0xb4>
    80003a22:	b7b5                	j	8000398e <namex+0xbe>
  while ((path = skipelem(path, name)) != 0) {
    80003a24:	00090463          	beqz	s2,80003a2c <namex+0x15c>
    80003a28:	84ca                	mv	s1,s2
    80003a2a:	b795                	j	8000398e <namex+0xbe>
  if (nameiparent) {
    80003a2c:	f00b00e3          	beqz	s6,8000392c <namex+0x5c>
    iput(ip);
    80003a30:	8552                	mv	a0,s4
    80003a32:	98fff0ef          	jal	800033c0 <iput>
    return 0;
    80003a36:	bdd5                	j	8000392a <namex+0x5a>

0000000080003a38 <dirlink>:
{
    80003a38:	715d                	addi	sp,sp,-80
    80003a3a:	e486                	sd	ra,72(sp)
    80003a3c:	e0a2                	sd	s0,64(sp)
    80003a3e:	f84a                	sd	s2,48(sp)
    80003a40:	ec56                	sd	s5,24(sp)
    80003a42:	e85a                	sd	s6,16(sp)
    80003a44:	0880                	addi	s0,sp,80
    80003a46:	892a                	mv	s2,a0
    80003a48:	8aae                	mv	s5,a1
    80003a4a:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003a4c:	4601                	li	a2,0
    80003a4e:	ddbff0ef          	jal	80003828 <dirlookup>
    80003a52:	ed1d                	bnez	a0,80003a90 <dirlink+0x58>
    80003a54:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a56:	04c92483          	lw	s1,76(s2)
    80003a5a:	c4b9                	beqz	s1,80003aa8 <dirlink+0x70>
    80003a5c:	f44e                	sd	s3,40(sp)
    80003a5e:	f052                	sd	s4,32(sp)
    80003a60:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a62:	fb040a13          	addi	s4,s0,-80
    80003a66:	49c1                	li	s3,16
    80003a68:	874e                	mv	a4,s3
    80003a6a:	86a6                	mv	a3,s1
    80003a6c:	8652                	mv	a2,s4
    80003a6e:	4581                	li	a1,0
    80003a70:	854a                	mv	a0,s2
    80003a72:	ba7ff0ef          	jal	80003618 <readi>
    80003a76:	03351163          	bne	a0,s3,80003a98 <dirlink+0x60>
    if (de.inum == 0)
    80003a7a:	fb045783          	lhu	a5,-80(s0)
    80003a7e:	c39d                	beqz	a5,80003aa4 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a80:	24c1                	addiw	s1,s1,16
    80003a82:	04c92783          	lw	a5,76(s2)
    80003a86:	fef4e1e3          	bltu	s1,a5,80003a68 <dirlink+0x30>
    80003a8a:	79a2                	ld	s3,40(sp)
    80003a8c:	7a02                	ld	s4,32(sp)
    80003a8e:	a829                	j	80003aa8 <dirlink+0x70>
    iput(ip);
    80003a90:	931ff0ef          	jal	800033c0 <iput>
    return -1;
    80003a94:	557d                	li	a0,-1
    80003a96:	a83d                	j	80003ad4 <dirlink+0x9c>
      panic("dirlink read");
    80003a98:	00004517          	auipc	a0,0x4
    80003a9c:	a5050513          	addi	a0,a0,-1456 # 800074e8 <etext+0x4e8>
    80003aa0:	da9fc0ef          	jal	80000848 <panic>
    80003aa4:	79a2                	ld	s3,40(sp)
    80003aa6:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003aa8:	4639                	li	a2,14
    80003aaa:	85d6                	mv	a1,s5
    80003aac:	fb240513          	addi	a0,s0,-78
    80003ab0:	b4afd0ef          	jal	80000dfa <strncpy>
  de.inum = inum;
    80003ab4:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ab8:	4741                	li	a4,16
    80003aba:	86a6                	mv	a3,s1
    80003abc:	fb040613          	addi	a2,s0,-80
    80003ac0:	4581                	li	a1,0
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	c47ff0ef          	jal	8000370a <writei>
    80003ac8:	1541                	addi	a0,a0,-16
    80003aca:	00a03533          	snez	a0,a0
    80003ace:	40a0053b          	negw	a0,a0
    80003ad2:	74e2                	ld	s1,56(sp)
}
    80003ad4:	60a6                	ld	ra,72(sp)
    80003ad6:	6406                	ld	s0,64(sp)
    80003ad8:	7942                	ld	s2,48(sp)
    80003ada:	6ae2                	ld	s5,24(sp)
    80003adc:	6b42                	ld	s6,16(sp)
    80003ade:	6161                	addi	sp,sp,80
    80003ae0:	8082                	ret

0000000080003ae2 <namei>:

struct inode *
namei(char *path)
{
    80003ae2:	1101                	addi	sp,sp,-32
    80003ae4:	ec06                	sd	ra,24(sp)
    80003ae6:	e822                	sd	s0,16(sp)
    80003ae8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003aea:	fe040613          	addi	a2,s0,-32
    80003aee:	4581                	li	a1,0
    80003af0:	de1ff0ef          	jal	800038d0 <namex>
}
    80003af4:	60e2                	ld	ra,24(sp)
    80003af6:	6442                	ld	s0,16(sp)
    80003af8:	6105                	addi	sp,sp,32
    80003afa:	8082                	ret

0000000080003afc <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003afc:	1141                	addi	sp,sp,-16
    80003afe:	e406                	sd	ra,8(sp)
    80003b00:	e022                	sd	s0,0(sp)
    80003b02:	0800                	addi	s0,sp,16
    80003b04:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b06:	4585                	li	a1,1
    80003b08:	dc9ff0ef          	jal	800038d0 <namex>
}
    80003b0c:	60a2                	ld	ra,8(sp)
    80003b0e:	6402                	ld	s0,0(sp)
    80003b10:	0141                	addi	sp,sp,16
    80003b12:	8082                	ret

0000000080003b14 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b14:	1101                	addi	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	e04a                	sd	s2,0(sp)
    80003b1e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b20:	0001c917          	auipc	s2,0x1c
    80003b24:	e3890913          	addi	s2,s2,-456 # 8001f958 <log>
    80003b28:	01892583          	lw	a1,24(s2)
    80003b2c:	02492503          	lw	a0,36(s2)
    80003b30:	86eff0ef          	jal	80002b9e <bread>
    80003b34:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003b36:	02c92603          	lw	a2,44(s2)
    80003b3a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b3c:	00c05f63          	blez	a2,80003b5a <write_head+0x46>
    80003b40:	0001c717          	auipc	a4,0x1c
    80003b44:	e4870713          	addi	a4,a4,-440 # 8001f988 <log+0x30>
    80003b48:	87aa                	mv	a5,a0
    80003b4a:	060a                	slli	a2,a2,0x2
    80003b4c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b4e:	4314                	lw	a3,0(a4)
    80003b50:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b52:	0711                	addi	a4,a4,4
    80003b54:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003b56:	fec79ce3          	bne	a5,a2,80003b4e <write_head+0x3a>
  }
  bwrite(buf);
    80003b5a:	8526                	mv	a0,s1
    80003b5c:	918ff0ef          	jal	80002c74 <bwrite>
  brelse(buf);
    80003b60:	8526                	mv	a0,s1
    80003b62:	944ff0ef          	jal	80002ca6 <brelse>
}
    80003b66:	60e2                	ld	ra,24(sp)
    80003b68:	6442                	ld	s0,16(sp)
    80003b6a:	64a2                	ld	s1,8(sp)
    80003b6c:	6902                	ld	s2,0(sp)
    80003b6e:	6105                	addi	sp,sp,32
    80003b70:	8082                	ret

0000000080003b72 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b72:	0001c797          	auipc	a5,0x1c
    80003b76:	e127a783          	lw	a5,-494(a5) # 8001f984 <log+0x2c>
    80003b7a:	0cf05163          	blez	a5,80003c3c <install_trans+0xca>
{
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f44e                	sd	s3,40(sp)
    80003b8a:	f052                	sd	s4,32(sp)
    80003b8c:	ec56                	sd	s5,24(sp)
    80003b8e:	e85a                	sd	s6,16(sp)
    80003b90:	e45e                	sd	s7,8(sp)
    80003b92:	e062                	sd	s8,0(sp)
    80003b94:	0880                	addi	s0,sp,80
    80003b96:	8b2a                	mv	s6,a0
    80003b98:	0001ca97          	auipc	s5,0x1c
    80003b9c:	df0a8a93          	addi	s5,s5,-528 # 8001f988 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ba0:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003ba2:	00004c17          	auipc	s8,0x4
    80003ba6:	956c0c13          	addi	s8,s8,-1706 # 800074f8 <etext+0x4f8>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003baa:	0001ca17          	auipc	s4,0x1c
    80003bae:	daea0a13          	addi	s4,s4,-594 # 8001f958 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003bb2:	40000b93          	li	s7,1024
    80003bb6:	a025                	j	80003bde <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003bb8:	000aa603          	lw	a2,0(s5)
    80003bbc:	85ce                	mv	a1,s3
    80003bbe:	8562                	mv	a0,s8
    80003bc0:	951fc0ef          	jal	80000510 <printk>
    80003bc4:	a839                	j	80003be2 <install_trans+0x70>
    brelse(lbuf);
    80003bc6:	854a                	mv	a0,s2
    80003bc8:	8deff0ef          	jal	80002ca6 <brelse>
    brelse(dbuf);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	8d8ff0ef          	jal	80002ca6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd2:	2985                	addiw	s3,s3,1
    80003bd4:	0a91                	addi	s5,s5,4
    80003bd6:	02ca2783          	lw	a5,44(s4)
    80003bda:	04f9d563          	bge	s3,a5,80003c24 <install_trans+0xb2>
    if (recovering) {
    80003bde:	fc0b1de3          	bnez	s6,80003bb8 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003be2:	018a2583          	lw	a1,24(s4)
    80003be6:	013585bb          	addw	a1,a1,s3
    80003bea:	2585                	addiw	a1,a1,1
    80003bec:	024a2503          	lw	a0,36(s4)
    80003bf0:	faffe0ef          	jal	80002b9e <bread>
    80003bf4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003bf6:	000aa583          	lw	a1,0(s5)
    80003bfa:	024a2503          	lw	a0,36(s4)
    80003bfe:	fa1fe0ef          	jal	80002b9e <bread>
    80003c02:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003c04:	865e                	mv	a2,s7
    80003c06:	05890593          	addi	a1,s2,88
    80003c0a:	05850513          	addi	a0,a0,88
    80003c0e:	942fd0ef          	jal	80000d50 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003c12:	8526                	mv	a0,s1
    80003c14:	860ff0ef          	jal	80002c74 <bwrite>
    if (recovering == 0)
    80003c18:	fa0b17e3          	bnez	s6,80003bc6 <install_trans+0x54>
      bunpin(dbuf);
    80003c1c:	8526                	mv	a0,s1
    80003c1e:	940ff0ef          	jal	80002d5e <bunpin>
    80003c22:	b755                	j	80003bc6 <install_trans+0x54>
}
    80003c24:	60a6                	ld	ra,72(sp)
    80003c26:	6406                	ld	s0,64(sp)
    80003c28:	74e2                	ld	s1,56(sp)
    80003c2a:	7942                	ld	s2,48(sp)
    80003c2c:	79a2                	ld	s3,40(sp)
    80003c2e:	7a02                	ld	s4,32(sp)
    80003c30:	6ae2                	ld	s5,24(sp)
    80003c32:	6b42                	ld	s6,16(sp)
    80003c34:	6ba2                	ld	s7,8(sp)
    80003c36:	6c02                	ld	s8,0(sp)
    80003c38:	6161                	addi	sp,sp,80
    80003c3a:	8082                	ret
    80003c3c:	8082                	ret

0000000080003c3e <initlog>:
{
    80003c3e:	7179                	addi	sp,sp,-48
    80003c40:	f406                	sd	ra,40(sp)
    80003c42:	f022                	sd	s0,32(sp)
    80003c44:	ec26                	sd	s1,24(sp)
    80003c46:	e84a                	sd	s2,16(sp)
    80003c48:	e44e                	sd	s3,8(sp)
    80003c4a:	1800                	addi	s0,sp,48
    80003c4c:	84aa                	mv	s1,a0
    80003c4e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c50:	0001c917          	auipc	s2,0x1c
    80003c54:	d0890913          	addi	s2,s2,-760 # 8001f958 <log>
    80003c58:	00004597          	auipc	a1,0x4
    80003c5c:	8c058593          	addi	a1,a1,-1856 # 80007518 <etext+0x518>
    80003c60:	854a                	mv	a0,s2
    80003c62:	f57fc0ef          	jal	80000bb8 <initlock>
  log.start = sb->logstart;
    80003c66:	0149a583          	lw	a1,20(s3)
    80003c6a:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003c6e:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003c72:	8526                	mv	a0,s1
    80003c74:	f2bfe0ef          	jal	80002b9e <bread>
  log.lh.n = lh->n;
    80003c78:	4d30                	lw	a2,88(a0)
    80003c7a:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003c7e:	00c05f63          	blez	a2,80003c9c <initlog+0x5e>
    80003c82:	87aa                	mv	a5,a0
    80003c84:	0001c717          	auipc	a4,0x1c
    80003c88:	d0470713          	addi	a4,a4,-764 # 8001f988 <log+0x30>
    80003c8c:	060a                	slli	a2,a2,0x2
    80003c8e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c90:	4ff4                	lw	a3,92(a5)
    80003c92:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c94:	0791                	addi	a5,a5,4
    80003c96:	0711                	addi	a4,a4,4
    80003c98:	fec79ce3          	bne	a5,a2,80003c90 <initlog+0x52>
  brelse(buf);
    80003c9c:	80aff0ef          	jal	80002ca6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003ca0:	4505                	li	a0,1
    80003ca2:	ed1ff0ef          	jal	80003b72 <install_trans>
  log.lh.n = 0;
    80003ca6:	0001c797          	auipc	a5,0x1c
    80003caa:	cc07af23          	sw	zero,-802(a5) # 8001f984 <log+0x2c>
  write_head(); // clear the log
    80003cae:	e67ff0ef          	jal	80003b14 <write_head>
}
    80003cb2:	70a2                	ld	ra,40(sp)
    80003cb4:	7402                	ld	s0,32(sp)
    80003cb6:	64e2                	ld	s1,24(sp)
    80003cb8:	6942                	ld	s2,16(sp)
    80003cba:	69a2                	ld	s3,8(sp)
    80003cbc:	6145                	addi	sp,sp,48
    80003cbe:	8082                	ret

0000000080003cc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003cc0:	1101                	addi	sp,sp,-32
    80003cc2:	ec06                	sd	ra,24(sp)
    80003cc4:	e822                	sd	s0,16(sp)
    80003cc6:	e426                	sd	s1,8(sp)
    80003cc8:	e04a                	sd	s2,0(sp)
    80003cca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ccc:	0001c517          	auipc	a0,0x1c
    80003cd0:	c8c50513          	addi	a0,a0,-884 # 8001f958 <log>
    80003cd4:	f65fc0ef          	jal	80000c38 <acquire>
  while (1) {
    if (log.committing) {
    80003cd8:	0001c497          	auipc	s1,0x1c
    80003cdc:	c8048493          	addi	s1,s1,-896 # 8001f958 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003ce0:	4979                	li	s2,30
    80003ce2:	a821                	j	80003cfa <begin_op+0x3a>
      sleep_prepare(&log);
    80003ce4:	8526                	mv	a0,s1
    80003ce6:	a34fe0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003cea:	8526                	mv	a0,s1
    80003cec:	fd1fc0ef          	jal	80000cbc <release>
      sleep();
    80003cf0:	a66fe0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	f43fc0ef          	jal	80000c38 <acquire>
    if (log.committing) {
    80003cfa:	509c                	lw	a5,32(s1)
    80003cfc:	f7e5                	bnez	a5,80003ce4 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003cfe:	4cd8                	lw	a4,28(s1)
    80003d00:	2705                	addiw	a4,a4,1
    80003d02:	0027179b          	slliw	a5,a4,0x2
    80003d06:	9fb9                	addw	a5,a5,a4
    80003d08:	0017979b          	slliw	a5,a5,0x1
    80003d0c:	54d4                	lw	a3,44(s1)
    80003d0e:	9fb5                	addw	a5,a5,a3
    80003d10:	00f95e63          	bge	s2,a5,80003d2c <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003d14:	8526                	mv	a0,s1
    80003d16:	a04fe0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003d1a:	8526                	mv	a0,s1
    80003d1c:	fa1fc0ef          	jal	80000cbc <release>
      sleep();
    80003d20:	a36fe0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003d24:	8526                	mv	a0,s1
    80003d26:	f13fc0ef          	jal	80000c38 <acquire>
    80003d2a:	bfc1                	j	80003cfa <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003d2c:	0001c797          	auipc	a5,0x1c
    80003d30:	c4e7a423          	sw	a4,-952(a5) # 8001f974 <log+0x1c>
      release(&log.lock);
    80003d34:	0001c517          	auipc	a0,0x1c
    80003d38:	c2450513          	addi	a0,a0,-988 # 8001f958 <log>
    80003d3c:	f81fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6902                	ld	s2,0(sp)
    80003d48:	6105                	addi	sp,sp,32
    80003d4a:	8082                	ret

0000000080003d4c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d4c:	7139                	addi	sp,sp,-64
    80003d4e:	fc06                	sd	ra,56(sp)
    80003d50:	f822                	sd	s0,48(sp)
    80003d52:	f426                	sd	s1,40(sp)
    80003d54:	f04a                	sd	s2,32(sp)
    80003d56:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d58:	0001c497          	auipc	s1,0x1c
    80003d5c:	c0048493          	addi	s1,s1,-1024 # 8001f958 <log>
    80003d60:	8526                	mv	a0,s1
    80003d62:	ed7fc0ef          	jal	80000c38 <acquire>
  log.outstanding -= 1;
    80003d66:	4cdc                	lw	a5,28(s1)
    80003d68:	37fd                	addiw	a5,a5,-1
    80003d6a:	893e                	mv	s2,a5
    80003d6c:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003d6e:	509c                	lw	a5,32(s1)
    80003d70:	e7b9                	bnez	a5,80003dbe <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003d72:	04091f63          	bnez	s2,80003dd0 <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003d76:	0001c497          	auipc	s1,0x1c
    80003d7a:	be248493          	addi	s1,s1,-1054 # 8001f958 <log>
    80003d7e:	4785                	li	a5,1
    80003d80:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d82:	8526                	mv	a0,s1
    80003d84:	f39fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d88:	54dc                	lw	a5,44(s1)
    80003d8a:	06f04063          	bgtz	a5,80003dea <end_op+0x9e>
    acquire(&log.lock);
    80003d8e:	0001c497          	auipc	s1,0x1c
    80003d92:	bca48493          	addi	s1,s1,-1078 # 8001f958 <log>
    80003d96:	8526                	mv	a0,s1
    80003d98:	ea1fc0ef          	jal	80000c38 <acquire>
    log.committing = 0;
    80003d9c:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003da0:	549c                	lw	a5,40(s1)
    80003da2:	2785                	addiw	a5,a5,1
    80003da4:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003da6:	8526                	mv	a0,s1
    80003da8:	9defe0ef          	jal	80001f86 <wakeup>
    release(&log.lock);
    80003dac:	8526                	mv	a0,s1
    80003dae:	f0ffc0ef          	jal	80000cbc <release>
}
    80003db2:	70e2                	ld	ra,56(sp)
    80003db4:	7442                	ld	s0,48(sp)
    80003db6:	74a2                	ld	s1,40(sp)
    80003db8:	7902                	ld	s2,32(sp)
    80003dba:	6121                	addi	sp,sp,64
    80003dbc:	8082                	ret
    80003dbe:	ec4e                	sd	s3,24(sp)
    80003dc0:	e852                	sd	s4,16(sp)
    80003dc2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003dc4:	00003517          	auipc	a0,0x3
    80003dc8:	75c50513          	addi	a0,a0,1884 # 80007520 <etext+0x520>
    80003dcc:	a7dfc0ef          	jal	80000848 <panic>
    wakeup(&log);
    80003dd0:	0001c517          	auipc	a0,0x1c
    80003dd4:	b8850513          	addi	a0,a0,-1144 # 8001f958 <log>
    80003dd8:	9aefe0ef          	jal	80001f86 <wakeup>
  release(&log.lock);
    80003ddc:	0001c517          	auipc	a0,0x1c
    80003de0:	b7c50513          	addi	a0,a0,-1156 # 8001f958 <log>
    80003de4:	ed9fc0ef          	jal	80000cbc <release>
  if (do_commit) {
    80003de8:	b7e9                	j	80003db2 <end_op+0x66>
    80003dea:	ec4e                	sd	s3,24(sp)
    80003dec:	e852                	sd	s4,16(sp)
    80003dee:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003df0:	0001ca97          	auipc	s5,0x1c
    80003df4:	b98a8a93          	addi	s5,s5,-1128 # 8001f988 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003df8:	0001ca17          	auipc	s4,0x1c
    80003dfc:	b60a0a13          	addi	s4,s4,-1184 # 8001f958 <log>
    80003e00:	018a2583          	lw	a1,24(s4)
    80003e04:	012585bb          	addw	a1,a1,s2
    80003e08:	2585                	addiw	a1,a1,1
    80003e0a:	024a2503          	lw	a0,36(s4)
    80003e0e:	d91fe0ef          	jal	80002b9e <bread>
    80003e12:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e14:	000aa583          	lw	a1,0(s5)
    80003e18:	024a2503          	lw	a0,36(s4)
    80003e1c:	d83fe0ef          	jal	80002b9e <bread>
    80003e20:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e22:	40000613          	li	a2,1024
    80003e26:	05850593          	addi	a1,a0,88
    80003e2a:	05848513          	addi	a0,s1,88
    80003e2e:	f23fc0ef          	jal	80000d50 <memmove>
    bwrite(to); // write the log
    80003e32:	8526                	mv	a0,s1
    80003e34:	e41fe0ef          	jal	80002c74 <bwrite>
    brelse(from);
    80003e38:	854e                	mv	a0,s3
    80003e3a:	e6dfe0ef          	jal	80002ca6 <brelse>
    brelse(to);
    80003e3e:	8526                	mv	a0,s1
    80003e40:	e67fe0ef          	jal	80002ca6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e44:	2905                	addiw	s2,s2,1
    80003e46:	0a91                	addi	s5,s5,4
    80003e48:	02ca2783          	lw	a5,44(s4)
    80003e4c:	faf94ae3          	blt	s2,a5,80003e00 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003e50:	cc5ff0ef          	jal	80003b14 <write_head>
    install_trans(0); // Now install writes to home locations
    80003e54:	4501                	li	a0,0
    80003e56:	d1dff0ef          	jal	80003b72 <install_trans>
    log.lh.n = 0;
    80003e5a:	0001c797          	auipc	a5,0x1c
    80003e5e:	b207a523          	sw	zero,-1238(a5) # 8001f984 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003e62:	cb3ff0ef          	jal	80003b14 <write_head>
    80003e66:	69e2                	ld	s3,24(sp)
    80003e68:	6a42                	ld	s4,16(sp)
    80003e6a:	6aa2                	ld	s5,8(sp)
    80003e6c:	b70d                	j	80003d8e <end_op+0x42>

0000000080003e6e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e6e:	1101                	addi	sp,sp,-32
    80003e70:	ec06                	sd	ra,24(sp)
    80003e72:	e822                	sd	s0,16(sp)
    80003e74:	e426                	sd	s1,8(sp)
    80003e76:	1000                	addi	s0,sp,32
    80003e78:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e7a:	0001c517          	auipc	a0,0x1c
    80003e7e:	ade50513          	addi	a0,a0,-1314 # 8001f958 <log>
    80003e82:	db7fc0ef          	jal	80000c38 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003e86:	0001c617          	auipc	a2,0x1c
    80003e8a:	afe62603          	lw	a2,-1282(a2) # 8001f984 <log+0x2c>
    80003e8e:	47f5                	li	a5,29
    80003e90:	04c7cc63          	blt	a5,a2,80003ee8 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e94:	0001c797          	auipc	a5,0x1c
    80003e98:	ae07a783          	lw	a5,-1312(a5) # 8001f974 <log+0x1c>
    80003e9c:	04f05c63          	blez	a5,80003ef4 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ea0:	4781                	li	a5,0
    80003ea2:	04c05f63          	blez	a2,80003f00 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003ea6:	44cc                	lw	a1,12(s1)
    80003ea8:	0001c717          	auipc	a4,0x1c
    80003eac:	ae070713          	addi	a4,a4,-1312 # 8001f988 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003eb0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003eb2:	4314                	lw	a3,0(a4)
    80003eb4:	04b68663          	beq	a3,a1,80003f00 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003eb8:	2785                	addiw	a5,a5,1
    80003eba:	0711                	addi	a4,a4,4
    80003ebc:	fef61be3          	bne	a2,a5,80003eb2 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ec0:	0621                	addi	a2,a2,8
    80003ec2:	060a                	slli	a2,a2,0x2
    80003ec4:	0001c797          	auipc	a5,0x1c
    80003ec8:	a9478793          	addi	a5,a5,-1388 # 8001f958 <log>
    80003ecc:	97b2                	add	a5,a5,a2
    80003ece:	44d8                	lw	a4,12(s1)
    80003ed0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	e57fe0ef          	jal	80002d2a <bpin>
    log.lh.n++;
    80003ed8:	0001c717          	auipc	a4,0x1c
    80003edc:	a8070713          	addi	a4,a4,-1408 # 8001f958 <log>
    80003ee0:	575c                	lw	a5,44(a4)
    80003ee2:	2785                	addiw	a5,a5,1
    80003ee4:	d75c                	sw	a5,44(a4)
    80003ee6:	a80d                	j	80003f18 <log_write+0xaa>
    panic("too big a transaction");
    80003ee8:	00003517          	auipc	a0,0x3
    80003eec:	64850513          	addi	a0,a0,1608 # 80007530 <etext+0x530>
    80003ef0:	959fc0ef          	jal	80000848 <panic>
    panic("log_write outside of trans");
    80003ef4:	00003517          	auipc	a0,0x3
    80003ef8:	65450513          	addi	a0,a0,1620 # 80007548 <etext+0x548>
    80003efc:	94dfc0ef          	jal	80000848 <panic>
  log.lh.block[i] = b->blockno;
    80003f00:	00878693          	addi	a3,a5,8
    80003f04:	068a                	slli	a3,a3,0x2
    80003f06:	0001c717          	auipc	a4,0x1c
    80003f0a:	a5270713          	addi	a4,a4,-1454 # 8001f958 <log>
    80003f0e:	9736                	add	a4,a4,a3
    80003f10:	44d4                	lw	a3,12(s1)
    80003f12:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003f14:	faf60fe3          	beq	a2,a5,80003ed2 <log_write+0x64>
  }
  release(&log.lock);
    80003f18:	0001c517          	auipc	a0,0x1c
    80003f1c:	a4050513          	addi	a0,a0,-1472 # 8001f958 <log>
    80003f20:	d9dfc0ef          	jal	80000cbc <release>
}
    80003f24:	60e2                	ld	ra,24(sp)
    80003f26:	6442                	ld	s0,16(sp)
    80003f28:	64a2                	ld	s1,8(sp)
    80003f2a:	6105                	addi	sp,sp,32
    80003f2c:	8082                	ret

0000000080003f2e <sys_sync>:

uint64
sys_sync(void)
{
    80003f2e:	1101                	addi	sp,sp,-32
    80003f30:	ec06                	sd	ra,24(sp)
    80003f32:	e822                	sd	s0,16(sp)
    80003f34:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003f36:	0001c517          	auipc	a0,0x1c
    80003f3a:	a2250513          	addi	a0,a0,-1502 # 8001f958 <log>
    80003f3e:	cfbfc0ef          	jal	80000c38 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003f42:	0001c797          	auipc	a5,0x1c
    80003f46:	a367a783          	lw	a5,-1482(a5) # 8001f978 <log+0x20>
    80003f4a:	e799                	bnez	a5,80003f58 <sys_sync+0x2a>
    80003f4c:	0001c797          	auipc	a5,0x1c
    80003f50:	a287a783          	lw	a5,-1496(a5) # 8001f974 <log+0x1c>
    80003f54:	02f05c63          	blez	a5,80003f8c <sys_sync+0x5e>
    80003f58:	e426                	sd	s1,8(sp)
    80003f5a:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003f5c:	0001c917          	auipc	s2,0x1c
    80003f60:	a2492903          	lw	s2,-1500(s2) # 8001f980 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80003f64:	0001c497          	auipc	s1,0x1c
    80003f68:	9f448493          	addi	s1,s1,-1548 # 8001f958 <log>
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	fadfd0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	d49fc0ef          	jal	80000cbc <release>
      sleep();
    80003f78:	fdffd0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	cbbfc0ef          	jal	80000c38 <acquire>
    while (log.ncommit < n) {
    80003f82:	549c                	lw	a5,40(s1)
    80003f84:	fef954e3          	bge	s2,a5,80003f6c <sys_sync+0x3e>
    80003f88:	64a2                	ld	s1,8(sp)
    80003f8a:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003f8c:	0001c517          	auipc	a0,0x1c
    80003f90:	9cc50513          	addi	a0,a0,-1588 # 8001f958 <log>
    80003f94:	d29fc0ef          	jal	80000cbc <release>
  return 0;
}
    80003f98:	4501                	li	a0,0
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	6105                	addi	sp,sp,32
    80003fa0:	8082                	ret

0000000080003fa2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fa2:	1101                	addi	sp,sp,-32
    80003fa4:	ec06                	sd	ra,24(sp)
    80003fa6:	e822                	sd	s0,16(sp)
    80003fa8:	e426                	sd	s1,8(sp)
    80003faa:	e04a                	sd	s2,0(sp)
    80003fac:	1000                	addi	s0,sp,32
    80003fae:	84aa                	mv	s1,a0
    80003fb0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003fb2:	00003597          	auipc	a1,0x3
    80003fb6:	5b658593          	addi	a1,a1,1462 # 80007568 <etext+0x568>
    80003fba:	0521                	addi	a0,a0,8
    80003fbc:	bfdfc0ef          	jal	80000bb8 <initlock>
  lk->name = name;
    80003fc0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003fc4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003fc8:	0204a423          	sw	zero,40(s1)
}
    80003fcc:	60e2                	ld	ra,24(sp)
    80003fce:	6442                	ld	s0,16(sp)
    80003fd0:	64a2                	ld	s1,8(sp)
    80003fd2:	6902                	ld	s2,0(sp)
    80003fd4:	6105                	addi	sp,sp,32
    80003fd6:	8082                	ret

0000000080003fd8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003fd8:	1101                	addi	sp,sp,-32
    80003fda:	ec06                	sd	ra,24(sp)
    80003fdc:	e822                	sd	s0,16(sp)
    80003fde:	e426                	sd	s1,8(sp)
    80003fe0:	e04a                	sd	s2,0(sp)
    80003fe2:	1000                	addi	s0,sp,32
    80003fe4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fe6:	00850913          	addi	s2,a0,8
    80003fea:	854a                	mv	a0,s2
    80003fec:	c4dfc0ef          	jal	80000c38 <acquire>
  while (lk->locked) {
    80003ff0:	409c                	lw	a5,0(s1)
    80003ff2:	cf91                	beqz	a5,8000400e <acquiresleep+0x36>
    sleep_prepare(lk);
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	f25fd0ef          	jal	80001f1a <sleep_prepare>
    release(&lk->lk);
    80003ffa:	854a                	mv	a0,s2
    80003ffc:	cc1fc0ef          	jal	80000cbc <release>
    sleep();
    80004000:	f57fd0ef          	jal	80001f56 <sleep>
    acquire(&lk->lk);
    80004004:	854a                	mv	a0,s2
    80004006:	c33fc0ef          	jal	80000c38 <acquire>
  while (lk->locked) {
    8000400a:	409c                	lw	a5,0(s1)
    8000400c:	f7e5                	bnez	a5,80003ff4 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000400e:	4785                	li	a5,1
    80004010:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004012:	911fd0ef          	jal	80001922 <myproc>
    80004016:	591c                	lw	a5,48(a0)
    80004018:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000401a:	854a                	mv	a0,s2
    8000401c:	ca1fc0ef          	jal	80000cbc <release>
}
    80004020:	60e2                	ld	ra,24(sp)
    80004022:	6442                	ld	s0,16(sp)
    80004024:	64a2                	ld	s1,8(sp)
    80004026:	6902                	ld	s2,0(sp)
    80004028:	6105                	addi	sp,sp,32
    8000402a:	8082                	ret

000000008000402c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000402c:	1101                	addi	sp,sp,-32
    8000402e:	ec06                	sd	ra,24(sp)
    80004030:	e822                	sd	s0,16(sp)
    80004032:	e426                	sd	s1,8(sp)
    80004034:	e04a                	sd	s2,0(sp)
    80004036:	1000                	addi	s0,sp,32
    80004038:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000403a:	00850913          	addi	s2,a0,8
    8000403e:	854a                	mv	a0,s2
    80004040:	bf9fc0ef          	jal	80000c38 <acquire>
  lk->locked = 0;
    80004044:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004048:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000404c:	8526                	mv	a0,s1
    8000404e:	f39fd0ef          	jal	80001f86 <wakeup>
  release(&lk->lk);
    80004052:	854a                	mv	a0,s2
    80004054:	c69fc0ef          	jal	80000cbc <release>
}
    80004058:	60e2                	ld	ra,24(sp)
    8000405a:	6442                	ld	s0,16(sp)
    8000405c:	64a2                	ld	s1,8(sp)
    8000405e:	6902                	ld	s2,0(sp)
    80004060:	6105                	addi	sp,sp,32
    80004062:	8082                	ret

0000000080004064 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004064:	7179                	addi	sp,sp,-48
    80004066:	f406                	sd	ra,40(sp)
    80004068:	f022                	sd	s0,32(sp)
    8000406a:	ec26                	sd	s1,24(sp)
    8000406c:	e84a                	sd	s2,16(sp)
    8000406e:	1800                	addi	s0,sp,48
    80004070:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004072:	00850913          	addi	s2,a0,8
    80004076:	854a                	mv	a0,s2
    80004078:	bc1fc0ef          	jal	80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000407c:	409c                	lw	a5,0(s1)
    8000407e:	ef81                	bnez	a5,80004096 <holdingsleep+0x32>
    80004080:	4481                	li	s1,0
  release(&lk->lk);
    80004082:	854a                	mv	a0,s2
    80004084:	c39fc0ef          	jal	80000cbc <release>
  return r;
}
    80004088:	8526                	mv	a0,s1
    8000408a:	70a2                	ld	ra,40(sp)
    8000408c:	7402                	ld	s0,32(sp)
    8000408e:	64e2                	ld	s1,24(sp)
    80004090:	6942                	ld	s2,16(sp)
    80004092:	6145                	addi	sp,sp,48
    80004094:	8082                	ret
    80004096:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004098:	0284a983          	lw	s3,40(s1)
    8000409c:	887fd0ef          	jal	80001922 <myproc>
    800040a0:	5904                	lw	s1,48(a0)
    800040a2:	413484b3          	sub	s1,s1,s3
    800040a6:	0014b493          	seqz	s1,s1
    800040aa:	69a2                	ld	s3,8(sp)
    800040ac:	bfd9                	j	80004082 <holdingsleep+0x1e>

00000000800040ae <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040ae:	1141                	addi	sp,sp,-16
    800040b0:	e406                	sd	ra,8(sp)
    800040b2:	e022                	sd	s0,0(sp)
    800040b4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040b6:	00003597          	auipc	a1,0x3
    800040ba:	4c258593          	addi	a1,a1,1218 # 80007578 <etext+0x578>
    800040be:	0001c517          	auipc	a0,0x1c
    800040c2:	9e250513          	addi	a0,a0,-1566 # 8001faa0 <ftable>
    800040c6:	af3fc0ef          	jal	80000bb8 <initlock>
}
    800040ca:	60a2                	ld	ra,8(sp)
    800040cc:	6402                	ld	s0,0(sp)
    800040ce:	0141                	addi	sp,sp,16
    800040d0:	8082                	ret

00000000800040d2 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800040d2:	1101                	addi	sp,sp,-32
    800040d4:	ec06                	sd	ra,24(sp)
    800040d6:	e822                	sd	s0,16(sp)
    800040d8:	e426                	sd	s1,8(sp)
    800040da:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800040dc:	0001c517          	auipc	a0,0x1c
    800040e0:	9c450513          	addi	a0,a0,-1596 # 8001faa0 <ftable>
    800040e4:	b55fc0ef          	jal	80000c38 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800040e8:	0001c497          	auipc	s1,0x1c
    800040ec:	9d048493          	addi	s1,s1,-1584 # 8001fab8 <ftable+0x18>
    800040f0:	0001d717          	auipc	a4,0x1d
    800040f4:	96870713          	addi	a4,a4,-1688 # 80020a58 <disk>
    if (f->ref == 0) {
    800040f8:	40dc                	lw	a5,4(s1)
    800040fa:	cf89                	beqz	a5,80004114 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800040fc:	02848493          	addi	s1,s1,40
    80004100:	fee49ce3          	bne	s1,a4,800040f8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004104:	0001c517          	auipc	a0,0x1c
    80004108:	99c50513          	addi	a0,a0,-1636 # 8001faa0 <ftable>
    8000410c:	bb1fc0ef          	jal	80000cbc <release>
  return 0;
    80004110:	4481                	li	s1,0
    80004112:	a809                	j	80004124 <filealloc+0x52>
      f->ref = 1;
    80004114:	4785                	li	a5,1
    80004116:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004118:	0001c517          	auipc	a0,0x1c
    8000411c:	98850513          	addi	a0,a0,-1656 # 8001faa0 <ftable>
    80004120:	b9dfc0ef          	jal	80000cbc <release>
}
    80004124:	8526                	mv	a0,s1
    80004126:	60e2                	ld	ra,24(sp)
    80004128:	6442                	ld	s0,16(sp)
    8000412a:	64a2                	ld	s1,8(sp)
    8000412c:	6105                	addi	sp,sp,32
    8000412e:	8082                	ret

0000000080004130 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004130:	1101                	addi	sp,sp,-32
    80004132:	ec06                	sd	ra,24(sp)
    80004134:	e822                	sd	s0,16(sp)
    80004136:	e426                	sd	s1,8(sp)
    80004138:	1000                	addi	s0,sp,32
    8000413a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000413c:	0001c517          	auipc	a0,0x1c
    80004140:	96450513          	addi	a0,a0,-1692 # 8001faa0 <ftable>
    80004144:	af5fc0ef          	jal	80000c38 <acquire>
  if (f->ref < 1)
    80004148:	40dc                	lw	a5,4(s1)
    8000414a:	02f05063          	blez	a5,8000416a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000414e:	2785                	addiw	a5,a5,1
    80004150:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004152:	0001c517          	auipc	a0,0x1c
    80004156:	94e50513          	addi	a0,a0,-1714 # 8001faa0 <ftable>
    8000415a:	b63fc0ef          	jal	80000cbc <release>
  return f;
}
    8000415e:	8526                	mv	a0,s1
    80004160:	60e2                	ld	ra,24(sp)
    80004162:	6442                	ld	s0,16(sp)
    80004164:	64a2                	ld	s1,8(sp)
    80004166:	6105                	addi	sp,sp,32
    80004168:	8082                	ret
    panic("filedup");
    8000416a:	00003517          	auipc	a0,0x3
    8000416e:	41650513          	addi	a0,a0,1046 # 80007580 <etext+0x580>
    80004172:	ed6fc0ef          	jal	80000848 <panic>

0000000080004176 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004176:	7139                	addi	sp,sp,-64
    80004178:	fc06                	sd	ra,56(sp)
    8000417a:	f822                	sd	s0,48(sp)
    8000417c:	f426                	sd	s1,40(sp)
    8000417e:	0080                	addi	s0,sp,64
    80004180:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004182:	0001c517          	auipc	a0,0x1c
    80004186:	91e50513          	addi	a0,a0,-1762 # 8001faa0 <ftable>
    8000418a:	aaffc0ef          	jal	80000c38 <acquire>
  if (f->ref < 1)
    8000418e:	40dc                	lw	a5,4(s1)
    80004190:	04f05a63          	blez	a5,800041e4 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    80004194:	37fd                	addiw	a5,a5,-1
    80004196:	c0dc                	sw	a5,4(s1)
    80004198:	06f04063          	bgtz	a5,800041f8 <fileclose+0x82>
    8000419c:	f04a                	sd	s2,32(sp)
    8000419e:	ec4e                	sd	s3,24(sp)
    800041a0:	e852                	sd	s4,16(sp)
    800041a2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041a4:	0004a903          	lw	s2,0(s1)
    800041a8:	0094c783          	lbu	a5,9(s1)
    800041ac:	89be                	mv	s3,a5
    800041ae:	689c                	ld	a5,16(s1)
    800041b0:	8a3e                	mv	s4,a5
    800041b2:	6c9c                	ld	a5,24(s1)
    800041b4:	8abe                	mv	s5,a5
  f->ref = 0;
    800041b6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041ba:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041be:	0001c517          	auipc	a0,0x1c
    800041c2:	8e250513          	addi	a0,a0,-1822 # 8001faa0 <ftable>
    800041c6:	af7fc0ef          	jal	80000cbc <release>

  if (ff.type == FD_PIPE) {
    800041ca:	4785                	li	a5,1
    800041cc:	04f90163          	beq	s2,a5,8000420e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    800041d0:	ffe9079b          	addiw	a5,s2,-2
    800041d4:	4705                	li	a4,1
    800041d6:	04f77563          	bgeu	a4,a5,80004220 <fileclose+0xaa>
    800041da:	7902                	ld	s2,32(sp)
    800041dc:	69e2                	ld	s3,24(sp)
    800041de:	6a42                	ld	s4,16(sp)
    800041e0:	6aa2                	ld	s5,8(sp)
    800041e2:	a00d                	j	80004204 <fileclose+0x8e>
    800041e4:	f04a                	sd	s2,32(sp)
    800041e6:	ec4e                	sd	s3,24(sp)
    800041e8:	e852                	sd	s4,16(sp)
    800041ea:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800041ec:	00003517          	auipc	a0,0x3
    800041f0:	39c50513          	addi	a0,a0,924 # 80007588 <etext+0x588>
    800041f4:	e54fc0ef          	jal	80000848 <panic>
    release(&ftable.lock);
    800041f8:	0001c517          	auipc	a0,0x1c
    800041fc:	8a850513          	addi	a0,a0,-1880 # 8001faa0 <ftable>
    80004200:	abdfc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004204:	70e2                	ld	ra,56(sp)
    80004206:	7442                	ld	s0,48(sp)
    80004208:	74a2                	ld	s1,40(sp)
    8000420a:	6121                	addi	sp,sp,64
    8000420c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000420e:	85ce                	mv	a1,s3
    80004210:	8552                	mv	a0,s4
    80004212:	352000ef          	jal	80004564 <pipeclose>
    80004216:	7902                	ld	s2,32(sp)
    80004218:	69e2                	ld	s3,24(sp)
    8000421a:	6a42                	ld	s4,16(sp)
    8000421c:	6aa2                	ld	s5,8(sp)
    8000421e:	b7dd                	j	80004204 <fileclose+0x8e>
    begin_op();
    80004220:	aa1ff0ef          	jal	80003cc0 <begin_op>
    iput(ff.ip);
    80004224:	8556                	mv	a0,s5
    80004226:	99aff0ef          	jal	800033c0 <iput>
    end_op();
    8000422a:	b23ff0ef          	jal	80003d4c <end_op>
    8000422e:	7902                	ld	s2,32(sp)
    80004230:	69e2                	ld	s3,24(sp)
    80004232:	6a42                	ld	s4,16(sp)
    80004234:	6aa2                	ld	s5,8(sp)
    80004236:	b7f9                	j	80004204 <fileclose+0x8e>

0000000080004238 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004238:	715d                	addi	sp,sp,-80
    8000423a:	e486                	sd	ra,72(sp)
    8000423c:	e0a2                	sd	s0,64(sp)
    8000423e:	fc26                	sd	s1,56(sp)
    80004240:	f052                	sd	s4,32(sp)
    80004242:	0880                	addi	s0,sp,80
    80004244:	84aa                	mv	s1,a0
    80004246:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004248:	edafd0ef          	jal	80001922 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    8000424c:	409c                	lw	a5,0(s1)
    8000424e:	37f9                	addiw	a5,a5,-2
    80004250:	4705                	li	a4,1
    80004252:	04f76963          	bltu	a4,a5,800042a4 <filestat+0x6c>
    80004256:	f84a                	sd	s2,48(sp)
    80004258:	f44e                	sd	s3,40(sp)
    8000425a:	892a                	mv	s2,a0
    memset(&st, 0, sizeof(st));
    8000425c:	fb840993          	addi	s3,s0,-72
    80004260:	4661                	li	a2,24
    80004262:	4581                	li	a1,0
    80004264:	854e                	mv	a0,s3
    80004266:	a8ffc0ef          	jal	80000cf4 <memset>
    ilock(f->ip);
    8000426a:	6c88                	ld	a0,24(s1)
    8000426c:	fd3fe0ef          	jal	8000323e <ilock>
    stati(f->ip, &st);
    80004270:	85ce                	mv	a1,s3
    80004272:	6c88                	ld	a0,24(s1)
    80004274:	b76ff0ef          	jal	800035ea <stati>
    iunlock(f->ip);
    80004278:	6c88                	ld	a0,24(s1)
    8000427a:	872ff0ef          	jal	800032ec <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    8000427e:	4761                	li	a4,24
    80004280:	86ce                	mv	a3,s3
    80004282:	8652                	mv	a2,s4
    80004284:	04893583          	ld	a1,72(s2)
    80004288:	05093503          	ld	a0,80(s2)
    8000428c:	ae0fd0ef          	jal	8000156c <copyout>
    80004290:	41f5551b          	sraiw	a0,a0,0x1f
    80004294:	7942                	ld	s2,48(sp)
    80004296:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004298:	60a6                	ld	ra,72(sp)
    8000429a:	6406                	ld	s0,64(sp)
    8000429c:	74e2                	ld	s1,56(sp)
    8000429e:	7a02                	ld	s4,32(sp)
    800042a0:	6161                	addi	sp,sp,80
    800042a2:	8082                	ret
  return -1;
    800042a4:	557d                	li	a0,-1
    800042a6:	bfcd                	j	80004298 <filestat+0x60>

00000000800042a8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042a8:	7179                	addi	sp,sp,-48
    800042aa:	f406                	sd	ra,40(sp)
    800042ac:	f022                	sd	s0,32(sp)
    800042ae:	e84a                	sd	s2,16(sp)
    800042b0:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    800042b2:	00854783          	lbu	a5,8(a0)
    800042b6:	0017b793          	seqz	a5,a5
    800042ba:	01f6571b          	srliw	a4,a2,0x1f
    800042be:	8fd9                	or	a5,a5,a4
    800042c0:	e3c5                	bnez	a5,80004360 <fileread+0xb8>
    800042c2:	ec26                	sd	s1,24(sp)
    800042c4:	e44e                	sd	s3,8(sp)
    800042c6:	84aa                	mv	s1,a0
    800042c8:	892e                	mv	s2,a1
    800042ca:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    800042cc:	411c                	lw	a5,0(a0)
    800042ce:	4705                	li	a4,1
    800042d0:	04e78363          	beq	a5,a4,80004316 <fileread+0x6e>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800042d4:	470d                	li	a4,3
    800042d6:	04e78763          	beq	a5,a4,80004324 <fileread+0x7c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    800042da:	4709                	li	a4,2
    800042dc:	06e79a63          	bne	a5,a4,80004350 <fileread+0xa8>
    ilock(f->ip);
    800042e0:	6d08                	ld	a0,24(a0)
    800042e2:	f5dfe0ef          	jal	8000323e <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800042e6:	874e                	mv	a4,s3
    800042e8:	5094                	lw	a3,32(s1)
    800042ea:	864a                	mv	a2,s2
    800042ec:	4585                	li	a1,1
    800042ee:	6c88                	ld	a0,24(s1)
    800042f0:	b28ff0ef          	jal	80003618 <readi>
    800042f4:	892a                	mv	s2,a0
    800042f6:	00a05563          	blez	a0,80004300 <fileread+0x58>
      f->off += r;
    800042fa:	509c                	lw	a5,32(s1)
    800042fc:	9fa9                	addw	a5,a5,a0
    800042fe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004300:	6c88                	ld	a0,24(s1)
    80004302:	febfe0ef          	jal	800032ec <iunlock>
    80004306:	64e2                	ld	s1,24(sp)
    80004308:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000430a:	854a                	mv	a0,s2
    8000430c:	70a2                	ld	ra,40(sp)
    8000430e:	7402                	ld	s0,32(sp)
    80004310:	6942                	ld	s2,16(sp)
    80004312:	6145                	addi	sp,sp,48
    80004314:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004316:	6908                	ld	a0,16(a0)
    80004318:	3c6000ef          	jal	800046de <piperead>
    8000431c:	892a                	mv	s2,a0
    8000431e:	64e2                	ld	s1,24(sp)
    80004320:	69a2                	ld	s3,8(sp)
    80004322:	b7e5                	j	8000430a <fileread+0x62>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004324:	02451783          	lh	a5,36(a0)
    80004328:	03079693          	slli	a3,a5,0x30
    8000432c:	92c1                	srli	a3,a3,0x30
    8000432e:	4725                	li	a4,9
    80004330:	02d76663          	bltu	a4,a3,8000435c <fileread+0xb4>
    80004334:	0792                	slli	a5,a5,0x4
    80004336:	0001b717          	auipc	a4,0x1b
    8000433a:	6ca70713          	addi	a4,a4,1738 # 8001fa00 <devsw>
    8000433e:	97ba                	add	a5,a5,a4
    80004340:	639c                	ld	a5,0(a5)
    80004342:	c395                	beqz	a5,80004366 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004344:	4505                	li	a0,1
    80004346:	9782                	jalr	a5
    80004348:	892a                	mv	s2,a0
    8000434a:	64e2                	ld	s1,24(sp)
    8000434c:	69a2                	ld	s3,8(sp)
    8000434e:	bf75                	j	8000430a <fileread+0x62>
    panic("fileread");
    80004350:	00003517          	auipc	a0,0x3
    80004354:	24850513          	addi	a0,a0,584 # 80007598 <etext+0x598>
    80004358:	cf0fc0ef          	jal	80000848 <panic>
    8000435c:	64e2                	ld	s1,24(sp)
    8000435e:	69a2                	ld	s3,8(sp)
    return -1;
    80004360:	57fd                	li	a5,-1
    80004362:	893e                	mv	s2,a5
    80004364:	b75d                	j	8000430a <fileread+0x62>
    80004366:	64e2                	ld	s1,24(sp)
    80004368:	69a2                	ld	s3,8(sp)
    8000436a:	bfdd                	j	80004360 <fileread+0xb8>

000000008000436c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    8000436c:	00954783          	lbu	a5,9(a0)
    80004370:	0017b793          	seqz	a5,a5
    80004374:	01f6571b          	srliw	a4,a2,0x1f
    80004378:	8fd9                	or	a5,a5,a4
    8000437a:	12079363          	bnez	a5,800044a0 <filewrite+0x134>
{
    8000437e:	711d                	addi	sp,sp,-96
    80004380:	ec86                	sd	ra,88(sp)
    80004382:	e8a2                	sd	s0,80(sp)
    80004384:	e0ca                	sd	s2,64(sp)
    80004386:	f456                	sd	s5,40(sp)
    80004388:	f05a                	sd	s6,32(sp)
    8000438a:	1080                	addi	s0,sp,96
    8000438c:	892a                	mv	s2,a0
    8000438e:	8b2e                	mv	s6,a1
    80004390:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004392:	411c                	lw	a5,0(a0)
    80004394:	4705                	li	a4,1
    80004396:	02e78a63          	beq	a5,a4,800043ca <filewrite+0x5e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000439a:	470d                	li	a4,3
    8000439c:	02e78b63          	beq	a5,a4,800043d2 <filewrite+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800043a0:	4709                	li	a4,2
    800043a2:	0ce79763          	bne	a5,a4,80004470 <filewrite+0x104>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800043a6:	0ec05363          	blez	a2,8000448c <filewrite+0x120>
    800043aa:	e4a6                	sd	s1,72(sp)
    800043ac:	fc4e                	sd	s3,56(sp)
    800043ae:	f852                	sd	s4,48(sp)
    800043b0:	ec5e                	sd	s7,24(sp)
    800043b2:	e862                	sd	s8,16(sp)
    800043b4:	e466                	sd	s9,8(sp)
    int i = 0;
    800043b6:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800043b8:	6b85                	lui	s7,0x1
    800043ba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043be:	6785                	lui	a5,0x1
    800043c0:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800043c4:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043c6:	4c05                	li	s8,1
    800043c8:	a8ad                	j	80004442 <filewrite+0xd6>
    ret = pipewrite(f->pipe, addr, n);
    800043ca:	6908                	ld	a0,16(a0)
    800043cc:	1f6000ef          	jal	800045c2 <pipewrite>
    800043d0:	a849                	j	80004462 <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043d2:	02451783          	lh	a5,36(a0)
    800043d6:	03079693          	slli	a3,a5,0x30
    800043da:	92c1                	srli	a3,a3,0x30
    800043dc:	4725                	li	a4,9
    800043de:	0ad76563          	bltu	a4,a3,80004488 <filewrite+0x11c>
    800043e2:	0792                	slli	a5,a5,0x4
    800043e4:	0001b717          	auipc	a4,0x1b
    800043e8:	61c70713          	addi	a4,a4,1564 # 8001fa00 <devsw>
    800043ec:	97ba                	add	a5,a5,a4
    800043ee:	679c                	ld	a5,8(a5)
    800043f0:	cfc1                	beqz	a5,80004488 <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    800043f2:	4505                	li	a0,1
    800043f4:	9782                	jalr	a5
    800043f6:	a0b5                	j	80004462 <filewrite+0xf6>
      if (n1 > max)
    800043f8:	2981                	sext.w	s3,s3
      begin_op();
    800043fa:	8c7ff0ef          	jal	80003cc0 <begin_op>
      ilock(f->ip);
    800043fe:	01893503          	ld	a0,24(s2)
    80004402:	e3dfe0ef          	jal	8000323e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004406:	874e                	mv	a4,s3
    80004408:	02092683          	lw	a3,32(s2)
    8000440c:	016a0633          	add	a2,s4,s6
    80004410:	85e2                	mv	a1,s8
    80004412:	01893503          	ld	a0,24(s2)
    80004416:	af4ff0ef          	jal	8000370a <writei>
    8000441a:	84aa                	mv	s1,a0
    8000441c:	00a05763          	blez	a0,8000442a <filewrite+0xbe>
        f->off += r;
    80004420:	02092783          	lw	a5,32(s2)
    80004424:	9fa9                	addw	a5,a5,a0
    80004426:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000442a:	01893503          	ld	a0,24(s2)
    8000442e:	ebffe0ef          	jal	800032ec <iunlock>
      end_op();
    80004432:	91bff0ef          	jal	80003d4c <end_op>

      if (r != n1) {
    80004436:	00999d63          	bne	s3,s1,80004450 <filewrite+0xe4>
        // error from writei
        break;
      }
      i += r;
    8000443a:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    8000443e:	015a5963          	bge	s4,s5,80004450 <filewrite+0xe4>
      int n1 = n - i;
    80004442:	414a87bb          	subw	a5,s5,s4
    80004446:	89be                	mv	s3,a5
      if (n1 > max)
    80004448:	fafbd8e3          	bge	s7,a5,800043f8 <filewrite+0x8c>
    8000444c:	89e6                	mv	s3,s9
    8000444e:	b76d                	j	800043f8 <filewrite+0x8c>
    }
    ret = (i == n ? n : -1);
    80004450:	054a9063          	bne	s5,s4,80004490 <filewrite+0x124>
    80004454:	8556                	mv	a0,s5
    80004456:	64a6                	ld	s1,72(sp)
    80004458:	79e2                	ld	s3,56(sp)
    8000445a:	7a42                	ld	s4,48(sp)
    8000445c:	6be2                	ld	s7,24(sp)
    8000445e:	6c42                	ld	s8,16(sp)
    80004460:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004462:	60e6                	ld	ra,88(sp)
    80004464:	6446                	ld	s0,80(sp)
    80004466:	6906                	ld	s2,64(sp)
    80004468:	7aa2                	ld	s5,40(sp)
    8000446a:	7b02                	ld	s6,32(sp)
    8000446c:	6125                	addi	sp,sp,96
    8000446e:	8082                	ret
    80004470:	e4a6                	sd	s1,72(sp)
    80004472:	fc4e                	sd	s3,56(sp)
    80004474:	f852                	sd	s4,48(sp)
    80004476:	ec5e                	sd	s7,24(sp)
    80004478:	e862                	sd	s8,16(sp)
    8000447a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000447c:	00003517          	auipc	a0,0x3
    80004480:	12c50513          	addi	a0,a0,300 # 800075a8 <etext+0x5a8>
    80004484:	bc4fc0ef          	jal	80000848 <panic>
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	bfe1                	j	80004462 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000448c:	8532                	mv	a0,a2
    8000448e:	bfd1                	j	80004462 <filewrite+0xf6>
    80004490:	557d                	li	a0,-1
    80004492:	64a6                	ld	s1,72(sp)
    80004494:	79e2                	ld	s3,56(sp)
    80004496:	7a42                	ld	s4,48(sp)
    80004498:	6be2                	ld	s7,24(sp)
    8000449a:	6c42                	ld	s8,16(sp)
    8000449c:	6ca2                	ld	s9,8(sp)
    8000449e:	b7d1                	j	80004462 <filewrite+0xf6>
    return -1;
    800044a0:	557d                	li	a0,-1
}
    800044a2:	8082                	ret

00000000800044a4 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044a4:	7179                	addi	sp,sp,-48
    800044a6:	f406                	sd	ra,40(sp)
    800044a8:	f022                	sd	s0,32(sp)
    800044aa:	ec26                	sd	s1,24(sp)
    800044ac:	e052                	sd	s4,0(sp)
    800044ae:	1800                	addi	s0,sp,48
    800044b0:	84aa                	mv	s1,a0
    800044b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044b4:	0005b023          	sd	zero,0(a1)
    800044b8:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044bc:	c17ff0ef          	jal	800040d2 <filealloc>
    800044c0:	e088                	sd	a0,0(s1)
    800044c2:	c549                	beqz	a0,8000454c <pipealloc+0xa8>
    800044c4:	c0fff0ef          	jal	800040d2 <filealloc>
    800044c8:	00aa3023          	sd	a0,0(s4)
    800044cc:	cd25                	beqz	a0,80004544 <pipealloc+0xa0>
    800044ce:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800044d0:	e8efc0ef          	jal	80000b5e <kalloc>
    800044d4:	892a                	mv	s2,a0
    800044d6:	c12d                	beqz	a0,80004538 <pipealloc+0x94>
    800044d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044da:	4985                	li	s3,1
    800044dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800044e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800044ec:	00003597          	auipc	a1,0x3
    800044f0:	0cc58593          	addi	a1,a1,204 # 800075b8 <etext+0x5b8>
    800044f4:	ec4fc0ef          	jal	80000bb8 <initlock>
  (*f0)->type = FD_PIPE;
    800044f8:	609c                	ld	a5,0(s1)
    800044fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800044fe:	609c                	ld	a5,0(s1)
    80004500:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004504:	609c                	ld	a5,0(s1)
    80004506:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000450a:	609c                	ld	a5,0(s1)
    8000450c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004510:	000a3783          	ld	a5,0(s4)
    80004514:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004518:	000a3783          	ld	a5,0(s4)
    8000451c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004520:	000a3783          	ld	a5,0(s4)
    80004524:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004528:	000a3783          	ld	a5,0(s4)
    8000452c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004530:	4501                	li	a0,0
    80004532:	6942                	ld	s2,16(sp)
    80004534:	69a2                	ld	s3,8(sp)
    80004536:	a00d                	j	80004558 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004538:	6088                	ld	a0,0(s1)
    8000453a:	c119                	beqz	a0,80004540 <pipealloc+0x9c>
    8000453c:	6942                	ld	s2,16(sp)
    8000453e:	a029                	j	80004548 <pipealloc+0xa4>
    80004540:	6942                	ld	s2,16(sp)
    80004542:	a029                	j	8000454c <pipealloc+0xa8>
    80004544:	6088                	ld	a0,0(s1)
    80004546:	c901                	beqz	a0,80004556 <pipealloc+0xb2>
    fileclose(*f0);
    80004548:	c2fff0ef          	jal	80004176 <fileclose>
  if (*f1)
    8000454c:	000a3503          	ld	a0,0(s4)
    80004550:	c119                	beqz	a0,80004556 <pipealloc+0xb2>
    fileclose(*f1);
    80004552:	c25ff0ef          	jal	80004176 <fileclose>
  return -1;
    80004556:	557d                	li	a0,-1
}
    80004558:	70a2                	ld	ra,40(sp)
    8000455a:	7402                	ld	s0,32(sp)
    8000455c:	64e2                	ld	s1,24(sp)
    8000455e:	6a02                	ld	s4,0(sp)
    80004560:	6145                	addi	sp,sp,48
    80004562:	8082                	ret

0000000080004564 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004564:	1101                	addi	sp,sp,-32
    80004566:	ec06                	sd	ra,24(sp)
    80004568:	e822                	sd	s0,16(sp)
    8000456a:	e426                	sd	s1,8(sp)
    8000456c:	e04a                	sd	s2,0(sp)
    8000456e:	1000                	addi	s0,sp,32
    80004570:	84aa                	mv	s1,a0
    80004572:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004574:	ec4fc0ef          	jal	80000c38 <acquire>
  if (writable) {
    80004578:	02090763          	beqz	s2,800045a6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000457c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004580:	21848513          	addi	a0,s1,536
    80004584:	a03fd0ef          	jal	80001f86 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004588:	2204a783          	lw	a5,544(s1)
    8000458c:	e781                	bnez	a5,80004594 <pipeclose+0x30>
    8000458e:	2244a783          	lw	a5,548(s1)
    80004592:	c38d                	beqz	a5,800045b4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    80004594:	8526                	mv	a0,s1
    80004596:	f26fc0ef          	jal	80000cbc <release>
}
    8000459a:	60e2                	ld	ra,24(sp)
    8000459c:	6442                	ld	s0,16(sp)
    8000459e:	64a2                	ld	s1,8(sp)
    800045a0:	6902                	ld	s2,0(sp)
    800045a2:	6105                	addi	sp,sp,32
    800045a4:	8082                	ret
    pi->readopen = 0;
    800045a6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045aa:	21c48513          	addi	a0,s1,540
    800045ae:	9d9fd0ef          	jal	80001f86 <wakeup>
    800045b2:	bfd9                	j	80004588 <pipeclose+0x24>
    release(&pi->lock);
    800045b4:	8526                	mv	a0,s1
    800045b6:	f06fc0ef          	jal	80000cbc <release>
    kfree((char *)pi);
    800045ba:	8526                	mv	a0,s1
    800045bc:	cbafc0ef          	jal	80000a76 <kfree>
    800045c0:	bfe9                	j	8000459a <pipeclose+0x36>

00000000800045c2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045c2:	7159                	addi	sp,sp,-112
    800045c4:	f486                	sd	ra,104(sp)
    800045c6:	f0a2                	sd	s0,96(sp)
    800045c8:	eca6                	sd	s1,88(sp)
    800045ca:	e8ca                	sd	s2,80(sp)
    800045cc:	e4ce                	sd	s3,72(sp)
    800045ce:	e0d2                	sd	s4,64(sp)
    800045d0:	fc56                	sd	s5,56(sp)
    800045d2:	1880                	addi	s0,sp,112
    800045d4:	84aa                	mv	s1,a0
    800045d6:	8aae                	mv	s5,a1
    800045d8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045da:	b48fd0ef          	jal	80001922 <myproc>
    800045de:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045e0:	8526                	mv	a0,s1
    800045e2:	e56fc0ef          	jal	80000c38 <acquire>
  while (i < n) {
    800045e6:	0f405a63          	blez	s4,800046da <pipewrite+0x118>
    800045ea:	f85a                	sd	s6,48(sp)
    800045ec:	f45e                	sd	s7,40(sp)
    800045ee:	f062                	sd	s8,32(sp)
    800045f0:	ec66                	sd	s9,24(sp)
    800045f2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800045f4:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800045f6:	f9f40c13          	addi	s8,s0,-97
    800045fa:	4b85                	li	s7,1
    800045fc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800045fe:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    80004602:	21c48c93          	addi	s9,s1,540
    80004606:	a0a1                	j	8000464e <pipewrite+0x8c>
      release(&pi->lock);
    80004608:	8526                	mv	a0,s1
    8000460a:	eb2fc0ef          	jal	80000cbc <release>
      return -1;
    8000460e:	597d                	li	s2,-1
    80004610:	7b42                	ld	s6,48(sp)
    80004612:	7ba2                	ld	s7,40(sp)
    80004614:	7c02                	ld	s8,32(sp)
    80004616:	6ce2                	ld	s9,24(sp)
    80004618:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000461a:	854a                	mv	a0,s2
    8000461c:	70a6                	ld	ra,104(sp)
    8000461e:	7406                	ld	s0,96(sp)
    80004620:	64e6                	ld	s1,88(sp)
    80004622:	6946                	ld	s2,80(sp)
    80004624:	69a6                	ld	s3,72(sp)
    80004626:	6a06                	ld	s4,64(sp)
    80004628:	7ae2                	ld	s5,56(sp)
    8000462a:	6165                	addi	sp,sp,112
    8000462c:	8082                	ret
      wakeup(&pi->nread);
    8000462e:	856a                	mv	a0,s10
    80004630:	957fd0ef          	jal	80001f86 <wakeup>
      sleep_prepare(&pi->nwrite);
    80004634:	8566                	mv	a0,s9
    80004636:	8e5fd0ef          	jal	80001f1a <sleep_prepare>
      release(&pi->lock);
    8000463a:	8526                	mv	a0,s1
    8000463c:	e80fc0ef          	jal	80000cbc <release>
      sleep();
    80004640:	917fd0ef          	jal	80001f56 <sleep>
      acquire(&pi->lock);
    80004644:	8526                	mv	a0,s1
    80004646:	df2fc0ef          	jal	80000c38 <acquire>
  while (i < n) {
    8000464a:	07495b63          	bge	s2,s4,800046c0 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    8000464e:	2204a783          	lw	a5,544(s1)
    80004652:	dbdd                	beqz	a5,80004608 <pipewrite+0x46>
    80004654:	854e                	mv	a0,s3
    80004656:	b1ffd0ef          	jal	80002174 <killed>
    8000465a:	f55d                	bnez	a0,80004608 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    8000465c:	2184a783          	lw	a5,536(s1)
    80004660:	21c4a703          	lw	a4,540(s1)
    80004664:	2007879b          	addiw	a5,a5,512
    80004668:	fcf703e3          	beq	a4,a5,8000462e <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000466c:	875e                	mv	a4,s7
    8000466e:	015906b3          	add	a3,s2,s5
    80004672:	8662                	mv	a2,s8
    80004674:	0489b583          	ld	a1,72(s3)
    80004678:	0509b503          	ld	a0,80(s3)
    8000467c:	fb1fc0ef          	jal	8000162c <copyin>
    80004680:	03650163          	beq	a0,s6,800046a2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004684:	21c4a783          	lw	a5,540(s1)
    80004688:	0017871b          	addiw	a4,a5,1
    8000468c:	20e4ae23          	sw	a4,540(s1)
    80004690:	1ff7f793          	andi	a5,a5,511
    80004694:	97a6                	add	a5,a5,s1
    80004696:	f9f44703          	lbu	a4,-97(s0)
    8000469a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000469e:	2905                	addiw	s2,s2,1
    800046a0:	b76d                	j	8000464a <pipewrite+0x88>
        if (i == 0)
    800046a2:	00090863          	beqz	s2,800046b2 <pipewrite+0xf0>
    800046a6:	7b42                	ld	s6,48(sp)
    800046a8:	7ba2                	ld	s7,40(sp)
    800046aa:	7c02                	ld	s8,32(sp)
    800046ac:	6ce2                	ld	s9,24(sp)
    800046ae:	6d42                	ld	s10,16(sp)
    800046b0:	a829                	j	800046ca <pipewrite+0x108>
          i = -1;
    800046b2:	892a                	mv	s2,a0
        break;
    800046b4:	7b42                	ld	s6,48(sp)
    800046b6:	7ba2                	ld	s7,40(sp)
    800046b8:	7c02                	ld	s8,32(sp)
    800046ba:	6ce2                	ld	s9,24(sp)
    800046bc:	6d42                	ld	s10,16(sp)
    800046be:	a031                	j	800046ca <pipewrite+0x108>
    800046c0:	7b42                	ld	s6,48(sp)
    800046c2:	7ba2                	ld	s7,40(sp)
    800046c4:	7c02                	ld	s8,32(sp)
    800046c6:	6ce2                	ld	s9,24(sp)
    800046c8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800046ca:	21848513          	addi	a0,s1,536
    800046ce:	8b9fd0ef          	jal	80001f86 <wakeup>
  release(&pi->lock);
    800046d2:	8526                	mv	a0,s1
    800046d4:	de8fc0ef          	jal	80000cbc <release>
  return i;
    800046d8:	b789                	j	8000461a <pipewrite+0x58>
  int i = 0;
    800046da:	4901                	li	s2,0
    800046dc:	b7fd                	j	800046ca <pipewrite+0x108>

00000000800046de <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046de:	711d                	addi	sp,sp,-96
    800046e0:	ec86                	sd	ra,88(sp)
    800046e2:	e8a2                	sd	s0,80(sp)
    800046e4:	e4a6                	sd	s1,72(sp)
    800046e6:	e0ca                	sd	s2,64(sp)
    800046e8:	fc4e                	sd	s3,56(sp)
    800046ea:	f852                	sd	s4,48(sp)
    800046ec:	f456                	sd	s5,40(sp)
    800046ee:	1080                	addi	s0,sp,96
    800046f0:	84aa                	mv	s1,a0
    800046f2:	89ae                	mv	s3,a1
    800046f4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046f6:	a2cfd0ef          	jal	80001922 <myproc>
    800046fa:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    800046fc:	8526                	mv	a0,s1
    800046fe:	d3afc0ef          	jal	80000c38 <acquire>
  while (n > 0 && pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004702:	0d505263          	blez	s5,800047c6 <piperead+0xe8>
    80004706:	2184a703          	lw	a4,536(s1)
    8000470a:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    8000470e:	21848a13          	addi	s4,s1,536
  while (n > 0 && pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004712:	02f71e63          	bne	a4,a5,8000474e <piperead+0x70>
    80004716:	2244a783          	lw	a5,548(s1)
    8000471a:	c3b9                	beqz	a5,80004760 <piperead+0x82>
    if (killed(pr)) {
    8000471c:	854a                	mv	a0,s2
    8000471e:	a57fd0ef          	jal	80002174 <killed>
    80004722:	e915                	bnez	a0,80004756 <piperead+0x78>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004724:	8552                	mv	a0,s4
    80004726:	ff4fd0ef          	jal	80001f1a <sleep_prepare>
    release(&pi->lock);
    8000472a:	8526                	mv	a0,s1
    8000472c:	d90fc0ef          	jal	80000cbc <release>
    sleep();
    80004730:	827fd0ef          	jal	80001f56 <sleep>
    acquire(&pi->lock);
    80004734:	8526                	mv	a0,s1
    80004736:	d02fc0ef          	jal	80000c38 <acquire>
  while (n > 0 && pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000473a:	2184a703          	lw	a4,536(s1)
    8000473e:	21c4a783          	lw	a5,540(s1)
    80004742:	fcf70ae3          	beq	a4,a5,80004716 <piperead+0x38>
    80004746:	f05a                	sd	s6,32(sp)
    80004748:	ec5e                	sd	s7,24(sp)
    8000474a:	e862                	sd	s8,16(sp)
    8000474c:	a829                	j	80004766 <piperead+0x88>
    8000474e:	f05a                	sd	s6,32(sp)
    80004750:	ec5e                	sd	s7,24(sp)
    80004752:	e862                	sd	s8,16(sp)
    80004754:	a809                	j	80004766 <piperead+0x88>
      release(&pi->lock);
    80004756:	8526                	mv	a0,s1
    80004758:	d64fc0ef          	jal	80000cbc <release>
      return -1;
    8000475c:	5a7d                	li	s4,-1
    8000475e:	a8a5                	j	800047d6 <piperead+0xf8>
    80004760:	f05a                	sd	s6,32(sp)
    80004762:	ec5e                	sd	s7,24(sp)
    80004764:	e862                	sd	s8,16(sp)
{
    80004766:	4a01                	li	s4,0
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004768:	faf40c13          	addi	s8,s0,-81
    8000476c:	4b85                	li	s7,1
    8000476e:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    80004770:	2184a783          	lw	a5,536(s1)
    80004774:	21c4a703          	lw	a4,540(s1)
    80004778:	06f70e63          	beq	a4,a5,800047f4 <piperead+0x116>
    ch = pi->data[pi->nread % PIPESIZE];
    8000477c:	1ff7f793          	andi	a5,a5,511
    80004780:	97a6                	add	a5,a5,s1
    80004782:	0187c783          	lbu	a5,24(a5)
    80004786:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    8000478a:	875e                	mv	a4,s7
    8000478c:	86e2                	mv	a3,s8
    8000478e:	864e                	mv	a2,s3
    80004790:	04893583          	ld	a1,72(s2)
    80004794:	05093503          	ld	a0,80(s2)
    80004798:	dd5fc0ef          	jal	8000156c <copyout>
    8000479c:	01650f63          	beq	a0,s6,800047ba <piperead+0xdc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800047a0:	2184a783          	lw	a5,536(s1)
    800047a4:	2785                	addiw	a5,a5,1
    800047a6:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800047aa:	2a05                	addiw	s4,s4,1
    800047ac:	0985                	addi	s3,s3,1
    800047ae:	fd4a91e3          	bne	s5,s4,80004770 <piperead+0x92>
    800047b2:	7b02                	ld	s6,32(sp)
    800047b4:	6be2                	ld	s7,24(sp)
    800047b6:	6c42                	ld	s8,16(sp)
    800047b8:	a801                	j	800047c8 <piperead+0xea>
      if (i == 0)
    800047ba:	020a0863          	beqz	s4,800047ea <piperead+0x10c>
    800047be:	7b02                	ld	s6,32(sp)
    800047c0:	6be2                	ld	s7,24(sp)
    800047c2:	6c42                	ld	s8,16(sp)
    800047c4:	a011                	j	800047c8 <piperead+0xea>
  while (n > 0 && pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800047c6:	4a01                	li	s4,0
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800047c8:	21c48513          	addi	a0,s1,540
    800047cc:	fbafd0ef          	jal	80001f86 <wakeup>
  release(&pi->lock);
    800047d0:	8526                	mv	a0,s1
    800047d2:	ceafc0ef          	jal	80000cbc <release>
  return i;
}
    800047d6:	8552                	mv	a0,s4
    800047d8:	60e6                	ld	ra,88(sp)
    800047da:	6446                	ld	s0,80(sp)
    800047dc:	64a6                	ld	s1,72(sp)
    800047de:	6906                	ld	s2,64(sp)
    800047e0:	79e2                	ld	s3,56(sp)
    800047e2:	7a42                	ld	s4,48(sp)
    800047e4:	7aa2                	ld	s5,40(sp)
    800047e6:	6125                	addi	sp,sp,96
    800047e8:	8082                	ret
        i = -1;
    800047ea:	8a2a                	mv	s4,a0
    800047ec:	7b02                	ld	s6,32(sp)
    800047ee:	6be2                	ld	s7,24(sp)
    800047f0:	6c42                	ld	s8,16(sp)
    800047f2:	bfd9                	j	800047c8 <piperead+0xea>
    800047f4:	7b02                	ld	s6,32(sp)
    800047f6:	6be2                	ld	s7,24(sp)
    800047f8:	6c42                	ld	s8,16(sp)
    800047fa:	b7f9                	j	800047c8 <piperead+0xea>

00000000800047fc <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800047fc:	1141                	addi	sp,sp,-16
    800047fe:	e406                	sd	ra,8(sp)
    80004800:	e022                	sd	s0,0(sp)
    80004802:	0800                	addi	s0,sp,16
    80004804:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004806:	0035151b          	slliw	a0,a0,0x3
    8000480a:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    8000480c:	8b89                	andi	a5,a5,2
    8000480e:	c399                	beqz	a5,80004814 <flags2perm+0x18>
    perm |= PTE_W;
    80004810:	00456513          	ori	a0,a0,4
  return perm;
}
    80004814:	60a2                	ld	ra,8(sp)
    80004816:	6402                	ld	s0,0(sp)
    80004818:	0141                	addi	sp,sp,16
    8000481a:	8082                	ret

000000008000481c <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000481c:	df010113          	addi	sp,sp,-528
    80004820:	20113423          	sd	ra,520(sp)
    80004824:	20813023          	sd	s0,512(sp)
    80004828:	ffa6                	sd	s1,504(sp)
    8000482a:	fbca                	sd	s2,496(sp)
    8000482c:	0c00                	addi	s0,sp,528
    8000482e:	892a                	mv	s2,a0
    80004830:	e0a43023          	sd	a0,-512(s0)
    80004834:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004838:	8eafd0ef          	jal	80001922 <myproc>
    8000483c:	84aa                	mv	s1,a0

  begin_op();
    8000483e:	c82ff0ef          	jal	80003cc0 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004842:	854a                	mv	a0,s2
    80004844:	a9eff0ef          	jal	80003ae2 <namei>
    80004848:	c931                	beqz	a0,8000489c <kexec+0x80>
    8000484a:	f3d2                	sd	s4,480(sp)
    8000484c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000484e:	9f1fe0ef          	jal	8000323e <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004852:	04000713          	li	a4,64
    80004856:	4681                	li	a3,0
    80004858:	e5040613          	addi	a2,s0,-432
    8000485c:	4581                	li	a1,0
    8000485e:	8552                	mv	a0,s4
    80004860:	db9fe0ef          	jal	80003618 <readi>
    80004864:	04000793          	li	a5,64
    80004868:	00f51a63          	bne	a0,a5,8000487c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    8000486c:	e5042703          	lw	a4,-432(s0)
    80004870:	464c47b7          	lui	a5,0x464c4
    80004874:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004878:	02f70563          	beq	a4,a5,800048a2 <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000487c:	8552                	mv	a0,s4
    8000487e:	c15fe0ef          	jal	80003492 <iunlockput>
    end_op();
    80004882:	ccaff0ef          	jal	80003d4c <end_op>
    80004886:	7a1e                	ld	s4,480(sp)
    return -1;
    80004888:	557d                	li	a0,-1
  }
  return -1;
}
    8000488a:	20813083          	ld	ra,520(sp)
    8000488e:	20013403          	ld	s0,512(sp)
    80004892:	74fe                	ld	s1,504(sp)
    80004894:	795e                	ld	s2,496(sp)
    80004896:	21010113          	addi	sp,sp,528
    8000489a:	8082                	ret
    end_op();
    8000489c:	cb0ff0ef          	jal	80003d4c <end_op>
    return -1;
    800048a0:	b7e5                	j	80004888 <kexec+0x6c>
    800048a2:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    800048a4:	8526                	mv	a0,s1
    800048a6:	982fd0ef          	jal	80001a28 <proc_pagetable>
    800048aa:	8b2a                	mv	s6,a0
    800048ac:	26050263          	beqz	a0,80004b10 <kexec+0x2f4>
    800048b0:	f7ce                	sd	s3,488(sp)
    800048b2:	efd6                	sd	s5,472(sp)
    800048b4:	e7de                	sd	s7,456(sp)
    800048b6:	e3e2                	sd	s8,448(sp)
    800048b8:	ff66                	sd	s9,440(sp)
    800048ba:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048bc:	e8845783          	lhu	a5,-376(s0)
    800048c0:	12078763          	beqz	a5,800049ee <kexec+0x1d2>
    800048c4:	f76e                	sd	s11,424(sp)
    800048c6:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048ca:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048cc:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048ce:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800048d2:	6c85                	lui	s9,0x1
    800048d4:	6a85                	lui	s5,0x1
    800048d6:	a085                	j	80004936 <kexec+0x11a>
      panic("loadseg: address should exist");
    800048d8:	00003517          	auipc	a0,0x3
    800048dc:	ce850513          	addi	a0,a0,-792 # 800075c0 <etext+0x5c0>
    800048e0:	f69fb0ef          	jal	80000848 <panic>
    if (sz - i < PGSIZE)
    800048e4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800048e6:	874a                	mv	a4,s2
    800048e8:	009b86bb          	addw	a3,s7,s1
    800048ec:	4581                	li	a1,0
    800048ee:	8552                	mv	a0,s4
    800048f0:	d29fe0ef          	jal	80003618 <readi>
    800048f4:	22a91263          	bne	s2,a0,80004b18 <kexec+0x2fc>
  for (i = 0; i < sz; i += PGSIZE) {
    800048f8:	009a84bb          	addw	s1,s5,s1
    800048fc:	0334f263          	bgeu	s1,s3,80004920 <kexec+0x104>
    pa = walkaddr(pagetable, va + i);
    80004900:	02049593          	slli	a1,s1,0x20
    80004904:	9181                	srli	a1,a1,0x20
    80004906:	95e2                	add	a1,a1,s8
    80004908:	855a                	mv	a0,s6
    8000490a:	f0efc0ef          	jal	80001018 <walkaddr>
    8000490e:	862a                	mv	a2,a0
    if (pa == 0)
    80004910:	d561                	beqz	a0,800048d8 <kexec+0xbc>
    if (sz - i < PGSIZE)
    80004912:	409987bb          	subw	a5,s3,s1
    80004916:	893e                	mv	s2,a5
    80004918:	fcfcf6e3          	bgeu	s9,a5,800048e4 <kexec+0xc8>
    8000491c:	8956                	mv	s2,s5
    8000491e:	b7d9                	j	800048e4 <kexec+0xc8>
    sz = sz1;
    80004920:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004924:	2d05                	addiw	s10,s10,1
    80004926:	e0843783          	ld	a5,-504(s0)
    8000492a:	0387869b          	addiw	a3,a5,56
    8000492e:	e8845783          	lhu	a5,-376(s0)
    80004932:	06fd5863          	bge	s10,a5,800049a2 <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004936:	e0d43423          	sd	a3,-504(s0)
    8000493a:	876e                	mv	a4,s11
    8000493c:	e1840613          	addi	a2,s0,-488
    80004940:	4581                	li	a1,0
    80004942:	8552                	mv	a0,s4
    80004944:	cd5fe0ef          	jal	80003618 <readi>
    80004948:	1db51663          	bne	a0,s11,80004b14 <kexec+0x2f8>
    if (ph.type != ELF_PROG_LOAD)
    8000494c:	e1842783          	lw	a5,-488(s0)
    80004950:	4705                	li	a4,1
    80004952:	fce799e3          	bne	a5,a4,80004924 <kexec+0x108>
    if (ph.memsz < ph.filesz)
    80004956:	e4043483          	ld	s1,-448(s0)
    8000495a:	e3843783          	ld	a5,-456(s0)
    8000495e:	1af4eb63          	bltu	s1,a5,80004b14 <kexec+0x2f8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004962:	e2843783          	ld	a5,-472(s0)
    80004966:	94be                	add	s1,s1,a5
    80004968:	1af4e663          	bltu	s1,a5,80004b14 <kexec+0x2f8>
    if (ph.vaddr % PGSIZE != 0)
    8000496c:	17d2                	slli	a5,a5,0x34
    8000496e:	1a079363          	bnez	a5,80004b14 <kexec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004972:	e1c42503          	lw	a0,-484(s0)
    80004976:	e87ff0ef          	jal	800047fc <flags2perm>
    8000497a:	86aa                	mv	a3,a0
    8000497c:	8626                	mv	a2,s1
    8000497e:	85ca                	mv	a1,s2
    80004980:	855a                	mv	a0,s6
    80004982:	965fc0ef          	jal	800012e6 <uvmalloc>
    80004986:	dea43823          	sd	a0,-528(s0)
    8000498a:	18050563          	beqz	a0,80004b14 <kexec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000498e:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004992:	f80987e3          	beqz	s3,80004920 <kexec+0x104>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004996:	e2843c03          	ld	s8,-472(s0)
    8000499a:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000499e:	4481                	li	s1,0
    800049a0:	b785                	j	80004900 <kexec+0xe4>
    800049a2:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800049a4:	8552                	mv	a0,s4
    800049a6:	aedfe0ef          	jal	80003492 <iunlockput>
  end_op();
    800049aa:	ba2ff0ef          	jal	80003d4c <end_op>
  p = myproc();
    800049ae:	f75fc0ef          	jal	80001922 <myproc>
    800049b2:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    800049b4:	04853a03          	ld	s4,72(a0)
  sz = PGROUNDUP(sz);
    800049b8:	6485                	lui	s1,0x1
    800049ba:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    800049bc:	94ca                	add	s1,s1,s2
    800049be:	77fd                	lui	a5,0xfffff
    800049c0:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    800049c2:	4691                	li	a3,4
    800049c4:	6609                	lui	a2,0x2
    800049c6:	9626                	add	a2,a2,s1
    800049c8:	85a6                	mv	a1,s1
    800049ca:	855a                	mv	a0,s6
    800049cc:	91bfc0ef          	jal	800012e6 <uvmalloc>
    800049d0:	8aaa                	mv	s5,a0
    800049d2:	e105                	bnez	a0,800049f2 <kexec+0x1d6>
    proc_freepagetable(pagetable, sz);
    800049d4:	85a6                	mv	a1,s1
    800049d6:	855a                	mv	a0,s6
    800049d8:	8d2fd0ef          	jal	80001aaa <proc_freepagetable>
  if (ip) {
    800049dc:	79be                	ld	s3,488(sp)
    800049de:	7a1e                	ld	s4,480(sp)
    800049e0:	6afe                	ld	s5,472(sp)
    800049e2:	6b5e                	ld	s6,464(sp)
    800049e4:	6bbe                	ld	s7,456(sp)
    800049e6:	6c1e                	ld	s8,448(sp)
    800049e8:	7cfa                	ld	s9,440(sp)
    800049ea:	7d5a                	ld	s10,432(sp)
    800049ec:	bd71                	j	80004888 <kexec+0x6c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800049ee:	4901                	li	s2,0
    800049f0:	bf55                	j	800049a4 <kexec+0x188>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    800049f2:	75f9                	lui	a1,0xffffe
    800049f4:	95aa                	add	a1,a1,a0
    800049f6:	855a                	mv	a0,s6
    800049f8:	ab7fc0ef          	jal	800014ae <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    800049fc:	7bfd                	lui	s7,0xfffff
    800049fe:	9bd6                	add	s7,s7,s5
  for (argc = 0; argv[argc]; argc++) {
    80004a00:	df843783          	ld	a5,-520(s0)
    80004a04:	6388                	ld	a0,0(a5)
    80004a06:	cd3d                	beqz	a0,80004a84 <kexec+0x268>
  sp = sz;
    80004a08:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004a0a:	4481                	li	s1,0
    ustack[argc] = sp;
    80004a0c:	e9040913          	addi	s2,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004a10:	c64fc0ef          	jal	80000e74 <strlen>
    80004a14:	0015079b          	addiw	a5,a0,1
    80004a18:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a1c:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004a20:	077c6063          	bltu	s8,s7,80004a80 <kexec+0x264>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a24:	df843d03          	ld	s10,-520(s0)
    80004a28:	000d3c83          	ld	s9,0(s10)
    80004a2c:	8566                	mv	a0,s9
    80004a2e:	c46fc0ef          	jal	80000e74 <strlen>
    80004a32:	0015071b          	addiw	a4,a0,1
    80004a36:	86e6                	mv	a3,s9
    80004a38:	8662                	mv	a2,s8
    80004a3a:	85d6                	mv	a1,s5
    80004a3c:	855a                	mv	a0,s6
    80004a3e:	b2ffc0ef          	jal	8000156c <copyout>
    80004a42:	02054f63          	bltz	a0,80004a80 <kexec+0x264>
    ustack[argc] = sp;
    80004a46:	00349793          	slli	a5,s1,0x3
    80004a4a:	97ca                	add	a5,a5,s2
    80004a4c:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffde468>
  for (argc = 0; argv[argc]; argc++) {
    80004a50:	0485                	addi	s1,s1,1
    80004a52:	008d0793          	addi	a5,s10,8
    80004a56:	def43c23          	sd	a5,-520(s0)
    80004a5a:	008d3503          	ld	a0,8(s10)
    80004a5e:	f94d                	bnez	a0,80004a10 <kexec+0x1f4>
  ustack[argc] = 0;
    80004a60:	00349793          	slli	a5,s1,0x3
    80004a64:	f9040713          	addi	a4,s0,-112
    80004a68:	97ba                	add	a5,a5,a4
    80004a6a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004a6e:	00148713          	addi	a4,s1,1
    80004a72:	070e                	slli	a4,a4,0x3
    80004a74:	40ec0933          	sub	s2,s8,a4
  sp -= sp % 16;
    80004a78:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004a7c:	01797763          	bgeu	s2,s7,80004a8a <kexec+0x26e>
  sz = sz1;
    80004a80:	84d6                	mv	s1,s5
    80004a82:	bf89                	j	800049d4 <kexec+0x1b8>
  sp = sz;
    80004a84:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004a86:	4481                	li	s1,0
    80004a88:	bfe1                	j	80004a60 <kexec+0x244>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004a8a:	e9040693          	addi	a3,s0,-368
    80004a8e:	864a                	mv	a2,s2
    80004a90:	85d6                	mv	a1,s5
    80004a92:	855a                	mv	a0,s6
    80004a94:	ad9fc0ef          	jal	8000156c <copyout>
    80004a98:	fe0544e3          	bltz	a0,80004a80 <kexec+0x264>
  p->trapframe->a1 = sp;
    80004a9c:	0589b783          	ld	a5,88(s3)
    80004aa0:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004aa4:	e0043783          	ld	a5,-512(s0)
    80004aa8:	0007c703          	lbu	a4,0(a5)
    80004aac:	cf11                	beqz	a4,80004ac8 <kexec+0x2ac>
    80004aae:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004ab0:	02f00693          	li	a3,47
    80004ab4:	a029                	j	80004abe <kexec+0x2a2>
  for (last = s = path; *s; s++)
    80004ab6:	0785                	addi	a5,a5,1
    80004ab8:	fff7c703          	lbu	a4,-1(a5)
    80004abc:	c711                	beqz	a4,80004ac8 <kexec+0x2ac>
    if (*s == '/')
    80004abe:	fed71ce3          	bne	a4,a3,80004ab6 <kexec+0x29a>
      last = s + 1;
    80004ac2:	e0f43023          	sd	a5,-512(s0)
    80004ac6:	bfc5                	j	80004ab6 <kexec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ac8:	4641                	li	a2,16
    80004aca:	e0043583          	ld	a1,-512(s0)
    80004ace:	15898513          	addi	a0,s3,344
    80004ad2:	b6cfc0ef          	jal	80000e3e <safestrcpy>
  oldpagetable = p->pagetable;
    80004ad6:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004ada:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004ade:	0559b423          	sd	s5,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004ae2:	0589b783          	ld	a5,88(s3)
    80004ae6:	e6843703          	ld	a4,-408(s0)
    80004aea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004aec:	0589b783          	ld	a5,88(s3)
    80004af0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004af4:	85d2                	mv	a1,s4
    80004af6:	fb5fc0ef          	jal	80001aaa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004afa:	0004851b          	sext.w	a0,s1
    80004afe:	79be                	ld	s3,488(sp)
    80004b00:	7a1e                	ld	s4,480(sp)
    80004b02:	6afe                	ld	s5,472(sp)
    80004b04:	6b5e                	ld	s6,464(sp)
    80004b06:	6bbe                	ld	s7,456(sp)
    80004b08:	6c1e                	ld	s8,448(sp)
    80004b0a:	7cfa                	ld	s9,440(sp)
    80004b0c:	7d5a                	ld	s10,432(sp)
    80004b0e:	bbb5                	j	8000488a <kexec+0x6e>
    80004b10:	6b5e                	ld	s6,464(sp)
    80004b12:	b3ad                	j	8000487c <kexec+0x60>
    return -1;
    80004b14:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004b18:	df043583          	ld	a1,-528(s0)
    80004b1c:	855a                	mv	a0,s6
    80004b1e:	f8dfc0ef          	jal	80001aaa <proc_freepagetable>
  if (ip) {
    80004b22:	79be                	ld	s3,488(sp)
    80004b24:	6afe                	ld	s5,472(sp)
    80004b26:	6b5e                	ld	s6,464(sp)
    80004b28:	6bbe                	ld	s7,456(sp)
    80004b2a:	6c1e                	ld	s8,448(sp)
    80004b2c:	7cfa                	ld	s9,440(sp)
    80004b2e:	7d5a                	ld	s10,432(sp)
    80004b30:	7dba                	ld	s11,424(sp)
    80004b32:	b3a9                	j	8000487c <kexec+0x60>

0000000080004b34 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b34:	7179                	addi	sp,sp,-48
    80004b36:	f406                	sd	ra,40(sp)
    80004b38:	f022                	sd	s0,32(sp)
    80004b3a:	ec26                	sd	s1,24(sp)
    80004b3c:	e84a                	sd	s2,16(sp)
    80004b3e:	1800                	addi	s0,sp,48
    80004b40:	892e                	mv	s2,a1
    80004b42:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b44:	fdc40593          	addi	a1,s0,-36
    80004b48:	cfbfd0ef          	jal	80002842 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004b4c:	fdc42703          	lw	a4,-36(s0)
    80004b50:	47bd                	li	a5,15
    80004b52:	02e7e963          	bltu	a5,a4,80004b84 <argfd+0x50>
    80004b56:	dcdfc0ef          	jal	80001922 <myproc>
    80004b5a:	fdc42703          	lw	a4,-36(s0)
    80004b5e:	01a70793          	addi	a5,a4,26
    80004b62:	078e                	slli	a5,a5,0x3
    80004b64:	953e                	add	a0,a0,a5
    80004b66:	611c                	ld	a5,0(a0)
    80004b68:	cf91                	beqz	a5,80004b84 <argfd+0x50>
    return -1;
  if (pfd)
    80004b6a:	00090463          	beqz	s2,80004b72 <argfd+0x3e>
    *pfd = fd;
    80004b6e:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004b72:	c091                	beqz	s1,80004b76 <argfd+0x42>
    *pf = f;
    80004b74:	e09c                	sd	a5,0(s1)
  return 0;
    80004b76:	4501                	li	a0,0
}
    80004b78:	70a2                	ld	ra,40(sp)
    80004b7a:	7402                	ld	s0,32(sp)
    80004b7c:	64e2                	ld	s1,24(sp)
    80004b7e:	6942                	ld	s2,16(sp)
    80004b80:	6145                	addi	sp,sp,48
    80004b82:	8082                	ret
    return -1;
    80004b84:	557d                	li	a0,-1
    80004b86:	bfcd                	j	80004b78 <argfd+0x44>

0000000080004b88 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b88:	1101                	addi	sp,sp,-32
    80004b8a:	ec06                	sd	ra,24(sp)
    80004b8c:	e822                	sd	s0,16(sp)
    80004b8e:	e426                	sd	s1,8(sp)
    80004b90:	1000                	addi	s0,sp,32
    80004b92:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b94:	d8ffc0ef          	jal	80001922 <myproc>
    80004b98:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004b9a:	0d050793          	addi	a5,a0,208
    80004b9e:	4501                	li	a0,0
    80004ba0:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004ba2:	6398                	ld	a4,0(a5)
    80004ba4:	cb19                	beqz	a4,80004bba <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004ba6:	2505                	addiw	a0,a0,1
    80004ba8:	07a1                	addi	a5,a5,8
    80004baa:	fed51ce3          	bne	a0,a3,80004ba2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004bae:	557d                	li	a0,-1
}
    80004bb0:	60e2                	ld	ra,24(sp)
    80004bb2:	6442                	ld	s0,16(sp)
    80004bb4:	64a2                	ld	s1,8(sp)
    80004bb6:	6105                	addi	sp,sp,32
    80004bb8:	8082                	ret
      p->ofile[fd] = f;
    80004bba:	01a50793          	addi	a5,a0,26
    80004bbe:	078e                	slli	a5,a5,0x3
    80004bc0:	963e                	add	a2,a2,a5
    80004bc2:	e204                	sd	s1,0(a2)
      return fd;
    80004bc4:	b7f5                	j	80004bb0 <fdalloc+0x28>

0000000080004bc6 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004bc6:	715d                	addi	sp,sp,-80
    80004bc8:	e486                	sd	ra,72(sp)
    80004bca:	e0a2                	sd	s0,64(sp)
    80004bcc:	fc26                	sd	s1,56(sp)
    80004bce:	f84a                	sd	s2,48(sp)
    80004bd0:	f44e                	sd	s3,40(sp)
    80004bd2:	ec56                	sd	s5,24(sp)
    80004bd4:	e85a                	sd	s6,16(sp)
    80004bd6:	0880                	addi	s0,sp,80
    80004bd8:	89ae                	mv	s3,a1
    80004bda:	8ab2                	mv	s5,a2
    80004bdc:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004bde:	fb040593          	addi	a1,s0,-80
    80004be2:	f1bfe0ef          	jal	80003afc <nameiparent>
    80004be6:	84aa                	mv	s1,a0
    return 0;
    80004be8:	892a                	mv	s2,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004bea:	cd31                	beqz	a0,80004c46 <create+0x80>

  ilock(dp);
    80004bec:	e52fe0ef          	jal	8000323e <ilock>

  if (dp->nlink == 0) {
    80004bf0:	04a49783          	lh	a5,74(s1)
    80004bf4:	c3bd                	beqz	a5,80004c5a <create+0x94>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004bf6:	7761                	lui	a4,0xffff8
    80004bf8:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd7469>
    80004bfa:	97ba                	add	a5,a5,a4
    80004bfc:	0017b793          	seqz	a5,a5
    80004c00:	fff98713          	addi	a4,s3,-1
    80004c04:	00173713          	seqz	a4,a4
    80004c08:	8ff9                	and	a5,a5,a4
    80004c0a:	efa1                	bnez	a5,80004c62 <create+0x9c>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004c0c:	4601                	li	a2,0
    80004c0e:	fb040593          	addi	a1,s0,-80
    80004c12:	8526                	mv	a0,s1
    80004c14:	c15fe0ef          	jal	80003828 <dirlookup>
    80004c18:	892a                	mv	s2,a0
    80004c1a:	c921                	beqz	a0,80004c6a <create+0xa4>
    iunlockput(dp);
    80004c1c:	8526                	mv	a0,s1
    80004c1e:	875fe0ef          	jal	80003492 <iunlockput>
    ilock(ip);
    80004c22:	854a                	mv	a0,s2
    80004c24:	e1afe0ef          	jal	8000323e <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c28:	4789                	li	a5,2
    80004c2a:	00f99a63          	bne	s3,a5,80004c3e <create+0x78>
    80004c2e:	04495783          	lhu	a5,68(s2)
    80004c32:	37f9                	addiw	a5,a5,-2
    80004c34:	17c2                	slli	a5,a5,0x30
    80004c36:	93c1                	srli	a5,a5,0x30
    80004c38:	4705                	li	a4,1
    80004c3a:	00f77663          	bgeu	a4,a5,80004c46 <create+0x80>
      return ip;
    iunlockput(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	853fe0ef          	jal	80003492 <iunlockput>
    return 0;
    80004c44:	4901                	li	s2,0
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c46:	854a                	mv	a0,s2
    80004c48:	60a6                	ld	ra,72(sp)
    80004c4a:	6406                	ld	s0,64(sp)
    80004c4c:	74e2                	ld	s1,56(sp)
    80004c4e:	7942                	ld	s2,48(sp)
    80004c50:	79a2                	ld	s3,40(sp)
    80004c52:	6ae2                	ld	s5,24(sp)
    80004c54:	6b42                	ld	s6,16(sp)
    80004c56:	6161                	addi	sp,sp,80
    80004c58:	8082                	ret
    iunlockput(dp);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	837fe0ef          	jal	80003492 <iunlockput>
    return 0;
    80004c60:	b7d5                	j	80004c44 <create+0x7e>
    iunlockput(dp);
    80004c62:	8526                	mv	a0,s1
    80004c64:	82ffe0ef          	jal	80003492 <iunlockput>
    return 0;
    80004c68:	bff1                	j	80004c44 <create+0x7e>
    80004c6a:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004c6c:	85ce                	mv	a1,s3
    80004c6e:	4088                	lw	a0,0(s1)
    80004c70:	c5efe0ef          	jal	800030ce <ialloc>
    80004c74:	8a2a                	mv	s4,a0
    80004c76:	cd1d                	beqz	a0,80004cb4 <create+0xee>
  ilock(ip);
    80004c78:	dc6fe0ef          	jal	8000323e <ilock>
  ip->major = major;
    80004c7c:	055a1323          	sh	s5,70(s4)
  ip->minor = minor;
    80004c80:	056a1423          	sh	s6,72(s4)
  ip->nlink = 1;
    80004c84:	4705                	li	a4,1
    80004c86:	04ea1523          	sh	a4,74(s4)
  iupdate(ip);
    80004c8a:	8552                	mv	a0,s4
    80004c8c:	cfefe0ef          	jal	8000318a <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004c90:	4785                	li	a5,1
    80004c92:	02f98563          	beq	s3,a5,80004cbc <create+0xf6>
  if (dirlink(dp, name, ip->inum) < 0)
    80004c96:	004a2603          	lw	a2,4(s4)
    80004c9a:	fb040593          	addi	a1,s0,-80
    80004c9e:	8526                	mv	a0,s1
    80004ca0:	d99fe0ef          	jal	80003a38 <dirlink>
    80004ca4:	06054363          	bltz	a0,80004d0a <create+0x144>
  iunlockput(dp);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	fe8fe0ef          	jal	80003492 <iunlockput>
    return 0;
    80004cae:	8952                	mv	s2,s4
    80004cb0:	7a02                	ld	s4,32(sp)
    80004cb2:	bf51                	j	80004c46 <create+0x80>
    iunlockput(dp);
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	fdcfe0ef          	jal	80003492 <iunlockput>
    return 0;
    80004cba:	bfd5                	j	80004cae <create+0xe8>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004cbc:	004a2603          	lw	a2,4(s4)
    80004cc0:	00003597          	auipc	a1,0x3
    80004cc4:	92058593          	addi	a1,a1,-1760 # 800075e0 <etext+0x5e0>
    80004cc8:	8552                	mv	a0,s4
    80004cca:	d6ffe0ef          	jal	80003a38 <dirlink>
    80004cce:	02054e63          	bltz	a0,80004d0a <create+0x144>
    80004cd2:	40d0                	lw	a2,4(s1)
    80004cd4:	00003597          	auipc	a1,0x3
    80004cd8:	91458593          	addi	a1,a1,-1772 # 800075e8 <etext+0x5e8>
    80004cdc:	8552                	mv	a0,s4
    80004cde:	d5bfe0ef          	jal	80003a38 <dirlink>
    80004ce2:	02054463          	bltz	a0,80004d0a <create+0x144>
  if (dirlink(dp, name, ip->inum) < 0)
    80004ce6:	004a2603          	lw	a2,4(s4)
    80004cea:	fb040593          	addi	a1,s0,-80
    80004cee:	8526                	mv	a0,s1
    80004cf0:	d49fe0ef          	jal	80003a38 <dirlink>
    80004cf4:	00054b63          	bltz	a0,80004d0a <create+0x144>
    dp->nlink++; // for ".."
    80004cf8:	04a4d783          	lhu	a5,74(s1)
    80004cfc:	2785                	addiw	a5,a5,1
    80004cfe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d02:	8526                	mv	a0,s1
    80004d04:	c86fe0ef          	jal	8000318a <iupdate>
    80004d08:	b745                	j	80004ca8 <create+0xe2>
  ip->nlink = 0;
    80004d0a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004d0e:	8552                	mv	a0,s4
    80004d10:	c7afe0ef          	jal	8000318a <iupdate>
  iunlockput(ip);
    80004d14:	8552                	mv	a0,s4
    80004d16:	f7cfe0ef          	jal	80003492 <iunlockput>
  iunlockput(dp);
    80004d1a:	8526                	mv	a0,s1
    80004d1c:	f76fe0ef          	jal	80003492 <iunlockput>
  return 0;
    80004d20:	7a02                	ld	s4,32(sp)
    80004d22:	b715                	j	80004c46 <create+0x80>

0000000080004d24 <sys_dup>:
{
    80004d24:	7179                	addi	sp,sp,-48
    80004d26:	f406                	sd	ra,40(sp)
    80004d28:	f022                	sd	s0,32(sp)
    80004d2a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004d2c:	fd840613          	addi	a2,s0,-40
    80004d30:	4581                	li	a1,0
    80004d32:	4501                	li	a0,0
    80004d34:	e01ff0ef          	jal	80004b34 <argfd>
    80004d38:	02054863          	bltz	a0,80004d68 <sys_dup+0x44>
    80004d3c:	ec26                	sd	s1,24(sp)
    80004d3e:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004d40:	fd843483          	ld	s1,-40(s0)
    80004d44:	8526                	mv	a0,s1
    80004d46:	e43ff0ef          	jal	80004b88 <fdalloc>
    80004d4a:	892a                	mv	s2,a0
    80004d4c:	00054c63          	bltz	a0,80004d64 <sys_dup+0x40>
  filedup(f);
    80004d50:	8526                	mv	a0,s1
    80004d52:	bdeff0ef          	jal	80004130 <filedup>
  return fd;
    80004d56:	854a                	mv	a0,s2
    80004d58:	64e2                	ld	s1,24(sp)
    80004d5a:	6942                	ld	s2,16(sp)
}
    80004d5c:	70a2                	ld	ra,40(sp)
    80004d5e:	7402                	ld	s0,32(sp)
    80004d60:	6145                	addi	sp,sp,48
    80004d62:	8082                	ret
    80004d64:	64e2                	ld	s1,24(sp)
    80004d66:	6942                	ld	s2,16(sp)
    return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	bfcd                	j	80004d5c <sys_dup+0x38>

0000000080004d6c <sys_read>:
{
    80004d6c:	7179                	addi	sp,sp,-48
    80004d6e:	f406                	sd	ra,40(sp)
    80004d70:	f022                	sd	s0,32(sp)
    80004d72:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d74:	fd840593          	addi	a1,s0,-40
    80004d78:	4505                	li	a0,1
    80004d7a:	ae5fd0ef          	jal	8000285e <argaddr>
  argint(2, &n);
    80004d7e:	fe440593          	addi	a1,s0,-28
    80004d82:	4509                	li	a0,2
    80004d84:	abffd0ef          	jal	80002842 <argint>
  if (argfd(0, 0, &f) < 0)
    80004d88:	fe840613          	addi	a2,s0,-24
    80004d8c:	4581                	li	a1,0
    80004d8e:	4501                	li	a0,0
    80004d90:	da5ff0ef          	jal	80004b34 <argfd>
    80004d94:	87aa                	mv	a5,a0
    return -1;
    80004d96:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d98:	0007ca63          	bltz	a5,80004dac <sys_read+0x40>
  return fileread(f, p, n);
    80004d9c:	fe442603          	lw	a2,-28(s0)
    80004da0:	fd843583          	ld	a1,-40(s0)
    80004da4:	fe843503          	ld	a0,-24(s0)
    80004da8:	d00ff0ef          	jal	800042a8 <fileread>
}
    80004dac:	70a2                	ld	ra,40(sp)
    80004dae:	7402                	ld	s0,32(sp)
    80004db0:	6145                	addi	sp,sp,48
    80004db2:	8082                	ret

0000000080004db4 <sys_write>:
{
    80004db4:	7179                	addi	sp,sp,-48
    80004db6:	f406                	sd	ra,40(sp)
    80004db8:	f022                	sd	s0,32(sp)
    80004dba:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004dbc:	fd840593          	addi	a1,s0,-40
    80004dc0:	4505                	li	a0,1
    80004dc2:	a9dfd0ef          	jal	8000285e <argaddr>
  argint(2, &n);
    80004dc6:	fe440593          	addi	a1,s0,-28
    80004dca:	4509                	li	a0,2
    80004dcc:	a77fd0ef          	jal	80002842 <argint>
  if (argfd(0, 0, &f) < 0)
    80004dd0:	fe840613          	addi	a2,s0,-24
    80004dd4:	4581                	li	a1,0
    80004dd6:	4501                	li	a0,0
    80004dd8:	d5dff0ef          	jal	80004b34 <argfd>
    80004ddc:	87aa                	mv	a5,a0
    return -1;
    80004dde:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004de0:	0007ca63          	bltz	a5,80004df4 <sys_write+0x40>
  return filewrite(f, p, n);
    80004de4:	fe442603          	lw	a2,-28(s0)
    80004de8:	fd843583          	ld	a1,-40(s0)
    80004dec:	fe843503          	ld	a0,-24(s0)
    80004df0:	d7cff0ef          	jal	8000436c <filewrite>
}
    80004df4:	70a2                	ld	ra,40(sp)
    80004df6:	7402                	ld	s0,32(sp)
    80004df8:	6145                	addi	sp,sp,48
    80004dfa:	8082                	ret

0000000080004dfc <sys_close>:
{
    80004dfc:	1101                	addi	sp,sp,-32
    80004dfe:	ec06                	sd	ra,24(sp)
    80004e00:	e822                	sd	s0,16(sp)
    80004e02:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004e04:	fe040613          	addi	a2,s0,-32
    80004e08:	fec40593          	addi	a1,s0,-20
    80004e0c:	4501                	li	a0,0
    80004e0e:	d27ff0ef          	jal	80004b34 <argfd>
    return -1;
    80004e12:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004e14:	02054063          	bltz	a0,80004e34 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004e18:	b0bfc0ef          	jal	80001922 <myproc>
    80004e1c:	fec42783          	lw	a5,-20(s0)
    80004e20:	07e9                	addi	a5,a5,26
    80004e22:	078e                	slli	a5,a5,0x3
    80004e24:	953e                	add	a0,a0,a5
    80004e26:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004e2a:	fe043503          	ld	a0,-32(s0)
    80004e2e:	b48ff0ef          	jal	80004176 <fileclose>
  return 0;
    80004e32:	4781                	li	a5,0
}
    80004e34:	853e                	mv	a0,a5
    80004e36:	60e2                	ld	ra,24(sp)
    80004e38:	6442                	ld	s0,16(sp)
    80004e3a:	6105                	addi	sp,sp,32
    80004e3c:	8082                	ret

0000000080004e3e <sys_fstat>:
{
    80004e3e:	1101                	addi	sp,sp,-32
    80004e40:	ec06                	sd	ra,24(sp)
    80004e42:	e822                	sd	s0,16(sp)
    80004e44:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e46:	fe040593          	addi	a1,s0,-32
    80004e4a:	4505                	li	a0,1
    80004e4c:	a13fd0ef          	jal	8000285e <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004e50:	fe840613          	addi	a2,s0,-24
    80004e54:	4581                	li	a1,0
    80004e56:	4501                	li	a0,0
    80004e58:	cddff0ef          	jal	80004b34 <argfd>
    80004e5c:	87aa                	mv	a5,a0
    return -1;
    80004e5e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004e60:	0007c863          	bltz	a5,80004e70 <sys_fstat+0x32>
  return filestat(f, st);
    80004e64:	fe043583          	ld	a1,-32(s0)
    80004e68:	fe843503          	ld	a0,-24(s0)
    80004e6c:	bccff0ef          	jal	80004238 <filestat>
}
    80004e70:	60e2                	ld	ra,24(sp)
    80004e72:	6442                	ld	s0,16(sp)
    80004e74:	6105                	addi	sp,sp,32
    80004e76:	8082                	ret

0000000080004e78 <sys_link>:
{
    80004e78:	7169                	addi	sp,sp,-304
    80004e7a:	f606                	sd	ra,296(sp)
    80004e7c:	f222                	sd	s0,288(sp)
    80004e7e:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e80:	08000613          	li	a2,128
    80004e84:	ed040593          	addi	a1,s0,-304
    80004e88:	4501                	li	a0,0
    80004e8a:	9f1fd0ef          	jal	8000287a <argstr>
    80004e8e:	0e054c63          	bltz	a0,80004f86 <sys_link+0x10e>
    80004e92:	08000613          	li	a2,128
    80004e96:	f5040593          	addi	a1,s0,-176
    80004e9a:	4505                	li	a0,1
    80004e9c:	9dffd0ef          	jal	8000287a <argstr>
    80004ea0:	0e054363          	bltz	a0,80004f86 <sys_link+0x10e>
    80004ea4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ea6:	e1bfe0ef          	jal	80003cc0 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004eaa:	ed040513          	addi	a0,s0,-304
    80004eae:	c35fe0ef          	jal	80003ae2 <namei>
    80004eb2:	84aa                	mv	s1,a0
    80004eb4:	cd35                	beqz	a0,80004f30 <sys_link+0xb8>
  ilock(ip);
    80004eb6:	b88fe0ef          	jal	8000323e <ilock>
  if (ip->type == T_DIR) {
    80004eba:	04449703          	lh	a4,68(s1)
    80004ebe:	4785                	li	a5,1
    80004ec0:	06f70c63          	beq	a4,a5,80004f38 <sys_link+0xc0>
  if (ip->nlink >= NLINK_MAX) {
    80004ec4:	04a49783          	lh	a5,74(s1)
    80004ec8:	6721                	lui	a4,0x8
    80004eca:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80004ecc:	06e78d63          	beq	a5,a4,80004f46 <sys_link+0xce>
    80004ed0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ed2:	2785                	addiw	a5,a5,1
    80004ed4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ed8:	8526                	mv	a0,s1
    80004eda:	ab0fe0ef          	jal	8000318a <iupdate>
  iunlock(ip);
    80004ede:	8526                	mv	a0,s1
    80004ee0:	c0cfe0ef          	jal	800032ec <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004ee4:	fd040593          	addi	a1,s0,-48
    80004ee8:	f5040513          	addi	a0,s0,-176
    80004eec:	c11fe0ef          	jal	80003afc <nameiparent>
    80004ef0:	892a                	mv	s2,a0
    80004ef2:	c925                	beqz	a0,80004f62 <sys_link+0xea>
  ilock(dp);
    80004ef4:	b4afe0ef          	jal	8000323e <ilock>
  if (dp->nlink == 0) {
    80004ef8:	04a91783          	lh	a5,74(s2)
    80004efc:	cfa1                	beqz	a5,80004f54 <sys_link+0xdc>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004efe:	854a                	mv	a0,s2
    80004f00:	00092703          	lw	a4,0(s2)
    80004f04:	409c                	lw	a5,0(s1)
    80004f06:	04f71b63          	bne	a4,a5,80004f5c <sys_link+0xe4>
    80004f0a:	40d0                	lw	a2,4(s1)
    80004f0c:	fd040593          	addi	a1,s0,-48
    80004f10:	b29fe0ef          	jal	80003a38 <dirlink>
    80004f14:	04054463          	bltz	a0,80004f5c <sys_link+0xe4>
  iunlockput(dp);
    80004f18:	854a                	mv	a0,s2
    80004f1a:	d78fe0ef          	jal	80003492 <iunlockput>
  iput(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	ca0fe0ef          	jal	800033c0 <iput>
  end_op();
    80004f24:	e29fe0ef          	jal	80003d4c <end_op>
  return 0;
    80004f28:	4501                	li	a0,0
    80004f2a:	64f2                	ld	s1,280(sp)
    80004f2c:	6952                	ld	s2,272(sp)
    80004f2e:	a8a9                	j	80004f88 <sys_link+0x110>
    end_op();
    80004f30:	e1dfe0ef          	jal	80003d4c <end_op>
    return -1;
    80004f34:	64f2                	ld	s1,280(sp)
    80004f36:	a881                	j	80004f86 <sys_link+0x10e>
    iunlockput(ip);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	d58fe0ef          	jal	80003492 <iunlockput>
    end_op();
    80004f3e:	e0ffe0ef          	jal	80003d4c <end_op>
    return -1;
    80004f42:	64f2                	ld	s1,280(sp)
    80004f44:	a089                	j	80004f86 <sys_link+0x10e>
    iunlockput(ip);
    80004f46:	8526                	mv	a0,s1
    80004f48:	d4afe0ef          	jal	80003492 <iunlockput>
    end_op();
    80004f4c:	e01fe0ef          	jal	80003d4c <end_op>
    return -1;
    80004f50:	64f2                	ld	s1,280(sp)
    80004f52:	a815                	j	80004f86 <sys_link+0x10e>
    iunlockput(dp);
    80004f54:	854a                	mv	a0,s2
    80004f56:	d3cfe0ef          	jal	80003492 <iunlockput>
    goto bad;
    80004f5a:	a021                	j	80004f62 <sys_link+0xea>
    iunlockput(dp);
    80004f5c:	854a                	mv	a0,s2
    80004f5e:	d34fe0ef          	jal	80003492 <iunlockput>
  ilock(ip);
    80004f62:	8526                	mv	a0,s1
    80004f64:	adafe0ef          	jal	8000323e <ilock>
  ip->nlink--;
    80004f68:	04a4d783          	lhu	a5,74(s1)
    80004f6c:	37fd                	addiw	a5,a5,-1
    80004f6e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f72:	8526                	mv	a0,s1
    80004f74:	a16fe0ef          	jal	8000318a <iupdate>
  iunlockput(ip);
    80004f78:	8526                	mv	a0,s1
    80004f7a:	d18fe0ef          	jal	80003492 <iunlockput>
  end_op();
    80004f7e:	dcffe0ef          	jal	80003d4c <end_op>
  return -1;
    80004f82:	64f2                	ld	s1,280(sp)
    80004f84:	6952                	ld	s2,272(sp)
    return -1;
    80004f86:	557d                	li	a0,-1
}
    80004f88:	70b2                	ld	ra,296(sp)
    80004f8a:	7412                	ld	s0,288(sp)
    80004f8c:	6155                	addi	sp,sp,304
    80004f8e:	8082                	ret

0000000080004f90 <sys_unlink>:
{
    80004f90:	7151                	addi	sp,sp,-240
    80004f92:	f586                	sd	ra,232(sp)
    80004f94:	f1a2                	sd	s0,224(sp)
    80004f96:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004f98:	08000613          	li	a2,128
    80004f9c:	f3040593          	addi	a1,s0,-208
    80004fa0:	4501                	li	a0,0
    80004fa2:	8d9fd0ef          	jal	8000287a <argstr>
    80004fa6:	14054763          	bltz	a0,800050f4 <sys_unlink+0x164>
    80004faa:	eda6                	sd	s1,216(sp)
  begin_op();
    80004fac:	d15fe0ef          	jal	80003cc0 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004fb0:	fb040593          	addi	a1,s0,-80
    80004fb4:	f3040513          	addi	a0,s0,-208
    80004fb8:	b45fe0ef          	jal	80003afc <nameiparent>
    80004fbc:	84aa                	mv	s1,a0
    80004fbe:	c955                	beqz	a0,80005072 <sys_unlink+0xe2>
  ilock(dp);
    80004fc0:	a7efe0ef          	jal	8000323e <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004fc4:	00002597          	auipc	a1,0x2
    80004fc8:	61c58593          	addi	a1,a1,1564 # 800075e0 <etext+0x5e0>
    80004fcc:	fb040513          	addi	a0,s0,-80
    80004fd0:	843fe0ef          	jal	80003812 <namecmp>
    80004fd4:	10050a63          	beqz	a0,800050e8 <sys_unlink+0x158>
    80004fd8:	00002597          	auipc	a1,0x2
    80004fdc:	61058593          	addi	a1,a1,1552 # 800075e8 <etext+0x5e8>
    80004fe0:	fb040513          	addi	a0,s0,-80
    80004fe4:	82ffe0ef          	jal	80003812 <namecmp>
    80004fe8:	10050063          	beqz	a0,800050e8 <sys_unlink+0x158>
    80004fec:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004fee:	f2c40613          	addi	a2,s0,-212
    80004ff2:	fb040593          	addi	a1,s0,-80
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	831fe0ef          	jal	80003828 <dirlookup>
    80004ffc:	892a                	mv	s2,a0
    80004ffe:	0e050463          	beqz	a0,800050e6 <sys_unlink+0x156>
    80005002:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005004:	a3afe0ef          	jal	8000323e <ilock>
  if (ip->nlink < 1)
    80005008:	04a91783          	lh	a5,74(s2)
    8000500c:	06f05763          	blez	a5,8000507a <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005010:	04491703          	lh	a4,68(s2)
    80005014:	4785                	li	a5,1
    80005016:	06f70863          	beq	a4,a5,80005086 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000501a:	fc040993          	addi	s3,s0,-64
    8000501e:	4641                	li	a2,16
    80005020:	4581                	li	a1,0
    80005022:	854e                	mv	a0,s3
    80005024:	cd1fb0ef          	jal	80000cf4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005028:	4741                	li	a4,16
    8000502a:	f2c42683          	lw	a3,-212(s0)
    8000502e:	864e                	mv	a2,s3
    80005030:	4581                	li	a1,0
    80005032:	8526                	mv	a0,s1
    80005034:	ed6fe0ef          	jal	8000370a <writei>
    80005038:	47c1                	li	a5,16
    8000503a:	08f51763          	bne	a0,a5,800050c8 <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    8000503e:	04491703          	lh	a4,68(s2)
    80005042:	4785                	li	a5,1
    80005044:	08f70863          	beq	a4,a5,800050d4 <sys_unlink+0x144>
  iunlockput(dp);
    80005048:	8526                	mv	a0,s1
    8000504a:	c48fe0ef          	jal	80003492 <iunlockput>
  ip->nlink--;
    8000504e:	04a95783          	lhu	a5,74(s2)
    80005052:	37fd                	addiw	a5,a5,-1
    80005054:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005058:	854a                	mv	a0,s2
    8000505a:	930fe0ef          	jal	8000318a <iupdate>
  iunlockput(ip);
    8000505e:	854a                	mv	a0,s2
    80005060:	c32fe0ef          	jal	80003492 <iunlockput>
  end_op();
    80005064:	ce9fe0ef          	jal	80003d4c <end_op>
  return 0;
    80005068:	4501                	li	a0,0
    8000506a:	64ee                	ld	s1,216(sp)
    8000506c:	694e                	ld	s2,208(sp)
    8000506e:	69ae                	ld	s3,200(sp)
    80005070:	a059                	j	800050f6 <sys_unlink+0x166>
    end_op();
    80005072:	cdbfe0ef          	jal	80003d4c <end_op>
    return -1;
    80005076:	64ee                	ld	s1,216(sp)
    80005078:	a8b5                	j	800050f4 <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    8000507a:	00002517          	auipc	a0,0x2
    8000507e:	57650513          	addi	a0,a0,1398 # 800075f0 <etext+0x5f0>
    80005082:	fc6fb0ef          	jal	80000848 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005086:	04c92703          	lw	a4,76(s2)
    8000508a:	02000793          	li	a5,32
    8000508e:	f8e7f6e3          	bgeu	a5,a4,8000501a <sys_unlink+0x8a>
    80005092:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005094:	4741                	li	a4,16
    80005096:	86ce                	mv	a3,s3
    80005098:	f1840613          	addi	a2,s0,-232
    8000509c:	4581                	li	a1,0
    8000509e:	854a                	mv	a0,s2
    800050a0:	d78fe0ef          	jal	80003618 <readi>
    800050a4:	47c1                	li	a5,16
    800050a6:	00f51b63          	bne	a0,a5,800050bc <sys_unlink+0x12c>
    if (de.inum != 0)
    800050aa:	f1845783          	lhu	a5,-232(s0)
    800050ae:	eba1                	bnez	a5,800050fe <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800050b0:	29c1                	addiw	s3,s3,16
    800050b2:	04c92783          	lw	a5,76(s2)
    800050b6:	fcf9efe3          	bltu	s3,a5,80005094 <sys_unlink+0x104>
    800050ba:	b785                	j	8000501a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800050bc:	00002517          	auipc	a0,0x2
    800050c0:	54c50513          	addi	a0,a0,1356 # 80007608 <etext+0x608>
    800050c4:	f84fb0ef          	jal	80000848 <panic>
    panic("unlink: writei");
    800050c8:	00002517          	auipc	a0,0x2
    800050cc:	55850513          	addi	a0,a0,1368 # 80007620 <etext+0x620>
    800050d0:	f78fb0ef          	jal	80000848 <panic>
    dp->nlink--;
    800050d4:	04a4d783          	lhu	a5,74(s1)
    800050d8:	37fd                	addiw	a5,a5,-1
    800050da:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050de:	8526                	mv	a0,s1
    800050e0:	8aafe0ef          	jal	8000318a <iupdate>
    800050e4:	b795                	j	80005048 <sys_unlink+0xb8>
    800050e6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800050e8:	8526                	mv	a0,s1
    800050ea:	ba8fe0ef          	jal	80003492 <iunlockput>
  end_op();
    800050ee:	c5ffe0ef          	jal	80003d4c <end_op>
  return -1;
    800050f2:	64ee                	ld	s1,216(sp)
    return -1;
    800050f4:	557d                	li	a0,-1
}
    800050f6:	70ae                	ld	ra,232(sp)
    800050f8:	740e                	ld	s0,224(sp)
    800050fa:	616d                	addi	sp,sp,240
    800050fc:	8082                	ret
    iunlockput(ip);
    800050fe:	854a                	mv	a0,s2
    80005100:	b92fe0ef          	jal	80003492 <iunlockput>
    goto bad;
    80005104:	694e                	ld	s2,208(sp)
    80005106:	69ae                	ld	s3,200(sp)
    80005108:	b7c5                	j	800050e8 <sys_unlink+0x158>

000000008000510a <sys_open>:

uint64
sys_open(void)
{
    8000510a:	7131                	addi	sp,sp,-192
    8000510c:	fd06                	sd	ra,184(sp)
    8000510e:	f922                	sd	s0,176(sp)
    80005110:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005112:	f4c40593          	addi	a1,s0,-180
    80005116:	4505                	li	a0,1
    80005118:	f2afd0ef          	jal	80002842 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000511c:	08000613          	li	a2,128
    80005120:	f5040593          	addi	a1,s0,-176
    80005124:	4501                	li	a0,0
    80005126:	f54fd0ef          	jal	8000287a <argstr>
    8000512a:	10054563          	bltz	a0,80005234 <sys_open+0x12a>
    8000512e:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    80005130:	b91fe0ef          	jal	80003cc0 <begin_op>

  if (omode & O_CREATE) {
    80005134:	f4c42783          	lw	a5,-180(s0)
    80005138:	2007f793          	andi	a5,a5,512
    8000513c:	cfd9                	beqz	a5,800051da <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    8000513e:	4681                	li	a3,0
    80005140:	4601                	li	a2,0
    80005142:	4589                	li	a1,2
    80005144:	f5040513          	addi	a0,s0,-176
    80005148:	a7fff0ef          	jal	80004bc6 <create>
    8000514c:	84aa                	mv	s1,a0
    if (ip == 0) {
    8000514e:	c151                	beqz	a0,800051d2 <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005150:	04449703          	lh	a4,68(s1)
    80005154:	478d                	li	a5,3
    80005156:	00f71763          	bne	a4,a5,80005164 <sys_open+0x5a>
    8000515a:	0464d703          	lhu	a4,70(s1)
    8000515e:	47a5                	li	a5,9
    80005160:	0ae7e863          	bltu	a5,a4,80005210 <sys_open+0x106>
    80005164:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005166:	f6dfe0ef          	jal	800040d2 <filealloc>
    8000516a:	892a                	mv	s2,a0
    8000516c:	cd4d                	beqz	a0,80005226 <sys_open+0x11c>
    8000516e:	ed4e                	sd	s3,152(sp)
    80005170:	a19ff0ef          	jal	80004b88 <fdalloc>
    80005174:	89aa                	mv	s3,a0
    80005176:	0a054463          	bltz	a0,8000521e <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000517a:	04449703          	lh	a4,68(s1)
    8000517e:	478d                	li	a5,3
    80005180:	0af70f63          	beq	a4,a5,8000523e <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005184:	4789                	li	a5,2
    80005186:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000518a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000518e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005192:	f4c42783          	lw	a5,-180(s0)
    80005196:	0017f713          	andi	a4,a5,1
    8000519a:	00174713          	xori	a4,a4,1
    8000519e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800051a2:	0037f713          	andi	a4,a5,3
    800051a6:	00e03733          	snez	a4,a4
    800051aa:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800051ae:	4007f793          	andi	a5,a5,1024
    800051b2:	c791                	beqz	a5,800051be <sys_open+0xb4>
    800051b4:	04449703          	lh	a4,68(s1)
    800051b8:	4789                	li	a5,2
    800051ba:	08f70963          	beq	a4,a5,8000524c <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    800051be:	8526                	mv	a0,s1
    800051c0:	92cfe0ef          	jal	800032ec <iunlock>
  end_op();
    800051c4:	b89fe0ef          	jal	80003d4c <end_op>

  return fd;
    800051c8:	854e                	mv	a0,s3
    800051ca:	74aa                	ld	s1,168(sp)
    800051cc:	790a                	ld	s2,160(sp)
    800051ce:	69ea                	ld	s3,152(sp)
    800051d0:	a09d                	j	80005236 <sys_open+0x12c>
      end_op();
    800051d2:	b7bfe0ef          	jal	80003d4c <end_op>
      return -1;
    800051d6:	74aa                	ld	s1,168(sp)
    800051d8:	a8b1                	j	80005234 <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    800051da:	f5040513          	addi	a0,s0,-176
    800051de:	905fe0ef          	jal	80003ae2 <namei>
    800051e2:	84aa                	mv	s1,a0
    800051e4:	c115                	beqz	a0,80005208 <sys_open+0xfe>
    ilock(ip);
    800051e6:	858fe0ef          	jal	8000323e <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    800051ea:	04449703          	lh	a4,68(s1)
    800051ee:	4785                	li	a5,1
    800051f0:	f6f710e3          	bne	a4,a5,80005150 <sys_open+0x46>
    800051f4:	f4c42783          	lw	a5,-180(s0)
    800051f8:	d7b5                	beqz	a5,80005164 <sys_open+0x5a>
      iunlockput(ip);
    800051fa:	8526                	mv	a0,s1
    800051fc:	a96fe0ef          	jal	80003492 <iunlockput>
      end_op();
    80005200:	b4dfe0ef          	jal	80003d4c <end_op>
      return -1;
    80005204:	74aa                	ld	s1,168(sp)
    80005206:	a03d                	j	80005234 <sys_open+0x12a>
      end_op();
    80005208:	b45fe0ef          	jal	80003d4c <end_op>
      return -1;
    8000520c:	74aa                	ld	s1,168(sp)
    8000520e:	a01d                	j	80005234 <sys_open+0x12a>
    iunlockput(ip);
    80005210:	8526                	mv	a0,s1
    80005212:	a80fe0ef          	jal	80003492 <iunlockput>
    end_op();
    80005216:	b37fe0ef          	jal	80003d4c <end_op>
    return -1;
    8000521a:	74aa                	ld	s1,168(sp)
    8000521c:	a821                	j	80005234 <sys_open+0x12a>
      fileclose(f);
    8000521e:	854a                	mv	a0,s2
    80005220:	f57fe0ef          	jal	80004176 <fileclose>
    80005224:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005226:	8526                	mv	a0,s1
    80005228:	a6afe0ef          	jal	80003492 <iunlockput>
    end_op();
    8000522c:	b21fe0ef          	jal	80003d4c <end_op>
    return -1;
    80005230:	74aa                	ld	s1,168(sp)
    80005232:	790a                	ld	s2,160(sp)
    return -1;
    80005234:	557d                	li	a0,-1
}
    80005236:	70ea                	ld	ra,184(sp)
    80005238:	744a                	ld	s0,176(sp)
    8000523a:	6129                	addi	sp,sp,192
    8000523c:	8082                	ret
    f->type = FD_DEVICE;
    8000523e:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005242:	04649783          	lh	a5,70(s1)
    80005246:	02f91223          	sh	a5,36(s2)
    8000524a:	b791                	j	8000518e <sys_open+0x84>
    itrunc(ip);
    8000524c:	8526                	mv	a0,s1
    8000524e:	8defe0ef          	jal	8000332c <itrunc>
    80005252:	b7b5                	j	800051be <sys_open+0xb4>

0000000080005254 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005254:	7175                	addi	sp,sp,-144
    80005256:	e506                	sd	ra,136(sp)
    80005258:	e122                	sd	s0,128(sp)
    8000525a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000525c:	a65fe0ef          	jal	80003cc0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005260:	08000613          	li	a2,128
    80005264:	f7040593          	addi	a1,s0,-144
    80005268:	4501                	li	a0,0
    8000526a:	e10fd0ef          	jal	8000287a <argstr>
    8000526e:	02054363          	bltz	a0,80005294 <sys_mkdir+0x40>
    80005272:	4681                	li	a3,0
    80005274:	4601                	li	a2,0
    80005276:	4585                	li	a1,1
    80005278:	f7040513          	addi	a0,s0,-144
    8000527c:	94bff0ef          	jal	80004bc6 <create>
    80005280:	c911                	beqz	a0,80005294 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005282:	a10fe0ef          	jal	80003492 <iunlockput>
  end_op();
    80005286:	ac7fe0ef          	jal	80003d4c <end_op>
  return 0;
    8000528a:	4501                	li	a0,0
}
    8000528c:	60aa                	ld	ra,136(sp)
    8000528e:	640a                	ld	s0,128(sp)
    80005290:	6149                	addi	sp,sp,144
    80005292:	8082                	ret
    end_op();
    80005294:	ab9fe0ef          	jal	80003d4c <end_op>
    return -1;
    80005298:	557d                	li	a0,-1
    8000529a:	bfcd                	j	8000528c <sys_mkdir+0x38>

000000008000529c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000529c:	7135                	addi	sp,sp,-160
    8000529e:	ed06                	sd	ra,152(sp)
    800052a0:	e922                	sd	s0,144(sp)
    800052a2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800052a4:	a1dfe0ef          	jal	80003cc0 <begin_op>
  argint(1, &major);
    800052a8:	f6c40593          	addi	a1,s0,-148
    800052ac:	4505                	li	a0,1
    800052ae:	d94fd0ef          	jal	80002842 <argint>
  argint(2, &minor);
    800052b2:	f6840593          	addi	a1,s0,-152
    800052b6:	4509                	li	a0,2
    800052b8:	d8afd0ef          	jal	80002842 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800052bc:	08000613          	li	a2,128
    800052c0:	f7040593          	addi	a1,s0,-144
    800052c4:	4501                	li	a0,0
    800052c6:	db4fd0ef          	jal	8000287a <argstr>
    800052ca:	02054563          	bltz	a0,800052f4 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800052ce:	f6841683          	lh	a3,-152(s0)
    800052d2:	f6c41603          	lh	a2,-148(s0)
    800052d6:	458d                	li	a1,3
    800052d8:	f7040513          	addi	a0,s0,-144
    800052dc:	8ebff0ef          	jal	80004bc6 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800052e0:	c911                	beqz	a0,800052f4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052e2:	9b0fe0ef          	jal	80003492 <iunlockput>
  end_op();
    800052e6:	a67fe0ef          	jal	80003d4c <end_op>
  return 0;
    800052ea:	4501                	li	a0,0
}
    800052ec:	60ea                	ld	ra,152(sp)
    800052ee:	644a                	ld	s0,144(sp)
    800052f0:	610d                	addi	sp,sp,160
    800052f2:	8082                	ret
    end_op();
    800052f4:	a59fe0ef          	jal	80003d4c <end_op>
    return -1;
    800052f8:	557d                	li	a0,-1
    800052fa:	bfcd                	j	800052ec <sys_mknod+0x50>

00000000800052fc <sys_chdir>:

uint64
sys_chdir(void)
{
    800052fc:	7135                	addi	sp,sp,-160
    800052fe:	ed06                	sd	ra,152(sp)
    80005300:	e922                	sd	s0,144(sp)
    80005302:	e14a                	sd	s2,128(sp)
    80005304:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005306:	e1cfc0ef          	jal	80001922 <myproc>
    8000530a:	892a                	mv	s2,a0

  begin_op();
    8000530c:	9b5fe0ef          	jal	80003cc0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005310:	08000613          	li	a2,128
    80005314:	f6040593          	addi	a1,s0,-160
    80005318:	4501                	li	a0,0
    8000531a:	d60fd0ef          	jal	8000287a <argstr>
    8000531e:	02054f63          	bltz	a0,8000535c <sys_chdir+0x60>
    80005322:	e526                	sd	s1,136(sp)
    80005324:	f6040513          	addi	a0,s0,-160
    80005328:	fbafe0ef          	jal	80003ae2 <namei>
    8000532c:	84aa                	mv	s1,a0
    8000532e:	c515                	beqz	a0,8000535a <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    80005330:	f0ffd0ef          	jal	8000323e <ilock>
  if (ip->type != T_DIR) {
    80005334:	04449703          	lh	a4,68(s1)
    80005338:	4785                	li	a5,1
    8000533a:	02f71963          	bne	a4,a5,8000536c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000533e:	8526                	mv	a0,s1
    80005340:	fadfd0ef          	jal	800032ec <iunlock>
  iput(p->cwd);
    80005344:	15093503          	ld	a0,336(s2)
    80005348:	878fe0ef          	jal	800033c0 <iput>
  end_op();
    8000534c:	a01fe0ef          	jal	80003d4c <end_op>
  p->cwd = ip;
    80005350:	14993823          	sd	s1,336(s2)
  return 0;
    80005354:	4501                	li	a0,0
    80005356:	64aa                	ld	s1,136(sp)
    80005358:	a029                	j	80005362 <sys_chdir+0x66>
    8000535a:	64aa                	ld	s1,136(sp)
    end_op();
    8000535c:	9f1fe0ef          	jal	80003d4c <end_op>
    return -1;
    80005360:	557d                	li	a0,-1
}
    80005362:	60ea                	ld	ra,152(sp)
    80005364:	644a                	ld	s0,144(sp)
    80005366:	690a                	ld	s2,128(sp)
    80005368:	610d                	addi	sp,sp,160
    8000536a:	8082                	ret
    iunlockput(ip);
    8000536c:	8526                	mv	a0,s1
    8000536e:	924fe0ef          	jal	80003492 <iunlockput>
    end_op();
    80005372:	9dbfe0ef          	jal	80003d4c <end_op>
    return -1;
    80005376:	64aa                	ld	s1,136(sp)
    80005378:	b7e5                	j	80005360 <sys_chdir+0x64>

000000008000537a <sys_exec>:

uint64
sys_exec(void)
{
    8000537a:	7105                	addi	sp,sp,-480
    8000537c:	ef86                	sd	ra,472(sp)
    8000537e:	eba2                	sd	s0,464(sp)
    80005380:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005382:	e2840593          	addi	a1,s0,-472
    80005386:	4505                	li	a0,1
    80005388:	cd6fd0ef          	jal	8000285e <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000538c:	08000613          	li	a2,128
    80005390:	f3040593          	addi	a1,s0,-208
    80005394:	4501                	li	a0,0
    80005396:	ce4fd0ef          	jal	8000287a <argstr>
    8000539a:	0c054e63          	bltz	a0,80005476 <sys_exec+0xfc>
    8000539e:	e7a6                	sd	s1,456(sp)
    800053a0:	e3ca                	sd	s2,448(sp)
    800053a2:	ff4e                	sd	s3,440(sp)
    800053a4:	fb52                	sd	s4,432(sp)
    800053a6:	f756                	sd	s5,424(sp)
    800053a8:	f35a                	sd	s6,416(sp)
    800053aa:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    800053ac:	e3040a13          	addi	s4,s0,-464
    800053b0:	10000613          	li	a2,256
    800053b4:	4581                	li	a1,0
    800053b6:	8552                	mv	a0,s4
    800053b8:	93dfb0ef          	jal	80000cf4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800053bc:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800053be:	89d2                	mv	s3,s4
    800053c0:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800053c2:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053c6:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800053c8:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800053cc:	00391513          	slli	a0,s2,0x3
    800053d0:	85d6                	mv	a1,s5
    800053d2:	e2843783          	ld	a5,-472(s0)
    800053d6:	953e                	add	a0,a0,a5
    800053d8:	be2fd0ef          	jal	800027ba <fetchaddr>
    800053dc:	02054663          	bltz	a0,80005408 <sys_exec+0x8e>
    if (uarg == 0) {
    800053e0:	e2043783          	ld	a5,-480(s0)
    800053e4:	c3b9                	beqz	a5,8000542a <sys_exec+0xb0>
    argv[i] = kalloc();
    800053e6:	f78fb0ef          	jal	80000b5e <kalloc>
    800053ea:	85aa                	mv	a1,a0
    800053ec:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800053f0:	cd01                	beqz	a0,80005408 <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053f2:	865a                	mv	a2,s6
    800053f4:	e2043503          	ld	a0,-480(s0)
    800053f8:	c08fd0ef          	jal	80002800 <fetchstr>
    800053fc:	00054663          	bltz	a0,80005408 <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    80005400:	0905                	addi	s2,s2,1
    80005402:	09a1                	addi	s3,s3,8
    80005404:	fd7914e3          	bne	s2,s7,800053cc <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005408:	100a0a13          	addi	s4,s4,256
    8000540c:	6088                	ld	a0,0(s1)
    8000540e:	cd29                	beqz	a0,80005468 <sys_exec+0xee>
    kfree(argv[i]);
    80005410:	e66fb0ef          	jal	80000a76 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005414:	04a1                	addi	s1,s1,8
    80005416:	ff449be3          	bne	s1,s4,8000540c <sys_exec+0x92>
    8000541a:	64be                	ld	s1,456(sp)
    8000541c:	691e                	ld	s2,448(sp)
    8000541e:	79fa                	ld	s3,440(sp)
    80005420:	7a5a                	ld	s4,432(sp)
    80005422:	7aba                	ld	s5,424(sp)
    80005424:	7b1a                	ld	s6,416(sp)
    80005426:	6bfa                	ld	s7,408(sp)
    80005428:	a0b9                	j	80005476 <sys_exec+0xfc>
      argv[i] = 0;
    8000542a:	0009079b          	sext.w	a5,s2
    8000542e:	e3040593          	addi	a1,s0,-464
    80005432:	078e                	slli	a5,a5,0x3
    80005434:	97ae                	add	a5,a5,a1
    80005436:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000543a:	f3040513          	addi	a0,s0,-208
    8000543e:	bdeff0ef          	jal	8000481c <kexec>
    80005442:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005444:	100a0a13          	addi	s4,s4,256
    80005448:	6088                	ld	a0,0(s1)
    8000544a:	c511                	beqz	a0,80005456 <sys_exec+0xdc>
    kfree(argv[i]);
    8000544c:	e2afb0ef          	jal	80000a76 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005450:	04a1                	addi	s1,s1,8
    80005452:	ff449be3          	bne	s1,s4,80005448 <sys_exec+0xce>
  return ret;
    80005456:	854a                	mv	a0,s2
    80005458:	64be                	ld	s1,456(sp)
    8000545a:	691e                	ld	s2,448(sp)
    8000545c:	79fa                	ld	s3,440(sp)
    8000545e:	7a5a                	ld	s4,432(sp)
    80005460:	7aba                	ld	s5,424(sp)
    80005462:	7b1a                	ld	s6,416(sp)
    80005464:	6bfa                	ld	s7,408(sp)
    80005466:	a809                	j	80005478 <sys_exec+0xfe>
    80005468:	64be                	ld	s1,456(sp)
    8000546a:	691e                	ld	s2,448(sp)
    8000546c:	79fa                	ld	s3,440(sp)
    8000546e:	7a5a                	ld	s4,432(sp)
    80005470:	7aba                	ld	s5,424(sp)
    80005472:	7b1a                	ld	s6,416(sp)
    80005474:	6bfa                	ld	s7,408(sp)
    return -1;
    80005476:	557d                	li	a0,-1
  return -1;
}
    80005478:	60fe                	ld	ra,472(sp)
    8000547a:	645e                	ld	s0,464(sp)
    8000547c:	613d                	addi	sp,sp,480
    8000547e:	8082                	ret

0000000080005480 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005480:	7139                	addi	sp,sp,-64
    80005482:	fc06                	sd	ra,56(sp)
    80005484:	f822                	sd	s0,48(sp)
    80005486:	f426                	sd	s1,40(sp)
    80005488:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000548a:	c98fc0ef          	jal	80001922 <myproc>
    8000548e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005490:	fd840593          	addi	a1,s0,-40
    80005494:	4501                	li	a0,0
    80005496:	bc8fd0ef          	jal	8000285e <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000549a:	fc840593          	addi	a1,s0,-56
    8000549e:	fd040513          	addi	a0,s0,-48
    800054a2:	802ff0ef          	jal	800044a4 <pipealloc>
    800054a6:	0a054663          	bltz	a0,80005552 <sys_pipe+0xd2>
    return -1;
  fd0 = -1;
    800054aa:	57fd                	li	a5,-1
    800054ac:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800054b0:	fd043503          	ld	a0,-48(s0)
    800054b4:	ed4ff0ef          	jal	80004b88 <fdalloc>
    800054b8:	fca42223          	sw	a0,-60(s0)
    800054bc:	08054363          	bltz	a0,80005542 <sys_pipe+0xc2>
    800054c0:	fc843503          	ld	a0,-56(s0)
    800054c4:	ec4ff0ef          	jal	80004b88 <fdalloc>
    800054c8:	fca42023          	sw	a0,-64(s0)
    800054cc:	06054263          	bltz	a0,80005530 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800054d0:	4711                	li	a4,4
    800054d2:	fc440693          	addi	a3,s0,-60
    800054d6:	fd843603          	ld	a2,-40(s0)
    800054da:	64ac                	ld	a1,72(s1)
    800054dc:	68a8                	ld	a0,80(s1)
    800054de:	88efc0ef          	jal	8000156c <copyout>
    800054e2:	02054063          	bltz	a0,80005502 <sys_pipe+0x82>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    800054e6:	4711                	li	a4,4
    800054e8:	fc040693          	addi	a3,s0,-64
    800054ec:	fd843603          	ld	a2,-40(s0)
    800054f0:	963a                	add	a2,a2,a4
    800054f2:	64ac                	ld	a1,72(s1)
    800054f4:	68a8                	ld	a0,80(s1)
    800054f6:	876fc0ef          	jal	8000156c <copyout>
    800054fa:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054fc:	4501                	li	a0,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800054fe:	0407db63          	bgez	a5,80005554 <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    80005502:	fc442783          	lw	a5,-60(s0)
    80005506:	07e9                	addi	a5,a5,26
    80005508:	078e                	slli	a5,a5,0x3
    8000550a:	97a6                	add	a5,a5,s1
    8000550c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005510:	fc042783          	lw	a5,-64(s0)
    80005514:	07e9                	addi	a5,a5,26
    80005516:	078e                	slli	a5,a5,0x3
    80005518:	94be                	add	s1,s1,a5
    8000551a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000551e:	fd043503          	ld	a0,-48(s0)
    80005522:	c55fe0ef          	jal	80004176 <fileclose>
    fileclose(wf);
    80005526:	fc843503          	ld	a0,-56(s0)
    8000552a:	c4dfe0ef          	jal	80004176 <fileclose>
    return -1;
    8000552e:	a015                	j	80005552 <sys_pipe+0xd2>
    if (fd0 >= 0)
    80005530:	fc442783          	lw	a5,-60(s0)
    80005534:	0007c763          	bltz	a5,80005542 <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    80005538:	07e9                	addi	a5,a5,26
    8000553a:	078e                	slli	a5,a5,0x3
    8000553c:	97a6                	add	a5,a5,s1
    8000553e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005542:	fd043503          	ld	a0,-48(s0)
    80005546:	c31fe0ef          	jal	80004176 <fileclose>
    fileclose(wf);
    8000554a:	fc843503          	ld	a0,-56(s0)
    8000554e:	c29fe0ef          	jal	80004176 <fileclose>
    return -1;
    80005552:	557d                	li	a0,-1
}
    80005554:	70e2                	ld	ra,56(sp)
    80005556:	7442                	ld	s0,48(sp)
    80005558:	74a2                	ld	s1,40(sp)
    8000555a:	6121                	addi	sp,sp,64
    8000555c:	8082                	ret
	...

0000000080005560 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005560:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005562:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005564:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005566:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005568:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000556a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000556c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000556e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005570:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005572:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005574:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005576:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005578:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000557a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000557c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000557e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005580:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005582:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005584:	944fd0ef          	jal	800026c8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005588:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000558a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000558c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000558e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005590:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005592:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005594:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005596:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005598:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000559a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000559c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000559e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800055a0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800055a2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800055a4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800055a6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800055a8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800055aa:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800055ac:	10200073          	sret
    800055b0:	0001                	nop
    800055b2:	00000013          	nop
    800055b6:	00000013          	nop
    800055ba:	00000013          	nop

00000000800055be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055be:	1141                	addi	sp,sp,-16
    800055c0:	e406                	sd	ra,8(sp)
    800055c2:	e022                	sd	s0,0(sp)
    800055c4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(volatile uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800055c6:	0c000737          	lui	a4,0xc000
    800055ca:	4785                	li	a5,1
    800055cc:	d71c                	sw	a5,40(a4)
  *(volatile uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800055ce:	c35c                	sw	a5,4(a4)
}
    800055d0:	60a2                	ld	ra,8(sp)
    800055d2:	6402                	ld	s0,0(sp)
    800055d4:	0141                	addi	sp,sp,16
    800055d6:	8082                	ret

00000000800055d8 <plicinithart>:

void
plicinithart(void)
{
    800055d8:	1141                	addi	sp,sp,-16
    800055da:	e406                	sd	ra,8(sp)
    800055dc:	e022                	sd	s0,0(sp)
    800055de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055e0:	b0efc0ef          	jal	800018ee <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(volatile uint32 *)PLIC_SENABLE(hart) =
    800055e4:	0085179b          	slliw	a5,a0,0x8
    800055e8:	0c002737          	lui	a4,0xc002
    800055ec:	08070713          	addi	a4,a4,128 # c002080 <_entry-0x73ffdf80>
    800055f0:	97ba                	add	a5,a5,a4
    800055f2:	40200713          	li	a4,1026
    800055f6:	c398                	sw	a4,0(a5)
    (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);

  // set this hart's S-mode priority threshold to 0.
  *(volatile uint32 *)PLIC_SPRIORITY(hart) = 0;
    800055f8:	00d5151b          	slliw	a0,a0,0xd
    800055fc:	0c2017b7          	lui	a5,0xc201
    80005600:	953e                	add	a0,a0,a5
    80005602:	00052023          	sw	zero,0(a0)
}
    80005606:	60a2                	ld	ra,8(sp)
    80005608:	6402                	ld	s0,0(sp)
    8000560a:	0141                	addi	sp,sp,16
    8000560c:	8082                	ret

000000008000560e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000560e:	1141                	addi	sp,sp,-16
    80005610:	e406                	sd	ra,8(sp)
    80005612:	e022                	sd	s0,0(sp)
    80005614:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005616:	ad8fc0ef          	jal	800018ee <cpuid>
  int irq = *(volatile uint32 *)PLIC_SCLAIM(hart);
    8000561a:	00d5151b          	slliw	a0,a0,0xd
    8000561e:	0c2017b7          	lui	a5,0xc201
    80005622:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    80005624:	953e                	add	a0,a0,a5
  return irq;
}
    80005626:	4108                	lw	a0,0(a0)
    80005628:	60a2                	ld	ra,8(sp)
    8000562a:	6402                	ld	s0,0(sp)
    8000562c:	0141                	addi	sp,sp,16
    8000562e:	8082                	ret

0000000080005630 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005630:	1101                	addi	sp,sp,-32
    80005632:	ec06                	sd	ra,24(sp)
    80005634:	e822                	sd	s0,16(sp)
    80005636:	e426                	sd	s1,8(sp)
    80005638:	1000                	addi	s0,sp,32
    8000563a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000563c:	ab2fc0ef          	jal	800018ee <cpuid>
  *(volatile uint32 *)PLIC_SCLAIM(hart) = irq;
    80005640:	00d5179b          	slliw	a5,a0,0xd
    80005644:	0c201737          	lui	a4,0xc201
    80005648:	0711                	addi	a4,a4,4 # c201004 <_entry-0x73dfeffc>
    8000564a:	97ba                	add	a5,a5,a4
    8000564c:	c384                	sw	s1,0(a5)
}
    8000564e:	60e2                	ld	ra,24(sp)
    80005650:	6442                	ld	s0,16(sp)
    80005652:	64a2                	ld	s1,8(sp)
    80005654:	6105                	addi	sp,sp,32
    80005656:	8082                	ret

0000000080005658 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005658:	1141                	addi	sp,sp,-16
    8000565a:	e406                	sd	ra,8(sp)
    8000565c:	e022                	sd	s0,0(sp)
    8000565e:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80005660:	479d                	li	a5,7
    80005662:	04a7ca63          	blt	a5,a0,800056b6 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005666:	0001b797          	auipc	a5,0x1b
    8000566a:	3f278793          	addi	a5,a5,1010 # 80020a58 <disk>
    8000566e:	97aa                	add	a5,a5,a0
    80005670:	0187c783          	lbu	a5,24(a5)
    80005674:	e7b9                	bnez	a5,800056c2 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005676:	00451693          	slli	a3,a0,0x4
    8000567a:	0001b797          	auipc	a5,0x1b
    8000567e:	3de78793          	addi	a5,a5,990 # 80020a58 <disk>
    80005682:	6398                	ld	a4,0(a5)
    80005684:	9736                	add	a4,a4,a3
    80005686:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000568a:	6398                	ld	a4,0(a5)
    8000568c:	9736                	add	a4,a4,a3
    8000568e:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005692:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005696:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000569a:	97aa                	add	a5,a5,a0
    8000569c:	4705                	li	a4,1
    8000569e:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800056a2:	0001b517          	auipc	a0,0x1b
    800056a6:	3ce50513          	addi	a0,a0,974 # 80020a70 <disk+0x18>
    800056aa:	8ddfc0ef          	jal	80001f86 <wakeup>
}
    800056ae:	60a2                	ld	ra,8(sp)
    800056b0:	6402                	ld	s0,0(sp)
    800056b2:	0141                	addi	sp,sp,16
    800056b4:	8082                	ret
    panic("free_desc 1");
    800056b6:	00002517          	auipc	a0,0x2
    800056ba:	f7a50513          	addi	a0,a0,-134 # 80007630 <etext+0x630>
    800056be:	98afb0ef          	jal	80000848 <panic>
    panic("free_desc 2");
    800056c2:	00002517          	auipc	a0,0x2
    800056c6:	f7e50513          	addi	a0,a0,-130 # 80007640 <etext+0x640>
    800056ca:	97efb0ef          	jal	80000848 <panic>

00000000800056ce <virtio_disk_init>:
{
    800056ce:	1101                	addi	sp,sp,-32
    800056d0:	ec06                	sd	ra,24(sp)
    800056d2:	e822                	sd	s0,16(sp)
    800056d4:	e426                	sd	s1,8(sp)
    800056d6:	e04a                	sd	s2,0(sp)
    800056d8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800056da:	00002597          	auipc	a1,0x2
    800056de:	f7658593          	addi	a1,a1,-138 # 80007650 <etext+0x650>
    800056e2:	0001b517          	auipc	a0,0x1b
    800056e6:	49e50513          	addi	a0,a0,1182 # 80020b80 <disk+0x128>
    800056ea:	ccefb0ef          	jal	80000bb8 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056ee:	100017b7          	lui	a5,0x10001
    800056f2:	4398                	lw	a4,0(a5)
    800056f4:	747277b7          	lui	a5,0x74727
    800056f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056fc:	14f71263          	bne	a4,a5,80005840 <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005700:	100017b7          	lui	a5,0x10001
    80005704:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005706:	4789                	li	a5,2
    80005708:	12f71c63          	bne	a4,a5,80005840 <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000570c:	100017b7          	lui	a5,0x10001
    80005710:	4798                	lw	a4,8(a5)
    80005712:	4789                	li	a5,2
    80005714:	12f71663          	bne	a4,a5,80005840 <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005718:	100017b7          	lui	a5,0x10001
    8000571c:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000571e:	554d47b7          	lui	a5,0x554d4
    80005722:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005726:	10f71d63          	bne	a4,a5,80005840 <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000572a:	100017b7          	lui	a5,0x10001
    8000572e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005732:	4705                	li	a4,1
    80005734:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005736:	470d                	li	a4,3
    80005738:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000573a:	10001737          	lui	a4,0x10001
    8000573e:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005740:	c7ffe6b7          	lui	a3,0xc7ffe
    80005744:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fdd9c7>
    80005748:	8f75                	and	a4,a4,a3
    8000574a:	100016b7          	lui	a3,0x10001
    8000574e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005750:	472d                	li	a4,11
    80005752:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005754:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005758:	00897793          	andi	a5,s2,8
    8000575c:	0e078863          	beqz	a5,8000584c <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005760:	100017b7          	lui	a5,0x10001
    80005764:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005768:	43fc                	lw	a5,68(a5)
    8000576a:	0e079763          	bnez	a5,80005858 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000576e:	100017b7          	lui	a5,0x10001
    80005772:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    80005774:	0e078863          	beqz	a5,80005864 <virtio_disk_init+0x196>
  if (max < NUM)
    80005778:	471d                	li	a4,7
    8000577a:	0ef77b63          	bgeu	a4,a5,80005870 <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    8000577e:	be0fb0ef          	jal	80000b5e <kalloc>
    80005782:	0001b497          	auipc	s1,0x1b
    80005786:	2d648493          	addi	s1,s1,726 # 80020a58 <disk>
    8000578a:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    8000578c:	bd2fb0ef          	jal	80000b5e <kalloc>
    80005790:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005792:	bccfb0ef          	jal	80000b5e <kalloc>
    80005796:	87aa                	mv	a5,a0
    80005798:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    8000579a:	6088                	ld	a0,0(s1)
    8000579c:	0e050063          	beqz	a0,8000587c <virtio_disk_init+0x1ae>
    800057a0:	0001b717          	auipc	a4,0x1b
    800057a4:	2c073703          	ld	a4,704(a4) # 80020a60 <disk+0x8>
    800057a8:	00173713          	seqz	a4,a4
    800057ac:	0017b793          	seqz	a5,a5
    800057b0:	8fd9                	or	a5,a5,a4
    800057b2:	e7e9                	bnez	a5,8000587c <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    800057b4:	6605                	lui	a2,0x1
    800057b6:	4581                	li	a1,0
    800057b8:	d3cfb0ef          	jal	80000cf4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800057bc:	0001b497          	auipc	s1,0x1b
    800057c0:	29c48493          	addi	s1,s1,668 # 80020a58 <disk>
    800057c4:	6605                	lui	a2,0x1
    800057c6:	4581                	li	a1,0
    800057c8:	6488                	ld	a0,8(s1)
    800057ca:	d2afb0ef          	jal	80000cf4 <memset>
  memset(disk.used, 0, PGSIZE);
    800057ce:	6605                	lui	a2,0x1
    800057d0:	4581                	li	a1,0
    800057d2:	6888                	ld	a0,16(s1)
    800057d4:	d20fb0ef          	jal	80000cf4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057d8:	100017b7          	lui	a5,0x10001
    800057dc:	4721                	li	a4,8
    800057de:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800057e0:	4098                	lw	a4,0(s1)
    800057e2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800057e6:	40d8                	lw	a4,4(s1)
    800057e8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057ec:	649c                	ld	a5,8(s1)
    800057ee:	10001737          	lui	a4,0x10001
    800057f2:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057f6:	9781                	srai	a5,a5,0x20
    800057f8:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057fc:	689c                	ld	a5,16(s1)
    800057fe:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005802:	9781                	srai	a5,a5,0x20
    80005804:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005808:	4785                	li	a5,1
    8000580a:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    8000580c:	00f48c23          	sb	a5,24(s1)
    80005810:	00f48ca3          	sb	a5,25(s1)
    80005814:	00f48d23          	sb	a5,26(s1)
    80005818:	00f48da3          	sb	a5,27(s1)
    8000581c:	00f48e23          	sb	a5,28(s1)
    80005820:	00f48ea3          	sb	a5,29(s1)
    80005824:	00f48f23          	sb	a5,30(s1)
    80005828:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000582c:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005830:	07272823          	sw	s2,112(a4)
}
    80005834:	60e2                	ld	ra,24(sp)
    80005836:	6442                	ld	s0,16(sp)
    80005838:	64a2                	ld	s1,8(sp)
    8000583a:	6902                	ld	s2,0(sp)
    8000583c:	6105                	addi	sp,sp,32
    8000583e:	8082                	ret
    panic("could not find virtio disk");
    80005840:	00002517          	auipc	a0,0x2
    80005844:	e2050513          	addi	a0,a0,-480 # 80007660 <etext+0x660>
    80005848:	800fb0ef          	jal	80000848 <panic>
    panic("virtio disk FEATURES_OK unset");
    8000584c:	00002517          	auipc	a0,0x2
    80005850:	e3450513          	addi	a0,a0,-460 # 80007680 <etext+0x680>
    80005854:	ff5fa0ef          	jal	80000848 <panic>
    panic("virtio disk should not be ready");
    80005858:	00002517          	auipc	a0,0x2
    8000585c:	e4850513          	addi	a0,a0,-440 # 800076a0 <etext+0x6a0>
    80005860:	fe9fa0ef          	jal	80000848 <panic>
    panic("virtio disk has no queue 0");
    80005864:	00002517          	auipc	a0,0x2
    80005868:	e5c50513          	addi	a0,a0,-420 # 800076c0 <etext+0x6c0>
    8000586c:	fddfa0ef          	jal	80000848 <panic>
    panic("virtio disk max queue too short");
    80005870:	00002517          	auipc	a0,0x2
    80005874:	e7050513          	addi	a0,a0,-400 # 800076e0 <etext+0x6e0>
    80005878:	fd1fa0ef          	jal	80000848 <panic>
    panic("virtio disk kalloc");
    8000587c:	00002517          	auipc	a0,0x2
    80005880:	e8450513          	addi	a0,a0,-380 # 80007700 <etext+0x700>
    80005884:	fc5fa0ef          	jal	80000848 <panic>

0000000080005888 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005888:	711d                	addi	sp,sp,-96
    8000588a:	ec86                	sd	ra,88(sp)
    8000588c:	e8a2                	sd	s0,80(sp)
    8000588e:	e4a6                	sd	s1,72(sp)
    80005890:	e0ca                	sd	s2,64(sp)
    80005892:	fc4e                	sd	s3,56(sp)
    80005894:	f852                	sd	s4,48(sp)
    80005896:	f456                	sd	s5,40(sp)
    80005898:	f05a                	sd	s6,32(sp)
    8000589a:	ec5e                	sd	s7,24(sp)
    8000589c:	e862                	sd	s8,16(sp)
    8000589e:	1080                	addi	s0,sp,96
    800058a0:	89aa                	mv	s3,a0
    800058a2:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058a4:	00c52b83          	lw	s7,12(a0)
    800058a8:	001b9b9b          	slliw	s7,s7,0x1
    800058ac:	1b82                	slli	s7,s7,0x20
    800058ae:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800058b2:	0001b517          	auipc	a0,0x1b
    800058b6:	2ce50513          	addi	a0,a0,718 # 80020b80 <disk+0x128>
    800058ba:	b7efb0ef          	jal	80000c38 <acquire>
  for (int i = 0; i < NUM; i++) {
    800058be:	44a1                	li	s1,8
      disk.free[i] = 0;
    800058c0:	0001ba97          	auipc	s5,0x1b
    800058c4:	198a8a93          	addi	s5,s5,408 # 80020a58 <disk>
  for (int i = 0; i < 3; i++) {
    800058c8:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800058ca:	5c7d                	li	s8,-1
    800058cc:	a8a5                	j	80005944 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800058ce:	00fa8733          	add	a4,s5,a5
    800058d2:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800058d6:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800058d8:	0207c563          	bltz	a5,80005902 <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    800058dc:	2905                	addiw	s2,s2,1
    800058de:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058e0:	07490663          	beq	s2,s4,8000594c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800058e4:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800058e6:	0001b717          	auipc	a4,0x1b
    800058ea:	17270713          	addi	a4,a4,370 # 80020a58 <disk>
    800058ee:	4781                	li	a5,0
    if (disk.free[i]) {
    800058f0:	01874683          	lbu	a3,24(a4)
    800058f4:	fee9                	bnez	a3,800058ce <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    800058f6:	2785                	addiw	a5,a5,1
    800058f8:	0705                	addi	a4,a4,1
    800058fa:	fe979be3          	bne	a5,s1,800058f0 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800058fe:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005902:	01205d63          	blez	s2,8000591c <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005906:	fa042503          	lw	a0,-96(s0)
    8000590a:	d4fff0ef          	jal	80005658 <free_desc>
      for (int j = 0; j < i; j++)
    8000590e:	4785                	li	a5,1
    80005910:	0127d663          	bge	a5,s2,8000591c <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005914:	fa442503          	lw	a0,-92(s0)
    80005918:	d41ff0ef          	jal	80005658 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    8000591c:	0001b517          	auipc	a0,0x1b
    80005920:	15450513          	addi	a0,a0,340 # 80020a70 <disk+0x18>
    80005924:	df6fc0ef          	jal	80001f1a <sleep_prepare>
    release(&disk.vdisk_lock);
    80005928:	0001b517          	auipc	a0,0x1b
    8000592c:	25850513          	addi	a0,a0,600 # 80020b80 <disk+0x128>
    80005930:	b8cfb0ef          	jal	80000cbc <release>
    sleep();
    80005934:	e22fc0ef          	jal	80001f56 <sleep>
    acquire(&disk.vdisk_lock);
    80005938:	0001b517          	auipc	a0,0x1b
    8000593c:	24850513          	addi	a0,a0,584 # 80020b80 <disk+0x128>
    80005940:	af8fb0ef          	jal	80000c38 <acquire>
  for (int i = 0; i < 3; i++) {
    80005944:	fa040613          	addi	a2,s0,-96
    80005948:	4901                	li	s2,0
    8000594a:	bf69                	j	800058e4 <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000594c:	fa042503          	lw	a0,-96(s0)
    80005950:	00451693          	slli	a3,a0,0x4

  if (write)
    80005954:	0001b797          	auipc	a5,0x1b
    80005958:	10478793          	addi	a5,a5,260 # 80020a58 <disk>
    8000595c:	00451713          	slli	a4,a0,0x4
    80005960:	0a070713          	addi	a4,a4,160
    80005964:	973e                	add	a4,a4,a5
    80005966:	01603633          	snez	a2,s6
    8000596a:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000596c:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005970:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005974:	6398                	ld	a4,0(a5)
    80005976:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005978:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    8000597c:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    8000597e:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005980:	6390                	ld	a2,0(a5)
    80005982:	00d605b3          	add	a1,a2,a3
    80005986:	4741                	li	a4,16
    80005988:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000598a:	4805                	li	a6,1
    8000598c:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005990:	fa442703          	lw	a4,-92(s0)
    80005994:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005998:	0712                	slli	a4,a4,0x4
    8000599a:	963a                	add	a2,a2,a4
    8000599c:	05898593          	addi	a1,s3,88
    800059a0:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800059a2:	0007b883          	ld	a7,0(a5)
    800059a6:	9746                	add	a4,a4,a7
    800059a8:	40000613          	li	a2,1024
    800059ac:	c710                	sw	a2,8(a4)
  if (write)
    800059ae:	001b3613          	seqz	a2,s6
    800059b2:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059b6:	01066633          	or	a2,a2,a6
    800059ba:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800059be:	fa842583          	lw	a1,-88(s0)
    800059c2:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059c6:	00250613          	addi	a2,a0,2
    800059ca:	0612                	slli	a2,a2,0x4
    800059cc:	963e                	add	a2,a2,a5
    800059ce:	577d                	li	a4,-1
    800059d0:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800059d4:	0592                	slli	a1,a1,0x4
    800059d6:	98ae                	add	a7,a7,a1
    800059d8:	03068713          	addi	a4,a3,48
    800059dc:	973e                	add	a4,a4,a5
    800059de:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059e2:	6398                	ld	a4,0(a5)
    800059e4:	972e                	add	a4,a4,a1
    800059e6:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059ea:	4689                	li	a3,2
    800059ec:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059f0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059f4:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800059f8:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059fc:	6794                	ld	a3,8(a5)
    800059fe:	0026d703          	lhu	a4,2(a3)
    80005a02:	8b1d                	andi	a4,a4,7
    80005a04:	0706                	slli	a4,a4,0x1
    80005a06:	96ba                	add	a3,a3,a4
    80005a08:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005a0c:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a10:	6798                	ld	a4,8(a5)
    80005a12:	00275783          	lhu	a5,2(a4)
    80005a16:	2785                	addiw	a5,a5,1
    80005a18:	00f71123          	sh	a5,2(a4)
    80005a1c:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a20:	100017b7          	lui	a5,0x10001
    80005a24:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005a28:	0049a783          	lw	a5,4(s3)
    80005a2c:	03079663          	bne	a5,a6,80005a58 <virtio_disk_rw+0x1d0>
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005a30:	0001b497          	auipc	s1,0x1b
    80005a34:	15048493          	addi	s1,s1,336 # 80020b80 <disk+0x128>
  while (b->disk == 1) {
    80005a38:	893e                	mv	s2,a5
    sleep_prepare(b);
    80005a3a:	854e                	mv	a0,s3
    80005a3c:	cdefc0ef          	jal	80001f1a <sleep_prepare>
    release(&disk.vdisk_lock);
    80005a40:	8526                	mv	a0,s1
    80005a42:	a7afb0ef          	jal	80000cbc <release>
    sleep();
    80005a46:	d10fc0ef          	jal	80001f56 <sleep>
    acquire(&disk.vdisk_lock);
    80005a4a:	8526                	mv	a0,s1
    80005a4c:	9ecfb0ef          	jal	80000c38 <acquire>
  while (b->disk == 1) {
    80005a50:	0049a783          	lw	a5,4(s3)
    80005a54:	ff2783e3          	beq	a5,s2,80005a3a <virtio_disk_rw+0x1b2>
  }

  disk.info[idx[0]].b = 0;
    80005a58:	fa042903          	lw	s2,-96(s0)
    80005a5c:	00290713          	addi	a4,s2,2
    80005a60:	0712                	slli	a4,a4,0x4
    80005a62:	0001b797          	auipc	a5,0x1b
    80005a66:	ff678793          	addi	a5,a5,-10 # 80020a58 <disk>
    80005a6a:	97ba                	add	a5,a5,a4
    80005a6c:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a70:	0001b997          	auipc	s3,0x1b
    80005a74:	fe898993          	addi	s3,s3,-24 # 80020a58 <disk>
    80005a78:	00491713          	slli	a4,s2,0x4
    80005a7c:	0009b783          	ld	a5,0(s3)
    80005a80:	97ba                	add	a5,a5,a4
    80005a82:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a86:	854a                	mv	a0,s2
    80005a88:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a8c:	bcdff0ef          	jal	80005658 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005a90:	8885                	andi	s1,s1,1
    80005a92:	f0fd                	bnez	s1,80005a78 <virtio_disk_rw+0x1f0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a94:	0001b517          	auipc	a0,0x1b
    80005a98:	0ec50513          	addi	a0,a0,236 # 80020b80 <disk+0x128>
    80005a9c:	a20fb0ef          	jal	80000cbc <release>
}
    80005aa0:	60e6                	ld	ra,88(sp)
    80005aa2:	6446                	ld	s0,80(sp)
    80005aa4:	64a6                	ld	s1,72(sp)
    80005aa6:	6906                	ld	s2,64(sp)
    80005aa8:	79e2                	ld	s3,56(sp)
    80005aaa:	7a42                	ld	s4,48(sp)
    80005aac:	7aa2                	ld	s5,40(sp)
    80005aae:	7b02                	ld	s6,32(sp)
    80005ab0:	6be2                	ld	s7,24(sp)
    80005ab2:	6c42                	ld	s8,16(sp)
    80005ab4:	6125                	addi	sp,sp,96
    80005ab6:	8082                	ret

0000000080005ab8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ab8:	1101                	addi	sp,sp,-32
    80005aba:	ec06                	sd	ra,24(sp)
    80005abc:	e822                	sd	s0,16(sp)
    80005abe:	e426                	sd	s1,8(sp)
    80005ac0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005ac2:	0001b497          	auipc	s1,0x1b
    80005ac6:	f9648493          	addi	s1,s1,-106 # 80020a58 <disk>
    80005aca:	0001b517          	auipc	a0,0x1b
    80005ace:	0b650513          	addi	a0,a0,182 # 80020b80 <disk+0x128>
    80005ad2:	966fb0ef          	jal	80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ad6:	100017b7          	lui	a5,0x10001
    80005ada:	53bc                	lw	a5,96(a5)
    80005adc:	8b8d                	andi	a5,a5,3
    80005ade:	10001737          	lui	a4,0x10001
    80005ae2:	d37c                	sw	a5,100(a4)
    80005ae4:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005ae8:	689c                	ld	a5,16(s1)
    80005aea:	0204d703          	lhu	a4,32(s1)
    80005aee:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005af2:	04f70663          	beq	a4,a5,80005b3e <virtio_disk_intr+0x86>
    80005af6:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005afa:	6898                	ld	a4,16(s1)
    80005afc:	0204d783          	lhu	a5,32(s1)
    80005b00:	8b9d                	andi	a5,a5,7
    80005b02:	078e                	slli	a5,a5,0x3
    80005b04:	97ba                	add	a5,a5,a4
    80005b06:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005b08:	00278713          	addi	a4,a5,2
    80005b0c:	0712                	slli	a4,a4,0x4
    80005b0e:	9726                	add	a4,a4,s1
    80005b10:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005b14:	e321                	bnez	a4,80005b54 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b16:	0789                	addi	a5,a5,2
    80005b18:	0792                	slli	a5,a5,0x4
    80005b1a:	97a6                	add	a5,a5,s1
    80005b1c:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005b1e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b22:	c64fc0ef          	jal	80001f86 <wakeup>

    disk.used_idx += 1;
    80005b26:	0204d783          	lhu	a5,32(s1)
    80005b2a:	2785                	addiw	a5,a5,1
    80005b2c:	17c2                	slli	a5,a5,0x30
    80005b2e:	93c1                	srli	a5,a5,0x30
    80005b30:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005b34:	6898                	ld	a4,16(s1)
    80005b36:	00275703          	lhu	a4,2(a4)
    80005b3a:	faf71ee3          	bne	a4,a5,80005af6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b3e:	0001b517          	auipc	a0,0x1b
    80005b42:	04250513          	addi	a0,a0,66 # 80020b80 <disk+0x128>
    80005b46:	976fb0ef          	jal	80000cbc <release>
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	64a2                	ld	s1,8(sp)
    80005b50:	6105                	addi	sp,sp,32
    80005b52:	8082                	ret
      panic("virtio_disk_intr status");
    80005b54:	00002517          	auipc	a0,0x2
    80005b58:	bc450513          	addi	a0,a0,-1084 # 80007718 <etext+0x718>
    80005b5c:	cedfa0ef          	jal	80000848 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
