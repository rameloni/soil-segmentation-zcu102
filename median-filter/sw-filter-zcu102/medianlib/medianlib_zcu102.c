#include <stdlib.h>
#include <stdio.h>

#include "medianlib_zcu102.h"

#include "../sorting.h"
#include "../axis_median_drivers/axis_median_8bit.c"

// #define VERBOSE
// #define DEBUG
#define HARDWARE

#ifndef TIMING
#define TIMING
#include <time.h>
#endif

int size = 1024;
int count = 0;

/* set_kernel_size():       it set the global variable size
 * 
 * int s:                   the kernel size
 *
 */ 
void set_kernel_size(int s)
{
    count = 0;
    size = s;
    return;
}

/* slowmedian():            it computes the median in "standard mode" sorting and then array[SIZE/2]
 *
 * uint8_t *array:          the input array
 * int l:                   the left boundary
 * int r:                   the right boundary
 * 
 * uint8_t median:          the median
 */ 
uint8_t slowmedian(uint8_t *array, int l, int r)
{
    int size = r - l;
    if (size < 0)
    {
        fprintf(stderr, "Negative size provided. Please use a positive one.\n");
        exit(EXIT_FAILURE);
    }

    // for small arrays insertion sort is generally better than merge sort
    if (size < 50)
        insertionSort(array, l, r);
    else
        mergeSort(array, l, r);

    return array[size / 2];
}



/* quickmedian():
 *
 * uint8_t input_buff[]:    the input buffer
 * int median_pos:          the expected position of the median  
 * int l:                   the left boundary
 * int r:                   the right boudary
 * int pivot:               the pivot
 * int second_median_value: the second median value which is used if the input_buff size is even,
 *                          indeed, only in this case the median is the arithmetic mean between the two central elements
 *                          (input_buff[SIZE/2]+input_buff[SIZE/2 - 1])/2
 * 
 * return uint8_t median:   the median of the input buffer
 * 
 */
