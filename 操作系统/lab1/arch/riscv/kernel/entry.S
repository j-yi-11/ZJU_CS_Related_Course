.section .text.entry

.global trap_s
.extern handler_s
.equ reg_size, 0x8
.align 2

trap_s:
	# TODO: save the caller saved registers and sepc
    
		#sscratch上下文保存寄存器，暂时存储sp
		csrw sscratch, sp #sscratch = sp
		#操作sp
		addi sp, sp, -33*reg_size 
		#存x0～x31 sp暂时不动
		sd x0, 0*reg_size(sp)
		sd x1, 1*reg_size(sp)
		sd x3, 3*reg_size(sp)
		sd x4, 4*reg_size(sp)
		sd x5, 5*reg_size(sp)
		sd x6, 6*reg_size(sp)
		sd x7, 7*reg_size(sp)
		sd x8, 8*reg_size(sp)
		sd x9, 9*reg_size(sp)
		sd x10, 10*reg_size(sp)
		sd x11, 11*reg_size(sp)
		sd x12, 12*reg_size(sp)
		sd x13, 13*reg_size(sp)
		sd x14, 14*reg_size(sp)
		sd x15, 15*reg_size(sp)
		sd x16, 16*reg_size(sp)
		sd x17, 17*reg_size(sp)
		sd x18, 18*reg_size(sp)
		sd x19, 19*reg_size(sp)
		sd x20, 20*reg_size(sp)
		sd x21, 21*reg_size(sp)
		sd x22, 22*reg_size(sp)
		sd x23, 23*reg_size(sp)
		sd x24, 24*reg_size(sp)
		sd x25, 25*reg_size(sp)
		sd x26, 26*reg_size(sp)
		sd x27, 27*reg_size(sp)
		sd x28, 28*reg_size(sp)
		sd x29, 29*reg_size(sp)
		sd x30, 30*reg_size(sp)
		sd x31, 31*reg_size(sp)
		#存储sepc
		csrr t0, sepc # t0 = sepc
		sd t0, 32*reg_size(sp) #mem[sp+32*reg_size] = t0 = sepc
		csrr t0, sscratch # t0 = sp
		csrw sscratch, x0
		sd t0, 2*reg_size(sp) #mem[sp+2*reg_size] = t0 = sp


	# TODO: call handler_s(scause)
	
		csrr a0, scause
		csrr a1, sepc
		jal ra, handler_s

	# TODO: load sepc and caller saved registers
		ld t0, 32*reg_size(sp)
		csrw sepc, t0
		ld x31, 31*reg_size(sp)
		ld x30, 30*reg_size(sp)
		ld x29, 29*reg_size(sp)
		ld x28, 28*reg_size(sp)
		ld x27, 27*reg_size(sp)
		ld x26, 26*reg_size(sp)
		ld x25, 25*reg_size(sp)
		ld x24, 24*reg_size(sp)
		ld x23, 23*reg_size(sp)
		ld x22, 22*reg_size(sp)
		ld x21, 21*reg_size(sp)
		ld x20, 20*reg_size(sp)
		ld x19, 19*reg_size(sp)
		ld x18, 18*reg_size(sp)
		ld x17, 17*reg_size(sp)
		ld x16, 16*reg_size(sp)
		ld x15, 15*reg_size(sp)
		ld x14, 14*reg_size(sp)
		ld x13, 13*reg_size(sp)
		ld x12, 12*reg_size(sp)
		ld x11, 11*reg_size(sp)
		ld x10, 10*reg_size(sp)
		ld x9, 9*reg_size(sp)
		ld x8, 8*reg_size(sp)
		ld x7, 7*reg_size(sp)
		ld x6, 6*reg_size(sp)
		ld x5, 5*reg_size(sp)
		ld x4, 4*reg_size(sp)
		ld x3, 3*reg_size(sp)
		ld x1, 1*reg_size(sp)
		ld x0, 0*reg_size(sp)

		ld x2, 2*reg_size(sp)

	
	sret