
section .data                               ;initialised data section
    
    aim db 0ah,"Program to perform multiplication of two hexadecimal numbers"
    len equ $-aim
        
    menu db 0ah,'1. Successive Addition'            ;menu to display
         db 0ah,'2. Add and Shift'                      
         db 0ah,'3. Exit'
         db 0ah,'   Enter your choice : '
    menul equ $-menu                    ;length of menu

    msg1 db 0ah,'Enter First Number  : '            ;message to display
    msgl1 equ $-msg1                    ;length of message

    msg2 db 0ah,'Enter Second Number : ' 
    msgl2 equ $-msg2

    msg3 db 0ah,'Result : '
    msgl3 equ $-msg3

section .bss                            ;uninitialised data section
n resb 4                            ;variable to take the input and print the output
num1 resb 1                         ;variable to store multiplicand
num2 resb 1                         ;variable to store multiplier
choice resb 2                           ;variable to take choice as input

section .text                           ;code section
global _start                           ;start of program execution
_start : 

%macro io 4                         ;macro for print and scan
    
    mov rax,%1                      ;first parameter
    mov rdi,%2                      ;second parameter
    mov rsi,%3                      ;third parameter
    mov rdx,%4                      ;fourth parameter
    syscall                         ;interrupt call
    
%endmacro                           ;end of macro
    
    io 1,1,aim,len
    
    men:                            ;user defined flag

        io 1,1,menu,menul               ;printing the menu
        io 0,0,choice,2                 ;taking user choice as input
        
        case1:                      ;case 1 for successive addition method
        
            cmp byte[choice],'1'            ;comparing whether user's choice is 1 
            jne case2               ;jumping to case2 if user didnot enter 1 as choice
            io 1,1,msg1,msgl1           ;print message1 
            io 0,0,n,3              ;taking multiplicand as input
            call asciihex               ;procedure call to convert input ascii to hex hex equivalent
            mov [num1],bl               ;moving contents of bl to num1 variable
    
            io 1,1,msg2,msgl2           ;print message2
            io 0,0,n,3              ;taking multiplier as input
            call asciihex               ;procedure call to convert input ascii to hex equivalent
            mov [num2],bl               ;moving contents of bl to num2 variable
    
            call p1                 ;procedure call
            jmp men                 ;unconditional jump
            
        case2:                      ;case 2 for add and shift method
            cmp byte[choice],'2'            ;comparing whether user's choice is 1 
            jne exi                 ;jumping to case2 if user didnot enter 1 as choice
            io 1,1,msg1,msgl1           ;print message1 
            io 0,0,n,3              ;taking multiplicand as input
            call asciihex               ;procedure call to convert input ascii to hex hex equivalent
            mov [num1],bl               ;moving contents of bl to num1 variable
    
            io 1,1,msg2,msgl2           ;print message2
            io 0,0,n,3              ;taking multiplier as input
            call asciihex               ;procedure call to convert input ascii to hex equivalent
            mov [num2],bl               ;moving contents of bl to num2 variable
    
            call p2                 ;procedure call
            jmp men                 ;unconditional jump
            
    exi:                            ;user defined flag
    
    mov rax,60                      ;system exit
    mov rdi,0                       ;system exit
    syscall                         ;system interrupt
        
    p1:                         ;procedure for successive addition method
    
        mov rcx,0                   ;clearing contents of rcx
        mov rbx,0                   ;clearing contents of rbx
        mov rax,0                   ;clearing contents of rax
        mov al,[num1]                   ;storing num1 in al
        mov cl,[num2]                   ;storing num2 in cl
        
        lp2:                        ;user defined label
            
            add bx,ax               ;add contents of bx and ax and store them in bx
        
        loop lp2                    ;looping instruction,automatically decrements rcx
        io 1,1,msg3,msgl3               ;printing message3
        call displaynum                 ;procedure call
    
    ret                         ;proccedure return
        
    p2:                         ;procedure for add and shift method
    
        mov rcx,0                   ;clearing contents of rcx
        mov rbx,0                   ;clearing contents of rbx
        mov rdx,0                   ;clearing contents of rdx
        mov al,[num1]                   ;storing num1 in al
        mov bl,[num2]                   ;storing num2 in bl
        mov rcx,8                   ;initialising rcx to 8
        
        lp4:                        ;user defined flag
            
            shr bl,1                ;shifting bits of bl right by 1 bit,lost bit is copied in carry flag
            jnc flg                 ;making conditional jump if carry flag is 1
            add dx,ax               ;adding contents of dx and ax and storing them in dx
            flg:shl ax,1                ;shifting bits of ax left by 1
                                    
        loop lp4                    ;looping instruction,automatically decrements rcx   
        mov rbx,rdx                 ;moving contents of rdx to rbx
        io 1,1,msg3,msgl3               ;printing message3
        call displaynum                 ;procedure call
    
    ret                         ;procedure return
        
    displaynum:                     ;procedure to display 4-digit number
        
        mov rcx,4                   ;initialising rcx to 4
        mov rax,0                   ;clearing contents of rax
        mov rsi,n                   ;making rsi point to the number to be displayed
        
        lp3:                        ;user defined label
            
            rol bx,4                ;rotating bits of bx to left by 1 bit
            mov al,bl               ;moving contents of bl into al
            and al,0fh              ;anding al and 0fh to get LSB digit
            cmp al,9                ;comparing al and 9
            jbe add30h              ;jump below or equal
            add al,7h               ;adding 7h to al
            add30h : add al,30h         ;adding 30h to al
            mov [rsi],al                ;moving contents of al to location pointed by rsi
            inc rsi                 ;incrementing rsi to point to next location 
            
        loop lp3                    ;looping instruction,automatically decrements rcx
    
        io 1,1,n,4                  ;printing 4-digit number
    
    ret                         ;procedure return
        
    asciihex:                       ;procedure for ascii to hex conversion  
        
        mov rsi,n                   ;making rsi point to variable hex
        mov rbx,0                   ;clearing rbx
        mov rax,0                   ;clearing rax
        mov rcx,2                   ;initialising rcx to 4
        
        lp1:                        ;user defined label
            
            rol bl,4                ;rotating contents of bx to left by 4 bits
            mov al,[rsi]                ;moving value pointed by rsi to al
            cmp al,39h              ;comparing value in al to 9
            jbe sub30h              ;jump if below or equal to flag sub30h
            sub al,7h               ;subtract 7h from al
            sub30h: sub al,30h          ;subtract 30h from al
            add bl,al               ;adding value in al as units digit in bl
            inc rsi                 ;incrementing rsi to point to next location
        
        loop lp1                    ;looping instruction
        
    ret                         ;procedure return
