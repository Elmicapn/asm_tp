section .bss
    inbuf   resb 10000
    outbuf  resb 32

section .text
    global _start

_start:
    mov     eax, 0
    mov     edi, 0
    mov     rsi, inbuf
    mov     edx, 10000
    syscall

    cmp     rax, 0
    jle     .done

    mov     rcx, rax
    mov     rsi, inbuf
    xor     rbx, rbx ; compteur de voyelles

.nextchar:
    mov     al, [rsi]
    cmp     al, 0
    je      .countdone
    cmp     al, 10
    je      .skip
    cmp     al, 128
    jae     .skip

    cmp     al, 'a'
    je      .isv
    cmp     al, 'e'
    je      .isv
    cmp     al, 'i'
    je      .isv
    cmp     al, 'o'
    je      .isv
    cmp     al, 'u'
    je      .isv
    cmp     al, 'y'
    je      .isv
    cmp     al, 'A'
    je      .isv
    cmp     al, 'E'
    je      .isv
    cmp     al, 'I'
    je      .isv
    cmp     al, 'O'
    je      .isv
    cmp     al, 'U'
    je      .isv
    cmp     al, 'Y'
    je      .isv
    jmp     .skip

.isv:
    inc     rbx

.skip:
    inc     rsi
    loop    .nextchar

.countdone:
    mov     rax, rbx
    call    itoa

    mov     eax, 1
    mov     edi, 1
    mov     rsi, rbx
    mov     rdx, rcx
    syscall

.done:
    mov     eax, 60
    xor     edi, edi
    syscall

itoa:
    mov     rdi, outbuf
    add     rdi, 31
    mov     byte [rdi], 10
    mov     rsi, rdi
    mov     rcx, 1
    test    rax, rax
    jnz     .loop
    dec     rsi
    mov     byte [rsi], '0'
    inc     rcx
    jmp     .finish

.loop:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    dec     rsi
    add     dl, '0'
    mov     [rsi], dl
    inc     rcx
    test    rax, rax
    jnz     .loop

.finish:
    mov     rbx, rsi
    ret
