#include <stdint.h> // it defines the uint8_t method
#include <stdlib.h>
#include <stdio.h>
#define STB_IMAGE_IMPLEMENTATION
#include "../sw-filter/stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../sw-filter/stb/stb_image_write.h"
#include "../sw-filter/medianlib.h"
#include <jpeglib.h>

void imwrite(uint8_t *in_image, int width, int height, int components);
void imwrite_txt(uint8_t *in_image, int x_size, int y_size, char *out_name);

uint8_t *merge_rgb(uint8_t *r_img, uint8_t *g_img, uint8_t *b_img, int size)
{
    uint8_t *output = malloc(size * 3);
    for (int i = 0; i < size; ++i)
    {
        output[i * 3 + 0] = r_img[i];
        output[i * 3 + 1] = g_img[i];
        output[i * 3 + 2] = b_img[i];
    }
    return output;
}

uint8_t *split_rgb(uint8_t *rgb_img, int xy_size, int comp)
{
    if (comp < 0 || comp > 2)
        return NULL;

    uint8_t *single_comp = malloc(xy_size);

    for (int i = 0; i < xy_size; ++i)
    {
        // printf("%d\n", i);
        single_comp[i] = rgb_img[i * 3 + comp];
    }
    // puts("ok");
    return single_comp;
}

