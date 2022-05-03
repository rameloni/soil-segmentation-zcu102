
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "medianlib.h"

int main(){
	// pointer to the image txt
    FILE *image_fp;
    int rows, cols;
    //if ((image_fp = fopen("/home/raffaele/Desktop/DJI_0003_small.txt", "r")) == NULL)
    if ((image_fp = fopen("/home/raffaele/Desktop/DJI_0003_small.txt", "r")) == NULL)
    {
        printf("Error opening image! Please, insert correct image name.\n");
        exit(1);
    }

    /* READING HEADER */
    char c;
    puts("ok");
    fscanf(image_fp, "%10d", &rows);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);
        puts("ok");
    // reading cols
    fscanf(image_fp, "%10d", &cols);
    fscanf(image_fp, "%c", &c);
    fscanf(image_fp, "%c", &c);
    puts("ok");
    if (rows <= 0 || cols <= 0)
    {
        printf("Error opening image! Please, use correct image txt structure.\n");
        exit(1);
    }
    
    
    
    int pix, n_pixels = 0;
    int comp_count = 0;
    uint8_t *output_image = (uint8_t *)malloc(sizeof(uint8_t) * (rows) * (cols));
puts("ok");
   // while (!feof(image_fp))
    while (n_pixels < (rows) * (cols))
    {
        //if (sizeof(output_image) < n_pixels)
          //  output_image = realloc(output_image, (n_pixels + 1) * sizeof(uint8_t) * 10);

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

    //printf("%s\n", image_name);
    //printf("N_pixels: %d\ty_size: %d\tx_size: %d\tcomp: %d\n\n", n_pixels, *rows, *cols, *comp);

    fclose(image_fp);
   
	//printf("%d \n", (cols*rows)%1024);
		uint8_t arr[1024];
	int k = (cols*rows)%1024;
	int j=0;
	int z=3;
	//for(int i=rows*cols-k-1024*z; i<rows*cols-k-1024*(z-1); ++i){	
	for(int i=1024*z; i<1024*(z)+1024; ++i){
		printf("%3d ", output_image[i]);
		if((i+1)%16==0) puts("");
		
		arr[j++] = output_image[i];
		}

	printf("-------------------------------\n");
	printf("%d \n", quickmedian(arr, 512, 0, 1024, 127, 0));
	printf("%d \n", slowmedian(arr, 0, 1024));
	
	mergeSort(arr, 0, 1024);
	/*for(int i =0; i<1024; ++i){
		printf("%3d ", arr[i]);
		
		if((i+1)%16==0) puts("");
		
		
	}*/
	free(output_image);
	return 0;
}