uint8_t quickmedian(uint8_t input_buff[], int median_pos, int l, int r, int pivot, uint8_t second_median_value)
{
    #ifdef VERBOSE
    printf("---------------------------------------------------------\n");
    printf("size: %5d, l: %4d, r: %4d, pivot: %3d, s_med_val: %3d, med_pos: %3d\n", r - l, l, r, pivot, second_median_value, median_pos);
    #endif
    if (r <= l)
    {
        fprintf(stderr, "Wrong right and left delimiters! Be sure that right_delimiter > left_delimiter.\n");
        exit(EXIT_FAILURE);
    }

    uint8_t lower[r - l];   // the buffer of all the values inside the input buffer that are SMALLER than pivot
    int lower_idx = 0;      // the pointer to the next element in the lower buffer (in other words the current size of lower buffer)

    uint8_t larger[r - l];  // the buffer of all the values inside the input buffer that are BIGGER than pivot
    int larger_idx = 0;     // the pointer to the next element in the larger buffer (in other words the current size of larger buffer)

    // uint8_t equal[r - l]; // an equal buffer is not needed since its elements are equals to pivot --> we have already this value: the pivot!
    int eq_idx = 0; // the pointer to the current last element inside equal buffer, in other words the count of the number of elements equals to pivot inside the buffer (we can consider it like a virtual buffer)


    int min_lower = 255, max_lower = 0;   // the min and max values inside the lower buffer  --> they are useful to choose the next pivot
    int min_larger = 255, max_larger = 0; // the min and max values inside the larger buffer --> they are useful to choose the next pivot

    // 1. scan the input buffer and fill the lower and larger buffers
    for (int i = l; i < r - l; ++i)
    {
        if (input_buff[i] < pivot) // if the i-element is smaller than pivot, insert it into the lower buffer
        {
            lower[lower_idx] = input_buff[i];

            // update min, max (if needed)
            if(input_buff[i] < min_lower)
                min_lower = input_buff[i];
            if(input_buff[i] > max_lower)
                max_lower = input_buff[i];
                
            //min_lower = (input_buff[i] < min_lower) ? input_buff[i] : min_lower;
            //max_lower = (input_buff[i] > max_lower) ? input_buff[i] : max_lower;
            
            lower_idx++; // update the idx
        }
        else if (input_buff[i] == pivot) // if i-element if equal to the pivot, "put it into the equal buffer"
        {
            eq_idx++;
        }
        else // if i-element is greater than pivot, put it into the lower buffer
        {
            larger[larger_idx] = input_buff[i];

            // update min, max (if needed)
            if(input_buff[i] < min_larger)
                min_larger = input_buff[i];
            if(input_buff[i] > max_larger)
                max_larger = input_buff[i];
            
            //min_larger = (input_buff[i] < min_larger) ? input_buff[i] : min_larger;
            //max_larger = (input_buff[i] > max_larger) ? input_buff[i] : max_larger;
            
            larger_idx++;
        }
    }

    // 2. check the median
    if (lower_idx > median_pos) // if the lower_idx reachs the median expected position, it means that the median is inside the lower buffer
    {
        int next_pivot = (max_lower + min_lower) / 2;   // update the pivot
        
        #ifdef VERBOSE
        // print the current "control" values
        printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
        printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, next_pivot, second_median_value);
        #endif

        return quickmedian(lower, median_pos, 0, lower_idx, next_pivot, second_median_value);
    }
    else if (lower_idx + eq_idx > median_pos) // if the sum of lower_idx and eq_idx reachs the median expected position, it means that the median is inside the equal buffer
    {
        // size is a global variable
        if (size % 2 == 0 && lower_idx == median_pos) // if size is an even number --> the median is the arithmetic mean between the two center elements
        {
            if (median_pos == 0)
            {
                #ifdef VERBOSE
                // print the current "control" values
                printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
                printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, (pivot + second_median_value) / 2, (pivot + second_median_value) / 2);
                #endif    

                // median_pos==0 means that the searched element is at the first pos of previous-iteration-larger-array.
                // it means that the median is the mean between the pivot and second_median_value (the element in median_pos-1 of the original input_buffer)
                return (pivot + second_median_value) / 2;
            }
            else
            {
                #ifdef VERBOSE
                // print the current "control" values
                printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
                printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, (pivot + max_lower) / 2, (pivot + max_lower) / 2);
                #endif

                // else the median is the mean between pivot and max_lower "the element in pos median_pos-1"
                return (pivot + max_lower) / 2;
            }
        }
        else
        {
            #ifdef VERBOSE
            // print the current "control" values
            printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
            printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, median_pos, pivot, pivot);
            #endif
            
            // if size is an even number the input_buff has a central element --> return pivot
            // if lower_idx != median_pos means that median_pos == median_pos-1 in both odd and even sizes --> return pivot
            return pivot;
        }
    }
    else // the median is inside the larger buffer
    {
        // the median is inside the larger buffer --> a new_pivot is needed and a "new median_pos"
        int next_pivot = (max_larger + min_larger) / 2;             // update the pivot
        int next_median_pos = median_pos - (lower_idx + eq_idx);    // compute the next expected median position "shift the median_pos" --> (lower_idx + eq_idx) is the pointer to the first element of the larger buffer

        if (next_median_pos == 0) // next_median_pos==0 means larger[0]==median_pos --> so the second_median_value is either max_lower or pivot
            second_median_value = (eq_idx == 0) ? max_lower : pivot;

        // moreover if max==min there is one value inside this buffer and it means that this value is the median, hence return max_lower (ATTENTION: one value doesn't mean one element)
        // but it is a mistake. For thi reason the following line is commented
        // return (max_larger == min_larger) ? max_larger : quickmedian(larger, next_median_pos, 0, larger_idx, next_pivot, second_median_value);
        
        #ifdef VERBOSE
        // print the current "control" values
        printf("max_lower: %3d, min_lower: %3d, max_larger: %3d, min_larger: %3d\n", max_lower, min_lower, max_larger, min_larger);
        printf("lower_size: %4d, equal_size: %4d, larger_size: %4d, next_med_pos: %3d, next_pivot: %3d, next2nd: %3d\n", lower_idx, eq_idx, larger_idx, next_median_pos, next_pivot, second_median_value);
        #endif

        return quickmedian(larger, next_median_pos, 0, larger_idx, next_pivot, second_median_value);
    }
}

/* box_median_filter():         it applies an algorithm of median filtering to an input image giving the possibility to choose between box filtering or not
 *
 * int x_kernel_size:           x kernel size side
 * int y_kernel_size:           y kernel size side
 * uint8_t *in_image:           input image array
 * int x_image_size:            input x-side size
 * int y_image_size:            input y-side size
 * short box_filtering:         boolean value to set on/off the box filtering
 * 
 * return uint8_t *out_image:   the filtered image
 * 
 */ 
