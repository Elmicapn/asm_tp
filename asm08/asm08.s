section .bss
    outbuf resb 32

section .text
    global _start

_start:
    ; argc est à [rsp], argv[0] à [rsp+8], argv[1] à [rsp+16]
    mov rbx, rsp
    mov rdi, [rbx]        ; argc
    cmp rdi, 2
    jl no_param           ; s'il n'y a pas de paramètre

    mov rsi, [rbx+16]     ; argv[1]
    call atoi             ; -> rax contient N
    cmp rax, -1
    je badinput

    ; calcul somme = N*(N-1)/2
    mov rcx, rax
    dec rcx
    imul rax, rcx
    shr rax, 1            ; division par 2

    ; conversion en string
    mov rsi, outbuf
    call itoa

    ; write(1, rbx, rcx)
    mov eax, 1            ; sys_write
    mov edi, 1            ; stdout
    mov rsi, rbx          ; adresse du buffer retournée
    mov rdx, rcx          ; longueur
    syscall

    ; exit(0)
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


; -------- atoi --------
; in:  rsi -> string
; out: rax = nombre ou -1 si erreur
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


; -------- itoa --------
; in:  rax = valeur
; out: rbx = adresse début string, rcx = longueur
itoa:
    mov rdi, outbuf
    add rdi, 31
    mov byte [rdi], 10     ; mettre '\n'
    mov rsi, rdi
    mov rcx, 1
    test rax, rax
    jnz .loop
    dec rsi
    mov byte [rsi], '0'
    inc rcx
    jmp .finish
.loop:
    xor rdx, rdx
    mov r8, 10
    div r8
    dec rsi
    add dl, '0'
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .loop
.finish:
    mov rbx, rsi
    ret
