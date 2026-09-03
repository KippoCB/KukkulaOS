;========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
;
; File:
;      hal_interrupts.asm
;
; Purpose:
;      Contains the routines to disable and enable processor interrupts
;
; Edits:
;       KippoCB
;             * Create | 3.9.2026
;
;=======================================================================
BITS 32

;
; Routine to disable the interrupts
_hal_disableInterrupts@0:
    cli
    ret

;
; Routine to re-enable interrupts
_hal_enableInterrupts@0:
    sti
    ret