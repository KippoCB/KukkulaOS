PROJDIR="../"
NASMCMD="../buildtools/nasm/nasm.exe"
DDCMD="../buildtools/dd.exe"
QEMUCMD="../buildtools/qemu/qemu-system-i386.exe"
CC="../buildtools/i386/bin/gcc"

init:
	mkdir ${PROJDIR}/out

asm:
	${NASMCMD} ${PROJDIR}/OS/base/boot/bootcode/i386/x86mboot.asm -f bin -o ${PROJDIR}/out/BOOT.BIN
	${NASMCMD} ${PROJDIR}/OS/base/boot/bootcode/i386/advboot.asm -f bin -o ${PROJDIR}/out/ADVBOOT.BIN
	${NASMCMD} ${PROJDIR}/OS/base/HAL/i386/hal_gdt.asm -f win32 -o ${PROJDIR}/out/hal_gdt.o
	${NASMCMD} ${PROJDIR}/OS/base/HAL/i386/hal_port.asm -f win32 -o ${PROJDIR}/out/hal_port.o
	${NASMCMD} ${PROJDIR}/OS/base/HAL/i386/hal_interrupts.asm -f win32 -o ${PROJDIR}/out/hal_interrupts.o
	${NASMCMD} ${PROJDIR}/OS/base/HAL/i386/hal_halt.asm -f win32 -o ${PROJDIR}/out/hal_halt.o

cc:
	${CC} -c ${PROJDIR}/OS/ntos/ntoskrnl.c -I${PROJDIR}/OS/base -ffreestanding -nostdlib -o ${PROJDIR}/out/ntoskrnl.o
	${CC} -c ${PROJDIR}/OS/base/HAL/i386/hal_serialWriteLine.c -I${PROJDIR}/OS/base -ffreestanding -nostdlib -o ${PROJDIR}/out/hal_serialWriteLine.o

kernel:
	${CC} -m32 -nostdlib -Wl,-e,kmain \
  		${PROJDIR}/out/hal_gdt.o \
  		${PROJDIR}/out/hal_halt.o \
  		${PROJDIR}/out/hal_interrupts.o \
  		${PROJDIR}/out/hal_port.o \
  		${PROJDIR}/out/hal_serialWriteLine.o \
  		${PROJDIR}/out/ntoskrnl.o \
  		-o ${PROJDIR}/out/ntoskrnl.exe

disk:
	${DDCMD} if=/dev/zero of=${PROJDIR}/out/DISK.IMG bs=1M count=64
	${DDCMD} if=${PROJDIR}/out/BOOT.BIN of=${PROJDIR}/out/DISK.IMG conv=notrunc bs=512 count=1
	${DDCMD} if=${PROJDIR}/out/ADVBOOT.BIN of=${PROJDIR}/out/DISK.IMG conv=notrunc bs=512 count=1 seek=100	

run:
	${QEMUCMD} -drive format=raw,file=${PROJDIR}/out/DISK.IMG

clean:
	rm -rf ${PROJDIR}/out
