PROJDIR=E:/KukkulaOS
NASMCMD="C:/Program Files/NASM/nasm.exe"
DDCMD="C:/Program Files/DD/dd.exe"
QEMUCMD="C:/Program Files/qemu/qemu-system-i386.exe"

init:
	mkdir ${PROJDIR}/out

asm:
	${NASMCMD} ${PROJDIR}/OS/base/boot/bootcode/i386/x86mboot.asm -f bin -o ${PROJDIR}/out/BOOT.BIN
	${NASMCMD} ${PROJDIR}/OS/base/boot/bootcode/i386/advboot.asm -f bin -o ${PROJDIR}/out/ADVBOOT.BIN

disk:
	${DDCMD} if=/dev/zero of=${PROJDIR}/out/DISK.IMG bs=1M count=64
	${DDCMD} if=${PROJDIR}/out/BOOT.BIN of=${PROJDIR}/out/DISK.IMG conv=notrunc bs=512 count=1
	${DDCMD} if=${PROJDIR}/out/ADVBOOT.BIN of=${PROJDIR}/out/DISK.IMG conv=notrunc bs=512 count=1 seek=100	

run:
	${QEMUCMD} -drive format=raw,file=${PROJDIR}/out/DISK.IMG

clean:
	rm -rf ${PROJDIR}/out
