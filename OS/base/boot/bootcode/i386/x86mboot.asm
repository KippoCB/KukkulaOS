;========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
;
; File:
;      x86mboot.asm
;
; Purpose:
;      Contains the routines to load the operating system from the disk.
;      It will:
;           1. Check for the extended disk read capabilities(xint13)
;           2. Parse the partition table to find the active bootable
;              partition marked by the active flag(0x80).
;           3. If we find a proper partition table entry with the active
;              flag set, we will construct an Disk Adress Packet(DAP)
;              and send it to the CPU.
;           4. After the DAP is properly set up we will read the disk
;              using the extended int13 read BIOS service and jump to
;              the start chs stored in the DAP.
;
; Edits:
;       KippoCB
;             * Create | 3.9.2026
;
;=======================================================================
BITS 16
org 0x7c00

;
; Bootloader constants
MBR_START_OFFSET            equ 0x7c00
PART_TAB_START_OFFSET       equ 0x1BE
PART_TAB_ENTRY_COUNT        equ 4
PART_TAB_ACTIVE_FLAG        equ 0x80
PART_TAB_ENTRY_SIZE         equ 16
RETRY_MAX_COUNT             equ 4

;
; Set up the stack and segment registers as on startup the BIOS will leave these into unpredictable states.
start:
    jmp 0x0000:init                                         ; Far jump to explicitly set cs to 0x0000

init:
    ;
    ; Clear out the data segments
    xor ax, ax 
    mov ds, ax 
    mov es, ax 

    mov [boot_drive], dl

    call check_xint13
    call find_active
    call read_disk
.halt:
    cli 
    hlt 
    jmp .halt 

;
; This routine handles printing a string onto the screen. 
; si = the message. Each message has to be zero terminated 
; or the loop will run into garbage.
print:
    mov ah, 0x0E
.loop:
    mov al, [si]                                            ; Get the character from si
    cmp al, 0                                               ; Is this the end of string?
    jz .done                                                ; Yes, stop the loop and return the execution to the caller
    int 0x10                                                ; No, print the character
    inc si                                                  ; Load the next character 
    jmp .loop                                               ; Loop till done
.done:
    ret

;
; This routine performs a check for xint13 support
check_xint13:
    mov ah, 0x41
    mov bx, 0x55AA
    mov dl, [boot_drive]

    int 0x13

    ;
    ; If read failed, xint13 is not supported
    jc .err_no_xint13

    ret
.err_no_xint13:
    mov si, MSG_NO_XINT13                               
    call print
    cli                                                     ; Disable interrupts
    hlt                                                     ; Halt the cpu

;
; This routine will find the partition table and the active partition. It will then parse the CHS values and 
; create the DAP.
find_active:
    mov si, MBR_START_OFFSET + PART_TAB_START_OFFSET        ; Move our index register to the start of the partition table
    mov cx, PART_TAB_ENTRY_COUNT                            ; Loop counter
.loop_slots:
    mov al, [si]                                            ; Move to the offset where the active flag is stored
    cmp al, 0x80                                            ; Check if this is the active partition
    je .active_found                                        ; If si = 0x80 this is the active partition, stop loop

    add si, PART_TAB_ENTRY_SIZE                             ; Go to the next entry
    loop .loop_slots
.err_no_active_partition:
    mov si, MSG_NO_ACTIVE_PART
    call print
    cli
    hlt 
.active_found:
    ;
    ; Extract the starting lba, we have to do this in two halves as the CPU is currently 16bit and the value is 32bits
    mov ax, [si + 8]                                        ; Lower 16 bits of starting lba
    mov bx, [si + 10]                                       ; Upper 16 bits of starting lba

    ;
    ; Put the values into the DAP
    mov [dap_lba_low], ax
    mov [dap_lba_high], bx 

    ;
    ; Extract the total sector count. This again is a 32bit value
    mov cx, [si + 12]                                       ; Lower 16 bits of sector count
    mov dx, [si + 14]                                       ; Higher 16 bits of sector count
    ret

;
; This routine will try to read the disk using the CHS values from the disk adress packet.
read_disk:
    mov ah, 0x42                                            ; Extended disk read
    mov dl, [boot_drive]                                    ; Drive number is the boot drive
    mov si, disk_address_packet                             ; 
    int 0x13
    jc .err_diskread_fail
    jmp 0x0000:0x8000
.err_diskread_fail:
    mov si, MSG_DISKREAD_FAIL
    call print 
    cli 
    hlt

;
; The disk adress packet structure.
align 4
disk_address_packet:
    db 0x10                                                 ; Size of the packet
    db 0x00                                                 ; Reserved
    dw 0x0001                                               ; Number of sectors to read
    dw 0x8000                                               ; Target buffer offset
    dw 0x0000                                               ; Target buffer segment
dap_lba_low:    dw 0x0000                                   ; Lower LBA bytes go here
dap_lba_high:   dw 0x0000                                   ; Upper LBA bytes go here
                dw 0x0000                                   ; Zeroes for the remaining 32bits of the lba
                dw 0x0000

boot_drive db 0 

;
; Messages used by the bootloader. Each of these have to be zero terminated as the message printing function 
; is zero terminated and will execute untill it finds an zero or runs into garbage memory which causes an crash.
MSG_NO_XINT13 db 'Your system does not support xint13.', 0
MSG_NO_ACTIVE_PART db 'No active (bootable) partition was found.', 0
MSG_DISKREAD_FAIL db 'Could not read the disk.', 0

times 446-($-$$) db 0

;
; Partition table slot 1
db 0x80
db 0, 1, 0 
db 0x83
db 0, 1, 0
dd 100
dd 1000

; Slots 2 - 4  are empty
times 16 db 0
times 16 db 0
times 16 db 0

dw 0xAA55