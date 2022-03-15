#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <termios.h>
#include <sys/mman.h>

#include <stdlib.h>

// offsets specified in AXI DMA reference guide
// https://www.xilinx.com/support/documentation/ip_documentation/axi_dma/v7_1/pg021_axi_dma.pdf
#define MM2S_CONTROL_REGISTER 0x00
#define MM2S_STATUS_REGISTER 0x04
#define MM2S_SRC_ADDRESS_REGISTER 0x18
#define MM2S_TRNSFR_LENGTH_REGISTER 0x28

#define S2MM_CONTROL_REGISTER 0x30
#define S2MM_STATUS_REGISTER 0x34
#define S2MM_DST_ADDRESS_REGISTER 0x48
#define S2MM_BUFF_LENGTH_REGISTER 0x58

// FLAGS for synchronization
#define IOC_IRQ_FLAG 1 << 12 // 0001 0000 0000 0000 = 1000
#define IDLE_FLAG 1 << 1	 // 0000 0000 0000 0010 = 0002

// check status content
#define STATUS_HALTED 0x00000001		   // 0000 0000 0000 0000 . 0000 0000 0000 0001
#define STATUS_IDLE 0x00000002			   // 0000 0000 0000 0000 . 0000 0000 0000 0010
#define STATUS_SG_INCLDED 0x00000008	   // 0000 0000 0000 0000 . 0000 0000 0000 1000
#define STATUS_DMA_INTERNAL_ERR 0x00000010 // 0000 0000 0000 0000 . 0000 0000 0001 0000
#define STATUS_DMA_SLAVE_ERR 0x00000020	   // 0000 0000 0000 0000 . 0000 0000 0010 0000
#define STATUS_DMA_DECODE_ERR 0x00000040   // 0000 0000 0000 0000 . 0000 0000 0100 0000
#define STATUS_SG_INTERNAL_ERR 0x00000100  // 0000 0000 0000 0000 . 0000 0001 0000 0000
#define STATUS_SG_SLAVE_ERR 0x00000200	   // 0000 0000 0000 0000 . 0000 0010 0000 0000
#define STATUS_SG_DECODE_ERR 0x00000400	   // 0000 0000 0000 0000 . 0000 0100 0000 0000
#define STATUS_IOC_IRQ 0x00001000		   // 0000 0000 0000 0000 . 0001 0000 0000 0000
#define STATUS_DELAY_IRQ 0x00002000		   // 0000 0000 0000 0000 . 0010 0000 0000 0000
#define STATUS_ERR_IRQ 0x00004000		   // 0000 0000 0000 0000 . 0100 0000 0000 0000

// control
#define HALT_DMA 0x00000000			// 0000 0000 0000 0000 . 0000 0000 0000 0000
#define RUN_DMA 0x00000001			// 0000 0000 0000 0000 . 0000 0000 0000 0001
#define RESET_DMA 0x00000004		// 0000 0000 0000 0000 . 0000 0000 0000 0100
#define ENABLE_IOC_IRQ 0x00001000	// 0000 0000 0000 0000 . 0001 0000 0000 0000
#define ENABLE_DELAY_IRQ 0x00002000 // 0000 0000 0000 0000 . 0010 0000 0000 0000
#define ENABLE_ERR_IRQ 0x00004000	// 0000 0000 0000 0000 . 0100 0000 0000 0000
#define ENABLE_ALL_IRQ 0x00007000	// 0000 0000 0000 0000 . 0111 0000 0000 0000

/* write_dma(): write a value into memory
 *
 *	unsigned int *virtual_addr: the address in which value should be written
 *	int offset:					offset of virtual_addr base address
 *	unsigned int value:			the value to write into memory
 *
 * 	return 0 if the writing is ok
 */
unsigned int write_dma(unsigned int *virtual_addr, int offset, unsigned int value)
{
	virtual_addr[offset >> 2] = value;
	// virtual_addr[offset] = value;
	return 0;
}

/* read_dma(): read a value from memory
 *
 *	unsigned int *virtual_addr: the address in which value should be read
 *	int offset:					offset of virtual_addr base address
 *
 * 	return the read value
 */
unsigned int read_dma(unsigned int *virtual_addr, int offset)
{
	return virtual_addr[offset >> 2];
	// return virtual_addr[offset];
}

