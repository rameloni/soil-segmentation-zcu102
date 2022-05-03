/*****************************************************************************
*  Filename:          s_accelerator.c
*  Description:       Stream Accelerator Driver
*  Date:              2022/03/30 16:12:02 (by Multi-Dataflow Composer - Platform Composer)
*****************************************************************************/

#include "s_accelerator.h"

int s_accelerator_median_8bit(
	// port out_second_median_value
	int size_out_second_median_value, int* data_out_second_median_value,
	// port out_median_pos
	int size_out_median_pos, int* data_out_median_pos,
	// port out_buff_size
	int size_out_buff_size, int* data_out_buff_size,
	// port out_pivot
	int size_out_pivot, int* data_out_pivot,
	// port out_px
	int size_out_px, int* data_out_px,
	// port in_second_median_value
	int size_in_second_median_value, int* data_in_second_median_value,
	// port in_median_pos
	int size_in_median_pos, int* data_in_median_pos,
	// port in_buff_size
	int size_in_buff_size, int* data_in_buff_size,
	// port in_pivot
	int size_in_pivot, int* data_in_pivot,
	// port in_px
	int size_in_px, int* data_in_px
	) {
	
	volatile int* config = (int*) XPAR_S_ACCELERATOR_0_CFG_BASEADDR;

	// configure I/O
	*(config + 1) = size_out_px;
	*(config + 2) = size_out_pivot;
	*(config + 3) = size_out_buff_size;
	*(config + 4) = size_out_median_pos;
	*(config + 5) = size_out_second_median_value;
	
	// start execution
	*(config) = 0x1000001;
	
		// send data port in_px
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x00>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x04>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x18>>2)) = (int) data_in_px; // src
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x28>>2)) = size_in_px*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x04>>2))) & 0x2) != 0x2);
		// send data port in_pivot
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x00>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x04>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x18>>2)) = (int) data_in_pivot; // src
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x28>>2)) = size_in_pivot*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x04>>2))) & 0x2) != 0x2);
		// send data port in_buff_size
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x00>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x04>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x18>>2)) = (int) data_in_buff_size; // src
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x28>>2)) = size_in_buff_size*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x04>>2))) & 0x2) != 0x2);
		// send data port in_median_pos
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x00>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x04>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x18>>2)) = (int) data_in_median_pos; // src
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x28>>2)) = size_in_median_pos*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x04>>2))) & 0x2) != 0x2);
		// send data port in_second_median_value
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x00>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x04>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x18>>2)) = (int) data_in_second_median_value; // src
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x28>>2)) = size_in_second_median_value*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x04>>2))) & 0x2) != 0x2);
	
		// receive data port out_px
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x30>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x34>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x48>>2)) = (int) data_out_px; // dst
		*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x58>>2)) = size_out_px*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_0_BASEADDR + (0x34>>2))) & 0x2) != 0x2);
		// receive data port out_pivot
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x30>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x34>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x48>>2)) = (int) data_out_pivot; // dst
		*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x58>>2)) = size_out_pivot*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_1_BASEADDR + (0x34>>2))) & 0x2) != 0x2);
		// receive data port out_buff_size
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x30>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x34>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x48>>2)) = (int) data_out_buff_size; // dst
		*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x58>>2)) = size_out_buff_size*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_2_BASEADDR + (0x34>>2))) & 0x2) != 0x2);
		// receive data port out_median_pos
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x30>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x34>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x48>>2)) = (int) data_out_median_pos; // dst
		*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x58>>2)) = size_out_median_pos*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_3_BASEADDR + (0x34>>2))) & 0x2) != 0x2);
		// receive data port out_second_median_value
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x30>>2)) = 0x00000001; // start
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x34>>2)) = 0x00000000; // reset idle
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x48>>2)) = (int) data_out_second_median_value; // dst
		*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x58>>2)) = size_out_second_median_value*4; // size [B]
		while(((*((volatile int*) XPAR_AXI_DMA_4_BASEADDR + (0x34>>2))) & 0x2) != 0x2);
	
	// stop execution
	//*(config) = 0x0;
	
	return 0;
}
