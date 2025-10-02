section .data 

section .bss
    outbuf  resb 32

section .text
    global _start

_start:

    mov     rbx, rsp
    mov     rdi, [rbx]
    cmp     rdi, 2
    jl      no_param

    mov     rsi, [rbx+16]
    call    atoi
    cmp     rax, -1
    je      badinput

    cmp     rax, 1
    jg      .compute
    xor     rax, rax
    jmp     .print

.compute:
    mov     rcx, rax
    dec     rcx 
    imul    rax, rcx 
    shr     rax, 1 

.print:
    ; rax contient la valeur à afficher
    call    itoa 

    mov     eax, 1 
    mov     edi, 1
    mov     rsi, rbx
    mov     rdx, rcx
    syscall

    mov     eax, 60
    xor     edi, edi
    syscall

no_param:
    mov     eax, 60
    mov     edi, 1
    syscall

badinput:
    mov     eax, 60
    mov     edi, 2
    syscall

atoi:
    xor     rax, rax          ; résultat
    xor     r8d, r8d          ; r8b=1 si négatif

    mov     dl, [rsi]
    cmp     dl, '-'
    jne     .check_plus
    inc     r8b
    inc     rsi
    jmp     .next
    
.check_plus:
    cmp     dl, '+'
    jne     .next
    inc     rsi

.next:
    mov     dl, [rsi]
    cmp     dl, 0
    je      .done

    cmp     dl, '0'
    jb      .error

    cmp     dl, '9'
    ja      .error

    sub     dl, '0'
    imul    rax, rax, 10
    movzx   r9, dl
    add     rax, r9
    inc     rsi
    jmp     .next

.done:
    test    r8b, r8b
    jz      .ret
    neg     rax
.ret:
    ret

.error:
    mov     rax, -1
    ret

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
