; Author: Dylan Turner
; Description: Used for printing while in real mode

[bits 16]

print16:
    push    ax
    push    bx

    mov     ah, 0x0E
print16_loop:
    cmp     [bx], byte 0
    je      print16_done

    mov     al, [bx]
    int 0x10

    inc     bx
    jmp     print16_loop
print16_done:
    pop     bx
    pop     ax
    ret
