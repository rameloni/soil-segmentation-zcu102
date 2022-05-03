#ifndef IMAGELIB_TXT_H
#define IMAGELIB_TXT_H

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

// #define DEBUG
// #define VERBOSE

/* split_rgb():         extracts a component from an array on format [rgb,rgb,rgb....rgb]
 * 
 * uint8_t *rgb_img:    the input image
 * int xy_size:         the size of the input image
 * int comp:            the component. It could be 0 (red), 1 (green), 2 (blue)
 * 
 * return uint8_t *:    an array (row major) of the specified component
 * return NULL:         if an error occurs
*/
uint8_t *split_rgb(uint8_t *rgb_img, int xy_size, int comp)
{
    if (comp < 0 || comp > 2)
        return NULL;

    uint8_t *single_comp = (uint8_t *)malloc(sizeof(uint8_t) * xy_size);

    for (int i = 0; i < xy_size; ++i)
        single_comp[i] = rgb_img[i * 3 + comp];

    return single_comp;
}

/* merge_rgb():         merges three components in a single image [rgb,rgb,rgb....rgb]
 * 
 * uint8_t *r_img:      the input image (r channel)
 * uint8_t *g_img:      the input image (g channel)
 * uint8_t *b_img:      the input image (b channel)
 * int size:            the size of the input image
 * 
 * return uint8_t *:    an array (row major) of the merged image
 * return NULL:         if an error occurs
*/
uint8_t *merge_rgb(uint8_t *r_img, uint8_t *g_img, uint8_t *b_img, int size)
{
    uint8_t *output = (uint8_t *)malloc(sizeof(uint8_t) * size * 3);

    // r channel
    for (int i = 0; i < size; ++i)
        output[i + size * 0] = r_img[i];

    // g channel
    for (int i = 0; i < size; ++i)
        output[i + size * 1] = g_img[i];
    
    // b channel
    for (int i = 0; i < size; ++i)
        output[i + size * 2] = b_img[i];
    
    return output;
}

/* imread_txt():            it reads an image from a file txt
 * 
 * char *image_name:        the input image whole name
 * int *cols:               the number of cols of the image read from the input file txt
 * int *rows:               the number of rows of the image read from the input file txt
 * int *n_comp:             the number of comps of the image read from the input file txt
 * 
 * return uint8_t *image:   n an array (row major) with the format [r,r...r, g,g...g, b,b...b]
 * 
 */ 
uint8_t *imread_txt(char *image_name, int *cols, int *rows, int *n_comp)
{
    FILE *image_fp;
    if ((image_fp = fopen(image_name, "r")) == NULL)
    {
        printf("Error opening image! Please, insert correct image name.\n");
        exit(1);
    }

    // reading the header of the file
    char c;
    
    // reading the number of rows
    fscanf(image_fp, "%10d", rows);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);

    // reading the number of columns
    fscanf(image_fp, "%10d", cols);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);

    if (rows <= 0 || cols <= 0)
    {
        printf("Error opening image! Please, use the correct image txt format.\n");
        exit(1);
    }

    int pix, n_pixels = 0;
    int comp_count = 0;
    uint8_t *output_image = (uint8_t *)malloc(sizeof(uint8_t) * (*rows) * (*cols));

    // read the whole file
    while (!feof(image_fp))
    {
        if (sizeof(output_image) < n_pixels)    // it prevents index out of bound
            output_image = (uint8_t *)realloc(output_image, (n_pixels + 1) * sizeof(uint8_t) * 10);

        fscanf(image_fp, "%3d", &pix);          // read the next pixel
        output_image[n_pixels] = pix;
        #ifdef DEBUG
        printf("Current num pixels: %d\n", n_pixels);
        #endif

        char c;
        fscanf(image_fp, "%c", &c); // read space

        fscanf(image_fp, "%c", &c); // read hypothetic "\n"

        if (c == '\n')              // if the read char is a newline a new component has been found
            comp_count++;
        else
            fseek(image_fp, -1, SEEK_CUR);

        n_pixels++;                 // upgrade the count of pixels
    }

    --n_pixels;
    --comp_count;

    *n_comp = comp_count;
    // *rows = rows_count;
    // *cols = n_pixels / rows_count;
    #ifdef VERBOSE
    printf("Read: %s\n", image_name);
    printf("N_pixels: %d\ty_size: %d\tx_size: %d\tcomp: %d\n\n", n_pixels, *rows, *cols, *n_comp);
    #endif

    fclose(image_fp); 
    return output_image;
}

/* imwrite_txt():           it writes an image into a file txt
 * 
 * uint8_t *in_image:       the input image
 * int x_size:              the x-side image size
 * int y_size:              the y-side image size
 * int n_comp:              the number of comps of the image read from the input file txt
 * char *out_name:          the output image whole name
 * 
 */
void imwrite_txt(uint8_t *in_image, int x_size, int y_size, int n_comp, char *out_name)
{
    FILE *fp = fopen(out_name, "w+");

    // write the file header
    fprintf(fp, "%10d \n", y_size);
    fprintf(fp, "%10d \n", x_size);
    
    // write the pixels
    for (int z = 0; z < n_comp; ++z)
    {
        for (int y = 0; y < y_size; ++y)
        {
            for (int x = 0; x < x_size; ++x){
                fprintf(fp, "%3d ", *(in_image + x + y * x_size + z * x_size * y_size));
            }
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
}




#endif