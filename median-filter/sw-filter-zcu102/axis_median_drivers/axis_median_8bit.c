/************************************************************************
 * Filename:        axis_median_8bit.c
 * Description:     Stream median 8bit accelerator Driver
 * Date:            21/04/2022
 ************************************************************************/

#include "axis_median_8bit.h"
#include "axi_dma_driver.c"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>

// #define VERBOSE

/*  load_axis_median_8bit():    load the accelerator using fpgautil
 *
 *	char *accelerator:          the accelerator file name to load
 *
 * 	return 0 if the accelerator has been loaded successfully
 */
int axis_median_8bit_load(char *accelerator){
	char *cmd;
	int size0 = strlen("fpgautil -b ");
	int size1 = strlen(accelerator);

	//#ifdef VERBOSE
    //int size2 = strlen(" > fpgautil_median.log");
    //#endif

	cmd = (char *)malloc(sizeof(char) * (size0+size1));
	
	if (cmd == NULL)
		return -1;
	
	strcpy(cmd, "fpgautil -b "); 
	strcat(cmd, accelerator);
	
	system(cmd);
	free(cmd);
	
	return 0;
}

/*  axis_median_8bit_unload():  unload the accelerator
 *
 * 	return 0 if the accelerator has been unloaded successfully
 */
int axis_median_8bit_unload()
{
    //system("fpgautil -b dummy.bin");
    return 0;
}

/*  axis_median_8bit_init():    init the accelerator
 *
 *  median_8bit_addr_t *addr:	the pointer to the addresses
 *
 * 	return -1 					an error occurs
 *  return  0  					accelerator initiated
 */
int axis_median_8bit_init(median_8bit_addr_t *addr){
	
	// open the ddr
	// -------------------------------------------------------------------
	if((addr->ddr_memory = open("/dev/mem", O_RDWR | O_SYNC)) < 0){
		printf("Error opening the DDR memory.\n");
		return -1;
	}
	
	// mapping the dma
	// -------------------------------------------------------------------
	addr->dma_IN_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, addr->ddr_memory, OFFS_DMA_IN_DATA);	    // MM2S
	if(addr->dma_IN_virtual_addr == MAP_FAILED){
		printf("Error mapping DMA INPUT virtual address.\n");
		return -1;
	}
		
	addr->dma_OUT_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, addr->ddr_memory, OFFS_DMA_OUT_DATA);    // S2MM
	if(addr->dma_OUT_virtual_addr == MAP_FAILED){
		printf("Error mapping DMA OUTPUT virtual address.\n");
		return -1;
	}
	
	
	// mapping the source(s)
	// -------------------------------------------------------------------
	addr->virtual_src_IN_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, addr->ddr_memory, 0x0e000000);
	if(addr->virtual_src_IN_addr == MAP_FAILED){
		printf("Error mapping INPUT virtual source address.\n");
		return -1;
	}
		
	// mapping the destination(s)
	// -------------------------------------------------------------------
	addr->virtual_dst_OUT_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, addr->ddr_memory, 0x0f000000);
	if(addr->virtual_dst_OUT_addr == MAP_FAILED){
		printf("Error mapping OUTPUT virtual destination address.\n");
		return -1;
	}

	// reset the dma
	// -------------------------------------------------------------------
	write_dma(addr->dma_IN_virtual_addr, MM2S_CONTROL_REGISTER, RESET_DMA);
	write_dma(addr->dma_OUT_virtual_addr, S2MM_CONTROL_REGISTER, RESET_DMA);

	#ifdef DEBUG
		// check status of dma
		dma_mm2s_status_print(addr->dma_INT_virtual_addr);
		dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif

	// halt the dma
	// -------------------------------------------------------------------
	// printf("Halt the DMA.\n");
	write_dma(addr->dma_IN_virtual_addr, MM2S_CONTROL_REGISTER, HALT_DMA);
	write_dma(addr->dma_OUT_virtual_addr, S2MM_CONTROL_REGISTER, HALT_DMA);

	#ifdef DEBUG
		// check status of dma
		dma_mm2s_status_print(addr->dma_IN_virtual_addr);
		dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif

	// enable all interrupts
	// -------------------------------------------------------------------
	//printf("Enable all interrupts.\n");
	write_dma(addr->dma_IN_virtual_addr, MM2S_CONTROL_REGISTER, ENABLE_ALL_IRQ); // ENABLE_ALL_IRQ is bit 14, 13, 12
	write_dma(addr->dma_OUT_virtual_addr, S2MM_CONTROL_REGISTER, ENABLE_ALL_IRQ);

	#ifdef DEBUG
	dma_mm2s_status_print(addr->dma_IN_virtual_addr);
	dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif

	// writing the source and destination registers
	// -------------------------------------------------------------------
	//	printf("Writing source address of the data from MM2S in DDR...\n"); // source pointer (pointer to reading data)
	write_dma(addr->dma_IN_virtual_addr, MM2S_SRC_ADDRESS_REGISTER, 0x0e000000);
	//printf("Writing the destination address for the data from S2MM in DDR...\n");
	write_dma(addr->dma_OUT_virtual_addr, S2MM_DST_ADDRESS_REGISTER, 0x0f000000);

	#ifdef DEBUG
	dma_mm2s_status_print(addr->dma_IN_virtual_addr);
	dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif 

	return 0;
}


