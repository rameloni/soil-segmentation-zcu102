`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
 * COMPLETE ACTOR
 */


// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module median_first_actor #(
		parameter MEDIAN_POS = 10'd8,
		BUFF_SIZE = 11'd16,
		BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
		//BUFF_SIZE_BIT = 16,
		DEFAULT_PIVOT = 8'd127
//		parameter MEDIAN_POS = 10'd512,
//		BUFF_SIZE = 11'd1024,
//		BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
//		//BUFF_SIZE_BIT = 16,
//		DEFAULT_PIVOT = 8'd127
		)(

		/*
		 * SYS SIGNALS
		 */
		input wire clock, reset,
    
		/*
		 * COMM SIGNALS INPUT
		 */
    
		// input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
		input wire [7:0] in_px, 
		output wire in_px_rd,
		input wire in_px_empty,		// not valid; assign valid = ~empty;
    	
   	
		/*
		 * COMM SIGNALS OUTPUT
		 */ 
       	// output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
		output wire [7:0] out_px,
		output wire out_px_wr,
		input wire out_px_full,
        
		output wire [7:0] out_pivot,
		output wire out_pivot_wr,
		input wire out_pivot_full,
    
		output wire [BUFF_SIZE_BIT-1:0] out_buff_size,
		output wire out_buff_size_wr,
		input wire out_buff_size_full,
    	
		output wire [BUFF_SIZE_BIT-1:0] out_median_pos,
		output wire out_median_pos_wr,
		input wire out_median_pos_full,
    	
		output wire [7:0] out_second_median_value,
		output wire out_second_median_value_wr,
		input wire out_second_median_value_full

		);
	/*
	 *  SIGNALS and MEMORIES
	 */  
	
	wire filling;
	wire fill_done;
 
    
    
	/*
	 * INPUT REGISTERS: delay_px not needed, pivot_samp, buff_size_samp, median_pos, second_median_value
	 */
	// in_pivot_samp = DEFAULT_PIVOT 	8'd127
	// in_buff_size_samp = BUFF_SIZE 	11'd1024	first buffer
	// in_median_pos = MEDIAN_POS		11'd512		the median pos
	// in_second_median_value_samp = DUMMY			it is not important for the first iteration
	
	
	// fill and check
	fill_and_check #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT), .DEFAULT_PIVOT(DEFAULT_PIVOT)) 
		DUT_fill_and_checK (

			/*
			 * SYS SIGNALS
			 */
			.clock(clock), .reset(reset),
    
			/*
			 * CONTROL SIGNALS
			 */
     
			.filling(filling),		// not used during this iteration
			.fill_done(fill_done),
			
			/*
			 * INPUT DATA: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
			 */ 
			.in_px(in_px), 
			.in_px_valid(in_px_rd & (~in_px_empty)),
			.in_px_rd(in_px_rd),
			.in_px_empty(in_px_empty),		// not valid; assign valid = ~empty;
    	
			.in_pivot_samp(DEFAULT_PIVOT),					// default value / starting value
    		.in_buff_size_samp(BUFF_SIZE),					// first buffer has orginal buffer size
			.in_median_pos_samp(MEDIAN_POS),				// first in_median_pos is the median pos
			.in_second_median_value_samp(DEFAULT_PIVOT),	// it is DUMMY, during the first iteration it is not important
        	
			
			/*
			 * OUTPUT DATA: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
			 */
			.out_px(out_px),
			.out_px_wr(out_px_wr),
			.out_px_full(out_px_full),
        
			.out_pivot(out_pivot),	
			.out_pivot_wr(out_pivot_wr),
			.out_pivot_full(out_pivot_full),
    
			.out_buff_size(out_buff_size),
			.out_buff_size_wr(out_buff_size_wr),
			.out_buff_size_full(out_buff_size_full),
    	
			.out_median_pos(out_median_pos),
			.out_median_pos_wr(out_median_pos_wr),
			.out_median_pos_full(out_median_pos_full),
    	
			.out_second_median_value(out_second_median_value),
			.out_second_median_value_wr(out_second_median_value_wr),
			.out_second_median_value_full(out_second_median_value_full)
 
		);	


endmodule
