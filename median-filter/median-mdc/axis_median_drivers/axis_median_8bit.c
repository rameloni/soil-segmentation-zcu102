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

/*  load_axis_median_8bit():    load the accelerator using fpgautil
 *
 *	char *accelerator:          the accelerator file name to load
 *
 * 	return 0 if the accelerator has been loaded successfully
 */
int load_axis_median_8bit(char *accelerator)
{
    char *cmd;
    int size0 = strlen("fpgautil -b ");
    int size1 = strlen(accelerator);

    cmd = (char *)malloc(sizeof(char) * (size0 + size1));

    if (cmd == NULL)
        return -1;

    strcpy(cmd, "fpgautil -b ");
    strcat(cmd, accelerator);
    // printf("%s\n", cmd);
    // calling fpagutil
    system(cmd);

    free(cmd);
    return 0;
}

/*  unload_axis_median_8bit():  unload the accelerator using fpgautil
 *
 * 	return 0 if the accelerator has been unloaded successfully
 */
int unload_axis_median_8bit()
{
    system("fpgautil -b dummy.bin");
    return 0;
}

/*  start_axis_median():        compute the medians of an input buffer
 *
 *  uint8_t input_buff[]:       input buffer
 *  int size:                   size of the input buffer
 *  int kernel size:            the size of the kernel
 *
 * 	return the medians
 */
