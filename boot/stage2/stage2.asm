; Author: Dylan Turner
; Description: 2nd stage bootloader to load kernel

[bits 16]

[global _start]

_start:
    jmp     enter_protected_mode

%include "print.asm"
%include "gdt.asm"
%include "cpuid.asm"
%include "simple_paging.asm"

[bits 16]

enter_protected_mode:
    call    enable_a20
    cli

    lgdt    [gdt_desc]
    mov     eax, cr0
    or      eax, 1
    mov     cr0, eax

    jmp     code_seg:start_protected_mode

enable_a20:
    in      al, 0x92
    or      al, 2
    out     0x92, al
    ret

[bits 32]

start_protected_mode:
    ; Point stack to correct new location
    mov     ax, data_seg
    mov     ds, ax
    mov     ss, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax
    
    call    assert_cpuid
    call    assert_long_mode
    call    set_up_ident_paging
    call    edit_gdt

    jmp     code_seg:start_64_bit

[bits 64]

[extern kernel_start]

start_64_bit:
    mov     edi, 0xB8000
    mov     rax, 0x1F201F201F201F20
    mov     ecx, 500
    rep     stosq

    call    kernel_start

    jmp     $

start_msg:  db "Starting kernel.", 0
done_msg:   db "Done.", 0
