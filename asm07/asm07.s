section .data 

section .text

global _start

_start:

    mov rax, [rsp]
    cmp rax, 2
    jb noarg

    mov rsi, [rsp+16]
    call atoi
    mov rdi, rax
    call is_prime

    mov rdi, rax
    mov eax, 60
    syscall

noarg:
    mov eax, 60
    mov edi, 1
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

is_prime:
    cmp rdi, 2
    jb .not_prime
    je .prime
    test rdi, 1
    jz .not_prime
    mov rbx, 3

.test_div:
    mov rax, rbx
    imul rax, rbx
    cmp rax, rdi
    ja .prime
    mov rax, rdi
    xor rdx, rdx
    div rbx
    test rdx, rdx
    jz .not_prime
    add rbx, 2
    jmp .test_div

.prime:
    xor rax, rax
    ret

.not_prime:
    mov rax, 1
    ret