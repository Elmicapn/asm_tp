section .data

section .text
global _start

_start:
    mov rax, 60 
    xor rdi, 0
    syscall