/*  axis_median_8bit_stop():	stop the accelerator
 *
 *  median_8bit_addr_t *addr:	the pointer to the addresses
 *
 * 	return -1 					an error occurs
 *  return  0  					accelerator stopped
 */
int axis_median_8bit_stop(median_8bit_addr_t *addr){

	// unmapping
	if(munmap(addr->dma_IN_virtual_addr, SIZE_VIRTUAL_ADDR) != 0){
		printf("Error unmapping DMA INPUT virtual address.\n");
		return -1;
	}
	
	if(munmap(addr->dma_OUT_virtual_addr, SIZE_VIRTUAL_ADDR) != 0){
		printf("Error unmapping DMA OUTPUT virtual address.\n");
		return -1;
	}
	
	if(munmap(addr->virtual_src_IN_addr, SIZE_VIRTUAL_ADDR) != 0){
		printf("Error unmapping INPUT virtual source address.\n");
		return -1;
	}

	if(munmap(addr->virtual_dst_OUT_addr, SIZE_VIRTUAL_ADDR) != 0){
		printf("Error unmapping OUTPUT virtual destination address.\n");
		return -1;
	}

	// close /dev/mem
	if(close(addr->ddr_memory) != 0){
		printf("Error closing the DDR memory.\n");
		return -1;
	}
	
	return 0;
}

/*  axis_median_8bit_send(): 	send data the accelerator
 *
 *	uint8_t *in_data:           the data to be sent
 *  int in_size:                the size of in_data, make sure that size % 1024 == 0
 *  int out_size:               the expected number of data out from the accelerator, it has to be written onto the vrt addr
 * 
 *  return -1                   an error occurs
 *  return 0                    data has been sent
 */
int axis_median_8bit_send(median_8bit_addr_t *addr, uint8_t *in_data, int in_size, int out_size){

	// median_8bit_addr_t median_addr = (median_8bit_addr_t)*addr;	// saving the addresses already opened
	
    if(in_size > SIZE_VIRTUAL_ADDR + 1){
        int x = SIZE_VIRTUAL_ADDR + 1;
	    printf("Error sending data to the accelerator! Too much data. Make sure in_size <= SIZE_VIRTUAL_ADDR: %d <= %d\n", in_size, x);
		return -1;
	}

  	// write source data
    addr->virtual_src_IN_addr[0] = (out_size << 8) + in_data[0];
    for(int i = 1; i < in_size; ++i){
		addr->virtual_src_IN_addr[i] = (uint32_t)in_data[i];
	}

	// run the MM2S channel(s)
	// -------------------------------------------------------------------
	//printf("Run the MM2S input channels.\n");
	write_dma(addr->dma_IN_virtual_addr, MM2S_CONTROL_REGISTER, RUN_DMA);

	#ifdef DEBUG
		dma_mm2s_status_print(addr->dma_IN_virtual_addr);
	#endif

	// run the S2MM channel(s)
	// -------------------------------------------------------------------
	//printf("Run the S2MM output channel.\n");
	write_dma(addr->dma_OUT_virtual_addr, S2MM_CONTROL_REGISTER, RUN_DMA);
	#ifdef DEBUG
		dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif

	// writing the MM2S channel(s) transfer lengths
	// -------------------------------------------------------------------
	// printf("Writing MM2S transfer length of size 32-bit-words...\n");
	write_dma(addr->dma_IN_virtual_addr, MM2S_TRNSFR_LENGTH_REGISTER, in_size * 4);
	#ifdef DEBUG
		dma_mm2s_status_print(addr->dma_IN_virtual_addr);
	#endif

	// writing the S2MM channel(s) transfer lengths
	// -------------------------------------------------------------------
	// printf("Writing S2MM transfer length of out_size * 32-bit-words...\n");
    // int out_size = size >> 10;  // out_size / 1024
    // int out_size = size / 1024;  // out_size / 1024
	write_dma(addr->dma_OUT_virtual_addr, S2MM_BUFF_LENGTH_REGISTER, out_size * 4);
	#ifdef DEBUG
		dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif
	
    return 0;
}

