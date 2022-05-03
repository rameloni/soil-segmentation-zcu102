#include <stdint.h> // it defines the uint8_t method

#include "imagelib/imagelib_txt.h"
#include "imagelib/imagelib_jpg.h"
#include "medianlib/medianlib_zcu102.c" // import the median lib with the quickmedian fuction

#ifndef TIMING
#define TIMING
#include <time.h>
#endif

void test_quickmedian()
{
    uint8_t arr[] = {10, 11, 11, 13, 14, 16, 16, 17, 18, 19, 20, 26, 28, 34, 48, 53};
    uint8_t med = quickmedian(arr, 8, 0, 16, 127, 0);

    printf("\n\ntest med: %d\n\n", med);
    return;
}



/* MEDIAN METHOD*/

int main(int argc, char *argv[])
{
    // read input from terminal
    if (argc <= 4)
    {
        fprintf(stderr, "Inputs not found!\nPlease enter: %s <path-to-image-txt> x_kernel_size y_kernel_size <output-path-image-txt>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    /* READ IMAGE */
    int x_txt_size, y_txt_size, comp; // width, height and bit per pixel --> x=width and y=height
    char *img_name = argv[1];
    printf("Reading %s\n", img_name);
    uint8_t *txt_image = imread_txt(img_name, &x_txt_size, &y_txt_size, &comp);

    if (txt_image == NULL)
    {
        fprintf(stderr, "Image not found!\nPlease enter: %s <path-to-image> width_kernel_size height_kernel_size <output-path-image-txt>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    printf("Input image size:\t%dx%d\n", y_txt_size, x_txt_size);

    /* COMPUTE BOX FILTERING MEDIAN BASED */
    // define the kernel size
    int x_kernel_size = strtol(argv[2], NULL, 10), y_kernel_size = strtol(argv[3], NULL, 10);
    printf("Kernel sizes:\t%dx%d\n", x_kernel_size, y_kernel_size);

    printf("Box filtering R\n");
    #ifdef TIMING
    clock_t tot_start, tot_end;
    double tot_elapsed;
    tot_start = clock();
    #endif
    uint8_t *out_img_r = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 0, x_txt_size, y_txt_size, 1);
    printf("Box filtering G\n");
    uint8_t *out_img_g = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 1, x_txt_size, y_txt_size, 1);
    printf("Box filtering B\n");
    uint8_t *out_img_b = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 2, x_txt_size, y_txt_size, 1);

    #ifdef TIMING
    tot_end = clock();
    tot_elapsed = ((double) (tot_end - tot_start)) / CLOCKS_PER_SEC;
    printf("\n\nTotal elapsed time (R+G+B): \t%lf\n", tot_elapsed);
    #endif

    /* WRITE OUTPUT IMAGE */

    uint8_t *out_img_txt = merge_rgb(out_img_r, out_img_g, out_img_b, (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size));
    free(out_img_r);
    free(out_img_g);
    free(out_img_b);
    // uint8_t *out_img_txt = out_img_r;
    printf("\nFiltering success\n");
    free(txt_image);
    
    
    char *ouput_name = argv[4];
    printf("Writing %s\n\n", ouput_name);
    // printf("First median value R: %d", *(out_img_txt));
    // printf("First median value G: %d", *(out_img_txt + (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size) * 1));
    // printf("First median value B: %d", *(out_img_txt + (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size) * 2));
    imwrite_txt(out_img_txt, x_txt_size / x_kernel_size, y_txt_size / y_kernel_size, 3, ouput_name);
    // imwrite_jpg(out_img_txt, x_txt_size / x_kernel_size, y_txt_size / y_kernel_size, 3);
    free(out_img_txt);
    
    // test_quickmedian();
    
    return 0;
}
