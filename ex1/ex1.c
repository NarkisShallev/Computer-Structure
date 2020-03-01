// 205832447 Narkis Shallev (Kremizi)
/******************************************
*Narkis Shallev (Kremizi)
*205832447
*03
*Exercise 1
******************************************/

#include <stdio.h>

/******************************************
 *function name: is_little_endian
 *The Input: None
 *The output: int
 *The Function operation: The function returns 1 if it is complied and runs on
 * a machine that runs by little endian and returns 0 if it is compiled and run
 * on a machine by big endian
******************************************/
int is_little_endian() {
    // 000000...01
    unsigned long int i = 1;

    /* Creates a char array so that each array cell has one byte of i in the
    order in which it is stored in memory */
    char *c = (char *) &i;

    /* In little endian the computer will keep the 1 like this - 00000..01.
    In big endian it will keep the 1 like this - 10000.00. Therefore, we will
    check the most right cell in the array. If it is equal to 0 then the
    computer runs by big endian - return 0.*/
    if (c[0] == 0) {
        return 0;
    }
    // Otherwise, by little endian - return 1.
    return 1;
}

/******************************************
 *function name: merge_bytes
 *The Input: 2 parameters of unsigned long int
 *The output: unsigned long
 *The Function operation: The function returns a word built from the least
 * significant byte of y and the other bytes of x
******************************************/
unsigned long merge_bytes(unsigned long x, unsigned long int y) {
    unsigned long int temp_x = x;
    unsigned long int temp_y = y;

    /* Creates a char array so that each array cell has one byte of x in the
    order in which it is stored in memory */
    char *c_x = (char *) &temp_x;

    /* Creates a char array so that each array cell has one byte of y in the
    order in which it is stored in memory */
    char *c_y = (char *) &temp_y;

    /* If the machine runs on little endian then the LSB will be the right cell
     * in the array, replace it and return x.*/
    if (is_little_endian()) {
        c_x[0] = c_y[0];
        return temp_x;
    }

    /* Otherwise, the LSB will be the left cell in the array, replace it and
    return x.*/
    c_x[sizeof(unsigned long int) - 1] = c_y[sizeof(unsigned long int) - 1];
    return temp_x;
}

/******************************************
 *function name: put_byte
 *The Input: unsigned long, unsigned char, int
 *The output: unsigned long
 *The Function operation: The function returns x after its byte i is replaced
 * by b
******************************************/
unsigned long put_byte(unsigned long x, unsigned char b, int i) {

    /* Creates a char array so that each array cell has one byte of x in the
    order in which it is stored in memory */
    unsigned long int temp_x = x;
    char *c_x = (char *) &temp_x;
    // check if i in the domain.
    if ((i < 0) || (i > sizeof(unsigned long int) - 1)){
        printf("The byte i does not exist !");
        return temp_x;
    }

    /* If the machine runs on little endian then the byte we replace will be
    in the i place when counting from the beginning. */
    if (is_little_endian()) {
        c_x[i] = b;
        return temp_x;
    }
    // Otherwise, it will be in the i place when counting from the end.
    c_x[sizeof(unsigned long int) - 1 - i] = b;
    return temp_x;
}