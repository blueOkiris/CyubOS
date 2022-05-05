; Author: Dylan Turner
; Description: Define isrs and loading for IDT in assembly bc they break in Rust lol

[global isr1]
[global idt_desc]
[global load_idt]

[extern IDT]
[extern isr1_handler]

[bits 64]

idt_desc:
    dw 4095
    dq IDT

%macro PUSHALL 0
    push    rax
    push    rcx
    push    rdx
    push    r8
    push    r9
    push    r10
    push    r11
%endmacro

%macro POPALL 0
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdx
    pop     rcx
    pop     rax
%endmacro

isr1:
    PUSHALL
    call isr1_handler
    POPALL
    iretq

load_idt:
    lidt    [idt_desc]
    sti
    ret
