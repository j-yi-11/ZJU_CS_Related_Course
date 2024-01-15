
vmlinux:     file format elf64-littleriscv


Disassembly of section .user_program:

ffffffc000004000 <user_program_start>:
ffffffc000004000:	ff810113          	addi	sp,sp,-8
ffffffc000004004:	00a12023          	sw	a0,0(sp)
ffffffc000004008:	00b12223          	sw	a1,4(sp)
ffffffc00000400c:	00100513          	li	a0,1
ffffffc000004010:	00100593          	li	a1,1
ffffffc000004014:	00810113          	addi	sp,sp,8
ffffffc000004018:	fe9ff06f          	j	ffffffc000004000 <user_program_start>
	...

ffffffc000005000 <test2>:
ffffffc000005000:	ff810113          	addi	sp,sp,-8
ffffffc000005004:	00a12023          	sw	a0,0(sp)
ffffffc000005008:	00b12223          	sw	a1,4(sp)
ffffffc00000500c:	00200513          	li	a0,2
ffffffc000005010:	00200593          	li	a1,2
ffffffc000005014:	00810113          	addi	sp,sp,8
ffffffc000005018:	fe9ff06f          	j	ffffffc000005000 <test2>
	...

ffffffc000006000 <test3>:
ffffffc000006000:	ff810113          	addi	sp,sp,-8
ffffffc000006004:	00a12023          	sw	a0,0(sp)
ffffffc000006008:	00b12223          	sw	a1,4(sp)
ffffffc00000600c:	00300513          	li	a0,3
ffffffc000006010:	00300593          	li	a1,3
ffffffc000006014:	00810113          	addi	sp,sp,8
ffffffc000006018:	fe9ff06f          	j	ffffffc000006000 <test3>
	...

ffffffc000007000 <test4>:
ffffffc000007000:	ff810113          	addi	sp,sp,-8
ffffffc000007004:	00a12023          	sw	a0,0(sp)
ffffffc000007008:	00b12223          	sw	a1,4(sp)
ffffffc00000700c:	00400513          	li	a0,4
ffffffc000007010:	00400593          	li	a1,4
ffffffc000007014:	00810113          	addi	sp,sp,8
ffffffc000007018:	fe9ff06f          	j	ffffffc000007000 <test4>
	...

ffffffc000008000 <test5>:
ffffffc000008000:	ff810113          	addi	sp,sp,-8
ffffffc000008004:	00a12023          	sw	a0,0(sp)
ffffffc000008008:	00b12223          	sw	a1,4(sp)
ffffffc00000800c:	00500513          	li	a0,5
ffffffc000008010:	00500593          	li	a1,5
ffffffc000008014:	00810113          	addi	sp,sp,8
ffffffc000008018:	fe9ff06f          	j	ffffffc000008000 <test5>
	...
