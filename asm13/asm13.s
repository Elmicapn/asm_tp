section .bss
    inbuf resb 256

section .text
    global _start

_start:
    mov     eax, 0
    mov     edi, 0
    mov     rsi, inbuf
    mov     edx, 256
    syscall
    cmp     rax, 0
    jle     not_pal

    mov     rcx, rax
    dec     rcx 
    mov     rsi, inbuf
    lea     rdi, [inbuf+rcx-1]

.check:
    cmp     rsi, rdi
    jge     is_pal
    mov     al, [rsi]
    mov     bl, [rdi]
    cmp     al, bl
    jne     not_pal
    inc     rsi
    dec     rdi
    jmp     .check

is_pal:
    mov     eax, 60
    xor     edi, edi
    syscall

not_pal:
    mov     eax, 60
    mov     edi, 1
    syscall
