#Narkis Kremizi Shallev 205832447
        .section .rodata
cFormat: .string "%c" 
dFormat: .string "%d"
case50:  .string "first pstring length: %d, second pstring length: %d\n" 
case51:  .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
case52:  .string "length: %d, string: %s\n" 
case53:  .string "length: %d, string: %s\n" 
case54:  .string "compare result: %d\n" 
error:   .string "invalid option!\n" 
.Switch_Case_table:
    .quad .L50                  #case 50
    .quad .L51                  #case 51
    .quad .L52                  #case 52
    .quad .L53                  #case 53
    .quad .L54                  #case 54
    .quad .L60                  #default 
.text
.global run_func
run_func:

    movq    %rsi, %r12          #backup pstring1
    movq    %rdx, %r13          #backup pstring2
    
    # Set up the jump table access
    leaq    -50(%rdi),%rsi                 # Compute %rsi = x-50
    cmpq    $4,%rsi                        # Compare %rsi to 3
    ja     .L60                           # if >, goto default
    jmp     *.Switch_Case_table(,%rsi,8)   # Goto Switch_Case_table[%rsi]
 
    # Case 50 - "pstrlen", calculates and prints the lengths of both pstring
.L50:
    movq    %r12,%rdi           #transfer the argument (pstring1) ​​to the pstrlen function   
    call    pstrlen                    
    movq    %rax,%rsi           #backup the return value in a register + transfer the second argument (len) ​​to the printf function
    
    movq    %r13,%rdi           #transfer the argument (pstring2) ​​to the pstrlen function   
    call    pstrlen                     
    movq    %rax,%rdx           #backup the return value in a register + transfer the third argument (len) ​​to the printf function
    
    movq    $case50,%rdi        #transfer the first argument (format) ​​to the printf function
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    jmp     .done                       
 
    # Case 51 - "replaceChar", replace all oldChar with newChar on both pstring
.L51:
    pushq   %rbp                #save the old frame pointer
    movq    %rsp,%rbp           #create the new frame pointer
         
    leaq    -8(%rsp),%rsp       #increase the stack for dummy
    movq    $cFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    
    leaq    -1(%rsp),%rsp       #increase the stack for oldChar
    movq    $cFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r14         #backup the return value in a register
    
    leaq    -8(%rsp),%rsp       #increase the stack for dummy
    movq    $cFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    
    leaq    -1(%rsp),%rsp       #increase the stack for newChar
    movq    $cFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r15         #backup the return value in a register
    
    movq    %r12,%rdi           #transfer the first argument (pstring1) ​​to the replaceChar function
    movq    %r14,%rsi           #transfer the second argument (oldChar) ​​to the replaceChar function
    movq    %r15,%rdx           #transfer the third argument (newChar) ​​to the replaceChar function
    call    replaceChar
    leaq    -8(%rsp),%rsp       #increase the stack for return value
    movq    %rax,(%rsp)         #backup the return value in the stack
    
    movq    %r13,%rdi           #transfer the first argument (pstring2) ​​to the replaceChar function
    call    replaceChar
    
    movq    $case51,%rdi        #transfer the argument (format) ​​to the printf function
    movzbq  %r14b,%rsi          #transfer the second argument (oldChar) ​​to the printf function
    movzbq  %r15b,%rdx          #transfer the third argument (newChar) ​​to the printf function
    pop     %rcx                #transfer the forth argument (pstring1) ​​to the printf function
    leaq    1(%rcx),%rcx        #skip the length
    leaq    1(%rax),%r8         #transfer the fifth argument (pstring2) ​​to the printf function + skip the length
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    movq    %rbp, %rsp          #restore the old stack pointer - release all used memory.
    pop     %rbp                #restore old frame pointer (the caller function frame)
    
    jmp     .done
 
    # Case 52 - "pstrijcpy", copying the src string [i: j] into dst [i: j]
