section .bss
    buffer resb 5

section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jb badarg

    mov rdi, [rsp+16]
    mov eax, 2
    xor esi, esi
    xor edx, edx
    syscall
    cmp eax, 0
    jl badfile
    mov edi, eax

    mov eax, 0
    mov rsi, buffer
    mov edx, 5
    syscall
    cmp eax, 5
    jl notelf

    mov al, [buffer]
    cmp al, 0x7F
    jne notelf
    mov al, [buffer+1]
    cmp al, 'E'
    jne notelf
    mov al, [buffer+2]
    cmp al, 'L'
    jne notelf
    mov al, [buffer+3]
    cmp al, 'F'
    jne notelf
    mov al, [buffer+4]
    cmp al, 2
    jne notelf

    mov eax, 60
    xor edi, edi
    syscall

notelf:
    mov eax, 60
    mov edi, 1
    syscall

badarg:
    mov eax, 60
    mov edi, 1
    syscall

badfile:
    mov eax, 60
    mov edi, 1
    syscall
