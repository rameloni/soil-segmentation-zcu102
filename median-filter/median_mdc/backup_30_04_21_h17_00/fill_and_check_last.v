fill_and_check #(
       parameter MEDIAN_POS = 10'd512,
       			 BUFF_SIZE = 11'd1024,
       			 //BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
       			 BUFF_SIZE_BIT = 16,
        		 DEFAULT_PIVOT = 8'd127
    ) DUT_fill_and_check_complete_last (


	/*
	 * SYS SIGNALS
	 */
    input wire clock, reset,
    
    /*
     * COMM SIGNALS
     */
     
    // input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
    input wire [7:0] in_px, 
    	output wire in_px_rd,
    	input wire in_px_empty,		// not valid; assign valid = ~empty;
    	

    input wire [7:0] in_pivot,
    	output wire in_pivot_rd,
    	input wire in_pivot_empty,
    	
    input wire [BUFF_SIZE_BIT-1:0] in_buff_size,
    	output wire in_buff_size_rd,
    	input wire in_buff_size_empty,
    	
    input wire [BUFF_SIZE_BIT-1:0] in_median_pos,
    	output wire in_median_pos_rd,
    	input wire in_median_pos_empty,
    	
    input wire [7:0] in_second_median_value,
    	output wire in_second_median_value_rd,
    	input wire in_second_median_value_empty,
        
        
    // output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
    output reg [7:0] out_px,
        output wire out_px_wr,
        input wire out_px_full,
        
    output reg [7:0] out_pivot,
    	output wire out_pivot_wr,
    	input wire out_pivot_full,
    
    output reg [BUFF_SIZE_BIT-1:0] out_buff_size,
    	output wire out_buff_size_wr,
    	input wire out_buff_size_full,
    	
    output reg [BUFF_SIZE_BIT-1:0] out_median_pos,
    	output wire out_buff_size_wr,
    	input wire out_buff_size_full,
    	
    output reg [7:0] out_second_median_value,
    	output wire out_second_median_value_wr,
    	input wire out_buff_size_full
 
    );