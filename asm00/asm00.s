section .data

section .text
global _start

_start:
    mov rdi, 60
    xor rdi, rdi 
    syscall
