#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

// #define R 0
// #define G 1
// #define B 2

/* Return the value of the pixel at [row][col] */
uint8_t read_px(uint8_t *image, int row, int col, int width, int height, int ch)
{
    return image[(col + row * width) + ch * width * height];
}
void insertionSort(uint8_t arr[], int n)
{
    int i, j;
    uint8_t key;
    for (i = 1; i < n; i++)
    {
        key = arr[i];
        j = i - 1;

        /* Move elements of arr[0..i-1], that are
		greater than key, to one position ahead
		of their current position */
        while (j >= 0 && arr[j] > key)
        {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

uint8_t median();
// stbi_uc *stbi_load (char const *filename, int *x, int *y, int *channels_in_file, int desired_channels);

int main()
{
    /* Reading the input image */
    int n_ch = 1;
    // char *img = "image.png";
    char *img = "../Sample_images/DJI_0002.JPG";
    int width, height, bpp;                                           // width, height and bit per pixel
    uint8_t *input_rgb = stbi_load(img, &width, &height, &bpp, n_ch); // 3 are the desired channels
    printf("%dx%d\n", width, height);

    uint8_t *_img = input_rgb;
    /* Apply the filter*/
    uint8_t *kernel = malloc(9);                      // kernel 3x3
    uint8_t *out_img = malloc(height * width * n_ch); // output image

    for (int ch = 0; ch < n_ch; ch++)
        for (int row = 1; row < height - 1; ++row)
        {
            for (int col = 1; col < width - 1; ++col)
            {
                //neighbor pixel values are stored in window including this pixel
                kernel[0] = read_px(_img, row - 1, col - 1, width, height, ch);
                kernel[1] = read_px(_img, row - 1, col, width, height, ch);
                kernel[2] = read_px(_img, row - 1, col + 1, width, height, ch);
                kernel[3] = read_px(_img, row, col - 1, width, height, ch);
                kernel[4] = read_px(_img, row, col, width, height, ch);
                kernel[5] = read_px(_img, row, col + 1, width, height, ch);
                kernel[6] = read_px(_img, row + 1, col, width, height, ch);
                kernel[7] = read_px(_img, row + 1, col, width, height, ch);
                kernel[8] = read_px(_img, row + 1, col + 1, width, height, ch);
                //sort windo_img

                insertionSort(kernel, 9);

                //put the median to the new array
                out_img[(col + row * width) + height * width * ch] = kernel[4];
            }
        }

    puts("okf");
    stbi_write_png("out_image_c.png", width, height, n_ch, out_img, width * n_ch);

    return 0;
}

// stbi_write_png("out_g_image.pnfg", width, height, 1, g_image, width);
// stbi_write_png("out_b_image.pnfg", width, height, 1, b_image, width);

// /* Copy the input image into an array */
// uint8_t copy_rgb[width][height][3];

// uint8_t *rgb_image = stbi_load("out_image.png", &width, &height, &bpp, 3);
// printf("%d ", bpp);

// uint8_t *out_image = malloc(width * height * 3);

// FILE *fp = fopen("image.values.txt", "w+");
// FILE *fp2 = fopen("array.values.txt", "w+");

// // fprintf(fp, rgb_image);
// int r = 1, c = 5;
// // printf("%d\n", rgb_image[r + c * width]);
// height = width = 300;
// uint8_t out[height][width];
// uint8_t real_out[height * width];
// float passo = (float)256 / (height * width);
// float v = 0;
// printf("%f", passo);
// for (int r = 0; r < height; ++r)
// {
//     for (int c = 0; c < width; ++c)
//     {
//         out[r][c] = v;
//         fprintf(fp, "%3d ", rgb_image[c + r * width]);
//         real_out[c + r * width] = 128;
//         // fprintf(fp, "%3d ", rgb_image[c + r * width]);
//         // fprintf(fp2, "%3d ", out[r][c]);
//         fprintf(fp2, "%3d ", real_out[c + r * width]);
//         v += passo;
//     }
//     fprintf(fp, "\n");
//     fprintf(fp2, "\n");
// }
// printf("%dx%d\n", width, height);
// stbi_write_png("out_image.png", width, height, 1, out, width);
// // stbi_write_png("out_image.png", width, height, 3, rgb_image, width * 3);
// stbi_image_free(rgb_image);

// fclose(fp);
// fclose(fp2);
// free(r_image);
// free(b_image);
// free(g_image);