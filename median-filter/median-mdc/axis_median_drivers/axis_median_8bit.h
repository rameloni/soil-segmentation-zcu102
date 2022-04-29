/************************************************************************
 * Filename:        axis_median_8bit.h
 * Description:     Stream median 8bit accelerator Driver Header
 * Date:            21/04/2022
 ************************************************************************/

#ifndef AXIS_MEDIAN_8BIT_H
#define AXIS_MEDIAN_8BIT_H
#include <stdint.h>

/************************* Constant Definitions ************************/
// OFFSET DMAs:     depends on the Vivado Address editor
#define OFFS_DMA_IN_DATA 0x00A0000000
#define OFFS_DMA_OUT_DATA 0x00A0010000
#define SIZE_VIRTUAL_ADDR 65535 // 64K

/************************ Functions Definitions ************************/

int load_axis_median_8bit(char *accelerator);

int unload_axis_median_8bit();

// run accelerator
uint8_t *start_axis_median(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size);

#endif