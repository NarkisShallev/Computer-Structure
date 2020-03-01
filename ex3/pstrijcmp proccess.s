int pstrijcmp(Pstring pstr1, Pstring pstr2, char i, char j){
    if (j  i)
        goto error;
    if (i  0)
        goto error;
    if (j=dst)
        goto error;
    if (j=src)
        goto error;
    p++;
    src++;
    p = p+i;
    src = p+i;
    counter = i
    if (counter ==j)
        goto done;
    loop
        if (pstr1  pstr2)
            return 1
        if (pstr2  pstr1)
            return -1
        p++
        src++
        counter++
        if (counter ==j)
            goto done;
        goto loop

    error
        return -2
    done...