/*  axis_median_8bit_wait():    wait the accelerator and return processed data
 *
 * 	uint8_t *out_data:	        the output data from the accelerator
 *  int out_size:               the number of out_data
 */
void axis_median_8bit_wait(median_8bit_addr_t *addr, uint8_t *out_data, int out_size){
		
	// waiting for synchronizations
	// -------------------------------------------------------------------
	// printf("Waiting for MM2S and S2MM synchronizations...\n");
	dma_mm2s_sync(addr->dma_IN_virtual_addr);
	dma_s2mm_sync(addr->dma_OUT_virtual_addr);
	#ifdef DEBUG
		dma_mm2s_status_print(addr->dma_IN_virtual_addr);
		dma_s2mm_status_print(addr->dma_OUT_virtual_addr);
	#endif	
	
	// read data from destination 
	uint8_t *out = out_data;
	for(int i = 0; i < out_size; ++i)
		out[i] = (uint8_t)addr->virtual_dst_OUT_addr[i];
	
}


/*  axis_median_8bit_send_wait():    send data and wait the accelerator
 *
 *	uint8_t *in_data:           the data to be sent
 *  int size:                   the size of in_data, make sure that size % 1024 == 0
 * 	uint8_t *out_data:	        the output data from the accelerator
 *  int out_size:               the expected number of data out from the accelerator
 * 
 *  return -1                   an error occurs
 *  return 0                    data has been sent
 */
int axis_median_8bit_send_wait(median_8bit_addr_t *addr, uint8_t *in_data, int in_size,  uint8_t *out_data, int out_size){
	
    int status = axis_median_8bit_send(addr, in_data, in_size, out_size);
    if(status == 0)
	    axis_median_8bit_wait(addr, out_data, out_size);

    return status;
}


// void set_dma()
// {
//     /*  STEP 1: reset the DMA
//      *
//      * 	MM2S_CR_bit2 = 1
//      *	S2MM_CR_bit2 = 1
//      */

//     /*  STEP 2: make sure the DMA is stopped
//      *
//      * 	MM2S_CR_bit0 = 0 = HALT_DMA
//      *	S2MM_CR_bit0 = 0
//      */
//     /*  STEP 3: enable IOC flag
//      *
//      * 	MM2S_CR_bit14, 13, 12 = 1
//      *	S2MM_CR_bit14, 13, 12 = 1
//      */
//     /*  STEP 4: write the SOURCE ADDRESS register in DDR of the data  MM2S --> DMA IS READING from address specified in SRC_ADDR_REG
//      *
//      * 	offset 0x18 = MM2S_SRC_ADDRESS_REGISTER
//      * 	writing 0x0e000000 --> ADDRESS TO SOURCE DATA (WHERE READ DATA)
//      */
//     /*  STEP 5: write the DESTINATION ADDRESS register in DDR of the data S2MM --> DMA IS WRITING to address specified in DEST_ADDR_REG
//      *
//      * 	offset 0x18 = S2MM_DST_ADDRESS_REGISTER
//      * 	writing 0x0f000000 --> ADDRESS TO DESTINATION DATA (WHERE WRITE DATA)
//      */
// }