/* dma_s2mm_status(): print the status of dma_s2mm
 *
 *	print the s2mm status register
 *
 * 	return void
 */
void dma_s2mm_status(unsigned int *virtual_addr)
{
	// read the status
	// S2MM_STATUS_REGISTER --> offset of S2MM status register
	unsigned int status = read_dma(virtual_addr, S2MM_STATUS_REGISTER);

	printf("Stream to memory-mapped status (0x%08x@0x%02x):", status, S2MM_STATUS_REGISTER);

	if (status & STATUS_HALTED)
	{
		printf(" Halted.\n");
	}
	else
	{
		printf(" Running.\n");
	}

	if (status & STATUS_IDLE)
	{
		printf(" Idle.\n");
	}

	if (status & STATUS_SG_INCLDED)
	{
		printf(" SG is included.\n");
	}

	if (status & STATUS_DMA_INTERNAL_ERR)
	{
		printf(" DMA internal error.\n");
	}

	if (status & STATUS_DMA_SLAVE_ERR)
	{
		printf(" DMA slave error.\n");
	}

	if (status & STATUS_DMA_DECODE_ERR)
	{
		printf(" DMA decode error.\n");
	}

	if (status & STATUS_SG_INTERNAL_ERR)
	{
		printf(" SG internal error.\n");
	}

	if (status & STATUS_SG_SLAVE_ERR)
	{
		printf(" SG slave error.\n");
	}

	if (status & STATUS_SG_DECODE_ERR)
	{
		printf(" SG decode error.\n");
	}

	if (status & STATUS_IOC_IRQ)
	{
		printf(" IOC interrupt occurred.\n");
	}

	if (status & STATUS_DELAY_IRQ)
	{
		printf(" Interrupt on delay occurred.\n");
	}

	if (status & STATUS_ERR_IRQ)
	{
		printf(" Error interrupt occurred.\n");
	}
}

/* dma_mm2s_status(): print the status of dma_mm2s
 *
 *	print the mm2s status register
 *
 * 	return void
 */
void dma_mm2s_status(unsigned int *virtual_addr)
{

	// read the status
	// MM2S_STATUS_REGISTER --> offset of MM2S status register
	unsigned int status = read_dma(virtual_addr, MM2S_STATUS_REGISTER);

	printf("Memory-mapped to stream status (0x%08x@0x%02x):", status, MM2S_STATUS_REGISTER);

	if (status & STATUS_HALTED)
	{
		printf(" Halted.\n");
	}
	else
	{
		printf(" Running.\n");
	}

	if (status & STATUS_IDLE)
	{
		printf(" Idle.\n");
	}

	if (status & STATUS_SG_INCLDED)
	{
		printf(" SG is included.\n");
	}

	if (status & STATUS_DMA_INTERNAL_ERR)
	{
		printf(" DMA internal error.\n");
	}

	if (status & STATUS_DMA_SLAVE_ERR)
	{
		printf(" DMA slave error.\n");
	}

	if (status & STATUS_DMA_DECODE_ERR)
	{
		printf(" DMA decode error.\n");
	}

	if (status & STATUS_SG_INTERNAL_ERR)
	{
		printf(" SG internal error.\n");
	}

	if (status & STATUS_SG_SLAVE_ERR)
	{
		printf(" SG slave error.\n");
	}

	if (status & STATUS_SG_DECODE_ERR)
	{
		printf(" SG decode error.\n");
	}

	if (status & STATUS_IOC_IRQ)
	{
		printf(" IOC interrupt occurred.\n");
	}

	if (status & STATUS_DELAY_IRQ)
	{
		printf(" Interrupt on delay occurred.\n");
	}

	if (status & STATUS_ERR_IRQ)
	{
		printf(" Error interrupt occurred.\n");
	}
}

/* dma_mm2s_sync(): wait for mm2s synchronization
 *
 *	print the mm2s status register
 *
 * 	return void
 */
int dma_mm2s_sync(unsigned int *virtual_addr)
{
	// read dma MM2S status register
	unsigned int mm2s_status = read_dma(virtual_addr, MM2S_STATUS_REGISTER);

	// sit in this while loop as long as the status does not read back 0x00001002 (4098)
	//
	// 0x00001002 = IOC interrupt has occured and DMA is idle
	// #define IOC_IRQ_FLAG                1<<12	// 0001 0000 0000 0000 = 00001000
	// #define IDLE_FLAG                   1<<1		// 0000 0000 0000 0010 = 00000002

	while (!(mm2s_status & IOC_IRQ_FLAG) || !(mm2s_status & IDLE_FLAG)) // and bitwise
	{
		dma_s2mm_status(virtual_addr);
		dma_mm2s_status(virtual_addr);

		mm2s_status = read_dma(virtual_addr, MM2S_STATUS_REGISTER);
	}

	return 0;
}

