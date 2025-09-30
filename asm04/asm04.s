section .data

section .bss

    buf resb 32  

section .text

global _start

_start:

    mov eax, 0
    mov edi, 0 
    lea rsi, [rel buf]
    mov edx, 32
    syscall

    xor rcx, rcx 
    lea rbx, [rel buf]

.parse:
    mov al, [rbx]
    cmp al, 0x0A
    je .done
    cmp al, 0
    je .done
    cmp al, '0'
    jb .badinput
    cmp al, '9'
    ja .badinput
    sub al, '0'
    imul rcx, rcx, 10
    add rcx, rax
    inc rbx
    jmp .parse

.done:
    test rcx, 1
    jz .even
    jmp .odd

.even:
    mov eax, 60 
    xor edi, edi
    syscall

.odd:
    mov eax, 60
    mov edi, 1 
    syscall

.badinput:
    mov eax, 60
    mov edi, 2
    syscall
