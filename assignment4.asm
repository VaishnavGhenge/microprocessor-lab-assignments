%macro write 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
	arr db 11h, 15h, 17h, 12h
	temp db 00h
section .bss
	cnt resb 1
	result resb 1
section .text
global _start
_start:
	mov byte[cnt], 05h
	mov rsi, arr
	mov al, 0
	
	lp:
	cmp al, [rsi]
	jg skip
	xchg al, [rsi]
	
	skip:
	inc rsi
	dec byte[cnt]
	jnz lp

	call display
	
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
    jmp skip1
    
    add_37: add al, 37h
    skip1:
    mov [rdi], al
    inc rdi
    dec cx
    jnz up1
    write result, 16
ret
