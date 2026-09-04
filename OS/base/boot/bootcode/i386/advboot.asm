;========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
;
; File:
;      advboot.asm
;
; Purpose:
;      Contains the i386 specific code to find the memory map, load and
;      create a temporary GDT. It will then flip the bit in cr0 to go 
;      to the protected mode. We will also provide a memory map for the 
;      kernel so we can implement a physical memory allocator for the 
;      kernel.
;
; Edits:
;       KippoCB
;             * Create | 3.9.2026
;
;=======================================================================
BITS 16
org 0x8000


mmap_ent equ 0x8000                                         ; The number of entries will be stored in 0x8000
;
; This routine will get the memory map from the BIOS and provide it to 
; ntoskrnl.exe so it can allocate 4k blocks of memory
do_e820:
    mov si, MSG_INSPECT_MEM
    call print 
    xor ebx, ebx                                            ; Must be zero to start
    xor bp, bp                                              ; Keep an entry count here
    mov edx, 0x0534D4150                                    ; Place "SMAP" into edx
    mov eax, 0xe820
    mov [es:di + 20], dword 1                               ; Force a valid ACPI entry
    mov ecx, 24                                             ; Ask for 24 bytes
    int 0x15
    jc .err_int15_unsupported                               ; If carry flag is set, it means unsupported function
    mov edx, 0x0534D4150                                    ; on success, eax must be reset to "SMAP"
.err_int15_unsupported:


print:
    mov ah, 0x0e
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

MSG_INSPECT_MEM db 'OSLOADER is now examining the memory configuration...', 0
MSG_UNSUPPORTED_FUNC db 'int15 is unsupported.', 0