uint8_t *start_axis_median(int x_kernel_size, int y_kernel_size, uint8_t *in_image, int x_image_size, int y_image_size)
{
    int kernel_size = x_kernel_size * y_kernel_size;
    if (kernel_size != 1024)
    {
        printf("The accelerator support only a kernel of 1024 bytes.\n");
        return NULL;
    }
    int image_size = x_image_size * y_image_size;
    if (image_size < 1)
    {
        printf("Please use a positive size for the input buffer.\n");
        return NULL;
    }
    // redefine the size, delete at least the last kernel_size values
    // image_size -= image_size % kernel_size;

    // OPEN DDR MEMORY:     open /dev/mem
    printf("Opening the character device file of the ZCU102's DDR memory...\n");
    int ddr_memory = open("/dev/mem", O_RDWR | O_SYNC);

    // DMA control virtual addresses:   mmap()
    printf("Memory map the address of the DMA AXI IP via its AXI lite control interface register block.\n");
    unsigned int *dma_in_data_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, OFFS_DMA_IN_DATA);   // MM2S
    unsigned int *dma_out_data_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, OFFS_DMA_OUT_DATA); // S2MM

    // MAPPING THE SOURCE ADDRESS:      mmap()
    // Allocating memory for source data
    // 0x0e000000 and 0x0f000000 are both arbitrary values
    // Arbitrary in range [0x0; 0x80000000)
    printf("Memory map the MM2S source address register blocks.\n");
    uint32_t *src_data_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, 0x0e000000);

    // MAPPING THE DESTINATION ADDRESS: mmap()
    // Where DMA will write the data
    printf("Memory map the S2MM destination address register block.\n");
    uint32_t *dst_data_virtual_addr = mmap(NULL, SIZE_VIRTUAL_ADDR, PROT_READ | PROT_WRITE, MAP_SHARED, ddr_memory, 0x0f000000);

    // 1. reset the dma
    write_dma(dma_in_data_virtual_addr, MM2S_CONTROL_REGISTER, RESET_DMA);
    write_dma(dma_out_data_virtual_addr, S2MM_CONTROL_REGISTER, RESET_DMA);
    printf("DMA reset done!\n");

    // 2. halt the dma
    write_dma(dma_in_data_virtual_addr, MM2S_CONTROL_REGISTER, HALT_DMA);
    write_dma(dma_out_data_virtual_addr, S2MM_CONTROL_REGISTER, HALT_DMA);
    printf("DMA halt done!\n");

    // 3. enable IOC flag
    write_dma(dma_in_data_virtual_addr, MM2S_CONTROL_REGISTER, ENABLE_ALL_IRQ);
    write_dma(dma_out_data_virtual_addr, S2MM_CONTROL_REGISTER, ENABLE_ALL_IRQ);
    printf("Interrupt enabled!\n");

    // 4. write source addresses
    printf("Writing source address of the data from MM2S in DDR...\n"); // source pointer (pointer to reading data)
    write_dma(dma_in_data_virtual_addr, MM2S_SRC_ADDRESS_REGISTER, 0x0e000000);

    // 5. write destination addresses
    printf("Writing the destination address for the data from S2MM in DDR...\n");
    write_dma(dma_in_data_virtual_addr, MM2S_SRC_ADDRESS_REGISTER, 0x0f000000);

    // WRITING SOURCE DATA
    printf("Writing input data to source register blocks...\n");
    int j = 0;

    uint8_t *kernel = (uint8_t *)malloc(sizeof(uint8_t) * kernel_size); // the kernel

    int x_out_size = x_image_size / x_kernel_size, y_out_size = y_image_size / y_kernel_size; // output image (x, y) size
    int x_skip = x_kernel_size, y_skip = y_kernel_size;                                       // skip (x, y) size
    int x_last_px = 0, y_last_px = 0;                                                         // starting (x, y) point

    uint8_t *out_image = (uint8_t *)malloc(sizeof(uint8_t) * (x_out_size * y_out_size));
    int x_out = 0, y_out = 0; // output indexers

    // number of accepted data by the DMA per time
    int n_accepted_data = SIZE_VIRTUAL_ADDR / 4; // 4 byte input data

    for (int count = 0; count < image_size; count += n_accepted_data)
    {
        if (image_size - count < n_accepted_data) // prevent segmentation faults
            n_accepted_data = image_size - count;

        uint32_t in_data; // input data to the DDR
        // create the first data to send: the first data is composed by 24-bit size and 8-bit of the pixel-data
        in_data = (n_accepted_data << 8) + in_image[x_last_px + y_last_px * x_image_size];
        // write the first data into mem
        src_data_virtual_addr[0] = in_data;

        int k = 1;
        while (k < n_accepted_data)
        {
            for (int x = x_last_px + 1; x < x_kernel_size + x_last_px; ++x)     // width
                for (int y = y_last_px + 1; y < y_kernel_size + y_last_px; ++y) // height
                {
                    src_data_virtual_addr[k++] = in_image[x + y * x_image_size]; // write a kernel
                }
            // move to the next kernel
            x_last_px += x_skip; // next last pixel
            if (x_last_px + x_kernel_size >= x_image_size)
            {
                x_last_px = 0;
                y_last_px += y_skip;
            }
        }

        // RUN THE ACCELERATOR
        // printf("Run the MM2S input channel.\n");
        write_dma(dma_in_data_virtual_addr, MM2S_CONTROL_REGISTER, RUN_DMA);
        // printf("Run the S2MM input channel.\n");
        write_dma(dma_out_data_virtual_addr, S2MM_CONTROL_REGISTER, RUN_DMA);

        // printf("Writing MM2S transfer length of %d 32-bit-words...\n", n_accepted_data);
        write_dma(dma_in_data_virtual_addr, MM2S_TRNSFR_LENGTH_REGISTER, n_accepted_data * 4);
        // printf("Writing S2MM transfer length of %d 32-bit-words...\n", x_out_size * y_out_size);
        write_dma(dma_out_data_virtual_addr, S2MM_BUFF_LENGTH_REGISTER, x_out_size * y_out_size * 4);

        // printf("Waiting for MM2S synchronizations...\n");
        dma_mm2s_sync(dma_in_data_virtual_addr);

        // printf("Waiting for S2MM sychronization...\n");
        dma_s2mm_sync(dma_out_data_virtual_addr);

        // READ DATA FROM DST ADDRESS
        k = 0;
        while ((k < n_accepted_data / kernel_size) & (y_out < y_out_size))
        {
            // write the output image
            out_image[x_out + y_out * x_out_size] = dst_data_virtual_addr[k++];
            x_out++;
            y_out++;
            if (x_out >= x_out_size)
                x_out = 0;
        }
    }
    // unmap dmas
    munmap(dma_in_data_virtual_addr, SIZE_VIRTUAL_ADDR);
    munmap(dma_out_data_virtual_addr, SIZE_VIRTUAL_ADDR);
    // unmap src and dst addr
    munmap(src_data_virtual_addr, SIZE_VIRTUAL_ADDR);
    munmap(dst_data_virtual_addr, SIZE_VIRTUAL_ADDR);

    // close memory
    close(ddr_memory);

    return out_image;
}

void set_dma()
{
    /*  STEP 1: reset the DMA
     *
     * 	MM2S_CR_bit2 = 1
     *	S2MM_CR_bit2 = 1
     */

    /*  STEP 2: make sure the DMA is stopped
     *
     * 	MM2S_CR_bit0 = 0 = HALT_DMA
     *	S2MM_CR_bit0 = 0
     */
    /*  STEP 3: enable IOC flag
     *
     * 	MM2S_CR_bit14, 13, 12 = 1
     *	S2MM_CR_bit14, 13, 12 = 1
     */
    /*  STEP 4: write the SOURCE ADDRESS register in DDR of the data  MM2S --> DMA IS READING from address specified in SRC_ADDR_REG
     *
     * 	offset 0x18 = MM2S_SRC_ADDRESS_REGISTER
     * 	writing 0x0e000000 --> ADDRESS TO SOURCE DATA (WHERE READ DATA)
     */
    /*  STEP 5: write the DESTINATION ADDRESS register in DDR of the data S2MM --> DMA IS WRITING to address specified in DEST_ADDR_REG
     *
     * 	offset 0x18 = S2MM_DST_ADDRESS_REGISTER
     * 	writing 0x0f000000 --> ADDRESS TO DESTINATION DATA (WHERE WRITE DATA)
     */
}