int main()
{
    /* READ IMAGE */
    int x_image_size, y_image_size, bpp; // width, height and bit per pixel --> x=width and y=height
    // char *img_name = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/Sample_images/DJI_0002.JPG";
    char *img_name = "/homoe/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/sample_images-median-filter/image.JPG";

    uint8_t *input_rgb = stbi_load(img_name, &x_image_size, &y_image_size, &bpp, 3); // the desired channel is

    // extract the 3 channels
    uint8_t *r = split_rgb(input_rgb, x_image_size * y_image_size, 0);
    uint8_t *g = split_rgb(input_rgb, x_image_size * y_image_size, 1);
    uint8_t *b = split_rgb(input_rgb, x_image_size * y_image_size, 2);
    free(r);
    free(g);
    free(b);

    int x_txt_size, y_txt_size;
    uint8_t *txt_r = imread_txt("/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/py_1st_channel.txt", &x_txt_size, &y_txt_size);

    int tmp_x, tmp_y;
    uint8_t *txt_g = imread_txt("/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/py_2nd_channel.txt", &tmp_x, &tmp_y);
    if (tmp_y != y_txt_size || tmp_x != x_txt_size)
    {
        fprintf(stderr, "Color channels txt files don't match! Be sure that 1st, 2nd and 3rd are of the same image.");
        exit(EXIT_FAILURE);
    }

    uint8_t *txt_b = imread_txt("/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/py_3rd_channel.txt", &tmp_x, &tmp_y);
    if (tmp_y != y_txt_size || tmp_x != x_txt_size)
    {
        fprintf(stderr, "Color channels txt files don't match! Be sure that 1st, 2nd and 3rd are of the same image.");
        exit(EXIT_FAILURE);
    }

    // to make simple the analisys--> just use the first n pixels of the image
    // int n = 32;
    // print output image
    char *out_img_name = "/home/raffaele/borsa-ricerca/soil-segmentation-zcu102/median-filter/debugging/c_out_rgb.JPG";
    // n = 60;
    // uint8_t *o = merge_rgb(out_img_r, out_img_g, out_img_b, n * n);
    // stbi_write_jpg(out_img_name, n, n, 3, o, n * 3);

    int k_size = 32;
    // out_img_r = median(k_size, k_size, r, x_image_size, y_image_size, 1);
    printf("x_txt_size: %d, y_txt_size: %d", x_txt_size, y_txt_size);
    uint8_t *out_img_r = box_median_filter(k_size, k_size, txt_r, x_txt_size, y_txt_size, 1);
    uint8_t *out_img_g = box_median_filter(k_size, k_size, txt_g, x_txt_size, y_txt_size, 1);
    uint8_t *out_img_b = box_median_filter(k_size, k_size, txt_b, x_txt_size, y_txt_size, 1);

    uint8_t *out_img_txt = merge_rgb(txt_r, txt_g, txt_b, x_txt_size * y_txt_size);

    free(txt_r);
    free(txt_g);
    free(txt_b);

    uint8_t *out_img = merge_rgb(out_img_r, out_img_g, out_img_b, (x_txt_size / k_size) * (y_txt_size / k_size));
    // stbi_write_jpg(out_img_name, x_txt_size / k_size, y_txt_size / k_size, 3, out_img, x_txt_size / k_size * 3);
    imwrite(out_img, x_txt_size / k_size, y_txt_size / k_size, 3);
    // imwrite(out_img_txt, x_txt_size, y_txt_size, 3);

    free(out_img);
    free(out_img_txt);

    imwrite_txt(out_img_r, x_txt_size / k_size, y_txt_size / k_size, "c_1st_channel_median.txt");
    imwrite_txt(out_img_g, x_txt_size / k_size, y_txt_size / k_size, "c_2nd_channel_median.txt");
    imwrite_txt(out_img_b, x_txt_size / k_size, y_txt_size / k_size, "c_3rd_channel_median.txt");

    free(out_img_r);
    free(out_img_g);
    free(out_img_b);
    test_quickmedian();
    return 0;
}
void imwrite_txt(uint8_t *in_image, int x_size, int y_size, char *out_name)
{
    FILE *fp = fopen(out_name, "w+");
    for (int y = 0; y < y_size; ++y)
    {
        for (int x = 0; x < x_size; ++x)
        {
            fprintf(fp, "%3d ", in_image[x + y * x_size]);
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
}

void imwrite(uint8_t *in_image, int width, int height, int components)
{
    /*
     *  File:       write_jpeg_example.cpp
     *  By:         Andrew Noske
     *  About:
     *          This file deomstrated the use of "jpeglib"
     *          by generating a small test image of a checkerboard
     *          with red and white pixels and the writes this
     *          out to a jpeg file called "test_jpeg.jpg".
     */

    //-----------------------------

    char *filename = (char *)"test_jpeg.JPG";
    int quality = 100;

    struct jpeg_compress_struct cinfo; // Basic info for JPEG properties.
    struct jpeg_error_mgr jerr;        // In case of error.
    FILE *outfile;                     // Target file.
    JSAMPROW row_pointer[1];           // Pointer to JSAMPLE row[s].
    int row_stride;                    // Physical row width in image buffer.

    //## ALLOCATE AND INITIALIZE JPEG COMPRESSION OBJECT

    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_compress(&cinfo);

    //## OPEN FILE FOR DATA DESTINATION:

    if ((outfile = fopen(filename, "wb")) == NULL)
    {
        fprintf(stderr, "ERROR: can't open %s\n", filename);
        exit(1);
    }
    jpeg_stdio_dest(&cinfo, outfile);

    //## SET PARAMETERS FOR COMPRESSION:

    cinfo.image_width = width;           // |-- Image width and height in pixels.
    cinfo.image_height = height;         // |
    cinfo.input_components = components; // Number of color components per pixel.
    cinfo.in_color_space = JCS_RGB;      // Colorspace of input image as RGB.

    jpeg_set_defaults(&cinfo);
    jpeg_set_quality(&cinfo, quality, TRUE);

    //## CREATE IMAGE BUFFER TO WRITE FROM AND MODIFY THE IMAGE TO LOOK LIKE CHECKERBOARD:

    unsigned char *image_buffer = NULL;
    image_buffer = (unsigned char *)malloc(cinfo.image_width * cinfo.image_height * cinfo.num_components);
    // image_buffer = merge_rgb(R, G, B, cinfo.image_width * cinfo.image_height);
    // image_buffer = in_image;

    for (int y = 0; y < cinfo.image_height; y++)
        for (int x = 0; x < cinfo.image_width; x++)
        {
            // unsigned int pixelIdx = ((y * cinfo.image_height) + x) * cinfo.input_components;

            // image_buffer[pixelIdx + 0] = in_image[pixelIdx + 0]; // r |-- Set r,g,b components to
            // image_buffer[pixelIdx + 1] = in_image[pixelIdx + 1]; // g |   make this pixel red
            // image_buffer[pixelIdx + 2] = in_image[pixelIdx + 2]; // b |   (255,0,0).
            image_buffer[pixelIdx + 0] = *(in_image + x + y * cinfo.image_width + 0 * cinfo.image_width * cinfo.image_height);                             // r |-- Set r,g,b components to
            image_buffer[pixelIdx + 1] = *(in_image + x + y * cinfo.image_width + 1 * cinfo.image_width * cinfo.image_height)                              // g |   make this pixel red
                                         image_buffer[pixelIdx + 2] = *(in_image + x + y * cinfo.image_width + 2 * cinfo.image_width * cinfo.image_height) // b |   (255,0,0).
        }

    //## START COMPRESSION:

    jpeg_start_compress(&cinfo, FALSE);
    row_stride = cinfo.image_width * 3; // JSAMPLEs per row in image_buffer

    while (cinfo.next_scanline < cinfo.image_height)
    {
        row_pointer[0] = &image_buffer[cinfo.next_scanline * row_stride];
        (void)jpeg_write_scanlines(&cinfo, row_pointer, 1);
    }
    // NOTE: jpeg_write_scanlines expects an array of pointers to scanlines.
    //       Here the array is only one element long, but you could pass
    //       more than one scanline at a time if that's more convenient.

    //## FINISH COMPRESSION AND CLOSE FILE:

    jpeg_finish_compress(&cinfo);
    fclose(outfile);
    jpeg_destroy_compress(&cinfo);

    printf("SUCCESS\n");

    // exit(0);
}
