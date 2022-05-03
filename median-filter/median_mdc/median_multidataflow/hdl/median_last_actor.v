`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
 * COMPLETE ACTOR
 */


// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module median_last_actor #(
//		parameter MEDIAN_POS = 5'd8,
//		BUFF_SIZE = 5'd16,
//		BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
//		//BUFF_SIZE_BIT = 16,
//		DEFAULT_PIVOT = 8'd127
				parameter MEDIAN_POS = 11'd512,
				BUFF_SIZE = 11'd1024,
				BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
				//BUFF_SIZE_BIT = 16,
				DEFAULT_PIVOT = 8'd127
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
       	
        
		/* 
		 * COMM SIGNALS OUTPUT
		 */ 
		// output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
		output wire [7:0] out_px,
		output wire out_px_wr,
		input wire out_px_full
//        
//		output wire [7:0] out_pivot,
//		output wire out_pivot_wr,
//		input wire out_pivot_full,
//    
//		output wire [BUFF_SIZE_BIT-1:0] out_buff_size,
//		output wire out_buff_size_wr,
//		input wire out_buff_size_full,
//    	
//		output wire [BUFF_SIZE_BIT-1:0] out_median_pos,
//		output wire out_median_pos_wr,
//		input wire out_median_pos_full,
//    	
//		output wire [7:0] out_second_median_value,
//		output wire out_second_median_value_wr,
//		input wire out_second_median_value_full
// 
		);
	
	median_middle_actor #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT),.DEFAULT_PIVOT(DEFAULT_PIVOT))
		DUT_median_middle_actor(


			/*
			 * SYS SIGNALS
			 */
			.clock(clock), .reset(reset),
    
			/*
			 * COMM SIGNALS INPUT
			 */
    
			// input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
			.in_px(in_px), 
			.in_px_rd(in_px_rd),
			.in_px_empty(in_px_empty),		// not valid; assign valid = ~empty;
    	

			.in_pivot(in_pivot),
			.in_pivot_rd(in_pivot_rd),
			.in_pivot_empty(in_pivot_empty),
    	
			.in_buff_size(in_buff_size),
			.in_buff_size_rd(in_buff_size_rd),
			.in_buff_size_empty(in_buff_size_empty),
    	
			.in_median_pos(in_median_pos),
			.in_median_pos_rd(in_median_pos_rd),
			.in_median_pos_empty(in_median_pos_empty),
    	
			.in_second_median_value(in_second_median_value),
			.in_second_median_value_rd(in_second_median_value_rd),
			.in_second_median_value_empty(in_second_median_value_empty),
       	
        
			/* 
			 * COMM SIGNALS OUTPUT
			 */ 
			// output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
			.out_px(out_px),
			.out_px_wr(out_px_wr),
			.out_px_full(out_px_full),
        
			.out_pivot(),
			.out_pivot_wr(),
			.out_pivot_full(1'b0),
    
			.out_buff_size(),
			.out_buff_size_wr(),
			.out_buff_size_full(1'b0),
    	
			.out_median_pos(),
			.out_median_pos_wr(),
			.out_median_pos_full(1'b0),
    	
			.out_second_median_value(),
			.out_second_median_value_wr(),
			.out_second_median_value_full(1'b0)
 
		);
    
			
		

endmodule
