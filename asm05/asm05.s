section .data

section .text

global _start

_start:
    mov rdi, [rsp+16]

    test rdi, rdi
    jz .noarg

    xor rcx, rcx
.count:
    cmp byte [rdi+rcx], 0
    je .print
    inc rcx
    jmp .count

.print:
    mov eax, 1
    mov edi, 1
    mov rsi, rdi
    mov rdx, rcx
    syscall

    mov eax, 60
    xor edi, edi
    syscall

.noarg:
    mov eax, 60
    mov edi, 1
    syscall
