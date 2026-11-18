
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00009797          	auipc	a5,0x9
      14:	91078793          	addi	a5,a5,-1776 # 8920 <malloc+0x2ae2>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	113050ef          	jal	595c <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	ec450513          	addi	a0,a0,-316 # 5f30 <malloc+0xf2>
      74:	50f050ef          	jal	5d82 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	0a3050ef          	jal	591c <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000a797          	auipc	a5,0xa
      82:	57a78793          	addi	a5,a5,1402 # a5f8 <uninit>
      86:	0000d697          	auipc	a3,0xd
      8a:	c8268693          	addi	a3,a3,-894 # cd08 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	eaa50513          	addi	a0,a0,-342 # 5f50 <malloc+0x112>
      ae:	4d5050ef          	jal	5d82 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	069050ef          	jal	591c <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	ea250513          	addi	a0,a0,-350 # 5f68 <malloc+0x12a>
      ce:	08f050ef          	jal	595c <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	06f050ef          	jal	5944 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	eac50513          	addi	a0,a0,-340 # 5f88 <malloc+0x14a>
      e4:	079050ef          	jal	595c <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	e7850513          	addi	a0,a0,-392 # 5f70 <malloc+0x132>
     100:	483050ef          	jal	5d82 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	017050ef          	jal	591c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	e8c50513          	addi	a0,a0,-372 # 5f98 <malloc+0x15a>
     114:	46f050ef          	jal	5d82 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	003050ef          	jal	591c <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	e9250513          	addi	a0,a0,-366 # 5fc0 <malloc+0x182>
     136:	037050ef          	jal	596c <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	e8250513          	addi	a0,a0,-382 # 5fc0 <malloc+0x182>
     146:	017050ef          	jal	595c <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	e8258593          	addi	a1,a1,-382 # 5fd0 <malloc+0x192>
     156:	7e6050ef          	jal	593c <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	e6250513          	addi	a0,a0,-414 # 5fc0 <malloc+0x182>
     166:	7f6050ef          	jal	595c <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	e6a58593          	addi	a1,a1,-406 # 5fd8 <malloc+0x19a>
     176:	8526                	mv	a0,s1
     178:	7c4050ef          	jal	593c <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	e3e50513          	addi	a0,a0,-450 # 5fc0 <malloc+0x182>
     18a:	7e2050ef          	jal	596c <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	7b4050ef          	jal	5944 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	7ae050ef          	jal	5944 <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	e3450513          	addi	a0,a0,-460 # 5fe0 <malloc+0x1a2>
     1b4:	3cf050ef          	jal	5d82 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	762050ef          	jal	591c <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	76a050ef          	jal	595c <open>
    close(fd);
     1f6:	74e050ef          	jal	5944 <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	74a050ef          	jal	596c <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00006517          	auipc	a0,0x6
     260:	dac50513          	addi	a0,a0,-596 # 6008 <malloc+0x1ca>
     264:	708050ef          	jal	596c <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00006a17          	auipc	s4,0x6
     274:	d98a0a13          	addi	s4,s4,-616 # 6008 <malloc+0x1ca>
    if (fd < 0) {
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000d997          	auipc	s3,0xd
     27e:	a8e98993          	addi	s3,s3,-1394 # cd08 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x55>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	6d0050ef          	jal	595c <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	69e050ef          	jal	593c <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	696050ef          	jal	5944 <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	6b8050ef          	jal	596c <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00006517          	auipc	a0,0x6
     2e0:	d3c50513          	addi	a0,a0,-708 # 6018 <malloc+0x1da>
     2e4:	29f050ef          	jal	5d82 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	632050ef          	jal	591c <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00006517          	auipc	a0,0x6
     2f8:	d4450513          	addi	a0,a0,-700 # 6038 <malloc+0x1fa>
     2fc:	287050ef          	jal	5d82 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	61a050ef          	jal	591c <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00006517          	auipc	a0,0x6
     31e:	d3650513          	addi	a0,a0,-714 # 6050 <malloc+0x212>
     322:	64a050ef          	jal	596c <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00006997          	auipc	s3,0x6
     332:	d2298993          	addi	s3,s3,-734 # 6050 <malloc+0x212>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	61a050ef          	jal	595c <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	5ec050ef          	jal	593c <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	5ee050ef          	jal	5944 <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	610050ef          	jal	596c <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00006517          	auipc	a0,0x6
     36e:	ce650513          	addi	a0,a0,-794 # 6050 <malloc+0x212>
     372:	5ea050ef          	jal	595c <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00006597          	auipc	a1,0x6
     382:	c5a58593          	addi	a1,a1,-934 # 5fd8 <malloc+0x19a>
     386:	5b6050ef          	jal	593c <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00006517          	auipc	a0,0x6
     394:	ce050513          	addi	a0,a0,-800 # 6070 <malloc+0x232>
     398:	1eb050ef          	jal	5d82 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	57e050ef          	jal	591c <exit>
      printf("open junk failed\n");
     3a2:	00006517          	auipc	a0,0x6
     3a6:	cb650513          	addi	a0,a0,-842 # 6058 <malloc+0x21a>
     3aa:	1d9050ef          	jal	5d82 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	56c050ef          	jal	591c <exit>
    printf("open junk failed\n");
     3b4:	00006517          	auipc	a0,0x6
     3b8:	ca450513          	addi	a0,a0,-860 # 6058 <malloc+0x21a>
     3bc:	1c7050ef          	jal	5d82 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	55a050ef          	jal	591c <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	57c050ef          	jal	5944 <close>
  unlink("junk");
     3cc:	00006517          	auipc	a0,0x6
     3d0:	c8450513          	addi	a0,a0,-892 # 6050 <malloc+0x212>
     3d4:	598050ef          	jal	596c <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	542050ef          	jal	591c <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	538050ef          	jal	596c <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	520050ef          	jal	595c <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	500050ef          	jal	5944 <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
  }

  for (int i = 0; i < nzz; i++) {
     44e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	4de050ef          	jal	596c <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00008797          	auipc	a5,0x8
     4c8:	45c78793          	addi	a5,a5,1116 # 8920 <malloc+0x2ae2>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00006a97          	auipc	s5,0x6
     4fa:	b8aa8a93          	addi	s5,s5,-1142 # 6080 <malloc+0x242>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	44e050ef          	jal	595c <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	420050ef          	jal	593c <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	41e050ef          	jal	5944 <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	440050ef          	jal	596c <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	406050ef          	jal	593c <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	3ec050ef          	jal	592c <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	3ec050ef          	jal	593c <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	3e8050ef          	jal	5944 <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	3e0050ef          	jal	5944 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00006517          	auipc	a0,0x6
     58c:	b0050513          	addi	a0,a0,-1280 # 6088 <malloc+0x24a>
     590:	7f2050ef          	jal	5d82 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	386050ef          	jal	591c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00006517          	auipc	a0,0x6
     5a2:	b0250513          	addi	a0,a0,-1278 # 60a0 <malloc+0x262>
     5a6:	7dc050ef          	jal	5d82 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	370050ef          	jal	591c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	b1c50513          	addi	a0,a0,-1252 # 60d0 <malloc+0x292>
     5bc:	7c6050ef          	jal	5d82 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	35a050ef          	jal	591c <exit>
      printf("pipe() failed\n");
     5c6:	00006517          	auipc	a0,0x6
     5ca:	b3a50513          	addi	a0,a0,-1222 # 6100 <malloc+0x2c2>
     5ce:	7b4050ef          	jal	5d82 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	348050ef          	jal	591c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00006517          	auipc	a0,0x6
     5e0:	b3450513          	addi	a0,a0,-1228 # 6110 <malloc+0x2d2>
     5e4:	79e050ef          	jal	5d82 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	332050ef          	jal	591c <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00008797          	auipc	a5,0x8
     60c:	31878793          	addi	a5,a5,792 # 8920 <malloc+0x2ae2>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00006b17          	auipc	s6,0x6
     640:	b04b0b13          	addi	s6,s6,-1276 # 6140 <malloc+0x302>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00006b97          	auipc	s7,0x6
     650:	98cb8b93          	addi	s7,s7,-1652 # 5fd8 <malloc+0x19a>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	300050ef          	jal	595c <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	2ca050ef          	jal	5934 <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	2d0050ef          	jal	5944 <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	2b2050ef          	jal	592c <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	2b2050ef          	jal	593c <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	29a050ef          	jal	5934 <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	29e050ef          	jal	5944 <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	296050ef          	jal	5944 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00006517          	auipc	a0,0x6
     6d6:	a7650513          	addi	a0,a0,-1418 # 6148 <malloc+0x30a>
     6da:	6a8050ef          	jal	5d82 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	23c050ef          	jal	591c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00006517          	auipc	a0,0x6
     6ec:	a7850513          	addi	a0,a0,-1416 # 6160 <malloc+0x322>
     6f0:	692050ef          	jal	5d82 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	226050ef          	jal	591c <exit>
      printf("pipe() failed\n");
     6fa:	00006517          	auipc	a0,0x6
     6fe:	a0650513          	addi	a0,a0,-1530 # 6100 <malloc+0x2c2>
     702:	680050ef          	jal	5d82 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	214050ef          	jal	591c <exit>
      printf("pipe write failed\n");
     70c:	00006517          	auipc	a0,0x6
     710:	a8450513          	addi	a0,a0,-1404 # 6190 <malloc+0x352>
     714:	66e050ef          	jal	5d82 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	202050ef          	jal	591c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00006517          	auipc	a0,0x6
     726:	a8650513          	addi	a0,a0,-1402 # 61a8 <malloc+0x36a>
     72a:	658050ef          	jal	5d82 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	1ec050ef          	jal	591c <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00006517          	auipc	a0,0x6
     74c:	87850513          	addi	a0,a0,-1928 # 5fc0 <malloc+0x182>
     750:	21c050ef          	jal	596c <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00006517          	auipc	a0,0x6
     75c:	86850513          	addi	a0,a0,-1944 # 5fc0 <malloc+0x182>
     760:	1fc050ef          	jal	595c <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00006597          	auipc	a1,0x6
     76c:	86858593          	addi	a1,a1,-1944 # 5fd0 <malloc+0x192>
     770:	1cc050ef          	jal	593c <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	1ce050ef          	jal	5944 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00006517          	auipc	a0,0x6
     780:	84450513          	addi	a0,a0,-1980 # 5fc0 <malloc+0x182>
     784:	1d8050ef          	jal	595c <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	1a2050ef          	jal	5934 <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00006517          	auipc	a0,0x6
     7a4:	82050513          	addi	a0,a0,-2016 # 5fc0 <malloc+0x182>
     7a8:	1b4050ef          	jal	595c <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00006517          	auipc	a0,0x6
     7b4:	81050513          	addi	a0,a0,-2032 # 5fc0 <malloc+0x182>
     7b8:	1a4050ef          	jal	595c <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	16e050ef          	jal	5934 <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	15c050ef          	jal	5934 <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00006597          	auipc	a1,0x6
     7e6:	a5658593          	addi	a1,a1,-1450 # 6238 <malloc+0x3fa>
     7ea:	854e                	mv	a0,s3
     7ec:	150050ef          	jal	593c <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	13a050ef          	jal	5934 <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	126050ef          	jal	5934 <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	7a850513          	addi	a0,a0,1960 # 5fc0 <malloc+0x182>
     820:	14c050ef          	jal	596c <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	11e050ef          	jal	5944 <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	118050ef          	jal	5944 <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	112050ef          	jal	5944 <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00006517          	auipc	a0,0x6
     850:	98c50513          	addi	a0,a0,-1652 # 61d8 <malloc+0x39a>
     854:	52e050ef          	jal	5d82 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	0c2050ef          	jal	591c <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00006517          	auipc	a0,0x6
     864:	99850513          	addi	a0,a0,-1640 # 61f8 <malloc+0x3ba>
     868:	51a050ef          	jal	5d82 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00006517          	auipc	a0,0x6
     874:	99850513          	addi	a0,a0,-1640 # 6208 <malloc+0x3ca>
     878:	50a050ef          	jal	5d82 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	09e050ef          	jal	591c <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00006517          	auipc	a0,0x6
     888:	9a450513          	addi	a0,a0,-1628 # 6228 <malloc+0x3ea>
     88c:	4f6050ef          	jal	5d82 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00006517          	auipc	a0,0x6
     898:	97450513          	addi	a0,a0,-1676 # 6208 <malloc+0x3ca>
     89c:	4e6050ef          	jal	5d82 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	07a050ef          	jal	591c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00006517          	auipc	a0,0x6
     8ae:	99650513          	addi	a0,a0,-1642 # 6240 <malloc+0x402>
     8b2:	4d0050ef          	jal	5d82 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	064050ef          	jal	591c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00006517          	auipc	a0,0x6
     8c4:	9a050513          	addi	a0,a0,-1632 # 6260 <malloc+0x422>
     8c8:	4ba050ef          	jal	5d82 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	04e050ef          	jal	591c <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00006517          	auipc	a0,0x6
     8f2:	99250513          	addi	a0,a0,-1646 # 6280 <malloc+0x442>
     8f6:	066050ef          	jal	595c <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00006a17          	auipc	s4,0x6
     908:	9a4a0a13          	addi	s4,s4,-1628 # 62a8 <malloc+0x46a>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00006b17          	auipc	s6,0x6
     910:	9d4b0b13          	addi	s6,s6,-1580 # 62e0 <malloc+0x4a2>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	01e050ef          	jal	593c <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	010050ef          	jal	593c <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	008050ef          	jal	5944 <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00006517          	auipc	a0,0x6
     946:	93e50513          	addi	a0,a0,-1730 # 6280 <malloc+0x442>
     94a:	012050ef          	jal	595c <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000c597          	auipc	a1,0xc
     95c:	3b058593          	addi	a1,a1,944 # cd08 <buf>
     960:	7d5040ef          	jal	5934 <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	7d7040ef          	jal	5944 <close>
  if (unlink("small") < 0) {
     972:	00006517          	auipc	a0,0x6
     976:	90e50513          	addi	a0,a0,-1778 # 6280 <malloc+0x442>
     97a:	7f3040ef          	jal	596c <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00006517          	auipc	a0,0x6
     99e:	8ee50513          	addi	a0,a0,-1810 # 6288 <malloc+0x44a>
     9a2:	3e0050ef          	jal	5d82 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	775040ef          	jal	591c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00006517          	auipc	a0,0x6
     9b4:	90850513          	addi	a0,a0,-1784 # 62b8 <malloc+0x47a>
     9b8:	3ca050ef          	jal	5d82 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	75f040ef          	jal	591c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00006517          	auipc	a0,0x6
     9ca:	92a50513          	addi	a0,a0,-1750 # 62f0 <malloc+0x4b2>
     9ce:	3b4050ef          	jal	5d82 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	749040ef          	jal	591c <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00006517          	auipc	a0,0x6
     9de:	93e50513          	addi	a0,a0,-1730 # 6318 <malloc+0x4da>
     9e2:	3a0050ef          	jal	5d82 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	735040ef          	jal	591c <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00006517          	auipc	a0,0x6
     9f2:	94a50513          	addi	a0,a0,-1718 # 6338 <malloc+0x4fa>
     9f6:	38c050ef          	jal	5d82 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	721040ef          	jal	591c <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00006517          	auipc	a0,0x6
     a06:	94e50513          	addi	a0,a0,-1714 # 6350 <malloc+0x512>
     a0a:	378050ef          	jal	5d82 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	70d040ef          	jal	591c <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00006517          	auipc	a0,0x6
     a32:	94250513          	addi	a0,a0,-1726 # 6370 <malloc+0x532>
     a36:	727040ef          	jal	595c <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000c997          	auipc	s3,0xc
     a46:	2c698993          	addi	s3,s3,710 # cd08 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	6e1040ef          	jal	593c <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	6d9040ef          	jal	5944 <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00006517          	auipc	a0,0x6
     a76:	8fe50513          	addi	a0,a0,-1794 # 6370 <malloc+0x532>
     a7a:	6e3040ef          	jal	595c <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000c917          	auipc	s2,0xc
     a8a:	28290913          	addi	s2,s2,642 # cd08 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	69d040ef          	jal	5934 <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00006517          	auipc	a0,0x6
     ab4:	8c850513          	addi	a0,a0,-1848 # 6378 <malloc+0x53a>
     ab8:	2ca050ef          	jal	5d82 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	65f040ef          	jal	591c <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00006517          	auipc	a0,0x6
     aca:	8d250513          	addi	a0,a0,-1838 # 6398 <malloc+0x55a>
     ace:	2b4050ef          	jal	5d82 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	649040ef          	jal	591c <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00006517          	auipc	a0,0x6
     ade:	8e650513          	addi	a0,a0,-1818 # 63c0 <malloc+0x582>
     ae2:	2a0050ef          	jal	5d82 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	635040ef          	jal	591c <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	64f040ef          	jal	5944 <close>
  if (unlink("big") < 0) {
     afa:	00006517          	auipc	a0,0x6
     afe:	87650513          	addi	a0,a0,-1930 # 6370 <malloc+0x532>
     b02:	66b040ef          	jal	596c <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00006517          	auipc	a0,0x6
     b26:	8be50513          	addi	a0,a0,-1858 # 63e0 <malloc+0x5a2>
     b2a:	258050ef          	jal	5d82 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	5ed040ef          	jal	591c <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	8d050513          	addi	a0,a0,-1840 # 6408 <malloc+0x5ca>
     b40:	242050ef          	jal	5d82 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	5d7040ef          	jal	591c <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00006517          	auipc	a0,0x6
     b52:	8d250513          	addi	a0,a0,-1838 # 6420 <malloc+0x5e2>
     b56:	22c050ef          	jal	5d82 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	5c1040ef          	jal	591c <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00006517          	auipc	a0,0x6
     b66:	8e650513          	addi	a0,a0,-1818 # 6448 <malloc+0x60a>
     b6a:	218050ef          	jal	5d82 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	5ad040ef          	jal	591c <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00006517          	auipc	a0,0x6
     b8c:	8d850513          	addi	a0,a0,-1832 # 6460 <malloc+0x622>
     b90:	5cd040ef          	jal	595c <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00006597          	auipc	a1,0x6
     ba0:	8f458593          	addi	a1,a1,-1804 # 6490 <malloc+0x652>
     ba4:	599040ef          	jal	593c <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	59b040ef          	jal	5944 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00006517          	auipc	a0,0x6
     bb4:	8b050513          	addi	a0,a0,-1872 # 6460 <malloc+0x622>
     bb8:	5a5040ef          	jal	595c <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00006517          	auipc	a0,0x6
     bc6:	89e50513          	addi	a0,a0,-1890 # 6460 <malloc+0x622>
     bca:	5a3040ef          	jal	596c <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00006517          	auipc	a0,0x6
     bd8:	88c50513          	addi	a0,a0,-1908 # 6460 <malloc+0x622>
     bdc:	581040ef          	jal	595c <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00006597          	auipc	a1,0x6
     be8:	8f458593          	addi	a1,a1,-1804 # 64d8 <malloc+0x69a>
     bec:	551040ef          	jal	593c <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	553040ef          	jal	5944 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000c597          	auipc	a1,0xc
     bfc:	11058593          	addi	a1,a1,272 # cd08 <buf>
     c00:	8526                	mv	a0,s1
     c02:	533040ef          	jal	5934 <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000c717          	auipc	a4,0xc
     c10:	0fc74703          	lbu	a4,252(a4) # cd08 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000c597          	auipc	a1,0xc
     c22:	0ea58593          	addi	a1,a1,234 # cd08 <buf>
     c26:	8526                	mv	a0,s1
     c28:	515040ef          	jal	593c <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	511040ef          	jal	5944 <close>
  unlink("unlinkread");
     c38:	00006517          	auipc	a0,0x6
     c3c:	82850513          	addi	a0,a0,-2008 # 6460 <malloc+0x622>
     c40:	52d040ef          	jal	596c <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00006517          	auipc	a0,0x6
     c58:	81c50513          	addi	a0,a0,-2020 # 6470 <malloc+0x632>
     c5c:	126050ef          	jal	5d82 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	4bb040ef          	jal	591c <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00006517          	auipc	a0,0x6
     c6c:	83050513          	addi	a0,a0,-2000 # 6498 <malloc+0x65a>
     c70:	112050ef          	jal	5d82 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	4a7040ef          	jal	591c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00006517          	auipc	a0,0x6
     c80:	83c50513          	addi	a0,a0,-1988 # 64b8 <malloc+0x67a>
     c84:	0fe050ef          	jal	5d82 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	493040ef          	jal	591c <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00006517          	auipc	a0,0x6
     c94:	85050513          	addi	a0,a0,-1968 # 64e0 <malloc+0x6a2>
     c98:	0ea050ef          	jal	5d82 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	47f040ef          	jal	591c <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00006517          	auipc	a0,0x6
     ca8:	85c50513          	addi	a0,a0,-1956 # 6500 <malloc+0x6c2>
     cac:	0d6050ef          	jal	5d82 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	46b040ef          	jal	591c <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00006517          	auipc	a0,0x6
     cbc:	86850513          	addi	a0,a0,-1944 # 6520 <malloc+0x6e2>
     cc0:	0c2050ef          	jal	5d82 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	457040ef          	jal	591c <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00006517          	auipc	a0,0x6
     cdc:	86850513          	addi	a0,a0,-1944 # 6540 <malloc+0x702>
     ce0:	48d040ef          	jal	596c <unlink>
  unlink("lf2");
     ce4:	00006517          	auipc	a0,0x6
     ce8:	86450513          	addi	a0,a0,-1948 # 6548 <malloc+0x70a>
     cec:	481040ef          	jal	596c <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00006517          	auipc	a0,0x6
     cf8:	84c50513          	addi	a0,a0,-1972 # 6540 <malloc+0x702>
     cfc:	461040ef          	jal	595c <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	78858593          	addi	a1,a1,1928 # 6490 <malloc+0x652>
     d10:	42d040ef          	jal	593c <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	429040ef          	jal	5944 <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00006597          	auipc	a1,0x6
     d24:	82858593          	addi	a1,a1,-2008 # 6548 <malloc+0x70a>
     d28:	00006517          	auipc	a0,0x6
     d2c:	81850513          	addi	a0,a0,-2024 # 6540 <malloc+0x702>
     d30:	44d040ef          	jal	597c <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00006517          	auipc	a0,0x6
     d3c:	80850513          	addi	a0,a0,-2040 # 6540 <malloc+0x702>
     d40:	42d040ef          	jal	596c <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	7fa50513          	addi	a0,a0,2042 # 6540 <malloc+0x702>
     d4e:	40f040ef          	jal	595c <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	7f050513          	addi	a0,a0,2032 # 6548 <malloc+0x70a>
     d60:	3fd040ef          	jal	595c <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000c597          	auipc	a1,0xc
     d70:	f9c58593          	addi	a1,a1,-100 # cd08 <buf>
     d74:	3c1040ef          	jal	5934 <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	3c5040ef          	jal	5944 <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	7c458593          	addi	a1,a1,1988 # 6548 <malloc+0x70a>
     d8c:	852e                	mv	a0,a1
     d8e:	3ef040ef          	jal	597c <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	7b250513          	addi	a0,a0,1970 # 6548 <malloc+0x70a>
     d9e:	3cf040ef          	jal	596c <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	79e58593          	addi	a1,a1,1950 # 6540 <malloc+0x702>
     daa:	00005517          	auipc	a0,0x5
     dae:	79e50513          	addi	a0,a0,1950 # 6548 <malloc+0x70a>
     db2:	3cb040ef          	jal	597c <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	78658593          	addi	a1,a1,1926 # 6540 <malloc+0x702>
     dc2:	00006517          	auipc	a0,0x6
     dc6:	88e50513          	addi	a0,a0,-1906 # 6650 <malloc+0x812>
     dca:	3b3040ef          	jal	597c <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	77050513          	addi	a0,a0,1904 # 6550 <malloc+0x712>
     de8:	79b040ef          	jal	5d82 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	32f040ef          	jal	591c <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	77450513          	addi	a0,a0,1908 # 6568 <malloc+0x72a>
     dfc:	787040ef          	jal	5d82 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	31b040ef          	jal	591c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	77850513          	addi	a0,a0,1912 # 6580 <malloc+0x742>
     e10:	773040ef          	jal	5d82 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	307040ef          	jal	591c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	78450513          	addi	a0,a0,1924 # 65a0 <malloc+0x762>
     e24:	75f040ef          	jal	5d82 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	2f3040ef          	jal	591c <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	7a050513          	addi	a0,a0,1952 # 65d0 <malloc+0x792>
     e38:	74b040ef          	jal	5d82 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	2df040ef          	jal	591c <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	7a450513          	addi	a0,a0,1956 # 65e8 <malloc+0x7aa>
     e4c:	737040ef          	jal	5d82 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	2cb040ef          	jal	591c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	7a850513          	addi	a0,a0,1960 # 6600 <malloc+0x7c2>
     e60:	723040ef          	jal	5d82 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	2b7040ef          	jal	591c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	7bc50513          	addi	a0,a0,1980 # 6628 <malloc+0x7ea>
     e74:	70f040ef          	jal	5d82 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	2a3040ef          	jal	591c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	7d850513          	addi	a0,a0,2008 # 6658 <malloc+0x81a>
     e88:	6fb040ef          	jal	5d82 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	28f040ef          	jal	591c <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	7ce98993          	addi	s3,s3,1998 # 6678 <malloc+0x83a>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	2bf040ef          	jal	597c <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	7a650513          	addi	a0,a0,1958 # 6688 <malloc+0x84a>
     eea:	699040ef          	jal	5d82 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	22d040ef          	jal	591c <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	79c50513          	addi	a0,a0,1948 # 66a8 <malloc+0x86a>
     f14:	259040ef          	jal	596c <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	78c50513          	addi	a0,a0,1932 # 66a8 <malloc+0x86a>
     f24:	239040ef          	jal	595c <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	219040ef          	jal	5944 <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	76e98993          	addi	s3,s3,1902 # 66a8 <malloc+0x86a>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	205040ef          	jal	597c <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	72250513          	addi	a0,a0,1826 # 66a8 <malloc+0x86a>
     f8e:	1df040ef          	jal	596c <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	19f040ef          	jal	596c <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	6be50513          	addi	a0,a0,1726 # 66b0 <malloc+0x872>
     ffa:	589040ef          	jal	5d82 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	11d040ef          	jal	591c <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	6c450513          	addi	a0,a0,1732 # 66d0 <malloc+0x892>
    1014:	56f040ef          	jal	5d82 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	103040ef          	jal	591c <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	6d850513          	addi	a0,a0,1752 # 66f8 <malloc+0x8ba>
    1028:	55b040ef          	jal	5d82 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	0ef040ef          	jal	591c <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00008497          	auipc	s1,0x8
    1044:	fc048493          	addi	s1,s1,-64 # 9000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	107040ef          	jal	5954 <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	0d9040ef          	jal	592c <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	0c3040ef          	jal	591c <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1d58>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00005997          	auipc	s3,0x5
    1082:	eea98993          	addi	s3,s3,-278 # 5f68 <malloc+0x12a>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	0c3040ef          	jal	5954 <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	081040ef          	jal	591c <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	0a7040ef          	jal	596c <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	085040ef          	jal	595c <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	095040ef          	jal	597c <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	6ee78793          	addi	a5,a5,1774 # 77e0 <malloc+0x19a2>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	04b040ef          	jal	5954 <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	001040ef          	jal	5914 <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00008797          	auipc	a5,0x8
    1124:	4d078793          	addi	a5,a5,1232 # 95f0 <big.0>
    1128:	00009697          	auipc	a3,0x9
    112c:	4c868693          	addi	a3,a3,1224 # a5f0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	00009797          	auipc	a5,0x9
    1142:	4a078923          	sb	zero,1202(a5) # a5f0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	7da78793          	addi	a5,a5,2010 # 8920 <malloc+0x2ae2>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00005517          	auipc	a0,0x5
    116e:	dfe50513          	addi	a0,a0,-514 # 5f68 <malloc+0x12a>
    1172:	7e2040ef          	jal	5954 <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	62250513          	addi	a0,a0,1570 # 67a0 <malloc+0x962>
    1186:	3fd040ef          	jal	5d82 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	790040ef          	jal	591c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	58250513          	addi	a0,a0,1410 # 6718 <malloc+0x8da>
    119e:	3e5040ef          	jal	5d82 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	778040ef          	jal	591c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	58a50513          	addi	a0,a0,1418 # 6738 <malloc+0x8fa>
    11b6:	3cd040ef          	jal	5d82 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	760040ef          	jal	591c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	59050513          	addi	a0,a0,1424 # 6758 <malloc+0x91a>
    11d0:	3b3040ef          	jal	5d82 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	746040ef          	jal	591c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	5a050513          	addi	a0,a0,1440 # 6780 <malloc+0x942>
    11e8:	39b040ef          	jal	5d82 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	72e040ef          	jal	591c <exit>
    printf("fork failed\n");
    11f2:	00007517          	auipc	a0,0x7
    11f6:	d8650513          	addi	a0,a0,-634 # 7f78 <malloc+0x213a>
    11fa:	389040ef          	jal	5d82 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	71c040ef          	jal	591c <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	714040ef          	jal	591c <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	710040ef          	jal	5924 <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	59c50513          	addi	a0,a0,1436 # 67c8 <malloc+0x98a>
    1234:	34f040ef          	jal	5d82 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	6e2040ef          	jal	591c <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00005517          	auipc	a0,0x5
    1252:	d7250513          	addi	a0,a0,-654 # 5fc0 <malloc+0x182>
    1256:	706040ef          	jal	595c <open>
    125a:	6ea040ef          	jal	5944 <close>
  pid = fork();
    125e:	6b6040ef          	jal	5914 <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00005997          	auipc	s3,0x5
    1282:	d4298993          	addi	s3,s3,-702 # 5fc0 <malloc+0x182>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	5a0b0b13          	addi	s6,s6,1440 # 6828 <malloc+0x9ea>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	6c0040ef          	jal	595c <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	692040ef          	jal	593c <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	690040ef          	jal	5944 <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	6a0040ef          	jal	595c <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	66e040ef          	jal	5934 <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	678040ef          	jal	5944 <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	644040ef          	jal	591c <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	50a50513          	addi	a0,a0,1290 # 67f8 <malloc+0x9ba>
    12f6:	28d040ef          	jal	5d82 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	620040ef          	jal	591c <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	50e50513          	addi	a0,a0,1294 # 6810 <malloc+0x9d2>
    130a:	279040ef          	jal	5d82 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	60c040ef          	jal	591c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	52050513          	addi	a0,a0,1312 # 6838 <malloc+0x9fa>
    1320:	263040ef          	jal	5d82 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	5f6040ef          	jal	591c <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
  if (pid == 0) {
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00005a17          	auipc	s4,0x5
    1342:	c82a0a13          	addi	s4,s4,-894 # 5fc0 <malloc+0x182>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	510b0b13          	addi	s6,s6,1296 # 6858 <malloc+0xa1a>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	608040ef          	jal	595c <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	5da040ef          	jal	593c <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	5d8040ef          	jal	5944 <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	5a6040ef          	jal	5924 <wait>
  unlink("truncfile");
    1382:	00005517          	auipc	a0,0x5
    1386:	c3e50513          	addi	a0,a0,-962 # 5fc0 <malloc+0x182>
    138a:	5e2040ef          	jal	596c <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	58a040ef          	jal	591c <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	47450513          	addi	a0,a0,1140 # 6810 <malloc+0x9d2>
    13a4:	1df040ef          	jal	5d82 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	572040ef          	jal	591c <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	4aa50513          	addi	a0,a0,1194 # 6860 <malloc+0xa22>
    13be:	1c5040ef          	jal	5d82 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	558040ef          	jal	591c <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	554040ef          	jal	592c <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	530040ef          	jal	5914 <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	54c040ef          	jal	5944 <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000ca17          	auipc	s4,0xc
    1404:	908a0a13          	addi	s4,s4,-1784 # cd08 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	524040ef          	jal	5934 <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000c797          	auipc	a5,0xc
    141e:	8ee78793          	addi	a5,a5,-1810 # cd08 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	42450513          	addi	a0,a0,1060 # 6880 <malloc+0xa42>
    1464:	11f040ef          	jal	5d82 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	4b2040ef          	jal	591c <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	4c8040ef          	jal	5944 <close>
    for (n = 0; n < N; n++) {
    1480:	0000cb17          	auipc	s6,0xc
    1484:	888b0b13          	addi	s6,s6,-1912 # cd08 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x47a>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	484040ef          	jal	593c <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	44c040ef          	jal	591c <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	3c250513          	addi	a0,a0,962 # 6898 <malloc+0xa5a>
    14de:	0a5040ef          	jal	5d82 <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	438040ef          	jal	591c <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	3c650513          	addi	a0,a0,966 # 68b0 <malloc+0xa72>
    14f2:	091040ef          	jal	5d82 <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	3ac50513          	addi	a0,a0,940 # 68c8 <malloc+0xa8a>
    1524:	05f040ef          	jal	5d82 <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	3f2040ef          	jal	591c <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	40c040ef          	jal	5944 <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	3e4040ef          	jal	5924 <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	3d4040ef          	jal	591c <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	39050513          	addi	a0,a0,912 # 68e8 <malloc+0xaaa>
    1560:	023040ef          	jal	5d82 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	3b6040ef          	jal	591c <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	38c040ef          	jal	5914 <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	38e040ef          	jal	5924 <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	23850513          	addi	a0,a0,568 # 67f8 <malloc+0x9ba>
    15c8:	7ba040ef          	jal	5d82 <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	34e040ef          	jal	591c <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	32c50513          	addi	a0,a0,812 # 6900 <malloc+0xac2>
    15dc:	7a6040ef          	jal	5d82 <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	33a040ef          	jal	591c <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	33050513          	addi	a0,a0,816 # 6918 <malloc+0xada>
    15f0:	792040ef          	jal	5d82 <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	326040ef          	jal	591c <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	320040ef          	jal	591c <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	302040ef          	jal	5914 <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	2f8040ef          	jal	5914 <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	2fc040ef          	jal	5924 <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	2f6040ef          	jal	5924 <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	1b450513          	addi	a0,a0,436 # 67f8 <malloc+0x9ba>
    164c:	736040ef          	jal	5d82 <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	2ca040ef          	jal	591c <exit>
      exit(0);
    1656:	2c6040ef          	jal	591c <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	19c50513          	addi	a0,a0,412 # 67f8 <malloc+0x9ba>
    1664:	71e040ef          	jal	5d82 <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	2b2040ef          	jal	591c <exit>
        exit(0);
    166e:	2ae040ef          	jal	591c <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	296040ef          	jal	5914 <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	28c040ef          	jal	5914 <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	28e040ef          	jal	5924 <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	280040ef          	jal	5924 <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	27e50513          	addi	a0,a0,638 # 6938 <malloc+0xafa>
    16c2:	6c0040ef          	jal	5d82 <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	254040ef          	jal	591c <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	244040ef          	jal	5914 <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	248040ef          	jal	5924 <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	236040ef          	jal	591c <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	230040ef          	jal	591c <exit>
          exit(0);
    16f0:	22c040ef          	jal	591c <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	25250513          	addi	a0,a0,594 # 6948 <malloc+0xb0a>
    16fe:	684040ef          	jal	5d82 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	218040ef          	jal	591c <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	1fe040ef          	jal	5914 <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	202040ef          	jal	5924 <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	1f0040ef          	jal	591c <exit>
      printf("fork failed\n");
    1730:	00007517          	auipc	a0,0x7
    1734:	84850513          	addi	a0,a0,-1976 # 7f78 <malloc+0x213a>
    1738:	64a040ef          	jal	5d82 <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	1de040ef          	jal	591c <exit>
      fork();
    1742:	1d2040ef          	jal	5914 <fork>
      fork();
    1746:	1ce040ef          	jal	5914 <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	1d0040ef          	jal	591c <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	1a0040ef          	jal	5914 <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	196040ef          	jal	5924 <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000993          	li	s3,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00005517          	auipc	a0,0x5
    17c0:	03c50513          	addi	a0,a0,60 # 67f8 <malloc+0x9ba>
    17c4:	5be040ef          	jal	5d82 <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	152040ef          	jal	591c <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	18050513          	addi	a0,a0,384 # 6968 <malloc+0xb2a>
    17f0:	592040ef          	jal	5d82 <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	126040ef          	jal	591c <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	15e040ef          	jal	596c <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	138040ef          	jal	595c <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	118040ef          	jal	5944 <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	0da040ef          	jal	591c <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	13850513          	addi	a0,a0,312 # 6980 <malloc+0xb42>
    1850:	532040ef          	jal	5d82 <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	0c6040ef          	jal	591c <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	0c0040ef          	jal	591c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1860:	f7040613          	addi	a2,s0,-144
    1864:	85ee                	mv	a1,s11
    1866:	00005517          	auipc	a0,0x5
    186a:	13250513          	addi	a0,a0,306 # 6998 <malloc+0xb5a>
    186e:	514040ef          	jal	5d82 <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	0a8040ef          	jal	591c <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1878:	02054063          	bltz	a0,1898 <createdelete+0x148>
        printf("%s: oops createdelete %s did exist\n", s, name);
    187c:	f7040613          	addi	a2,s0,-144
    1880:	85ee                	mv	a1,s11
    1882:	00005517          	auipc	a0,0x5
    1886:	13e50513          	addi	a0,a0,318 # 69c0 <malloc+0xb82>
    188a:	4f8040ef          	jal	5d82 <printf>
        exit(1);
    188e:	4505                	li	a0,1
    1890:	08c040ef          	jal	591c <exit>
        close(fd);
    1894:	0b0040ef          	jal	5944 <close>
    for (pi = 0; pi < NCHILD; pi++) {
    1898:	2485                	addiw	s1,s1,1
    189a:	0ff4f493          	zext.b	s1,s1
    189e:	03648463          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    18a2:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    18a6:	f73408a3          	sb	s3,-143(s0)
      fd = open(name, 0);
    18aa:	4581                	li	a1,0
    18ac:	8562                	mv	a0,s8
    18ae:	0ae040ef          	jal	595c <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18b2:	01f5579b          	srliw	a5,a0,0x1f
    18b6:	00f977b3          	and	a5,s2,a5
    18ba:	f3dd                	bnez	a5,1860 <createdelete+0x110>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18bc:	fb4bfee3          	bgeu	s7,s4,1878 <createdelete+0x128>
      if (fd >= 0)
    18c0:	fc054ce3          	bltz	a0,1898 <createdelete+0x148>
    18c4:	bfc1                	j	1894 <createdelete+0x144>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2985                	addiw	s3,s3,1
    18cc:	0ff9f993          	zext.b	s3,s3
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab913          	seqz	s2,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f96933          	or	s2,s2,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	bf7d                	j	18a2 <createdelete+0x152>
  for (i = 0; i < N; i++) {
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	066040ef          	jal	596c <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	67e50513          	addi	a0,a0,1662 # 5fd8 <malloc+0x19a>
    1962:	00a040ef          	jal	596c <unlink>
  pid = fork();
    1966:	7af030ef          	jal	5914 <fork>
  if (pid < 0) {
    196a:	04054663          	bltz	a0,19b6 <linkunlink+0x7a>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	00153913          	seqz	s2,a0
    1974:	41200933          	neg	s2,s2
    1978:	06097913          	andi	s2,s2,96
    197c:	0905                	addi	s2,s2,1
    197e:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1982:	41c65ab7          	lui	s5,0x41c65
    1986:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c55165>
    198a:	6a0d                	lui	s4,0x3
    198c:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4b3>
    if ((x % 3) == 0) {
    1990:	000ab9b7          	lui	s3,0xab
    1994:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9ada3>
    1998:	09b2                	slli	s3,s3,0xc
    199a:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    199e:	4b85                	li	s7,1
      unlink("x");
    19a0:	00004b17          	auipc	s6,0x4
    19a4:	638b0b13          	addi	s6,s6,1592 # 5fd8 <malloc+0x19a>
      link("cat", "x");
    19a8:	00005c97          	auipc	s9,0x5
    19ac:	040c8c93          	addi	s9,s9,64 # 69e8 <malloc+0xbaa>
      close(open("x", O_RDWR | O_CREATE));
    19b0:	20200c13          	li	s8,514
    19b4:	a03d                	j	19e2 <linkunlink+0xa6>
    printf("%s: fork failed\n", s);
    19b6:	85a6                	mv	a1,s1
    19b8:	00005517          	auipc	a0,0x5
    19bc:	e4050513          	addi	a0,a0,-448 # 67f8 <malloc+0x9ba>
    19c0:	3c2040ef          	jal	5d82 <printf>
    exit(1);
    19c4:	4505                	li	a0,1
    19c6:	757030ef          	jal	591c <exit>
      close(open("x", O_RDWR | O_CREATE));
    19ca:	85e2                	mv	a1,s8
    19cc:	855a                	mv	a0,s6
    19ce:	78f030ef          	jal	595c <open>
    19d2:	773030ef          	jal	5944 <close>
    19d6:	a021                	j	19de <linkunlink+0xa2>
      unlink("x");
    19d8:	855a                	mv	a0,s6
    19da:	793030ef          	jal	596c <unlink>
  for (i = 0; i < 100; i++) {
    19de:	34fd                	addiw	s1,s1,-1
    19e0:	c885                	beqz	s1,1a10 <linkunlink+0xd4>
    x = x * 1103515245 + 12345;
    19e2:	035907bb          	mulw	a5,s2,s5
    19e6:	00fa07bb          	addw	a5,s4,a5
    19ea:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19ec:	02079713          	slli	a4,a5,0x20
    19f0:	9301                	srli	a4,a4,0x20
    19f2:	03370733          	mul	a4,a4,s3
    19f6:	9305                	srli	a4,a4,0x21
    19f8:	0017169b          	slliw	a3,a4,0x1
    19fc:	9f35                	addw	a4,a4,a3
    19fe:	9f99                	subw	a5,a5,a4
    1a00:	d7e9                	beqz	a5,19ca <linkunlink+0x8e>
    } else if ((x % 3) == 1) {
    1a02:	fd779be3          	bne	a5,s7,19d8 <linkunlink+0x9c>
      link("cat", "x");
    1a06:	85da                	mv	a1,s6
    1a08:	8566                	mv	a0,s9
    1a0a:	773030ef          	jal	597c <link>
    1a0e:	bfc1                	j	19de <linkunlink+0xa2>
  if (pid)
    1a10:	020d0363          	beqz	s10,1a36 <linkunlink+0xfa>
    wait(0);
    1a14:	4501                	li	a0,0
    1a16:	70f030ef          	jal	5924 <wait>
}
    1a1a:	60e6                	ld	ra,88(sp)
    1a1c:	6446                	ld	s0,80(sp)
    1a1e:	64a6                	ld	s1,72(sp)
    1a20:	6906                	ld	s2,64(sp)
    1a22:	79e2                	ld	s3,56(sp)
    1a24:	7a42                	ld	s4,48(sp)
    1a26:	7aa2                	ld	s5,40(sp)
    1a28:	7b02                	ld	s6,32(sp)
    1a2a:	6be2                	ld	s7,24(sp)
    1a2c:	6c42                	ld	s8,16(sp)
    1a2e:	6ca2                	ld	s9,8(sp)
    1a30:	6d02                	ld	s10,0(sp)
    1a32:	6125                	addi	sp,sp,96
    1a34:	8082                	ret
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	6e5030ef          	jal	591c <exit>

0000000000001a3c <forktest>:
{
    1a3c:	7179                	addi	sp,sp,-48
    1a3e:	f406                	sd	ra,40(sp)
    1a40:	f022                	sd	s0,32(sp)
    1a42:	ec26                	sd	s1,24(sp)
    1a44:	e84a                	sd	s2,16(sp)
    1a46:	e44e                	sd	s3,8(sp)
    1a48:	1800                	addi	s0,sp,48
    1a4a:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a4c:	4481                	li	s1,0
    1a4e:	3e800913          	li	s2,1000
    pid = fork();
    1a52:	6c3030ef          	jal	5914 <fork>
    if (pid < 0)
    1a56:	06054063          	bltz	a0,1ab6 <forktest+0x7a>
    if (pid == 0)
    1a5a:	cd11                	beqz	a0,1a76 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a5c:	2485                	addiw	s1,s1,1
    1a5e:	ff249ae3          	bne	s1,s2,1a52 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a62:	85ce                	mv	a1,s3
    1a64:	00005517          	auipc	a0,0x5
    1a68:	fd450513          	addi	a0,a0,-44 # 6a38 <malloc+0xbfa>
    1a6c:	316040ef          	jal	5d82 <printf>
    exit(1);
    1a70:	4505                	li	a0,1
    1a72:	6ab030ef          	jal	591c <exit>
      exit(0);
    1a76:	6a7030ef          	jal	591c <exit>
    printf("%s: no fork at all!\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	f7450513          	addi	a0,a0,-140 # 69f0 <malloc+0xbb2>
    1a84:	2fe040ef          	jal	5d82 <printf>
    exit(1);
    1a88:	4505                	li	a0,1
    1a8a:	693030ef          	jal	591c <exit>
      printf("%s: wait stopped early\n", s);
    1a8e:	85ce                	mv	a1,s3
    1a90:	00005517          	auipc	a0,0x5
    1a94:	f7850513          	addi	a0,a0,-136 # 6a08 <malloc+0xbca>
    1a98:	2ea040ef          	jal	5d82 <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	67f030ef          	jal	591c <exit>
    printf("%s: wait got too many\n", s);
    1aa2:	85ce                	mv	a1,s3
    1aa4:	00005517          	auipc	a0,0x5
    1aa8:	f7c50513          	addi	a0,a0,-132 # 6a20 <malloc+0xbe2>
    1aac:	2d6040ef          	jal	5d82 <printf>
    exit(1);
    1ab0:	4505                	li	a0,1
    1ab2:	66b030ef          	jal	591c <exit>
  if (n == 0) {
    1ab6:	d0f1                	beqz	s1,1a7a <forktest+0x3e>
  for (; n > 0; n--) {
    1ab8:	00905963          	blez	s1,1aca <forktest+0x8e>
    if (wait(0) < 0) {
    1abc:	4501                	li	a0,0
    1abe:	667030ef          	jal	5924 <wait>
    1ac2:	fc0546e3          	bltz	a0,1a8e <forktest+0x52>
  for (; n > 0; n--) {
    1ac6:	34fd                	addiw	s1,s1,-1
    1ac8:	f8f5                	bnez	s1,1abc <forktest+0x80>
  if (wait(0) != -1) {
    1aca:	4501                	li	a0,0
    1acc:	659030ef          	jal	5924 <wait>
    1ad0:	57fd                	li	a5,-1
    1ad2:	fcf518e3          	bne	a0,a5,1aa2 <forktest+0x66>
}
    1ad6:	70a2                	ld	ra,40(sp)
    1ad8:	7402                	ld	s0,32(sp)
    1ada:	64e2                	ld	s1,24(sp)
    1adc:	6942                	ld	s2,16(sp)
    1ade:	69a2                	ld	s3,8(sp)
    1ae0:	6145                	addi	sp,sp,48
    1ae2:	8082                	ret

0000000000001ae4 <kernmem>:
{
    1ae4:	715d                	addi	sp,sp,-80
    1ae6:	e486                	sd	ra,72(sp)
    1ae8:	e0a2                	sd	s0,64(sp)
    1aea:	fc26                	sd	s1,56(sp)
    1aec:	f84a                	sd	s2,48(sp)
    1aee:	f44e                	sd	s3,40(sp)
    1af0:	f052                	sd	s4,32(sp)
    1af2:	ec56                	sd	s5,24(sp)
    1af4:	e85a                	sd	s6,16(sp)
    1af6:	0880                	addi	s0,sp,80
    1af8:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afa:	4485                	li	s1,1
    1afc:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1afe:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1b02:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b04:	69b1                	lui	s3,0xc
    1b06:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1d58>
    1b0a:	1003d937          	lui	s2,0x1003d
    1b0e:	090e                	slli	s2,s2,0x3
    1b10:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d778>
    pid = fork();
    1b14:	601030ef          	jal	5914 <fork>
    if (pid < 0) {
    1b18:	02054763          	bltz	a0,1b46 <kernmem+0x62>
    if (pid == 0) {
    1b1c:	cd1d                	beqz	a0,1b5a <kernmem+0x76>
    wait(&xstatus);
    1b1e:	8556                	mv	a0,s5
    1b20:	605030ef          	jal	5924 <wait>
    if (xstatus != -1) // did kernel kill child?
    1b24:	fbc42783          	lw	a5,-68(s0)
    1b28:	05479663          	bne	a5,s4,1b74 <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b2c:	94ce                	add	s1,s1,s3
    1b2e:	ff2493e3          	bne	s1,s2,1b14 <kernmem+0x30>
}
    1b32:	60a6                	ld	ra,72(sp)
    1b34:	6406                	ld	s0,64(sp)
    1b36:	74e2                	ld	s1,56(sp)
    1b38:	7942                	ld	s2,48(sp)
    1b3a:	79a2                	ld	s3,40(sp)
    1b3c:	7a02                	ld	s4,32(sp)
    1b3e:	6ae2                	ld	s5,24(sp)
    1b40:	6b42                	ld	s6,16(sp)
    1b42:	6161                	addi	sp,sp,80
    1b44:	8082                	ret
      printf("%s: fork failed\n", s);
    1b46:	85da                	mv	a1,s6
    1b48:	00005517          	auipc	a0,0x5
    1b4c:	cb050513          	addi	a0,a0,-848 # 67f8 <malloc+0x9ba>
    1b50:	232040ef          	jal	5d82 <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	5c7030ef          	jal	591c <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b5a:	0004c683          	lbu	a3,0(s1)
    1b5e:	8626                	mv	a2,s1
    1b60:	85da                	mv	a1,s6
    1b62:	00005517          	auipc	a0,0x5
    1b66:	efe50513          	addi	a0,a0,-258 # 6a60 <malloc+0xc22>
    1b6a:	218040ef          	jal	5d82 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	5ad030ef          	jal	591c <exit>
      exit(1);
    1b74:	4505                	li	a0,1
    1b76:	5a7030ef          	jal	591c <exit>

0000000000001b7a <MAXVAplus>:
{
    1b7a:	7139                	addi	sp,sp,-64
    1b7c:	fc06                	sd	ra,56(sp)
    1b7e:	f822                	sd	s0,48(sp)
    1b80:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b82:	4785                	li	a5,1
    1b84:	179a                	slli	a5,a5,0x26
    1b86:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b8a:	fc843783          	ld	a5,-56(s0)
    1b8e:	cf9d                	beqz	a5,1bcc <MAXVAplus+0x52>
    1b90:	f426                	sd	s1,40(sp)
    1b92:	f04a                	sd	s2,32(sp)
    1b94:	ec4e                	sd	s3,24(sp)
    1b96:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b98:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b9c:	54fd                	li	s1,-1
    pid = fork();
    1b9e:	577030ef          	jal	5914 <fork>
    if (pid < 0) {
    1ba2:	02054963          	bltz	a0,1bd4 <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba6:	c129                	beqz	a0,1be8 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba8:	854a                	mv	a0,s2
    1baa:	57b030ef          	jal	5924 <wait>
    if (xstatus != -1) // did kernel kill child?
    1bae:	fc442783          	lw	a5,-60(s0)
    1bb2:	04979d63          	bne	a5,s1,1c0c <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb6:	fc843783          	ld	a5,-56(s0)
    1bba:	0786                	slli	a5,a5,0x1
    1bbc:	fcf43423          	sd	a5,-56(s0)
    1bc0:	fc843783          	ld	a5,-56(s0)
    1bc4:	ffe9                	bnez	a5,1b9e <MAXVAplus+0x24>
    1bc6:	74a2                	ld	s1,40(sp)
    1bc8:	7902                	ld	s2,32(sp)
    1bca:	69e2                	ld	s3,24(sp)
}
    1bcc:	70e2                	ld	ra,56(sp)
    1bce:	7442                	ld	s0,48(sp)
    1bd0:	6121                	addi	sp,sp,64
    1bd2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bd4:	85ce                	mv	a1,s3
    1bd6:	00005517          	auipc	a0,0x5
    1bda:	c2250513          	addi	a0,a0,-990 # 67f8 <malloc+0x9ba>
    1bde:	1a4040ef          	jal	5d82 <printf>
      exit(1);
    1be2:	4505                	li	a0,1
    1be4:	539030ef          	jal	591c <exit>
      *(char *)a = 99;
    1be8:	fc843783          	ld	a5,-56(s0)
    1bec:	06300713          	li	a4,99
    1bf0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bf4:	fc843603          	ld	a2,-56(s0)
    1bf8:	85ce                	mv	a1,s3
    1bfa:	00005517          	auipc	a0,0x5
    1bfe:	e8650513          	addi	a0,a0,-378 # 6a80 <malloc+0xc42>
    1c02:	180040ef          	jal	5d82 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	515030ef          	jal	591c <exit>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	50f030ef          	jal	591c <exit>

0000000000001c12 <stacktest>:
{
    1c12:	7179                	addi	sp,sp,-48
    1c14:	f406                	sd	ra,40(sp)
    1c16:	f022                	sd	s0,32(sp)
    1c18:	ec26                	sd	s1,24(sp)
    1c1a:	1800                	addi	s0,sp,48
    1c1c:	84aa                	mv	s1,a0
  pid = fork();
    1c1e:	4f7030ef          	jal	5914 <fork>
  if (pid == 0) {
    1c22:	cd11                	beqz	a0,1c3e <stacktest+0x2c>
  } else if (pid < 0) {
    1c24:	02054c63          	bltz	a0,1c5c <stacktest+0x4a>
  wait(&xstatus);
    1c28:	fdc40513          	addi	a0,s0,-36
    1c2c:	4f9030ef          	jal	5924 <wait>
  if (xstatus == -1) // kernel killed child?
    1c30:	fdc42503          	lw	a0,-36(s0)
    1c34:	57fd                	li	a5,-1
    1c36:	02f50d63          	beq	a0,a5,1c70 <stacktest+0x5e>
    exit(xstatus);
    1c3a:	4e3030ef          	jal	591c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c3e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c40:	77fd                	lui	a5,0xfffff
    1c42:	97ba                	add	a5,a5,a4
    1c44:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef2f8>
    1c48:	85a6                	mv	a1,s1
    1c4a:	00005517          	auipc	a0,0x5
    1c4e:	e4e50513          	addi	a0,a0,-434 # 6a98 <malloc+0xc5a>
    1c52:	130040ef          	jal	5d82 <printf>
    exit(1);
    1c56:	4505                	li	a0,1
    1c58:	4c5030ef          	jal	591c <exit>
    printf("%s: fork failed\n", s);
    1c5c:	85a6                	mv	a1,s1
    1c5e:	00005517          	auipc	a0,0x5
    1c62:	b9a50513          	addi	a0,a0,-1126 # 67f8 <malloc+0x9ba>
    1c66:	11c040ef          	jal	5d82 <printf>
    exit(1);
    1c6a:	4505                	li	a0,1
    1c6c:	4b1030ef          	jal	591c <exit>
    exit(0);
    1c70:	4501                	li	a0,0
    1c72:	4ab030ef          	jal	591c <exit>

0000000000001c76 <nowrite>:
{
    1c76:	7159                	addi	sp,sp,-112
    1c78:	f486                	sd	ra,104(sp)
    1c7a:	f0a2                	sd	s0,96(sp)
    1c7c:	eca6                	sd	s1,88(sp)
    1c7e:	e8ca                	sd	s2,80(sp)
    1c80:	e4ce                	sd	s3,72(sp)
    1c82:	e0d2                	sd	s4,64(sp)
    1c84:	1880                	addi	s0,sp,112
    1c86:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c88:	00007797          	auipc	a5,0x7
    1c8c:	c9878793          	addi	a5,a5,-872 # 8920 <malloc+0x2ae2>
    1c90:	7788                	ld	a0,40(a5)
    1c92:	7b8c                	ld	a1,48(a5)
    1c94:	7f90                	ld	a2,56(a5)
    1c96:	63b4                	ld	a3,64(a5)
    1c98:	67b8                	ld	a4,72(a5)
    1c9a:	f8a43c23          	sd	a0,-104(s0)
    1c9e:	fab43023          	sd	a1,-96(s0)
    1ca2:	fac43423          	sd	a2,-88(s0)
    1ca6:	fad43823          	sd	a3,-80(s0)
    1caa:	fae43c23          	sd	a4,-72(s0)
    1cae:	6bbc                	ld	a5,80(a5)
    1cb0:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4481                	li	s1,0
    wait(&xstatus);
    1cb6:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cba:	4999                	li	s3,6
    pid = fork();
    1cbc:	459030ef          	jal	5914 <fork>
    if (pid == 0) {
    1cc0:	cd19                	beqz	a0,1cde <nowrite+0x68>
    } else if (pid < 0) {
    1cc2:	04054063          	bltz	a0,1d02 <nowrite+0x8c>
    wait(&xstatus);
    1cc6:	854a                	mv	a0,s2
    1cc8:	45d030ef          	jal	5924 <wait>
    if (xstatus == 0) {
    1ccc:	fcc42783          	lw	a5,-52(s0)
    1cd0:	c3b9                	beqz	a5,1d16 <nowrite+0xa0>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cd2:	2485                	addiw	s1,s1,1
    1cd4:	ff3494e3          	bne	s1,s3,1cbc <nowrite+0x46>
  exit(0);
    1cd8:	4501                	li	a0,0
    1cda:	443030ef          	jal	591c <exit>
      volatile int *addr = (int *)addrs[ai];
    1cde:	048e                	slli	s1,s1,0x3
    1ce0:	fd040793          	addi	a5,s0,-48
    1ce4:	94be                	add	s1,s1,a5
    1ce6:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1cea:	47a9                	li	a5,10
    1cec:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cee:	85d2                	mv	a1,s4
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	dd050513          	addi	a0,a0,-560 # 6ac0 <malloc+0xc82>
    1cf8:	08a040ef          	jal	5d82 <printf>
      exit(0);
    1cfc:	4501                	li	a0,0
    1cfe:	41f030ef          	jal	591c <exit>
      printf("%s: fork failed\n", s);
    1d02:	85d2                	mv	a1,s4
    1d04:	00005517          	auipc	a0,0x5
    1d08:	af450513          	addi	a0,a0,-1292 # 67f8 <malloc+0x9ba>
    1d0c:	076040ef          	jal	5d82 <printf>
      exit(1);
    1d10:	4505                	li	a0,1
    1d12:	40b030ef          	jal	591c <exit>
      exit(1);
    1d16:	4505                	li	a0,1
    1d18:	405030ef          	jal	591c <exit>

0000000000001d1c <manywrites>:
{
    1d1c:	7159                	addi	sp,sp,-112
    1d1e:	f486                	sd	ra,104(sp)
    1d20:	f0a2                	sd	s0,96(sp)
    1d22:	eca6                	sd	s1,88(sp)
    1d24:	e8ca                	sd	s2,80(sp)
    1d26:	e4ce                	sd	s3,72(sp)
    1d28:	ec66                	sd	s9,24(sp)
    1d2a:	1880                	addi	s0,sp,112
    1d2c:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2e:	4901                	li	s2,0
    1d30:	4991                	li	s3,4
    int pid = fork();
    1d32:	3e3030ef          	jal	5914 <fork>
    1d36:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d38:	02054c63          	bltz	a0,1d70 <manywrites+0x54>
    if (pid == 0) {
    1d3c:	c929                	beqz	a0,1d8e <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3e:	2905                	addiw	s2,s2,1
    1d40:	ff3919e3          	bne	s2,s3,1d32 <manywrites+0x16>
    1d44:	4491                	li	s1,4
    wait(&st);
    1d46:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d4a:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4e:	854a                	mv	a0,s2
    1d50:	3d5030ef          	jal	5924 <wait>
    if (st != 0)
    1d54:	f9842503          	lw	a0,-104(s0)
    1d58:	0e051763          	bnez	a0,1e46 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d5c:	34fd                	addiw	s1,s1,-1
    1d5e:	f4f5                	bnez	s1,1d4a <manywrites+0x2e>
    1d60:	e0d2                	sd	s4,64(sp)
    1d62:	fc56                	sd	s5,56(sp)
    1d64:	f85a                	sd	s6,48(sp)
    1d66:	f45e                	sd	s7,40(sp)
    1d68:	f062                	sd	s8,32(sp)
    1d6a:	e86a                	sd	s10,16(sp)
  exit(0);
    1d6c:	3b1030ef          	jal	591c <exit>
    1d70:	e0d2                	sd	s4,64(sp)
    1d72:	fc56                	sd	s5,56(sp)
    1d74:	f85a                	sd	s6,48(sp)
    1d76:	f45e                	sd	s7,40(sp)
    1d78:	f062                	sd	s8,32(sp)
    1d7a:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d7c:	00006517          	auipc	a0,0x6
    1d80:	1fc50513          	addi	a0,a0,508 # 7f78 <malloc+0x213a>
    1d84:	7ff030ef          	jal	5d82 <printf>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	393030ef          	jal	591c <exit>
    1d8e:	e0d2                	sd	s4,64(sp)
    1d90:	fc56                	sd	s5,56(sp)
    1d92:	f85a                	sd	s6,48(sp)
    1d94:	f45e                	sd	s7,40(sp)
    1d96:	f062                	sd	s8,32(sp)
    1d98:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d9a:	06200793          	li	a5,98
    1d9e:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1da2:	0619079b          	addiw	a5,s2,97
    1da6:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1daa:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1dae:	f9840513          	addi	a0,s0,-104
    1db2:	3bb030ef          	jal	596c <unlink>
    1db6:	47f9                	li	a5,30
    1db8:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1dba:	f9840b93          	addi	s7,s0,-104
    1dbe:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dc2:	6a8d                	lui	s5,0x3
    1dc4:	0000bc17          	auipc	s8,0xb
    1dc8:	f44c0c13          	addi	s8,s8,-188 # cd08 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dcc:	8a26                	mv	s4,s1
    1dce:	02094563          	bltz	s2,1df8 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dd2:	85da                	mv	a1,s6
    1dd4:	855e                	mv	a0,s7
    1dd6:	387030ef          	jal	595c <open>
    1dda:	89aa                	mv	s3,a0
          if (fd < 0) {
    1ddc:	02054d63          	bltz	a0,1e16 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1de0:	8656                	mv	a2,s5
    1de2:	85e2                	mv	a1,s8
    1de4:	359030ef          	jal	593c <write>
          if (cc != sz) {
    1de8:	05551363          	bne	a0,s5,1e2e <manywrites+0x112>
          close(fd);
    1dec:	854e                	mv	a0,s3
    1dee:	357030ef          	jal	5944 <close>
        for (int i = 0; i < ci + 1; i++) {
    1df2:	2a05                	addiw	s4,s4,1
    1df4:	fd495fe3          	bge	s2,s4,1dd2 <manywrites+0xb6>
        unlink(name);
    1df8:	f9840513          	addi	a0,s0,-104
    1dfc:	371030ef          	jal	596c <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1e00:	fffd079b          	addiw	a5,s10,-1
    1e04:	8d3e                	mv	s10,a5
    1e06:	f3f9                	bnez	a5,1dcc <manywrites+0xb0>
      unlink(name);
    1e08:	f9840513          	addi	a0,s0,-104
    1e0c:	361030ef          	jal	596c <unlink>
      exit(0);
    1e10:	4501                	li	a0,0
    1e12:	30b030ef          	jal	591c <exit>
            printf("%s: cannot create %s\n", s, name);
    1e16:	f9840613          	addi	a2,s0,-104
    1e1a:	85e6                	mv	a1,s9
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	cc450513          	addi	a0,a0,-828 # 6ae0 <malloc+0xca2>
    1e24:	75f030ef          	jal	5d82 <printf>
            exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	2f3030ef          	jal	591c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2e:	86aa                	mv	a3,a0
    1e30:	660d                	lui	a2,0x3
    1e32:	85e6                	mv	a1,s9
    1e34:	00004517          	auipc	a0,0x4
    1e38:	20450513          	addi	a0,a0,516 # 6038 <malloc+0x1fa>
    1e3c:	747030ef          	jal	5d82 <printf>
            exit(1);
    1e40:	4505                	li	a0,1
    1e42:	2db030ef          	jal	591c <exit>
    1e46:	e0d2                	sd	s4,64(sp)
    1e48:	fc56                	sd	s5,56(sp)
    1e4a:	f85a                	sd	s6,48(sp)
    1e4c:	f45e                	sd	s7,40(sp)
    1e4e:	f062                	sd	s8,32(sp)
    1e50:	e86a                	sd	s10,16(sp)
      exit(st);
    1e52:	2cb030ef          	jal	591c <exit>

0000000000001e56 <copyinstr3>:
{
    1e56:	7179                	addi	sp,sp,-48
    1e58:	f406                	sd	ra,40(sp)
    1e5a:	f022                	sd	s0,32(sp)
    1e5c:	ec26                	sd	s1,24(sp)
    1e5e:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e60:	6509                	lui	a0,0x2
    1e62:	287030ef          	jal	58e8 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e66:	4501                	li	a0,0
    1e68:	281030ef          	jal	58e8 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e6c:	03451793          	slli	a5,a0,0x34
    1e70:	e7bd                	bnez	a5,1ede <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e72:	4501                	li	a0,0
    1e74:	275030ef          	jal	58e8 <sbrk>
  if (top % PGSIZE) {
    1e78:	03451793          	slli	a5,a0,0x34
    1e7c:	ebad                	bnez	a5,1eee <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7e:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa5>
  *b = 'x';
    1e82:	07800793          	li	a5,120
    1e86:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e8a:	8526                	mv	a0,s1
    1e8c:	2e1030ef          	jal	596c <unlink>
  if (ret != -1) {
    1e90:	57fd                	li	a5,-1
    1e92:	06f51763          	bne	a0,a5,1f00 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e96:	20100593          	li	a1,513
    1e9a:	8526                	mv	a0,s1
    1e9c:	2c1030ef          	jal	595c <open>
  if (fd != -1) {
    1ea0:	57fd                	li	a5,-1
    1ea2:	06f51a63          	bne	a0,a5,1f16 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea6:	85a6                	mv	a1,s1
    1ea8:	8526                	mv	a0,s1
    1eaa:	2d3030ef          	jal	597c <link>
  if (ret != -1) {
    1eae:	57fd                	li	a5,-1
    1eb0:	06f51e63          	bne	a0,a5,1f2c <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb4:	00006797          	auipc	a5,0x6
    1eb8:	92c78793          	addi	a5,a5,-1748 # 77e0 <malloc+0x19a2>
    1ebc:	fcf43823          	sd	a5,-48(s0)
    1ec0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec4:	fd040593          	addi	a1,s0,-48
    1ec8:	8526                	mv	a0,s1
    1eca:	28b030ef          	jal	5954 <exec>
  if (ret != -1) {
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51a63          	bne	a0,a5,1f44 <copyinstr3+0xee>
}
    1ed4:	70a2                	ld	ra,40(sp)
    1ed6:	7402                	ld	s0,32(sp)
    1ed8:	64e2                	ld	s1,24(sp)
    1eda:	6145                	addi	sp,sp,48
    1edc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ede:	0347d513          	srli	a0,a5,0x34
    1ee2:	6785                	lui	a5,0x1
    1ee4:	40a7853b          	subw	a0,a5,a0
    1ee8:	201030ef          	jal	58e8 <sbrk>
    1eec:	b759                	j	1e72 <copyinstr3+0x1c>
    printf("oops\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	c0a50513          	addi	a0,a0,-1014 # 6af8 <malloc+0xcba>
    1ef6:	68d030ef          	jal	5d82 <printf>
    exit(1);
    1efa:	4505                	li	a0,1
    1efc:	221030ef          	jal	591c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f00:	862a                	mv	a2,a0
    1f02:	85a6                	mv	a1,s1
    1f04:	00005517          	auipc	a0,0x5
    1f08:	81450513          	addi	a0,a0,-2028 # 6718 <malloc+0x8da>
    1f0c:	677030ef          	jal	5d82 <printf>
    exit(1);
    1f10:	4505                	li	a0,1
    1f12:	20b030ef          	jal	591c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f16:	862a                	mv	a2,a0
    1f18:	85a6                	mv	a1,s1
    1f1a:	00005517          	auipc	a0,0x5
    1f1e:	81e50513          	addi	a0,a0,-2018 # 6738 <malloc+0x8fa>
    1f22:	661030ef          	jal	5d82 <printf>
    exit(1);
    1f26:	4505                	li	a0,1
    1f28:	1f5030ef          	jal	591c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f2c:	86aa                	mv	a3,a0
    1f2e:	8626                	mv	a2,s1
    1f30:	85a6                	mv	a1,s1
    1f32:	00005517          	auipc	a0,0x5
    1f36:	82650513          	addi	a0,a0,-2010 # 6758 <malloc+0x91a>
    1f3a:	649030ef          	jal	5d82 <printf>
    exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	1dd030ef          	jal	591c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f44:	863e                	mv	a2,a5
    1f46:	85a6                	mv	a1,s1
    1f48:	00005517          	auipc	a0,0x5
    1f4c:	83850513          	addi	a0,a0,-1992 # 6780 <malloc+0x942>
    1f50:	633030ef          	jal	5d82 <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	1c7030ef          	jal	591c <exit>

0000000000001f5a <rwsbrk>:
{
    1f5a:	1101                	addi	sp,sp,-32
    1f5c:	ec06                	sd	ra,24(sp)
    1f5e:	e822                	sd	s0,16(sp)
    1f60:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f62:	6509                	lui	a0,0x2
    1f64:	185030ef          	jal	58e8 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f68:	57fd                	li	a5,-1
    1f6a:	04f50a63          	beq	a0,a5,1fbe <rwsbrk+0x64>
    1f6e:	e426                	sd	s1,8(sp)
    1f70:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f72:	7579                	lui	a0,0xffffe
    1f74:	175030ef          	jal	58e8 <sbrk>
    1f78:	57fd                	li	a5,-1
    1f7a:	04f50d63          	beq	a0,a5,1fd4 <rwsbrk+0x7a>
    1f7e:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f80:	20100593          	li	a1,513
    1f84:	00005517          	auipc	a0,0x5
    1f88:	bb450513          	addi	a0,a0,-1100 # 6b38 <malloc+0xcfa>
    1f8c:	1d1030ef          	jal	595c <open>
    1f90:	892a                	mv	s2,a0
  if (fd < 0) {
    1f92:	04054b63          	bltz	a0,1fe8 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f96:	6785                	lui	a5,0x1
    1f98:	94be                	add	s1,s1,a5
    1f9a:	40000613          	li	a2,1024
    1f9e:	85a6                	mv	a1,s1
    1fa0:	19d030ef          	jal	593c <write>
    1fa4:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa6:	04054a63          	bltz	a0,1ffa <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1faa:	85a6                	mv	a1,s1
    1fac:	00005517          	auipc	a0,0x5
    1fb0:	bac50513          	addi	a0,a0,-1108 # 6b58 <malloc+0xd1a>
    1fb4:	5cf030ef          	jal	5d82 <printf>
    exit(1);
    1fb8:	4505                	li	a0,1
    1fba:	163030ef          	jal	591c <exit>
    1fbe:	e426                	sd	s1,8(sp)
    1fc0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fc2:	00005517          	auipc	a0,0x5
    1fc6:	b3e50513          	addi	a0,a0,-1218 # 6b00 <malloc+0xcc2>
    1fca:	5b9030ef          	jal	5d82 <printf>
    exit(1);
    1fce:	4505                	li	a0,1
    1fd0:	14d030ef          	jal	591c <exit>
    1fd4:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd6:	00005517          	auipc	a0,0x5
    1fda:	b4250513          	addi	a0,a0,-1214 # 6b18 <malloc+0xcda>
    1fde:	5a5030ef          	jal	5d82 <printf>
    exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	139030ef          	jal	591c <exit>
    printf("open(rwsbrk) failed\n");
    1fe8:	00005517          	auipc	a0,0x5
    1fec:	b5850513          	addi	a0,a0,-1192 # 6b40 <malloc+0xd02>
    1ff0:	593030ef          	jal	5d82 <printf>
    exit(1);
    1ff4:	4505                	li	a0,1
    1ff6:	127030ef          	jal	591c <exit>
  close(fd);
    1ffa:	854a                	mv	a0,s2
    1ffc:	149030ef          	jal	5944 <close>
  unlink("rwsbrk");
    2000:	00005517          	auipc	a0,0x5
    2004:	b3850513          	addi	a0,a0,-1224 # 6b38 <malloc+0xcfa>
    2008:	165030ef          	jal	596c <unlink>
  fd = open("README", O_RDONLY);
    200c:	4581                	li	a1,0
    200e:	00004517          	auipc	a0,0x4
    2012:	13250513          	addi	a0,a0,306 # 6140 <malloc+0x302>
    2016:	147030ef          	jal	595c <open>
    201a:	892a                	mv	s2,a0
  if (fd < 0) {
    201c:	02054363          	bltz	a0,2042 <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    2020:	4629                	li	a2,10
    2022:	85a6                	mv	a1,s1
    2024:	111030ef          	jal	5934 <read>
    2028:	862a                	mv	a2,a0
  if (n >= 0) {
    202a:	02054563          	bltz	a0,2054 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202e:	85a6                	mv	a1,s1
    2030:	00005517          	auipc	a0,0x5
    2034:	b5850513          	addi	a0,a0,-1192 # 6b88 <malloc+0xd4a>
    2038:	54b030ef          	jal	5d82 <printf>
    exit(1);
    203c:	4505                	li	a0,1
    203e:	0df030ef          	jal	591c <exit>
    printf("open(README) failed\n");
    2042:	00004517          	auipc	a0,0x4
    2046:	10650513          	addi	a0,a0,262 # 6148 <malloc+0x30a>
    204a:	539030ef          	jal	5d82 <printf>
    exit(1);
    204e:	4505                	li	a0,1
    2050:	0cd030ef          	jal	591c <exit>
  close(fd);
    2054:	854a                	mv	a0,s2
    2056:	0ef030ef          	jal	5944 <close>
  exit(0);
    205a:	4501                	li	a0,0
    205c:	0c1030ef          	jal	591c <exit>

0000000000002060 <sbrkbasic>:
{
    2060:	715d                	addi	sp,sp,-80
    2062:	e486                	sd	ra,72(sp)
    2064:	e0a2                	sd	s0,64(sp)
    2066:	ec56                	sd	s5,24(sp)
    2068:	0880                	addi	s0,sp,80
    206a:	8aaa                	mv	s5,a0
  pid = fork();
    206c:	0a9030ef          	jal	5914 <fork>
  if (pid < 0) {
    2070:	02054c63          	bltz	a0,20a8 <sbrkbasic+0x48>
  if (pid == 0) {
    2074:	ed31                	bnez	a0,20d0 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2076:	40000537          	lui	a0,0x40000
    207a:	06f030ef          	jal	58e8 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207e:	57fd                	li	a5,-1
    2080:	04f50163          	beq	a0,a5,20c2 <sbrkbasic+0x62>
    2084:	fc26                	sd	s1,56(sp)
    2086:	f84a                	sd	s2,48(sp)
    2088:	f44e                	sd	s3,40(sp)
    208a:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    208c:	400007b7          	lui	a5,0x40000
    2090:	97aa                	add	a5,a5,a0
      *b = 99;
    2092:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2096:	6705                	lui	a4,0x1
      *b = 99;
    2098:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff02f8>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    209c:	953a                	add	a0,a0,a4
    209e:	fef51de3          	bne	a0,a5,2098 <sbrkbasic+0x38>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	079030ef          	jal	591c <exit>
    20a8:	fc26                	sd	s1,56(sp)
    20aa:	f84a                	sd	s2,48(sp)
    20ac:	f44e                	sd	s3,40(sp)
    20ae:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20b0:	00005517          	auipc	a0,0x5
    20b4:	b0050513          	addi	a0,a0,-1280 # 6bb0 <malloc+0xd72>
    20b8:	4cb030ef          	jal	5d82 <printf>
    exit(1);
    20bc:	4505                	li	a0,1
    20be:	05f030ef          	jal	591c <exit>
    20c2:	fc26                	sd	s1,56(sp)
    20c4:	f84a                	sd	s2,48(sp)
    20c6:	f44e                	sd	s3,40(sp)
    20c8:	f052                	sd	s4,32(sp)
      exit(0);
    20ca:	4501                	li	a0,0
    20cc:	051030ef          	jal	591c <exit>
  wait(&xstatus);
    20d0:	fbc40513          	addi	a0,s0,-68
    20d4:	051030ef          	jal	5924 <wait>
  if (xstatus == 1) {
    20d8:	fbc42703          	lw	a4,-68(s0)
    20dc:	4785                	li	a5,1
    20de:	02f70063          	beq	a4,a5,20fe <sbrkbasic+0x9e>
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20ea:	4501                	li	a0,0
    20ec:	7fc030ef          	jal	58e8 <sbrk>
    20f0:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20f2:	4901                	li	s2,0
    b = sbrk(1);
    20f4:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f6:	6a05                	lui	s4,0x1
    20f8:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20fc:	a005                	j	211c <sbrkbasic+0xbc>
    20fe:	fc26                	sd	s1,56(sp)
    2100:	f84a                	sd	s2,48(sp)
    2102:	f44e                	sd	s3,40(sp)
    2104:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2106:	85d6                	mv	a1,s5
    2108:	00005517          	auipc	a0,0x5
    210c:	ac850513          	addi	a0,a0,-1336 # 6bd0 <malloc+0xd92>
    2110:	473030ef          	jal	5d82 <printf>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	007030ef          	jal	591c <exit>
  for (i = 0; i < 5000; i++) {
    211a:	84be                	mv	s1,a5
    b = sbrk(1);
    211c:	854e                	mv	a0,s3
    211e:	7ca030ef          	jal	58e8 <sbrk>
    if (b != a) {
    2122:	04951163          	bne	a0,s1,2164 <sbrkbasic+0x104>
    *b = 1;
    2126:	01348023          	sb	s3,0(s1)
    a = b + 1;
    212a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212e:	2905                	addiw	s2,s2,1
    2130:	ff4915e3          	bne	s2,s4,211a <sbrkbasic+0xba>
  pid = fork();
    2134:	7e0030ef          	jal	5914 <fork>
    2138:	892a                	mv	s2,a0
  if (pid < 0) {
    213a:	04054263          	bltz	a0,217e <sbrkbasic+0x11e>
  c = sbrk(1);
    213e:	4505                	li	a0,1
    2140:	7a8030ef          	jal	58e8 <sbrk>
  c = sbrk(1);
    2144:	4505                	li	a0,1
    2146:	7a2030ef          	jal	58e8 <sbrk>
  if (c != a + 1) {
    214a:	0489                	addi	s1,s1,2
    214c:	04950363          	beq	a0,s1,2192 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    2150:	85d6                	mv	a1,s5
    2152:	00005517          	auipc	a0,0x5
    2156:	ade50513          	addi	a0,a0,-1314 # 6c30 <malloc+0xdf2>
    215a:	429030ef          	jal	5d82 <printf>
    exit(1);
    215e:	4505                	li	a0,1
    2160:	7bc030ef          	jal	591c <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2164:	872a                	mv	a4,a0
    2166:	86a6                	mv	a3,s1
    2168:	864a                	mv	a2,s2
    216a:	85d6                	mv	a1,s5
    216c:	00005517          	auipc	a0,0x5
    2170:	a8450513          	addi	a0,a0,-1404 # 6bf0 <malloc+0xdb2>
    2174:	40f030ef          	jal	5d82 <printf>
      exit(1);
    2178:	4505                	li	a0,1
    217a:	7a2030ef          	jal	591c <exit>
    printf("%s: sbrk test fork failed\n", s);
    217e:	85d6                	mv	a1,s5
    2180:	00005517          	auipc	a0,0x5
    2184:	a9050513          	addi	a0,a0,-1392 # 6c10 <malloc+0xdd2>
    2188:	3fb030ef          	jal	5d82 <printf>
    exit(1);
    218c:	4505                	li	a0,1
    218e:	78e030ef          	jal	591c <exit>
  if (pid == 0)
    2192:	00091563          	bnez	s2,219c <sbrkbasic+0x13c>
    exit(0);
    2196:	4501                	li	a0,0
    2198:	784030ef          	jal	591c <exit>
  wait(&xstatus);
    219c:	fbc40513          	addi	a0,s0,-68
    21a0:	784030ef          	jal	5924 <wait>
  exit(xstatus);
    21a4:	fbc42503          	lw	a0,-68(s0)
    21a8:	774030ef          	jal	591c <exit>

00000000000021ac <sbrkmuch>:
{
    21ac:	7179                	addi	sp,sp,-48
    21ae:	f406                	sd	ra,40(sp)
    21b0:	f022                	sd	s0,32(sp)
    21b2:	ec26                	sd	s1,24(sp)
    21b4:	e84a                	sd	s2,16(sp)
    21b6:	e44e                	sd	s3,8(sp)
    21b8:	e052                	sd	s4,0(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21be:	4501                	li	a0,0
    21c0:	728030ef          	jal	58e8 <sbrk>
    21c4:	892a                	mv	s2,a0
  a = sbrk(0);
    21c6:	4501                	li	a0,0
    21c8:	720030ef          	jal	58e8 <sbrk>
    21cc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ce:	06400537          	lui	a0,0x6400
    21d2:	9d05                	subw	a0,a0,s1
    21d4:	714030ef          	jal	58e8 <sbrk>
  if (p != a) {
    21d8:	08a49763          	bne	s1,a0,2266 <sbrkmuch+0xba>
  *lastaddr = 99;
    21dc:	064007b7          	lui	a5,0x6400
    21e0:	06300713          	li	a4,99
    21e4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f02f7>
  a = sbrk(0);
    21e8:	4501                	li	a0,0
    21ea:	6fe030ef          	jal	58e8 <sbrk>
    21ee:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21f0:	757d                	lui	a0,0xfffff
    21f2:	6f6030ef          	jal	58e8 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f6:	57fd                	li	a5,-1
    21f8:	08f50163          	beq	a0,a5,227a <sbrkmuch+0xce>
  c = sbrk(0);
    21fc:	4501                	li	a0,0
    21fe:	6ea030ef          	jal	58e8 <sbrk>
  if (c != a - PGSIZE) {
    2202:	77fd                	lui	a5,0xfffff
    2204:	97a6                	add	a5,a5,s1
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe2>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	6dc030ef          	jal	58e8 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	6d4030ef          	jal	58e8 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfa>
    221e:	4501                	li	a0,0
    2220:	6c8030ef          	jal	58e8 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f02f7>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x112>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	6aa030ef          	jal	58e8 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	6a2030ef          	jal	58e8 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	69a030ef          	jal	58e8 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x126>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00005517          	auipc	a0,0x5
    226c:	9e850513          	addi	a0,a0,-1560 # 6c50 <malloc+0xe12>
    2270:	313030ef          	jal	5d82 <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	6a6030ef          	jal	591c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00005517          	auipc	a0,0x5
    2280:	a1c50513          	addi	a0,a0,-1508 # 6c98 <malloc+0xe5a>
    2284:	2ff030ef          	jal	5d82 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	692030ef          	jal	591c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00005517          	auipc	a0,0x5
    2298:	a2450513          	addi	a0,a0,-1500 # 6cb8 <malloc+0xe7a>
    229c:	2e7030ef          	jal	5d82 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	67a030ef          	jal	591c <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00005517          	auipc	a0,0x5
    22b0:	a4c50513          	addi	a0,a0,-1460 # 6cf8 <malloc+0xeba>
    22b4:	2cf030ef          	jal	5d82 <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	662030ef          	jal	591c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	a6850513          	addi	a0,a0,-1432 # 6d28 <malloc+0xeea>
    22c8:	2bb030ef          	jal	5d82 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	64e030ef          	jal	591c <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00005517          	auipc	a0,0x5
    22dc:	a8850513          	addi	a0,a0,-1400 # 6d60 <malloc+0xf22>
    22e0:	2a3030ef          	jal	5d82 <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	636030ef          	jal	591c <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	5ec030ef          	jal	58e8 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00005517          	auipc	a0,0x5
    230a:	a8250513          	addi	a0,a0,-1406 # 6d88 <malloc+0xf4a>
    230e:	64e030ef          	jal	595c <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00005517          	auipc	a0,0x5
    2318:	a7450513          	addi	a0,a0,-1420 # 6d88 <malloc+0xf4a>
    231c:	650030ef          	jal	596c <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	612030ef          	jal	593c <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	610030ef          	jal	5944 <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	5ae030ef          	jal	58e8 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	5ee030ef          	jal	592c <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00005517          	auipc	a0,0x5
    2358:	a3c50513          	addi	a0,a0,-1476 # 6d90 <malloc+0xf52>
    235c:	227030ef          	jal	5d82 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	5ba030ef          	jal	591c <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00005517          	auipc	a0,0x5
    236c:	a4050513          	addi	a0,a0,-1472 # 6da8 <malloc+0xf6a>
    2370:	213030ef          	jal	5d82 <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	5a6030ef          	jal	591c <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	50450513          	addi	a0,a0,1284 # 6880 <malloc+0xa42>
    2384:	1ff030ef          	jal	5d82 <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	592030ef          	jal	591c <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00005517          	auipc	a0,0x5
    23a2:	a2250513          	addi	a0,a0,-1502 # 6dc0 <malloc+0xf82>
    23a6:	5b6030ef          	jal	595c <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	536030ef          	jal	58e8 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	576030ef          	jal	5934 <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	580030ef          	jal	5944 <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	43a50513          	addi	a0,a0,1082 # 6810 <malloc+0x9d2>
    23de:	1a5030ef          	jal	5d82 <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	538030ef          	jal	591c <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	524030ef          	jal	5914 <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	4ee030ef          	jal	58e8 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	4e6030ef          	jal	58e8 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	514030ef          	jal	591c <exit>
    printf("fork failed\n");
    240c:	00006517          	auipc	a0,0x6
    2410:	b6c50513          	addi	a0,a0,-1172 # 7f78 <malloc+0x213a>
    2414:	16f030ef          	jal	5d82 <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	502030ef          	jal	591c <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	504030ef          	jal	5924 <wait>
  pid = fork();
    2424:	4f0030ef          	jal	5914 <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	4ba030ef          	jal	58e8 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	4ac030ef          	jal	58e8 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	4da030ef          	jal	591c <exit>
    printf("fork failed\n");
    2446:	00006517          	auipc	a0,0x6
    244a:	b3250513          	addi	a0,a0,-1230 # 7f78 <malloc+0x213a>
    244e:	135030ef          	jal	5d82 <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	4c8030ef          	jal	591c <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	4ca030ef          	jal	5924 <wait>
  pid = fork();
    245e:	4b6030ef          	jal	5914 <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	480030ef          	jal	58e8 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x208>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	472030ef          	jal	58e8 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	46c030ef          	jal	58e8 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	49a030ef          	jal	591c <exit>
    printf("fork failed\n");
    2486:	00006517          	auipc	a0,0x6
    248a:	af250513          	addi	a0,a0,-1294 # 7f78 <malloc+0x213a>
    248e:	0f5030ef          	jal	5d82 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	488030ef          	jal	591c <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	48a030ef          	jal	5924 <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	47c030ef          	jal	591c <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	432030ef          	jal	58e8 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	426030ef          	jal	58e8 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	420030ef          	jal	58e8 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	41a030ef          	jal	58e8 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	414030ef          	jal	58e8 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	46c030ef          	jal	595c <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	442030ef          	jal	593c <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	444030ef          	jal	5944 <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	454030ef          	jal	595c <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	420030ef          	jal	5934 <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	3ae030ef          	jal	58e8 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	3da030ef          	jal	591c <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff02fc>
    2554:	394030ef          	jal	58e8 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	38e030ef          	jal	58e8 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	fef50fa3          	sb	a5,-1(a0)
}
    2568:	60a2                	ld	ra,8(sp)
    256a:	6402                	ld	s0,0(sp)
    256c:	0141                	addi	sp,sp,16
    256e:	8082                	ret

0000000000002570 <execout>:
{
    2570:	711d                	addi	sp,sp,-96
    2572:	ec86                	sd	ra,88(sp)
    2574:	e8a2                	sd	s0,80(sp)
    2576:	e4a6                	sd	s1,72(sp)
    2578:	e0ca                	sd	s2,64(sp)
    257a:	fc4e                	sd	s3,56(sp)
    257c:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    257e:	4901                	li	s2,0
    2580:	49bd                	li	s3,15
    int pid = fork();
    2582:	392030ef          	jal	5914 <fork>
    2586:	84aa                	mv	s1,a0
    if (pid < 0) {
    2588:	00054e63          	bltz	a0,25a4 <execout+0x34>
    } else if (pid == 0) {
    258c:	c51d                	beqz	a0,25ba <execout+0x4a>
      wait((int *)0);
    258e:	4501                	li	a0,0
    2590:	394030ef          	jal	5924 <wait>
  for (int avail = 0; avail < 15; avail++) {
    2594:	2905                	addiw	s2,s2,1
    2596:	ff3916e3          	bne	s2,s3,2582 <execout+0x12>
    259a:	f852                	sd	s4,48(sp)
    259c:	f456                	sd	s5,40(sp)
  exit(0);
    259e:	4501                	li	a0,0
    25a0:	37c030ef          	jal	591c <exit>
    25a4:	f852                	sd	s4,48(sp)
    25a6:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25a8:	00006517          	auipc	a0,0x6
    25ac:	9d050513          	addi	a0,a0,-1584 # 7f78 <malloc+0x213a>
    25b0:	7d2030ef          	jal	5d82 <printf>
      exit(1);
    25b4:	4505                	li	a0,1
    25b6:	366030ef          	jal	591c <exit>
    25ba:	f852                	sd	s4,48(sp)
    25bc:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25be:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c0:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c2:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c4:	854e                	mv	a0,s3
    25c6:	322030ef          	jal	58e8 <sbrk>
        if (a == SBRK_ERROR)
    25ca:	01450663          	beq	a0,s4,25d6 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25ce:	954e                	add	a0,a0,s3
    25d0:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d4:	bfc5                	j	25c4 <execout+0x54>
        sbrk(-PGSIZE);
    25d6:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25d8:	01205863          	blez	s2,25e8 <execout+0x78>
        sbrk(-PGSIZE);
    25dc:	854e                	mv	a0,s3
    25de:	30a030ef          	jal	58e8 <sbrk>
      for (int i = 0; i < avail; i++)
    25e2:	2485                	addiw	s1,s1,1
    25e4:	ff249ce3          	bne	s1,s2,25dc <execout+0x6c>
      close(1);
    25e8:	4505                	li	a0,1
    25ea:	35a030ef          	jal	5944 <close>
      char *args[] = {"echo", "x", 0};
    25ee:	00004797          	auipc	a5,0x4
    25f2:	97a78793          	addi	a5,a5,-1670 # 5f68 <malloc+0x12a>
    25f6:	faf43423          	sd	a5,-88(s0)
    25fa:	00004797          	auipc	a5,0x4
    25fe:	9de78793          	addi	a5,a5,-1570 # 5fd8 <malloc+0x19a>
    2602:	faf43823          	sd	a5,-80(s0)
    2606:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260a:	fa840593          	addi	a1,s0,-88
    260e:	00004517          	auipc	a0,0x4
    2612:	95a50513          	addi	a0,a0,-1702 # 5f68 <malloc+0x12a>
    2616:	33e030ef          	jal	5954 <exec>
      exit(0);
    261a:	4501                	li	a0,0
    261c:	300030ef          	jal	591c <exit>

0000000000002620 <fourteen>:
{
    2620:	1101                	addi	sp,sp,-32
    2622:	ec06                	sd	ra,24(sp)
    2624:	e822                	sd	s0,16(sp)
    2626:	e426                	sd	s1,8(sp)
    2628:	1000                	addi	s0,sp,32
    262a:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    262c:	00005517          	auipc	a0,0x5
    2630:	96c50513          	addi	a0,a0,-1684 # 6f98 <malloc+0x115a>
    2634:	350030ef          	jal	5984 <mkdir>
    2638:	e555                	bnez	a0,26e4 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263a:	00004517          	auipc	a0,0x4
    263e:	7b650513          	addi	a0,a0,1974 # 6df0 <malloc+0xfb2>
    2642:	342030ef          	jal	5984 <mkdir>
    2646:	e94d                	bnez	a0,26f8 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2648:	20000593          	li	a1,512
    264c:	00004517          	auipc	a0,0x4
    2650:	7fc50513          	addi	a0,a0,2044 # 6e48 <malloc+0x100a>
    2654:	308030ef          	jal	595c <open>
  if (fd < 0) {
    2658:	0a054a63          	bltz	a0,270c <fourteen+0xec>
  close(fd);
    265c:	2e8030ef          	jal	5944 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2660:	4581                	li	a1,0
    2662:	00005517          	auipc	a0,0x5
    2666:	85e50513          	addi	a0,a0,-1954 # 6ec0 <malloc+0x1082>
    266a:	2f2030ef          	jal	595c <open>
  if (fd < 0) {
    266e:	0a054963          	bltz	a0,2720 <fourteen+0x100>
  close(fd);
    2672:	2d2030ef          	jal	5944 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2676:	00005517          	auipc	a0,0x5
    267a:	8ba50513          	addi	a0,a0,-1862 # 6f30 <malloc+0x10f2>
    267e:	306030ef          	jal	5984 <mkdir>
    2682:	c94d                	beqz	a0,2734 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2684:	00005517          	auipc	a0,0x5
    2688:	90450513          	addi	a0,a0,-1788 # 6f88 <malloc+0x114a>
    268c:	2f8030ef          	jal	5984 <mkdir>
    2690:	cd45                	beqz	a0,2748 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2692:	00005517          	auipc	a0,0x5
    2696:	8f650513          	addi	a0,a0,-1802 # 6f88 <malloc+0x114a>
    269a:	2d2030ef          	jal	596c <unlink>
  unlink("12345678901234/12345678901234");
    269e:	00005517          	auipc	a0,0x5
    26a2:	89250513          	addi	a0,a0,-1902 # 6f30 <malloc+0x10f2>
    26a6:	2c6030ef          	jal	596c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26aa:	00005517          	auipc	a0,0x5
    26ae:	81650513          	addi	a0,a0,-2026 # 6ec0 <malloc+0x1082>
    26b2:	2ba030ef          	jal	596c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	79250513          	addi	a0,a0,1938 # 6e48 <malloc+0x100a>
    26be:	2ae030ef          	jal	596c <unlink>
  unlink("12345678901234/123456789012345");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	72e50513          	addi	a0,a0,1838 # 6df0 <malloc+0xfb2>
    26ca:	2a2030ef          	jal	596c <unlink>
  unlink("12345678901234");
    26ce:	00005517          	auipc	a0,0x5
    26d2:	8ca50513          	addi	a0,a0,-1846 # 6f98 <malloc+0x115a>
    26d6:	296030ef          	jal	596c <unlink>
}
    26da:	60e2                	ld	ra,24(sp)
    26dc:	6442                	ld	s0,16(sp)
    26de:	64a2                	ld	s1,8(sp)
    26e0:	6105                	addi	sp,sp,32
    26e2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	6e250513          	addi	a0,a0,1762 # 6dc8 <malloc+0xf8a>
    26ee:	694030ef          	jal	5d82 <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	228030ef          	jal	591c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	71650513          	addi	a0,a0,1814 # 6e10 <malloc+0xfd2>
    2702:	680030ef          	jal	5d82 <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	214030ef          	jal	591c <exit>
    printf(
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	76a50513          	addi	a0,a0,1898 # 6e78 <malloc+0x103a>
    2716:	66c030ef          	jal	5d82 <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	200030ef          	jal	591c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	7ce50513          	addi	a0,a0,1998 # 6ef0 <malloc+0x10b2>
    272a:	658030ef          	jal	5d82 <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	1ec030ef          	jal	591c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2734:	85a6                	mv	a1,s1
    2736:	00005517          	auipc	a0,0x5
    273a:	81a50513          	addi	a0,a0,-2022 # 6f50 <malloc+0x1112>
    273e:	644030ef          	jal	5d82 <printf>
    exit(1);
    2742:	4505                	li	a0,1
    2744:	1d8030ef          	jal	591c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2748:	85a6                	mv	a1,s1
    274a:	00005517          	auipc	a0,0x5
    274e:	85e50513          	addi	a0,a0,-1954 # 6fa8 <malloc+0x116a>
    2752:	630030ef          	jal	5d82 <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	1c4030ef          	jal	591c <exit>

000000000000275c <diskfull>:
{
    275c:	b6010113          	addi	sp,sp,-1184
    2760:	48113c23          	sd	ra,1176(sp)
    2764:	48813823          	sd	s0,1168(sp)
    2768:	48913423          	sd	s1,1160(sp)
    276c:	49213023          	sd	s2,1152(sp)
    2770:	47313c23          	sd	s3,1144(sp)
    2774:	47413823          	sd	s4,1136(sp)
    2778:	47513423          	sd	s5,1128(sp)
    277c:	47613023          	sd	s6,1120(sp)
    2780:	45713c23          	sd	s7,1112(sp)
    2784:	45813823          	sd	s8,1104(sp)
    2788:	45913423          	sd	s9,1096(sp)
    278c:	45a13023          	sd	s10,1088(sp)
    2790:	43b13c23          	sd	s11,1080(sp)
    2794:	4a010413          	addi	s0,sp,1184
    2798:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    279c:	00005517          	auipc	a0,0x5
    27a0:	84450513          	addi	a0,a0,-1980 # 6fe0 <malloc+0x11a2>
    27a4:	1c8030ef          	jal	596c <unlink>
    27a8:	03000a93          	li	s5,48
    name[0] = 'b';
    27ac:	06200d13          	li	s10,98
    name[1] = 'i';
    27b0:	06900c93          	li	s9,105
    name[2] = 'g';
    27b4:	06700c13          	li	s8,103
    unlink(name);
    27b8:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27bc:	60200b93          	li	s7,1538
    if (fd < 0) {
    27c0:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c4:	b9040a13          	addi	s4,s0,-1136
    27c8:	aa8d                	j	293a <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ca:	b7040613          	addi	a2,s0,-1168
    27ce:	b6843583          	ld	a1,-1176(s0)
    27d2:	00005517          	auipc	a0,0x5
    27d6:	81e50513          	addi	a0,a0,-2018 # 6ff0 <malloc+0x11b2>
    27da:	5a8030ef          	jal	5d82 <printf>
      break;
    27de:	a039                	j	27ec <diskfull+0x90>
        close(fd);
    27e0:	854e                	mv	a0,s3
    27e2:	162030ef          	jal	5944 <close>
    close(fd);
    27e6:	854e                	mv	a0,s3
    27e8:	15c030ef          	jal	5944 <close>
  for (int i = 0; i < nzz; i++) {
    27ec:	4481                	li	s1,0
    name[0] = 'z';
    27ee:	07a00993          	li	s3,122
    unlink(name);
    27f2:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27f6:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fa:	08000a93          	li	s5,128
    name[0] = 'z';
    27fe:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2802:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2806:	41f4d71b          	sraiw	a4,s1,0x1f
    280a:	01b7571b          	srliw	a4,a4,0x1b
    280e:	009707bb          	addw	a5,a4,s1
    2812:	4057d69b          	sraiw	a3,a5,0x5
    2816:	0306869b          	addiw	a3,a3,48
    281a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    281e:	8bfd                	andi	a5,a5,31
    2820:	9f99                	subw	a5,a5,a4
    2822:	0307879b          	addiw	a5,a5,48
    2826:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    282e:	854a                	mv	a0,s2
    2830:	13c030ef          	jal	596c <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2834:	85d2                	mv	a1,s4
    2836:	854a                	mv	a0,s2
    2838:	124030ef          	jal	595c <open>
    if (fd < 0)
    283c:	00054763          	bltz	a0,284a <diskfull+0xee>
    close(fd);
    2840:	104030ef          	jal	5944 <close>
  for (int i = 0; i < nzz; i++) {
    2844:	2485                	addiw	s1,s1,1
    2846:	fb549ce3          	bne	s1,s5,27fe <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284a:	00004517          	auipc	a0,0x4
    284e:	79650513          	addi	a0,a0,1942 # 6fe0 <malloc+0x11a2>
    2852:	132030ef          	jal	5984 <mkdir>
    2856:	12050363          	beqz	a0,297c <diskfull+0x220>
  unlink("diskfulldir");
    285a:	00004517          	auipc	a0,0x4
    285e:	78650513          	addi	a0,a0,1926 # 6fe0 <malloc+0x11a2>
    2862:	10a030ef          	jal	596c <unlink>
  for (int i = 0; i < nzz; i++) {
    2866:	4481                	li	s1,0
    name[0] = 'z';
    2868:	07a00913          	li	s2,122
    unlink(name);
    286c:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2870:	08000993          	li	s3,128
    name[0] = 'z';
    2874:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2878:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    287c:	41f4d71b          	sraiw	a4,s1,0x1f
    2880:	01b7571b          	srliw	a4,a4,0x1b
    2884:	009707bb          	addw	a5,a4,s1
    2888:	4057d69b          	sraiw	a3,a5,0x5
    288c:	0306869b          	addiw	a3,a3,48
    2890:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2894:	8bfd                	andi	a5,a5,31
    2896:	9f99                	subw	a5,a5,a4
    2898:	0307879b          	addiw	a5,a5,48
    289c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a4:	8552                	mv	a0,s4
    28a6:	0c6030ef          	jal	596c <unlink>
  for (int i = 0; i < nzz; i++) {
    28aa:	2485                	addiw	s1,s1,1
    28ac:	fd3494e3          	bne	s1,s3,2874 <diskfull+0x118>
    28b0:	03000493          	li	s1,48
    name[0] = 'b';
    28b4:	06200b13          	li	s6,98
    name[1] = 'i';
    28b8:	06900a93          	li	s5,105
    name[2] = 'g';
    28bc:	06700a13          	li	s4,103
    unlink(name);
    28c0:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c4:	07f00913          	li	s2,127
    name[0] = 'b';
    28c8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28cc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d0:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d4:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28d8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28dc:	854e                	mv	a0,s3
    28de:	08e030ef          	jal	596c <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e2:	2485                	addiw	s1,s1,1
    28e4:	0ff4f493          	zext.b	s1,s1
    28e8:	ff2490e3          	bne	s1,s2,28c8 <diskfull+0x16c>
}
    28ec:	49813083          	ld	ra,1176(sp)
    28f0:	49013403          	ld	s0,1168(sp)
    28f4:	48813483          	ld	s1,1160(sp)
    28f8:	48013903          	ld	s2,1152(sp)
    28fc:	47813983          	ld	s3,1144(sp)
    2900:	47013a03          	ld	s4,1136(sp)
    2904:	46813a83          	ld	s5,1128(sp)
    2908:	46013b03          	ld	s6,1120(sp)
    290c:	45813b83          	ld	s7,1112(sp)
    2910:	45013c03          	ld	s8,1104(sp)
    2914:	44813c83          	ld	s9,1096(sp)
    2918:	44013d03          	ld	s10,1088(sp)
    291c:	43813d83          	ld	s11,1080(sp)
    2920:	4a010113          	addi	sp,sp,1184
    2924:	8082                	ret
    close(fd);
    2926:	854e                	mv	a0,s3
    2928:	01c030ef          	jal	5944 <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    292c:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x47b>
    292e:	0ffafa93          	zext.b	s5,s5
    2932:	07f00793          	li	a5,127
    2936:	eafa8be3          	beq	s5,a5,27ec <diskfull+0x90>
    name[0] = 'b';
    293a:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    293e:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2942:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2946:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294a:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    294e:	855a                	mv	a0,s6
    2950:	01c030ef          	jal	596c <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2954:	85de                	mv	a1,s7
    2956:	855a                	mv	a0,s6
    2958:	004030ef          	jal	595c <open>
    295c:	89aa                	mv	s3,a0
    if (fd < 0) {
    295e:	e60546e3          	bltz	a0,27ca <diskfull+0x6e>
    2962:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2964:	40000913          	li	s2,1024
    2968:	864a                	mv	a2,s2
    296a:	85d2                	mv	a1,s4
    296c:	854e                	mv	a0,s3
    296e:	7cf020ef          	jal	593c <write>
    2972:	e72517e3          	bne	a0,s2,27e0 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    2976:	34fd                	addiw	s1,s1,-1
    2978:	f8e5                	bnez	s1,2968 <diskfull+0x20c>
    297a:	b775                	j	2926 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    297c:	b6843583          	ld	a1,-1176(s0)
    2980:	00004517          	auipc	a0,0x4
    2984:	69050513          	addi	a0,a0,1680 # 7010 <malloc+0x11d2>
    2988:	3fa030ef          	jal	5d82 <printf>
    298c:	b5f9                	j	285a <diskfull+0xfe>

000000000000298e <iputtest>:
{
    298e:	1101                	addi	sp,sp,-32
    2990:	ec06                	sd	ra,24(sp)
    2992:	e822                	sd	s0,16(sp)
    2994:	e426                	sd	s1,8(sp)
    2996:	1000                	addi	s0,sp,32
    2998:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299a:	00004517          	auipc	a0,0x4
    299e:	6a650513          	addi	a0,a0,1702 # 7040 <malloc+0x1202>
    29a2:	7e3020ef          	jal	5984 <mkdir>
    29a6:	02054f63          	bltz	a0,29e4 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29aa:	00004517          	auipc	a0,0x4
    29ae:	69650513          	addi	a0,a0,1686 # 7040 <malloc+0x1202>
    29b2:	7db020ef          	jal	598c <chdir>
    29b6:	04054163          	bltz	a0,29f8 <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29ba:	00004517          	auipc	a0,0x4
    29be:	6c650513          	addi	a0,a0,1734 # 7080 <malloc+0x1242>
    29c2:	7ab020ef          	jal	596c <unlink>
    29c6:	04054363          	bltz	a0,2a0c <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ca:	00004517          	auipc	a0,0x4
    29ce:	6e650513          	addi	a0,a0,1766 # 70b0 <malloc+0x1272>
    29d2:	7bb020ef          	jal	598c <chdir>
    29d6:	04054563          	bltz	a0,2a20 <iputtest+0x92>
}
    29da:	60e2                	ld	ra,24(sp)
    29dc:	6442                	ld	s0,16(sp)
    29de:	64a2                	ld	s1,8(sp)
    29e0:	6105                	addi	sp,sp,32
    29e2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e4:	85a6                	mv	a1,s1
    29e6:	00004517          	auipc	a0,0x4
    29ea:	66250513          	addi	a0,a0,1634 # 7048 <malloc+0x120a>
    29ee:	394030ef          	jal	5d82 <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	729020ef          	jal	591c <exit>
    printf("%s: chdir iputdir failed\n", s);
    29f8:	85a6                	mv	a1,s1
    29fa:	00004517          	auipc	a0,0x4
    29fe:	66650513          	addi	a0,a0,1638 # 7060 <malloc+0x1222>
    2a02:	380030ef          	jal	5d82 <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	715020ef          	jal	591c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a0c:	85a6                	mv	a1,s1
    2a0e:	00004517          	auipc	a0,0x4
    2a12:	68250513          	addi	a0,a0,1666 # 7090 <malloc+0x1252>
    2a16:	36c030ef          	jal	5d82 <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	701020ef          	jal	591c <exit>
    printf("%s: chdir / failed\n", s);
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	69650513          	addi	a0,a0,1686 # 70b8 <malloc+0x127a>
    2a2a:	358030ef          	jal	5d82 <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	6ed020ef          	jal	591c <exit>

0000000000002a34 <exitiputtest>:
{
    2a34:	7179                	addi	sp,sp,-48
    2a36:	f406                	sd	ra,40(sp)
    2a38:	f022                	sd	s0,32(sp)
    2a3a:	ec26                	sd	s1,24(sp)
    2a3c:	1800                	addi	s0,sp,48
    2a3e:	84aa                	mv	s1,a0
  pid = fork();
    2a40:	6d5020ef          	jal	5914 <fork>
  if (pid < 0) {
    2a44:	02054e63          	bltz	a0,2a80 <exitiputtest+0x4c>
  if (pid == 0) {
    2a48:	e541                	bnez	a0,2ad0 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	5f650513          	addi	a0,a0,1526 # 7040 <malloc+0x1202>
    2a52:	733020ef          	jal	5984 <mkdir>
    2a56:	02054f63          	bltz	a0,2a94 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	5e650513          	addi	a0,a0,1510 # 7040 <malloc+0x1202>
    2a62:	72b020ef          	jal	598c <chdir>
    2a66:	04054163          	bltz	a0,2aa8 <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	61650513          	addi	a0,a0,1558 # 7080 <malloc+0x1242>
    2a72:	6fb020ef          	jal	596c <unlink>
    2a76:	04054363          	bltz	a0,2abc <exitiputtest+0x88>
    exit(0);
    2a7a:	4501                	li	a0,0
    2a7c:	6a1020ef          	jal	591c <exit>
    printf("%s: fork failed\n", s);
    2a80:	85a6                	mv	a1,s1
    2a82:	00004517          	auipc	a0,0x4
    2a86:	d7650513          	addi	a0,a0,-650 # 67f8 <malloc+0x9ba>
    2a8a:	2f8030ef          	jal	5d82 <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	68d020ef          	jal	591c <exit>
      printf("%s: mkdir failed\n", s);
    2a94:	85a6                	mv	a1,s1
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	5b250513          	addi	a0,a0,1458 # 7048 <malloc+0x120a>
    2a9e:	2e4030ef          	jal	5d82 <printf>
      exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	679020ef          	jal	591c <exit>
      printf("%s: child chdir failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	62650513          	addi	a0,a0,1574 # 70d0 <malloc+0x1292>
    2ab2:	2d0030ef          	jal	5d82 <printf>
      exit(1);
    2ab6:	4505                	li	a0,1
    2ab8:	665020ef          	jal	591c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2abc:	85a6                	mv	a1,s1
    2abe:	00004517          	auipc	a0,0x4
    2ac2:	5d250513          	addi	a0,a0,1490 # 7090 <malloc+0x1252>
    2ac6:	2bc030ef          	jal	5d82 <printf>
      exit(1);
    2aca:	4505                	li	a0,1
    2acc:	651020ef          	jal	591c <exit>
  wait(&xstatus);
    2ad0:	fdc40513          	addi	a0,s0,-36
    2ad4:	651020ef          	jal	5924 <wait>
  exit(xstatus);
    2ad8:	fdc42503          	lw	a0,-36(s0)
    2adc:	641020ef          	jal	591c <exit>

0000000000002ae0 <dirtest>:
{
    2ae0:	1101                	addi	sp,sp,-32
    2ae2:	ec06                	sd	ra,24(sp)
    2ae4:	e822                	sd	s0,16(sp)
    2ae6:	e426                	sd	s1,8(sp)
    2ae8:	1000                	addi	s0,sp,32
    2aea:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2aec:	00004517          	auipc	a0,0x4
    2af0:	5fc50513          	addi	a0,a0,1532 # 70e8 <malloc+0x12aa>
    2af4:	691020ef          	jal	5984 <mkdir>
    2af8:	02054f63          	bltz	a0,2b36 <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2afc:	00004517          	auipc	a0,0x4
    2b00:	5ec50513          	addi	a0,a0,1516 # 70e8 <malloc+0x12aa>
    2b04:	689020ef          	jal	598c <chdir>
    2b08:	04054163          	bltz	a0,2b4a <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b0c:	00004517          	auipc	a0,0x4
    2b10:	5fc50513          	addi	a0,a0,1532 # 7108 <malloc+0x12ca>
    2b14:	679020ef          	jal	598c <chdir>
    2b18:	04054363          	bltz	a0,2b5e <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	5cc50513          	addi	a0,a0,1484 # 70e8 <malloc+0x12aa>
    2b24:	649020ef          	jal	596c <unlink>
    2b28:	04054563          	bltz	a0,2b72 <dirtest+0x92>
}
    2b2c:	60e2                	ld	ra,24(sp)
    2b2e:	6442                	ld	s0,16(sp)
    2b30:	64a2                	ld	s1,8(sp)
    2b32:	6105                	addi	sp,sp,32
    2b34:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	51050513          	addi	a0,a0,1296 # 7048 <malloc+0x120a>
    2b40:	242030ef          	jal	5d82 <printf>
    exit(1);
    2b44:	4505                	li	a0,1
    2b46:	5d7020ef          	jal	591c <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4a:	85a6                	mv	a1,s1
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	5a450513          	addi	a0,a0,1444 # 70f0 <malloc+0x12b2>
    2b54:	22e030ef          	jal	5d82 <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	5c3020ef          	jal	591c <exit>
    printf("%s: chdir .. failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	5b050513          	addi	a0,a0,1456 # 7110 <malloc+0x12d2>
    2b68:	21a030ef          	jal	5d82 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	5af020ef          	jal	591c <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	5b450513          	addi	a0,a0,1460 # 7128 <malloc+0x12ea>
    2b7c:	206030ef          	jal	5d82 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	59b020ef          	jal	591c <exit>

0000000000002b86 <subdir>:
{
    2b86:	1101                	addi	sp,sp,-32
    2b88:	ec06                	sd	ra,24(sp)
    2b8a:	e822                	sd	s0,16(sp)
    2b8c:	e426                	sd	s1,8(sp)
    2b8e:	e04a                	sd	s2,0(sp)
    2b90:	1000                	addi	s0,sp,32
    2b92:	892a                	mv	s2,a0
  unlink("ff");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	6dc50513          	addi	a0,a0,1756 # 7270 <malloc+0x1432>
    2b9c:	5d1020ef          	jal	596c <unlink>
  if (mkdir("dd") != 0) {
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	5a050513          	addi	a0,a0,1440 # 7140 <malloc+0x1302>
    2ba8:	5dd020ef          	jal	5984 <mkdir>
    2bac:	2e051263          	bnez	a0,2e90 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb0:	20200593          	li	a1,514
    2bb4:	00004517          	auipc	a0,0x4
    2bb8:	5ac50513          	addi	a0,a0,1452 # 7160 <malloc+0x1322>
    2bbc:	5a1020ef          	jal	595c <open>
    2bc0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc2:	2e054163          	bltz	a0,2ea4 <subdir+0x31e>
  write(fd, "ff", 2);
    2bc6:	4609                	li	a2,2
    2bc8:	00004597          	auipc	a1,0x4
    2bcc:	6a858593          	addi	a1,a1,1704 # 7270 <malloc+0x1432>
    2bd0:	56d020ef          	jal	593c <write>
  close(fd);
    2bd4:	8526                	mv	a0,s1
    2bd6:	56f020ef          	jal	5944 <close>
  if (unlink("dd") >= 0) {
    2bda:	00004517          	auipc	a0,0x4
    2bde:	56650513          	addi	a0,a0,1382 # 7140 <malloc+0x1302>
    2be2:	58b020ef          	jal	596c <unlink>
    2be6:	2c055963          	bgez	a0,2eb8 <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bea:	00004517          	auipc	a0,0x4
    2bee:	5ce50513          	addi	a0,a0,1486 # 71b8 <malloc+0x137a>
    2bf2:	593020ef          	jal	5984 <mkdir>
    2bf6:	2c051b63          	bnez	a0,2ecc <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfa:	20200593          	li	a1,514
    2bfe:	00004517          	auipc	a0,0x4
    2c02:	5e250513          	addi	a0,a0,1506 # 71e0 <malloc+0x13a2>
    2c06:	557020ef          	jal	595c <open>
    2c0a:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c0c:	2c054a63          	bltz	a0,2ee0 <subdir+0x35a>
  write(fd, "FF", 2);
    2c10:	4609                	li	a2,2
    2c12:	00004597          	auipc	a1,0x4
    2c16:	5fe58593          	addi	a1,a1,1534 # 7210 <malloc+0x13d2>
    2c1a:	523020ef          	jal	593c <write>
  close(fd);
    2c1e:	8526                	mv	a0,s1
    2c20:	525020ef          	jal	5944 <close>
  fd = open("dd/dd/../ff", 0);
    2c24:	4581                	li	a1,0
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	5f250513          	addi	a0,a0,1522 # 7218 <malloc+0x13da>
    2c2e:	52f020ef          	jal	595c <open>
    2c32:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c34:	2c054063          	bltz	a0,2ef4 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c38:	660d                	lui	a2,0x3
    2c3a:	0000a597          	auipc	a1,0xa
    2c3e:	0ce58593          	addi	a1,a1,206 # cd08 <buf>
    2c42:	4f3020ef          	jal	5934 <read>
  if (cc != 2 || buf[0] != 'f') {
    2c46:	4789                	li	a5,2
    2c48:	2cf51063          	bne	a0,a5,2f08 <subdir+0x382>
    2c4c:	0000a717          	auipc	a4,0xa
    2c50:	0bc74703          	lbu	a4,188(a4) # cd08 <buf>
    2c54:	06600793          	li	a5,102
    2c58:	2af71863          	bne	a4,a5,2f08 <subdir+0x382>
  close(fd);
    2c5c:	8526                	mv	a0,s1
    2c5e:	4e7020ef          	jal	5944 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c62:	00004597          	auipc	a1,0x4
    2c66:	60658593          	addi	a1,a1,1542 # 7268 <malloc+0x142a>
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	57650513          	addi	a0,a0,1398 # 71e0 <malloc+0x13a2>
    2c72:	50b020ef          	jal	597c <link>
    2c76:	2a051363          	bnez	a0,2f1c <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	56650513          	addi	a0,a0,1382 # 71e0 <malloc+0x13a2>
    2c82:	4eb020ef          	jal	596c <unlink>
    2c86:	2a051563          	bnez	a0,2f30 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8a:	4581                	li	a1,0
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	55450513          	addi	a0,a0,1364 # 71e0 <malloc+0x13a2>
    2c94:	4c9020ef          	jal	595c <open>
    2c98:	2a055663          	bgez	a0,2f44 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	4a450513          	addi	a0,a0,1188 # 7140 <malloc+0x1302>
    2ca4:	4e9020ef          	jal	598c <chdir>
    2ca8:	2a051863          	bnez	a0,2f58 <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	65450513          	addi	a0,a0,1620 # 7300 <malloc+0x14c2>
    2cb4:	4d9020ef          	jal	598c <chdir>
    2cb8:	2a051a63          	bnez	a0,2f6c <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	67450513          	addi	a0,a0,1652 # 7330 <malloc+0x14f2>
    2cc4:	4c9020ef          	jal	598c <chdir>
    2cc8:	2a051c63          	bnez	a0,2f80 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	69c50513          	addi	a0,a0,1692 # 7368 <malloc+0x152a>
    2cd4:	4b9020ef          	jal	598c <chdir>
    2cd8:	2a051e63          	bnez	a0,2f94 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cdc:	4581                	li	a1,0
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	58a50513          	addi	a0,a0,1418 # 7268 <malloc+0x142a>
    2ce6:	477020ef          	jal	595c <open>
    2cea:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cec:	2a054e63          	bltz	a0,2fa8 <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf0:	660d                	lui	a2,0x3
    2cf2:	0000a597          	auipc	a1,0xa
    2cf6:	01658593          	addi	a1,a1,22 # cd08 <buf>
    2cfa:	43b020ef          	jal	5934 <read>
    2cfe:	4789                	li	a5,2
    2d00:	2af51e63          	bne	a0,a5,2fbc <subdir+0x436>
  close(fd);
    2d04:	8526                	mv	a0,s1
    2d06:	43f020ef          	jal	5944 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0a:	4581                	li	a1,0
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	4d450513          	addi	a0,a0,1236 # 71e0 <malloc+0x13a2>
    2d14:	449020ef          	jal	595c <open>
    2d18:	2a055c63          	bgez	a0,2fd0 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d1c:	20200593          	li	a1,514
    2d20:	00004517          	auipc	a0,0x4
    2d24:	6d850513          	addi	a0,a0,1752 # 73f8 <malloc+0x15ba>
    2d28:	435020ef          	jal	595c <open>
    2d2c:	2a055c63          	bgez	a0,2fe4 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d30:	20200593          	li	a1,514
    2d34:	00004517          	auipc	a0,0x4
    2d38:	6f450513          	addi	a0,a0,1780 # 7428 <malloc+0x15ea>
    2d3c:	421020ef          	jal	595c <open>
    2d40:	2a055c63          	bgez	a0,2ff8 <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d44:	20000593          	li	a1,512
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	3f850513          	addi	a0,a0,1016 # 7140 <malloc+0x1302>
    2d50:	40d020ef          	jal	595c <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d58:	4589                	li	a1,2
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	3e650513          	addi	a0,a0,998 # 7140 <malloc+0x1302>
    2d62:	3fb020ef          	jal	595c <open>
    2d66:	2a055d63          	bgez	a0,3020 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6a:	4585                	li	a1,1
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	3d450513          	addi	a0,a0,980 # 7140 <malloc+0x1302>
    2d74:	3e9020ef          	jal	595c <open>
    2d78:	2a055e63          	bgez	a0,3034 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d7c:	00004597          	auipc	a1,0x4
    2d80:	73c58593          	addi	a1,a1,1852 # 74b8 <malloc+0x167a>
    2d84:	00004517          	auipc	a0,0x4
    2d88:	67450513          	addi	a0,a0,1652 # 73f8 <malloc+0x15ba>
    2d8c:	3f1020ef          	jal	597c <link>
    2d90:	2a050c63          	beqz	a0,3048 <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d94:	00004597          	auipc	a1,0x4
    2d98:	72458593          	addi	a1,a1,1828 # 74b8 <malloc+0x167a>
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	68c50513          	addi	a0,a0,1676 # 7428 <malloc+0x15ea>
    2da4:	3d9020ef          	jal	597c <link>
    2da8:	2a050a63          	beqz	a0,305c <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2dac:	00004597          	auipc	a1,0x4
    2db0:	4bc58593          	addi	a1,a1,1212 # 7268 <malloc+0x142a>
    2db4:	00004517          	auipc	a0,0x4
    2db8:	3ac50513          	addi	a0,a0,940 # 7160 <malloc+0x1322>
    2dbc:	3c1020ef          	jal	597c <link>
    2dc0:	2a050863          	beqz	a0,3070 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	63450513          	addi	a0,a0,1588 # 73f8 <malloc+0x15ba>
    2dcc:	3b9020ef          	jal	5984 <mkdir>
    2dd0:	2a050a63          	beqz	a0,3084 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	65450513          	addi	a0,a0,1620 # 7428 <malloc+0x15ea>
    2ddc:	3a9020ef          	jal	5984 <mkdir>
    2de0:	2a050c63          	beqz	a0,3098 <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de4:	00004517          	auipc	a0,0x4
    2de8:	48450513          	addi	a0,a0,1156 # 7268 <malloc+0x142a>
    2dec:	399020ef          	jal	5984 <mkdir>
    2df0:	2a050e63          	beqz	a0,30ac <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df4:	00004517          	auipc	a0,0x4
    2df8:	63450513          	addi	a0,a0,1588 # 7428 <malloc+0x15ea>
    2dfc:	371020ef          	jal	596c <unlink>
    2e00:	2c050063          	beqz	a0,30c0 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e04:	00004517          	auipc	a0,0x4
    2e08:	5f450513          	addi	a0,a0,1524 # 73f8 <malloc+0x15ba>
    2e0c:	361020ef          	jal	596c <unlink>
    2e10:	2c050263          	beqz	a0,30d4 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e14:	00004517          	auipc	a0,0x4
    2e18:	34c50513          	addi	a0,a0,844 # 7160 <malloc+0x1322>
    2e1c:	371020ef          	jal	598c <chdir>
    2e20:	2c050463          	beqz	a0,30e8 <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e24:	00004517          	auipc	a0,0x4
    2e28:	7e450513          	addi	a0,a0,2020 # 7608 <malloc+0x17ca>
    2e2c:	361020ef          	jal	598c <chdir>
    2e30:	2c050663          	beqz	a0,30fc <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e34:	00004517          	auipc	a0,0x4
    2e38:	43450513          	addi	a0,a0,1076 # 7268 <malloc+0x142a>
    2e3c:	331020ef          	jal	596c <unlink>
    2e40:	2c051863          	bnez	a0,3110 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e44:	00004517          	auipc	a0,0x4
    2e48:	31c50513          	addi	a0,a0,796 # 7160 <malloc+0x1322>
    2e4c:	321020ef          	jal	596c <unlink>
    2e50:	2c051a63          	bnez	a0,3124 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e54:	00004517          	auipc	a0,0x4
    2e58:	2ec50513          	addi	a0,a0,748 # 7140 <malloc+0x1302>
    2e5c:	311020ef          	jal	596c <unlink>
    2e60:	2c050c63          	beqz	a0,3138 <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e64:	00005517          	auipc	a0,0x5
    2e68:	81450513          	addi	a0,a0,-2028 # 7678 <malloc+0x183a>
    2e6c:	301020ef          	jal	596c <unlink>
    2e70:	2c054e63          	bltz	a0,314c <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e74:	00004517          	auipc	a0,0x4
    2e78:	2cc50513          	addi	a0,a0,716 # 7140 <malloc+0x1302>
    2e7c:	2f1020ef          	jal	596c <unlink>
    2e80:	2e054063          	bltz	a0,3160 <subdir+0x5da>
}
    2e84:	60e2                	ld	ra,24(sp)
    2e86:	6442                	ld	s0,16(sp)
    2e88:	64a2                	ld	s1,8(sp)
    2e8a:	6902                	ld	s2,0(sp)
    2e8c:	6105                	addi	sp,sp,32
    2e8e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e90:	85ca                	mv	a1,s2
    2e92:	00004517          	auipc	a0,0x4
    2e96:	2b650513          	addi	a0,a0,694 # 7148 <malloc+0x130a>
    2e9a:	6e9020ef          	jal	5d82 <printf>
    exit(1);
    2e9e:	4505                	li	a0,1
    2ea0:	27d020ef          	jal	591c <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00004517          	auipc	a0,0x4
    2eaa:	2c250513          	addi	a0,a0,706 # 7168 <malloc+0x132a>
    2eae:	6d5020ef          	jal	5d82 <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	269020ef          	jal	591c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eb8:	85ca                	mv	a1,s2
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	2ce50513          	addi	a0,a0,718 # 7188 <malloc+0x134a>
    2ec2:	6c1020ef          	jal	5d82 <printf>
    exit(1);
    2ec6:	4505                	li	a0,1
    2ec8:	255020ef          	jal	591c <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ecc:	85ca                	mv	a1,s2
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	2f250513          	addi	a0,a0,754 # 71c0 <malloc+0x1382>
    2ed6:	6ad020ef          	jal	5d82 <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	241020ef          	jal	591c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00004517          	auipc	a0,0x4
    2ee6:	30e50513          	addi	a0,a0,782 # 71f0 <malloc+0x13b2>
    2eea:	699020ef          	jal	5d82 <printf>
    exit(1);
    2eee:	4505                	li	a0,1
    2ef0:	22d020ef          	jal	591c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	33250513          	addi	a0,a0,818 # 7228 <malloc+0x13ea>
    2efe:	685020ef          	jal	5d82 <printf>
    exit(1);
    2f02:	4505                	li	a0,1
    2f04:	219020ef          	jal	591c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f08:	85ca                	mv	a1,s2
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	33e50513          	addi	a0,a0,830 # 7248 <malloc+0x140a>
    2f12:	671020ef          	jal	5d82 <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	205020ef          	jal	591c <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	35a50513          	addi	a0,a0,858 # 7278 <malloc+0x143a>
    2f26:	65d020ef          	jal	5d82 <printf>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	1f1020ef          	jal	591c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f30:	85ca                	mv	a1,s2
    2f32:	00004517          	auipc	a0,0x4
    2f36:	36e50513          	addi	a0,a0,878 # 72a0 <malloc+0x1462>
    2f3a:	649020ef          	jal	5d82 <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	1dd020ef          	jal	591c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f44:	85ca                	mv	a1,s2
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	37a50513          	addi	a0,a0,890 # 72c0 <malloc+0x1482>
    2f4e:	635020ef          	jal	5d82 <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	1c9020ef          	jal	591c <exit>
    printf("%s: chdir dd failed\n", s);
    2f58:	85ca                	mv	a1,s2
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	38e50513          	addi	a0,a0,910 # 72e8 <malloc+0x14aa>
    2f62:	621020ef          	jal	5d82 <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	1b5020ef          	jal	591c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	3a250513          	addi	a0,a0,930 # 7310 <malloc+0x14d2>
    2f76:	60d020ef          	jal	5d82 <printf>
    exit(1);
    2f7a:	4505                	li	a0,1
    2f7c:	1a1020ef          	jal	591c <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00004517          	auipc	a0,0x4
    2f86:	3be50513          	addi	a0,a0,958 # 7340 <malloc+0x1502>
    2f8a:	5f9020ef          	jal	5d82 <printf>
    exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	18d020ef          	jal	591c <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f94:	85ca                	mv	a1,s2
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	3da50513          	addi	a0,a0,986 # 7370 <malloc+0x1532>
    2f9e:	5e5020ef          	jal	5d82 <printf>
    exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	179020ef          	jal	591c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fa8:	85ca                	mv	a1,s2
    2faa:	00004517          	auipc	a0,0x4
    2fae:	3de50513          	addi	a0,a0,990 # 7388 <malloc+0x154a>
    2fb2:	5d1020ef          	jal	5d82 <printf>
    exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	165020ef          	jal	591c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	3ea50513          	addi	a0,a0,1002 # 73a8 <malloc+0x156a>
    2fc6:	5bd020ef          	jal	5d82 <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	151020ef          	jal	591c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	3f650513          	addi	a0,a0,1014 # 73c8 <malloc+0x158a>
    2fda:	5a9020ef          	jal	5d82 <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	13d020ef          	jal	591c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	42250513          	addi	a0,a0,1058 # 7408 <malloc+0x15ca>
    2fee:	595020ef          	jal	5d82 <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	129020ef          	jal	591c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	43e50513          	addi	a0,a0,1086 # 7438 <malloc+0x15fa>
    3002:	581020ef          	jal	5d82 <printf>
    exit(1);
    3006:	4505                	li	a0,1
    3008:	115020ef          	jal	591c <exit>
    printf("%s: create dd succeeded!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00004517          	auipc	a0,0x4
    3012:	44a50513          	addi	a0,a0,1098 # 7458 <malloc+0x161a>
    3016:	56d020ef          	jal	5d82 <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	101020ef          	jal	591c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00004517          	auipc	a0,0x4
    3026:	45650513          	addi	a0,a0,1110 # 7478 <malloc+0x163a>
    302a:	559020ef          	jal	5d82 <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	0ed020ef          	jal	591c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00004517          	auipc	a0,0x4
    303a:	46250513          	addi	a0,a0,1122 # 7498 <malloc+0x165a>
    303e:	545020ef          	jal	5d82 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	0d9020ef          	jal	591c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00004517          	auipc	a0,0x4
    304e:	47e50513          	addi	a0,a0,1150 # 74c8 <malloc+0x168a>
    3052:	531020ef          	jal	5d82 <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	0c5020ef          	jal	591c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00004517          	auipc	a0,0x4
    3062:	49250513          	addi	a0,a0,1170 # 74f0 <malloc+0x16b2>
    3066:	51d020ef          	jal	5d82 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	0b1020ef          	jal	591c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00004517          	auipc	a0,0x4
    3076:	4a650513          	addi	a0,a0,1190 # 7518 <malloc+0x16da>
    307a:	509020ef          	jal	5d82 <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	09d020ef          	jal	591c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00004517          	auipc	a0,0x4
    308a:	4ba50513          	addi	a0,a0,1210 # 7540 <malloc+0x1702>
    308e:	4f5020ef          	jal	5d82 <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	089020ef          	jal	591c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00004517          	auipc	a0,0x4
    309e:	4c650513          	addi	a0,a0,1222 # 7560 <malloc+0x1722>
    30a2:	4e1020ef          	jal	5d82 <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	075020ef          	jal	591c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	4d250513          	addi	a0,a0,1234 # 7580 <malloc+0x1742>
    30b6:	4cd020ef          	jal	5d82 <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	061020ef          	jal	591c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	4e650513          	addi	a0,a0,1254 # 75a8 <malloc+0x176a>
    30ca:	4b9020ef          	jal	5d82 <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	04d020ef          	jal	591c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	4f250513          	addi	a0,a0,1266 # 75c8 <malloc+0x178a>
    30de:	4a5020ef          	jal	5d82 <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	039020ef          	jal	591c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	4fe50513          	addi	a0,a0,1278 # 75e8 <malloc+0x17aa>
    30f2:	491020ef          	jal	5d82 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	025020ef          	jal	591c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	51250513          	addi	a0,a0,1298 # 7610 <malloc+0x17d2>
    3106:	47d020ef          	jal	5d82 <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	011020ef          	jal	591c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	18e50513          	addi	a0,a0,398 # 72a0 <malloc+0x1462>
    311a:	469020ef          	jal	5d82 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	7fc020ef          	jal	591c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	50a50513          	addi	a0,a0,1290 # 7630 <malloc+0x17f2>
    312e:	455020ef          	jal	5d82 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	7e8020ef          	jal	591c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	51650513          	addi	a0,a0,1302 # 7650 <malloc+0x1812>
    3142:	441020ef          	jal	5d82 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	7d4020ef          	jal	591c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00004517          	auipc	a0,0x4
    3152:	53250513          	addi	a0,a0,1330 # 7680 <malloc+0x1842>
    3156:	42d020ef          	jal	5d82 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	7c0020ef          	jal	591c <exit>
    printf("%s: unlink dd failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	53e50513          	addi	a0,a0,1342 # 76a0 <malloc+0x1862>
    316a:	419020ef          	jal	5d82 <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	7ac020ef          	jal	591c <exit>

0000000000003174 <rmdot>:
{
    3174:	1101                	addi	sp,sp,-32
    3176:	ec06                	sd	ra,24(sp)
    3178:	e822                	sd	s0,16(sp)
    317a:	e426                	sd	s1,8(sp)
    317c:	1000                	addi	s0,sp,32
    317e:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3180:	00004517          	auipc	a0,0x4
    3184:	53850513          	addi	a0,a0,1336 # 76b8 <malloc+0x187a>
    3188:	7fc020ef          	jal	5984 <mkdir>
    318c:	e53d                	bnez	a0,31fa <rmdot+0x86>
  if (chdir("dots") != 0) {
    318e:	00004517          	auipc	a0,0x4
    3192:	52a50513          	addi	a0,a0,1322 # 76b8 <malloc+0x187a>
    3196:	7f6020ef          	jal	598c <chdir>
    319a:	e935                	bnez	a0,320e <rmdot+0x9a>
  if (unlink(".") == 0) {
    319c:	00003517          	auipc	a0,0x3
    31a0:	4b450513          	addi	a0,a0,1204 # 6650 <malloc+0x812>
    31a4:	7c8020ef          	jal	596c <unlink>
    31a8:	cd2d                	beqz	a0,3222 <rmdot+0xae>
  if (unlink("..") == 0) {
    31aa:	00004517          	auipc	a0,0x4
    31ae:	f5e50513          	addi	a0,a0,-162 # 7108 <malloc+0x12ca>
    31b2:	7ba020ef          	jal	596c <unlink>
    31b6:	c141                	beqz	a0,3236 <rmdot+0xc2>
  if (chdir("/") != 0) {
    31b8:	00004517          	auipc	a0,0x4
    31bc:	ef850513          	addi	a0,a0,-264 # 70b0 <malloc+0x1272>
    31c0:	7cc020ef          	jal	598c <chdir>
    31c4:	e159                	bnez	a0,324a <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31c6:	00004517          	auipc	a0,0x4
    31ca:	55a50513          	addi	a0,a0,1370 # 7720 <malloc+0x18e2>
    31ce:	79e020ef          	jal	596c <unlink>
    31d2:	c551                	beqz	a0,325e <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d4:	00004517          	auipc	a0,0x4
    31d8:	57450513          	addi	a0,a0,1396 # 7748 <malloc+0x190a>
    31dc:	790020ef          	jal	596c <unlink>
    31e0:	c949                	beqz	a0,3272 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e2:	00004517          	auipc	a0,0x4
    31e6:	4d650513          	addi	a0,a0,1238 # 76b8 <malloc+0x187a>
    31ea:	782020ef          	jal	596c <unlink>
    31ee:	ed41                	bnez	a0,3286 <rmdot+0x112>
}
    31f0:	60e2                	ld	ra,24(sp)
    31f2:	6442                	ld	s0,16(sp)
    31f4:	64a2                	ld	s1,8(sp)
    31f6:	6105                	addi	sp,sp,32
    31f8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fa:	85a6                	mv	a1,s1
    31fc:	00004517          	auipc	a0,0x4
    3200:	4c450513          	addi	a0,a0,1220 # 76c0 <malloc+0x1882>
    3204:	37f020ef          	jal	5d82 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	712020ef          	jal	591c <exit>
    printf("%s: chdir dots failed\n", s);
    320e:	85a6                	mv	a1,s1
    3210:	00004517          	auipc	a0,0x4
    3214:	4c850513          	addi	a0,a0,1224 # 76d8 <malloc+0x189a>
    3218:	36b020ef          	jal	5d82 <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	6fe020ef          	jal	591c <exit>
    printf("%s: rm . worked!\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	4cc50513          	addi	a0,a0,1228 # 76f0 <malloc+0x18b2>
    322c:	357020ef          	jal	5d82 <printf>
    exit(1);
    3230:	4505                	li	a0,1
    3232:	6ea020ef          	jal	591c <exit>
    printf("%s: rm .. worked!\n", s);
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	4d050513          	addi	a0,a0,1232 # 7708 <malloc+0x18ca>
    3240:	343020ef          	jal	5d82 <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	6d6020ef          	jal	591c <exit>
    printf("%s: chdir / failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	e6c50513          	addi	a0,a0,-404 # 70b8 <malloc+0x127a>
    3254:	32f020ef          	jal	5d82 <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	6c2020ef          	jal	591c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	4c850513          	addi	a0,a0,1224 # 7728 <malloc+0x18ea>
    3268:	31b020ef          	jal	5d82 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	6ae020ef          	jal	591c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	4dc50513          	addi	a0,a0,1244 # 7750 <malloc+0x1912>
    327c:	307020ef          	jal	5d82 <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	69a020ef          	jal	591c <exit>
    printf("%s: unlink dots failed!\n", s);
    3286:	85a6                	mv	a1,s1
    3288:	00004517          	auipc	a0,0x4
    328c:	4e850513          	addi	a0,a0,1256 # 7770 <malloc+0x1932>
    3290:	2f3020ef          	jal	5d82 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	686020ef          	jal	591c <exit>

000000000000329a <dirfile>:
{
    329a:	1101                	addi	sp,sp,-32
    329c:	ec06                	sd	ra,24(sp)
    329e:	e822                	sd	s0,16(sp)
    32a0:	e426                	sd	s1,8(sp)
    32a2:	e04a                	sd	s2,0(sp)
    32a4:	1000                	addi	s0,sp,32
    32a6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32a8:	20000593          	li	a1,512
    32ac:	00004517          	auipc	a0,0x4
    32b0:	4e450513          	addi	a0,a0,1252 # 7790 <malloc+0x1952>
    32b4:	6a8020ef          	jal	595c <open>
  if (fd < 0) {
    32b8:	0c054563          	bltz	a0,3382 <dirfile+0xe8>
  close(fd);
    32bc:	688020ef          	jal	5944 <close>
  if (chdir("dirfile") == 0) {
    32c0:	00004517          	auipc	a0,0x4
    32c4:	4d050513          	addi	a0,a0,1232 # 7790 <malloc+0x1952>
    32c8:	6c4020ef          	jal	598c <chdir>
    32cc:	c569                	beqz	a0,3396 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	50850513          	addi	a0,a0,1288 # 77d8 <malloc+0x199a>
    32d8:	684020ef          	jal	595c <open>
  if (fd >= 0) {
    32dc:	0c055763          	bgez	a0,33aa <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e0:	20000593          	li	a1,512
    32e4:	00004517          	auipc	a0,0x4
    32e8:	4f450513          	addi	a0,a0,1268 # 77d8 <malloc+0x199a>
    32ec:	670020ef          	jal	595c <open>
  if (fd >= 0) {
    32f0:	0c055763          	bgez	a0,33be <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f4:	00004517          	auipc	a0,0x4
    32f8:	4e450513          	addi	a0,a0,1252 # 77d8 <malloc+0x199a>
    32fc:	688020ef          	jal	5984 <mkdir>
    3300:	0c050963          	beqz	a0,33d2 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3304:	00004517          	auipc	a0,0x4
    3308:	4d450513          	addi	a0,a0,1236 # 77d8 <malloc+0x199a>
    330c:	660020ef          	jal	596c <unlink>
    3310:	0c050b63          	beqz	a0,33e6 <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3314:	00004597          	auipc	a1,0x4
    3318:	4c458593          	addi	a1,a1,1220 # 77d8 <malloc+0x199a>
    331c:	00003517          	auipc	a0,0x3
    3320:	e2450513          	addi	a0,a0,-476 # 6140 <malloc+0x302>
    3324:	658020ef          	jal	597c <link>
    3328:	0c050963          	beqz	a0,33fa <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    332c:	00004517          	auipc	a0,0x4
    3330:	46450513          	addi	a0,a0,1124 # 7790 <malloc+0x1952>
    3334:	638020ef          	jal	596c <unlink>
    3338:	0c051b63          	bnez	a0,340e <dirfile+0x174>
  fd = open(".", O_RDWR);
    333c:	4589                	li	a1,2
    333e:	00003517          	auipc	a0,0x3
    3342:	31250513          	addi	a0,a0,786 # 6650 <malloc+0x812>
    3346:	616020ef          	jal	595c <open>
  if (fd >= 0) {
    334a:	0c055c63          	bgez	a0,3422 <dirfile+0x188>
  fd = open(".", 0);
    334e:	4581                	li	a1,0
    3350:	00003517          	auipc	a0,0x3
    3354:	30050513          	addi	a0,a0,768 # 6650 <malloc+0x812>
    3358:	604020ef          	jal	595c <open>
    335c:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    335e:	4605                	li	a2,1
    3360:	00003597          	auipc	a1,0x3
    3364:	c7858593          	addi	a1,a1,-904 # 5fd8 <malloc+0x19a>
    3368:	5d4020ef          	jal	593c <write>
    336c:	0ca04563          	bgtz	a0,3436 <dirfile+0x19c>
  close(fd);
    3370:	8526                	mv	a0,s1
    3372:	5d2020ef          	jal	5944 <close>
}
    3376:	60e2                	ld	ra,24(sp)
    3378:	6442                	ld	s0,16(sp)
    337a:	64a2                	ld	s1,8(sp)
    337c:	6902                	ld	s2,0(sp)
    337e:	6105                	addi	sp,sp,32
    3380:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3382:	85ca                	mv	a1,s2
    3384:	00004517          	auipc	a0,0x4
    3388:	41450513          	addi	a0,a0,1044 # 7798 <malloc+0x195a>
    338c:	1f7020ef          	jal	5d82 <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	58a020ef          	jal	591c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3396:	85ca                	mv	a1,s2
    3398:	00004517          	auipc	a0,0x4
    339c:	42050513          	addi	a0,a0,1056 # 77b8 <malloc+0x197a>
    33a0:	1e3020ef          	jal	5d82 <printf>
    exit(1);
    33a4:	4505                	li	a0,1
    33a6:	576020ef          	jal	591c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33aa:	85ca                	mv	a1,s2
    33ac:	00004517          	auipc	a0,0x4
    33b0:	43c50513          	addi	a0,a0,1084 # 77e8 <malloc+0x19aa>
    33b4:	1cf020ef          	jal	5d82 <printf>
    exit(1);
    33b8:	4505                	li	a0,1
    33ba:	562020ef          	jal	591c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33be:	85ca                	mv	a1,s2
    33c0:	00004517          	auipc	a0,0x4
    33c4:	42850513          	addi	a0,a0,1064 # 77e8 <malloc+0x19aa>
    33c8:	1bb020ef          	jal	5d82 <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	54e020ef          	jal	591c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	43c50513          	addi	a0,a0,1084 # 7810 <malloc+0x19d2>
    33dc:	1a7020ef          	jal	5d82 <printf>
    exit(1);
    33e0:	4505                	li	a0,1
    33e2:	53a020ef          	jal	591c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33e6:	85ca                	mv	a1,s2
    33e8:	00004517          	auipc	a0,0x4
    33ec:	45050513          	addi	a0,a0,1104 # 7838 <malloc+0x19fa>
    33f0:	193020ef          	jal	5d82 <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	526020ef          	jal	591c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fa:	85ca                	mv	a1,s2
    33fc:	00004517          	auipc	a0,0x4
    3400:	46450513          	addi	a0,a0,1124 # 7860 <malloc+0x1a22>
    3404:	17f020ef          	jal	5d82 <printf>
    exit(1);
    3408:	4505                	li	a0,1
    340a:	512020ef          	jal	591c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    340e:	85ca                	mv	a1,s2
    3410:	00004517          	auipc	a0,0x4
    3414:	47850513          	addi	a0,a0,1144 # 7888 <malloc+0x1a4a>
    3418:	16b020ef          	jal	5d82 <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	4fe020ef          	jal	591c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3422:	85ca                	mv	a1,s2
    3424:	00004517          	auipc	a0,0x4
    3428:	48450513          	addi	a0,a0,1156 # 78a8 <malloc+0x1a6a>
    342c:	157020ef          	jal	5d82 <printf>
    exit(1);
    3430:	4505                	li	a0,1
    3432:	4ea020ef          	jal	591c <exit>
    printf("%s: write . succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00004517          	auipc	a0,0x4
    343c:	49850513          	addi	a0,a0,1176 # 78d0 <malloc+0x1a92>
    3440:	143020ef          	jal	5d82 <printf>
    exit(1);
    3444:	4505                	li	a0,1
    3446:	4d6020ef          	jal	591c <exit>

000000000000344a <iref>:
{
    344a:	715d                	addi	sp,sp,-80
    344c:	e486                	sd	ra,72(sp)
    344e:	e0a2                	sd	s0,64(sp)
    3450:	fc26                	sd	s1,56(sp)
    3452:	f84a                	sd	s2,48(sp)
    3454:	f44e                	sd	s3,40(sp)
    3456:	f052                	sd	s4,32(sp)
    3458:	ec56                	sd	s5,24(sp)
    345a:	e85a                	sd	s6,16(sp)
    345c:	e45e                	sd	s7,8(sp)
    345e:	0880                	addi	s0,sp,80
    3460:	8baa                	mv	s7,a0
    3462:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    3466:	00004a97          	auipc	s5,0x4
    346a:	482a8a93          	addi	s5,s5,1154 # 78e8 <malloc+0x1aaa>
    mkdir("");
    346e:	00004497          	auipc	s1,0x4
    3472:	f8248493          	addi	s1,s1,-126 # 73f0 <malloc+0x15b2>
    link("README", "");
    3476:	00003b17          	auipc	s6,0x3
    347a:	ccab0b13          	addi	s6,s6,-822 # 6140 <malloc+0x302>
    fd = open("", O_CREATE);
    347e:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3482:	00004997          	auipc	s3,0x4
    3486:	35e98993          	addi	s3,s3,862 # 77e0 <malloc+0x19a2>
    348a:	a835                	j	34c6 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    348c:	85de                	mv	a1,s7
    348e:	00004517          	auipc	a0,0x4
    3492:	46250513          	addi	a0,a0,1122 # 78f0 <malloc+0x1ab2>
    3496:	0ed020ef          	jal	5d82 <printf>
      exit(1);
    349a:	4505                	li	a0,1
    349c:	480020ef          	jal	591c <exit>
      printf("%s: chdir irefd failed\n", s);
    34a0:	85de                	mv	a1,s7
    34a2:	00004517          	auipc	a0,0x4
    34a6:	46650513          	addi	a0,a0,1126 # 7908 <malloc+0x1aca>
    34aa:	0d9020ef          	jal	5d82 <printf>
      exit(1);
    34ae:	4505                	li	a0,1
    34b0:	46c020ef          	jal	591c <exit>
      close(fd);
    34b4:	490020ef          	jal	5944 <close>
    34b8:	a825                	j	34f0 <iref+0xa6>
    unlink("xx");
    34ba:	854e                	mv	a0,s3
    34bc:	4b0020ef          	jal	596c <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c0:	397d                	addiw	s2,s2,-1
    34c2:	04090063          	beqz	s2,3502 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34c6:	8556                	mv	a0,s5
    34c8:	4bc020ef          	jal	5984 <mkdir>
    34cc:	f161                	bnez	a0,348c <iref+0x42>
    if (chdir("irefd") != 0) {
    34ce:	8556                	mv	a0,s5
    34d0:	4bc020ef          	jal	598c <chdir>
    34d4:	f571                	bnez	a0,34a0 <iref+0x56>
    mkdir("");
    34d6:	8526                	mv	a0,s1
    34d8:	4ac020ef          	jal	5984 <mkdir>
    link("README", "");
    34dc:	85a6                	mv	a1,s1
    34de:	855a                	mv	a0,s6
    34e0:	49c020ef          	jal	597c <link>
    fd = open("", O_CREATE);
    34e4:	85d2                	mv	a1,s4
    34e6:	8526                	mv	a0,s1
    34e8:	474020ef          	jal	595c <open>
    if (fd >= 0)
    34ec:	fc0554e3          	bgez	a0,34b4 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f0:	85d2                	mv	a1,s4
    34f2:	854e                	mv	a0,s3
    34f4:	468020ef          	jal	595c <open>
    if (fd >= 0)
    34f8:	fc0541e3          	bltz	a0,34ba <iref+0x70>
      close(fd);
    34fc:	448020ef          	jal	5944 <close>
    3500:	bf6d                	j	34ba <iref+0x70>
  for (i = 0; i < NINODE + 1; i++) {
    3502:	03300493          	li	s1,51
    chdir("..");
    3506:	00004997          	auipc	s3,0x4
    350a:	c0298993          	addi	s3,s3,-1022 # 7108 <malloc+0x12ca>
    unlink("irefd");
    350e:	00004917          	auipc	s2,0x4
    3512:	3da90913          	addi	s2,s2,986 # 78e8 <malloc+0x1aaa>
    chdir("..");
    3516:	854e                	mv	a0,s3
    3518:	474020ef          	jal	598c <chdir>
    unlink("irefd");
    351c:	854a                	mv	a0,s2
    351e:	44e020ef          	jal	596c <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3522:	34fd                	addiw	s1,s1,-1
    3524:	f8ed                	bnez	s1,3516 <iref+0xcc>
  chdir("/");
    3526:	00004517          	auipc	a0,0x4
    352a:	b8a50513          	addi	a0,a0,-1142 # 70b0 <malloc+0x1272>
    352e:	45e020ef          	jal	598c <chdir>
}
    3532:	60a6                	ld	ra,72(sp)
    3534:	6406                	ld	s0,64(sp)
    3536:	74e2                	ld	s1,56(sp)
    3538:	7942                	ld	s2,48(sp)
    353a:	79a2                	ld	s3,40(sp)
    353c:	7a02                	ld	s4,32(sp)
    353e:	6ae2                	ld	s5,24(sp)
    3540:	6b42                	ld	s6,16(sp)
    3542:	6ba2                	ld	s7,8(sp)
    3544:	6161                	addi	sp,sp,80
    3546:	8082                	ret

0000000000003548 <unlinkcwd>:
{
    3548:	1101                	addi	sp,sp,-32
    354a:	ec06                	sd	ra,24(sp)
    354c:	e822                	sd	s0,16(sp)
    354e:	e426                	sd	s1,8(sp)
    3550:	1000                	addi	s0,sp,32
    3552:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    3554:	00004517          	auipc	a0,0x4
    3558:	3cc50513          	addi	a0,a0,972 # 7920 <malloc+0x1ae2>
    355c:	428020ef          	jal	5984 <mkdir>
    3560:	06054a63          	bltz	a0,35d4 <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    3564:	00004517          	auipc	a0,0x4
    3568:	3dc50513          	addi	a0,a0,988 # 7940 <malloc+0x1b02>
    356c:	418020ef          	jal	5984 <mkdir>
    3570:	06054c63          	bltz	a0,35e8 <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    3574:	00004517          	auipc	a0,0x4
    3578:	3cc50513          	addi	a0,a0,972 # 7940 <malloc+0x1b02>
    357c:	410020ef          	jal	598c <chdir>
    3580:	06054e63          	bltz	a0,35fc <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    3584:	00004517          	auipc	a0,0x4
    3588:	3bc50513          	addi	a0,a0,956 # 7940 <malloc+0x1b02>
    358c:	3e0020ef          	jal	596c <unlink>
    3590:	08054063          	bltz	a0,3610 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    3594:	00004517          	auipc	a0,0x4
    3598:	38c50513          	addi	a0,a0,908 # 7920 <malloc+0x1ae2>
    359c:	3d0020ef          	jal	596c <unlink>
    35a0:	08054263          	bltz	a0,3624 <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    35a4:	4581                	li	a1,0
    35a6:	00004517          	auipc	a0,0x4
    35aa:	40250513          	addi	a0,a0,1026 # 79a8 <malloc+0x1b6a>
    35ae:	3ae020ef          	jal	595c <open>
    35b2:	08a04363          	bgtz	a0,3638 <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    35b6:	20000593          	li	a1,512
    35ba:	00004517          	auipc	a0,0x4
    35be:	41e50513          	addi	a0,a0,1054 # 79d8 <malloc+0x1b9a>
    35c2:	39a020ef          	jal	595c <open>
    35c6:	08a04163          	bgtz	a0,3648 <unlinkcwd+0x100>
}
    35ca:	60e2                	ld	ra,24(sp)
    35cc:	6442                	ld	s0,16(sp)
    35ce:	64a2                	ld	s1,8(sp)
    35d0:	6105                	addi	sp,sp,32
    35d2:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35d4:	85a6                	mv	a1,s1
    35d6:	00004517          	auipc	a0,0x4
    35da:	35250513          	addi	a0,a0,850 # 7928 <malloc+0x1aea>
    35de:	7a4020ef          	jal	5d82 <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	338020ef          	jal	591c <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35e8:	85a6                	mv	a1,s1
    35ea:	00004517          	auipc	a0,0x4
    35ee:	35e50513          	addi	a0,a0,862 # 7948 <malloc+0x1b0a>
    35f2:	790020ef          	jal	5d82 <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	324020ef          	jal	591c <exit>
    printf("%s: chdir failed\n", s);
    35fc:	85a6                	mv	a1,s1
    35fe:	00004517          	auipc	a0,0x4
    3602:	36250513          	addi	a0,a0,866 # 7960 <malloc+0x1b22>
    3606:	77c020ef          	jal	5d82 <printf>
    exit(1);
    360a:	4505                	li	a0,1
    360c:	310020ef          	jal	591c <exit>
    printf("%s: unlink /a/b failed\n", s);
    3610:	85a6                	mv	a1,s1
    3612:	00004517          	auipc	a0,0x4
    3616:	36650513          	addi	a0,a0,870 # 7978 <malloc+0x1b3a>
    361a:	768020ef          	jal	5d82 <printf>
    exit(1);
    361e:	4505                	li	a0,1
    3620:	2fc020ef          	jal	591c <exit>
    printf("%s: unlink /a failed\n", s);
    3624:	85a6                	mv	a1,s1
    3626:	00004517          	auipc	a0,0x4
    362a:	36a50513          	addi	a0,a0,874 # 7990 <malloc+0x1b52>
    362e:	754020ef          	jal	5d82 <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	2e8020ef          	jal	591c <exit>
    printf("%s: open ../ non-existing directory\n", s);
    3638:	85a6                	mv	a1,s1
    363a:	00004517          	auipc	a0,0x4
    363e:	37650513          	addi	a0,a0,886 # 79b0 <malloc+0x1b72>
    3642:	740020ef          	jal	5d82 <printf>
    3646:	bf85                	j	35b6 <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    3648:	85a6                	mv	a1,s1
    364a:	00004517          	auipc	a0,0x4
    364e:	39650513          	addi	a0,a0,918 # 79e0 <malloc+0x1ba2>
    3652:	730020ef          	jal	5d82 <printf>
}
    3656:	bf95                	j	35ca <unlinkcwd+0x82>

0000000000003658 <openiputtest>:
{
    3658:	7179                	addi	sp,sp,-48
    365a:	f406                	sd	ra,40(sp)
    365c:	f022                	sd	s0,32(sp)
    365e:	ec26                	sd	s1,24(sp)
    3660:	1800                	addi	s0,sp,48
    3662:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3664:	00004517          	auipc	a0,0x4
    3668:	3a450513          	addi	a0,a0,932 # 7a08 <malloc+0x1bca>
    366c:	318020ef          	jal	5984 <mkdir>
    3670:	02054a63          	bltz	a0,36a4 <openiputtest+0x4c>
  pid = fork();
    3674:	2a0020ef          	jal	5914 <fork>
  if (pid < 0) {
    3678:	04054063          	bltz	a0,36b8 <openiputtest+0x60>
  if (pid == 0) {
    367c:	e939                	bnez	a0,36d2 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    367e:	4589                	li	a1,2
    3680:	00004517          	auipc	a0,0x4
    3684:	38850513          	addi	a0,a0,904 # 7a08 <malloc+0x1bca>
    3688:	2d4020ef          	jal	595c <open>
    if (fd >= 0) {
    368c:	04054063          	bltz	a0,36cc <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3690:	85a6                	mv	a1,s1
    3692:	00004517          	auipc	a0,0x4
    3696:	39650513          	addi	a0,a0,918 # 7a28 <malloc+0x1bea>
    369a:	6e8020ef          	jal	5d82 <printf>
      exit(1);
    369e:	4505                	li	a0,1
    36a0:	27c020ef          	jal	591c <exit>
    printf("%s: mkdir oidir failed\n", s);
    36a4:	85a6                	mv	a1,s1
    36a6:	00004517          	auipc	a0,0x4
    36aa:	36a50513          	addi	a0,a0,874 # 7a10 <malloc+0x1bd2>
    36ae:	6d4020ef          	jal	5d82 <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	268020ef          	jal	591c <exit>
    printf("%s: fork failed\n", s);
    36b8:	85a6                	mv	a1,s1
    36ba:	00003517          	auipc	a0,0x3
    36be:	13e50513          	addi	a0,a0,318 # 67f8 <malloc+0x9ba>
    36c2:	6c0020ef          	jal	5d82 <printf>
    exit(1);
    36c6:	4505                	li	a0,1
    36c8:	254020ef          	jal	591c <exit>
    exit(0);
    36cc:	4501                	li	a0,0
    36ce:	24e020ef          	jal	591c <exit>
  pause(1);
    36d2:	4505                	li	a0,1
    36d4:	2d8020ef          	jal	59ac <pause>
  if (unlink("oidir") != 0) {
    36d8:	00004517          	auipc	a0,0x4
    36dc:	33050513          	addi	a0,a0,816 # 7a08 <malloc+0x1bca>
    36e0:	28c020ef          	jal	596c <unlink>
    36e4:	c919                	beqz	a0,36fa <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36e6:	85a6                	mv	a1,s1
    36e8:	00003517          	auipc	a0,0x3
    36ec:	29850513          	addi	a0,a0,664 # 6980 <malloc+0xb42>
    36f0:	692020ef          	jal	5d82 <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	226020ef          	jal	591c <exit>
  wait(&xstatus);
    36fa:	fdc40513          	addi	a0,s0,-36
    36fe:	226020ef          	jal	5924 <wait>
  exit(xstatus);
    3702:	fdc42503          	lw	a0,-36(s0)
    3706:	216020ef          	jal	591c <exit>

000000000000370a <forkforkfork>:
{
    370a:	1101                	addi	sp,sp,-32
    370c:	ec06                	sd	ra,24(sp)
    370e:	e822                	sd	s0,16(sp)
    3710:	e426                	sd	s1,8(sp)
    3712:	1000                	addi	s0,sp,32
    3714:	84aa                	mv	s1,a0
  unlink("stopforking");
    3716:	00004517          	auipc	a0,0x4
    371a:	33a50513          	addi	a0,a0,826 # 7a50 <malloc+0x1c12>
    371e:	24e020ef          	jal	596c <unlink>
  int pid = fork();
    3722:	1f2020ef          	jal	5914 <fork>
  if (pid < 0) {
    3726:	02054b63          	bltz	a0,375c <forkforkfork+0x52>
  if (pid == 0) {
    372a:	c125                	beqz	a0,378a <forkforkfork+0x80>
  pause(20); // two seconds
    372c:	4551                	li	a0,20
    372e:	27e020ef          	jal	59ac <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3732:	20200593          	li	a1,514
    3736:	00004517          	auipc	a0,0x4
    373a:	31a50513          	addi	a0,a0,794 # 7a50 <malloc+0x1c12>
    373e:	21e020ef          	jal	595c <open>
    3742:	202020ef          	jal	5944 <close>
  wait(0);
    3746:	4501                	li	a0,0
    3748:	1dc020ef          	jal	5924 <wait>
  pause(10); // one second
    374c:	4529                	li	a0,10
    374e:	25e020ef          	jal	59ac <pause>
}
    3752:	60e2                	ld	ra,24(sp)
    3754:	6442                	ld	s0,16(sp)
    3756:	64a2                	ld	s1,8(sp)
    3758:	6105                	addi	sp,sp,32
    375a:	8082                	ret
    printf("%s: fork failed", s);
    375c:	85a6                	mv	a1,s1
    375e:	00003517          	auipc	a0,0x3
    3762:	1da50513          	addi	a0,a0,474 # 6938 <malloc+0xafa>
    3766:	61c020ef          	jal	5d82 <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	1b0020ef          	jal	591c <exit>
        exit(0);
    3770:	4501                	li	a0,0
    3772:	1aa020ef          	jal	591c <exit>
        close(open("stopforking", O_CREATE | O_RDWR));
    3776:	20200593          	li	a1,514
    377a:	00004517          	auipc	a0,0x4
    377e:	2d650513          	addi	a0,a0,726 # 7a50 <malloc+0x1c12>
    3782:	1da020ef          	jal	595c <open>
    3786:	1be020ef          	jal	5944 <close>
      int fd = open("stopforking", 0);
    378a:	4581                	li	a1,0
    378c:	00004517          	auipc	a0,0x4
    3790:	2c450513          	addi	a0,a0,708 # 7a50 <malloc+0x1c12>
    3794:	1c8020ef          	jal	595c <open>
      if (fd >= 0) {
    3798:	fc055ce3          	bgez	a0,3770 <forkforkfork+0x66>
      if (fork() < 0) {
    379c:	178020ef          	jal	5914 <fork>
    37a0:	fe0555e3          	bgez	a0,378a <forkforkfork+0x80>
    37a4:	bfc9                	j	3776 <forkforkfork+0x6c>

00000000000037a6 <exectest>:
{
    37a6:	711d                	addi	sp,sp,-96
    37a8:	ec86                	sd	ra,88(sp)
    37aa:	e8a2                	sd	s0,80(sp)
    37ac:	e0ca                	sd	s2,64(sp)
    37ae:	1080                	addi	s0,sp,96
    37b0:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    37b2:	00002797          	auipc	a5,0x2
    37b6:	7b678793          	addi	a5,a5,1974 # 5f68 <malloc+0x12a>
    37ba:	faf43823          	sd	a5,-80(s0)
    37be:	00004797          	auipc	a5,0x4
    37c2:	2a278793          	addi	a5,a5,674 # 7a60 <malloc+0x1c22>
    37c6:	faf43c23          	sd	a5,-72(s0)
    37ca:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37ce:	00004517          	auipc	a0,0x4
    37d2:	29a50513          	addi	a0,a0,666 # 7a68 <malloc+0x1c2a>
    37d6:	196020ef          	jal	596c <unlink>
  pid = fork();
    37da:	13a020ef          	jal	5914 <fork>
  if (pid < 0) {
    37de:	04054763          	bltz	a0,382c <exectest+0x86>
    37e2:	e4a6                	sd	s1,72(sp)
    37e4:	fc4e                	sd	s3,56(sp)
    37e6:	84aa                	mv	s1,a0
  if (pid == 0) {
    37e8:	ed49                	bnez	a0,3882 <exectest+0xdc>
    int errfd = dup(1);
    37ea:	4505                	li	a0,1
    37ec:	1a8020ef          	jal	5994 <dup>
    37f0:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37f2:	04054963          	bltz	a0,3844 <exectest+0x9e>
    close(1);
    37f6:	4505                	li	a0,1
    37f8:	14c020ef          	jal	5944 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    37fc:	20100593          	li	a1,513
    3800:	00004517          	auipc	a0,0x4
    3804:	26850513          	addi	a0,a0,616 # 7a68 <malloc+0x1c2a>
    3808:	154020ef          	jal	595c <open>
    if (fd < 0) {
    380c:	04054663          	bltz	a0,3858 <exectest+0xb2>
    if (fd != 1) {
    3810:	4785                	li	a5,1
    3812:	04f50e63          	beq	a0,a5,386e <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    3816:	864a                	mv	a2,s2
    3818:	00004597          	auipc	a1,0x4
    381c:	26858593          	addi	a1,a1,616 # 7a80 <malloc+0x1c42>
    3820:	854e                	mv	a0,s3
    3822:	536020ef          	jal	5d58 <fprintf>
      exit(1);
    3826:	4505                	li	a0,1
    3828:	0f4020ef          	jal	591c <exit>
    382c:	e4a6                	sd	s1,72(sp)
    382e:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3830:	85ca                	mv	a1,s2
    3832:	00003517          	auipc	a0,0x3
    3836:	fc650513          	addi	a0,a0,-58 # 67f8 <malloc+0x9ba>
    383a:	548020ef          	jal	5d82 <printf>
    exit(1);
    383e:	4505                	li	a0,1
    3840:	0dc020ef          	jal	591c <exit>
      printf("%s: dup failed\n", s);
    3844:	85ca                	mv	a1,s2
    3846:	00004517          	auipc	a0,0x4
    384a:	22a50513          	addi	a0,a0,554 # 7a70 <malloc+0x1c32>
    384e:	534020ef          	jal	5d82 <printf>
      exit(1);
    3852:	4505                	li	a0,1
    3854:	0c8020ef          	jal	591c <exit>
      fprintf(errfd, "%s: create failed\n", s);
    3858:	864a                	mv	a2,s2
    385a:	00003597          	auipc	a1,0x3
    385e:	10e58593          	addi	a1,a1,270 # 6968 <malloc+0xb2a>
    3862:	854e                	mv	a0,s3
    3864:	4f4020ef          	jal	5d58 <fprintf>
      exit(1);
    3868:	4505                	li	a0,1
    386a:	0b2020ef          	jal	591c <exit>
    if (exec("echo", echoargv) < 0) {
    386e:	fb040593          	addi	a1,s0,-80
    3872:	00002517          	auipc	a0,0x2
    3876:	6f650513          	addi	a0,a0,1782 # 5f68 <malloc+0x12a>
    387a:	0da020ef          	jal	5954 <exec>
    387e:	02054563          	bltz	a0,38a8 <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3882:	fcc40513          	addi	a0,s0,-52
    3886:	09e020ef          	jal	5924 <wait>
    388a:	02951a63          	bne	a0,s1,38be <exectest+0x118>
  if (xstatus != 0) {
    388e:	fcc42603          	lw	a2,-52(s0)
    3892:	ce15                	beqz	a2,38ce <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3894:	85ca                	mv	a1,s2
    3896:	00004517          	auipc	a0,0x4
    389a:	22a50513          	addi	a0,a0,554 # 7ac0 <malloc+0x1c82>
    389e:	4e4020ef          	jal	5d82 <printf>
    exit(1);
    38a2:	4505                	li	a0,1
    38a4:	078020ef          	jal	591c <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    38a8:	864a                	mv	a2,s2
    38aa:	00004597          	auipc	a1,0x4
    38ae:	1e658593          	addi	a1,a1,486 # 7a90 <malloc+0x1c52>
    38b2:	854e                	mv	a0,s3
    38b4:	4a4020ef          	jal	5d58 <fprintf>
      exit(1);
    38b8:	4505                	li	a0,1
    38ba:	062020ef          	jal	591c <exit>
    printf("%s: wait failed!\n", s);
    38be:	85ca                	mv	a1,s2
    38c0:	00004517          	auipc	a0,0x4
    38c4:	1e850513          	addi	a0,a0,488 # 7aa8 <malloc+0x1c6a>
    38c8:	4ba020ef          	jal	5d82 <printf>
    38cc:	b7c9                	j	388e <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38ce:	4581                	li	a1,0
    38d0:	00004517          	auipc	a0,0x4
    38d4:	19850513          	addi	a0,a0,408 # 7a68 <malloc+0x1c2a>
    38d8:	084020ef          	jal	595c <open>
  if (fd < 0) {
    38dc:	02054463          	bltz	a0,3904 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38e0:	4609                	li	a2,2
    38e2:	fa840593          	addi	a1,s0,-88
    38e6:	04e020ef          	jal	5934 <read>
    38ea:	4789                	li	a5,2
    38ec:	02f50663          	beq	a0,a5,3918 <exectest+0x172>
    printf("%s: read failed\n", s);
    38f0:	85ca                	mv	a1,s2
    38f2:	00003517          	auipc	a0,0x3
    38f6:	a4650513          	addi	a0,a0,-1466 # 6338 <malloc+0x4fa>
    38fa:	488020ef          	jal	5d82 <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	01c020ef          	jal	591c <exit>
    printf("%s: open failed\n", s);
    3904:	85ca                	mv	a1,s2
    3906:	00003517          	auipc	a0,0x3
    390a:	f0a50513          	addi	a0,a0,-246 # 6810 <malloc+0x9d2>
    390e:	474020ef          	jal	5d82 <printf>
    exit(1);
    3912:	4505                	li	a0,1
    3914:	008020ef          	jal	591c <exit>
  unlink("echo-ok");
    3918:	00004517          	auipc	a0,0x4
    391c:	15050513          	addi	a0,a0,336 # 7a68 <malloc+0x1c2a>
    3920:	04c020ef          	jal	596c <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3924:	fa844703          	lbu	a4,-88(s0)
    3928:	04f00793          	li	a5,79
    392c:	00f71863          	bne	a4,a5,393c <exectest+0x196>
    3930:	fa944703          	lbu	a4,-87(s0)
    3934:	04b00793          	li	a5,75
    3938:	00f70c63          	beq	a4,a5,3950 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    393c:	85ca                	mv	a1,s2
    393e:	00004517          	auipc	a0,0x4
    3942:	1a250513          	addi	a0,a0,418 # 7ae0 <malloc+0x1ca2>
    3946:	43c020ef          	jal	5d82 <printf>
    exit(1);
    394a:	4505                	li	a0,1
    394c:	7d1010ef          	jal	591c <exit>
    exit(0);
    3950:	4501                	li	a0,0
    3952:	7cb010ef          	jal	591c <exit>

0000000000003956 <pipezero>:
{
    3956:	715d                	addi	sp,sp,-80
    3958:	e486                	sd	ra,72(sp)
    395a:	e0a2                	sd	s0,64(sp)
    395c:	fc26                	sd	s1,56(sp)
    395e:	f84a                	sd	s2,48(sp)
    3960:	f44e                	sd	s3,40(sp)
    3962:	f052                	sd	s4,32(sp)
    3964:	0880                	addi	s0,sp,80
    3966:	8a2a                	mv	s4,a0
  if ((reader = fork()) < 0) {
    3968:	7ad010ef          	jal	5914 <fork>
    396c:	04054663          	bltz	a0,39b8 <pipezero+0x62>
    3970:	892a                	mv	s2,a0
  if (reader == 0) {
    3972:	cd29                	beqz	a0,39cc <pipezero+0x76>
  if ((timer = fork()) < 0) {
    3974:	7a1010ef          	jal	5914 <fork>
    3978:	84aa                	mv	s1,a0
    397a:	12054463          	bltz	a0,3aa2 <pipezero+0x14c>
  if (timer == 0) {
    397e:	14050263          	beqz	a0,3ac2 <pipezero+0x16c>
  pid = wait(&status);
    3982:	fcc40513          	addi	a0,s0,-52
    3986:	79f010ef          	jal	5924 <wait>
    398a:	89aa                	mv	s3,a0
  if (pid == timer) {
    398c:	14a48263          	beq	s1,a0,3ad0 <pipezero+0x17a>
  kill(timer);
    3990:	8526                	mv	a0,s1
    3992:	7bb010ef          	jal	594c <kill>
  wait(0);
    3996:	4501                	li	a0,0
    3998:	78d010ef          	jal	5924 <wait>
  if (pid != reader || status != 0)
    399c:	15391a63          	bne	s2,s3,3af0 <pipezero+0x19a>
    39a0:	fcc42783          	lw	a5,-52(s0)
    39a4:	14079663          	bnez	a5,3af0 <pipezero+0x19a>
}
    39a8:	60a6                	ld	ra,72(sp)
    39aa:	6406                	ld	s0,64(sp)
    39ac:	74e2                	ld	s1,56(sp)
    39ae:	7942                	ld	s2,48(sp)
    39b0:	79a2                	ld	s3,40(sp)
    39b2:	7a02                	ld	s4,32(sp)
    39b4:	6161                	addi	sp,sp,80
    39b6:	8082                	ret
    printf("%s: fork failed\n", s);
    39b8:	85d2                	mv	a1,s4
    39ba:	00003517          	auipc	a0,0x3
    39be:	e3e50513          	addi	a0,a0,-450 # 67f8 <malloc+0x9ba>
    39c2:	3c0020ef          	jal	5d82 <printf>
    exit(1);
    39c6:	4505                	li	a0,1
    39c8:	755010ef          	jal	591c <exit>
  char c = 'z';
    39cc:	07a00793          	li	a5,122
    39d0:	faf40fa3          	sb	a5,-65(s0)
  if (pipe(fds) < 0) {
    39d4:	fc040513          	addi	a0,s0,-64
    39d8:	755010ef          	jal	592c <pipe>
    39dc:	08054563          	bltz	a0,3a66 <pipezero+0x110>
  if (read(fds[0], &c, 0) != 0 || c != 'z') {
    39e0:	4601                	li	a2,0
    39e2:	fbf40593          	addi	a1,s0,-65
    39e6:	fc042503          	lw	a0,-64(s0)
    39ea:	74b010ef          	jal	5934 <read>
    39ee:	e551                	bnez	a0,3a7a <pipezero+0x124>
    39f0:	fbf44703          	lbu	a4,-65(s0)
    39f4:	07a00793          	li	a5,122
    39f8:	08f71163          	bne	a4,a5,3a7a <pipezero+0x124>
  if (write(fds[1], "x", 1) != 1 || read(fds[0], &c, 0) != 0 || c != 'z' ||
    39fc:	4605                	li	a2,1
    39fe:	00002597          	auipc	a1,0x2
    3a02:	5da58593          	addi	a1,a1,1498 # 5fd8 <malloc+0x19a>
    3a06:	fc442503          	lw	a0,-60(s0)
    3a0a:	733010ef          	jal	593c <write>
    3a0e:	4785                	li	a5,1
    3a10:	06f51f63          	bne	a0,a5,3a8e <pipezero+0x138>
    3a14:	4601                	li	a2,0
    3a16:	fbf40593          	addi	a1,s0,-65
    3a1a:	fc042503          	lw	a0,-64(s0)
    3a1e:	717010ef          	jal	5934 <read>
    3a22:	e535                	bnez	a0,3a8e <pipezero+0x138>
    3a24:	fbf44703          	lbu	a4,-65(s0)
    3a28:	07a00793          	li	a5,122
    3a2c:	06f71163          	bne	a4,a5,3a8e <pipezero+0x138>
      read(fds[0], &c, 1) != 1 || c != 'x') {
    3a30:	4605                	li	a2,1
    3a32:	fbf40593          	addi	a1,s0,-65
    3a36:	fc042503          	lw	a0,-64(s0)
    3a3a:	6fb010ef          	jal	5934 <read>
  if (write(fds[1], "x", 1) != 1 || read(fds[0], &c, 0) != 0 || c != 'z' ||
    3a3e:	4785                	li	a5,1
    3a40:	04f51763          	bne	a0,a5,3a8e <pipezero+0x138>
      read(fds[0], &c, 1) != 1 || c != 'x') {
    3a44:	fbf44703          	lbu	a4,-65(s0)
    3a48:	07800793          	li	a5,120
    3a4c:	04f71163          	bne	a4,a5,3a8e <pipezero+0x138>
  close(fds[0]);
    3a50:	fc042503          	lw	a0,-64(s0)
    3a54:	6f1010ef          	jal	5944 <close>
  close(fds[1]);
    3a58:	fc442503          	lw	a0,-60(s0)
    3a5c:	6e9010ef          	jal	5944 <close>
    exit(0);
    3a60:	4501                	li	a0,0
    3a62:	6bb010ef          	jal	591c <exit>
    printf("%s: pipe failed\n", s);
    3a66:	85d2                	mv	a1,s4
    3a68:	00004517          	auipc	a0,0x4
    3a6c:	09050513          	addi	a0,a0,144 # 7af8 <malloc+0x1cba>
    3a70:	312020ef          	jal	5d82 <printf>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	6a7010ef          	jal	591c <exit>
    printf("%s: zero-length read on empty pipe failed\n", s);
    3a7a:	85d2                	mv	a1,s4
    3a7c:	00004517          	auipc	a0,0x4
    3a80:	09450513          	addi	a0,a0,148 # 7b10 <malloc+0x1cd2>
    3a84:	2fe020ef          	jal	5d82 <printf>
    exit(1);
    3a88:	4505                	li	a0,1
    3a8a:	693010ef          	jal	591c <exit>
    printf("%s: zero-length read consumed data\n", s);
    3a8e:	85d2                	mv	a1,s4
    3a90:	00004517          	auipc	a0,0x4
    3a94:	0b050513          	addi	a0,a0,176 # 7b40 <malloc+0x1d02>
    3a98:	2ea020ef          	jal	5d82 <printf>
    exit(1);
    3a9c:	4505                	li	a0,1
    3a9e:	67f010ef          	jal	591c <exit>
    kill(reader);
    3aa2:	854a                	mv	a0,s2
    3aa4:	6a9010ef          	jal	594c <kill>
    wait(0);
    3aa8:	4501                	li	a0,0
    3aaa:	67b010ef          	jal	5924 <wait>
    printf("%s: fork failed\n", s);
    3aae:	85d2                	mv	a1,s4
    3ab0:	00003517          	auipc	a0,0x3
    3ab4:	d4850513          	addi	a0,a0,-696 # 67f8 <malloc+0x9ba>
    3ab8:	2ca020ef          	jal	5d82 <printf>
    exit(1);
    3abc:	4505                	li	a0,1
    3abe:	65f010ef          	jal	591c <exit>
    pause(50);
    3ac2:	03200513          	li	a0,50
    3ac6:	6e7010ef          	jal	59ac <pause>
    exit(0);
    3aca:	4501                	li	a0,0
    3acc:	651010ef          	jal	591c <exit>
    kill(reader);
    3ad0:	854a                	mv	a0,s2
    3ad2:	67b010ef          	jal	594c <kill>
    wait(0);
    3ad6:	4501                	li	a0,0
    3ad8:	64d010ef          	jal	5924 <wait>
    printf("%s: zero-length read timed out\n", s);
    3adc:	85d2                	mv	a1,s4
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	08a50513          	addi	a0,a0,138 # 7b68 <malloc+0x1d2a>
    3ae6:	29c020ef          	jal	5d82 <printf>
    exit(1);
    3aea:	4505                	li	a0,1
    3aec:	631010ef          	jal	591c <exit>
    exit(1);
    3af0:	4505                	li	a0,1
    3af2:	62b010ef          	jal	591c <exit>

0000000000003af6 <killzero>:
{
    3af6:	7179                	addi	sp,sp,-48
    3af8:	f406                	sd	ra,40(sp)
    3afa:	f022                	sd	s0,32(sp)
    3afc:	e84a                	sd	s2,16(sp)
    3afe:	1800                	addi	s0,sp,48
    3b00:	892a                	mv	s2,a0
  kill(0);
    3b02:	4501                	li	a0,0
    3b04:	649010ef          	jal	594c <kill>
  pid = fork();
    3b08:	60d010ef          	jal	5914 <fork>
  if (pid < 0) {
    3b0c:	00054863          	bltz	a0,3b1c <killzero+0x26>
    3b10:	ec26                	sd	s1,24(sp)
    3b12:	84aa                	mv	s1,a0
  if (pid == 0) {
    3b14:	ed19                	bnez	a0,3b32 <killzero+0x3c>
    exit(7);
    3b16:	451d                	li	a0,7
    3b18:	605010ef          	jal	591c <exit>
    3b1c:	ec26                	sd	s1,24(sp)
    printf("%s: fork failed\n", s);
    3b1e:	85ca                	mv	a1,s2
    3b20:	00003517          	auipc	a0,0x3
    3b24:	cd850513          	addi	a0,a0,-808 # 67f8 <malloc+0x9ba>
    3b28:	25a020ef          	jal	5d82 <printf>
    exit(1);
    3b2c:	4505                	li	a0,1
    3b2e:	5ef010ef          	jal	591c <exit>
  if (wait(&xst) != pid) {
    3b32:	fdc40513          	addi	a0,s0,-36
    3b36:	5ef010ef          	jal	5924 <wait>
    3b3a:	02951163          	bne	a0,s1,3b5c <killzero+0x66>
  if (xst != 7) {
    3b3e:	fdc42603          	lw	a2,-36(s0)
    3b42:	479d                	li	a5,7
    3b44:	02f60663          	beq	a2,a5,3b70 <killzero+0x7a>
    printf("%s: child exited with status %d, expected 7\n", s, xst);
    3b48:	85ca                	mv	a1,s2
    3b4a:	00004517          	auipc	a0,0x4
    3b4e:	03e50513          	addi	a0,a0,62 # 7b88 <malloc+0x1d4a>
    3b52:	230020ef          	jal	5d82 <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	5c5010ef          	jal	591c <exit>
    printf("%s: wait wrong pid\n", s);
    3b5c:	85ca                	mv	a1,s2
    3b5e:	00003517          	auipc	a0,0x3
    3b62:	da250513          	addi	a0,a0,-606 # 6900 <malloc+0xac2>
    3b66:	21c020ef          	jal	5d82 <printf>
    exit(1);
    3b6a:	4505                	li	a0,1
    3b6c:	5b1010ef          	jal	591c <exit>
  exit(0);
    3b70:	4501                	li	a0,0
    3b72:	5ab010ef          	jal	591c <exit>

0000000000003b76 <preempt>:
{
    3b76:	7139                	addi	sp,sp,-64
    3b78:	fc06                	sd	ra,56(sp)
    3b7a:	f822                	sd	s0,48(sp)
    3b7c:	f426                	sd	s1,40(sp)
    3b7e:	f04a                	sd	s2,32(sp)
    3b80:	ec4e                	sd	s3,24(sp)
    3b82:	e852                	sd	s4,16(sp)
    3b84:	0080                	addi	s0,sp,64
    3b86:	892a                	mv	s2,a0
  pid1 = fork();
    3b88:	58d010ef          	jal	5914 <fork>
  if (pid1 < 0) {
    3b8c:	00054563          	bltz	a0,3b96 <preempt+0x20>
    3b90:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3b92:	ed01                	bnez	a0,3baa <preempt+0x34>
    for (;;)
    3b94:	a001                	j	3b94 <preempt+0x1e>
    printf("%s: fork failed", s);
    3b96:	85ca                	mv	a1,s2
    3b98:	00003517          	auipc	a0,0x3
    3b9c:	da050513          	addi	a0,a0,-608 # 6938 <malloc+0xafa>
    3ba0:	1e2020ef          	jal	5d82 <printf>
    exit(1);
    3ba4:	4505                	li	a0,1
    3ba6:	577010ef          	jal	591c <exit>
  pid2 = fork();
    3baa:	56b010ef          	jal	5914 <fork>
    3bae:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3bb0:	00054463          	bltz	a0,3bb8 <preempt+0x42>
  if (pid2 == 0)
    3bb4:	ed01                	bnez	a0,3bcc <preempt+0x56>
    for (;;)
    3bb6:	a001                	j	3bb6 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3bb8:	85ca                	mv	a1,s2
    3bba:	00003517          	auipc	a0,0x3
    3bbe:	c3e50513          	addi	a0,a0,-962 # 67f8 <malloc+0x9ba>
    3bc2:	1c0020ef          	jal	5d82 <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	555010ef          	jal	591c <exit>
  pipe(pfds);
    3bcc:	fc840513          	addi	a0,s0,-56
    3bd0:	55d010ef          	jal	592c <pipe>
  pid3 = fork();
    3bd4:	541010ef          	jal	5914 <fork>
    3bd8:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3bda:	02054863          	bltz	a0,3c0a <preempt+0x94>
  if (pid3 == 0) {
    3bde:	e921                	bnez	a0,3c2e <preempt+0xb8>
    close(pfds[0]);
    3be0:	fc842503          	lw	a0,-56(s0)
    3be4:	561010ef          	jal	5944 <close>
    if (write(pfds[1], "x", 1) != 1)
    3be8:	4605                	li	a2,1
    3bea:	00002597          	auipc	a1,0x2
    3bee:	3ee58593          	addi	a1,a1,1006 # 5fd8 <malloc+0x19a>
    3bf2:	fcc42503          	lw	a0,-52(s0)
    3bf6:	547010ef          	jal	593c <write>
    3bfa:	4785                	li	a5,1
    3bfc:	02f51163          	bne	a0,a5,3c1e <preempt+0xa8>
    close(pfds[1]);
    3c00:	fcc42503          	lw	a0,-52(s0)
    3c04:	541010ef          	jal	5944 <close>
    for (;;)
    3c08:	a001                	j	3c08 <preempt+0x92>
    printf("%s: fork failed\n", s);
    3c0a:	85ca                	mv	a1,s2
    3c0c:	00003517          	auipc	a0,0x3
    3c10:	bec50513          	addi	a0,a0,-1044 # 67f8 <malloc+0x9ba>
    3c14:	16e020ef          	jal	5d82 <printf>
    exit(1);
    3c18:	4505                	li	a0,1
    3c1a:	503010ef          	jal	591c <exit>
      printf("%s: preempt write error", s);
    3c1e:	85ca                	mv	a1,s2
    3c20:	00004517          	auipc	a0,0x4
    3c24:	f9850513          	addi	a0,a0,-104 # 7bb8 <malloc+0x1d7a>
    3c28:	15a020ef          	jal	5d82 <printf>
    3c2c:	bfd1                	j	3c00 <preempt+0x8a>
  close(pfds[1]);
    3c2e:	fcc42503          	lw	a0,-52(s0)
    3c32:	513010ef          	jal	5944 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3c36:	660d                	lui	a2,0x3
    3c38:	00009597          	auipc	a1,0x9
    3c3c:	0d058593          	addi	a1,a1,208 # cd08 <buf>
    3c40:	fc842503          	lw	a0,-56(s0)
    3c44:	4f1010ef          	jal	5934 <read>
    3c48:	4785                	li	a5,1
    3c4a:	00f50a63          	beq	a0,a5,3c5e <preempt+0xe8>
    printf("%s: preempt read error", s);
    3c4e:	85ca                	mv	a1,s2
    3c50:	00004517          	auipc	a0,0x4
    3c54:	f8050513          	addi	a0,a0,-128 # 7bd0 <malloc+0x1d92>
    3c58:	12a020ef          	jal	5d82 <printf>
    return;
    3c5c:	a099                	j	3ca2 <preempt+0x12c>
  close(pfds[0]);
    3c5e:	fc842503          	lw	a0,-56(s0)
    3c62:	4e3010ef          	jal	5944 <close>
  printf("kill... ");
    3c66:	00004517          	auipc	a0,0x4
    3c6a:	f8250513          	addi	a0,a0,-126 # 7be8 <malloc+0x1daa>
    3c6e:	114020ef          	jal	5d82 <printf>
  kill(pid1);
    3c72:	8526                	mv	a0,s1
    3c74:	4d9010ef          	jal	594c <kill>
  kill(pid2);
    3c78:	854e                	mv	a0,s3
    3c7a:	4d3010ef          	jal	594c <kill>
  kill(pid3);
    3c7e:	8552                	mv	a0,s4
    3c80:	4cd010ef          	jal	594c <kill>
  printf("wait... ");
    3c84:	00004517          	auipc	a0,0x4
    3c88:	f7450513          	addi	a0,a0,-140 # 7bf8 <malloc+0x1dba>
    3c8c:	0f6020ef          	jal	5d82 <printf>
  wait(0);
    3c90:	4501                	li	a0,0
    3c92:	493010ef          	jal	5924 <wait>
  wait(0);
    3c96:	4501                	li	a0,0
    3c98:	48d010ef          	jal	5924 <wait>
  wait(0);
    3c9c:	4501                	li	a0,0
    3c9e:	487010ef          	jal	5924 <wait>
}
    3ca2:	70e2                	ld	ra,56(sp)
    3ca4:	7442                	ld	s0,48(sp)
    3ca6:	74a2                	ld	s1,40(sp)
    3ca8:	7902                	ld	s2,32(sp)
    3caa:	69e2                	ld	s3,24(sp)
    3cac:	6a42                	ld	s4,16(sp)
    3cae:	6121                	addi	sp,sp,64
    3cb0:	8082                	ret

0000000000003cb2 <sbrkfail>:
{
    3cb2:	7175                	addi	sp,sp,-144
    3cb4:	e506                	sd	ra,136(sp)
    3cb6:	e122                	sd	s0,128(sp)
    3cb8:	fca6                	sd	s1,120(sp)
    3cba:	f8ca                	sd	s2,112(sp)
    3cbc:	f4ce                	sd	s3,104(sp)
    3cbe:	f0d2                	sd	s4,96(sp)
    3cc0:	ecd6                	sd	s5,88(sp)
    3cc2:	e8da                	sd	s6,80(sp)
    3cc4:	e4de                	sd	s7,72(sp)
    3cc6:	e0e2                	sd	s8,64(sp)
    3cc8:	0900                	addi	s0,sp,144
    3cca:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3ccc:	fa040513          	addi	a0,s0,-96
    3cd0:	45d010ef          	jal	592c <pipe>
    3cd4:	ed01                	bnez	a0,3cec <sbrkfail+0x3a>
    3cd6:	8baa                	mv	s7,a0
    3cd8:	f7040493          	addi	s1,s0,-144
    3cdc:	f9840993          	addi	s3,s0,-104
    3ce0:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3ce2:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3ce4:	f9f40b13          	addi	s6,s0,-97
    3ce8:	4a85                	li	s5,1
    3cea:	a095                	j	3d4e <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3cec:	85e2                	mv	a1,s8
    3cee:	00003517          	auipc	a0,0x3
    3cf2:	b9250513          	addi	a0,a0,-1134 # 6880 <malloc+0xa42>
    3cf6:	08c020ef          	jal	5d82 <printf>
    exit(1);
    3cfa:	4505                	li	a0,1
    3cfc:	421010ef          	jal	591c <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3d00:	3e9010ef          	jal	58e8 <sbrk>
    3d04:	064007b7          	lui	a5,0x6400
    3d08:	40a7853b          	subw	a0,a5,a0
    3d0c:	3dd010ef          	jal	58e8 <sbrk>
    3d10:	57fd                	li	a5,-1
    3d12:	02f50163          	beq	a0,a5,3d34 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3d16:	4605                	li	a2,1
    3d18:	00005597          	auipc	a1,0x5
    3d1c:	8d858593          	addi	a1,a1,-1832 # 85f0 <malloc+0x27b2>
    3d20:	fa442503          	lw	a0,-92(s0)
    3d24:	419010ef          	jal	593c <write>
        pause(1000);
    3d28:	3e800493          	li	s1,1000
    3d2c:	8526                	mv	a0,s1
    3d2e:	47f010ef          	jal	59ac <pause>
      for (;;)
    3d32:	bfed                	j	3d2c <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3d34:	4605                	li	a2,1
    3d36:	00004597          	auipc	a1,0x4
    3d3a:	ed258593          	addi	a1,a1,-302 # 7c08 <malloc+0x1dca>
    3d3e:	fa442503          	lw	a0,-92(s0)
    3d42:	3fb010ef          	jal	593c <write>
    3d46:	b7cd                	j	3d28 <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3d48:	0911                	addi	s2,s2,4
    3d4a:	03390a63          	beq	s2,s3,3d7e <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3d4e:	3c7010ef          	jal	5914 <fork>
    3d52:	00a92023          	sw	a0,0(s2)
    3d56:	d54d                	beqz	a0,3d00 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3d58:	ff4508e3          	beq	a0,s4,3d48 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3d5c:	8656                	mv	a2,s5
    3d5e:	85da                	mv	a1,s6
    3d60:	fa042503          	lw	a0,-96(s0)
    3d64:	3d1010ef          	jal	5934 <read>
      if (scratch == '0')
    3d68:	f9f44783          	lbu	a5,-97(s0)
    3d6c:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f02c8>
    3d70:	0017b793          	seqz	a5,a5
    3d74:	00fbe7b3          	or	a5,s7,a5
    3d78:	00078b9b          	sext.w	s7,a5
    3d7c:	b7f1                	j	3d48 <sbrkfail+0x96>
  if (!failed) {
    3d7e:	000b8863          	beqz	s7,3d8e <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3d82:	6505                	lui	a0,0x1
    3d84:	365010ef          	jal	58e8 <sbrk>
    3d88:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3d8a:	597d                	li	s2,-1
    3d8c:	a821                	j	3da4 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3d8e:	85e2                	mv	a1,s8
    3d90:	00004517          	auipc	a0,0x4
    3d94:	e8050513          	addi	a0,a0,-384 # 7c10 <malloc+0x1dd2>
    3d98:	7eb010ef          	jal	5d82 <printf>
    3d9c:	b7dd                	j	3d82 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3d9e:	0491                	addi	s1,s1,4
    3da0:	01348b63          	beq	s1,s3,3db6 <sbrkfail+0x104>
    if (pids[i] == -1)
    3da4:	4088                	lw	a0,0(s1)
    3da6:	ff250ce3          	beq	a0,s2,3d9e <sbrkfail+0xec>
    kill(pids[i]);
    3daa:	3a3010ef          	jal	594c <kill>
    wait(0);
    3dae:	4501                	li	a0,0
    3db0:	375010ef          	jal	5924 <wait>
    3db4:	b7ed                	j	3d9e <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3db6:	57fd                	li	a5,-1
    3db8:	02fa0a63          	beq	s4,a5,3dec <sbrkfail+0x13a>
  pid = fork();
    3dbc:	359010ef          	jal	5914 <fork>
  if (pid < 0) {
    3dc0:	04054063          	bltz	a0,3e00 <sbrkfail+0x14e>
  if (pid == 0) {
    3dc4:	e939                	bnez	a0,3e1a <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3dc6:	3e800537          	lui	a0,0x3e800
    3dca:	31f010ef          	jal	58e8 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3dce:	57fd                	li	a5,-1
    3dd0:	04f50263          	beq	a0,a5,3e14 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3dd4:	3e800637          	lui	a2,0x3e800
    3dd8:	85e2                	mv	a1,s8
    3dda:	00004517          	auipc	a0,0x4
    3dde:	e8650513          	addi	a0,a0,-378 # 7c60 <malloc+0x1e22>
    3de2:	7a1010ef          	jal	5d82 <printf>
    exit(1);
    3de6:	4505                	li	a0,1
    3de8:	335010ef          	jal	591c <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3dec:	85e2                	mv	a1,s8
    3dee:	00004517          	auipc	a0,0x4
    3df2:	e5250513          	addi	a0,a0,-430 # 7c40 <malloc+0x1e02>
    3df6:	78d010ef          	jal	5d82 <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	321010ef          	jal	591c <exit>
    printf("%s: fork failed\n", s);
    3e00:	85e2                	mv	a1,s8
    3e02:	00003517          	auipc	a0,0x3
    3e06:	9f650513          	addi	a0,a0,-1546 # 67f8 <malloc+0x9ba>
    3e0a:	779010ef          	jal	5d82 <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	30d010ef          	jal	591c <exit>
      exit(0);
    3e14:	4501                	li	a0,0
    3e16:	307010ef          	jal	591c <exit>
  wait(&xstatus);
    3e1a:	fac40513          	addi	a0,s0,-84
    3e1e:	307010ef          	jal	5924 <wait>
  if (xstatus != 0)
    3e22:	fac42783          	lw	a5,-84(s0)
    3e26:	ef89                	bnez	a5,3e40 <sbrkfail+0x18e>
}
    3e28:	60aa                	ld	ra,136(sp)
    3e2a:	640a                	ld	s0,128(sp)
    3e2c:	74e6                	ld	s1,120(sp)
    3e2e:	7946                	ld	s2,112(sp)
    3e30:	79a6                	ld	s3,104(sp)
    3e32:	7a06                	ld	s4,96(sp)
    3e34:	6ae6                	ld	s5,88(sp)
    3e36:	6b46                	ld	s6,80(sp)
    3e38:	6ba6                	ld	s7,72(sp)
    3e3a:	6c06                	ld	s8,64(sp)
    3e3c:	6149                	addi	sp,sp,144
    3e3e:	8082                	ret
    exit(1);
    3e40:	4505                	li	a0,1
    3e42:	2db010ef          	jal	591c <exit>

0000000000003e46 <killstatus>:
{
    3e46:	715d                	addi	sp,sp,-80
    3e48:	e486                	sd	ra,72(sp)
    3e4a:	e0a2                	sd	s0,64(sp)
    3e4c:	fc26                	sd	s1,56(sp)
    3e4e:	f84a                	sd	s2,48(sp)
    3e50:	f44e                	sd	s3,40(sp)
    3e52:	f052                	sd	s4,32(sp)
    3e54:	ec56                	sd	s5,24(sp)
    3e56:	e85a                	sd	s6,16(sp)
    3e58:	0880                	addi	s0,sp,80
    3e5a:	8b2a                	mv	s6,a0
    3e5c:	06400913          	li	s2,100
    pause(1);
    3e60:	4a85                	li	s5,1
    wait(&xst);
    3e62:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    3e66:	59fd                	li	s3,-1
    int pid1 = fork();
    3e68:	2ad010ef          	jal	5914 <fork>
    3e6c:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3e6e:	02054663          	bltz	a0,3e9a <killstatus+0x54>
    if (pid1 == 0) {
    3e72:	cd15                	beqz	a0,3eae <killstatus+0x68>
    pause(1);
    3e74:	8556                	mv	a0,s5
    3e76:	337010ef          	jal	59ac <pause>
    kill(pid1);
    3e7a:	8526                	mv	a0,s1
    3e7c:	2d1010ef          	jal	594c <kill>
    wait(&xst);
    3e80:	8552                	mv	a0,s4
    3e82:	2a3010ef          	jal	5924 <wait>
    if (xst != -1) {
    3e86:	fbc42783          	lw	a5,-68(s0)
    3e8a:	03379563          	bne	a5,s3,3eb4 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    3e8e:	397d                	addiw	s2,s2,-1
    3e90:	fc091ce3          	bnez	s2,3e68 <killstatus+0x22>
  exit(0);
    3e94:	4501                	li	a0,0
    3e96:	287010ef          	jal	591c <exit>
      printf("%s: fork failed\n", s);
    3e9a:	85da                	mv	a1,s6
    3e9c:	00003517          	auipc	a0,0x3
    3ea0:	95c50513          	addi	a0,a0,-1700 # 67f8 <malloc+0x9ba>
    3ea4:	6df010ef          	jal	5d82 <printf>
      exit(1);
    3ea8:	4505                	li	a0,1
    3eaa:	273010ef          	jal	591c <exit>
        getpid();
    3eae:	2ef010ef          	jal	599c <getpid>
      while (1) {
    3eb2:	bff5                	j	3eae <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    3eb4:	85da                	mv	a1,s6
    3eb6:	00004517          	auipc	a0,0x4
    3eba:	dda50513          	addi	a0,a0,-550 # 7c90 <malloc+0x1e52>
    3ebe:	6c5010ef          	jal	5d82 <printf>
      exit(1);
    3ec2:	4505                	li	a0,1
    3ec4:	259010ef          	jal	591c <exit>

0000000000003ec8 <reparent>:
{
    3ec8:	7179                	addi	sp,sp,-48
    3eca:	f406                	sd	ra,40(sp)
    3ecc:	f022                	sd	s0,32(sp)
    3ece:	ec26                	sd	s1,24(sp)
    3ed0:	e84a                	sd	s2,16(sp)
    3ed2:	e44e                	sd	s3,8(sp)
    3ed4:	e052                	sd	s4,0(sp)
    3ed6:	1800                	addi	s0,sp,48
    3ed8:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3eda:	2c3010ef          	jal	599c <getpid>
    3ede:	8a2a                	mv	s4,a0
    3ee0:	0c800913          	li	s2,200
    int pid = fork();
    3ee4:	231010ef          	jal	5914 <fork>
    3ee8:	84aa                	mv	s1,a0
    if (pid < 0) {
    3eea:	00054e63          	bltz	a0,3f06 <reparent+0x3e>
    if (pid) {
    3eee:	c121                	beqz	a0,3f2e <reparent+0x66>
      if (wait(0) != pid) {
    3ef0:	4501                	li	a0,0
    3ef2:	233010ef          	jal	5924 <wait>
    3ef6:	02951263          	bne	a0,s1,3f1a <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3efa:	397d                	addiw	s2,s2,-1
    3efc:	fe0914e3          	bnez	s2,3ee4 <reparent+0x1c>
  exit(0);
    3f00:	4501                	li	a0,0
    3f02:	21b010ef          	jal	591c <exit>
      printf("%s: fork failed\n", s);
    3f06:	85ce                	mv	a1,s3
    3f08:	00003517          	auipc	a0,0x3
    3f0c:	8f050513          	addi	a0,a0,-1808 # 67f8 <malloc+0x9ba>
    3f10:	673010ef          	jal	5d82 <printf>
      exit(1);
    3f14:	4505                	li	a0,1
    3f16:	207010ef          	jal	591c <exit>
        printf("%s: wait wrong pid\n", s);
    3f1a:	85ce                	mv	a1,s3
    3f1c:	00003517          	auipc	a0,0x3
    3f20:	9e450513          	addi	a0,a0,-1564 # 6900 <malloc+0xac2>
    3f24:	65f010ef          	jal	5d82 <printf>
        exit(1);
    3f28:	4505                	li	a0,1
    3f2a:	1f3010ef          	jal	591c <exit>
      int pid2 = fork();
    3f2e:	1e7010ef          	jal	5914 <fork>
      if (pid2 < 0) {
    3f32:	00054563          	bltz	a0,3f3c <reparent+0x74>
      exit(0);
    3f36:	4501                	li	a0,0
    3f38:	1e5010ef          	jal	591c <exit>
        kill(master_pid);
    3f3c:	8552                	mv	a0,s4
    3f3e:	20f010ef          	jal	594c <kill>
        exit(1);
    3f42:	4505                	li	a0,1
    3f44:	1d9010ef          	jal	591c <exit>

0000000000003f48 <mem>:
{
    3f48:	7139                	addi	sp,sp,-64
    3f4a:	fc06                	sd	ra,56(sp)
    3f4c:	f822                	sd	s0,48(sp)
    3f4e:	f426                	sd	s1,40(sp)
    3f50:	f04a                	sd	s2,32(sp)
    3f52:	ec4e                	sd	s3,24(sp)
    3f54:	0080                	addi	s0,sp,64
    3f56:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3f58:	1bd010ef          	jal	5914 <fork>
    m1 = 0;
    3f5c:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3f5e:	6909                	lui	s2,0x2
    3f60:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xf1>
  if ((pid = fork()) == 0) {
    3f64:	cd11                	beqz	a0,3f80 <mem+0x38>
    wait(&xstatus);
    3f66:	fcc40513          	addi	a0,s0,-52
    3f6a:	1bb010ef          	jal	5924 <wait>
    if (xstatus == -1) {
    3f6e:	fcc42503          	lw	a0,-52(s0)
    3f72:	57fd                	li	a5,-1
    3f74:	04f50363          	beq	a0,a5,3fba <mem+0x72>
    exit(xstatus);
    3f78:	1a5010ef          	jal	591c <exit>
      *(char **)m2 = m1;
    3f7c:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f7e:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3f80:	854a                	mv	a0,s2
    3f82:	6bd010ef          	jal	5e3e <malloc>
    3f86:	f97d                	bnez	a0,3f7c <mem+0x34>
    while (m1) {
    3f88:	c491                	beqz	s1,3f94 <mem+0x4c>
      m2 = *(char **)m1;
    3f8a:	8526                	mv	a0,s1
    3f8c:	6084                	ld	s1,0(s1)
      free(m1);
    3f8e:	627010ef          	jal	5db4 <free>
    while (m1) {
    3f92:	fce5                	bnez	s1,3f8a <mem+0x42>
    m1 = malloc(1024 * 20);
    3f94:	6515                	lui	a0,0x5
    3f96:	6a9010ef          	jal	5e3e <malloc>
    if (m1 == 0) {
    3f9a:	c511                	beqz	a0,3fa6 <mem+0x5e>
    free(m1);
    3f9c:	619010ef          	jal	5db4 <free>
    exit(0);
    3fa0:	4501                	li	a0,0
    3fa2:	17b010ef          	jal	591c <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3fa6:	85ce                	mv	a1,s3
    3fa8:	00004517          	auipc	a0,0x4
    3fac:	d0850513          	addi	a0,a0,-760 # 7cb0 <malloc+0x1e72>
    3fb0:	5d3010ef          	jal	5d82 <printf>
      exit(1);
    3fb4:	4505                	li	a0,1
    3fb6:	167010ef          	jal	591c <exit>
      exit(0);
    3fba:	4501                	li	a0,0
    3fbc:	161010ef          	jal	591c <exit>

0000000000003fc0 <sharedfd>:
{
    3fc0:	7159                	addi	sp,sp,-112
    3fc2:	f486                	sd	ra,104(sp)
    3fc4:	f0a2                	sd	s0,96(sp)
    3fc6:	eca6                	sd	s1,88(sp)
    3fc8:	f85a                	sd	s6,48(sp)
    3fca:	1880                	addi	s0,sp,112
    3fcc:	84aa                	mv	s1,a0
    3fce:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3fd0:	00004517          	auipc	a0,0x4
    3fd4:	d0050513          	addi	a0,a0,-768 # 7cd0 <malloc+0x1e92>
    3fd8:	195010ef          	jal	596c <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3fdc:	20200593          	li	a1,514
    3fe0:	00004517          	auipc	a0,0x4
    3fe4:	cf050513          	addi	a0,a0,-784 # 7cd0 <malloc+0x1e92>
    3fe8:	175010ef          	jal	595c <open>
  if (fd < 0) {
    3fec:	04054863          	bltz	a0,403c <sharedfd+0x7c>
    3ff0:	e8ca                	sd	s2,80(sp)
    3ff2:	e4ce                	sd	s3,72(sp)
    3ff4:	e0d2                	sd	s4,64(sp)
    3ff6:	fc56                	sd	s5,56(sp)
    3ff8:	89aa                	mv	s3,a0
  pid = fork();
    3ffa:	11b010ef          	jal	5914 <fork>
    3ffe:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4000:	07000593          	li	a1,112
    4004:	e119                	bnez	a0,400a <sharedfd+0x4a>
    4006:	06300593          	li	a1,99
    400a:	4629                	li	a2,10
    400c:	fa040513          	addi	a0,s0,-96
    4010:	6e2010ef          	jal	56f2 <memset>
    4014:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    4018:	fa040a13          	addi	s4,s0,-96
    401c:	4929                	li	s2,10
    401e:	864a                	mv	a2,s2
    4020:	85d2                	mv	a1,s4
    4022:	854e                	mv	a0,s3
    4024:	119010ef          	jal	593c <write>
    4028:	03251963          	bne	a0,s2,405a <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    402c:	34fd                	addiw	s1,s1,-1
    402e:	f8e5                	bnez	s1,401e <sharedfd+0x5e>
  if (pid == 0) {
    4030:	040a9063          	bnez	s5,4070 <sharedfd+0xb0>
    4034:	f45e                	sd	s7,40(sp)
    exit(0);
    4036:	4501                	li	a0,0
    4038:	0e5010ef          	jal	591c <exit>
    403c:	e8ca                	sd	s2,80(sp)
    403e:	e4ce                	sd	s3,72(sp)
    4040:	e0d2                	sd	s4,64(sp)
    4042:	fc56                	sd	s5,56(sp)
    4044:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4046:	85a6                	mv	a1,s1
    4048:	00004517          	auipc	a0,0x4
    404c:	c9850513          	addi	a0,a0,-872 # 7ce0 <malloc+0x1ea2>
    4050:	533010ef          	jal	5d82 <printf>
    exit(1);
    4054:	4505                	li	a0,1
    4056:	0c7010ef          	jal	591c <exit>
    405a:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    405c:	85da                	mv	a1,s6
    405e:	00004517          	auipc	a0,0x4
    4062:	caa50513          	addi	a0,a0,-854 # 7d08 <malloc+0x1eca>
    4066:	51d010ef          	jal	5d82 <printf>
      exit(1);
    406a:	4505                	li	a0,1
    406c:	0b1010ef          	jal	591c <exit>
    wait(&xstatus);
    4070:	f9c40513          	addi	a0,s0,-100
    4074:	0b1010ef          	jal	5924 <wait>
    if (xstatus != 0)
    4078:	f9c42a03          	lw	s4,-100(s0)
    407c:	000a0663          	beqz	s4,4088 <sharedfd+0xc8>
    4080:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    4082:	8552                	mv	a0,s4
    4084:	099010ef          	jal	591c <exit>
    4088:	f45e                	sd	s7,40(sp)
  close(fd);
    408a:	854e                	mv	a0,s3
    408c:	0b9010ef          	jal	5944 <close>
  fd = open("sharedfd", 0);
    4090:	4581                	li	a1,0
    4092:	00004517          	auipc	a0,0x4
    4096:	c3e50513          	addi	a0,a0,-962 # 7cd0 <malloc+0x1e92>
    409a:	0c3010ef          	jal	595c <open>
    409e:	8baa                	mv	s7,a0
  nc = np = 0;
    40a0:	89d2                	mv	s3,s4
  if (fd < 0) {
    40a2:	02054363          	bltz	a0,40c8 <sharedfd+0x108>
    40a6:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    40aa:	06300493          	li	s1,99
      if (buf[i] == 'p')
    40ae:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    40b2:	4629                	li	a2,10
    40b4:	fa040593          	addi	a1,s0,-96
    40b8:	855e                	mv	a0,s7
    40ba:	07b010ef          	jal	5934 <read>
    40be:	02a05b63          	blez	a0,40f4 <sharedfd+0x134>
    40c2:	fa040793          	addi	a5,s0,-96
    40c6:	a839                	j	40e4 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    40c8:	85da                	mv	a1,s6
    40ca:	00004517          	auipc	a0,0x4
    40ce:	c5e50513          	addi	a0,a0,-930 # 7d28 <malloc+0x1eea>
    40d2:	4b1010ef          	jal	5d82 <printf>
    exit(1);
    40d6:	4505                	li	a0,1
    40d8:	045010ef          	jal	591c <exit>
        nc++;
    40dc:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    40de:	0785                	addi	a5,a5,1
    40e0:	fd2789e3          	beq	a5,s2,40b2 <sharedfd+0xf2>
      if (buf[i] == 'c')
    40e4:	0007c703          	lbu	a4,0(a5)
    40e8:	fe970ae3          	beq	a4,s1,40dc <sharedfd+0x11c>
      if (buf[i] == 'p')
    40ec:	ff5719e3          	bne	a4,s5,40de <sharedfd+0x11e>
        np++;
    40f0:	2985                	addiw	s3,s3,1
    40f2:	b7f5                	j	40de <sharedfd+0x11e>
  close(fd);
    40f4:	855e                	mv	a0,s7
    40f6:	04f010ef          	jal	5944 <close>
  unlink("sharedfd");
    40fa:	00004517          	auipc	a0,0x4
    40fe:	bd650513          	addi	a0,a0,-1066 # 7cd0 <malloc+0x1e92>
    4102:	06b010ef          	jal	596c <unlink>
  if (nc == N * SZ && np == N * SZ) {
    4106:	6789                	lui	a5,0x2
    4108:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xf0>
    410c:	00fa1763          	bne	s4,a5,411a <sharedfd+0x15a>
    4110:	01499563          	bne	s3,s4,411a <sharedfd+0x15a>
    exit(0);
    4114:	4501                	li	a0,0
    4116:	007010ef          	jal	591c <exit>
    printf("%s: nc/np test fails\n", s);
    411a:	85da                	mv	a1,s6
    411c:	00004517          	auipc	a0,0x4
    4120:	c3450513          	addi	a0,a0,-972 # 7d50 <malloc+0x1f12>
    4124:	45f010ef          	jal	5d82 <printf>
    exit(1);
    4128:	4505                	li	a0,1
    412a:	7f2010ef          	jal	591c <exit>

000000000000412e <fourfiles>:
{
    412e:	7135                	addi	sp,sp,-160
    4130:	ed06                	sd	ra,152(sp)
    4132:	e922                	sd	s0,144(sp)
    4134:	e526                	sd	s1,136(sp)
    4136:	e14a                	sd	s2,128(sp)
    4138:	fcce                	sd	s3,120(sp)
    413a:	f8d2                	sd	s4,112(sp)
    413c:	f4d6                	sd	s5,104(sp)
    413e:	f0da                	sd	s6,96(sp)
    4140:	ecde                	sd	s7,88(sp)
    4142:	e8e2                	sd	s8,80(sp)
    4144:	e4e6                	sd	s9,72(sp)
    4146:	e0ea                	sd	s10,64(sp)
    4148:	fc6e                	sd	s11,56(sp)
    414a:	1100                	addi	s0,sp,160
    414c:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    414e:	00004797          	auipc	a5,0x4
    4152:	c1a78793          	addi	a5,a5,-998 # 7d68 <malloc+0x1f2a>
    4156:	f6f43823          	sd	a5,-144(s0)
    415a:	00004797          	auipc	a5,0x4
    415e:	c1678793          	addi	a5,a5,-1002 # 7d70 <malloc+0x1f32>
    4162:	f6f43c23          	sd	a5,-136(s0)
    4166:	00004797          	auipc	a5,0x4
    416a:	c1278793          	addi	a5,a5,-1006 # 7d78 <malloc+0x1f3a>
    416e:	f8f43023          	sd	a5,-128(s0)
    4172:	00004797          	auipc	a5,0x4
    4176:	c0e78793          	addi	a5,a5,-1010 # 7d80 <malloc+0x1f42>
    417a:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    417e:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    4182:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    4184:	4481                	li	s1,0
    4186:	4a11                	li	s4,4
    fname = names[pi];
    4188:	00093983          	ld	s3,0(s2)
    unlink(fname);
    418c:	854e                	mv	a0,s3
    418e:	7de010ef          	jal	596c <unlink>
    pid = fork();
    4192:	782010ef          	jal	5914 <fork>
    if (pid < 0) {
    4196:	04054063          	bltz	a0,41d6 <fourfiles+0xa8>
    if (pid == 0) {
    419a:	c921                	beqz	a0,41ea <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    419c:	2485                	addiw	s1,s1,1
    419e:	0921                	addi	s2,s2,8
    41a0:	ff4494e3          	bne	s1,s4,4188 <fourfiles+0x5a>
    41a4:	4491                	li	s1,4
    wait(&xstatus);
    41a6:	f6c40913          	addi	s2,s0,-148
    41aa:	854a                	mv	a0,s2
    41ac:	778010ef          	jal	5924 <wait>
    if (xstatus != 0)
    41b0:	f6c42b03          	lw	s6,-148(s0)
    41b4:	0a0b1463          	bnez	s6,425c <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    41b8:	34fd                	addiw	s1,s1,-1
    41ba:	f8e5                	bnez	s1,41aa <fourfiles+0x7c>
    41bc:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    41c0:	6a8d                	lui	s5,0x3
    41c2:	00009a17          	auipc	s4,0x9
    41c6:	b46a0a13          	addi	s4,s4,-1210 # cd08 <buf>
    if (total != N * SZ) {
    41ca:	6d05                	lui	s10,0x1
    41cc:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    41d0:	03400d93          	li	s11,52
    41d4:	a86d                	j	428e <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    41d6:	85e6                	mv	a1,s9
    41d8:	00002517          	auipc	a0,0x2
    41dc:	62050513          	addi	a0,a0,1568 # 67f8 <malloc+0x9ba>
    41e0:	3a3010ef          	jal	5d82 <printf>
      exit(1);
    41e4:	4505                	li	a0,1
    41e6:	736010ef          	jal	591c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    41ea:	20200593          	li	a1,514
    41ee:	854e                	mv	a0,s3
    41f0:	76c010ef          	jal	595c <open>
    41f4:	892a                	mv	s2,a0
      if (fd < 0) {
    41f6:	04054063          	bltz	a0,4236 <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    41fa:	1f400613          	li	a2,500
    41fe:	0304859b          	addiw	a1,s1,48
    4202:	00009517          	auipc	a0,0x9
    4206:	b0650513          	addi	a0,a0,-1274 # cd08 <buf>
    420a:	4e8010ef          	jal	56f2 <memset>
    420e:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4210:	1f400993          	li	s3,500
    4214:	00009a17          	auipc	s4,0x9
    4218:	af4a0a13          	addi	s4,s4,-1292 # cd08 <buf>
    421c:	864e                	mv	a2,s3
    421e:	85d2                	mv	a1,s4
    4220:	854a                	mv	a0,s2
    4222:	71a010ef          	jal	593c <write>
    4226:	85aa                	mv	a1,a0
    4228:	03351163          	bne	a0,s3,424a <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    422c:	34fd                	addiw	s1,s1,-1
    422e:	f4fd                	bnez	s1,421c <fourfiles+0xee>
      exit(0);
    4230:	4501                	li	a0,0
    4232:	6ea010ef          	jal	591c <exit>
        printf("%s: create failed\n", s);
    4236:	85e6                	mv	a1,s9
    4238:	00002517          	auipc	a0,0x2
    423c:	73050513          	addi	a0,a0,1840 # 6968 <malloc+0xb2a>
    4240:	343010ef          	jal	5d82 <printf>
        exit(1);
    4244:	4505                	li	a0,1
    4246:	6d6010ef          	jal	591c <exit>
          printf("write failed %d\n", n);
    424a:	00004517          	auipc	a0,0x4
    424e:	b3e50513          	addi	a0,a0,-1218 # 7d88 <malloc+0x1f4a>
    4252:	331010ef          	jal	5d82 <printf>
          exit(1);
    4256:	4505                	li	a0,1
    4258:	6c4010ef          	jal	591c <exit>
      exit(xstatus);
    425c:	855a                	mv	a0,s6
    425e:	6be010ef          	jal	591c <exit>
          printf("%s: wrong char\n", s);
    4262:	85e6                	mv	a1,s9
    4264:	00004517          	auipc	a0,0x4
    4268:	b3c50513          	addi	a0,a0,-1220 # 7da0 <malloc+0x1f62>
    426c:	317010ef          	jal	5d82 <printf>
          exit(1);
    4270:	4505                	li	a0,1
    4272:	6aa010ef          	jal	591c <exit>
    close(fd);
    4276:	854e                	mv	a0,s3
    4278:	6cc010ef          	jal	5944 <close>
    if (total != N * SZ) {
    427c:	05a91863          	bne	s2,s10,42cc <fourfiles+0x19e>
    unlink(fname);
    4280:	8562                	mv	a0,s8
    4282:	6ea010ef          	jal	596c <unlink>
  for (i = 0; i < NCHILD; i++) {
    4286:	0ba1                	addi	s7,s7,8
    4288:	2485                	addiw	s1,s1,1
    428a:	05b48b63          	beq	s1,s11,42e0 <fourfiles+0x1b2>
    fname = names[i];
    428e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4292:	4581                	li	a1,0
    4294:	8562                	mv	a0,s8
    4296:	6c6010ef          	jal	595c <open>
    429a:	89aa                	mv	s3,a0
    total = 0;
    429c:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    429e:	8656                	mv	a2,s5
    42a0:	85d2                	mv	a1,s4
    42a2:	854e                	mv	a0,s3
    42a4:	690010ef          	jal	5934 <read>
    42a8:	fca057e3          	blez	a0,4276 <fourfiles+0x148>
    42ac:	00009797          	auipc	a5,0x9
    42b0:	a5c78793          	addi	a5,a5,-1444 # cd08 <buf>
    42b4:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    42b8:	0007c703          	lbu	a4,0(a5)
    42bc:	fa9713e3          	bne	a4,s1,4262 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    42c0:	0785                	addi	a5,a5,1
    42c2:	fed79be3          	bne	a5,a3,42b8 <fourfiles+0x18a>
      total += n;
    42c6:	00a9093b          	addw	s2,s2,a0
    42ca:	bfd1                	j	429e <fourfiles+0x170>
      printf("wrong length %d\n", total);
    42cc:	85ca                	mv	a1,s2
    42ce:	00004517          	auipc	a0,0x4
    42d2:	ae250513          	addi	a0,a0,-1310 # 7db0 <malloc+0x1f72>
    42d6:	2ad010ef          	jal	5d82 <printf>
      exit(1);
    42da:	4505                	li	a0,1
    42dc:	640010ef          	jal	591c <exit>
}
    42e0:	60ea                	ld	ra,152(sp)
    42e2:	644a                	ld	s0,144(sp)
    42e4:	64aa                	ld	s1,136(sp)
    42e6:	690a                	ld	s2,128(sp)
    42e8:	79e6                	ld	s3,120(sp)
    42ea:	7a46                	ld	s4,112(sp)
    42ec:	7aa6                	ld	s5,104(sp)
    42ee:	7b06                	ld	s6,96(sp)
    42f0:	6be6                	ld	s7,88(sp)
    42f2:	6c46                	ld	s8,80(sp)
    42f4:	6ca6                	ld	s9,72(sp)
    42f6:	6d06                	ld	s10,64(sp)
    42f8:	7de2                	ld	s11,56(sp)
    42fa:	610d                	addi	sp,sp,160
    42fc:	8082                	ret

00000000000042fe <concreate>:
{
    42fe:	7171                	addi	sp,sp,-176
    4300:	f506                	sd	ra,168(sp)
    4302:	f122                	sd	s0,160(sp)
    4304:	ed26                	sd	s1,152(sp)
    4306:	e94a                	sd	s2,144(sp)
    4308:	e54e                	sd	s3,136(sp)
    430a:	e152                	sd	s4,128(sp)
    430c:	fcd6                	sd	s5,120(sp)
    430e:	f8da                	sd	s6,112(sp)
    4310:	f4de                	sd	s7,104(sp)
    4312:	f0e2                	sd	s8,96(sp)
    4314:	ece6                	sd	s9,88(sp)
    4316:	e8ea                	sd	s10,80(sp)
    4318:	1900                	addi	s0,sp,176
    431a:	8d2a                	mv	s10,a0
  file[0] = 'C';
    431c:	04300793          	li	a5,67
    4320:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4324:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    4328:	4901                	li	s2,0
    unlink(file);
    432a:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    432e:	55555b37          	lui	s6,0x55555
    4332:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554584e>
    4336:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    4338:	20200c13          	li	s8,514
      link("C0", file);
    433c:	00004c97          	auipc	s9,0x4
    4340:	a8cc8c93          	addi	s9,s9,-1396 # 7dc8 <malloc+0x1f8a>
      wait(&xstatus);
    4344:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    4348:	02800a13          	li	s4,40
    434c:	a481                	j	458c <concreate+0x28e>
      link("C0", file);
    434e:	85ce                	mv	a1,s3
    4350:	8566                	mv	a0,s9
    4352:	62a010ef          	jal	597c <link>
    if (pid == 0) {
    4356:	a40d                	j	4578 <concreate+0x27a>
    } else if (pid == 0 && (i % 5) == 1) {
    4358:	666667b7          	lui	a5,0x66666
    435c:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665695f>
    4360:	02f907b3          	mul	a5,s2,a5
    4364:	9785                	srai	a5,a5,0x21
    4366:	41f9571b          	sraiw	a4,s2,0x1f
    436a:	9f99                	subw	a5,a5,a4
    436c:	0027971b          	slliw	a4,a5,0x2
    4370:	9fb9                	addw	a5,a5,a4
    4372:	40f9093b          	subw	s2,s2,a5
    4376:	4785                	li	a5,1
    4378:	02f90563          	beq	s2,a5,43a2 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    437c:	20200593          	li	a1,514
    4380:	f9840513          	addi	a0,s0,-104
    4384:	5d8010ef          	jal	595c <open>
      if (fd < 0) {
    4388:	1e055363          	bgez	a0,456e <concreate+0x270>
        printf("concreate create %s failed\n", file);
    438c:	f9840593          	addi	a1,s0,-104
    4390:	00004517          	auipc	a0,0x4
    4394:	a4050513          	addi	a0,a0,-1472 # 7dd0 <malloc+0x1f92>
    4398:	1eb010ef          	jal	5d82 <printf>
        exit(1);
    439c:	4505                	li	a0,1
    439e:	57e010ef          	jal	591c <exit>
      link("C0", file);
    43a2:	f9840593          	addi	a1,s0,-104
    43a6:	00004517          	auipc	a0,0x4
    43aa:	a2250513          	addi	a0,a0,-1502 # 7dc8 <malloc+0x1f8a>
    43ae:	5ce010ef          	jal	597c <link>
      exit(0);
    43b2:	4501                	li	a0,0
    43b4:	568010ef          	jal	591c <exit>
        exit(1);
    43b8:	4505                	li	a0,1
    43ba:	562010ef          	jal	591c <exit>
  memset(fa, 0, sizeof(fa));
    43be:	02800613          	li	a2,40
    43c2:	4581                	li	a1,0
    43c4:	f7040513          	addi	a0,s0,-144
    43c8:	32a010ef          	jal	56f2 <memset>
  fd = open(".", 0);
    43cc:	4581                	li	a1,0
    43ce:	00002517          	auipc	a0,0x2
    43d2:	28250513          	addi	a0,a0,642 # 6650 <malloc+0x812>
    43d6:	586010ef          	jal	595c <open>
    43da:	892a                	mv	s2,a0
  n = 0;
    43dc:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    43de:	f6040a13          	addi	s4,s0,-160
    43e2:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    43e4:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    43e8:	02700b93          	li	s7,39
      fa[i] = 1;
    43ec:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    43ee:	864e                	mv	a2,s3
    43f0:	85d2                	mv	a1,s4
    43f2:	854a                	mv	a0,s2
    43f4:	540010ef          	jal	5934 <read>
    43f8:	06a05763          	blez	a0,4466 <concreate+0x168>
    if (de.inum == 0)
    43fc:	f6045783          	lhu	a5,-160(s0)
    4400:	d7fd                	beqz	a5,43ee <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4402:	f6244783          	lbu	a5,-158(s0)
    4406:	ff5794e3          	bne	a5,s5,43ee <concreate+0xf0>
    440a:	f6444783          	lbu	a5,-156(s0)
    440e:	f3e5                	bnez	a5,43ee <concreate+0xf0>
      i = de.name[1] - '0';
    4410:	f6344783          	lbu	a5,-157(s0)
    4414:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    4418:	00fbef63          	bltu	s7,a5,4436 <concreate+0x138>
      if (fa[i]) {
    441c:	fa040713          	addi	a4,s0,-96
    4420:	973e                	add	a4,a4,a5
    4422:	fd074703          	lbu	a4,-48(a4)
    4426:	e705                	bnez	a4,444e <concreate+0x150>
      fa[i] = 1;
    4428:	fa040713          	addi	a4,s0,-96
    442c:	97ba                	add	a5,a5,a4
    442e:	fd878823          	sb	s8,-48(a5)
      n++;
    4432:	2b05                	addiw	s6,s6,1
    4434:	bf6d                	j	43ee <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4436:	f6240613          	addi	a2,s0,-158
    443a:	85ea                	mv	a1,s10
    443c:	00004517          	auipc	a0,0x4
    4440:	9b450513          	addi	a0,a0,-1612 # 7df0 <malloc+0x1fb2>
    4444:	13f010ef          	jal	5d82 <printf>
        exit(1);
    4448:	4505                	li	a0,1
    444a:	4d2010ef          	jal	591c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    444e:	f6240613          	addi	a2,s0,-158
    4452:	85ea                	mv	a1,s10
    4454:	00004517          	auipc	a0,0x4
    4458:	9bc50513          	addi	a0,a0,-1604 # 7e10 <malloc+0x1fd2>
    445c:	127010ef          	jal	5d82 <printf>
        exit(1);
    4460:	4505                	li	a0,1
    4462:	4ba010ef          	jal	591c <exit>
  close(fd);
    4466:	854a                	mv	a0,s2
    4468:	4dc010ef          	jal	5944 <close>
  if (n != N) {
    446c:	02800793          	li	a5,40
    4470:	00fb1a63          	bne	s6,a5,4484 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4474:	55555a37          	lui	s4,0x55555
    4478:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554584e>
      close(open(file, 0));
    447c:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    4480:	8ada                	mv	s5,s6
    4482:	a049                	j	4504 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4484:	85ea                	mv	a1,s10
    4486:	00004517          	auipc	a0,0x4
    448a:	9b250513          	addi	a0,a0,-1614 # 7e38 <malloc+0x1ffa>
    448e:	0f5010ef          	jal	5d82 <printf>
    exit(1);
    4492:	4505                	li	a0,1
    4494:	488010ef          	jal	591c <exit>
      printf("%s: fork failed\n", s);
    4498:	85ea                	mv	a1,s10
    449a:	00002517          	auipc	a0,0x2
    449e:	35e50513          	addi	a0,a0,862 # 67f8 <malloc+0x9ba>
    44a2:	0e1010ef          	jal	5d82 <printf>
      exit(1);
    44a6:	4505                	li	a0,1
    44a8:	474010ef          	jal	591c <exit>
      close(open(file, 0));
    44ac:	4581                	li	a1,0
    44ae:	854e                	mv	a0,s3
    44b0:	4ac010ef          	jal	595c <open>
    44b4:	490010ef          	jal	5944 <close>
      close(open(file, 0));
    44b8:	4581                	li	a1,0
    44ba:	854e                	mv	a0,s3
    44bc:	4a0010ef          	jal	595c <open>
    44c0:	484010ef          	jal	5944 <close>
      close(open(file, 0));
    44c4:	4581                	li	a1,0
    44c6:	854e                	mv	a0,s3
    44c8:	494010ef          	jal	595c <open>
    44cc:	478010ef          	jal	5944 <close>
      close(open(file, 0));
    44d0:	4581                	li	a1,0
    44d2:	854e                	mv	a0,s3
    44d4:	488010ef          	jal	595c <open>
    44d8:	46c010ef          	jal	5944 <close>
      close(open(file, 0));
    44dc:	4581                	li	a1,0
    44de:	854e                	mv	a0,s3
    44e0:	47c010ef          	jal	595c <open>
    44e4:	460010ef          	jal	5944 <close>
      close(open(file, 0));
    44e8:	4581                	li	a1,0
    44ea:	854e                	mv	a0,s3
    44ec:	470010ef          	jal	595c <open>
    44f0:	454010ef          	jal	5944 <close>
    if (pid == 0)
    44f4:	06090a63          	beqz	s2,4568 <concreate+0x26a>
      wait(0);
    44f8:	4501                	li	a0,0
    44fa:	42a010ef          	jal	5924 <wait>
  for (i = 0; i < N; i++) {
    44fe:	2485                	addiw	s1,s1,1
    4500:	0d548563          	beq	s1,s5,45ca <concreate+0x2cc>
    file[1] = '0' + i;
    4504:	0304879b          	addiw	a5,s1,48
    4508:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    450c:	408010ef          	jal	5914 <fork>
    4510:	892a                	mv	s2,a0
    if (pid < 0) {
    4512:	f80543e3          	bltz	a0,4498 <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4516:	03448733          	mul	a4,s1,s4
    451a:	9301                	srli	a4,a4,0x20
    451c:	41f4d79b          	sraiw	a5,s1,0x1f
    4520:	9f1d                	subw	a4,a4,a5
    4522:	0017179b          	slliw	a5,a4,0x1
    4526:	9fb9                	addw	a5,a5,a4
    4528:	40f487bb          	subw	a5,s1,a5
    452c:	00a7e733          	or	a4,a5,a0
    4530:	2701                	sext.w	a4,a4
    4532:	df2d                	beqz	a4,44ac <concreate+0x1ae>
    4534:	00a03733          	snez	a4,a0
    4538:	17fd                	addi	a5,a5,-1
    453a:	0017b793          	seqz	a5,a5
    453e:	8ff9                	and	a5,a5,a4
    4540:	f7b5                	bnez	a5,44ac <concreate+0x1ae>
      unlink(file);
    4542:	854e                	mv	a0,s3
    4544:	428010ef          	jal	596c <unlink>
      unlink(file);
    4548:	854e                	mv	a0,s3
    454a:	422010ef          	jal	596c <unlink>
      unlink(file);
    454e:	854e                	mv	a0,s3
    4550:	41c010ef          	jal	596c <unlink>
      unlink(file);
    4554:	854e                	mv	a0,s3
    4556:	416010ef          	jal	596c <unlink>
      unlink(file);
    455a:	854e                	mv	a0,s3
    455c:	410010ef          	jal	596c <unlink>
      unlink(file);
    4560:	854e                	mv	a0,s3
    4562:	40a010ef          	jal	596c <unlink>
    4566:	b779                	j	44f4 <concreate+0x1f6>
      exit(0);
    4568:	4501                	li	a0,0
    456a:	3b2010ef          	jal	591c <exit>
      close(fd);
    456e:	3d6010ef          	jal	5944 <close>
    if (pid == 0) {
    4572:	b581                	j	43b2 <concreate+0xb4>
      close(fd);
    4574:	3d0010ef          	jal	5944 <close>
      wait(&xstatus);
    4578:	8556                	mv	a0,s5
    457a:	3aa010ef          	jal	5924 <wait>
      if (xstatus != 0)
    457e:	f5c42483          	lw	s1,-164(s0)
    4582:	e2049be3          	bnez	s1,43b8 <concreate+0xba>
  for (i = 0; i < N; i++) {
    4586:	2905                	addiw	s2,s2,1
    4588:	e3490be3          	beq	s2,s4,43be <concreate+0xc0>
    file[1] = '0' + i;
    458c:	0309079b          	addiw	a5,s2,48
    4590:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4594:	854e                	mv	a0,s3
    4596:	3d6010ef          	jal	596c <unlink>
    pid = fork();
    459a:	37a010ef          	jal	5914 <fork>
    if (pid && (i % 3) == 1) {
    459e:	da050de3          	beqz	a0,4358 <concreate+0x5a>
    45a2:	036907b3          	mul	a5,s2,s6
    45a6:	9381                	srli	a5,a5,0x20
    45a8:	41f9571b          	sraiw	a4,s2,0x1f
    45ac:	9f99                	subw	a5,a5,a4
    45ae:	0017971b          	slliw	a4,a5,0x1
    45b2:	9fb9                	addw	a5,a5,a4
    45b4:	40f907bb          	subw	a5,s2,a5
    45b8:	d9778be3          	beq	a5,s7,434e <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    45bc:	85e2                	mv	a1,s8
    45be:	854e                	mv	a0,s3
    45c0:	39c010ef          	jal	595c <open>
      if (fd < 0) {
    45c4:	fa0558e3          	bgez	a0,4574 <concreate+0x276>
    45c8:	b3d1                	j	438c <concreate+0x8e>
}
    45ca:	70aa                	ld	ra,168(sp)
    45cc:	740a                	ld	s0,160(sp)
    45ce:	64ea                	ld	s1,152(sp)
    45d0:	694a                	ld	s2,144(sp)
    45d2:	69aa                	ld	s3,136(sp)
    45d4:	6a0a                	ld	s4,128(sp)
    45d6:	7ae6                	ld	s5,120(sp)
    45d8:	7b46                	ld	s6,112(sp)
    45da:	7ba6                	ld	s7,104(sp)
    45dc:	7c06                	ld	s8,96(sp)
    45de:	6ce6                	ld	s9,88(sp)
    45e0:	6d46                	ld	s10,80(sp)
    45e2:	614d                	addi	sp,sp,176
    45e4:	8082                	ret

00000000000045e6 <bigfile>:
{
    45e6:	7139                	addi	sp,sp,-64
    45e8:	fc06                	sd	ra,56(sp)
    45ea:	f822                	sd	s0,48(sp)
    45ec:	f426                	sd	s1,40(sp)
    45ee:	f04a                	sd	s2,32(sp)
    45f0:	ec4e                	sd	s3,24(sp)
    45f2:	e852                	sd	s4,16(sp)
    45f4:	e456                	sd	s5,8(sp)
    45f6:	e05a                	sd	s6,0(sp)
    45f8:	0080                	addi	s0,sp,64
    45fa:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    45fc:	00004517          	auipc	a0,0x4
    4600:	87450513          	addi	a0,a0,-1932 # 7e70 <malloc+0x2032>
    4604:	368010ef          	jal	596c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4608:	20200593          	li	a1,514
    460c:	00004517          	auipc	a0,0x4
    4610:	86450513          	addi	a0,a0,-1948 # 7e70 <malloc+0x2032>
    4614:	348010ef          	jal	595c <open>
  if (fd < 0) {
    4618:	08054a63          	bltz	a0,46ac <bigfile+0xc6>
    461c:	8a2a                	mv	s4,a0
    461e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4620:	25800913          	li	s2,600
    4624:	00008997          	auipc	s3,0x8
    4628:	6e498993          	addi	s3,s3,1764 # cd08 <buf>
  for (i = 0; i < N; i++) {
    462c:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    462e:	864a                	mv	a2,s2
    4630:	85a6                	mv	a1,s1
    4632:	854e                	mv	a0,s3
    4634:	0be010ef          	jal	56f2 <memset>
    if (write(fd, buf, SZ) != SZ) {
    4638:	864a                	mv	a2,s2
    463a:	85ce                	mv	a1,s3
    463c:	8552                	mv	a0,s4
    463e:	2fe010ef          	jal	593c <write>
    4642:	07251f63          	bne	a0,s2,46c0 <bigfile+0xda>
  for (i = 0; i < N; i++) {
    4646:	2485                	addiw	s1,s1,1
    4648:	ff5493e3          	bne	s1,s5,462e <bigfile+0x48>
  close(fd);
    464c:	8552                	mv	a0,s4
    464e:	2f6010ef          	jal	5944 <close>
  fd = open("bigfile.dat", 0);
    4652:	4581                	li	a1,0
    4654:	00004517          	auipc	a0,0x4
    4658:	81c50513          	addi	a0,a0,-2020 # 7e70 <malloc+0x2032>
    465c:	300010ef          	jal	595c <open>
    4660:	8aaa                	mv	s5,a0
  total = 0;
    4662:	4a01                	li	s4,0
  for (i = 0;; i++) {
    4664:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4666:	12c00993          	li	s3,300
    466a:	00008917          	auipc	s2,0x8
    466e:	69e90913          	addi	s2,s2,1694 # cd08 <buf>
  if (fd < 0) {
    4672:	06054163          	bltz	a0,46d4 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    4676:	864e                	mv	a2,s3
    4678:	85ca                	mv	a1,s2
    467a:	8556                	mv	a0,s5
    467c:	2b8010ef          	jal	5934 <read>
    if (cc < 0) {
    4680:	06054463          	bltz	a0,46e8 <bigfile+0x102>
    if (cc == 0)
    4684:	c145                	beqz	a0,4724 <bigfile+0x13e>
    if (cc != SZ / 2) {
    4686:	07351b63          	bne	a0,s3,46fc <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    468a:	01f4d79b          	srliw	a5,s1,0x1f
    468e:	9fa5                	addw	a5,a5,s1
    4690:	4017d79b          	sraiw	a5,a5,0x1
    4694:	00094703          	lbu	a4,0(s2)
    4698:	06f71c63          	bne	a4,a5,4710 <bigfile+0x12a>
    469c:	12b94703          	lbu	a4,299(s2)
    46a0:	06f71863          	bne	a4,a5,4710 <bigfile+0x12a>
    total += cc;
    46a4:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    46a8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    46aa:	b7f1                	j	4676 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    46ac:	85da                	mv	a1,s6
    46ae:	00003517          	auipc	a0,0x3
    46b2:	7d250513          	addi	a0,a0,2002 # 7e80 <malloc+0x2042>
    46b6:	6cc010ef          	jal	5d82 <printf>
    exit(1);
    46ba:	4505                	li	a0,1
    46bc:	260010ef          	jal	591c <exit>
      printf("%s: write bigfile failed\n", s);
    46c0:	85da                	mv	a1,s6
    46c2:	00003517          	auipc	a0,0x3
    46c6:	7de50513          	addi	a0,a0,2014 # 7ea0 <malloc+0x2062>
    46ca:	6b8010ef          	jal	5d82 <printf>
      exit(1);
    46ce:	4505                	li	a0,1
    46d0:	24c010ef          	jal	591c <exit>
    printf("%s: cannot open bigfile\n", s);
    46d4:	85da                	mv	a1,s6
    46d6:	00003517          	auipc	a0,0x3
    46da:	7ea50513          	addi	a0,a0,2026 # 7ec0 <malloc+0x2082>
    46de:	6a4010ef          	jal	5d82 <printf>
    exit(1);
    46e2:	4505                	li	a0,1
    46e4:	238010ef          	jal	591c <exit>
      printf("%s: read bigfile failed\n", s);
    46e8:	85da                	mv	a1,s6
    46ea:	00003517          	auipc	a0,0x3
    46ee:	7f650513          	addi	a0,a0,2038 # 7ee0 <malloc+0x20a2>
    46f2:	690010ef          	jal	5d82 <printf>
      exit(1);
    46f6:	4505                	li	a0,1
    46f8:	224010ef          	jal	591c <exit>
      printf("%s: short read bigfile\n", s);
    46fc:	85da                	mv	a1,s6
    46fe:	00004517          	auipc	a0,0x4
    4702:	80250513          	addi	a0,a0,-2046 # 7f00 <malloc+0x20c2>
    4706:	67c010ef          	jal	5d82 <printf>
      exit(1);
    470a:	4505                	li	a0,1
    470c:	210010ef          	jal	591c <exit>
      printf("%s: read bigfile wrong data\n", s);
    4710:	85da                	mv	a1,s6
    4712:	00004517          	auipc	a0,0x4
    4716:	80650513          	addi	a0,a0,-2042 # 7f18 <malloc+0x20da>
    471a:	668010ef          	jal	5d82 <printf>
      exit(1);
    471e:	4505                	li	a0,1
    4720:	1fc010ef          	jal	591c <exit>
  close(fd);
    4724:	8556                	mv	a0,s5
    4726:	21e010ef          	jal	5944 <close>
  if (total != N * SZ) {
    472a:	678d                	lui	a5,0x3
    472c:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x35a>
    4730:	02fa1263          	bne	s4,a5,4754 <bigfile+0x16e>
  unlink("bigfile.dat");
    4734:	00003517          	auipc	a0,0x3
    4738:	73c50513          	addi	a0,a0,1852 # 7e70 <malloc+0x2032>
    473c:	230010ef          	jal	596c <unlink>
}
    4740:	70e2                	ld	ra,56(sp)
    4742:	7442                	ld	s0,48(sp)
    4744:	74a2                	ld	s1,40(sp)
    4746:	7902                	ld	s2,32(sp)
    4748:	69e2                	ld	s3,24(sp)
    474a:	6a42                	ld	s4,16(sp)
    474c:	6aa2                	ld	s5,8(sp)
    474e:	6b02                	ld	s6,0(sp)
    4750:	6121                	addi	sp,sp,64
    4752:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4754:	85da                	mv	a1,s6
    4756:	00003517          	auipc	a0,0x3
    475a:	7e250513          	addi	a0,a0,2018 # 7f38 <malloc+0x20fa>
    475e:	624010ef          	jal	5d82 <printf>
    exit(1);
    4762:	4505                	li	a0,1
    4764:	1b8010ef          	jal	591c <exit>

0000000000004768 <bigargtest>:
{
    4768:	7121                	addi	sp,sp,-448
    476a:	ff06                	sd	ra,440(sp)
    476c:	fb22                	sd	s0,432(sp)
    476e:	f726                	sd	s1,424(sp)
    4770:	0380                	addi	s0,sp,448
    4772:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4774:	00003517          	auipc	a0,0x3
    4778:	7e450513          	addi	a0,a0,2020 # 7f58 <malloc+0x211a>
    477c:	1f0010ef          	jal	596c <unlink>
  pid = fork();
    4780:	194010ef          	jal	5914 <fork>
  if (pid == 0) {
    4784:	c915                	beqz	a0,47b8 <bigargtest+0x50>
  } else if (pid < 0) {
    4786:	08054c63          	bltz	a0,481e <bigargtest+0xb6>
  wait(&xstatus);
    478a:	fdc40513          	addi	a0,s0,-36
    478e:	196010ef          	jal	5924 <wait>
  if (xstatus != 0)
    4792:	fdc42503          	lw	a0,-36(s0)
    4796:	ed51                	bnez	a0,4832 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4798:	4581                	li	a1,0
    479a:	00003517          	auipc	a0,0x3
    479e:	7be50513          	addi	a0,a0,1982 # 7f58 <malloc+0x211a>
    47a2:	1ba010ef          	jal	595c <open>
  if (fd < 0) {
    47a6:	08054863          	bltz	a0,4836 <bigargtest+0xce>
  close(fd);
    47aa:	19a010ef          	jal	5944 <close>
}
    47ae:	70fa                	ld	ra,440(sp)
    47b0:	745a                	ld	s0,432(sp)
    47b2:	74ba                	ld	s1,424(sp)
    47b4:	6139                	addi	sp,sp,448
    47b6:	8082                	ret
    memset(big, ' ', sizeof(big));
    47b8:	19000613          	li	a2,400
    47bc:	02000593          	li	a1,32
    47c0:	e4840513          	addi	a0,s0,-440
    47c4:	72f000ef          	jal	56f2 <memset>
    big[sizeof(big) - 1] = '\0';
    47c8:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    47cc:	00005797          	auipc	a5,0x5
    47d0:	d2478793          	addi	a5,a5,-732 # 94f0 <args.1>
    47d4:	00005697          	auipc	a3,0x5
    47d8:	e1468693          	addi	a3,a3,-492 # 95e8 <args.1+0xf8>
      args[i] = big;
    47dc:	e4840713          	addi	a4,s0,-440
    47e0:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    47e2:	07a1                	addi	a5,a5,8
    47e4:	fed79ee3          	bne	a5,a3,47e0 <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    47e8:	00005797          	auipc	a5,0x5
    47ec:	e007b023          	sd	zero,-512(a5) # 95e8 <args.1+0xf8>
    exec("echo", args);
    47f0:	00005597          	auipc	a1,0x5
    47f4:	d0058593          	addi	a1,a1,-768 # 94f0 <args.1>
    47f8:	00001517          	auipc	a0,0x1
    47fc:	77050513          	addi	a0,a0,1904 # 5f68 <malloc+0x12a>
    4800:	154010ef          	jal	5954 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4804:	20000593          	li	a1,512
    4808:	00003517          	auipc	a0,0x3
    480c:	75050513          	addi	a0,a0,1872 # 7f58 <malloc+0x211a>
    4810:	14c010ef          	jal	595c <open>
    close(fd);
    4814:	130010ef          	jal	5944 <close>
    exit(0);
    4818:	4501                	li	a0,0
    481a:	102010ef          	jal	591c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    481e:	85a6                	mv	a1,s1
    4820:	00003517          	auipc	a0,0x3
    4824:	74850513          	addi	a0,a0,1864 # 7f68 <malloc+0x212a>
    4828:	55a010ef          	jal	5d82 <printf>
    exit(1);
    482c:	4505                	li	a0,1
    482e:	0ee010ef          	jal	591c <exit>
    exit(xstatus);
    4832:	0ea010ef          	jal	591c <exit>
    printf("%s: bigarg test failed!\n", s);
    4836:	85a6                	mv	a1,s1
    4838:	00003517          	auipc	a0,0x3
    483c:	75050513          	addi	a0,a0,1872 # 7f88 <malloc+0x214a>
    4840:	542010ef          	jal	5d82 <printf>
    exit(1);
    4844:	4505                	li	a0,1
    4846:	0d6010ef          	jal	591c <exit>

000000000000484a <partial_write>:
{
    484a:	bb010113          	addi	sp,sp,-1104
    484e:	44113423          	sd	ra,1096(sp)
    4852:	44813023          	sd	s0,1088(sp)
    4856:	42913c23          	sd	s1,1080(sp)
    485a:	43213823          	sd	s2,1072(sp)
    485e:	43313423          	sd	s3,1064(sp)
    4862:	43413023          	sd	s4,1056(sp)
    4866:	41513c23          	sd	s5,1048(sp)
    486a:	45010413          	addi	s0,sp,1104
    486e:	8aaa                	mv	s5,a0
  unlink("testfile");
    4870:	00003517          	auipc	a0,0x3
    4874:	73850513          	addi	a0,a0,1848 # 7fa8 <malloc+0x216a>
    4878:	0f4010ef          	jal	596c <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    487c:	20200593          	li	a1,514
    4880:	00003517          	auipc	a0,0x3
    4884:	72850513          	addi	a0,a0,1832 # 7fa8 <malloc+0x216a>
    4888:	0d4010ef          	jal	595c <open>
  if (fd < 0) {
    488c:	14054f63          	bltz	a0,49ea <partial_write+0x1a0>
    4890:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    4892:	4605                	li	a2,1
    4894:	00003597          	auipc	a1,0x3
    4898:	74458593          	addi	a1,a1,1860 # 7fd8 <malloc+0x219a>
    489c:	0a0010ef          	jal	593c <write>
  if (cc != 1) {
    48a0:	4785                	li	a5,1
    48a2:	14f51e63          	bne	a0,a5,49fe <partial_write+0x1b4>
  close(fd);
    48a6:	8526                	mv	a0,s1
    48a8:	09c010ef          	jal	5944 <close>
  fd = open("testfile", O_RDWR);
    48ac:	4589                	li	a1,2
    48ae:	00003517          	auipc	a0,0x3
    48b2:	6fa50513          	addi	a0,a0,1786 # 7fa8 <malloc+0x216a>
    48b6:	0a6010ef          	jal	595c <open>
    48ba:	84aa                	mv	s1,a0
  if (fd < 0) {
    48bc:	14054b63          	bltz	a0,4a12 <partial_write+0x1c8>
  char *p = sbrk(0);
    48c0:	4501                	li	a0,0
    48c2:	026010ef          	jal	58e8 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    48c6:	03451793          	slli	a5,a0,0x34
    48ca:	93d1                	srli	a5,a5,0x34
    48cc:	6505                	lui	a0,0x1
    48ce:	9d1d                	subw	a0,a0,a5
    48d0:	018010ef          	jal	58e8 <sbrk>
  p = sbrk(0);
    48d4:	4501                	li	a0,0
    48d6:	012010ef          	jal	58e8 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    48da:	03451793          	slli	a5,a0,0x34
    48de:	14079463          	bnez	a5,4a26 <partial_write+0x1dc>
  p[-1] = 'X';
    48e2:	05800793          	li	a5,88
    48e6:	fef50fa3          	sb	a5,-1(a0) # fff <bigdir+0x10b>
  cc = write(fd, p - 1, 2);
    48ea:	4609                	li	a2,2
    48ec:	fff50593          	addi	a1,a0,-1
    48f0:	8526                	mv	a0,s1
    48f2:	04a010ef          	jal	593c <write>
  if (cc != -1) {
    48f6:	57fd                	li	a5,-1
    48f8:	14f51163          	bne	a0,a5,4a3a <partial_write+0x1f0>
  close(fd);
    48fc:	8526                	mv	a0,s1
    48fe:	046010ef          	jal	5944 <close>
  fd = open("testfile", O_RDONLY);
    4902:	4581                	li	a1,0
    4904:	00003517          	auipc	a0,0x3
    4908:	6a450513          	addi	a0,a0,1700 # 7fa8 <malloc+0x216a>
    490c:	050010ef          	jal	595c <open>
    4910:	84aa                	mv	s1,a0
  if (fd < 0) {
    4912:	12054e63          	bltz	a0,4a4e <partial_write+0x204>
  cc = read(fd, &b, 1);
    4916:	4605                	li	a2,1
    4918:	fbf40593          	addi	a1,s0,-65
    491c:	018010ef          	jal	5934 <read>
  if (cc != 1) {
    4920:	4785                	li	a5,1
    4922:	14f51063          	bne	a0,a5,4a62 <partial_write+0x218>
  close(fd);
    4926:	8526                	mv	a0,s1
    4928:	01c010ef          	jal	5944 <close>
  if (b != 'X') {
    492c:	fbf44603          	lbu	a2,-65(s0)
    4930:	05800793          	li	a5,88
    4934:	14f61163          	bne	a2,a5,4a76 <partial_write+0x22c>
  fd = open("bigfile", O_CREATE | O_RDWR);
    4938:	20200593          	li	a1,514
    493c:	00003517          	auipc	a0,0x3
    4940:	76c50513          	addi	a0,a0,1900 # 80a8 <malloc+0x226a>
    4944:	018010ef          	jal	595c <open>
    4948:	8a2a                	mv	s4,a0
    494a:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    494e:	bb840993          	addi	s3,s0,-1096
    4952:	40000493          	li	s1,1024
    4956:	8626                	mv	a2,s1
    4958:	4581                	li	a1,0
    495a:	854e                	mv	a0,s3
    495c:	597000ef          	jal	56f2 <memset>
    cc = write(fd, buf, sizeof(buf));
    4960:	8626                	mv	a2,s1
    4962:	85ce                	mv	a1,s3
    4964:	8552                	mv	a0,s4
    4966:	7d7000ef          	jal	593c <write>
    if (cc != sizeof(buf)) {
    496a:	12951063          	bne	a0,s1,4a8a <partial_write+0x240>
  for (int i = 0; i < 64; i++) {
    496e:	397d                	addiw	s2,s2,-1
    4970:	fe0913e3          	bnez	s2,4956 <partial_write+0x10c>
  close(fd);
    4974:	8552                	mv	a0,s4
    4976:	7cf000ef          	jal	5944 <close>
  unlink("bigfile");
    497a:	00003517          	auipc	a0,0x3
    497e:	72e50513          	addi	a0,a0,1838 # 80a8 <malloc+0x226a>
    4982:	7eb000ef          	jal	596c <unlink>
  fd = open("testfile", O_RDONLY);
    4986:	4581                	li	a1,0
    4988:	00003517          	auipc	a0,0x3
    498c:	62050513          	addi	a0,a0,1568 # 7fa8 <malloc+0x216a>
    4990:	7cd000ef          	jal	595c <open>
    4994:	84aa                	mv	s1,a0
  if (fd < 0) {
    4996:	10054463          	bltz	a0,4a9e <partial_write+0x254>
  cc = read(fd, &b, 1);
    499a:	4605                	li	a2,1
    499c:	fbf40593          	addi	a1,s0,-65
    49a0:	795000ef          	jal	5934 <read>
  if (cc != 1) {
    49a4:	4785                	li	a5,1
    49a6:	10f51663          	bne	a0,a5,4ab2 <partial_write+0x268>
  close(fd);
    49aa:	8526                	mv	a0,s1
    49ac:	799000ef          	jal	5944 <close>
  if (b != 'X') {
    49b0:	fbf44603          	lbu	a2,-65(s0)
    49b4:	05800793          	li	a5,88
    49b8:	10f61763          	bne	a2,a5,4ac6 <partial_write+0x27c>
  unlink("testfile");
    49bc:	00003517          	auipc	a0,0x3
    49c0:	5ec50513          	addi	a0,a0,1516 # 7fa8 <malloc+0x216a>
    49c4:	7a9000ef          	jal	596c <unlink>
}
    49c8:	44813083          	ld	ra,1096(sp)
    49cc:	44013403          	ld	s0,1088(sp)
    49d0:	43813483          	ld	s1,1080(sp)
    49d4:	43013903          	ld	s2,1072(sp)
    49d8:	42813983          	ld	s3,1064(sp)
    49dc:	42013a03          	ld	s4,1056(sp)
    49e0:	41813a83          	ld	s5,1048(sp)
    49e4:	45010113          	addi	sp,sp,1104
    49e8:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    49ea:	85d6                	mv	a1,s5
    49ec:	00003517          	auipc	a0,0x3
    49f0:	5cc50513          	addi	a0,a0,1484 # 7fb8 <malloc+0x217a>
    49f4:	38e010ef          	jal	5d82 <printf>
    exit(1);
    49f8:	4505                	li	a0,1
    49fa:	723000ef          	jal	591c <exit>
    printf("%s: could not write A\n", s);
    49fe:	85d6                	mv	a1,s5
    4a00:	00003517          	auipc	a0,0x3
    4a04:	5e050513          	addi	a0,a0,1504 # 7fe0 <malloc+0x21a2>
    4a08:	37a010ef          	jal	5d82 <printf>
    exit(1);
    4a0c:	4505                	li	a0,1
    4a0e:	70f000ef          	jal	591c <exit>
    printf("%s: cannot re-open testfile\n", s);
    4a12:	85d6                	mv	a1,s5
    4a14:	00003517          	auipc	a0,0x3
    4a18:	5e450513          	addi	a0,a0,1508 # 7ff8 <malloc+0x21ba>
    4a1c:	366010ef          	jal	5d82 <printf>
    exit(1);
    4a20:	4505                	li	a0,1
    4a22:	6fb000ef          	jal	591c <exit>
    printf("%s: sbrk did not align\n", s);
    4a26:	85d6                	mv	a1,s5
    4a28:	00003517          	auipc	a0,0x3
    4a2c:	5f050513          	addi	a0,a0,1520 # 8018 <malloc+0x21da>
    4a30:	352010ef          	jal	5d82 <printf>
    exit(1);
    4a34:	4505                	li	a0,1
    4a36:	6e7000ef          	jal	591c <exit>
    printf("%s: write succeeded, should have failed\n", s);
    4a3a:	85d6                	mv	a1,s5
    4a3c:	00003517          	auipc	a0,0x3
    4a40:	5f450513          	addi	a0,a0,1524 # 8030 <malloc+0x21f2>
    4a44:	33e010ef          	jal	5d82 <printf>
    exit(1);
    4a48:	4505                	li	a0,1
    4a4a:	6d3000ef          	jal	591c <exit>
    printf("%s: cannot re-open testfile\n", s);
    4a4e:	85d6                	mv	a1,s5
    4a50:	00003517          	auipc	a0,0x3
    4a54:	5a850513          	addi	a0,a0,1448 # 7ff8 <malloc+0x21ba>
    4a58:	32a010ef          	jal	5d82 <printf>
    exit(1);
    4a5c:	4505                	li	a0,1
    4a5e:	6bf000ef          	jal	591c <exit>
    printf("%s: cannot read testfile\n", s);
    4a62:	85d6                	mv	a1,s5
    4a64:	00003517          	auipc	a0,0x3
    4a68:	5fc50513          	addi	a0,a0,1532 # 8060 <malloc+0x2222>
    4a6c:	316010ef          	jal	5d82 <printf>
    exit(1);
    4a70:	4505                	li	a0,1
    4a72:	6ab000ef          	jal	591c <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4a76:	85d6                	mv	a1,s5
    4a78:	00003517          	auipc	a0,0x3
    4a7c:	60850513          	addi	a0,a0,1544 # 8080 <malloc+0x2242>
    4a80:	302010ef          	jal	5d82 <printf>
    exit(1);
    4a84:	4505                	li	a0,1
    4a86:	697000ef          	jal	591c <exit>
      printf("%s: could not write to bigfile\n", s);
    4a8a:	85d6                	mv	a1,s5
    4a8c:	00003517          	auipc	a0,0x3
    4a90:	62450513          	addi	a0,a0,1572 # 80b0 <malloc+0x2272>
    4a94:	2ee010ef          	jal	5d82 <printf>
      exit(-1);
    4a98:	557d                	li	a0,-1
    4a9a:	683000ef          	jal	591c <exit>
    printf("%s: cannot re-open testfile\n", s);
    4a9e:	85d6                	mv	a1,s5
    4aa0:	00003517          	auipc	a0,0x3
    4aa4:	55850513          	addi	a0,a0,1368 # 7ff8 <malloc+0x21ba>
    4aa8:	2da010ef          	jal	5d82 <printf>
    exit(1);
    4aac:	4505                	li	a0,1
    4aae:	66f000ef          	jal	591c <exit>
    printf("%s: cannot read testfile\n", s);
    4ab2:	85d6                	mv	a1,s5
    4ab4:	00003517          	auipc	a0,0x3
    4ab8:	5ac50513          	addi	a0,a0,1452 # 8060 <malloc+0x2222>
    4abc:	2c6010ef          	jal	5d82 <printf>
    exit(1);
    4ac0:	4505                	li	a0,1
    4ac2:	65b000ef          	jal	591c <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4ac6:	85d6                	mv	a1,s5
    4ac8:	00003517          	auipc	a0,0x3
    4acc:	5b850513          	addi	a0,a0,1464 # 8080 <malloc+0x2242>
    4ad0:	2b2010ef          	jal	5d82 <printf>
    exit(1);
    4ad4:	4505                	li	a0,1
    4ad6:	647000ef          	jal	591c <exit>

0000000000004ada <lazy_alloc>:
{
    4ada:	1141                	addi	sp,sp,-16
    4adc:	e406                	sd	ra,8(sp)
    4ade:	e022                	sd	s0,0(sp)
    4ae0:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4ae2:	40000537          	lui	a0,0x40000
    4ae6:	619000ef          	jal	58fe <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4aea:	57fd                	li	a5,-1
    4aec:	02f50a63          	beq	a0,a5,4b20 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4af0:	6605                	lui	a2,0x1
    4af2:	962a                	add	a2,a2,a0
    4af4:	400017b7          	lui	a5,0x40001
    4af8:	00f50733          	add	a4,a0,a5
    4afc:	87b2                	mv	a5,a2
    4afe:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4b02:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4b04:	97b6                	add	a5,a5,a3
    4b06:	fee79ee3          	bne	a5,a4,4b02 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4b0a:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4b0e:	621c                	ld	a5,0(a2)
    4b10:	02c79163          	bne	a5,a2,4b32 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4b14:	9636                	add	a2,a2,a3
    4b16:	fee61ce3          	bne	a2,a4,4b0e <lazy_alloc+0x34>
  exit(0);
    4b1a:	4501                	li	a0,0
    4b1c:	601000ef          	jal	591c <exit>
    printf("sbrklazy() failed\n");
    4b20:	00003517          	auipc	a0,0x3
    4b24:	5b050513          	addi	a0,a0,1456 # 80d0 <malloc+0x2292>
    4b28:	25a010ef          	jal	5d82 <printf>
    exit(1);
    4b2c:	4505                	li	a0,1
    4b2e:	5ef000ef          	jal	591c <exit>
      printf("failed to read value from memory\n");
    4b32:	00003517          	auipc	a0,0x3
    4b36:	5b650513          	addi	a0,a0,1462 # 80e8 <malloc+0x22aa>
    4b3a:	248010ef          	jal	5d82 <printf>
      exit(1);
    4b3e:	4505                	li	a0,1
    4b40:	5dd000ef          	jal	591c <exit>

0000000000004b44 <lazy_unmap>:
{
    4b44:	7139                	addi	sp,sp,-64
    4b46:	fc06                	sd	ra,56(sp)
    4b48:	f822                	sd	s0,48(sp)
    4b4a:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    4b4c:	40000537          	lui	a0,0x40000
    4b50:	5af000ef          	jal	58fe <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4b54:	57fd                	li	a5,-1
    4b56:	04f50863          	beq	a0,a5,4ba6 <lazy_unmap+0x62>
    4b5a:	f426                	sd	s1,40(sp)
    4b5c:	f04a                	sd	s2,32(sp)
    4b5e:	ec4e                	sd	s3,24(sp)
    4b60:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4b62:	6905                	lui	s2,0x1
    4b64:	992a                	add	s2,s2,a0
    4b66:	400017b7          	lui	a5,0x40001
    4b6a:	00f504b3          	add	s1,a0,a5
    4b6e:	87ca                	mv	a5,s2
    4b70:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4b74:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4b76:	97ba                	add	a5,a5,a4
    4b78:	fe979ee3          	bne	a5,s1,4b74 <lazy_unmap+0x30>
      wait(&status);
    4b7c:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4b80:	01000a37          	lui	s4,0x1000
    pid = fork();
    4b84:	591000ef          	jal	5914 <fork>
    if (pid < 0) {
    4b88:	02054c63          	bltz	a0,4bc0 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    4b8c:	c139                	beqz	a0,4bd2 <lazy_unmap+0x8e>
      wait(&status);
    4b8e:	854e                	mv	a0,s3
    4b90:	595000ef          	jal	5924 <wait>
      if (status == 0) {
    4b94:	fcc42783          	lw	a5,-52(s0)
    4b98:	c7b1                	beqz	a5,4be4 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4b9a:	9952                	add	s2,s2,s4
    4b9c:	fe9914e3          	bne	s2,s1,4b84 <lazy_unmap+0x40>
  exit(0);
    4ba0:	4501                	li	a0,0
    4ba2:	57b000ef          	jal	591c <exit>
    4ba6:	f426                	sd	s1,40(sp)
    4ba8:	f04a                	sd	s2,32(sp)
    4baa:	ec4e                	sd	s3,24(sp)
    4bac:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    4bae:	00003517          	auipc	a0,0x3
    4bb2:	52250513          	addi	a0,a0,1314 # 80d0 <malloc+0x2292>
    4bb6:	1cc010ef          	jal	5d82 <printf>
    exit(1);
    4bba:	4505                	li	a0,1
    4bbc:	561000ef          	jal	591c <exit>
      printf("error forking\n");
    4bc0:	00003517          	auipc	a0,0x3
    4bc4:	55050513          	addi	a0,a0,1360 # 8110 <malloc+0x22d2>
    4bc8:	1ba010ef          	jal	5d82 <printf>
      exit(1);
    4bcc:	4505                	li	a0,1
    4bce:	54f000ef          	jal	591c <exit>
      sbrklazy(-1L * REGION_SZ);
    4bd2:	c0000537          	lui	a0,0xc0000
    4bd6:	529000ef          	jal	58fe <sbrklazy>
      *(char **)i = i;
    4bda:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    4bde:	4501                	li	a0,0
    4be0:	53d000ef          	jal	591c <exit>
        printf("memory not unmapped\n");
    4be4:	00003517          	auipc	a0,0x3
    4be8:	53c50513          	addi	a0,a0,1340 # 8120 <malloc+0x22e2>
    4bec:	196010ef          	jal	5d82 <printf>
        exit(1);
    4bf0:	4505                	li	a0,1
    4bf2:	52b000ef          	jal	591c <exit>

0000000000004bf6 <lazy_copy>:
{
    4bf6:	7119                	addi	sp,sp,-128
    4bf8:	fc86                	sd	ra,120(sp)
    4bfa:	f8a2                	sd	s0,112(sp)
    4bfc:	f4a6                	sd	s1,104(sp)
    4bfe:	f0ca                	sd	s2,96(sp)
    4c00:	ecce                	sd	s3,88(sp)
    4c02:	e8d2                	sd	s4,80(sp)
    4c04:	e4d6                	sd	s5,72(sp)
    4c06:	e0da                	sd	s6,64(sp)
    4c08:	fc5e                	sd	s7,56(sp)
    4c0a:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4c0c:	4501                	li	a0,0
    4c0e:	4db000ef          	jal	58e8 <sbrk>
    4c12:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4c14:	6511                	lui	a0,0x4
    4c16:	4e9000ef          	jal	58fe <sbrklazy>
    open(p + 8192, 0);
    4c1a:	4581                	li	a1,0
    4c1c:	6509                	lui	a0,0x2
    4c1e:	9526                	add	a0,a0,s1
    4c20:	53d000ef          	jal	595c <open>
    void *xx = sbrk(0);
    4c24:	4501                	li	a0,0
    4c26:	4c3000ef          	jal	58e8 <sbrk>
    4c2a:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4c2c:	fff54513          	not	a0,a0
    4c30:	2501                	sext.w	a0,a0
    4c32:	4b7000ef          	jal	58e8 <sbrk>
    if (ret != xx) {
    4c36:	00a48c63          	beq	s1,a0,4c4e <lazy_copy+0x58>
    4c3a:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4c3c:	00003517          	auipc	a0,0x3
    4c40:	4fc50513          	addi	a0,a0,1276 # 8138 <malloc+0x22fa>
    4c44:	13e010ef          	jal	5d82 <printf>
      exit(1);
    4c48:	4505                	li	a0,1
    4c4a:	4d3000ef          	jal	591c <exit>
  unsigned long bad[] = {
    4c4e:	00004797          	auipc	a5,0x4
    4c52:	cd278793          	addi	a5,a5,-814 # 8920 <malloc+0x2ae2>
    4c56:	7fa8                	ld	a0,120(a5)
    4c58:	63cc                	ld	a1,128(a5)
    4c5a:	67d0                	ld	a2,136(a5)
    4c5c:	6bd4                	ld	a3,144(a5)
    4c5e:	6fd8                	ld	a4,152(a5)
    4c60:	f8a43023          	sd	a0,-128(s0)
    4c64:	f8b43423          	sd	a1,-120(s0)
    4c68:	f8c43823          	sd	a2,-112(s0)
    4c6c:	f8d43c23          	sd	a3,-104(s0)
    4c70:	fae43023          	sd	a4,-96(s0)
    4c74:	73dc                	ld	a5,160(a5)
    4c76:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4c7a:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4c7e:	00001a97          	auipc	s5,0x1
    4c82:	4c2a8a93          	addi	s5,s5,1218 # 6140 <malloc+0x302>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4c86:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4c8a:	60200b93          	li	s7,1538
    4c8e:	00001b17          	auipc	s6,0x1
    4c92:	3c2b0b13          	addi	s6,s6,962 # 6050 <malloc+0x212>
    int fd = open("README", 0);
    4c96:	4581                	li	a1,0
    4c98:	8556                	mv	a0,s5
    4c9a:	4c3000ef          	jal	595c <open>
    4c9e:	84aa                	mv	s1,a0
    if (fd < 0) {
    4ca0:	04054563          	bltz	a0,4cea <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4ca4:	00093983          	ld	s3,0(s2)
    4ca8:	8652                	mv	a2,s4
    4caa:	85ce                	mv	a1,s3
    4cac:	489000ef          	jal	5934 <read>
    4cb0:	04055663          	bgez	a0,4cfc <lazy_copy+0x106>
    close(fd);
    4cb4:	8526                	mv	a0,s1
    4cb6:	48f000ef          	jal	5944 <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4cba:	85de                	mv	a1,s7
    4cbc:	855a                	mv	a0,s6
    4cbe:	49f000ef          	jal	595c <open>
    4cc2:	84aa                	mv	s1,a0
    if (fd < 0) {
    4cc4:	04054563          	bltz	a0,4d0e <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4cc8:	8652                	mv	a2,s4
    4cca:	85ce                	mv	a1,s3
    4ccc:	471000ef          	jal	593c <write>
    4cd0:	04055863          	bgez	a0,4d20 <lazy_copy+0x12a>
    close(fd);
    4cd4:	8526                	mv	a0,s1
    4cd6:	46f000ef          	jal	5944 <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4cda:	0921                	addi	s2,s2,8
    4cdc:	fb040793          	addi	a5,s0,-80
    4ce0:	faf91be3          	bne	s2,a5,4c96 <lazy_copy+0xa0>
  exit(0);
    4ce4:	4501                	li	a0,0
    4ce6:	437000ef          	jal	591c <exit>
      printf("cannot open README\n");
    4cea:	00003517          	auipc	a0,0x3
    4cee:	47e50513          	addi	a0,a0,1150 # 8168 <malloc+0x232a>
    4cf2:	090010ef          	jal	5d82 <printf>
      exit(1);
    4cf6:	4505                	li	a0,1
    4cf8:	425000ef          	jal	591c <exit>
      printf("read succeeded\n");
    4cfc:	00003517          	auipc	a0,0x3
    4d00:	48450513          	addi	a0,a0,1156 # 8180 <malloc+0x2342>
    4d04:	07e010ef          	jal	5d82 <printf>
      exit(1);
    4d08:	4505                	li	a0,1
    4d0a:	413000ef          	jal	591c <exit>
      printf("cannot open junk\n");
    4d0e:	00003517          	auipc	a0,0x3
    4d12:	48250513          	addi	a0,a0,1154 # 8190 <malloc+0x2352>
    4d16:	06c010ef          	jal	5d82 <printf>
      exit(1);
    4d1a:	4505                	li	a0,1
    4d1c:	401000ef          	jal	591c <exit>
      printf("write succeeded\n");
    4d20:	00003517          	auipc	a0,0x3
    4d24:	48850513          	addi	a0,a0,1160 # 81a8 <malloc+0x236a>
    4d28:	05a010ef          	jal	5d82 <printf>
      exit(1);
    4d2c:	4505                	li	a0,1
    4d2e:	3ef000ef          	jal	591c <exit>

0000000000004d32 <lazy_sbrk>:
{
    4d32:	7179                	addi	sp,sp,-48
    4d34:	f406                	sd	ra,40(sp)
    4d36:	f022                	sd	s0,32(sp)
    4d38:	ec26                	sd	s1,24(sp)
    4d3a:	e84a                	sd	s2,16(sp)
    4d3c:	e44e                	sd	s3,8(sp)
    4d3e:	e052                	sd	s4,0(sp)
    4d40:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4d42:	4501                	li	a0,0
    4d44:	3a5000ef          	jal	58e8 <sbrk>
    4d48:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4d4a:	0ff00793          	li	a5,255
    4d4e:	07fa                	slli	a5,a5,0x1e
    4d50:	02f57163          	bgeu	a0,a5,4d72 <lazy_sbrk+0x40>
    p = sbrklazy(1 << 30);
    4d54:	40000a37          	lui	s4,0x40000
    if (p == SBRK_ERROR) {
    4d58:	59fd                	li	s3,-1
  while ((uint64)p < MAXVA - (1 << 30)) {
    4d5a:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4d5c:	8552                	mv	a0,s4
    4d5e:	3a1000ef          	jal	58fe <sbrklazy>
    if (p == SBRK_ERROR) {
    4d62:	05350763          	beq	a0,s3,4db0 <lazy_sbrk+0x7e>
    p = sbrklazy(0);
    4d66:	4501                	li	a0,0
    4d68:	397000ef          	jal	58fe <sbrklazy>
    4d6c:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4d6e:	ff2567e3          	bltu	a0,s2,4d5c <lazy_sbrk+0x2a>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4d72:	7975                	lui	s2,0xffffd
    4d74:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4d78:	854a                	mv	a0,s2
    4d7a:	385000ef          	jal	58fe <sbrklazy>
  if (p1 == SBRK_ERROR || p1 != p) {
    4d7e:	00150793          	addi	a5,a0,1
    4d82:	c3b9                	beqz	a5,4dc8 <lazy_sbrk+0x96>
    4d84:	04951263          	bne	a0,s1,4dc8 <lazy_sbrk+0x96>
  p = sbrk(PGSIZE);
    4d88:	6505                	lui	a0,0x1
    4d8a:	35f000ef          	jal	58e8 <sbrk>
    4d8e:	862a                	mv	a2,a0
  if (p == SBRK_ERROR || (uint64)p != TRAPFRAME - PGSIZE) {
    4d90:	040007b7          	lui	a5,0x4000
    4d94:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff02f5>
    4d96:	07b2                	slli	a5,a5,0xc
    4d98:	04f50463          	beq	a0,a5,4de0 <lazy_sbrk+0xae>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4d9c:	6585                	lui	a1,0x1
    4d9e:	00003517          	auipc	a0,0x3
    4da2:	47250513          	addi	a0,a0,1138 # 8210 <malloc+0x23d2>
    4da6:	7dd000ef          	jal	5d82 <printf>
    exit(1);
    4daa:	4505                	li	a0,1
    4dac:	371000ef          	jal	591c <exit>
      printf("sbrklazy(%d) returned %p\n", 1 << 30, p);
    4db0:	567d                	li	a2,-1
    4db2:	400005b7          	lui	a1,0x40000
    4db6:	00003517          	auipc	a0,0x3
    4dba:	40a50513          	addi	a0,a0,1034 # 81c0 <malloc+0x2382>
    4dbe:	7c5000ef          	jal	5d82 <printf>
      exit(1);
    4dc2:	4505                	li	a0,1
    4dc4:	359000ef          	jal	591c <exit>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4dc8:	86a6                	mv	a3,s1
    4dca:	862a                	mv	a2,a0
    4dcc:	85ca                	mv	a1,s2
    4dce:	00003517          	auipc	a0,0x3
    4dd2:	41250513          	addi	a0,a0,1042 # 81e0 <malloc+0x23a2>
    4dd6:	7ad000ef          	jal	5d82 <printf>
    exit(1);
    4dda:	4505                	li	a0,1
    4ddc:	341000ef          	jal	591c <exit>
  p[0] = 1;
    4de0:	040007b7          	lui	a5,0x4000
    4de4:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff02f5>
    4de6:	07b2                	slli	a5,a5,0xc
    4de8:	4705                	li	a4,1
    4dea:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4dee:	0017c783          	lbu	a5,1(a5)
    4df2:	cb91                	beqz	a5,4e06 <lazy_sbrk+0xd4>
    printf("sbrk() returned non-zero-filled memory\n");
    4df4:	00003517          	auipc	a0,0x3
    4df8:	45450513          	addi	a0,a0,1108 # 8248 <malloc+0x240a>
    4dfc:	787000ef          	jal	5d82 <printf>
    exit(1);
    4e00:	4505                	li	a0,1
    4e02:	31b000ef          	jal	591c <exit>
  p = sbrk(1);
    4e06:	4505                	li	a0,1
    4e08:	2e1000ef          	jal	58e8 <sbrk>
    4e0c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4e0e:	57fd                	li	a5,-1
    4e10:	00f50b63          	beq	a0,a5,4e26 <lazy_sbrk+0xf4>
    printf("sbrk(1) returned %p, expected error\n", p);
    4e14:	00003517          	auipc	a0,0x3
    4e18:	45c50513          	addi	a0,a0,1116 # 8270 <malloc+0x2432>
    4e1c:	767000ef          	jal	5d82 <printf>
    exit(1);
    4e20:	4505                	li	a0,1
    4e22:	2fb000ef          	jal	591c <exit>
  p = sbrklazy(1);
    4e26:	4505                	li	a0,1
    4e28:	2d7000ef          	jal	58fe <sbrklazy>
    4e2c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4e2e:	57fd                	li	a5,-1
    4e30:	00f50b63          	beq	a0,a5,4e46 <lazy_sbrk+0x114>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4e34:	00003517          	auipc	a0,0x3
    4e38:	46450513          	addi	a0,a0,1124 # 8298 <malloc+0x245a>
    4e3c:	747000ef          	jal	5d82 <printf>
    exit(1);
    4e40:	4505                	li	a0,1
    4e42:	2db000ef          	jal	591c <exit>
  exit(0);
    4e46:	4501                	li	a0,0
    4e48:	2d5000ef          	jal	591c <exit>

0000000000004e4c <lazy_copyinstr>:
{
    4e4c:	7139                	addi	sp,sp,-64
    4e4e:	fc06                	sd	ra,56(sp)
    4e50:	f822                	sd	s0,48(sp)
    4e52:	f426                	sd	s1,40(sp)
    4e54:	f04a                	sd	s2,32(sp)
    4e56:	0080                	addi	s0,sp,64
    4e58:	892a                	mv	s2,a0
  char *p = sbrk(0);
    4e5a:	4501                	li	a0,0
    4e5c:	28d000ef          	jal	58e8 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4e60:	03451793          	slli	a5,a0,0x34
    4e64:	93d1                	srli	a5,a5,0x34
    4e66:	6505                	lui	a0,0x1
    4e68:	9d1d                	subw	a0,a0,a5
    4e6a:	27f000ef          	jal	58e8 <sbrk>
  p = sbrk(0);
    4e6e:	4501                	li	a0,0
    4e70:	279000ef          	jal	58e8 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4e74:	03451793          	slli	a5,a0,0x34
    4e78:	eba1                	bnez	a5,4ec8 <lazy_copyinstr+0x7c>
    4e7a:	84aa                	mv	s1,a0
  sbrklazy(2 * PGSIZE);
    4e7c:	6509                	lui	a0,0x2
    4e7e:	281000ef          	jal	58fe <sbrklazy>
  p[4095] = '/';
    4e82:	6505                	lui	a0,0x1
    4e84:	00a487b3          	add	a5,s1,a0
    4e88:	02f00713          	li	a4,47
    4e8c:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4e90:	157d                	addi	a0,a0,-1 # fff <bigdir+0x10b>
    4e92:	4581                	li	a1,0
    4e94:	9526                	add	a0,a0,s1
    4e96:	2c7000ef          	jal	595c <open>
    4e9a:	84aa                	mv	s1,a0
  if (fd < 0) {
    4e9c:	04054063          	bltz	a0,4edc <lazy_copyinstr+0x90>
  int r = fstat(fd, &st);
    4ea0:	fc840593          	addi	a1,s0,-56
    4ea4:	2d1000ef          	jal	5974 <fstat>
  if (r < 0) {
    4ea8:	04054363          	bltz	a0,4eee <lazy_copyinstr+0xa2>
  if (st.type != T_DIR) {
    4eac:	fd041703          	lh	a4,-48(s0)
    4eb0:	4785                	li	a5,1
    4eb2:	04f71763          	bne	a4,a5,4f00 <lazy_copyinstr+0xb4>
  close(fd);
    4eb6:	8526                	mv	a0,s1
    4eb8:	28d000ef          	jal	5944 <close>
}
    4ebc:	70e2                	ld	ra,56(sp)
    4ebe:	7442                	ld	s0,48(sp)
    4ec0:	74a2                	ld	s1,40(sp)
    4ec2:	7902                	ld	s2,32(sp)
    4ec4:	6121                	addi	sp,sp,64
    4ec6:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4ec8:	85ca                	mv	a1,s2
    4eca:	00003517          	auipc	a0,0x3
    4ece:	14e50513          	addi	a0,a0,334 # 8018 <malloc+0x21da>
    4ed2:	6b1000ef          	jal	5d82 <printf>
    exit(1);
    4ed6:	4505                	li	a0,1
    4ed8:	245000ef          	jal	591c <exit>
    printf("could not open /");
    4edc:	00003517          	auipc	a0,0x3
    4ee0:	3ec50513          	addi	a0,a0,1004 # 82c8 <malloc+0x248a>
    4ee4:	69f000ef          	jal	5d82 <printf>
    exit(1);
    4ee8:	4505                	li	a0,1
    4eea:	233000ef          	jal	591c <exit>
    printf("could not stat /");
    4eee:	00003517          	auipc	a0,0x3
    4ef2:	3f250513          	addi	a0,a0,1010 # 82e0 <malloc+0x24a2>
    4ef6:	68d000ef          	jal	5d82 <printf>
    exit(1);
    4efa:	4505                	li	a0,1
    4efc:	221000ef          	jal	591c <exit>
    printf("/ is not T_DIR");
    4f00:	00003517          	auipc	a0,0x3
    4f04:	3f850513          	addi	a0,a0,1016 # 82f8 <malloc+0x24ba>
    4f08:	67b000ef          	jal	5d82 <printf>
    exit(1);
    4f0c:	4505                	li	a0,1
    4f0e:	20f000ef          	jal	591c <exit>

0000000000004f12 <fsfull>:
{
    4f12:	7131                	addi	sp,sp,-192
    4f14:	fd06                	sd	ra,184(sp)
    4f16:	f922                	sd	s0,176(sp)
    4f18:	f526                	sd	s1,168(sp)
    4f1a:	f14a                	sd	s2,160(sp)
    4f1c:	ed4e                	sd	s3,152(sp)
    4f1e:	e952                	sd	s4,144(sp)
    4f20:	e556                	sd	s5,136(sp)
    4f22:	e15a                	sd	s6,128(sp)
    4f24:	fcde                	sd	s7,120(sp)
    4f26:	f8e2                	sd	s8,112(sp)
    4f28:	f4e6                	sd	s9,104(sp)
    4f2a:	f0ea                	sd	s10,96(sp)
    4f2c:	ecee                	sd	s11,88(sp)
    4f2e:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4f30:	00003517          	auipc	a0,0x3
    4f34:	3d850513          	addi	a0,a0,984 # 8308 <malloc+0x24ca>
    4f38:	64b000ef          	jal	5d82 <printf>
  int fsblocks = 0;
    4f3c:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4f3e:	4481                	li	s1,0
    name[0] = 'f';
    4f40:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4f44:	106257b7          	lui	a5,0x10625
    4f48:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106150cb>
    4f4c:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f50:	51eb8b37          	lui	s6,0x51eb8
    4f54:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea8817>
    name[3] = '0' + (nfiles % 100) / 10;
    4f58:	66666ab7          	lui	s5,0x66666
    4f5c:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665695f>
    printf("writing %s\n", name);
    4f60:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4f64:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f68:	f4843783          	ld	a5,-184(s0)
    4f6c:	02f487b3          	mul	a5,s1,a5
    4f70:	9799                	srai	a5,a5,0x26
    4f72:	41f4d69b          	sraiw	a3,s1,0x1f
    4f76:	9f95                	subw	a5,a5,a3
    4f78:	0307871b          	addiw	a4,a5,48
    4f7c:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f80:	3e800713          	li	a4,1000
    4f84:	02f707bb          	mulw	a5,a4,a5
    4f88:	40f487bb          	subw	a5,s1,a5
    4f8c:	03678733          	mul	a4,a5,s6
    4f90:	9715                	srai	a4,a4,0x25
    4f92:	41f7d79b          	sraiw	a5,a5,0x1f
    4f96:	40f707bb          	subw	a5,a4,a5
    4f9a:	0307879b          	addiw	a5,a5,48
    4f9e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4fa2:	036487b3          	mul	a5,s1,s6
    4fa6:	9795                	srai	a5,a5,0x25
    4fa8:	9f95                	subw	a5,a5,a3
    4faa:	06400713          	li	a4,100
    4fae:	02f707bb          	mulw	a5,a4,a5
    4fb2:	40f487bb          	subw	a5,s1,a5
    4fb6:	03578733          	mul	a4,a5,s5
    4fba:	9709                	srai	a4,a4,0x22
    4fbc:	41f7d79b          	sraiw	a5,a5,0x1f
    4fc0:	40f707bb          	subw	a5,a4,a5
    4fc4:	0307879b          	addiw	a5,a5,48
    4fc8:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4fcc:	03548733          	mul	a4,s1,s5
    4fd0:	9709                	srai	a4,a4,0x22
    4fd2:	9f15                	subw	a4,a4,a3
    4fd4:	0027179b          	slliw	a5,a4,0x2
    4fd8:	9fb9                	addw	a5,a5,a4
    4fda:	0017979b          	slliw	a5,a5,0x1
    4fde:	40f487bb          	subw	a5,s1,a5
    4fe2:	0307879b          	addiw	a5,a5,48
    4fe6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4fea:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4fee:	85ea                	mv	a1,s10
    4ff0:	00003517          	auipc	a0,0x3
    4ff4:	32850513          	addi	a0,a0,808 # 8318 <malloc+0x24da>
    4ff8:	58b000ef          	jal	5d82 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4ffc:	20200593          	li	a1,514
    5000:	856a                	mv	a0,s10
    5002:	15b000ef          	jal	595c <open>
    5006:	892a                	mv	s2,a0
    if (fd < 0) {
    5008:	0e055c63          	bgez	a0,5100 <fsfull+0x1ee>
      printf("open %s failed\n", name);
    500c:	f5040593          	addi	a1,s0,-176
    5010:	00003517          	auipc	a0,0x3
    5014:	31850513          	addi	a0,a0,792 # 8328 <malloc+0x24ea>
    5018:	56b000ef          	jal	5d82 <printf>
  while (nfiles >= 0) {
    501c:	0a04cc63          	bltz	s1,50d4 <fsfull+0x1c2>
    name[0] = 'f';
    5020:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    5024:	10625ab7          	lui	s5,0x10625
    5028:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106150cb>
    name[2] = '0' + (nfiles % 1000) / 100;
    502c:	3e800c13          	li	s8,1000
    5030:	51eb8a37          	lui	s4,0x51eb8
    5034:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea8817>
    name[3] = '0' + (nfiles % 100) / 10;
    5038:	06400b93          	li	s7,100
    503c:	66666937          	lui	s2,0x66666
    5040:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665695f>
    unlink(name);
    5044:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    5048:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    504c:	035487b3          	mul	a5,s1,s5
    5050:	9799                	srai	a5,a5,0x26
    5052:	41f4d69b          	sraiw	a3,s1,0x1f
    5056:	9f95                	subw	a5,a5,a3
    5058:	0307871b          	addiw	a4,a5,48
    505c:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5060:	02fc07bb          	mulw	a5,s8,a5
    5064:	40f487bb          	subw	a5,s1,a5
    5068:	03478733          	mul	a4,a5,s4
    506c:	9715                	srai	a4,a4,0x25
    506e:	41f7d79b          	sraiw	a5,a5,0x1f
    5072:	40f707bb          	subw	a5,a4,a5
    5076:	0307879b          	addiw	a5,a5,48
    507a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    507e:	034487b3          	mul	a5,s1,s4
    5082:	9795                	srai	a5,a5,0x25
    5084:	9f95                	subw	a5,a5,a3
    5086:	02fb87bb          	mulw	a5,s7,a5
    508a:	40f487bb          	subw	a5,s1,a5
    508e:	03278733          	mul	a4,a5,s2
    5092:	9709                	srai	a4,a4,0x22
    5094:	41f7d79b          	sraiw	a5,a5,0x1f
    5098:	40f707bb          	subw	a5,a4,a5
    509c:	0307879b          	addiw	a5,a5,48
    50a0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    50a4:	03248733          	mul	a4,s1,s2
    50a8:	9709                	srai	a4,a4,0x22
    50aa:	9f15                	subw	a4,a4,a3
    50ac:	0027179b          	slliw	a5,a4,0x2
    50b0:	9fb9                	addw	a5,a5,a4
    50b2:	0017979b          	slliw	a5,a5,0x1
    50b6:	40f487bb          	subw	a5,s1,a5
    50ba:	0307879b          	addiw	a5,a5,48
    50be:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    50c2:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    50c6:	855a                	mv	a0,s6
    50c8:	0a5000ef          	jal	596c <unlink>
    nfiles--;
    50cc:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    50ce:	57fd                	li	a5,-1
    50d0:	f6f49ce3          	bne	s1,a5,5048 <fsfull+0x136>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    50d4:	85ce                	mv	a1,s3
    50d6:	00003517          	auipc	a0,0x3
    50da:	27250513          	addi	a0,a0,626 # 8348 <malloc+0x250a>
    50de:	4a5000ef          	jal	5d82 <printf>
}
    50e2:	70ea                	ld	ra,184(sp)
    50e4:	744a                	ld	s0,176(sp)
    50e6:	74aa                	ld	s1,168(sp)
    50e8:	790a                	ld	s2,160(sp)
    50ea:	69ea                	ld	s3,152(sp)
    50ec:	6a4a                	ld	s4,144(sp)
    50ee:	6aaa                	ld	s5,136(sp)
    50f0:	6b0a                	ld	s6,128(sp)
    50f2:	7be6                	ld	s7,120(sp)
    50f4:	7c46                	ld	s8,112(sp)
    50f6:	7ca6                	ld	s9,104(sp)
    50f8:	7d06                	ld	s10,96(sp)
    50fa:	6de6                	ld	s11,88(sp)
    50fc:	6129                	addi	sp,sp,192
    50fe:	8082                	ret
    int total = 0;
    5100:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    5102:	40000c93          	li	s9,1024
    5106:	00008c17          	auipc	s8,0x8
    510a:	c02c0c13          	addi	s8,s8,-1022 # cd08 <buf>
      if (cc < BSIZE)
    510e:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    5112:	8666                	mv	a2,s9
    5114:	85e2                	mv	a1,s8
    5116:	854a                	mv	a0,s2
    5118:	025000ef          	jal	593c <write>
      if (cc < BSIZE)
    511c:	00abd663          	bge	s7,a0,5128 <fsfull+0x216>
      total += cc;
    5120:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    5124:	2985                	addiw	s3,s3,1
    while (1) {
    5126:	b7f5                	j	5112 <fsfull+0x200>
    printf("wrote %d bytes\n", total);
    5128:	85d2                	mv	a1,s4
    512a:	00003517          	auipc	a0,0x3
    512e:	20e50513          	addi	a0,a0,526 # 8338 <malloc+0x24fa>
    5132:	451000ef          	jal	5d82 <printf>
    close(fd);
    5136:	854a                	mv	a0,s2
    5138:	00d000ef          	jal	5944 <close>
    if (total == 0)
    513c:	ee0a00e3          	beqz	s4,501c <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    5140:	2485                	addiw	s1,s1,1
    5142:	b50d                	j	4f64 <fsfull+0x52>

0000000000005144 <linkoverflow>:

void
linkoverflow(char *s)
{
    5144:	7175                	addi	sp,sp,-144
    5146:	e506                	sd	ra,136(sp)
    5148:	e122                	sd	s0,128(sp)
    514a:	fca6                	sd	s1,120(sp)
    514c:	f8ca                	sd	s2,112(sp)
    514e:	f4ce                	sd	s3,104(sp)
    5150:	f0d2                	sd	s4,96(sp)
    5152:	ecd6                	sd	s5,88(sp)
    5154:	e8da                	sd	s6,80(sp)
    5156:	e4de                	sd	s7,72(sp)
    5158:	e0e2                	sd	s8,64(sp)
    515a:	fc66                	sd	s9,56(sp)
    515c:	f86a                	sd	s10,48(sp)
    515e:	0900                	addi	s0,sp,144
    5160:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    5162:	00003517          	auipc	a0,0x3
    5166:	20e50513          	addi	a0,a0,526 # 8370 <malloc+0x2532>
    516a:	003000ef          	jal	596c <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    516e:	20200593          	li	a1,514
    5172:	00003517          	auipc	a0,0x3
    5176:	1fe50513          	addi	a0,a0,510 # 8370 <malloc+0x2532>
    517a:	7e2000ef          	jal	595c <open>
  if (fd < 0) {
    517e:	02054863          	bltz	a0,51ae <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    5182:	7c2000ef          	jal	5944 <close>

  for (i = 0; i < TARGET; i++) {
    5186:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    5188:	02f00993          	li	s3,47
    pn[1] = 'd';
    518c:	06400b93          	li	s7,100
    pn[2] = '_';
    5190:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    5194:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    5198:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    519c:	00003c17          	auipc	s8,0x3
    51a0:	1d4c0c13          	addi	s8,s8,468 # 8370 <malloc+0x2532>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    51a4:	51eb8ab7          	lui	s5,0x51eb8
    51a8:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea8817>
    51ac:	a869                	j	5246 <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    51ae:	85ea                	mv	a1,s10
    51b0:	00003517          	auipc	a0,0x3
    51b4:	1c850513          	addi	a0,a0,456 # 8378 <malloc+0x253a>
    51b8:	3cb000ef          	jal	5d82 <printf>
    exit(1);
    51bc:	4505                	li	a0,1
    51be:	75e000ef          	jal	591c <exit>
    pn[5] = '/';
    51c2:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    51c6:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    51ca:	41f9579b          	sraiw	a5,s2,0x1f
    51ce:	0127d79b          	srliw	a5,a5,0x12
    51d2:	012787bb          	addw	a5,a5,s2
    51d6:	40e7d79b          	sraiw	a5,a5,0xe
    51da:	0617879b          	addiw	a5,a5,97
    51de:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    51e2:	41f4d71b          	sraiw	a4,s1,0x1f
    51e6:	01c7571b          	srliw	a4,a4,0x1c
    51ea:	9cb9                	addw	s1,s1,a4
    51ec:	4044d79b          	sraiw	a5,s1,0x4
    51f0:	41f7d69b          	sraiw	a3,a5,0x1f
    51f4:	01c6d69b          	srliw	a3,a3,0x1c
    51f8:	9fb5                	addw	a5,a5,a3
    51fa:	8bbd                	andi	a5,a5,15
    51fc:	9f95                	subw	a5,a5,a3
    51fe:	0617879b          	addiw	a5,a5,97
    5202:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    5206:	88bd                	andi	s1,s1,15
    5208:	9c99                	subw	s1,s1,a4
    520a:	0614849b          	addiw	s1,s1,97
    520e:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    5212:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    5216:	85d2                	mv	a1,s4
    5218:	8562                	mv	a0,s8
    521a:	762000ef          	jal	597c <link>
    521e:	08054a63          	bltz	a0,52b2 <linkoverflow+0x16e>
    if (i % 100 == 0) {
    5222:	03590733          	mul	a4,s2,s5
    5226:	9715                	srai	a4,a4,0x25
    5228:	41f9579b          	sraiw	a5,s2,0x1f
    522c:	9f1d                	subw	a4,a4,a5
    522e:	06400793          	li	a5,100
    5232:	02e787bb          	mulw	a5,a5,a4
    5236:	40f907bb          	subw	a5,s2,a5
    523a:	10078363          	beqz	a5,5340 <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    523e:	2905                	addiw	s2,s2,1
    5240:	67a1                	lui	a5,0x8
    5242:	08f90863          	beq	s2,a5,52d2 <linkoverflow+0x18e>
    int d = i % DIRS;
    5246:	41f9571b          	sraiw	a4,s2,0x1f
    524a:	01a7571b          	srliw	a4,a4,0x1a
    524e:	012704bb          	addw	s1,a4,s2
    5252:	03f4f793          	andi	a5,s1,63
    5256:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    5258:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    525c:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    5260:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    5264:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    5268:	41f7d71b          	sraiw	a4,a5,0x1f
    526c:	01c7571b          	srliw	a4,a4,0x1c
    5270:	9fb9                	addw	a5,a5,a4
    5272:	4047d69b          	sraiw	a3,a5,0x4
    5276:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x30359>
    527a:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    527e:	8bbd                	andi	a5,a5,15
    5280:	9f99                	subw	a5,a5,a4
    5282:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x2223>
    5286:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    528a:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    528e:	f895                	bnez	s1,51c2 <linkoverflow+0x7e>
    5290:	8552                	mv	a0,s4
    5292:	6f2000ef          	jal	5984 <mkdir>
    5296:	f20556e3          	bgez	a0,51c2 <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    529a:	f7840613          	addi	a2,s0,-136
    529e:	85ea                	mv	a1,s10
    52a0:	00003517          	auipc	a0,0x3
    52a4:	0f050513          	addi	a0,a0,240 # 8390 <malloc+0x2552>
    52a8:	2db000ef          	jal	5d82 <printf>
      exit(1);
    52ac:	4505                	li	a0,1
    52ae:	66e000ef          	jal	591c <exit>
      if (stat("/lof", &st) < 0) {
    52b2:	f8840593          	addi	a1,s0,-120
    52b6:	00003517          	auipc	a0,0x3
    52ba:	0ba50513          	addi	a0,a0,186 # 8370 <malloc+0x2532>
    52be:	4fc000ef          	jal	57ba <stat>
    52c2:	04054a63          	bltz	a0,5316 <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    52c6:	f9241683          	lh	a3,-110(s0)
    52ca:	67a1                	lui	a5,0x8
    52cc:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x21c1>
    52ce:	04f69e63          	bne	a3,a5,532a <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    52d2:	f8840593          	addi	a1,s0,-120
    52d6:	00003517          	auipc	a0,0x3
    52da:	09a50513          	addi	a0,a0,154 # 8370 <malloc+0x2532>
    52de:	4dc000ef          	jal	57ba <stat>
    52e2:	06054963          	bltz	a0,5354 <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    52e6:	00003517          	auipc	a0,0x3
    52ea:	08a50513          	addi	a0,a0,138 # 8370 <malloc+0x2532>
    52ee:	67e000ef          	jal	596c <unlink>

  if (st.nlink < 0) {
    52f2:	f9241603          	lh	a2,-110(s0)
    52f6:	06064963          	bltz	a2,5368 <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    52fa:	60aa                	ld	ra,136(sp)
    52fc:	640a                	ld	s0,128(sp)
    52fe:	74e6                	ld	s1,120(sp)
    5300:	7946                	ld	s2,112(sp)
    5302:	79a6                	ld	s3,104(sp)
    5304:	7a06                	ld	s4,96(sp)
    5306:	6ae6                	ld	s5,88(sp)
    5308:	6b46                	ld	s6,80(sp)
    530a:	6ba6                	ld	s7,72(sp)
    530c:	6c06                	ld	s8,64(sp)
    530e:	7ce2                	ld	s9,56(sp)
    5310:	7d42                	ld	s10,48(sp)
    5312:	6149                	addi	sp,sp,144
    5314:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    5316:	85ea                	mv	a1,s10
    5318:	00003517          	auipc	a0,0x3
    531c:	09050513          	addi	a0,a0,144 # 83a8 <malloc+0x256a>
    5320:	263000ef          	jal	5d82 <printf>
        exit(1);
    5324:	4505                	li	a0,1
    5326:	5f6000ef          	jal	591c <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    532a:	864a                	mv	a2,s2
    532c:	85ea                	mv	a1,s10
    532e:	00003517          	auipc	a0,0x3
    5332:	09250513          	addi	a0,a0,146 # 83c0 <malloc+0x2582>
    5336:	24d000ef          	jal	5d82 <printf>
      exit(1);
    533a:	4505                	li	a0,1
    533c:	5e0000ef          	jal	591c <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    5340:	86d2                	mv	a3,s4
    5342:	864a                	mv	a2,s2
    5344:	85ea                	mv	a1,s10
    5346:	00003517          	auipc	a0,0x3
    534a:	0aa50513          	addi	a0,a0,170 # 83f0 <malloc+0x25b2>
    534e:	235000ef          	jal	5d82 <printf>
    5352:	b5f5                	j	523e <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    5354:	85ea                	mv	a1,s10
    5356:	00003517          	auipc	a0,0x3
    535a:	05250513          	addi	a0,a0,82 # 83a8 <malloc+0x256a>
    535e:	225000ef          	jal	5d82 <printf>
    exit(1);
    5362:	4505                	li	a0,1
    5364:	5b8000ef          	jal	591c <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    5368:	85ea                	mv	a1,s10
    536a:	00003517          	auipc	a0,0x3
    536e:	09e50513          	addi	a0,a0,158 # 8408 <malloc+0x25ca>
    5372:	211000ef          	jal	5d82 <printf>
    exit(1);
    5376:	4505                	li	a0,1
    5378:	5a4000ef          	jal	591c <exit>

000000000000537c <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    537c:	7179                	addi	sp,sp,-48
    537e:	f406                	sd	ra,40(sp)
    5380:	f022                	sd	s0,32(sp)
    5382:	ec26                	sd	s1,24(sp)
    5384:	e84a                	sd	s2,16(sp)
    5386:	1800                	addi	s0,sp,48
    5388:	84aa                	mv	s1,a0
    538a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    538c:	00003517          	auipc	a0,0x3
    5390:	09c50513          	addi	a0,a0,156 # 8428 <malloc+0x25ea>
    5394:	1ef000ef          	jal	5d82 <printf>
  if ((pid = fork()) < 0) {
    5398:	57c000ef          	jal	5914 <fork>
    539c:	02054a63          	bltz	a0,53d0 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    53a0:	c129                	beqz	a0,53e2 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    53a2:	fdc40513          	addi	a0,s0,-36
    53a6:	57e000ef          	jal	5924 <wait>
    if (xstatus != 0)
    53aa:	fdc42783          	lw	a5,-36(s0)
    53ae:	cf9d                	beqz	a5,53ec <run+0x70>
      printf("FAILED\n");
    53b0:	00003517          	auipc	a0,0x3
    53b4:	0a050513          	addi	a0,a0,160 # 8450 <malloc+0x2612>
    53b8:	1cb000ef          	jal	5d82 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    53bc:	fdc42503          	lw	a0,-36(s0)
  }
}
    53c0:	00153513          	seqz	a0,a0
    53c4:	70a2                	ld	ra,40(sp)
    53c6:	7402                	ld	s0,32(sp)
    53c8:	64e2                	ld	s1,24(sp)
    53ca:	6942                	ld	s2,16(sp)
    53cc:	6145                	addi	sp,sp,48
    53ce:	8082                	ret
    printf("runtest: fork error\n");
    53d0:	00003517          	auipc	a0,0x3
    53d4:	06850513          	addi	a0,a0,104 # 8438 <malloc+0x25fa>
    53d8:	1ab000ef          	jal	5d82 <printf>
    exit(1);
    53dc:	4505                	li	a0,1
    53de:	53e000ef          	jal	591c <exit>
    f(s);
    53e2:	854a                	mv	a0,s2
    53e4:	9482                	jalr	s1
    exit(0);
    53e6:	4501                	li	a0,0
    53e8:	534000ef          	jal	591c <exit>
      printf("OK\n");
    53ec:	00003517          	auipc	a0,0x3
    53f0:	06c50513          	addi	a0,a0,108 # 8458 <malloc+0x261a>
    53f4:	18f000ef          	jal	5d82 <printf>
    53f8:	b7d1                	j	53bc <run+0x40>

00000000000053fa <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    53fa:	7179                	addi	sp,sp,-48
    53fc:	f406                	sd	ra,40(sp)
    53fe:	f022                	sd	s0,32(sp)
    5400:	ec26                	sd	s1,24(sp)
    5402:	e44e                	sd	s3,8(sp)
    5404:	1800                	addi	s0,sp,48
    5406:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5408:	6508                	ld	a0,8(a0)
    540a:	c125                	beqz	a0,546a <runtests+0x70>
    540c:	e84a                	sd	s2,16(sp)
    540e:	e052                	sd	s4,0(sp)
    5410:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    5412:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    5414:	00c03a33          	snez	s4,a2
  int ntests = 0;
    5418:	4981                	li	s3,0
    541a:	a831                	j	5436 <runtests+0x3c>
      if (!run(t->f, t->s)) {
    541c:	648c                	ld	a1,8(s1)
    541e:	6088                	ld	a0,0(s1)
    5420:	f5dff0ef          	jal	537c <run>
    5424:	00153513          	seqz	a0,a0
        if (continuous != 2) {
    5428:	00aa7533          	and	a0,s4,a0
    542c:	ed01                	bnez	a0,5444 <runtests+0x4a>
      ntests++;
    542e:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    5430:	04c1                	addi	s1,s1,16
    5432:	6488                	ld	a0,8(s1)
    5434:	c115                	beqz	a0,5458 <runtests+0x5e>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5436:	fe0903e3          	beqz	s2,541c <runtests+0x22>
    543a:	85ca                	mv	a1,s2
    543c:	25a000ef          	jal	5696 <strcmp>
    5440:	f965                	bnez	a0,5430 <runtests+0x36>
    5442:	bfe9                	j	541c <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    5444:	00003517          	auipc	a0,0x3
    5448:	01c50513          	addi	a0,a0,28 # 8460 <malloc+0x2622>
    544c:	137000ef          	jal	5d82 <printf>
          return -1;
    5450:	59fd                	li	s3,-1
    5452:	6942                	ld	s2,16(sp)
    5454:	6a02                	ld	s4,0(sp)
    5456:	a019                	j	545c <runtests+0x62>
    5458:	6942                	ld	s2,16(sp)
    545a:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    545c:	854e                	mv	a0,s3
    545e:	70a2                	ld	ra,40(sp)
    5460:	7402                	ld	s0,32(sp)
    5462:	64e2                	ld	s1,24(sp)
    5464:	69a2                	ld	s3,8(sp)
    5466:	6145                	addi	sp,sp,48
    5468:	8082                	ret
  return ntests;
    546a:	4981                	li	s3,0
    546c:	bfc5                	j	545c <runtests+0x62>

000000000000546e <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    546e:	7179                	addi	sp,sp,-48
    5470:	f406                	sd	ra,40(sp)
    5472:	f022                	sd	s0,32(sp)
    5474:	ec26                	sd	s1,24(sp)
    5476:	e84a                	sd	s2,16(sp)
    5478:	e44e                	sd	s3,8(sp)
    547a:	e052                	sd	s4,0(sp)
    547c:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    547e:	4501                	li	a0,0
    5480:	468000ef          	jal	58e8 <sbrk>
    5484:	8a2a                	mv	s4,a0
  int n = 0;
    5486:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    5488:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    548a:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    548c:	854e                	mv	a0,s3
    548e:	45a000ef          	jal	58e8 <sbrk>
    if (a == SBRK_ERROR) {
    5492:	01250463          	beq	a0,s2,549a <countfree+0x2c>
      break;
    }
    n += 1;
    5496:	2485                	addiw	s1,s1,1
  while (1) {
    5498:	bfd5                	j	548c <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    549a:	4501                	li	a0,0
    549c:	44c000ef          	jal	58e8 <sbrk>
    54a0:	40aa053b          	subw	a0,s4,a0
    54a4:	444000ef          	jal	58e8 <sbrk>
  return n;
}
    54a8:	8526                	mv	a0,s1
    54aa:	70a2                	ld	ra,40(sp)
    54ac:	7402                	ld	s0,32(sp)
    54ae:	64e2                	ld	s1,24(sp)
    54b0:	6942                	ld	s2,16(sp)
    54b2:	69a2                	ld	s3,8(sp)
    54b4:	6a02                	ld	s4,0(sp)
    54b6:	6145                	addi	sp,sp,48
    54b8:	8082                	ret

00000000000054ba <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    54ba:	7159                	addi	sp,sp,-112
    54bc:	f486                	sd	ra,104(sp)
    54be:	f0a2                	sd	s0,96(sp)
    54c0:	eca6                	sd	s1,88(sp)
    54c2:	e8ca                	sd	s2,80(sp)
    54c4:	e4ce                	sd	s3,72(sp)
    54c6:	e0d2                	sd	s4,64(sp)
    54c8:	fc56                	sd	s5,56(sp)
    54ca:	f85a                	sd	s6,48(sp)
    54cc:	f45e                	sd	s7,40(sp)
    54ce:	f062                	sd	s8,32(sp)
    54d0:	ec66                	sd	s9,24(sp)
    54d2:	e86a                	sd	s10,16(sp)
    54d4:	e46e                	sd	s11,8(sp)
    54d6:	1880                	addi	s0,sp,112
    54d8:	8aaa                	mv	s5,a0
    54da:	89ae                	mv	s3,a1
    54dc:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    54de:	00c03cb3          	snez	s9,a2
    printf("usertests starting\n");
    54e2:	00003c17          	auipc	s8,0x3
    54e6:	f96c0c13          	addi	s8,s8,-106 # 8478 <malloc+0x263a>
    n = runtests(quicktests, justone, continuous);
    54ea:	00004b97          	auipc	s7,0x4
    54ee:	b26b8b93          	addi	s7,s7,-1242 # 9010 <quicktests>
      if (continuous != 2) {
    54f2:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    54f4:	00004d17          	auipc	s10,0x4
    54f8:	f7cd0d13          	addi	s10,s10,-132 # 9470 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    54fc:	00003d97          	auipc	s11,0x3
    5500:	fb4d8d93          	addi	s11,s11,-76 # 84b0 <malloc+0x2672>
    5504:	a80d                	j	5536 <drivetests+0x7c>
      if (continuous != 2) {
    5506:	09699563          	bne	s3,s6,5590 <drivetests+0xd6>
    int ntests = 0;
    550a:	4481                	li	s1,0
    550c:	a099                	j	5552 <drivetests+0x98>
        printf("usertests slow tests starting\n");
    550e:	00003517          	auipc	a0,0x3
    5512:	f8250513          	addi	a0,a0,-126 # 8490 <malloc+0x2652>
    5516:	06d000ef          	jal	5d82 <printf>
    551a:	a081                	j	555a <drivetests+0xa0>
        if (continuous != 2) {
    551c:	07699a63          	bne	s3,s6,5590 <drivetests+0xd6>
    if ((free1 = countfree()) < free0) {
    5520:	f4fff0ef          	jal	546e <countfree>
    5524:	05254463          	blt	a0,s2,556c <drivetests+0xb2>
    if (justone != 0 && ntests == 0) {
    5528:	0014b493          	seqz	s1,s1
    552c:	009cf4b3          	and	s1,s9,s1
    5530:	e8b1                	bnez	s1,5584 <drivetests+0xca>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    5532:	06098f63          	beqz	s3,55b0 <drivetests+0xf6>
    printf("usertests starting\n");
    5536:	8562                	mv	a0,s8
    5538:	04b000ef          	jal	5d82 <printf>
    int free0 = countfree();
    553c:	f33ff0ef          	jal	546e <countfree>
    5540:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    5542:	864e                	mv	a2,s3
    5544:	85d2                	mv	a1,s4
    5546:	855e                	mv	a0,s7
    5548:	eb3ff0ef          	jal	53fa <runtests>
    554c:	84aa                	mv	s1,a0
    if (n < 0) {
    554e:	fa054ce3          	bltz	a0,5506 <drivetests+0x4c>
    if (!quick) {
    5552:	fc0a97e3          	bnez	s5,5520 <drivetests+0x66>
      if (justone == 0)
    5556:	fa0a0ce3          	beqz	s4,550e <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    555a:	864e                	mv	a2,s3
    555c:	85d2                	mv	a1,s4
    555e:	856a                	mv	a0,s10
    5560:	e9bff0ef          	jal	53fa <runtests>
      if (n < 0) {
    5564:	fa054ce3          	bltz	a0,551c <drivetests+0x62>
        ntests += n;
    5568:	9ca9                	addw	s1,s1,a0
    556a:	bf5d                	j	5520 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    556c:	864a                	mv	a2,s2
    556e:	85aa                	mv	a1,a0
    5570:	856e                	mv	a0,s11
    5572:	011000ef          	jal	5d82 <printf>
      if (continuous != 2) {
    5576:	01699d63          	bne	s3,s6,5590 <drivetests+0xd6>
    if (justone != 0 && ntests == 0) {
    557a:	0014b493          	seqz	s1,s1
    557e:	009cf4b3          	and	s1,s9,s1
    5582:	d8d5                	beqz	s1,5536 <drivetests+0x7c>
      printf("NO TESTS EXECUTED\n");
    5584:	00003517          	auipc	a0,0x3
    5588:	f5c50513          	addi	a0,a0,-164 # 84e0 <malloc+0x26a2>
    558c:	7f6000ef          	jal	5d82 <printf>
        return 1;
    5590:	4505                	li	a0,1
  return 0;
}
    5592:	70a6                	ld	ra,104(sp)
    5594:	7406                	ld	s0,96(sp)
    5596:	64e6                	ld	s1,88(sp)
    5598:	6946                	ld	s2,80(sp)
    559a:	69a6                	ld	s3,72(sp)
    559c:	6a06                	ld	s4,64(sp)
    559e:	7ae2                	ld	s5,56(sp)
    55a0:	7b42                	ld	s6,48(sp)
    55a2:	7ba2                	ld	s7,40(sp)
    55a4:	7c02                	ld	s8,32(sp)
    55a6:	6ce2                	ld	s9,24(sp)
    55a8:	6d42                	ld	s10,16(sp)
    55aa:	6da2                	ld	s11,8(sp)
    55ac:	6165                	addi	sp,sp,112
    55ae:	8082                	ret
  return 0;
    55b0:	854e                	mv	a0,s3
    55b2:	b7c5                	j	5592 <drivetests+0xd8>

00000000000055b4 <main>:

int
main(int argc, char *argv[])
{
    55b4:	1101                	addi	sp,sp,-32
    55b6:	ec06                	sd	ra,24(sp)
    55b8:	e822                	sd	s0,16(sp)
    55ba:	e426                	sd	s1,8(sp)
    55bc:	e04a                	sd	s2,0(sp)
    55be:	1000                	addi	s0,sp,32
    55c0:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    55c2:	4789                	li	a5,2
    55c4:	00f50e63          	beq	a0,a5,55e0 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    55c8:	4785                	li	a5,1
    55ca:	06a7c663          	blt	a5,a0,5636 <main+0x82>
  char *justone = 0;
    55ce:	4601                	li	a2,0
  int quick = 0;
    55d0:	4501                	li	a0,0
  int continuous = 0;
    55d2:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    55d4:	ee7ff0ef          	jal	54ba <drivetests>
    55d8:	cd35                	beqz	a0,5654 <main+0xa0>
    exit(1);
    55da:	4505                	li	a0,1
    55dc:	340000ef          	jal	591c <exit>
    55e0:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    55e2:	00003597          	auipc	a1,0x3
    55e6:	f1658593          	addi	a1,a1,-234 # 84f8 <malloc+0x26ba>
    55ea:	00893503          	ld	a0,8(s2)
    55ee:	0a8000ef          	jal	5696 <strcmp>
    55f2:	85aa                	mv	a1,a0
    55f4:	e501                	bnez	a0,55fc <main+0x48>
  char *justone = 0;
    55f6:	4601                	li	a2,0
    quick = 1;
    55f8:	4505                	li	a0,1
    55fa:	bfe9                	j	55d4 <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    55fc:	00003597          	auipc	a1,0x3
    5600:	f0458593          	addi	a1,a1,-252 # 8500 <malloc+0x26c2>
    5604:	00893503          	ld	a0,8(s2)
    5608:	08e000ef          	jal	5696 <strcmp>
    560c:	cd15                	beqz	a0,5648 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    560e:	00003597          	auipc	a1,0x3
    5612:	f4258593          	addi	a1,a1,-190 # 8550 <malloc+0x2712>
    5616:	00893503          	ld	a0,8(s2)
    561a:	07c000ef          	jal	5696 <strcmp>
    561e:	c905                	beqz	a0,564e <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    5620:	00893603          	ld	a2,8(s2)
    5624:	00064703          	lbu	a4,0(a2)
    5628:	02d00793          	li	a5,45
    562c:	00f70563          	beq	a4,a5,5636 <main+0x82>
  int quick = 0;
    5630:	4501                	li	a0,0
  int continuous = 0;
    5632:	4581                	li	a1,0
    5634:	b745                	j	55d4 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5636:	00003517          	auipc	a0,0x3
    563a:	ed250513          	addi	a0,a0,-302 # 8508 <malloc+0x26ca>
    563e:	744000ef          	jal	5d82 <printf>
    exit(1);
    5642:	4505                	li	a0,1
    5644:	2d8000ef          	jal	591c <exit>
  char *justone = 0;
    5648:	4601                	li	a2,0
    continuous = 1;
    564a:	4585                	li	a1,1
    564c:	b761                	j	55d4 <main+0x20>
    continuous = 2;
    564e:	85a6                	mv	a1,s1
  char *justone = 0;
    5650:	4601                	li	a2,0
    5652:	b749                	j	55d4 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5654:	00003517          	auipc	a0,0x3
    5658:	ee450513          	addi	a0,a0,-284 # 8538 <malloc+0x26fa>
    565c:	726000ef          	jal	5d82 <printf>
  exit(0);
    5660:	4501                	li	a0,0
    5662:	2ba000ef          	jal	591c <exit>

0000000000005666 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    5666:	1141                	addi	sp,sp,-16
    5668:	e406                	sd	ra,8(sp)
    566a:	e022                	sd	s0,0(sp)
    566c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    566e:	f47ff0ef          	jal	55b4 <main>
  exit(r);
    5672:	2aa000ef          	jal	591c <exit>

0000000000005676 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    5676:	1141                	addi	sp,sp,-16
    5678:	e406                	sd	ra,8(sp)
    567a:	e022                	sd	s0,0(sp)
    567c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    567e:	87aa                	mv	a5,a0
    5680:	0585                	addi	a1,a1,1
    5682:	0785                	addi	a5,a5,1
    5684:	fff5c703          	lbu	a4,-1(a1)
    5688:	fee78fa3          	sb	a4,-1(a5)
    568c:	fb75                	bnez	a4,5680 <strcpy+0xa>
    ;
  return os;
}
    568e:	60a2                	ld	ra,8(sp)
    5690:	6402                	ld	s0,0(sp)
    5692:	0141                	addi	sp,sp,16
    5694:	8082                	ret

0000000000005696 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5696:	1141                	addi	sp,sp,-16
    5698:	e406                	sd	ra,8(sp)
    569a:	e022                	sd	s0,0(sp)
    569c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    569e:	00054783          	lbu	a5,0(a0)
    56a2:	cb91                	beqz	a5,56b6 <strcmp+0x20>
    56a4:	0005c703          	lbu	a4,0(a1)
    56a8:	00f71763          	bne	a4,a5,56b6 <strcmp+0x20>
    p++, q++;
    56ac:	0505                	addi	a0,a0,1
    56ae:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    56b0:	00054783          	lbu	a5,0(a0)
    56b4:	fbe5                	bnez	a5,56a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    56b6:	0005c503          	lbu	a0,0(a1)
}
    56ba:	40a7853b          	subw	a0,a5,a0
    56be:	60a2                	ld	ra,8(sp)
    56c0:	6402                	ld	s0,0(sp)
    56c2:	0141                	addi	sp,sp,16
    56c4:	8082                	ret

00000000000056c6 <strlen>:

uint
strlen(const char *s)
{
    56c6:	1141                	addi	sp,sp,-16
    56c8:	e406                	sd	ra,8(sp)
    56ca:	e022                	sd	s0,0(sp)
    56cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    56ce:	00054783          	lbu	a5,0(a0)
    56d2:	cf91                	beqz	a5,56ee <strlen+0x28>
    56d4:	00150793          	addi	a5,a0,1
    56d8:	86be                	mv	a3,a5
    56da:	0785                	addi	a5,a5,1
    56dc:	fff7c703          	lbu	a4,-1(a5)
    56e0:	ff65                	bnez	a4,56d8 <strlen+0x12>
    56e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    56e6:	60a2                	ld	ra,8(sp)
    56e8:	6402                	ld	s0,0(sp)
    56ea:	0141                	addi	sp,sp,16
    56ec:	8082                	ret
  for (n = 0; s[n]; n++)
    56ee:	4501                	li	a0,0
    56f0:	bfdd                	j	56e6 <strlen+0x20>

00000000000056f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
    56f2:	1141                	addi	sp,sp,-16
    56f4:	e406                	sd	ra,8(sp)
    56f6:	e022                	sd	s0,0(sp)
    56f8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    56fa:	ca19                	beqz	a2,5710 <memset+0x1e>
    56fc:	87aa                	mv	a5,a0
    56fe:	1602                	slli	a2,a2,0x20
    5700:	9201                	srli	a2,a2,0x20
    5702:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5706:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    570a:	0785                	addi	a5,a5,1
    570c:	fee79de3          	bne	a5,a4,5706 <memset+0x14>
  }
  return dst;
}
    5710:	60a2                	ld	ra,8(sp)
    5712:	6402                	ld	s0,0(sp)
    5714:	0141                	addi	sp,sp,16
    5716:	8082                	ret

0000000000005718 <strchr>:

char *
strchr(const char *s, char c)
{
    5718:	1141                	addi	sp,sp,-16
    571a:	e406                	sd	ra,8(sp)
    571c:	e022                	sd	s0,0(sp)
    571e:	0800                	addi	s0,sp,16
  for (; *s; s++)
    5720:	00054783          	lbu	a5,0(a0)
    5724:	c799                	beqz	a5,5732 <strchr+0x1a>
    if (*s == c)
    5726:	00f58763          	beq	a1,a5,5734 <strchr+0x1c>
  for (; *s; s++)
    572a:	0505                	addi	a0,a0,1
    572c:	00054783          	lbu	a5,0(a0)
    5730:	fbfd                	bnez	a5,5726 <strchr+0xe>
      return (char *)s;
  return 0;
    5732:	4501                	li	a0,0
}
    5734:	60a2                	ld	ra,8(sp)
    5736:	6402                	ld	s0,0(sp)
    5738:	0141                	addi	sp,sp,16
    573a:	8082                	ret

000000000000573c <gets>:

char *
gets(char *buf, int max)
{
    573c:	711d                	addi	sp,sp,-96
    573e:	ec86                	sd	ra,88(sp)
    5740:	e8a2                	sd	s0,80(sp)
    5742:	e4a6                	sd	s1,72(sp)
    5744:	e0ca                	sd	s2,64(sp)
    5746:	fc4e                	sd	s3,56(sp)
    5748:	f852                	sd	s4,48(sp)
    574a:	f456                	sd	s5,40(sp)
    574c:	f05a                	sd	s6,32(sp)
    574e:	ec5e                	sd	s7,24(sp)
    5750:	e862                	sd	s8,16(sp)
    5752:	1080                	addi	s0,sp,96
    5754:	8baa                	mv	s7,a0
    5756:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5758:	892a                	mv	s2,a0
    575a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    575c:	faf40b13          	addi	s6,s0,-81
    5760:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    5762:	8c26                	mv	s8,s1
    5764:	0014899b          	addiw	s3,s1,1
    5768:	84ce                	mv	s1,s3
    576a:	0349d863          	bge	s3,s4,579a <gets+0x5e>
    cc = read(0, &c, 1);
    576e:	8656                	mv	a2,s5
    5770:	85da                	mv	a1,s6
    5772:	4501                	li	a0,0
    5774:	1c0000ef          	jal	5934 <read>
    if (cc < 1)
    5778:	02a05163          	blez	a0,579a <gets+0x5e>
      break;
    buf[i++] = c;
    577c:	faf44783          	lbu	a5,-81(s0)
    5780:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    5784:	0905                	addi	s2,s2,1
    5786:	ff678713          	addi	a4,a5,-10
    578a:	00173713          	seqz	a4,a4
    578e:	17cd                	addi	a5,a5,-13
    5790:	0017b793          	seqz	a5,a5
    5794:	8fd9                	or	a5,a5,a4
    5796:	d7f1                	beqz	a5,5762 <gets+0x26>
    buf[i++] = c;
    5798:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    579a:	9c5e                	add	s8,s8,s7
    579c:	000c0023          	sb	zero,0(s8)
  return buf;
}
    57a0:	855e                	mv	a0,s7
    57a2:	60e6                	ld	ra,88(sp)
    57a4:	6446                	ld	s0,80(sp)
    57a6:	64a6                	ld	s1,72(sp)
    57a8:	6906                	ld	s2,64(sp)
    57aa:	79e2                	ld	s3,56(sp)
    57ac:	7a42                	ld	s4,48(sp)
    57ae:	7aa2                	ld	s5,40(sp)
    57b0:	7b02                	ld	s6,32(sp)
    57b2:	6be2                	ld	s7,24(sp)
    57b4:	6c42                	ld	s8,16(sp)
    57b6:	6125                	addi	sp,sp,96
    57b8:	8082                	ret

00000000000057ba <stat>:

int
stat(const char *n, struct stat *st)
{
    57ba:	1101                	addi	sp,sp,-32
    57bc:	ec06                	sd	ra,24(sp)
    57be:	e822                	sd	s0,16(sp)
    57c0:	e04a                	sd	s2,0(sp)
    57c2:	1000                	addi	s0,sp,32
    57c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    57c6:	4581                	li	a1,0
    57c8:	194000ef          	jal	595c <open>
  if (fd < 0)
    57cc:	02054263          	bltz	a0,57f0 <stat+0x36>
    57d0:	e426                	sd	s1,8(sp)
    57d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    57d4:	85ca                	mv	a1,s2
    57d6:	19e000ef          	jal	5974 <fstat>
    57da:	892a                	mv	s2,a0
  close(fd);
    57dc:	8526                	mv	a0,s1
    57de:	166000ef          	jal	5944 <close>
  return r;
    57e2:	64a2                	ld	s1,8(sp)
}
    57e4:	854a                	mv	a0,s2
    57e6:	60e2                	ld	ra,24(sp)
    57e8:	6442                	ld	s0,16(sp)
    57ea:	6902                	ld	s2,0(sp)
    57ec:	6105                	addi	sp,sp,32
    57ee:	8082                	ret
    return -1;
    57f0:	57fd                	li	a5,-1
    57f2:	893e                	mv	s2,a5
    57f4:	bfc5                	j	57e4 <stat+0x2a>

00000000000057f6 <atoi>:

int
atoi(const char *s)
{
    57f6:	1141                	addi	sp,sp,-16
    57f8:	e406                	sd	ra,8(sp)
    57fa:	e022                	sd	s0,0(sp)
    57fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    57fe:	00054683          	lbu	a3,0(a0)
    5802:	fd06879b          	addiw	a5,a3,-48
    5806:	0ff7f793          	zext.b	a5,a5
    580a:	4625                	li	a2,9
    580c:	02f66963          	bltu	a2,a5,583e <atoi+0x48>
    5810:	872a                	mv	a4,a0
  n = 0;
    5812:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    5814:	0705                	addi	a4,a4,1 # 1000001 <base+0xff02f9>
    5816:	0025179b          	slliw	a5,a0,0x2
    581a:	9fa9                	addw	a5,a5,a0
    581c:	0017979b          	slliw	a5,a5,0x1
    5820:	9fb5                	addw	a5,a5,a3
    5822:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    5826:	00074683          	lbu	a3,0(a4)
    582a:	fd06879b          	addiw	a5,a3,-48
    582e:	0ff7f793          	zext.b	a5,a5
    5832:	fef671e3          	bgeu	a2,a5,5814 <atoi+0x1e>
  return n;
}
    5836:	60a2                	ld	ra,8(sp)
    5838:	6402                	ld	s0,0(sp)
    583a:	0141                	addi	sp,sp,16
    583c:	8082                	ret
  n = 0;
    583e:	4501                	li	a0,0
    5840:	bfdd                	j	5836 <atoi+0x40>

0000000000005842 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    5842:	1141                	addi	sp,sp,-16
    5844:	e406                	sd	ra,8(sp)
    5846:	e022                	sd	s0,0(sp)
    5848:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    584a:	02b57563          	bgeu	a0,a1,5874 <memmove+0x32>
    while (n-- > 0)
    584e:	00c05f63          	blez	a2,586c <memmove+0x2a>
    5852:	1602                	slli	a2,a2,0x20
    5854:	9201                	srli	a2,a2,0x20
    5856:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    585a:	872a                	mv	a4,a0
      *dst++ = *src++;
    585c:	0585                	addi	a1,a1,1
    585e:	0705                	addi	a4,a4,1
    5860:	fff5c683          	lbu	a3,-1(a1)
    5864:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    5868:	fee79ae3          	bne	a5,a4,585c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    586c:	60a2                	ld	ra,8(sp)
    586e:	6402                	ld	s0,0(sp)
    5870:	0141                	addi	sp,sp,16
    5872:	8082                	ret
    while (n-- > 0)
    5874:	fec05ce3          	blez	a2,586c <memmove+0x2a>
    dst += n;
    5878:	00c50733          	add	a4,a0,a2
    src += n;
    587c:	95b2                	add	a1,a1,a2
    587e:	fff6079b          	addiw	a5,a2,-1
    5882:	1782                	slli	a5,a5,0x20
    5884:	9381                	srli	a5,a5,0x20
    5886:	fff7c793          	not	a5,a5
    588a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    588c:	15fd                	addi	a1,a1,-1
    588e:	177d                	addi	a4,a4,-1
    5890:	0005c683          	lbu	a3,0(a1)
    5894:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    5898:	fef71ae3          	bne	a4,a5,588c <memmove+0x4a>
    589c:	bfc1                	j	586c <memmove+0x2a>

000000000000589e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    589e:	1141                	addi	sp,sp,-16
    58a0:	e406                	sd	ra,8(sp)
    58a2:	e022                	sd	s0,0(sp)
    58a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    58a6:	ce19                	beqz	a2,58c4 <memcmp+0x26>
    58a8:	1602                	slli	a2,a2,0x20
    58aa:	9201                	srli	a2,a2,0x20
    58ac:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    58b0:	00054783          	lbu	a5,0(a0)
    58b4:	0005c703          	lbu	a4,0(a1)
    58b8:	00e79b63          	bne	a5,a4,58ce <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
    58bc:	0505                	addi	a0,a0,1
    p2++;
    58be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    58c0:	fed518e3          	bne	a0,a3,58b0 <memcmp+0x12>
  }
  return 0;
    58c4:	4501                	li	a0,0
}
    58c6:	60a2                	ld	ra,8(sp)
    58c8:	6402                	ld	s0,0(sp)
    58ca:	0141                	addi	sp,sp,16
    58cc:	8082                	ret
      return *p1 - *p2;
    58ce:	40e7853b          	subw	a0,a5,a4
    58d2:	bfd5                	j	58c6 <memcmp+0x28>

00000000000058d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    58d4:	1141                	addi	sp,sp,-16
    58d6:	e406                	sd	ra,8(sp)
    58d8:	e022                	sd	s0,0(sp)
    58da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    58dc:	f67ff0ef          	jal	5842 <memmove>
}
    58e0:	60a2                	ld	ra,8(sp)
    58e2:	6402                	ld	s0,0(sp)
    58e4:	0141                	addi	sp,sp,16
    58e6:	8082                	ret

00000000000058e8 <sbrk>:

char *
sbrk(int n)
{
    58e8:	1141                	addi	sp,sp,-16
    58ea:	e406                	sd	ra,8(sp)
    58ec:	e022                	sd	s0,0(sp)
    58ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    58f0:	4585                	li	a1,1
    58f2:	0b2000ef          	jal	59a4 <sys_sbrk>
}
    58f6:	60a2                	ld	ra,8(sp)
    58f8:	6402                	ld	s0,0(sp)
    58fa:	0141                	addi	sp,sp,16
    58fc:	8082                	ret

00000000000058fe <sbrklazy>:

char *
sbrklazy(int n)
{
    58fe:	1141                	addi	sp,sp,-16
    5900:	e406                	sd	ra,8(sp)
    5902:	e022                	sd	s0,0(sp)
    5904:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    5906:	4589                	li	a1,2
    5908:	09c000ef          	jal	59a4 <sys_sbrk>
}
    590c:	60a2                	ld	ra,8(sp)
    590e:	6402                	ld	s0,0(sp)
    5910:	0141                	addi	sp,sp,16
    5912:	8082                	ret

0000000000005914 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5914:	4885                	li	a7,1
 ecall
    5916:	00000073          	ecall
 ret
    591a:	8082                	ret

000000000000591c <exit>:
.global exit
exit:
 li a7, SYS_exit
    591c:	4889                	li	a7,2
 ecall
    591e:	00000073          	ecall
 ret
    5922:	8082                	ret

0000000000005924 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5924:	488d                	li	a7,3
 ecall
    5926:	00000073          	ecall
 ret
    592a:	8082                	ret

000000000000592c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    592c:	4891                	li	a7,4
 ecall
    592e:	00000073          	ecall
 ret
    5932:	8082                	ret

0000000000005934 <read>:
.global read
read:
 li a7, SYS_read
    5934:	4895                	li	a7,5
 ecall
    5936:	00000073          	ecall
 ret
    593a:	8082                	ret

000000000000593c <write>:
.global write
write:
 li a7, SYS_write
    593c:	48c1                	li	a7,16
 ecall
    593e:	00000073          	ecall
 ret
    5942:	8082                	ret

0000000000005944 <close>:
.global close
close:
 li a7, SYS_close
    5944:	48d5                	li	a7,21
 ecall
    5946:	00000073          	ecall
 ret
    594a:	8082                	ret

000000000000594c <kill>:
.global kill
kill:
 li a7, SYS_kill
    594c:	4899                	li	a7,6
 ecall
    594e:	00000073          	ecall
 ret
    5952:	8082                	ret

0000000000005954 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5954:	489d                	li	a7,7
 ecall
    5956:	00000073          	ecall
 ret
    595a:	8082                	ret

000000000000595c <open>:
.global open
open:
 li a7, SYS_open
    595c:	48bd                	li	a7,15
 ecall
    595e:	00000073          	ecall
 ret
    5962:	8082                	ret

0000000000005964 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5964:	48c5                	li	a7,17
 ecall
    5966:	00000073          	ecall
 ret
    596a:	8082                	ret

000000000000596c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    596c:	48c9                	li	a7,18
 ecall
    596e:	00000073          	ecall
 ret
    5972:	8082                	ret

0000000000005974 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5974:	48a1                	li	a7,8
 ecall
    5976:	00000073          	ecall
 ret
    597a:	8082                	ret

000000000000597c <link>:
.global link
link:
 li a7, SYS_link
    597c:	48cd                	li	a7,19
 ecall
    597e:	00000073          	ecall
 ret
    5982:	8082                	ret

0000000000005984 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5984:	48d1                	li	a7,20
 ecall
    5986:	00000073          	ecall
 ret
    598a:	8082                	ret

000000000000598c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    598c:	48a5                	li	a7,9
 ecall
    598e:	00000073          	ecall
 ret
    5992:	8082                	ret

0000000000005994 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5994:	48a9                	li	a7,10
 ecall
    5996:	00000073          	ecall
 ret
    599a:	8082                	ret

000000000000599c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    599c:	48ad                	li	a7,11
 ecall
    599e:	00000073          	ecall
 ret
    59a2:	8082                	ret

00000000000059a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    59a4:	48b1                	li	a7,12
 ecall
    59a6:	00000073          	ecall
 ret
    59aa:	8082                	ret

00000000000059ac <pause>:
.global pause
pause:
 li a7, SYS_pause
    59ac:	48b5                	li	a7,13
 ecall
    59ae:	00000073          	ecall
 ret
    59b2:	8082                	ret

00000000000059b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    59b4:	48b9                	li	a7,14
 ecall
    59b6:	00000073          	ecall
 ret
    59ba:	8082                	ret

00000000000059bc <sync>:
.global sync
sync:
 li a7, SYS_sync
    59bc:	48d9                	li	a7,22
 ecall
    59be:	00000073          	ecall
 ret
    59c2:	8082                	ret

00000000000059c4 <getYear>:
.global getYear
getYear:
 li a7, SYS_getYear
    59c4:	48dd                	li	a7,23
 ecall
    59c6:	00000073          	ecall
 ret
    59ca:	8082                	ret

00000000000059cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    59cc:	1101                	addi	sp,sp,-32
    59ce:	ec06                	sd	ra,24(sp)
    59d0:	e822                	sd	s0,16(sp)
    59d2:	1000                	addi	s0,sp,32
    59d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    59d8:	4605                	li	a2,1
    59da:	fef40593          	addi	a1,s0,-17
    59de:	f5fff0ef          	jal	593c <write>
}
    59e2:	60e2                	ld	ra,24(sp)
    59e4:	6442                	ld	s0,16(sp)
    59e6:	6105                	addi	sp,sp,32
    59e8:	8082                	ret

00000000000059ea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    59ea:	715d                	addi	sp,sp,-80
    59ec:	e486                	sd	ra,72(sp)
    59ee:	e0a2                	sd	s0,64(sp)
    59f0:	f84a                	sd	s2,48(sp)
    59f2:	f44e                	sd	s3,40(sp)
    59f4:	0880                	addi	s0,sp,80
    59f6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    59f8:	00d036b3          	snez	a3,a3
    59fc:	03f5d793          	srli	a5,a1,0x3f
    5a00:	8efd                	and	a3,a3,a5
  neg = 0;
    5a02:	4301                	li	t1,0
  if (sgn && xx < 0) {
    5a04:	c681                	beqz	a3,5a0c <printint+0x22>
    neg = 1;
    x = -xx;
    5a06:	40b005b3          	neg	a1,a1
    neg = 1;
    5a0a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    5a0c:	fb840993          	addi	s3,s0,-72
  neg = 0;
    5a10:	86ce                	mv	a3,s3
  i = 0;
    5a12:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5a14:	00003817          	auipc	a6,0x3
    5a18:	fb480813          	addi	a6,a6,-76 # 89c8 <digits>
    5a1c:	88ba                	mv	a7,a4
    5a1e:	0017051b          	addiw	a0,a4,1
    5a22:	872a                	mv	a4,a0
    5a24:	02c5f7b3          	remu	a5,a1,a2
    5a28:	97c2                	add	a5,a5,a6
    5a2a:	0007c783          	lbu	a5,0(a5)
    5a2e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5a32:	87ae                	mv	a5,a1
    5a34:	02c5d5b3          	divu	a1,a1,a2
    5a38:	0685                	addi	a3,a3,1
    5a3a:	fec7f1e3          	bgeu	a5,a2,5a1c <printint+0x32>
  if (neg)
    5a3e:	00030b63          	beqz	t1,5a54 <printint+0x6a>
    buf[i++] = '-';
    5a42:	fd040793          	addi	a5,s0,-48
    5a46:	953e                	add	a0,a0,a5
    5a48:	02d00793          	li	a5,45
    5a4c:	fef50423          	sb	a5,-24(a0)
    5a50:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    5a54:	02e05563          	blez	a4,5a7e <printint+0x94>
    5a58:	fc26                	sd	s1,56(sp)
    5a5a:	377d                	addiw	a4,a4,-1
    5a5c:	00e984b3          	add	s1,s3,a4
    5a60:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    5a62:	99ba                	add	s3,s3,a4
    5a64:	1702                	slli	a4,a4,0x20
    5a66:	9301                	srli	a4,a4,0x20
    5a68:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5a6c:	0004c583          	lbu	a1,0(s1)
    5a70:	854a                	mv	a0,s2
    5a72:	f5bff0ef          	jal	59cc <putc>
  while (--i >= 0)
    5a76:	14fd                	addi	s1,s1,-1
    5a78:	ff349ae3          	bne	s1,s3,5a6c <printint+0x82>
    5a7c:	74e2                	ld	s1,56(sp)
}
    5a7e:	60a6                	ld	ra,72(sp)
    5a80:	6406                	ld	s0,64(sp)
    5a82:	7942                	ld	s2,48(sp)
    5a84:	79a2                	ld	s3,40(sp)
    5a86:	6161                	addi	sp,sp,80
    5a88:	8082                	ret

0000000000005a8a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5a8a:	711d                	addi	sp,sp,-96
    5a8c:	ec86                	sd	ra,88(sp)
    5a8e:	e8a2                	sd	s0,80(sp)
    5a90:	e4a6                	sd	s1,72(sp)
    5a92:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    5a94:	0005c483          	lbu	s1,0(a1)
    5a98:	2a048063          	beqz	s1,5d38 <vprintf+0x2ae>
    5a9c:	e0ca                	sd	s2,64(sp)
    5a9e:	fc4e                	sd	s3,56(sp)
    5aa0:	f852                	sd	s4,48(sp)
    5aa2:	f456                	sd	s5,40(sp)
    5aa4:	f05a                	sd	s6,32(sp)
    5aa6:	ec5e                	sd	s7,24(sp)
    5aa8:	e862                	sd	s8,16(sp)
    5aaa:	8b2a                	mv	s6,a0
    5aac:	8a2e                	mv	s4,a1
    5aae:	8bb2                	mv	s7,a2
  state = 0;
    5ab0:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    5ab2:	4901                	li	s2,0
    5ab4:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    5ab6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    5aba:	06400c13          	li	s8,100
    5abe:	a00d                	j	5ae0 <vprintf+0x56>
        putc(fd, c0);
    5ac0:	85a6                	mv	a1,s1
    5ac2:	855a                	mv	a0,s6
    5ac4:	f09ff0ef          	jal	59cc <putc>
    5ac8:	a019                	j	5ace <vprintf+0x44>
    } else if (state == '%') {
    5aca:	03598363          	beq	s3,s5,5af0 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    5ace:	0019079b          	addiw	a5,s2,1
    5ad2:	893e                	mv	s2,a5
    5ad4:	873e                	mv	a4,a5
    5ad6:	97d2                	add	a5,a5,s4
    5ad8:	0007c483          	lbu	s1,0(a5)
    5adc:	24048763          	beqz	s1,5d2a <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
    5ae0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    5ae4:	fe0993e3          	bnez	s3,5aca <vprintf+0x40>
      if (c0 == '%') {
    5ae8:	fd579ce3          	bne	a5,s5,5ac0 <vprintf+0x36>
        state = '%';
    5aec:	89be                	mv	s3,a5
    5aee:	b7c5                	j	5ace <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    5af0:	00ea06b3          	add	a3,s4,a4
    5af4:	0016c603          	lbu	a2,1(a3)
      if (c1)
    5af8:	24060563          	beqz	a2,5d42 <vprintf+0x2b8>
      if (c0 == 'd') {
    5afc:	0b878763          	beq	a5,s8,5baa <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    5b00:	f9478693          	addi	a3,a5,-108
    5b04:	0016b693          	seqz	a3,a3
    5b08:	f9c60593          	addi	a1,a2,-100
    5b0c:	0015b593          	seqz	a1,a1
    5b10:	8df5                	and	a1,a1,a3
    5b12:	e9c5                	bnez	a1,5bc2 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
    5b14:	9752                	add	a4,a4,s4
    5b16:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5b1a:	f9460713          	addi	a4,a2,-108
    5b1e:	00173713          	seqz	a4,a4
    5b22:	8f75                	and	a4,a4,a3
    5b24:	f9c50593          	addi	a1,a0,-100
    5b28:	0015b593          	seqz	a1,a1
    5b2c:	8df9                	and	a1,a1,a4
    5b2e:	e5dd                	bnez	a1,5bdc <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    5b30:	07500593          	li	a1,117
    5b34:	0cb78163          	beq	a5,a1,5bf6 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
    5b38:	f8b60593          	addi	a1,a2,-117
    5b3c:	0015b593          	seqz	a1,a1
    5b40:	8df5                	and	a1,a1,a3
    5b42:	e5f1                	bnez	a1,5c0e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5b44:	f8b50593          	addi	a1,a0,-117
    5b48:	0015b593          	seqz	a1,a1
    5b4c:	8df9                	and	a1,a1,a4
    5b4e:	ede9                	bnez	a1,5c28 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    5b50:	07800593          	li	a1,120
    5b54:	0eb78763          	beq	a5,a1,5c42 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
    5b58:	f8860613          	addi	a2,a2,-120
    5b5c:	00163613          	seqz	a2,a2
    5b60:	8ef1                	and	a3,a3,a2
    5b62:	0e069c63          	bnez	a3,5c5a <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5b66:	f8850513          	addi	a0,a0,-120
    5b6a:	00153513          	seqz	a0,a0
    5b6e:	8f69                	and	a4,a4,a0
    5b70:	10071263          	bnez	a4,5c74 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    5b74:	07000713          	li	a4,112
    5b78:	10e78a63          	beq	a5,a4,5c8c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    5b7c:	06300713          	li	a4,99
    5b80:	14e78a63          	beq	a5,a4,5cd4 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    5b84:	07300713          	li	a4,115
    5b88:	16e78063          	beq	a5,a4,5ce8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    5b8c:	02500713          	li	a4,37
    5b90:	18e78863          	beq	a5,a4,5d20 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5b94:	02500593          	li	a1,37
    5b98:	855a                	mv	a0,s6
    5b9a:	e33ff0ef          	jal	59cc <putc>
        putc(fd, c0);
    5b9e:	85a6                	mv	a1,s1
    5ba0:	855a                	mv	a0,s6
    5ba2:	e2bff0ef          	jal	59cc <putc>
      }

      state = 0;
    5ba6:	4981                	li	s3,0
    5ba8:	b71d                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5baa:	008b8493          	addi	s1,s7,8
    5bae:	4685                	li	a3,1
    5bb0:	4629                	li	a2,10
    5bb2:	000ba583          	lw	a1,0(s7)
    5bb6:	855a                	mv	a0,s6
    5bb8:	e33ff0ef          	jal	59ea <printint>
    5bbc:	8ba6                	mv	s7,s1
      state = 0;
    5bbe:	4981                	li	s3,0
    5bc0:	b739                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5bc2:	008b8493          	addi	s1,s7,8
    5bc6:	4685                	li	a3,1
    5bc8:	4629                	li	a2,10
    5bca:	000bb583          	ld	a1,0(s7)
    5bce:	855a                	mv	a0,s6
    5bd0:	e1bff0ef          	jal	59ea <printint>
        i += 1;
    5bd4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5bd6:	8ba6                	mv	s7,s1
      state = 0;
    5bd8:	4981                	li	s3,0
    5bda:	bdd5                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5bdc:	008b8493          	addi	s1,s7,8
    5be0:	4685                	li	a3,1
    5be2:	4629                	li	a2,10
    5be4:	000bb583          	ld	a1,0(s7)
    5be8:	855a                	mv	a0,s6
    5bea:	e01ff0ef          	jal	59ea <printint>
        i += 2;
    5bee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5bf0:	8ba6                	mv	s7,s1
      state = 0;
    5bf2:	4981                	li	s3,0
        i += 2;
    5bf4:	bde9                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5bf6:	008b8493          	addi	s1,s7,8
    5bfa:	4681                	li	a3,0
    5bfc:	4629                	li	a2,10
    5bfe:	000be583          	lwu	a1,0(s7)
    5c02:	855a                	mv	a0,s6
    5c04:	de7ff0ef          	jal	59ea <printint>
    5c08:	8ba6                	mv	s7,s1
      state = 0;
    5c0a:	4981                	li	s3,0
    5c0c:	b5c9                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c0e:	008b8493          	addi	s1,s7,8
    5c12:	4681                	li	a3,0
    5c14:	4629                	li	a2,10
    5c16:	000bb583          	ld	a1,0(s7)
    5c1a:	855a                	mv	a0,s6
    5c1c:	dcfff0ef          	jal	59ea <printint>
        i += 1;
    5c20:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c22:	8ba6                	mv	s7,s1
      state = 0;
    5c24:	4981                	li	s3,0
    5c26:	b565                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c28:	008b8493          	addi	s1,s7,8
    5c2c:	4681                	li	a3,0
    5c2e:	4629                	li	a2,10
    5c30:	000bb583          	ld	a1,0(s7)
    5c34:	855a                	mv	a0,s6
    5c36:	db5ff0ef          	jal	59ea <printint>
        i += 2;
    5c3a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c3c:	8ba6                	mv	s7,s1
      state = 0;
    5c3e:	4981                	li	s3,0
        i += 2;
    5c40:	b579                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5c42:	008b8493          	addi	s1,s7,8
    5c46:	4681                	li	a3,0
    5c48:	4641                	li	a2,16
    5c4a:	000be583          	lwu	a1,0(s7)
    5c4e:	855a                	mv	a0,s6
    5c50:	d9bff0ef          	jal	59ea <printint>
    5c54:	8ba6                	mv	s7,s1
      state = 0;
    5c56:	4981                	li	s3,0
    5c58:	bd9d                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5c5a:	008b8493          	addi	s1,s7,8
    5c5e:	4681                	li	a3,0
    5c60:	4641                	li	a2,16
    5c62:	000bb583          	ld	a1,0(s7)
    5c66:	855a                	mv	a0,s6
    5c68:	d83ff0ef          	jal	59ea <printint>
        i += 1;
    5c6c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5c6e:	8ba6                	mv	s7,s1
      state = 0;
    5c70:	4981                	li	s3,0
    5c72:	bdb1                	j	5ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5c74:	008b8493          	addi	s1,s7,8
    5c78:	4641                	li	a2,16
    5c7a:	000bb583          	ld	a1,0(s7)
    5c7e:	855a                	mv	a0,s6
    5c80:	d6bff0ef          	jal	59ea <printint>
        i += 2;
    5c84:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5c86:	8ba6                	mv	s7,s1
      state = 0;
    5c88:	4981                	li	s3,0
        i += 2;
    5c8a:	b591                	j	5ace <vprintf+0x44>
    5c8c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5c8e:	008b8793          	addi	a5,s7,8
    5c92:	8cbe                	mv	s9,a5
    5c94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5c98:	03000593          	li	a1,48
    5c9c:	855a                	mv	a0,s6
    5c9e:	d2fff0ef          	jal	59cc <putc>
  putc(fd, 'x');
    5ca2:	07800593          	li	a1,120
    5ca6:	855a                	mv	a0,s6
    5ca8:	d25ff0ef          	jal	59cc <putc>
    5cac:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5cae:	00003b97          	auipc	s7,0x3
    5cb2:	d1ab8b93          	addi	s7,s7,-742 # 89c8 <digits>
    5cb6:	03c9d793          	srli	a5,s3,0x3c
    5cba:	97de                	add	a5,a5,s7
    5cbc:	0007c583          	lbu	a1,0(a5)
    5cc0:	855a                	mv	a0,s6
    5cc2:	d0bff0ef          	jal	59cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5cc6:	0992                	slli	s3,s3,0x4
    5cc8:	34fd                	addiw	s1,s1,-1
    5cca:	f4f5                	bnez	s1,5cb6 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
    5ccc:	8be6                	mv	s7,s9
      state = 0;
    5cce:	4981                	li	s3,0
    5cd0:	6ca2                	ld	s9,8(sp)
    5cd2:	bbf5                	j	5ace <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5cd4:	008b8493          	addi	s1,s7,8
    5cd8:	000bc583          	lbu	a1,0(s7)
    5cdc:	855a                	mv	a0,s6
    5cde:	cefff0ef          	jal	59cc <putc>
    5ce2:	8ba6                	mv	s7,s1
      state = 0;
    5ce4:	4981                	li	s3,0
    5ce6:	b3e5                	j	5ace <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5ce8:	008b8993          	addi	s3,s7,8
    5cec:	000bb483          	ld	s1,0(s7)
    5cf0:	cc91                	beqz	s1,5d0c <vprintf+0x282>
        for (; *s; s++)
    5cf2:	0004c583          	lbu	a1,0(s1)
    5cf6:	c195                	beqz	a1,5d1a <vprintf+0x290>
          putc(fd, *s);
    5cf8:	855a                	mv	a0,s6
    5cfa:	cd3ff0ef          	jal	59cc <putc>
        for (; *s; s++)
    5cfe:	0485                	addi	s1,s1,1
    5d00:	0004c583          	lbu	a1,0(s1)
    5d04:	f9f5                	bnez	a1,5cf8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5d06:	8bce                	mv	s7,s3
      state = 0;
    5d08:	4981                	li	s3,0
    5d0a:	b3d1                	j	5ace <vprintf+0x44>
          s = "(null)";
    5d0c:	00003497          	auipc	s1,0x3
    5d10:	c0c48493          	addi	s1,s1,-1012 # 8918 <malloc+0x2ada>
        for (; *s; s++)
    5d14:	02800593          	li	a1,40
    5d18:	b7c5                	j	5cf8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5d1a:	8bce                	mv	s7,s3
      state = 0;
    5d1c:	4981                	li	s3,0
    5d1e:	bb45                	j	5ace <vprintf+0x44>
        putc(fd, '%');
    5d20:	85be                	mv	a1,a5
    5d22:	855a                	mv	a0,s6
    5d24:	ca9ff0ef          	jal	59cc <putc>
    5d28:	bdbd                	j	5ba6 <vprintf+0x11c>
    5d2a:	6906                	ld	s2,64(sp)
    5d2c:	79e2                	ld	s3,56(sp)
    5d2e:	7a42                	ld	s4,48(sp)
    5d30:	7aa2                	ld	s5,40(sp)
    5d32:	7b02                	ld	s6,32(sp)
    5d34:	6be2                	ld	s7,24(sp)
    5d36:	6c42                	ld	s8,16(sp)
    }
  }
}
    5d38:	60e6                	ld	ra,88(sp)
    5d3a:	6446                	ld	s0,80(sp)
    5d3c:	64a6                	ld	s1,72(sp)
    5d3e:	6125                	addi	sp,sp,96
    5d40:	8082                	ret
      if (c0 == 'd') {
    5d42:	06400713          	li	a4,100
    5d46:	e6e782e3          	beq	a5,a4,5baa <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    5d4a:	f9478693          	addi	a3,a5,-108
    5d4e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5d52:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5d54:	4701                	li	a4,0
    5d56:	bbe9                	j	5b30 <vprintf+0xa6>

0000000000005d58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5d58:	715d                	addi	sp,sp,-80
    5d5a:	ec06                	sd	ra,24(sp)
    5d5c:	e822                	sd	s0,16(sp)
    5d5e:	1000                	addi	s0,sp,32
    5d60:	e010                	sd	a2,0(s0)
    5d62:	e414                	sd	a3,8(s0)
    5d64:	e818                	sd	a4,16(s0)
    5d66:	ec1c                	sd	a5,24(s0)
    5d68:	03043023          	sd	a6,32(s0)
    5d6c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5d70:	8622                	mv	a2,s0
    5d72:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5d76:	d15ff0ef          	jal	5a8a <vprintf>
}
    5d7a:	60e2                	ld	ra,24(sp)
    5d7c:	6442                	ld	s0,16(sp)
    5d7e:	6161                	addi	sp,sp,80
    5d80:	8082                	ret

0000000000005d82 <printf>:

void
printf(const char *fmt, ...)
{
    5d82:	711d                	addi	sp,sp,-96
    5d84:	ec06                	sd	ra,24(sp)
    5d86:	e822                	sd	s0,16(sp)
    5d88:	1000                	addi	s0,sp,32
    5d8a:	e40c                	sd	a1,8(s0)
    5d8c:	e810                	sd	a2,16(s0)
    5d8e:	ec14                	sd	a3,24(s0)
    5d90:	f018                	sd	a4,32(s0)
    5d92:	f41c                	sd	a5,40(s0)
    5d94:	03043823          	sd	a6,48(s0)
    5d98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5d9c:	00840613          	addi	a2,s0,8
    5da0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5da4:	85aa                	mv	a1,a0
    5da6:	4505                	li	a0,1
    5da8:	ce3ff0ef          	jal	5a8a <vprintf>
}
    5dac:	60e2                	ld	ra,24(sp)
    5dae:	6442                	ld	s0,16(sp)
    5db0:	6125                	addi	sp,sp,96
    5db2:	8082                	ret

0000000000005db4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5db4:	1141                	addi	sp,sp,-16
    5db6:	e406                	sd	ra,8(sp)
    5db8:	e022                	sd	s0,0(sp)
    5dba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5dbc:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5dc0:	00003797          	auipc	a5,0x3
    5dc4:	7207b783          	ld	a5,1824(a5) # 94e0 <freep>
    5dc8:	a095                	j	5e2c <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    5dca:	ff852583          	lw	a1,-8(a0)
    5dce:	6390                	ld	a2,0(a5)
    5dd0:	02059813          	slli	a6,a1,0x20
    5dd4:	01c85693          	srli	a3,a6,0x1c
    5dd8:	96ba                	add	a3,a3,a4
    5dda:	02d60563          	beq	a2,a3,5e04 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5dde:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    5de2:	4790                	lw	a2,8(a5)
    5de4:	02061593          	slli	a1,a2,0x20
    5de8:	01c5d693          	srli	a3,a1,0x1c
    5dec:	96be                	add	a3,a3,a5
    5dee:	02d70263          	beq	a4,a3,5e12 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5df2:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5df4:	00003717          	auipc	a4,0x3
    5df8:	6ef73623          	sd	a5,1772(a4) # 94e0 <freep>
}
    5dfc:	60a2                	ld	ra,8(sp)
    5dfe:	6402                	ld	s0,0(sp)
    5e00:	0141                	addi	sp,sp,16
    5e02:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5e04:	4614                	lw	a3,8(a2)
    5e06:	9ead                	addw	a3,a3,a1
    5e08:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5e0c:	6394                	ld	a3,0(a5)
    5e0e:	6290                	ld	a2,0(a3)
    5e10:	b7f9                	j	5dde <free+0x2a>
    p->s.size += bp->s.size;
    5e12:	ff852703          	lw	a4,-8(a0)
    5e16:	9f31                	addw	a4,a4,a2
    5e18:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5e1a:	ff053703          	ld	a4,-16(a0)
    5e1e:	bfd1                	j	5df2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5e20:	6394                	ld	a3,0(a5)
    5e22:	00d7e463          	bltu	a5,a3,5e2a <free+0x76>
    5e26:	fad762e3          	bltu	a4,a3,5dca <free+0x16>
    5e2a:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5e2c:	fee7fae3          	bgeu	a5,a4,5e20 <free+0x6c>
    5e30:	6394                	ld	a3,0(a5)
    5e32:	f8d76ce3          	bltu	a4,a3,5dca <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5e36:	f8d7fae3          	bgeu	a5,a3,5dca <free+0x16>
    5e3a:	87b6                	mv	a5,a3
    5e3c:	bfc5                	j	5e2c <free+0x78>

0000000000005e3e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5e3e:	7139                	addi	sp,sp,-64
    5e40:	fc06                	sd	ra,56(sp)
    5e42:	f822                	sd	s0,48(sp)
    5e44:	f04a                	sd	s2,32(sp)
    5e46:	ec4e                	sd	s3,24(sp)
    5e48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5e4a:	02051993          	slli	s3,a0,0x20
    5e4e:	0209d993          	srli	s3,s3,0x20
    5e52:	09bd                	addi	s3,s3,15
    5e54:	0049d993          	srli	s3,s3,0x4
    5e58:	2985                	addiw	s3,s3,1
    5e5a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5e5c:	00003517          	auipc	a0,0x3
    5e60:	68453503          	ld	a0,1668(a0) # 94e0 <freep>
    5e64:	c905                	beqz	a0,5e94 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5e66:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5e68:	4798                	lw	a4,8(a5)
    5e6a:	09377663          	bgeu	a4,s3,5ef6 <malloc+0xb8>
    5e6e:	f426                	sd	s1,40(sp)
    5e70:	e852                	sd	s4,16(sp)
    5e72:	e456                	sd	s5,8(sp)
    5e74:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5e76:	8a4e                	mv	s4,s3
    5e78:	6705                	lui	a4,0x1
    5e7a:	00e9f363          	bgeu	s3,a4,5e80 <malloc+0x42>
    5e7e:	6a05                	lui	s4,0x1
    5e80:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5e84:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5e88:	00003497          	auipc	s1,0x3
    5e8c:	65848493          	addi	s1,s1,1624 # 94e0 <freep>
  if (p == SBRK_ERROR)
    5e90:	5afd                	li	s5,-1
    5e92:	a83d                	j	5ed0 <malloc+0x92>
    5e94:	f426                	sd	s1,40(sp)
    5e96:	e852                	sd	s4,16(sp)
    5e98:	e456                	sd	s5,8(sp)
    5e9a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5e9c:	0000a797          	auipc	a5,0xa
    5ea0:	e6c78793          	addi	a5,a5,-404 # fd08 <base>
    5ea4:	00003717          	auipc	a4,0x3
    5ea8:	62f73e23          	sd	a5,1596(a4) # 94e0 <freep>
    5eac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5eae:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5eb2:	b7d1                	j	5e76 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5eb4:	6398                	ld	a4,0(a5)
    5eb6:	e118                	sd	a4,0(a0)
    5eb8:	a899                	j	5f0e <malloc+0xd0>
  hp->s.size = nu;
    5eba:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5ebe:	0541                	addi	a0,a0,16
    5ec0:	ef5ff0ef          	jal	5db4 <free>
  return freep;
    5ec4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5ec6:	c125                	beqz	a0,5f26 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5ec8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5eca:	4798                	lw	a4,8(a5)
    5ecc:	03277163          	bgeu	a4,s2,5eee <malloc+0xb0>
    if (p == freep)
    5ed0:	6098                	ld	a4,0(s1)
    5ed2:	853e                	mv	a0,a5
    5ed4:	fef71ae3          	bne	a4,a5,5ec8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5ed8:	8552                	mv	a0,s4
    5eda:	a0fff0ef          	jal	58e8 <sbrk>
  if (p == SBRK_ERROR)
    5ede:	fd551ee3          	bne	a0,s5,5eba <malloc+0x7c>
        return 0;
    5ee2:	4501                	li	a0,0
    5ee4:	74a2                	ld	s1,40(sp)
    5ee6:	6a42                	ld	s4,16(sp)
    5ee8:	6aa2                	ld	s5,8(sp)
    5eea:	6b02                	ld	s6,0(sp)
    5eec:	a03d                	j	5f1a <malloc+0xdc>
    5eee:	74a2                	ld	s1,40(sp)
    5ef0:	6a42                	ld	s4,16(sp)
    5ef2:	6aa2                	ld	s5,8(sp)
    5ef4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5ef6:	fae90fe3          	beq	s2,a4,5eb4 <malloc+0x76>
        p->s.size -= nunits;
    5efa:	4137073b          	subw	a4,a4,s3
    5efe:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5f00:	02071693          	slli	a3,a4,0x20
    5f04:	01c6d713          	srli	a4,a3,0x1c
    5f08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5f0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5f0e:	00003717          	auipc	a4,0x3
    5f12:	5ca73923          	sd	a0,1490(a4) # 94e0 <freep>
      return (void *)(p + 1);
    5f16:	01078513          	addi	a0,a5,16
  }
}
    5f1a:	70e2                	ld	ra,56(sp)
    5f1c:	7442                	ld	s0,48(sp)
    5f1e:	7902                	ld	s2,32(sp)
    5f20:	69e2                	ld	s3,24(sp)
    5f22:	6121                	addi	sp,sp,64
    5f24:	8082                	ret
    5f26:	74a2                	ld	s1,40(sp)
    5f28:	6a42                	ld	s4,16(sp)
    5f2a:	6aa2                	ld	s5,8(sp)
    5f2c:	6b02                	ld	s6,0(sp)
    5f2e:	b7f5                	j	5f1a <malloc+0xdc>
