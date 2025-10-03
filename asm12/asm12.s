section .bss
    inbuf   resb 256
    outbuf  resb 256

section .text
    global _start

_start:

    mov     eax, 0
    mov     edi, 0
    mov     rsi, inbuf
    mov     edx, 256
    syscall

    cmp     rax, 0
    jle     .done 

    mov     rcx, rax
    dec     rcx
    mov     rsi, inbuf
    mov     rdi, outbuf

    add     rsi, rcx
    dec     rsi

    xor     rbx, rbx         ; compteur chars inversés

.revloop:
    cmp     rcx, 0
    je      .finish
    mov     al, [rsi]
    mov     [rdi], al
    inc     rdi
    dec     rsi
    dec     rcx
    inc     rbx
    jmp     .revloop

.finish:
    mov     byte [rdi], 10
    inc     rbx 

    mov     eax, 1
    mov     edi, 1
    mov     rsi, outbuf
    mov     rdx, rbx
    syscall

.done:
    mov     eax, 60
    xor     edi, edi
    syscall
