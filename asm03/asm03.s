section .data

msg db "1337",10
len equ $-msg

section .text

global _start
_start:
    cmp rdi,2
    jne fail

    mov rbx,[rsi+8]
    mov al,[rbx]
    cmp al,'4'
    jne fail

    mov al,[rbx+1]
    cmp al,'2'
    jne fail

    mov al,[rbx+2]
    test al,al
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
