section .bss
    outbuf resb 128

section .data
    digits db "0123456789ABCDEF"

section .text
    global _start

_start:
    mov     rbx, rsp
    mov     rdi, [rbx]
    cmp     rdi, 2
    jl      no_param

    mov     rsi, [rbx+16]
    mov     al, [rsi]
    cmp     al, '-'
    jne     .default_hex
    cmp     byte [rsi+1], 'b'
    je      .is_bin
    jmp     invalid

.is_bin:
    cmp     byte [rsi+2], 0
    jne     invalid
    cmp     rdi, 3
    jne     invalid
    mov     rsi, [rbx+24]
    mov     r9, 2
    jmp     .parse

.default_hex:
    mov     r9, 16

.parse:
    call    atoi
    cmp     rax, -2
    je      invalid
    cmp     rax, -1
    je      badinput
    call    itoa_base

    mov     eax, 1
    mov     edi, 1
    mov     rsi, rbx
    mov     rdx, rcx
    syscall

    mov     eax, 60
    xor     edi, edi
    syscall

no_param:
    
invalid:
    mov     eax, 60
    mov     edi, 1
    syscall

badinput:
    mov     eax, 60
    mov     edi, 2
    syscall

atoi:
    xor     rax, rax
    mov     bl, [rsi]
    cmp     bl, '-'
    je      .neg
    cmp     bl, '+'
    je      .skip
    jmp     .loop
.neg:

    mov     rax, -2
    ret

.skip:
    inc     rsi

.loop:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .done
    cmp     bl, '0'
    jb      .error
    cmp     bl, '9'
    ja      .error
    sub     bl, '0'
    imul    rax, rax, 10
    movzx   r8, bl
    add     rax, r8
    inc     rsi
    jmp     .loop

.done:
    ret

.error:
    mov     rax, -1
    ret

itoa_base:
    lea     rsi, [outbuf+127]
    mov     byte [rsi], 10
    mov     rcx, 1
    test    rax, rax
    jnz     .loop
    dec     rsi
    mov     byte [rsi], '0'
    inc     rcx
    jmp     .finish

.loop:
    xor     rdx, rdx
    div     r9
    dec     rsi
    mov     bl, [digits+rdx]
    mov     [rsi], bl
    inc     rcx
    test    rax, rax
    jnz     .loop

.finish:
    mov     rbx, rsi
    ret
