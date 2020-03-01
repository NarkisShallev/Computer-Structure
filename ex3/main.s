#Narkis Kremizi Shallev 205832447
        .section .rodata
len:    .string  "%d"
option: .string  "%d"
string: .string  "%s"
.text
.global main
main:
    movq %rsp, %rbp #for correct debugging

# %r12 - ptr to first string, %r13 - ptr to second string

    pushq   %rbp                #save the old frame pointer
    movq    %rsp,%rbp           #create the new frame pointer
    
    leaq    -8(%rsp),%rsp       #increase the stack in one byte for the len of the first string
    movq    $len,%rdi           #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    
    pop     %rbx                #pop the len of the first string from the stack so that we can save the string in the order in which we were asked in the exercise
    leaq    -1(%rsp),%rsp       #increase the stack in one bit for \0
    movb    $'\0',(%rsp)        #adds a string end character
    subq    %rbx,%rsp           #increase the stack in %rbx value (len) for the first string
    movq    $string,%rdi        #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    leaq    -1(%rsp),%rsp       #increase the stack in one bit for the len of the first string
    movb    %bl,(%rsp)          #insert the len into the stack
    movq    %rsp, %r12          #create a pointer to the first string
    
    leaq    -8(%rsp),%rsp       #increase the stack in one byte for the length of the second string
    movq    $len,%rdi           #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    
    pop     %rbx                #pop the len of the second string from the stack so that we can save the string in the order in which we were asked in the exercise
    leaq    -1(%rsp),%rsp       #increase the stack in one bit for \0
    movb    $'\0',(%rsp)        #adds a string end character
    subq    %rbx,%rsp           #increase the stack in %rbx value (len) for the first string
    movq    $string,%rdi        #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    leaq    -1(%rsp),%rsp       #increase the stack in one bit for the len of the second string
    movb    %bl,(%rsp)          #insert the len into the stack
    movq    %rsp, %r13          #create a pointer to the second string
    
    leaq    -8(%rsp),%rsp       #increase the stack in one byte for the option
    movq    $option,%rdi        #transfer the first argument (format) ​​to the scanf function
    movq    %rsp,%rsi           #transfer the second argument (the place in stack) to the scanf function
    movq    $0,%rax             #reset the return value of the scanf function
    call    scanf
    
    pop     %rdi                #transfer the first argument (option) ​​to the run_func function
    movq    %r12,%rsi           #transfer the second argument (pstring1) ​​to the run_func function
    movq    %r13,%rdx           #transfer the third argument (pstring2) ​​to the run_func function
    call    run_func            
    
    movq    $0,%rax             #return 0;
    movq    %rbp, %rsp          #restore the old stack pointer - release all used memory.
    pop     %rbp                #restore old frame pointer (the caller function frame)
    ret	                  #return to caller function (OS)
    