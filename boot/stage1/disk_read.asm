; Author: Dylan Turner
; Description: Read a file from disk

[bits 16]

pgrm_space  equ 0x8000

read_disk:
    mov     ah, 0x02
    mov     bx, pgrm_space
    mov     al, 32              ; We'll say 32 sectors rn (16kB)
    mov     dl, [boot_disk]
    mov     ch, 0x00            ; cyllinder 0
    mov     dh, 0x00            ; head 0
    mov     cl, 0x02            ; 2nd sector

    int     0x13                ; read it

    jc      disk_read_failed

    ret

boot_disk:
    db 0

disk_read_err   db "Error! Disk read failed", 0

disk_read_failed:
    mov     bx, disk_read_err
    call    print16

    hlt
