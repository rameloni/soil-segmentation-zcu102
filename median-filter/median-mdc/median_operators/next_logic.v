`timescale 1ns / 1ps

module next_logic #(
    parameter MEDIAN_POS = 512,  // default 1024/2
        BUFF_SIZE = 32,
        BUFF_SIZE_BIT = $clog2(BUFF_SIZE)+1
    ) (
   	
    /*
     * "CONTROL" INPUT DATA: lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
     */
    input wire [BUFF_SIZE_BIT-1:0] lower_size,	// buffer sizes
    input wire [BUFF_SIZE_BIT-1:0] equal_size,
    input wire [BUFF_SIZE_BIT-1:0] larger_size,
    
    input wire [7:0] max_lower,  min_lower,		// min and max values
    input wire [7:0] max_larger, min_larger,
    
    /*
 	 * 	"EXTERNAL" INPUT DATA: in_pivot_samp, in_median_pos_samp 
 	 */
    input wire [7:0] in_pivot,						// in_pivot_samp
    input wire [BUFF_SIZE_BIT-1:0] in_median_pos,	// in_median_pos_samp
    
    /*
     * OUTPUT DATA: next_pivot, next_buff_size, next_median_pos, next_second_median_value
     */
    output reg [7:0] next_pivot,
    output reg [BUFF_SIZE_BIT-1:0] next_buff_size,   
    output reg [BUFF_SIZE_BIT-1:0] next_median_pos,
    output wire [7:0] next_second_median_value
    
    );
    
   /*
    * NEXT PIVOT
    */ 
	always@(in_pivot, in_median_pos, lower_size, equal_size, max_lower, min_lower, max_larger, min_larger, max_larger)
		if (lower_size > in_median_pos)
			next_pivot = (max_lower + min_lower) >> 1;
		else if ((lower_size + equal_size) > in_median_pos)
			next_pivot = in_pivot;
		else if (equal_size == in_median_pos)
			next_pivot = in_pivot;
		else 
			next_pivot = (max_larger + min_larger) >> 1;
		
    /*
     * NEXT BUFF SIZE
     */
    always@(in_median_pos, lower_size, equal_size, larger_size)
    	if (lower_size > in_median_pos)
    		next_buff_size = lower_size;
    	else if ((lower_size + equal_size) > in_median_pos)
    		next_buff_size = 1;  	
    	else if (equal_size == in_median_pos)
    		next_buff_size = 1;  	
    	else
    		next_buff_size = larger_size;
   
    /*
     * NEXT MEDIAN POS
     */ 
    
    always@(in_median_pos, lower_size, equal_size)
    	if (lower_size > in_median_pos)
            next_median_pos = in_median_pos;   // median_pos doesn't change 
    	else if ((lower_size + equal_size) > in_median_pos)//  || equal_size == in_median_pos)
//            next_median_pos = BUFF_SIZE >> 1; // reset the median_pos
    	next_median_pos = 0; // reset the median_pos
    	else if (equal_size == in_median_pos)
    		next_median_pos = 0; // reset the median_pos
    	else
            next_median_pos = in_median_pos - (lower_size + equal_size);
        
    /*
     * NEXT SECOND MEDIAN VALUE
     */ 	
    assign next_second_median_value = (equal_size == 0) ? max_lower : in_pivot;
        
   	/*
   	 * MEDIAN FOUND LOGIC
   	 */ 
    //assign out_median_valid = (check_median == 1'b1 && (lower_size <= in_median_pos) && (lower_size + equal_size > in_median_pos));
    
endmodule
