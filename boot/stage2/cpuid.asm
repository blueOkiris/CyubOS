; Author: Dylan Turner
; Description: Detect cpuid and long mode stuff

[bits 32]

assert_cpuid:
    pushfd
    pop     eax

    mov     ecx, eax

    xor     eax, 1 << 21

    push    eax
    popfd

    pushfd
    pop     eax

    xor     eax, ecx
    jz      no_cpuid
    ret

assert_long_mode:
    mov     eax, 0x80000001
    cpuid
    test    edx, 1 << 29
    jz      no_long_mode
    ret

no_cpuid:
    mov     ebx, 0
no_cpuid_fill:
    push    ebx
    mov     eax, no_cpuid_err
    call    print32
    pop     ebx
    add     ebx, byte 80
    cmp     ebx, 160*20
    je      no_cpuid_done
    jmp     no_cpuid_fill
no_cpuid_done:
    hlt

no_long_mode:
    mov     ebx, 0
no_long_mode_fill:
    push    ebx
    mov     eax, no_long_mode_err
    call    print32
    pop     ebx
    add     ebx, 80
    cmp     ebx, 160*20
    jge     no_long_mode_done
    jmp     no_long_mode_fill
no_long_mode_done:
    hlt

no_cpuid_err        db "Error! CyubOS requires CPUID to work!   ", 0
no_long_mode_err    db "Error! CyubOS requires a 64 bit CPU!    ", 0
