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
#define OFFS_DMA_OUT_DATA 0x00A0080000
//#define OFFS_DMA_OUT_DATA 0x00A0010000

// #define SIZE_VIRTUAL_ADDR 65535 // 64K		// SIZE-1
#define SIZE_VIRTUAL_ADDR 524287 // 512K		// SIZE-1

/************************* Struct Definitions **************************/

typedef struct median_8bit_addr{
	int ddr_memory;							// DDR memory
	
	uint32_t *dma_IN_virtual_addr;		    // DMA MM2S: input data
	uint32_t *dma_OUT_virtual_addr;	        // DMA S2MM: output text data
	
	uint32_t *virtual_src_IN_addr;		    // input addr
	uint32_t *virtual_dst_OUT_addr;	        // output addr

} median_8bit_addr_t;
		
/************************ Functions Definitions ************************/

int axis_median_8bit_load(char *accelerator);

int axis_median_8bit_unload();

int axis_median_8bit_init(median_8bit_addr_t *addr);

int axis_median_8bit_stop(median_8bit_addr_t *addr);

int axis_median_8bit_send(median_8bit_addr_t *addr, uint8_t *in_data, int in_size, int out_size);

void axis_median_8bit_wait(median_8bit_addr_t *addr, uint8_t *out_data, int out_size);

int axis_median_8bit_send_wait(median_8bit_addr_t *addr, uint8_t *in_data, int in_size, uint8_t *out_data, int out_size);
 
#endif