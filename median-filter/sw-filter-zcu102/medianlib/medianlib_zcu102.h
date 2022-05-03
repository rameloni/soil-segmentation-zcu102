#ifndef MEDIANLIB_ZCU102_H
#define MEDIANLIB_ZCU102_H

#include <stdio.h>

//#include <jpeglib.h>
uint8_t slowmedian(uint8_t *array, int l, int r);

void set_kernel_size(int s);

uint8_t quickmedian(uint8_t input_buff[], int median_pos, int l, int r, int pivot, uint8_t second_median_value);

uint8_t *box_median_filter(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size, short box_filtering);

#endif

