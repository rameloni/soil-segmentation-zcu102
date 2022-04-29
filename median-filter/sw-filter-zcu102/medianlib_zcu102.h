/*
    In this file there are the algorithms for compute the median(s), starting from the sorting based median function to the quickmedian.
    As well as image read from txt and image write to txt in a known format.
    All of this function works for uint8_t data.
*/

#ifndef MEDIANLIB_ZCU102_H
#define MEDIANLIB_ZCU102_H

#include "sorting.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
//#include <jpeglib.h>
#endif

// Quickmedian runs in linear time
/*
    input_buff: the input array
    median_pos: the expectated position of the median
    l and r are the delimiters of input_buff, that is r-l = size of input buffer
    pivot: is the expectated median value

    To have an optimal execution, use the half of the values' range in the input buffer, e.g. if range is [0; 255] like uint8_t 8bit images you should choose 127.

*/
// quickmedian():   compute the median value of an array
uint8_t quickmedian(uint8_t input_buff[], int median_pos, int l, int r, int pivot, uint8_t second_median_value);
// imread_txt():    build 8-bit image array (row major format) from a txt file --> FORMAT_ROWS: %3d %3d ....%3d \n
uint8_t *imread_txt(char *image_name, int *cols, int *row, int *comp);
// box_median_filter(): filter based on a rectangular kernel, this function implements both box_filter and median_filter, which to use depends on box_fitering input
uint8_t *box_median_filter(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size, short box_filtering);

int size = 1024;
int count = 0;
void set_kernel_size(int s)
{
    count = 0;
    size = s;
    return;
}

/* box_median_filter(): filter based on a rectangular kernel, this function implements both box_filter and median_filter, which to use depends on box_fitering input
    int (x_kernel_size, y_kernel_size):     kernel sizes
    uint8_t *in_image:                      two-dimensional input image
    int (x_image_size, y_image_size):       input image sizes
    short box_filtering:                    if(box_filtering==1) then compute the box_filter, else compute a median_filter

    return uint8_t *:                       the filtered image
 */
uint8_t *box_median_filter(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size, short box_filtering)
{
    printf("%d\n", *in_image);
    /* DEFINE THE SHAPE (the kernel) */
    // remember to prevent index out of bound or segmentation fault
    int kernel_size = x_kernel_size * y_kernel_size;
    uint8_t *kernel = (uint8_t *)malloc(sizeof(uint8_t) * kernel_size); // the kernel

    // set the size global variable needed by quickmedian
    set_kernel_size(kernel_size);

    // The difference between a median filter and a box
    //  size of the output image (filtered image array)
    int x_out_size = (box_filtering == 0) ? x_image_size : x_image_size / x_kernel_size;
    int y_out_size = (box_filtering == 0) ? y_image_size : y_image_size / y_kernel_size;
    uint8_t *out_image = (uint8_t *)malloc(sizeof(uint8_t) * (x_out_size * y_out_size));

    // find the first pixel to substitute of the input image
    int x_last_px = 0; // starting point
    int y_last_px = 0;

    int x_skip = (box_filtering == 0) ? 1 : x_kernel_size;
    int y_skip = (box_filtering == 0) ? 1 : y_kernel_size;

    for (int y_out = 0; y_out < y_out_size; ++y_out)
    {
        for (int x_out = 0; x_out < x_out_size; ++x_out)
        {
            // populate kernel
            // it prevents the kernel 1x1
            int k = 0;
            for (int x = x_last_px; x < x_kernel_size + x_last_px; ++x)     // width
                for (int y = y_last_px; y < y_kernel_size + y_last_px; ++y) // height
                    kernel[k++] = in_image[x + y * x_image_size];

            x_last_px += x_skip; // next last pixel

            out_image[x_out + y_out * x_out_size] = quickmedian(kernel, (kernel_size) / 2, 0, kernel_size, 127, 0);
        }
        x_last_px = 0; // reset the y axis
        y_last_px += y_skip;

        // check if finished
        // the following control prevents index out of bound error, the y-axis control is not necessary because y_last_px never occurs
        if (y_last_px >= y_image_size)
        {
            // printf("entered");
            free(kernel);
            return out_image;
        }
    }

    free(kernel);
    return out_image;
}