.L52:    
    pushq   %rbp                #save the old frame pointer
    movq    %rsp,%rbp           #create the new frame pointer
    
    leaq    -8(%rsp),%rsp       #increase the stack for startIndex i
    movq    $dFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r14         #backup the return value in a register

    leaq    -8(%rsp),%rsp       #increase the stack for endIndex j
    movq    $dFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r15         #backup the return value in a register
    
    movq    %r12,%rdi           #transfer the first argument (pstring1-dst) ​​to the pstrijcpy function
    movq    %r13,%rsi           #transfer the first argument (pstring2-src) ​​to the pstrijcpy function
    movq    %r14,%rdx           #transfer the second argument (i) ​​to the pstrijcpy function
    movq    %r15,%rcx           #transfer the third argument (j) ​​to the pstrijcpy function  
    call    pstrijcpy
    
    movq    $case52,%rdi        #transfer the first argument (format) ​​to the printf function
    movzbq  (%rax),%rsi         #transfer the second argument (len) ​​to the printf function
    leaq    1(%rax),%rdx        #transfer the third argument (pstring2) ​​to the printf function + skip the length
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    movq    $case52,%rdi        #transfer the first argument (format) ​​to the printf function
    movzbq  (%r13),%rsi         #transfer the second argument (len) ​​to the printf function
    leaq    1(%r13),%rdx        #transfer the third argument (pstring2) ​​to the printf function + skip the length
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    movq    %rbp, %rsp          #restore the old stack pointer - release all used memory.
    pop     %rbp                #restore old frame pointer (the caller function frame)
        
    jmp     .done
        
    # Case 53 - "swapCase", converts any large letter in both pstring to a small letter and vice versa
.L53:
    movq    %r12,%rdi           #transfer the argument (pstring1) ​​to the swapCase function
    call    swapCase
    
    movq    $case53,%rdi        #transfer the first argument (format) ​​to the printf function
    movb    (%rax),%sil         #transfer the second argument (len) ​​to the printf function
    leaq    1(%rax),%rdx        #transfer the third argument (pstring1) ​​to the printf function + skip the length
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    movq    %r13,%rdi           #transfer the argument (pstring2) ​​to the swapCase function
    call    swapCase
    
    movq    $case53,%rdi        #transfer the first argument (format) ​​to the printf function
    movzbq  (%rax),%rsi         #transfer the second argument (len) ​​to the printf function
    leaq    1(%rax),%rdx        #transfer the third argument (pstring2) ​​to the printf function + skip the length
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    jmp     .done
        
    # Case 54 - "pstrijcmp", compare pstr1 ->str[i:j] to pstr2 ->str[i:j]
.L54:
    pushq   %rbp                #save the old frame pointer
    movq    %rsp,%rbp           #create the new frame pointer
    
    leaq    -8(%rsp),%rsp       #increase the stack for startIndex i
    movq    $dFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r14         #backup the return value in a register

    leaq    -8(%rsp),%rsp       #increase the stack for endIndex j
    movq    $dFormat,%rdi       #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    movzbq  (%rsp),%r15         #backup the return value in a register
    
    movq    %r12,%rdi           #transfer the first argument (pstring1-dst) ​​to the pstrijcmp function
    movq    %r13,%rsi           #transfer the first argument (pstring2-src) ​​to the pstrijcmp function
    movq    %r14,%rdx           #transfer the second argument (i) ​​to the pstrijcmp function
    movq    %r15,%rcx           #transfer the third argument (j) ​​to the pstrijcmp function  
    call    pstrijcmp
    
    movq    $case54,%rdi        #transfer the first argument (format) ​​to the printf function
    movq    %rax,%rsi           #transfer the second argument (result) ​​to the printf function
    movq    $0,%rax             #reset the return value of the printf function
    call    printf
    
    movq    %rbp, %rsp          #restore the old stack pointer - release all used memory.
    pop     %rbp                #restore old frame pointer (the caller function frame)
    
    jmp     .done
        
    # Defualt
.L60:
    movq    $error, %rdi        #transfer the first argument (format) ​​to the printf function
    movq    $0, %rax            #reset the return value of the printf function
    call    printf     
    jmp     .done
        
.done:
    ret
