section .data

section .bss
    buffer resb 32

section .text

global _start

_start:
    mov rsi, [rsp+16]
    call atoi
    mov r8, rax

    mov rsi, [rsp+24]
    call atoi
    add r8, rax

    mov rax, r8
    lea rsi, [rel buffer]
    call itoa

    mov eax, 1
    mov edi, 1
    mov rsi, rbx
    mov rdx, rcx
    syscall

    mov eax, 60
    xor edi, edi
    syscall

atoi:
    xor rax, rax

.next:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc rsi
    jmp .next

.done:
    ret

itoa:
    mov rcx, 0
    mov rbx, 10
    lea rdi, [rsi+31]
    mov byte [rdi], 0

.conv:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .conv
    mov rbx, rdi
    ret