int dma_s2mm_sync(unsigned int *virtual_addr)
{
	unsigned int s2mm_status = read_dma(virtual_addr, S2MM_STATUS_REGISTER);

	// sit in this while loop as long as the status does not read back 0x00001002 (4098)
	// 0x00001002 = IOC interrupt has occured and DMA is idle
	while (!(s2mm_status & IOC_IRQ_FLAG) || !(s2mm_status & IDLE_FLAG))
	{
		//      dma_s2mm_status(virtual_addr);
		//      dma_mm2s_status(virtual_addr);

		s2mm_status = read_dma(virtual_addr, S2MM_STATUS_REGISTER);
	}

	return 0;
}

void print_mem(void *virtual_address, int byte_count)
{
	char *data_ptr = virtual_address;

	for (int i = 0; i < byte_count; i++)
	{
		printf("%02X", data_ptr[i]);

		// print a space every 4 bytes (0 indexed)
		if (i % 4 == 3)
		{
			printf(" ");
		}
	}

	printf("\n");
}

int main()
{
	// load the accelerator
	system("fpgautil -b fifo_easy_hw.bin");
	puts("");
	puts("---------------------------------------------------------------------------------");
	printf("Hello World! - Running DMA transfer test application.\n");

	// OPEN DDR MEMORY 	--> open()
	printf("Opening a character device file of the Arty's DDR memory...\n");
	int ddr_memory = open("/dev/mem", O_RDWR | O_SYNC);

	// MAPPING THE DMA  --> mmap()
	printf("Memory map the address of the DMA AXI IP via its AXI lite control interface register block.\n");
	// int offset_dma = 0x40400000;
	int offset_dma = 0x00A0000000; // value read from Vivado address editor
	unsigned int *dma_virtual_addr = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, 0x00A0000000);

	// MAPPING THE SOURCE ADDRESS --> mmap()
	// allocating memory for source data
	// Are both 0x0e000000 and 0x0f000000 arbitrary values? If yes, this means that in this step I specify a portion of shared memory
	// Arbitrary in range [0x0; 0x80000000)
	printf("Memory map the MM2S source address register block.\n");
	unsigned int *virtual_src_addr = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, 0x0e000000);

	// MAPPING THE DESTINATION ADDRESS --> mmap()
	// where DMA will write the data
	printf("Memory map the S2MM destination address register block.\n");
	unsigned int *virtual_dst_addr = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, 0x0f000000);

	printf("Writing random data to source register block...\n");
	virtual_src_addr[0] = 0xEFBEADDE; // 4 byte --> integers are 32 bit = 4 byte
	/*virtual_src_addr[1]= 0x11223344;
	virtual_src_addr[2]= 0xABABABAB;
	virtual_src_addr[3]= 0xCDCDCDCD;
	virtual_src_addr[4]= 0x00001111;
	virtual_src_addr[5]= 0x22223333;
	virtual_src_addr[6]= 0x44445555;
	virtual_src_addr[7]= 0x66667777;*/

	// 32 byte because there are 8 integers
	printf("Clearing the destination register block...\n");
	memset(virtual_dst_addr, 0, 32);

	printf("Source memory block data:      ");
	print_mem(virtual_src_addr, 32);

	printf("Destination memory block data: ");
	print_mem(virtual_dst_addr, 32);

	/*  STEP 1: reset the DMA
	 *
	 * 	MM2S_CR_bit2 = 1
	 *	S2MM_CR_bit2 = 1
	 */
	printf("Reset the DMA.\n");
	// reset
	write_dma(dma_virtual_addr, S2MM_CONTROL_REGISTER, RESET_DMA);
	printf("S2MM reset done\n");
	write_dma(dma_virtual_addr, MM2S_CONTROL_REGISTER, RESET_DMA);
	printf("MM2S reset done\n");

	// check status of dma
	dma_s2mm_status(dma_virtual_addr);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 2: make sure the DMA is stopped
	 *
	 * 	MM2S_CR_bit0 = 0 = HALT_DMA
	 *	S2MM_CR_bit0 = 0
	 */
	printf("Halt the DMA.\n");
	write_dma(dma_virtual_addr, S2MM_CONTROL_REGISTER, HALT_DMA);
	write_dma(dma_virtual_addr, MM2S_CONTROL_REGISTER, HALT_DMA);
	dma_s2mm_status(dma_virtual_addr);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 3: enable IOC flag
	 *
	 * 	MM2S_CR_bit14, 13, 12 = 1
	 *	S2MM_CR_bit14, 13, 12 = 1
	 */
	printf("Enable all interrupts.\n");
	write_dma(dma_virtual_addr, S2MM_CONTROL_REGISTER, ENABLE_ALL_IRQ); // ENABLE_ALL_IRQ is bit 14, 13, 12
	write_dma(dma_virtual_addr, MM2S_CONTROL_REGISTER, ENABLE_ALL_IRQ);
	dma_s2mm_status(dma_virtual_addr);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 4: write the SOURCE ADDRESS register in DDR of the data  MM2S --> DMA IS READING from address specified in SRC_ADDR_REG
	 *
	 * 	offset 0x18 = MM2S_SRC_ADDRESS_REGISTER
	 * 	writing 0x0e000000 --> ADDRESS TO SOURCE DATA (WHERE READ DATA)
	 */
	printf("Writing source address of the data from MM2S in DDR...\n"); // source pointer (pointer to reading data)
	write_dma(dma_virtual_addr, MM2S_SRC_ADDRESS_REGISTER, 0x0e000000);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 5: write the DESTINATION ADDRESS register in DDR of the data S2MM --> DMA IS WRITING to address specified in DEST_ADDR_REG
	 *
	 * 	offset 0x18 = S2MM_DST_ADDRESS_REGISTER
	 * 	writing 0x0f000000 --> ADDRESS TO DESTINATION DATA (WHERE WRITE DATA)
	 */
	printf("Writing the destination address for the data from S2MM in DDR...\n");
	write_dma(dma_virtual_addr, S2MM_DST_ADDRESS_REGISTER, 0x0f000000);
	dma_s2mm_status(dma_virtual_addr);

	/*  STEP 6: run MM2S channel --> DMA read the data, CPU write data
	 *
	 *	MM2S_CR_bit0 = 1 = RUN_DMA
	 */
	printf("Run the MM2S channel.\n");
	write_dma(dma_virtual_addr, MM2S_CONTROL_REGISTER, RUN_DMA);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 7: run S2MM channel --> DMA write the data
	 *
	 *	S2MM_CR_bit0 = 1 = RUN_DMA
	 */
	printf("Run the S2MM channel.\n");
	write_dma(dma_virtual_addr, S2MM_CONTROL_REGISTER, RUN_DMA);
	dma_s2mm_status(dma_virtual_addr);

	/*  STEP 8: write the LENGTH of the transfer from MM2S --> how much data should be read by the DMA
	 *
	 *	4 bytes will be sent
	 */
	printf("Writing MM2S transfer length of 4 bytes...\n");
	write_dma(dma_virtual_addr, MM2S_TRNSFR_LENGTH_REGISTER, 1);
	dma_mm2s_status(dma_virtual_addr);

	/*  STEP 9: write the LENGTH of the transfer from S2MM --> how much data should be read by the DMA
	 *
	 *	4 bytes will be sent
	 */

	printf("Writing S2MM transfer length of 32 bytes...\n");
	write_dma(dma_virtual_addr, S2MM_BUFF_LENGTH_REGISTER, 1);
	dma_s2mm_status(dma_virtual_addr);

	/*  STEP 10: sync --> monitor IOC flag and IDLE flag in status registers of both MM2S and S2MM
	 *
	 *	4 bytes will be sent
	 */

	printf("Waiting for MM2S synchronization...\n");
	dma_mm2s_sync(dma_virtual_addr);

	printf("Waiting for S2MM sychronization...\n");
	dma_s2mm_sync(dma_virtual_addr);

	// print the status at the end
	dma_s2mm_status(dma_virtual_addr);
	dma_mm2s_status(dma_virtual_addr);

	printf("Destination memory block: ");
	print_mem(virtual_dst_addr, 32);

	close(ddr_memory);
	return 0;
}
