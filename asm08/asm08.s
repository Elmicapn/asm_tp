section .bss
    outbuf resb 32

section .text
    global _start

_start:
    mov rbx, rsp
    mov rdi, [rbx]            ; argc
    cmp rdi, 2
    jl no_param
    mov rsi, [rbx+16]         ; argv[1]
    call atoi
    cmp rax, -1
    je badinput

    mov rcx, rax
    xor rax, rax
    mov rdx, 1

.sum_loop:
    cmp rdx, rcx
    jge .done_sum
    add rax, rdx
    inc rdx
    jmp .sum_loop

.done_sum:
    mov rsi, outbuf
    call itoa
    mov eax, 1
    mov edi, 1
    mov rsi, outbuf
    mov rdx, rbx
    syscall
    
    mov eax, 60
    xor edi, edi
    syscall

no_param:
    mov eax, 60
    mov edi, 1
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

itoa:
    mov rcx, 10
    mov rbx, rsi
    add rsi, 31
    mov byte [rsi], 10
    dec rsi

.conv_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .conv_loop
    inc rsi
    mov rdx, outbuf+32
    sub rdx, rsi
    mov rbx, rdx
    ret
