section .data
    msg db "Enter number: "
    msglen equ $-msg
    msg2 db "Array: ", 0AH
    msg2len equ $-msg2
section .bss
    arr resw 200
    count resb 1
section .text
global _start
_start:
mov r8, arr
mov byte[count], 05

loop1:
mov rax, 1
mov rdi, 1
mov rsi, msg
mov rdx, msglen
syscall

mov rax, 0
mov rdi, 0
mov rsi, r8
mov rdx, 200
syscall

add r8, 17
dec byte[count]
jnz loop1

mov rax, 1
mov rdi, 1
mov rsi, msg2
mov rdx, msg2len
syscall

mov rax, 1
mov rdi, 1
mov rsi, arr
mov rdx, 200
syscall

mov rax, 60
mov rdi, 0
syscall
