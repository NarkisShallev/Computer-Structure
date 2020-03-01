// 205832447 Narkis Shallev (Kremizi)
/******************************************
*Narkis Shallev (Kremizi)
*205832447
*03
*Exercise 2
******************************************/
#include <stdio.h>
#include <string.h>

void option1(char *argv[]);

void option2(char *argv[]);

void option3(char *argv[]);

void swap(char *arr);

void sharedFunc12(char *argv[], int sign);

/******************************************
 *function name: main
 *The Input: int argc, char *argv[]
 *The output: int
 *The Function operation: The arguments given in CMD will determine the
 * operation of the program. The possible arguments are: 1. Input file name
 * and output file name. 2. Like 1 + flag indicating the operating system
 * encoding in the input file and flag indicating the desired operating system
 * encoding for the output file. 3. Like 2 + flag indicating whether to change
 * the endianness by which the file is saved.
******************************************/
int main(int argc, char *argv[]) {
    if (argc == 3) {
        option1(argv);
    } else if (argc == 5) {
        option2(argv);
    } else if (argc == 6) {
        option3(argv);
    }
    return 0;
}

/******************************************
 *function name: option1
 *The Input: char *argv[]
 *The output: void
 *The Function operation: When file names are obtained without additional
 * flags, create an output file that is a copy of the input file.
******************************************/
void option1(char *argv[]) {
    char buffer[2];
    // open the first file for reading
    FILE *fp1 = fopen(argv[1], "r");
    if (fp1 == NULL) {
        return;
    }
    // overwritten or create the second file for writing,
    FILE *fp2 = fopen(argv[2], "w");
    if (fp2 == NULL) {
        return;
    }
    // Read contents from the first file and copy it to the second file
    long a = fread(buffer, 1, 2, fp1);

    /* As long as we have not reached the end of the file, we will copy a
     * character to character to the new file*/
    while (a > 0) {
        fwrite(buffer, 1, 2, fp2);
        a = fread(buffer, 1, 2, fp1);
    }
    // close the files
    fclose(fp1);
    fclose(fp2);
}

/******************************************
 *function name: option2
 *The Input: char *argv[]
 *The output: void
 *The Function operation: Like 1 + flag indicating the operating system
 * encoding in the input file and flag indicating the desired operating system
 * encoding for the output file.
 * Use the sharedFunc12.
******************************************/
void option2(char *argv[]) {
    sharedFunc12(argv, 0);
}

/******************************************
 *function name: option3
 *The Input: char *argv[]
 *The output: void
 *The Function operation: Like 2 + flag indicating whether to change
 * the endianness by which the file is saved.
 * Use the sharedFunc12.
******************************************/
void option3(char *argv[]) {
    if (strcmp(argv[5], "-swap") == 0) {
        sharedFunc12(argv, 1);
    } else if (strcmp(argv[5], "-keep") == 0) {
        sharedFunc12(argv, 0);
    }
}

/******************************************
 *function name: sharedFunc12
 *The Input: char *argv[], int sign
 *The output: void
 *The Function operation: Performs the work of Option 2 + 3
******************************************/
void sharedFunc12(char *argv[], int sign) {
    char buffer[2];
    // open the first file for reading
    FILE *fp1 = fopen(argv[1], "r");
    if (fp1 == NULL) {
        return;
    }
    // overwritten or create the second file for writing,
    FILE *fp2 = fopen(argv[2], "w");
    if (fp2 == NULL) {
        return;
    }
    // Read contents from the first file and copy it to the second file
    long a =fread(buffer, 1, 2, fp1);

    /* As long as we have not reached the end of the file, we will copy a
     * character to character to the new file and and changes the line breaks'
     * character according to the operating system */
    while (a > 0) {
        // If we received a Unix file and saw \n
        if (strcmp(argv[3], "-unix") == 0) {
            if (*buffer == 0x000a) {
                if (strcmp(argv[4], "-mac") == 0) {
                    *buffer = 0x000d;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    a = fread(buffer, 1, 2, fp1);
                    continue;
                } else if (strcmp(argv[4], "-win") == 0) {
                    buffer[0] = 0x000d;
                    buffer[1] = 0x0000;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    buffer[0] = 0x000a;
                    buffer[1] = 0x0000;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    a = fread(buffer, 1, 2, fp1);
                    continue;
                }
            }
            // If we received a Unix file and saw \r
        } else if (strcmp(argv[3], "-mac") == 0) {
            if (*buffer == 0x000d) {
                if (strcmp(argv[4], "-unix") == 0) {
                    *buffer = 0x000a;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    a = fread(buffer, 1, 2, fp1);
                    continue;
                } else if (strcmp(argv[4], "-win") == 0) {
                    buffer[0] = 0x000d;
                    buffer[1] = 0x0000;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    buffer[0] = 0x000a;
                    buffer[1] = 0x0000;
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(buffer);
                    }
                    fwrite(buffer, 1, 2, fp2);
                    a = fread(buffer, 1, 2, fp1);
                    continue;
                }
            }
            // If we received a Unix file and saw \r\n
        } else if (strcmp(argv[3], "-win") == 0) {
            if (*buffer == 0x000d) {
                char tmp[2];
                strcpy(tmp, buffer);
                a = fread(buffer, 1, 2, fp1);
                if (*buffer == 0x000a) {
                    if (strcmp(argv[4], "-unix") == 0) {
                        *buffer = 0x000a;
                        // if the sign is 1 we do swap
                        if (sign) {
                            swap(buffer);
                        }
                        fwrite(buffer, 1, 2, fp2);
                        a = fread(buffer, 1, 2, fp1);
                        continue;
                    } else if (strcmp(argv[4], "-mac") == 0) {
                        *buffer = 0x000d;
                        // if the sign is 1 we do swap
                        if (sign) {
                            swap(buffer);
                        }
                        fwrite(buffer, 1, 2, fp2);
                        a = fread(buffer, 1, 2, fp1);
                        continue;
                    }
                    // If we saw only \r
                } else {
                    // if the sign is 1 we do swap
                    if (sign) {
                        swap(tmp);
                    }
                    fwrite(tmp, 1, 2, fp2);
                }
            }
        }
        // if the sign is 1 we do swap
        if (sign) {
            swap(buffer);
        }
        fwrite(buffer, 1, 2, fp2);
        a = fread(buffer, 1, 2, fp1);
    }
    // close the files
    fclose(fp1);
    fclose(fp2);
}

/******************************************
 *function name: swap
 *The Input: char *arr
 *The output: void
 *The Function operation: swap the values on the arr
******************************************/
void swap(char *arr) {
    char tmp = arr[0];
    arr[0] = arr[1];
    arr[1] = tmp;
}





