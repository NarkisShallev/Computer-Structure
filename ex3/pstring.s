#Narkis Kremizi Shallev 205832447
        .section .rodata
error:   .string "invalid input!\n"
.text
.global pstrlen
pstrlen:
    movzbq  (%rdi), %rax        #put len of pstr on the return val
    ret

.global replaceChar
replaceChar:
    movq    %rdi, %r9           #backup pointer of pstr on %r9
    movzbq  (%rdi),%rcx         #put len of pstr on caller save %rcx
    movq    $0, %r8             #init counter = 0
    leaq    1(%r9), %r9         #pass on the len of pstr in the memory
    cmpq    %r8, %rcx           #compare counter to len
    je      .done1              #if counter == len jump to end of the func
.loop1:
    cmpb    %sil, (%r9)         #compare oldChar to the char in pstr
    je      .replace            #if it does replace to newChar
.check1:
    leaq    1(%r9), %r9         #pass to the next char in pstr
    incq    %r8                 #counter++
    cmpq    %r8, %rcx           #compare counter to len
    je      .done1              #if counter == len jump to end of the func
    jmp     .loop1              #else, jump to another loop
.replace:
    movb    %dl, (%r9)          #replace the char in pstr to newChar
    jmp     .check1 
.done1:
    movq    %rdi,%rax           #put the pointer to pstr on the return val
    ret
    
.global pstrijcpy
pstrijcpy:
    movq    %rdi, %r9           #backup pointer of dst so that we can return it later      
    cmpq    %rdx,%rcx           #compare i to j        
    jl      .error1              #if j<i jump to error      
    cmpq    $0,%rdx             #compare i to 0      
    jl      .error1              #if i<0 jump to error      
    cmpb    (%r9),%cl           #compare i to dst len     
    jae     .error1              #if j>=dst len jump to error     
    cmpb    (%rsi),%cl          #compare i to src len 
    jae     .error1              #if j>=src len jump to error
    
    leaq    1(%r9),%r9          #skip the length
    leaq    1(%rsi),%rsi        #skip the length
    addq    %rdx,%r9            #skip to the index we start to copy from
    addq    %rdx,%rsi           #skip to the index we start to copy to
    movq    %rdx,%r10           #counter=i;
    incq    %rcx                #j++ to include the last letter in copy
    cmpq    %r10,%rcx           #compare counter to j
    je      .done3
.loop3:
    movb    (%rsi),%r11b         #copy the char to a temporary register
    movb    %r11b,(%r9)        #copy the char from the temporary register to the destination
    incq    %r10                #counter++
    cmpq    %r10,%rcx           #compare counter to j
    je      .done3
    leaq    1(%r9),%r9          #pass to next char
    leaq    1(%rsi),%rsi        #pass to next char
    jmp     .loop3              #else, jump to another loop
.error1:
    movq    $error,%rdi         #transfer the first argument (format) ​​to the printf function
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
.done3:
    movq    %rdi,%rax           #put the pointer to pstr on the return val
    ret              
    
.global swapCase
swapCase:
    movq    %rdi, %r9           #backup pointer of pstr on %r9
    movzbq  (%rdi),%rcx         #put len of pstr on caller save %rcx
    movq    $0, %r8             #init counter = 0
    leaq    1(%r9), %r9         #pass on the len of pstr in the memory
    cmpq    %r8, %rcx           #compare counter to len
    je      .done2              #if counter == len jump to end of the func
.loop2:
    cmpb    $'A',(%r9)          #compare the char in pstr to 'A'    
    jl      .check2             #if char < 'A' jump to check
    cmpb    $'Z',(%r9)          #compare the char in pstr to 'Z'         
    jbe      .replaceToLittle   #if char <= 'Z' jump to replaceToLittle            
    cmpb    $'a',(%r9)          #compare the char in pstr to 'a'         
    jl      .check2             #if char < 'a' jump to check      
    cmpb    $'z',(%r9)          #compare the char in pstr to 'z'         
    jbe      .replaceToBig      #if char < 'z' jump to replaceToBig
.check2:
    leaq    1(%r9), %r9         #pass to the next char in pstr
    incq    %r8                 #counter++
    cmpq    %r8, %rcx           #compare counter to len
    je      .done2              #if counter == len jump to end of the func
    jmp     .loop2              #else, jump to another loop
.replaceToLittle:
    addq    $32,(%r9)           #If we add 32 to the ASCII value of a big letter, it makes it little
    jmp     .check2     
.replaceToBig:
    subq    $32,(%r9)           #If we subtract 32 from the ASCII value of a little letter, it makes it big
    jmp     .check2
.done2:
    movq    %rdi,%rax           #put the pointer to pstr on the return val
    ret

.global pstrijcmp
pstrijcmp:
    cmpq    %rdx,%rcx           #compare i to j        
    jl      .error2              #if j<i jump to error      
    cmpq    $0,%rdx             #compare i to 0      
    jl      .error2             #if i<0 jump to error      
    cmpb    (%rdi),%cl          #compare i to dst len     
    jae     .error2             #if j>=dst len jump to error     
    cmpb    (%rsi),%cl          #compare i to src len 
    jae     .error2             #if j>=src len jump to error
    
    leaq    1(%rdi),%rdi        #skip the length
    leaq    1(%rsi),%rsi        #skip the length
    addq    %rdx,%rdi           #skip to the index we start to copy from
    addq    %rdx,%rsi           #skip to the index we start to copy to
    movq    %rdx,%r10           #counter=i;
    incq    %rcx                #j++ to include the last letter in copy
    cmpq    %r10,%rcx           #compare counter to j
    je      .done4
.loop4:
    movq    (%rdi),%r11         #copy the char to a temporary register
    cmpb    %r11b,(%rsi)        #compare the char to the char in the temporary register
    jb      .bigCase            #if char1>char2 jump to big
    movq    (%rdi),%r11         #copy the char to a temporary register
    cmpb    %r11b,(%rsi)        #compare the char to the char in the temporary register
    ja      .littleCase         #if char1<char2 jump to big
    incq    %r10                #counter++
    cmpq    %r10,%rcx           #compare counter to j
    je      .equalCase          #if char1==char2 jump to equal
    leaq    1(%rdi),%rdi        #pass to next char
    leaq    1(%rsi),%rsi        #pass to next char
    jmp     .loop4              #else, jump to another loop
.bigCase:
    movq    $1,%rax
    jmp     .done4
.littleCase:
    movq    $-1,%rax  
    jmp     .done4
.equalCase:
    movq    $0,%rax  
    jmp     .done4
.error2:
    movq    $error,%rdi         #transfer the first argument (format) ​​to the printf function
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    movq    $-2,%rax
.done4:
    ret 
    