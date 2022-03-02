; Author: Dylan Turner
; Description: Prints a message from pointer in 32 bit protected mode

[bits 32]

; Uses eax as start data address and ebx as start print address
print32:
    push ecx
print32_start:
    mov     cl, [eax]
    inc     eax

    cmp     cl, 0
    je      print32_done

    mov     [0xB8000 + ebx], byte cl
    inc     ebx
    inc     ebx

    jmp     print32_start
print32_done:
    pop     ecx
    ret

[bits 64]:

print64:
    push    rcx
print64_start:
    mov     cl, [rax]
    inc     rax

    cmp     cl, 0
    je      print64_done

    mov     [0xB8000 + rbx], byte cl
    inc     rbx
    inc     rbx

    jmp     print64_start
print64_done:
    pop     rcx
    ret

