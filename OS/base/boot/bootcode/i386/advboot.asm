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

start:
    mov bx, 0xA000
    mov es, bx
    mov di, 0xA100

    call do_e820
    call go_pm

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

mmap_ent equ 0x9000                                         ; The number of entries will be stored in 0x8000

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
    mov [es:di + 20], 1                                     ; Force a valid ACPI entry
    mov ecx, 24                                             ; Ask for 24 bytes
    int 0x15
    jc .err_int15_unsupported                               ; If carry flag is set, it means unsupported function
    mov edx, 0x0534D4150                                    ; on success, eax must be reset to "SMAP"
    jne .err_int15_unsupported
    test ebx, ebx                                           ; ebx = 0 implies list is only 1 entry long
    je .err_bad_memory_info
    jmp .jmpin
.e820lp:
    mov eax, 0xe820                                         ; eax gets trashed on every int15 call
    mov [es:di + 20], 1                                     ; Force a valid ACPI 3 entry
    mov ecx, 24                                             ; Ask for 24 bytes
    int 0x15                                                
    jc .e820f                                               ; Carry flag means end of list is already reached
    mov edx, 0x0534D4150 
.jmpin:
    jcxz .skipent                                           ; Skip any entries with length 0
    cmp cl, 20                                              ; Got a 24 byte ACPI response?
    jbe .notext
    test byte [es:di + 20], 1                               ; If so, is the ingore this data bit clear?
    je .skipent
.notext:
    mov ecx, [es:di + 8]                                    ; Get lower UINT of memory region length
    or ecx, [es:di + 12]                                    ; "or" it with upper UINT to test for zero
    jz .skipent                                             ; If len is zero, skip entry
    inc bp                                                  ; Got a good entry? ++count, move to next spot
    add di, 24
.skipent:
    test ebx, ebx                                           ; If ebx resets to 0, list is complete
    jne .e820lp 
.e820f:
    mov [es:mmap_ent], bp                                   ; Store the entry count
    clc                                                     ; Clear carry flag
    ret
.err_int15_unsupported:
    mov si, MSG_UNSUPPORTED_FUNC
    call print
    cli 
    hlt 
.err_bad_memory_info:
    mov si, MSG_BAD_MEMINFO
    call print 
    cli 
    hlt

;
; We will now set up the global descriptor table.
gdt:
.null_desc:
    dq 0
;
; This is the initial code descriptor for the global descriptor table. The kernel
; will later create a new global descriptor table.
.code_desc:
    dw 0xffff                                               ; Segment limit
    dw 0x0000                                               ; Base first 0-15 bites
    db 0x00                                                 ; Base 16-23 bites
    db 0x9a                                                 ; Access byte
    db 0b11001111                                           ; high 4 bits(flags) low 4 bits(limit 4 last bits)
    db 0x00                                                 ; base 24-31 bits
;
; This is the data descriptor. Offset is at 0x10 and the ds, es, fs, gs and ss registers should all point
; to this descriptor
.data_desc:
    dw 0xffff                                               ; Segment limit first 0-15 bits
    dw 0x0000                                               ; base first 0-15 bits
    db 0x00                                                 ; base 16-23 bits
    db 0x92                                                 ; access byte
    db 0b11001111                                           ; high 4 bits (flags) low 4 bits(limit 4 last bits)
    db 0x00                                                 ; base 24-31 bits
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1                                    ; GDT limit
    dd gdt                                                  ; GDT base

go_pm:
    mov si, MSG_INIT_GDT
    call print
    cli                                                     ; Disable interrupts
    lgdt [gdt_descriptor]                                   ; Load GDT registers with the start adress of the GDT
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:FindKernel

    ;
    ; Perform a far jump to selector 08h (offset into GDT pointing at a 32bit PM code segment descriptor)
    jmp 08h:FindKernel

;
; We are now in 32 bit protected mode. The standard bios interrupts do not work from now on
BITS 32
FindKernel:
    mov ax, 0x10 
    mov ds, ax 
    mov es, ax 
    mov fs, ax 
    mov gs, ax 
    mov ss, ax


MSG_INSPECT_MEM db 'OSLOADER is now examining the memory configuration...', 0xd, 0
MSG_UNSUPPORTED_FUNC db 'int15 is unsupported.', 0xd, 0
MSG_BAD_MEMINFO db 'OSLOADER got an invalid memory map.', 0xd, 0
MSG_INIT_GDT db 'Jumping to 32bit protected mode...', 0xd, 0