/* quickmedian(): compute the median value of an array --> fast median searching for arrays with a known range values. This method fits perfectly for images which have 8-bit values
    uint8_t input_buff[]:   input array
    int median_pos:         it is the position taht the element would have if the array was sorted
    int l:                  left delimiter of the array
    int r:                  right delimiter of the array
    int pivot:              the pivot is extremly fundamental in median searching, it is used to discard the elements inside input_buff which cannot be the element in median_pos
    second_median_value:it is a support input for even array's sizes in which there isn't a center position but two
*/
uint8_t quickmedian(uint8_t input_buff[], int median_pos, int l, int r, int pivot, uint8_t second_median_value)
{
    printf("----------------------------------------\n");
    printf("size: %5d, l: %4d, r: %4d, pivot: %3d, s_med_val: %3d, med_pos: %3d\n", r - l, l, r, pivot, second_median_value, median_pos);
    if (r <= l)
    {
        fprintf(stderr, "Wrong right and left delimiters! Be sure that right_delimiter > left_delimiter.");
        exit(EXIT_FAILURE);
    }

    // simulating hardware instancing vector of a fixed size
    uint8_t lower[r - l]; // the buffer of all the values inside the input buffer that are SMALLER than pivot
    int lower_idx = 0;    // the pointer to the next element in the lower buffer (the current size of lower buffer)

    uint8_t larger[r - l]; // the buffer of all the values inside the input buffer that are BIGGER than pivot
    int larger_idx = 0;    // the pointer to the next element in the larger buffer (the current size of larger buffer)

    // uint8_t equal[r - l]; // an equal buffer is not needed since its elements are equals to pivot
    int eq_idx = 0; // the pointer to the current last element inside equal buffer, in other words the count of the number of elements equals to pivot inside the buffer (we can consider it like a virtual buffer)

    int min_lower = 255, max_lower = 0;   // the min and max values inside the lower buffer --> it is useful to choose the next pivot
    int min_larger = 255, max_larger = 0; // the min and max values inside the larger buffer --> it is useful to choose the next pivot

    // starting the scan of the input buffer and fill the lower and larger buffers
    for (int i = l; i < r - l; ++i)
    {
        if (input_buff[i] < pivot) // if the scanned element is smaller than pivot, insert it (input_buff[i]) into the lower buffer
        {
            lower[lower_idx] = input_buff[i];

            // update min, max (if needed)
            min_lower = (input_buff[i] < min_lower) ? input_buff[i] : min_lower;
            max_lower = (input_buff[i] > max_lower) ? input_buff[i] : max_lower;
            lower_idx++; // update the idx
        }
        else if (input_buff[i] == pivot) // if the scanned value if equal to pivot, "insert it into the equal buffer"
        {
            eq_idx++;
        }
        else // if the scanned value is greater than pivot, insert it into the lower buffer
        {
            larger[larger_idx] = input_buff[i];

            // update min, max
            min_larger = (input_buff[i] < min_larger) ? input_buff[i] : min_larger;
            max_larger = (input_buff[i] > max_larger) ? input_buff[i] : max_larger;
            larger_idx++;
        }
    }

    // check the median
    if (lower_idx > median_pos) // if the lower_idx reachs the median expected position, it means that the median is inside the lower buffer
    {
        // the median is inside lower buffer --> a new_pivot is needed
        int next_pivot = (max_lower + min_lower) / 2;

        // moreover if max==min there is one value inside this buffer and it means that this value is the median, hence return max_lower (ATTENTION: one value doesn't mean one element)
        // but it is a mistake. For thi reason the following line is commented
        // return (max_lower == min_lower) ? max_lower : quickmedian(larger, next_median_pos, 0, larger_idx, next_pivot, second_median_value);

        printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
        printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, next_pivot, second_median_value);
        return quickmedian(lower, median_pos, 0, lower_idx, next_pivot, second_median_value);
    }
    else if (lower_idx + eq_idx > median_pos) // if the sum of lower_idx and eq_idx reachs the median expected position, it means that the median is inside the equal buffer
    {

        // remember that size is a global variable
        if (size % 2 == 0 && lower_idx == median_pos) // if size is an even number --> the median is the arithmetic mean between the two center elements
        {
            if (median_pos == 0)
            {
                // median_pos==0 means that the searched element is in the first pos of previous-iteration-larger-array.
                // it means that the median is the mean of the pivot and second_median_value (the element in median_pos-1 of the original input_buffer, that of the first function call)
                printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
                printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, (pivot + second_median_value) / 2, (pivot + second_median_value) / 2);
                return (pivot + second_median_value) / 2;
            }
            else
            {
                printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
                printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, (pivot + max_lower) / 2, (pivot + max_lower) / 2);
                // else the median is the mean between pivot and max_lower "the element in pos median_pos-1"
                return (pivot + max_lower) / 2;
            }
        }
        else
        {
            printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
            printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, pivot, pivot);

            // if size is an odd number the input_buff has a central element --> return pivot
            // if lower_idx != median_pos means that median_pos == median_pos-1 in both odd and even sizes --> return pivot
            return pivot;
        }
    }
    else // the median is inside the larger buffer
    {
        // the median is inside the larger buffer --> a new_pivot is needed and a "new median_pos"
        int next_pivot = (max_larger + min_larger) / 2;
        int next_median_pos = median_pos - (lower_idx + eq_idx); // compute the next expected median position "shift the median_pos" --> (lower_idx + eq_idx) is the pointer to the first element of the larger buffer

        if (next_median_pos == 0) // next_median_pos==0 means larger[0]==median_pos --> so the second_median_value is either max_lower or pivot
            second_median_value = (eq_idx == 0) ? max_lower : pivot;

        // moreover if max==min there is one value inside this buffer and it means that this value is the median, hence return max_lower (ATTENTION: one value doesn't mean one element)
        // but it is a mistake. For thi reason the following line is commented
        // return (max_larger == min_larger) ? max_larger : quickmedian(larger, next_median_pos, 0, larger_idx, next_pivot, second_median_value);
        printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
        printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, next_median_pos, next_pivot, second_median_value);

        return quickmedian(larger, next_median_pos, 0, larger_idx, next_pivot, second_median_value);
    }
}

