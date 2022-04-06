`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
 * COMPLETE ACTOR
 */


// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module median_first_actor #(
		parameter MEDIAN_POS = 10'd4,
		BUFF_SIZE = 11'd8,
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
		 * COMM SIGNALS
		 */
     
		// input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
		input wire [7:0] in_px, 
		output wire in_px_rd,
		input wire in_px_empty,		// not valid; assign valid = ~empty;
    	
//
//		input wire [7:0] in_pivot,
//		output wire in_pivot_rd,
//		input wire in_pivot_empty,
//    	
//		input wire [BUFF_SIZE_BIT-1:0] in_buff_size,
//		output wire in_buff_size_rd,
//		input wire in_buff_size_empty,
//    	
//		input wire [BUFF_SIZE_BIT-1:0] in_median_pos,
//		output wire in_median_pos_rd,
//		input wire in_median_pos_empty,
//    	
//		input wire [7:0] in_second_median_value,
//		output wire in_second_median_value_rd,
//		input wire in_second_median_value_empty,
//        
        
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
	// pivot register
	//reg [7:0] in_pivot_samp;
    
	// in_buffer_size_samp register
	//reg [BUFF_SIZE_BIT-1:0] in_buff_size_samp;
	wire filling;
	//	wire fill_done;
    
	// in median pos register
	//reg [BUFF_SIZE_BIT-1:0] in_median_pos_samp;
    
	// in second median value
	//reg [7:0] in_second_median_value_samp;
 
    
    
	/*
	 * INPUT REGISTERS
	 */
	// sample pivot
//	always@(posedge clock, negedge reset)
//		if (reset == 1'b0)
//			in_pivot_samp <= DEFAULT_PIVOT;
//		else if (in_pivot_rd && (~in_pivot_empty))
//			in_pivot_samp <= in_pivot;
//    
//	assign in_pivot_rd = ~filling;	// if is not filling, samp a new pivot
//    
//	// sample buff size
//	always@(posedge clock, negedge reset)
//		if (reset == 1'b0)
//			in_buff_size_samp <= BUFF_SIZE;
//		else if (in_buff_size_rd && (~in_buff_size_empty))
//			in_buff_size_samp <= in_buff_size;
//    
//	assign in_buff_size_rd = ~filling;	// if is filling don't read a new in buff size
//    
//	// sample median pos
//	always@(posedge clock, negedge reset)
//		if (reset == 1'b0)
//			in_median_pos_samp <= MEDIAN_POS;
//		else if (in_median_pos_rd && (~in_median_pos_empty))
//			in_median_pos_samp <= in_median_pos;
//    
//	assign in_median_pos_rd = ~filling;	// if is filling don't read a new in median pos
//    
//	// second median value samp
//	always@(posedge clock, negedge reset)
//		if (reset == 1'b0)
//			in_second_median_value_samp <= DEFAULT_PIVOT;
//		else if (in_second_median_value_rd && (~in_second_median_value_empty))
//			in_second_median_value_samp <= in_second_median_value;
//    
//	assign in_second_median_value_rd = ~filling;	// if is filling don't read a new in median pos

    
	
	
	// fill and check
	fill_and_check #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT), .DEFAULT_PIVOT(DEFAULT_PIVOT)) 
		DUT_fill_and_checK (

			/*
			 * SYS SIGNALS
			 */
			.clock(clock), .reset(reset),
    
			/*
			 * COMM SIGNALS
			 */
     
			.filling(filling),
			.fill_done(),
			// input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
			.in_px(in_px), 
			.in_px_rd(in_px_rd),
			.in_px_empty(in_px_empty),		// not valid; assign valid = ~empty;
    	

			.in_pivot_samp(DEFAULT_PIVOT),
			//			.in_pivot_rd(),
			//			.in_pivot_empty(),
    	
			.in_buff_size_samp(BUFF_SIZE),
			//			.in_buff_size_rd,
			//			.in_buff_size_empty,
    	
			.in_median_pos_samp(MEDIAN_POS),
			//			.in_median_pos_rd(),
			//			.in_median_pos_empty(),
    	
			.in_second_median_value_samp(DEFAULT_PIVOT),
			//.in_second_median_value_rd(),
			//.in_second_median_value_empty(),
        
        
			// output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
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