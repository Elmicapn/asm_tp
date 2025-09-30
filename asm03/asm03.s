section .data

msg db "1337",10
len equ $-msg

section .text

global _start
_start:

    mov rax,[rsp]
    cmp rax,2
    jne fail

    mov rbx,[rsp+16]
    cmp byte [rbx],'4'
    jne fail

    cmp byte [rbx+1],'2'
    jne fail

    cmp byte [rbx+2],0
    jne fail

ok: mov eax,1
    mov edi,1
    mov rsi,msg
    mov edx,len
    syscall

    mov eax,60
    xor edi,edi
    syscall

fail:
    mov eax,60
    mov edi,1
    syscall
