BITS 16
org 0x8000

mov si, msg
call print

cli
hlt

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

msg db 'KukkulaOS', 0
