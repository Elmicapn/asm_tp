section .data 

section .bss
buffer resb 32

section .text

global _start

_start:
    mov eax, 0
    mov edi, 0
    mov rsi, buffer
    mov edx, 32
    syscall

    test rax, rax
    jle badinput

    mov rsi, buffer
    call atoi
    cmp rax, -1
    je badinput

    mov rdi, rax
    call is_prime

    mov edi, eax
    mov eax, 60
    syscall

badinput:
    mov eax, 60
    mov edi, 2
    syscall

atoi:
    xor rax, rax

.next:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    cmp bl, 10
    je .done
    cmp bl, '0'
    jb .error
    cmp bl, '9'
    ja .error
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp .next

.done:
    ret

.error:
    mov rax, -1
    ret

is_prime:
    cmp rdi, 2
    jb .not_prime
    je .prime
    test rdi, 1
    jz .not_prime
    mov rbx, 3
.loop:
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
    jmp .loop

.prime:
    xor eax, eax
    ret

.not_prime:
    mov eax, 1
    ret
