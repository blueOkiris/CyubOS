; Author: Dylan Turner
; Description: Enable paging stuff before jump to 64 bit

[bits 32]
page_table_entry    equ 0x1000

set_up_ident_paging:
    mov     edi, page_table_entry
    mov     cr3, edi
    mov     dword [edi], 0x2003
    add     edi, 0x1000
    mov     dword [edi], 0x3003
    add     edi, 0x1000
    mov     dword [edi], 0x4003
    add     edi, 0x1000

    mov     ebx, 0x00000003
    mov     ecx, 512            ; Loop 512 times (5 entries)

.set_entry:
    mov     dword [edi], ebx
    add     ebx, 0x1000
    add     edi, 8
    loop    .set_entry

    mov     eax, cr4
    or      eax, 1 << 5
    mov     cr4, eax

    ; Long mode enable
    mov     ecx, 0xC0000080
    rdmsr
    or      eax, 1 << 8
    wrmsr

    ; Enable paging
    mov     eax, cr0
    or      eax, 1 << 31
    mov     cr0, eax

    ret
