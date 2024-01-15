# export 关键字定义的变量在调用子 Makefile 文件时依然有效
export
CROSS_  = riscv64-unknown-elf-
CC      = $(CROSS_)gcc
LD      = $(CROSS_)ld
OBJCOPY = $(CROSS_)objcopy

# gcc 编译相关参数
ISA     = rv64imafd
ABI     = lp64
INCLUDE = -I$(shell pwd)/include -I$(shell pwd)/arch/riscv/include
CF      = -g -march=$(ISA) -mabi=$(ABI) -mcmodel=medany -ffunction-sections -fdata-sections -nostartfiles -nostdlib -nostdinc -fno-builtin -static -lgcc 
CFLAG   = ${CF} ${INCLUDE}

# 磁盘映像产物
SFSIMG  = sfs.img

all: vmlinux

.PHONY: vmlinux run debug clean tools

tools:
	$(MAKE) -C tools all

$(SFSIMG): tools
	dd if=/dev/zero of=$@ bs=4KB count=4096
	./tools/mksfs $@
	@echo "\033[32mMake $@ Success! \033[0m"

vmlinux: $(SFSIMG)
	$(MAKE) -C arch/riscv all 
	$(LD) -T arch/riscv/kernel/vmlinux.lds arch/riscv/kernel/*.o arch/riscv/user/*.o -o vmlinux
	@$(shell test -d arch/riscv/boot || mkdir -p arch/riscv/boot)
	@$(OBJCOPY) -j .text -j .rodata -j .data -j .text.user_program -O binary vmlinux arch/riscv/boot/Image
	@echo "\033[32mMake vmlinux Success! \033[0m"

run: vmlinux
	@qemu-system-riscv64 \
		-nographic \
		-machine virt \
		-device loader,file=vmlinux \
		-drive file=$(SFSIMG),if=none,format=raw,id=x0 \
		-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
	
debug: vmlinux
	@qemu-system-riscv64 \
		-nographic \
		-machine virt \
		-device loader,file=vmlinux \
		-drive file=$(SFSIMG),if=none,format=raw,id=x0 \
		-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 \
		-S -s

clean:
	$(MAKE) -C arch/riscv clean
	$(MAKE) -C tools clean
	@$(shell test -f vmlinux && rm vmlinux)
	@$(shell test -f $(SFSIMG) && rm $(SFSIMG))
	@echo "\033[32mMake clean Success! \033[0m"