void test_quickmedian()
{
    uint8_t arr[] = {10, 11, 11, 13, 14, 16, 16, 17, 18, 19, 20, 26, 28, 34, 48, 53};
    uint8_t med = quickmedian(arr, 8, 0, 16, 127, 0);

    printf("\n\ntest med: %d\n\n", med);
    return;
}

// A sorting based median function
uint8_t slowmedian(uint8_t *array, int l, int r)
{
    int size = r - l;
    if (size < 0)
    {
        fprintf(stderr, "Negative size provided in findMedian. Please insert one positive.");
        exit(EXIT_FAILURE);
    }

    // for small arrays insertion sort is generally better than merge sort
    if (size < 50)
        insertionSort(array, l, r);
    else
        mergeSort(array, l, r);

    return array[size / 2];
}

/* READING IMAGES */
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
        printf("Count: %d\n", count);
        out_image_ptr = (uint8_t *)realloc(out_image_ptr, (count + 1) * sizeof(uint8_t) * 64);
        n = fread(buffer, sizeof(uint8_t), sizeof(buffer), image_fp);
        for (i = 0; i < n; ++i)
        {
            printf("BUFF[%d]: %d\t%x\n", i, buffer[i], buffer[i]);
            out_image_ptr[i + count * 64] = buffer[i];
        }
        count++;

        // *old = *out_image_ptr;
        // *(old) = 10;
        // printf("------------------------------- out_image_ptr: %d\n", *(old + 63), out_image_ptr[0]);
        // free(out_image_ptr);
        printf("----\n");
    }
    printf("Count: %d\n", count);
    fclose(image_fp);
    return out_image_ptr;
}

// return an array in format {RR...R, GG...G, BB...B}
uint8_t *imread_txt(char *image_name, int *cols, int *rows, int *comp)
{
    FILE *image_fp;
    if ((image_fp = fopen(image_name, "r")) == NULL)
    {
        printf("Error opening image! Please, insert correct image name.\n");
        exit(1);
    }

    /* READING HEADER */
    char c;
    fscanf(image_fp, "%10d", rows);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);
    // reading cols
    fscanf(image_fp, "%10d", cols);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);
    if (rows <= 0 || cols <= 0)
    {
        printf("Error opening image! Please, use correct image txt structure.\n");
        exit(1);
    }
    int pix, n_pixels = 0;
    int comp_count = 0;
    uint8_t *output_image = (uint8_t *)malloc(sizeof(uint8_t) * (*rows) * (*cols));

    while (!feof(image_fp))
    {
        if (sizeof(output_image) < n_pixels)
            output_image = (uint8_t *)realloc(output_image, (n_pixels + 1) * sizeof(uint8_t) * 10);

        fscanf(image_fp, "%3d", &pix);
        output_image[n_pixels] = pix;
        // printf("%d\n", n_pixels);
        char c;
        fscanf(image_fp, "%c", &c); // read space

        fscanf(image_fp, "%c", &c); // read hypothetic "\n"
        if (c == '\n')
            comp_count++;
        else
            fseek(image_fp, -1, SEEK_CUR);

        n_pixels++;
    }

    --n_pixels;
    --comp_count;
    // *rows = rows_count;
    // *cols = n_pixels / rows_count;

    printf("%s\n", image_name);
    printf("N_pixels: %d\ty_size: %d\tx_size: %d\tcomp: %d\n\n", n_pixels, *rows, *cols, *comp);

    fclose(image_fp);
    return output_image;
}

