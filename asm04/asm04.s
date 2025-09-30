section .data

section .bss

buf resb 32

section .text

global _start
_start:

    xor eax,eax
    xor edi,edi
    lea rsi,[rel buf]
    mov edx,32
    syscall

    xor ecx,ecx
    mov rbx,buf

.next:
    mov al,[rbx]
    cmp al,10
    je .done
    sub al,'0'
    imul ecx,ecx,10
    add ecx,eax
    inc rbx
    jmp .next

.done:
    test ecx,1
    jnz .odd


