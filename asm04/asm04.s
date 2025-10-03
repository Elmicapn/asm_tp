section .bss
buf     resb    64

section .text
global _start

_start:
    ; read(0, buf, 64)
    mov     eax, 0
    mov     edi, 0
    lea     rsi, [rel buf]
    mov     edx, 64
    syscall

    xor     rcx, rcx
    lea     rbx, [rel buf]
    mov     r8, 0
    mov     r9, 0

    mov     al, [rbx]
    cmp     al, '-'
    jne     .check_plus
    mov     r9, 1
    inc     rbx
    jmp     .parse

.check_plus:
    cmp     al, '+'
    jne     .parse
    inc     rbx

.parse:
    mov     al, [rbx]
    cmp     al, 0x0A
    je      .done
    cmp     al, 0
    je      .done
    cmp     al, '0'
    jb      .badinput
    cmp     al, '9'
    ja      .badinput
    sub     al, '0'
    imul    rcx, rcx, 10
    add     rcx, rax
    inc     rbx
    inc     r8
    cmp     r8, 19
    ja      .badinput
    jmp     .parse

.done:
    cmp     r9, 0
    je      .check
    neg     rcx

.check:
    test    rcx, 1
    jz      .even
    jmp     .odd

.even:
    mov     eax, 60
    xor     edi, edi
    syscall

.odd:
    mov     eax, 60
    mov     edi, 1
    syscall

.badinput:
    mov     eax, 60
    mov     edi, 2
    syscall