/* WRITING IMAGES*/
void imwrite_txt(uint8_t *in_image, int x_size, int y_size, int comp, char *out_name)
{
    FILE *fp = fopen(out_name, "w+");
    fprintf(fp, "%10d \n", y_size);
    fprintf(fp, "%10d \n", x_size);
    for (int z = 0; z < comp; ++z)
    {
        for (int y = 0; y < y_size; ++y)
        {
            for (int x = 0; x < x_size; ++x)
                fprintf(fp, "%3d ", *(in_image + x + y * x_size + z * x_size * y_size));
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
}

// void imwrite_jpg(uint8_t *in_image, int width, int height, int components)
// {
//     /*
//      *  File:       write_jpeg_example.cpp
//      *  By:         Andrew Noske
//      *  About:
//      *          This file deomstrated the use of "jpeglib"
//      *          by generating a small test image of a checkerboard
//      *          with red and white pixels and the writes this
//      *          out to a jpeg file called "test_jpeg.jpg".
//      */

// //-----------------------------

// char *filename = (char *)"test_jpeg.JPG";
// int quality = 100;

// struct jpeg_compress_struct cinfo; // Basic info for JPEG properties.
// struct jpeg_error_mgr jerr;        // In case of error.
// FILE *outfile;                     // Target file.
// JSAMPROW row_pointer[1];           // Pointer to JSAMPLE row[s].
// int row_stride;                    // Physical row width in image buffer.

// //## ALLOCATE AND INITIALIZE JPEG COMPRESSION OBJECT

// cinfo.err = jpeg_std_error(&jerr);
// jpeg_create_compress(&cinfo);

// //## OPEN FILE FOR DATA DESTINATION:

// if ((outfile = fopen(filename, "wb")) == NULL)
// {
//     fprintf(stderr, "ERROR: can't open %s\n", filename);
//     exit(1);
// }
// jpeg_stdio_dest(&cinfo, outfile);

// //## SET PARAMETERS FOR COMPRESSION:

// cinfo.image_width = width;           // |-- Image width and height in pixels.
// cinfo.image_height = height;         // |
// cinfo.input_components = components; // Number of color components per pixel.
// cinfo.in_color_space = JCS_RGB;      // Colorspace of input image as RGB.

// jpeg_set_defaults(&cinfo);
// jpeg_set_quality(&cinfo, quality, TRUE);

// //## CREATE IMAGE BUFFER TO WRITE FROM AND MODIFY THE IMAGE TO LOOK LIKE CHECKERBOARD:

// unsigned char *image_buffer = NULL;
// image_buffer = (unsigned char *)malloc(cinfo.image_width * cinfo.image_height * cinfo.num_components);
// int i = 0;
// for (int y = 0; y < cinfo.image_height; y++)
//     for (int x = 0; x < cinfo.image_width; x++)
//     {

//         // unsigned int pixelIdx = ((y * cinfo.image_height) + x) * cinfo.input_components;

//         // image_buffer[pixelIdx + 0] = in_image[pixelIdx + 0]; // r |-- Set r,g,b components to
//         // image_buffer[pixelIdx + 1] = in_image[pixelIdx + 1]; // g |   make this pixel red
//         // image_buffer[pixelIdx + 2] = in_imae[pixelIdx + 2]; // b |   (255,0,0).
//         image_buffer[i * 3 + 0] = *(in_image + x + y * cinfo.image_width + 0 * cinfo.image_width * cinfo.image_height); // r |-- Set r,g,b components to
//         image_buffer[i * 3 + 1] = *(in_image + x + y * cinfo.image_width + 1 * cinfo.image_width * cinfo.image_height); // g |   make this pixel red
//         image_buffer[i * 3 + 2] = *(in_image + x + y * cinfo.image_width + 2 * cinfo.image_width * cinfo.image_height); // b |   (255,0,0).        ;

//         i++;
//     }
// //## START COMPRESSION:

// jpeg_start_compress(&cinfo, FALSE);
// row_stride = cinfo.image_width * 3; // JSAMPLEs per row in image_buffer

// while (cinfo.next_scanline < cinfo.image_height)
// {
//     row_pointer[0] = &image_buffer[cinfo.next_scanline * row_stride];
//     (void)jpeg_write_scanlines(&cinfo, row_pointer, 1);
// }
// // NOTE: jpeg_write_scanlines expects an array of pointers to scanlines.
// //       Here the array is only one element long, but you could pass
// //       more than one scanline at a time if that's more convenient.

// //## FINISH COMPRESSION AND CLOSE FILE:

// jpeg_finish_compress(&cinfo);
// fclose(outfile);
// jpeg_destroy_compress(&cinfo);

// printf("SUCCESS\n");
// }
