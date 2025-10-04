section .bss
    buffer  resb 1024

section .text

global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jb      .noarg

    mov     rsi, [rsp+16]
    call    atoi
    mov     r8, rax

    mov     rax, r8
    xor     rdx, rdx
    mov     rbx, 26
    div     rbx
    mov     r8, rdx

    mov     eax, 0
    mov     edi, 0
    mov     rsi, buffer
    mov     edx, 1024
    syscall
    mov     r10, rax         ; sauver nb d'octets lus
    mov     rcx, rax

    mov     rsi, buffer
    mov     rbx, 26

.loop:
    test    rcx, rcx
    jz      .write
    mov     al, [rsi]
    cmp     al, 'a'
    jb      .skip
    cmp     al, 'z'
    ja      .skip
    sub     al, 'a'
    add     al, r8b
    movzx   eax, al
    xor     edx, edx
    div     ebx
    mov     al, dl
    add     al, 'a'

.skip:
    mov     [rsi], al
    inc     rsi
    dec     rcx
    jmp     .loop

.write:
    mov     eax, 1
    mov     edi, 1
    mov     rsi, buffer
    mov     rdx, r10        ; utiliser nb d’octets lus
    syscall

    mov     eax, 60
    xor     edi, edi
    syscall

.noarg:
    mov     eax, 60
    mov     edi, 1
    syscall

atoi:
    xor     rax, rax

.a_next:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .a_done
    cmp     bl, 10
    je      .a_done
    sub     bl, '0'
    imul    rax, rax, 10
    add     rax, rbx
    inc     rsi
    jmp     .a_next

.a_done:
    ret
