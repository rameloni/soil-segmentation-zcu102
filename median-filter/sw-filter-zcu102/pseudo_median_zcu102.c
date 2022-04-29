#include <stdint.h> // it defines the uint8_t method

// #define STB_IMAGE_IMPLEMENTATION
#include "medianlib_zcu102.h" // import the median lib with the quickmedian fuction
#include "axis_median_drivers/axis_median_8bit.c"
/*  split_rgb(): extracts a component from an array on format rgb,rgb,rgb....rgb
    return uint8_t *array (row major) of the specified component
    return NULL if an error occurs
*/
uint8_t *split_rgb(uint8_t *rgb_img, int xy_size, int comp)
{
    if (comp < 0 || comp > 2)
        return NULL;

    uint8_t *single_comp = malloc(xy_size);

    for (int i = 0; i < xy_size; ++i)
        single_comp[i] = rgb_img[i * 3 + comp];

    return single_comp;
}

/* merge_rgb(): merges three components in a single image rgb,rgb,rgb....rgb
    return uint8_t *array (row major)
*/
uint8_t *merge_rgb(uint8_t *r_img, uint8_t *g_img, uint8_t *b_img, int size)
{
    uint8_t *output = malloc(size * 3);

    for (int i = 0; i < size; ++i)
        output[i + size * 0] = r_img[i];
    for (int i = 0; i < size; ++i)
        output[i + size * 1] = g_img[i];
    for (int i = 0; i < size; ++i)
        output[i + size * 2] = b_img[i];
    return output;
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
    load_axis_median_8bit("axis_median.bin");
    // uint8_t *out_img_r = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 0, x_txt_size, y_txt_size, 1);
    uint8_t *out_img_r = start_axis_median(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 0, x_txt_size, y_txt_size);

    printf("Box filtering G\n");
    // uint8_t *out_img_g = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 1, x_txt_size, y_txt_size, 1);
    uint8_t *out_img_g = start_axis_median(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 1, x_txt_size, y_txt_size);
    printf("Box filtering B\n");
    // uint8_t *out_img_b = box_median_filter(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 2, x_txt_size, y_txt_size, 1);
    uint8_t *out_img_b = start_axis_median(x_kernel_size, y_kernel_size, txt_image + x_txt_size * y_txt_size * 2, x_txt_size, y_txt_size);
    // uint8_t *out_img_g = box_median_filter(x_kernel_size, y_kernel_size, txt_g, x_txt_size, y_txt_size, 1);
    // uint8_t *out_img_b = box_median_filter(x_kernel_size, y_kernel_size, txt_b, x_txt_size, y_txt_size, 1);
    /* WRITE OUTPUT IMAGE */

    uint8_t *out_img_txt = merge_rgb(out_img_r, out_img_g, out_img_b, (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size));
    free(out_img_r);
    free(out_img_g);
    free(out_img_b);
    // uint8_t *out_img_txt = out_img_r;
    printf("Filtering success\n");
    free(txt_image);
    char *ouput_name = argv[4];
    printf("Writing %s", ouput_name);
    // printf("First median value R: %d", *(out_img_txt));
    // printf("First median value G: %d", *(out_img_txt + (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size) * 1));
    // printf("First median value B: %d", *(out_img_txt + (x_txt_size / x_kernel_size) * (y_txt_size / y_kernel_size) * 2));
    imwrite_txt(out_img_txt, x_txt_size / x_kernel_size, y_txt_size / y_kernel_size, 3, ouput_name);
    // imwrite_jpg(out_img_txt, x_txt_size / x_kernel_size, y_txt_size / y_kernel_size, 3);
    free(out_img_txt);
    // test_quickmedian();
    return 0;
}
