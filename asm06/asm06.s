section .bss
    buffer resb 32

section .text
    global _start

_start:

    mov rax, [rsp]
    cmp rax, 3
    jne badarg 

    mov rsi, [rsp+16]
    call atoi
    cmp r10, 1
    je badarg
    mov r8, rax

    mov rsi, [rsp+24] 
    call atoi
    cmp r10, 1
    je badarg
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

badarg:
    mov eax, 60
    mov edi, 1
    syscall

atoi:
    xor rax, rax
    xor r9, r9
    xor r10, r10
    
    mov bl, [rsi]
    cmp bl, '-'
    jne .parse
    mov r9b, 1
    inc rsi

.parse:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    cmp bl, 10
    je .done
    cmp bl, '0'
    jb .fail
    cmp bl, '9'
    ja .fail
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc rsi
    jmp .parse

.done:
    test r9b, r9b
    jz .ret
    neg rax

.ret:
    ret

.fail:
    mov r10, 1
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