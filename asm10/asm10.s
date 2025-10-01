section .bss
    buffer resb 32

section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 4
    jb noarg

    mov rsi, [rsp+16]
    call atoi
    mov r8, rax

    mov rsi, [rsp+24]
    call atoi
    cmp rax, r8
    cmovg r8, rax

    mov rsi, [rsp+32]
    call atoi
    cmp rax, r8
    cmovg r8, rax

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
    xor r9, r9
    mov bl, [rsi]
    cmp bl, '-'
    jne .next
    mov r9b, 1
    inc rsi
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
    test r9b, r9b
    jz .ret
    neg rax
.ret:
    ret

itoa:
    mov rcx, 0
    mov rbx, 10
    xor r9, r9
    test rax, rax
    jns .positive
    neg rax
    mov r9b, 1
.positive:
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
    test r9b, r9b
    jz .done
    dec rdi
    mov byte [rdi], '-'
    inc rcx
.done:
    mov rbx, rdi
    ret

noarg:
    mov eax, 60
    mov edi, 1
    syscall
