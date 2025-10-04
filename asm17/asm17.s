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
    cqo
    mov     rbx, 26
    idiv    rbx 
    mov     r8, rdx
    cmp     r8, 0
    jge     .shift_ok
    add     r8, 26
.shift_ok:

    mov     eax, 0
    mov     edi, 0
    mov     rsi, buffer
    mov     edx, 1024
    syscall

    mov     r10, rax
    mov     rcx, rax

    mov     rsi, buffer
    mov     rbx, 26

.loop:
    test    rcx, rcx
    jz      .write
    mov     al, [rsi]

    ;minuscules
    cmp     al, 'a'
    jb      .check_upper
    cmp     al, 'z'
    ja      .check_upper
    sub     al, 'a'
    add     al, r8b
    movzx   eax, al
    xor     edx, edx
    div     ebx
    mov     al, dl
    add     al, 'a'
    jmp     .store

    ;maj
.check_upper:
    cmp     al, 'A'
    jb      .skip
    cmp     al, 'Z'
    ja      .skip
    sub     al, 'A'
    add     al, r8b
    movzx   eax, al
    xor     edx, edx
    div     ebx
    mov     al, dl
    add     al, 'A'
    jmp     .store

.skip:

.store:
    mov     [rsi], al
    inc     rsi
    dec     rcx
    jmp     .loop

.write:
    mov     eax, 1
    mov     edi, 1
    mov     rsi, buffer
    mov     rdx, r10
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
    xor     r9, r9
    mov     bl, [rsi]
    cmp     bl, '-'
    jne     .a_next
    mov     r9b, 1
    inc     rsi

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
    test    r9b, r9b
    jz      .ret
    neg     rax

.ret:
    ret
