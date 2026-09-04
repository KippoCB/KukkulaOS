;========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
;
; File:
;      hal_interrupts.asm
;
; Purpose:
;      Contains the i386 specific routines to intialize the gdt
;
; Edits:
;       KippoCB
;             * Create | 3.9.2026
;
;=======================================================================
BITS 32

;
; This routine initializes the global descriptor table. This is needed for
; the memory paging and memory protection to work at all.
gdt:
.null_desc:
    dq 0                                                    ; This is the null descriptor for the gdt
;
; This is the code descriptor for our gdt
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

_hal_gdtInit@0:
    lgdt[gdt_descriptor]                                    ; Load the GDI

    ; Reload the segment registers
    mov ax, 0x10                                            ; Data descriptor
    mov ds, ax 
    mov es, ax 
    mov fs, ax 
    mov gs, ax 
    mov ss, ax 

    ;
    ; Reload cs with a far jump
    jmp 0x08:.reload_cs
.reload_cs:
    ret