uint8_t *box_median_filter(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size, short box_filtering)
{
    // printf("%d\n", *in_image);
    // define the kernel
    // remember to prevent index out of bound or segmentation fault

    int kernel_size = x_kernel_size * y_kernel_size;
    
    // 1. set the output sizes
    int x_out_size = (box_filtering == 0) ? x_image_size : x_image_size / x_kernel_size;
    int y_out_size = (box_filtering == 0) ? y_image_size : y_image_size / y_kernel_size;
    
    // declare the output image
    uint8_t *out_image = (uint8_t *)malloc(sizeof(uint8_t) * (x_out_size * y_out_size));

    int x_last_px = 0; // starting point
    int y_last_px = 0;

    int x_skip = (box_filtering == 0) ? 1 : x_kernel_size;  // skipping size
    int y_skip = (box_filtering == 0) ? 1 : y_kernel_size;

    #ifdef VERBOSE
    printf("input image size:\t%dx%d\n", x_image_size, y_image_size);
    printf("kernel size:     \t%dx%d = %d\n", x_kernel_size, y_kernel_size, kernel_size);
    printf("skip (x, y):     \t(%d, %d)\n", x_skip, y_skip);
    #endif

    #ifndef HARDWARE
    uint8_t *kernel = (uint8_t *)malloc(sizeof(uint8_t) * kernel_size);

    // set the size global variable needed by quickmedian
    set_kernel_size(kernel_size);

    #ifdef TIMING
    clock_t tot_start, tot_end, start, end;
    double tot_elapsed, median_elapsed;
    median_elapsed = 0;
    tot_start = clock();
    #endif

    // create the output image
    for (int y_out = 0; y_out < y_out_size; ++y_out)
    {
        for (int x_out = 0; x_out < x_out_size; ++x_out)
        {
            // 2. populate kernel
            int k = 0;
            for (int x = x_last_px; x < x_kernel_size + x_last_px; ++x)     // width
                for (int y = y_last_px; y < y_kernel_size + y_last_px; ++y) // height
                    kernel[k++] = in_image[x + y * x_image_size];
            
            // 3. find the median inside the kernel
            #ifdef TIMING
            start = clock();
            #endif
            
            out_image[x_out + y_out * x_out_size] = quickmedian(kernel, (kernel_size) / 2, 0, kernel_size, 127, 0);
            
            #ifdef TIMING
            end = clock();
            median_elapsed += ((double) (end - start)) / CLOCKS_PER_SEC;
            #endif

            // 4. update the last pixel
            x_last_px += x_skip; 
        }
        // reset last x pixel
        x_last_px = 0;
        // update last y pixel
        y_last_px += y_skip;

        // check if finished
        // the following control prevents index out of bound error, the y-axis control is not necessary because y_last_px never occurs
        // if (y_last_px >= y_image_size)
        // {
        //     free(kernel);
        //     return out_image;
        // }
    }
    #ifdef TIMING
    tot_end = clock();
    tot_elapsed = ((double) (tot_end - tot_start)) / CLOCKS_PER_SEC;
    printf("Total elapsed time: \t%lf\n", tot_elapsed);
    printf("Median elapsed time:\t%lf\n", median_elapsed);
    #endif

    free(kernel);
    #else
    // create the output image using the hardware

    // 1. check the kernel size 
    if (kernel_size != 1024)
    {
        printf("The accelerator support only a kernel of 1024 bytes.\n");
        return NULL;
    }

    // 2. check the input image size 
    int image_size = x_image_size * y_image_size;
    image_size -= image_size % kernel_size;
    #ifdef VERBOSE
    printf("image size acc:\t%d\n", image_size);
    #endif

    if (image_size < 1)
    {
        printf("Please use a positive size for the input buffer.\n");
        return NULL;
    }

    // 3. load the accelerator
    if(axis_median_8bit_load("axis_median_drivers/axis_median_8bit_design_1_wrapper_512k.bin") == -1){
        printf("Error during loading median accelerator.\n");
        return NULL;
    }

    median_8bit_addr_t axis_median_addr;    // declare the median struct
    // 4. init the accelerator
    if(axis_median_8bit_init(&axis_median_addr) == -1)
        return NULL;

    // 5. prepare data and send chunks
    int in_chunk_size = (SIZE_VIRTUAL_ADDR+1)/4;    // the number of accepted data by the accelerator
    int out_chunk_size = in_chunk_size / kernel_size;
    uint8_t *in_data_chunk = (uint8_t *)malloc(sizeof(uint8_t) * in_chunk_size);
    uint8_t *out_data_chunk = (uint8_t *)malloc(sizeof(uint8_t) * out_chunk_size);

    #ifdef VERBOSE
    printf("input chunk size: \t%d\n", in_chunk_size);
    printf("output chunk size:\t%d\n", out_chunk_size);
    #endif
    int x_out = 0, y_out = 0;

    #ifdef TIMING
    clock_t tot_start, tot_end, start, end;
    double tot_elapsed, median_elapsed;
    median_elapsed = 0;
    tot_start = clock();
    #endif

    for (int tot_count = 0; tot_count < image_size; tot_count += in_chunk_size){    // count the number of pixels sent
       
        if(image_size - tot_count < in_chunk_size){
            in_chunk_size = image_size - tot_count;
            out_chunk_size = in_chunk_size / kernel_size;
            printf("new chunk sizes: %d   %d\n", in_chunk_size, out_chunk_size);
        }
        #ifdef DEBUG
        printf("\n\n###############################DEBUG##################################\n");
        printf("partial input tot_count:\t%d\n", tot_count); 
        printf("input chunk size: \t%d\n", in_chunk_size);
        printf("output chunk size:\t%d\n", out_chunk_size);        
        printf("\n\n#############################DATA CHUNK################################\n");
        #endif

        int k = 0;
        while(k < in_chunk_size){
            for (int x = x_last_px; x < x_kernel_size + x_last_px; ++x){     // width
                for (int y = y_last_px; y < y_kernel_size + y_last_px; ++y) // height
                {
                    in_data_chunk[k++] = in_image[x + y * x_image_size];           // write a pixel
                    #ifdef DEBUG_
                    printf("%4d", in_data_chunk[k-1]);
                    #endif
                }
                // printf("\n\n");
            }
            // move to the next kernel
            x_last_px += x_skip; // next last pixel
            if (x_last_px + x_kernel_size > x_image_size)
            {
                #ifdef DEBUG
                printf("Restart last_px: %d\t %d\t --> ", x_last_px, y_last_px);
                #endif
                x_last_px = 0;
                y_last_px += y_skip;
                #ifdef DEBUG
                printf("%d\t %d", x_last_px, y_last_px);
                #endif
                // if (y_last_px + y_kernel_size > y_image_size){
                //     y_last_px = 0;
                // }
            }
        }

        #ifdef TIMING
        start = clock();
        #endif

        #ifndef DEBUG
        if(axis_median_8bit_send(&axis_median_addr, in_data_chunk, in_chunk_size, out_chunk_size) == -1){
            printf("Error sending pixels to the accelerator.\n");
            free(in_data_chunk);
            free(out_data_chunk);
            return NULL;
        }
        axis_median_8bit_wait(&axis_median_addr, out_data_chunk, out_chunk_size);
        #endif

        #ifdef TIMING
        end = clock();
        median_elapsed += ((double) (end - start)) / CLOCKS_PER_SEC;
        #endif
        
        k = 0;
        while ((k < out_chunk_size) & (y_out < y_out_size))
        {
            // write the output image
            #ifndef DEBUG
            out_image[x_out + y_out * x_out_size] = out_data_chunk[k++];
            #else
            printf("k: %d\tx_out: %d\ty_out: %d\n", k, x_out, y_out);
            k++;
            #endif
            x_out++;
            if (x_out >= x_out_size){
                x_out = 0;
                y_out++;
            }
        }
    }
    
    #ifdef TIMING
    tot_end = clock();
    tot_elapsed = ((double) (tot_end - tot_start)) / CLOCKS_PER_SEC;
    printf("Total elapsed time: \t%lf\n", tot_elapsed);
    printf("Median elapsed time:\t%lf\n", median_elapsed);
    #endif

    axis_median_8bit_stop(&axis_median_addr);

    free(in_data_chunk);
    free(out_data_chunk);

    #endif

    return out_image;
}

