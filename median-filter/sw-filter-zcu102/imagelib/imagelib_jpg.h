#ifndef IMAGELIB_JPG_H
#define IMAGELIB_JPG_H

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

// #define DEBUG
// #define VERBOSE

/* imread_jpg():            it reads an image from a file jpg
 * 
 * uint8_t *image_name:     the whole name of the image to open
 * 
 * uint8_t *out_name:       the image read 
 * 
 */
uint8_t *imread_jpg(char *image_name)
{
    // pointer to the image
    FILE *image_fp;

    if ((image_fp = fopen(image_name, "r")) == NULL)
    {
        printf("Error opening image! Please, insert correct image name.\n");
        exit(1);
    }
    uint8_t buffer[64]; // each buffer should contain 64 bytes
    uint8_t *out_image_ptr = (uint8_t *)malloc(sizeof(uint8_t) * 64);
    // uint8_t *old = malloc(sizeof(uint8_t) * 64);
    int i, n, count = 0;
    while (!feof(image_fp))
    {   
        #ifdef DEBUG
        printf("Count: %d\n", count);
        #endif
        out_image_ptr = (uint8_t *)realloc(out_image_ptr, (count + 1) * sizeof(uint8_t) * 64);
        n = fread(buffer, sizeof(uint8_t), sizeof(buffer), image_fp);
        for (i = 0; i < n; ++i)
        {   
            #ifdef DEBUG
            printf("BUFF[%d]: %d\t%x\n", i, buffer[i], buffer[i]);
            #endif
            out_image_ptr[i + count * 64] = buffer[i];
        }
        count++;

        // *old = *out_image_ptr;
        // *(old) = 10;
        // printf("------------------------------- out_image_ptr: %d\n", *(old + 63), out_image_ptr[0]);
        // free(out_image_ptr);
    }
    #ifdef DEBUG
    printf("Count: %d\n", count);
    #endif
    
    fclose(image_fp);
    return out_image_ptr;
}

#endif