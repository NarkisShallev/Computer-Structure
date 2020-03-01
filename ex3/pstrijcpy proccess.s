Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j){
*p = dst; //backup of pstr
if (j < i)
    goto error;
if (i < 0)
    goto error;
if (j>=*dst)
    goto error;
if (j>=*src)
    goto error;
p++;
src++;
p = p+i;
src = p+i;
counter = i
if (counter ==j)
    goto done;
loop:
    *dst=*src
    p++
    src++
    counter++
    if (counter ==j)
        goto done;
    goto loop
done...



return dst;}