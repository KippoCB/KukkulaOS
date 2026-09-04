;========== Copyright (C) KukkulaOS 2026, All Rights Reserved ==========
;
; File:
;      hal_port.asm
;
; Purpose:
;      Contains the routines to read and write BYTEs from a port.
;
; Edits:
;       KippoCB
;             * Create | 3.9.2026
;
;=======================================================================
BITS 32

;
; Global symbols for the HAL functions
global _hal_readPortByte
global _hal_writePortByte

;
; Routine to read BYTE values from the specified port.
_hal_readPortByte@4:
    ;
    ; Find the parameter we passed to the function from the stack.
    ;
    ; Layout at the moment is:
    ; [esp + 4] = WORD port
    mov dx, [esp + 4]
    in dx, al 
    ret 4

;
; Routine to write a BYTE value to the specified port
_hal_writePortByte@8:
    ;
    ; Get the params
    ;
    ; Stack layout at the moment is:
    ; [esp + 4] = BYTE value
    ; [esp + 8] = WORD port
    mov dx, [esp + 4]
    mov al, [esp + 8]
    out al, dx
    ret 8