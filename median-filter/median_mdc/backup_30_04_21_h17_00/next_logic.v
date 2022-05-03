`timescale 1ns / 1ps



module next_logic #(
    parameter MEDIAN_POS = 512,  // default 1024/2
        BUFF_SIZE = 32,
        BUFF_SIZE_BIT = $clog2(BUFF_SIZE)+1
    ) (

   // input wire clk,    input wire rst_n,
    	
	/*
	 * 	INPUTS FROM fill_buffers
	 */

    
    // input buffer sizes
    input wire [BUFF_SIZE_BIT-1:0] lower_size,
    input wire [BUFF_SIZE_BIT-1:0] equal_size,
    input wire [BUFF_SIZE_BIT-1:0] larger_size,
    
    input reg [7:0] max_lower,  min_lower,
    input reg [7:0] max_larger, min_larger,
      
    //input wire [7:0] lower_buffer  [BUFF_SIZE - 1:0],
   	// input wire [7:0] equal_buffer  [BUFF_SIZE - 1:0],
    //input wire [7:0] larger_buffer [BUFF_SIZE - 1:0],

    /*	
	 * 	"EXTERNAL" INPUTS 
	 */
    input wire [7:0] in_pivot,
    input wire [BUFF_SIZE_BIT-1:0] in_median_pos,
    
    /*
     * OUTPUT
     */
    output reg [BUFF_SIZE_BIT-1:0] next_buff_size,   
    output reg [7:0] next_pivot,
    output reg [BUFF_SIZE_BIT-1:0] next_median_pos,
     output reg [7:0] next_second_median_value
    //output reg [7:0] next_buffer [BUFF_SIZE-1:0],
    

    
    
    );
    
   
    // next buff size logic
    always@(in_median_pos, lower_size, equal_size, larger_size)
    	if (lower_size > in_median_pos)
    		next_buff_size = lower_size;
    	else if ((lower_size + equal_size) > in_median_pos)
    		next_buff_size = equal_size;  	
    	else
    		next_buff_size = larger_size;
    	
    // next pivot logic
    always@(in_pivot, in_median_pos, lower_size, equal_size, max_lower, min_lower, max_larger, min_larger, max_larger)
    	if (lower_size > in_median_pos)
    		next_pivot = (max_lower + min_lower) >> 1;
    	else if ((lower_size + equal_size) > in_median_pos)
    		next_pivot = in_pivot;
    	else 
    	    next_pivot = (max_larger + min_larger) >> 1;
    	    
    // next buffer logic
    /*always@(in_median_pos, lower_size, equal_size, lower_buffer, larger_buffer)
    	if (lower_size > in_median_pos)
    		next_buffer = lower_buffer;
    	else if ((lower_size + equal_size) > in_median_pos)
    		next_buffer = {lower_buffer[BUFF_SIZE-1:1], in_pivot};  	
    	else
    		next_buffer = larger_buffer;
    */
    // next median pos logic
    always@(in_median_pos, lower_size, equal_size)
    	if (lower_size > in_median_pos)
            next_median_pos = in_median_pos;   // median_pos doesn't change 
    	else if ((lower_size + equal_size) > in_median_pos)
            next_median_pos = BUFF_SIZE >> 1; // reset the median_pos
    	else
            next_median_pos = in_median_pos - (lower_size + equal_size);
        
    // next second median value 
    
    assign out_second_median_value = (equal_size == 0) ? max_lower : in_pivot;
        
            
   	// median found logic
	  
    //assign out_median_valid = (check_median == 1'b1 && (lower_size <= in_median_pos) && (lower_size + equal_size > in_median_pos));
    
endmodule
