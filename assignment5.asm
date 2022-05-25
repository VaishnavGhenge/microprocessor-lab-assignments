section .data
    welmsg db 10,'Welcome to count +ve and -ve numbers in an array',10
    welmsg_len equ $-welmsg

    pmsg db 10,'Count of +ve numbers::'
    pmsg_len equ $-pmsg

    nmsg db 10,'Count of -ve numbers::'
    nmsg_len equ $-nmsg

    nwline db 10

    
    array dw 9000h,8001h,9002h,4553h,8006h,9004h,022h
    arrcnt equ 7

    pcnt db 0
    ncnt db 0

section .bss
    dispbuff resb 2

%macro  print   2
    mov   rax, 1
    mov   rdi, 1
    mov   rsi, %1
    mov   rdx, %2
    syscall
%endmacro


section .text
    global _start
_start:
    print welmsg,welmsg_len

    mov rsi,array   
    mov ecx,arrcnt
up1:
    bt word[rsi],15
    ;shl rax, 4
    jnc pnxt
    inc byte[ncnt]
    jmp pskip

pnxt:   inc byte[pcnt]

pskip:  inc rsi
    inc rsi
    loop up1

    print pmsg,pmsg_len
    mov bl,[pcnt]
    call disp8num


    print nmsg,nmsg_len
    mov bl,[ncnt]
    call disp8num

    print nwline,1      
exit:
    mov rax,60
    syscall

disp8num:
    mov rcx,2       
    mov rdi,dispbuff    
dup1:
    rol bl,4        
    mov al,bl       
    and al,0fh      ;Mask upper digit
    cmp al,09       ;Compare with 9
    jbe dskip       ;If number below or equal to 9 go to add only 30h
    add al,07h      ;Else first add 07h
dskip:  add al,30h      ;Add 30h
    mov [rdi],al        ;Store ASCII code in temp buff
    inc rdi         ;Increment pointer to next location in temp buff
    loop dup1       ;repeat till ecx becomes zero

    print dispbuff,2    ;display the value from temp buff
    ret         ;return to calling program
