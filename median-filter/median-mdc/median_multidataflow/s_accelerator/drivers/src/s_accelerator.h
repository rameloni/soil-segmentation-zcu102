/*****************************************************************************
*  Filename:          s_accelerator.h
*  Description:       Stream Accelerator Driver Header
*  Date:              2022/03/30 16:12:02 (by Multi-Dataflow Composer - Platform Composer)
*****************************************************************************/

#ifndef S_ACCELERATOR_H
#define S_ACCELERATOR_H

/***************************** Include Files *******************************/		
#include "xparameters.h"

/************************** Constant Definitions ***************************/
/************************* Functions Definitions ***************************/


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
);


#endif /** MM_ACCELERATOR_H */
