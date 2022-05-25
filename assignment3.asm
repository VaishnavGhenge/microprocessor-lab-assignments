%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro write 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data

section .bss
    s resb 200
    result resb 16
section .text
global _start
_start:
    read s, 200
    call display
    dec rax

    mov rax, 60
    mov rdi, 0
    syscall

display:
    mov rbx, rax
    mov rdi, result
    mov cx, 16
    
    up1:
    rol rbx, 04
    mov al, bl
    and al, 0fh
    cmp al, 09h
    jg add_37
    add al, 30h
    jmp skip
    
    add_37: add al, 37h
    skip:
    mov [rdi], al
    inc rdi
    dec cx
    jnz up1
    write result, 16
ret
