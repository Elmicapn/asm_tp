section .data
    msg db "Hello Universe !", 10
    len equ $ - msg

section .text
    global _start

_start:
    mov     rbx, rsp
    mov     rdi, [rbx]


    mov     rdi, [rbx+16]
    mov     rax, 2
    mov     rsi, 577
    mov     rdx, 0644o
    syscall

    cmp     rax, 0
    js      badinput
    mov     rdi, rax

    mov     rax, 1
    mov     rsi, msg
    mov     rdx, len
    syscall

    mov     rax, 3
    syscall

    mov     eax, 60
    xor     edi, edi
    syscall

badinput:
    mov     eax, 60
    mov     edi, 2
    syscall
