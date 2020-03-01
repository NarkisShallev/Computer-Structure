Pstring* swapCase(Pstring* pstr) {
    int counter = pstr->len;
    pstr++;
    loop:
        if (counter == 0){
            goto done;
        }
        if ((*pstr)>='A' &&(*pstr)<='Z'){
            goto replaceToLittle;
        }
        if ((*pstr)>='a' &&(*pstr)<='z'){
        goto replaceToBig;
        }
    afterReplace:
        pstr++;
        counter--;
        goto loop;
    }
    replaceToLittle:
        *pstr = *pstr+32;
        goto afterReplace;
    replaceToBig:
        *pstr = *pstr-32
        goto afterReplace;
    done:...
}
