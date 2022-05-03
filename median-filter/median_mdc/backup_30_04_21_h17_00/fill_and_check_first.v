`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module fill_and_check_first #(
		parameter MEDIAN_POS = 10'd512,
		BUFF_SIZE = 11'd1024,
		//BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
		BUFF_SIZE_BIT = 16
		) (
		
		/*
		 * SYS SIGNALS
		 */
		input wire clock, reset,

		// input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value in this module have default values
		input wire [7:0] in_px, 
		output wire in_px_rd,
		input wire in_px_empty,		// not valid; assign valid = ~empty;
		
		     
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
	
	parameter FIRST_PIVOT = 8'd127;
	parameter FIRST_BUFF_SIZE = BUFF_SIZE;
	parameter FIRST_SECOND_MEDIAN_VALUE = 8'd127;



	
	counter 





fill_and_check #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT), .DEFAULT_PIVOT(DEFAULT_PIVOT)) 
	DUT_fill_and_check_complete_first (

	/*
	 * SYS SIGNALS
	 */
		.clock(clock), .reset(reset),
    
    /*
     * COMM SIGNALS
     */
     
    // input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
	.in_px(in_px), 
		.in_px_rd(in_px_rd),
		.in_px_empty(in_px_empty),		// not valid; assign valid = ~empty;
    	

	.in_pivot(FIRST_PIVOT),
		.in_pivot_rd(),
		.in_pivot_empty(),
    	
	.in_buff_size(FIRST_BUFF_SIZE),
    	.in_buff_size_rd,
    	.in_buff_size_empty,
    	
    .in_median_pos(FIRST_MEDIAN_POS),
    	.in_median_pos_rd(),
    	.in_median_pos_empty(),
    	
    .in_second_median_value(FIRST_SECOND_MEDIAN_VALUE),
    	.in_second_median_value_rd(),
    	.in_second_median_value_empty(),
        
        
    // output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
    .out_px(out_px),
    	.out_px_wr(out_px_wr),
    	.out_px_full(out_px_full),
        
    .out_pivot(out_pivot),
    	.out_pivot_wr(out_pivot_wr),
    	.out_pivot_full(out_pivot_wr),
    
    .out_buff_size(out_buff_size),
    	.out_buff_size_wr(out_buff_size_wr),
    	.out_buff_size_full(out_buff_size_full),
    	
 	.out_median_pos(out_median_pos),
 		.out_buff_size_wr(out_buff_size_wr),
 		.out_buff_size_full(out_buff_size_wr),
    	
 	.out_second_median_value(out_second_median_value),
 		.out_second_median_value_wr(out_second_median_value_wr),
 		.out_buff_size_full(out_buff_size_full)
 
    );
    
    
    
endmodule