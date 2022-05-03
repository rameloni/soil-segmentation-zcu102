// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Network module 
// Date: 2022/04/15 10:13:39
//
// ----------------------------------------------------------------------------

module multi_dataflow (
	// Input(s)
	input [7 : 0] in_px_data,
	input in_px_wr,
	output in_px_full,
	
	// Output(s)
	output [7 : 0] out_px_data,
	output out_px_wr,
	input out_px_full,
	
	// Dynamic Parameter(s)
	
	// Monitoring
	
	// Configuration ID
	
	
	// System Signal(s)		
	input clock,
	input reset
);	

// internal signals
// ----------------------------------------------------------------------------
		


// Actors Wire(s)
	
// actor median_first_actor_0
wire [7 : 0] fifo_small_median_first_actor_0_in_px_data;
wire fifo_small_median_first_actor_0_in_px_wr;
wire fifo_small_median_first_actor_0_in_px_full;
wire [7 : 0] median_first_actor_0_in_px_data;
wire median_first_actor_0_in_px_rd;
wire median_first_actor_0_in_px_empty;
wire [7 : 0] median_first_actor_0_out_px_data;
wire median_first_actor_0_out_px_wr;
wire median_first_actor_0_out_px_full;
wire [7 : 0] median_first_actor_0_out_pivot_data;
wire median_first_actor_0_out_pivot_wr;
wire median_first_actor_0_out_pivot_full;
wire [10 : 0] median_first_actor_0_out_buff_size_data;
wire median_first_actor_0_out_buff_size_wr;
wire median_first_actor_0_out_buff_size_full;
wire [10 : 0] median_first_actor_0_out_median_pos_data;
wire median_first_actor_0_out_median_pos_wr;
wire median_first_actor_0_out_median_pos_full;
wire [7 : 0] median_first_actor_0_out_second_median_value_data;
wire median_first_actor_0_out_second_median_value_wr;
wire median_first_actor_0_out_second_median_value_full;
	
// actor median_middle_actor_0
wire [7 : 0] fifo_small_median_middle_actor_0_in_px_data;
wire fifo_small_median_middle_actor_0_in_px_wr;
wire fifo_small_median_middle_actor_0_in_px_full;
wire [7 : 0] median_middle_actor_0_in_px_data;
wire median_middle_actor_0_in_px_rd;
wire median_middle_actor_0_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_0_in_pivot_data;
wire fifo_small_median_middle_actor_0_in_pivot_wr;
wire fifo_small_median_middle_actor_0_in_pivot_full;
wire [7 : 0] median_middle_actor_0_in_pivot_data;
wire median_middle_actor_0_in_pivot_rd;
wire median_middle_actor_0_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_0_in_buff_size_data;
wire fifo_small_median_middle_actor_0_in_buff_size_wr;
wire fifo_small_median_middle_actor_0_in_buff_size_full;
wire [10 : 0] median_middle_actor_0_in_buff_size_data;
wire median_middle_actor_0_in_buff_size_rd;
wire median_middle_actor_0_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_0_in_median_pos_data;
wire fifo_small_median_middle_actor_0_in_median_pos_wr;
wire fifo_small_median_middle_actor_0_in_median_pos_full;
wire [10 : 0] median_middle_actor_0_in_median_pos_data;
wire median_middle_actor_0_in_median_pos_rd;
wire median_middle_actor_0_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_0_in_second_median_value_data;
wire fifo_small_median_middle_actor_0_in_second_median_value_wr;
wire fifo_small_median_middle_actor_0_in_second_median_value_full;
wire [7 : 0] median_middle_actor_0_in_second_median_value_data;
wire median_middle_actor_0_in_second_median_value_rd;
wire median_middle_actor_0_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_0_out_px_data;
wire median_middle_actor_0_out_px_wr;
wire median_middle_actor_0_out_px_full;
wire [7 : 0] median_middle_actor_0_out_pivot_data;
wire median_middle_actor_0_out_pivot_wr;
wire median_middle_actor_0_out_pivot_full;
wire [10 : 0] median_middle_actor_0_out_buff_size_data;
wire median_middle_actor_0_out_buff_size_wr;
wire median_middle_actor_0_out_buff_size_full;
wire [10 : 0] median_middle_actor_0_out_median_pos_data;
wire median_middle_actor_0_out_median_pos_wr;
wire median_middle_actor_0_out_median_pos_full;
wire [7 : 0] median_middle_actor_0_out_second_median_value_data;
wire median_middle_actor_0_out_second_median_value_wr;
wire median_middle_actor_0_out_second_median_value_full;
	
// actor median_middle_actor_1
wire [7 : 0] fifo_small_median_middle_actor_1_in_px_data;
wire fifo_small_median_middle_actor_1_in_px_wr;
wire fifo_small_median_middle_actor_1_in_px_full;
wire [7 : 0] median_middle_actor_1_in_px_data;
wire median_middle_actor_1_in_px_rd;
wire median_middle_actor_1_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_1_in_pivot_data;
wire fifo_small_median_middle_actor_1_in_pivot_wr;
wire fifo_small_median_middle_actor_1_in_pivot_full;
wire [7 : 0] median_middle_actor_1_in_pivot_data;
wire median_middle_actor_1_in_pivot_rd;
wire median_middle_actor_1_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_1_in_buff_size_data;
wire fifo_small_median_middle_actor_1_in_buff_size_wr;
wire fifo_small_median_middle_actor_1_in_buff_size_full;
wire [10 : 0] median_middle_actor_1_in_buff_size_data;
wire median_middle_actor_1_in_buff_size_rd;
wire median_middle_actor_1_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_1_in_median_pos_data;
wire fifo_small_median_middle_actor_1_in_median_pos_wr;
wire fifo_small_median_middle_actor_1_in_median_pos_full;
wire [10 : 0] median_middle_actor_1_in_median_pos_data;
wire median_middle_actor_1_in_median_pos_rd;
wire median_middle_actor_1_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_1_in_second_median_value_data;
wire fifo_small_median_middle_actor_1_in_second_median_value_wr;
wire fifo_small_median_middle_actor_1_in_second_median_value_full;
wire [7 : 0] median_middle_actor_1_in_second_median_value_data;
wire median_middle_actor_1_in_second_median_value_rd;
wire median_middle_actor_1_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_1_out_px_data;
wire median_middle_actor_1_out_px_wr;
wire median_middle_actor_1_out_px_full;
wire [7 : 0] median_middle_actor_1_out_pivot_data;
wire median_middle_actor_1_out_pivot_wr;
wire median_middle_actor_1_out_pivot_full;
wire [10 : 0] median_middle_actor_1_out_buff_size_data;
wire median_middle_actor_1_out_buff_size_wr;
wire median_middle_actor_1_out_buff_size_full;
wire [10 : 0] median_middle_actor_1_out_median_pos_data;
wire median_middle_actor_1_out_median_pos_wr;
wire median_middle_actor_1_out_median_pos_full;
wire [7 : 0] median_middle_actor_1_out_second_median_value_data;
wire median_middle_actor_1_out_second_median_value_wr;
wire median_middle_actor_1_out_second_median_value_full;
	
// actor median_middle_actor_2
wire [7 : 0] fifo_small_median_middle_actor_2_in_px_data;
wire fifo_small_median_middle_actor_2_in_px_wr;
wire fifo_small_median_middle_actor_2_in_px_full;
wire [7 : 0] median_middle_actor_2_in_px_data;
wire median_middle_actor_2_in_px_rd;
wire median_middle_actor_2_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_2_in_pivot_data;
wire fifo_small_median_middle_actor_2_in_pivot_wr;
wire fifo_small_median_middle_actor_2_in_pivot_full;
wire [7 : 0] median_middle_actor_2_in_pivot_data;
wire median_middle_actor_2_in_pivot_rd;
wire median_middle_actor_2_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_2_in_buff_size_data;
wire fifo_small_median_middle_actor_2_in_buff_size_wr;
wire fifo_small_median_middle_actor_2_in_buff_size_full;
wire [10 : 0] median_middle_actor_2_in_buff_size_data;
wire median_middle_actor_2_in_buff_size_rd;
wire median_middle_actor_2_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_2_in_median_pos_data;
wire fifo_small_median_middle_actor_2_in_median_pos_wr;
wire fifo_small_median_middle_actor_2_in_median_pos_full;
wire [10 : 0] median_middle_actor_2_in_median_pos_data;
wire median_middle_actor_2_in_median_pos_rd;
wire median_middle_actor_2_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_2_in_second_median_value_data;
wire fifo_small_median_middle_actor_2_in_second_median_value_wr;
wire fifo_small_median_middle_actor_2_in_second_median_value_full;
wire [7 : 0] median_middle_actor_2_in_second_median_value_data;
wire median_middle_actor_2_in_second_median_value_rd;
wire median_middle_actor_2_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_2_out_px_data;
wire median_middle_actor_2_out_px_wr;
wire median_middle_actor_2_out_px_full;
wire [7 : 0] median_middle_actor_2_out_pivot_data;
wire median_middle_actor_2_out_pivot_wr;
wire median_middle_actor_2_out_pivot_full;
wire [10 : 0] median_middle_actor_2_out_buff_size_data;
wire median_middle_actor_2_out_buff_size_wr;
wire median_middle_actor_2_out_buff_size_full;
wire [10 : 0] median_middle_actor_2_out_median_pos_data;
wire median_middle_actor_2_out_median_pos_wr;
wire median_middle_actor_2_out_median_pos_full;
wire [7 : 0] median_middle_actor_2_out_second_median_value_data;
wire median_middle_actor_2_out_second_median_value_wr;
wire median_middle_actor_2_out_second_median_value_full;
	
// actor median_middle_actor_3
wire [7 : 0] fifo_small_median_middle_actor_3_in_px_data;
wire fifo_small_median_middle_actor_3_in_px_wr;
wire fifo_small_median_middle_actor_3_in_px_full;
wire [7 : 0] median_middle_actor_3_in_px_data;
wire median_middle_actor_3_in_px_rd;
wire median_middle_actor_3_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_3_in_pivot_data;
wire fifo_small_median_middle_actor_3_in_pivot_wr;
wire fifo_small_median_middle_actor_3_in_pivot_full;
wire [7 : 0] median_middle_actor_3_in_pivot_data;
wire median_middle_actor_3_in_pivot_rd;
wire median_middle_actor_3_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_3_in_buff_size_data;
wire fifo_small_median_middle_actor_3_in_buff_size_wr;
wire fifo_small_median_middle_actor_3_in_buff_size_full;
wire [10 : 0] median_middle_actor_3_in_buff_size_data;
wire median_middle_actor_3_in_buff_size_rd;
wire median_middle_actor_3_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_3_in_median_pos_data;
wire fifo_small_median_middle_actor_3_in_median_pos_wr;
wire fifo_small_median_middle_actor_3_in_median_pos_full;
wire [10 : 0] median_middle_actor_3_in_median_pos_data;
wire median_middle_actor_3_in_median_pos_rd;
wire median_middle_actor_3_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_3_in_second_median_value_data;
wire fifo_small_median_middle_actor_3_in_second_median_value_wr;
wire fifo_small_median_middle_actor_3_in_second_median_value_full;
wire [7 : 0] median_middle_actor_3_in_second_median_value_data;
wire median_middle_actor_3_in_second_median_value_rd;
wire median_middle_actor_3_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_3_out_px_data;
wire median_middle_actor_3_out_px_wr;
wire median_middle_actor_3_out_px_full;
wire [7 : 0] median_middle_actor_3_out_pivot_data;
wire median_middle_actor_3_out_pivot_wr;
wire median_middle_actor_3_out_pivot_full;
wire [10 : 0] median_middle_actor_3_out_buff_size_data;
wire median_middle_actor_3_out_buff_size_wr;
wire median_middle_actor_3_out_buff_size_full;
wire [10 : 0] median_middle_actor_3_out_median_pos_data;
wire median_middle_actor_3_out_median_pos_wr;
wire median_middle_actor_3_out_median_pos_full;
wire [7 : 0] median_middle_actor_3_out_second_median_value_data;
wire median_middle_actor_3_out_second_median_value_wr;
wire median_middle_actor_3_out_second_median_value_full;
	
// actor median_middle_actor_4
wire [7 : 0] fifo_small_median_middle_actor_4_in_px_data;
wire fifo_small_median_middle_actor_4_in_px_wr;
wire fifo_small_median_middle_actor_4_in_px_full;
wire [7 : 0] median_middle_actor_4_in_px_data;
wire median_middle_actor_4_in_px_rd;
wire median_middle_actor_4_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_4_in_pivot_data;
wire fifo_small_median_middle_actor_4_in_pivot_wr;
wire fifo_small_median_middle_actor_4_in_pivot_full;
wire [7 : 0] median_middle_actor_4_in_pivot_data;
wire median_middle_actor_4_in_pivot_rd;
wire median_middle_actor_4_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_4_in_buff_size_data;
wire fifo_small_median_middle_actor_4_in_buff_size_wr;
wire fifo_small_median_middle_actor_4_in_buff_size_full;
wire [10 : 0] median_middle_actor_4_in_buff_size_data;
wire median_middle_actor_4_in_buff_size_rd;
wire median_middle_actor_4_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_4_in_median_pos_data;
wire fifo_small_median_middle_actor_4_in_median_pos_wr;
wire fifo_small_median_middle_actor_4_in_median_pos_full;
wire [10 : 0] median_middle_actor_4_in_median_pos_data;
wire median_middle_actor_4_in_median_pos_rd;
wire median_middle_actor_4_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_4_in_second_median_value_data;
wire fifo_small_median_middle_actor_4_in_second_median_value_wr;
wire fifo_small_median_middle_actor_4_in_second_median_value_full;
wire [7 : 0] median_middle_actor_4_in_second_median_value_data;
wire median_middle_actor_4_in_second_median_value_rd;
wire median_middle_actor_4_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_4_out_px_data;
wire median_middle_actor_4_out_px_wr;
wire median_middle_actor_4_out_px_full;
wire [7 : 0] median_middle_actor_4_out_pivot_data;
wire median_middle_actor_4_out_pivot_wr;
wire median_middle_actor_4_out_pivot_full;
wire [10 : 0] median_middle_actor_4_out_buff_size_data;
wire median_middle_actor_4_out_buff_size_wr;
wire median_middle_actor_4_out_buff_size_full;
wire [10 : 0] median_middle_actor_4_out_median_pos_data;
wire median_middle_actor_4_out_median_pos_wr;
wire median_middle_actor_4_out_median_pos_full;
wire [7 : 0] median_middle_actor_4_out_second_median_value_data;
wire median_middle_actor_4_out_second_median_value_wr;
wire median_middle_actor_4_out_second_median_value_full;
	
// actor median_middle_actor_5
wire [7 : 0] fifo_small_median_middle_actor_5_in_px_data;
wire fifo_small_median_middle_actor_5_in_px_wr;
wire fifo_small_median_middle_actor_5_in_px_full;
wire [7 : 0] median_middle_actor_5_in_px_data;
wire median_middle_actor_5_in_px_rd;
wire median_middle_actor_5_in_px_empty;
wire [7 : 0] fifo_small_median_middle_actor_5_in_pivot_data;
wire fifo_small_median_middle_actor_5_in_pivot_wr;
wire fifo_small_median_middle_actor_5_in_pivot_full;
wire [7 : 0] median_middle_actor_5_in_pivot_data;
wire median_middle_actor_5_in_pivot_rd;
wire median_middle_actor_5_in_pivot_empty;
wire [10 : 0] fifo_small_median_middle_actor_5_in_buff_size_data;
wire fifo_small_median_middle_actor_5_in_buff_size_wr;
wire fifo_small_median_middle_actor_5_in_buff_size_full;
wire [10 : 0] median_middle_actor_5_in_buff_size_data;
wire median_middle_actor_5_in_buff_size_rd;
wire median_middle_actor_5_in_buff_size_empty;
wire [10 : 0] fifo_small_median_middle_actor_5_in_median_pos_data;
wire fifo_small_median_middle_actor_5_in_median_pos_wr;
wire fifo_small_median_middle_actor_5_in_median_pos_full;
wire [10 : 0] median_middle_actor_5_in_median_pos_data;
wire median_middle_actor_5_in_median_pos_rd;
wire median_middle_actor_5_in_median_pos_empty;
wire [7 : 0] fifo_small_median_middle_actor_5_in_second_median_value_data;
wire fifo_small_median_middle_actor_5_in_second_median_value_wr;
wire fifo_small_median_middle_actor_5_in_second_median_value_full;
wire [7 : 0] median_middle_actor_5_in_second_median_value_data;
wire median_middle_actor_5_in_second_median_value_rd;
wire median_middle_actor_5_in_second_median_value_empty;
wire [7 : 0] median_middle_actor_5_out_px_data;
wire median_middle_actor_5_out_px_wr;
wire median_middle_actor_5_out_px_full;
wire [7 : 0] median_middle_actor_5_out_pivot_data;
wire median_middle_actor_5_out_pivot_wr;
wire median_middle_actor_5_out_pivot_full;
wire [10 : 0] median_middle_actor_5_out_buff_size_data;
wire median_middle_actor_5_out_buff_size_wr;
wire median_middle_actor_5_out_buff_size_full;
wire [10 : 0] median_middle_actor_5_out_median_pos_data;
wire median_middle_actor_5_out_median_pos_wr;
wire median_middle_actor_5_out_median_pos_full;
wire [7 : 0] median_middle_actor_5_out_second_median_value_data;
wire median_middle_actor_5_out_second_median_value_wr;
wire median_middle_actor_5_out_second_median_value_full;
// ----------------------------------------------------------------------------

// body
// ----------------------------------------------------------------------------



// fifo_small_median_first_actor_0_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_first_actor_0_in_px(
	.datain(fifo_small_median_first_actor_0_in_px_data),
	.dataout(median_first_actor_0_in_px_data),
	.enr(median_first_actor_0_in_px_rd),
	.enw(fifo_small_median_first_actor_0_in_px_wr),
	.empty(median_first_actor_0_in_px_empty),
	.full(fifo_small_median_first_actor_0_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_first_actor_0
median_first_actor actor_median_first_actor_0 (
	// Input Signal(s)
	.in_px(median_first_actor_0_in_px_data),
	.in_px_rd(median_first_actor_0_in_px_rd),
	.in_px_empty(median_first_actor_0_in_px_empty)
	,
	
	// Output Signal(s)
	.out_px(median_first_actor_0_out_px_data),
	.out_px_wr(median_first_actor_0_out_px_wr),
	.out_px_full(median_first_actor_0_out_px_full),
	.out_pivot(median_first_actor_0_out_pivot_data),
	.out_pivot_wr(median_first_actor_0_out_pivot_wr),
	.out_pivot_full(median_first_actor_0_out_pivot_full),
	.out_buff_size(median_first_actor_0_out_buff_size_data),
	.out_buff_size_wr(median_first_actor_0_out_buff_size_wr),
	.out_buff_size_full(median_first_actor_0_out_buff_size_full),
	.out_median_pos(median_first_actor_0_out_median_pos_data),
	.out_median_pos_wr(median_first_actor_0_out_median_pos_wr),
	.out_median_pos_full(median_first_actor_0_out_median_pos_full),
	.out_second_median_value(median_first_actor_0_out_second_median_value_data),
	.out_second_median_value_wr(median_first_actor_0_out_second_median_value_wr),
	.out_second_median_value_full(median_first_actor_0_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_0_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_0_in_px(
	.datain(fifo_small_median_middle_actor_0_in_px_data),
	.dataout(median_middle_actor_0_in_px_data),
	.enr(median_middle_actor_0_in_px_rd),
	.enw(fifo_small_median_middle_actor_0_in_px_wr),
	.empty(median_middle_actor_0_in_px_empty),
	.full(fifo_small_median_middle_actor_0_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_0_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_0_in_pivot(
	.datain(fifo_small_median_middle_actor_0_in_pivot_data),
	.dataout(median_middle_actor_0_in_pivot_data),
	.enr(median_middle_actor_0_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_0_in_pivot_wr),
	.empty(median_middle_actor_0_in_pivot_empty),
	.full(fifo_small_median_middle_actor_0_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_0_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_0_in_buff_size(
	.datain(fifo_small_median_middle_actor_0_in_buff_size_data),
	.dataout(median_middle_actor_0_in_buff_size_data),
	.enr(median_middle_actor_0_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_0_in_buff_size_wr),
	.empty(median_middle_actor_0_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_0_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_0_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_0_in_median_pos(
	.datain(fifo_small_median_middle_actor_0_in_median_pos_data),
	.dataout(median_middle_actor_0_in_median_pos_data),
	.enr(median_middle_actor_0_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_0_in_median_pos_wr),
	.empty(median_middle_actor_0_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_0_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_0_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_0_in_second_median_value(
	.datain(fifo_small_median_middle_actor_0_in_second_median_value_data),
	.dataout(median_middle_actor_0_in_second_median_value_data),
	.enr(median_middle_actor_0_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_0_in_second_median_value_wr),
	.empty(median_middle_actor_0_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_0_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_0
median_middle_actor actor_median_middle_actor_0 (
	// Input Signal(s)
	.in_px(median_middle_actor_0_in_px_data),
	.in_px_rd(median_middle_actor_0_in_px_rd),
	.in_px_empty(median_middle_actor_0_in_px_empty),
	.in_pivot(median_middle_actor_0_in_pivot_data),
	.in_pivot_rd(median_middle_actor_0_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_0_in_pivot_empty),
	.in_buff_size(median_middle_actor_0_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_0_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_0_in_buff_size_empty),
	.in_median_pos(median_middle_actor_0_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_0_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_0_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_0_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_0_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_0_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_0_out_px_data),
	.out_px_wr(median_middle_actor_0_out_px_wr),
	.out_px_full(median_middle_actor_0_out_px_full),
	.out_pivot(median_middle_actor_0_out_pivot_data),
	.out_pivot_wr(median_middle_actor_0_out_pivot_wr),
	.out_pivot_full(median_middle_actor_0_out_pivot_full),
	.out_buff_size(median_middle_actor_0_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_0_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_0_out_buff_size_full),
	.out_median_pos(median_middle_actor_0_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_0_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_0_out_median_pos_full),
	.out_second_median_value(median_middle_actor_0_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_0_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_0_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_1_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_1_in_px(
	.datain(fifo_small_median_middle_actor_1_in_px_data),
	.dataout(median_middle_actor_1_in_px_data),
	.enr(median_middle_actor_1_in_px_rd),
	.enw(fifo_small_median_middle_actor_1_in_px_wr),
	.empty(median_middle_actor_1_in_px_empty),
	.full(fifo_small_median_middle_actor_1_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_1_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_1_in_pivot(
	.datain(fifo_small_median_middle_actor_1_in_pivot_data),
	.dataout(median_middle_actor_1_in_pivot_data),
	.enr(median_middle_actor_1_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_1_in_pivot_wr),
	.empty(median_middle_actor_1_in_pivot_empty),
	.full(fifo_small_median_middle_actor_1_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_1_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_1_in_buff_size(
	.datain(fifo_small_median_middle_actor_1_in_buff_size_data),
	.dataout(median_middle_actor_1_in_buff_size_data),
	.enr(median_middle_actor_1_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_1_in_buff_size_wr),
	.empty(median_middle_actor_1_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_1_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_1_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_1_in_median_pos(
	.datain(fifo_small_median_middle_actor_1_in_median_pos_data),
	.dataout(median_middle_actor_1_in_median_pos_data),
	.enr(median_middle_actor_1_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_1_in_median_pos_wr),
	.empty(median_middle_actor_1_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_1_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_1_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_1_in_second_median_value(
	.datain(fifo_small_median_middle_actor_1_in_second_median_value_data),
	.dataout(median_middle_actor_1_in_second_median_value_data),
	.enr(median_middle_actor_1_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_1_in_second_median_value_wr),
	.empty(median_middle_actor_1_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_1_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_1
median_middle_actor actor_median_middle_actor_1 (
	// Input Signal(s)
	.in_px(median_middle_actor_1_in_px_data),
	.in_px_rd(median_middle_actor_1_in_px_rd),
	.in_px_empty(median_middle_actor_1_in_px_empty),
	.in_pivot(median_middle_actor_1_in_pivot_data),
	.in_pivot_rd(median_middle_actor_1_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_1_in_pivot_empty),
	.in_buff_size(median_middle_actor_1_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_1_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_1_in_buff_size_empty),
	.in_median_pos(median_middle_actor_1_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_1_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_1_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_1_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_1_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_1_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_1_out_px_data),
	.out_px_wr(median_middle_actor_1_out_px_wr),
	.out_px_full(median_middle_actor_1_out_px_full),
	.out_pivot(median_middle_actor_1_out_pivot_data),
	.out_pivot_wr(median_middle_actor_1_out_pivot_wr),
	.out_pivot_full(median_middle_actor_1_out_pivot_full),
	.out_buff_size(median_middle_actor_1_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_1_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_1_out_buff_size_full),
	.out_median_pos(median_middle_actor_1_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_1_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_1_out_median_pos_full),
	.out_second_median_value(median_middle_actor_1_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_1_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_1_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_2_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_2_in_px(
	.datain(fifo_small_median_middle_actor_2_in_px_data),
	.dataout(median_middle_actor_2_in_px_data),
	.enr(median_middle_actor_2_in_px_rd),
	.enw(fifo_small_median_middle_actor_2_in_px_wr),
	.empty(median_middle_actor_2_in_px_empty),
	.full(fifo_small_median_middle_actor_2_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_2_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_2_in_pivot(
	.datain(fifo_small_median_middle_actor_2_in_pivot_data),
	.dataout(median_middle_actor_2_in_pivot_data),
	.enr(median_middle_actor_2_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_2_in_pivot_wr),
	.empty(median_middle_actor_2_in_pivot_empty),
	.full(fifo_small_median_middle_actor_2_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_2_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_2_in_buff_size(
	.datain(fifo_small_median_middle_actor_2_in_buff_size_data),
	.dataout(median_middle_actor_2_in_buff_size_data),
	.enr(median_middle_actor_2_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_2_in_buff_size_wr),
	.empty(median_middle_actor_2_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_2_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_2_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_2_in_median_pos(
	.datain(fifo_small_median_middle_actor_2_in_median_pos_data),
	.dataout(median_middle_actor_2_in_median_pos_data),
	.enr(median_middle_actor_2_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_2_in_median_pos_wr),
	.empty(median_middle_actor_2_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_2_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_2_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_2_in_second_median_value(
	.datain(fifo_small_median_middle_actor_2_in_second_median_value_data),
	.dataout(median_middle_actor_2_in_second_median_value_data),
	.enr(median_middle_actor_2_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_2_in_second_median_value_wr),
	.empty(median_middle_actor_2_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_2_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_2
median_middle_actor actor_median_middle_actor_2 (
	// Input Signal(s)
	.in_px(median_middle_actor_2_in_px_data),
	.in_px_rd(median_middle_actor_2_in_px_rd),
	.in_px_empty(median_middle_actor_2_in_px_empty),
	.in_pivot(median_middle_actor_2_in_pivot_data),
	.in_pivot_rd(median_middle_actor_2_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_2_in_pivot_empty),
	.in_buff_size(median_middle_actor_2_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_2_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_2_in_buff_size_empty),
	.in_median_pos(median_middle_actor_2_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_2_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_2_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_2_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_2_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_2_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_2_out_px_data),
	.out_px_wr(median_middle_actor_2_out_px_wr),
	.out_px_full(median_middle_actor_2_out_px_full),
	.out_pivot(median_middle_actor_2_out_pivot_data),
	.out_pivot_wr(median_middle_actor_2_out_pivot_wr),
	.out_pivot_full(median_middle_actor_2_out_pivot_full),
	.out_buff_size(median_middle_actor_2_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_2_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_2_out_buff_size_full),
	.out_median_pos(median_middle_actor_2_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_2_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_2_out_median_pos_full),
	.out_second_median_value(median_middle_actor_2_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_2_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_2_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_3_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_3_in_px(
	.datain(fifo_small_median_middle_actor_3_in_px_data),
	.dataout(median_middle_actor_3_in_px_data),
	.enr(median_middle_actor_3_in_px_rd),
	.enw(fifo_small_median_middle_actor_3_in_px_wr),
	.empty(median_middle_actor_3_in_px_empty),
	.full(fifo_small_median_middle_actor_3_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_3_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_3_in_pivot(
	.datain(fifo_small_median_middle_actor_3_in_pivot_data),
	.dataout(median_middle_actor_3_in_pivot_data),
	.enr(median_middle_actor_3_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_3_in_pivot_wr),
	.empty(median_middle_actor_3_in_pivot_empty),
	.full(fifo_small_median_middle_actor_3_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_3_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_3_in_buff_size(
	.datain(fifo_small_median_middle_actor_3_in_buff_size_data),
	.dataout(median_middle_actor_3_in_buff_size_data),
	.enr(median_middle_actor_3_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_3_in_buff_size_wr),
	.empty(median_middle_actor_3_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_3_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_3_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_3_in_median_pos(
	.datain(fifo_small_median_middle_actor_3_in_median_pos_data),
	.dataout(median_middle_actor_3_in_median_pos_data),
	.enr(median_middle_actor_3_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_3_in_median_pos_wr),
	.empty(median_middle_actor_3_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_3_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_3_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_3_in_second_median_value(
	.datain(fifo_small_median_middle_actor_3_in_second_median_value_data),
	.dataout(median_middle_actor_3_in_second_median_value_data),
	.enr(median_middle_actor_3_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_3_in_second_median_value_wr),
	.empty(median_middle_actor_3_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_3_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_3
median_middle_actor actor_median_middle_actor_3 (
	// Input Signal(s)
	.in_px(median_middle_actor_3_in_px_data),
	.in_px_rd(median_middle_actor_3_in_px_rd),
	.in_px_empty(median_middle_actor_3_in_px_empty),
	.in_pivot(median_middle_actor_3_in_pivot_data),
	.in_pivot_rd(median_middle_actor_3_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_3_in_pivot_empty),
	.in_buff_size(median_middle_actor_3_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_3_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_3_in_buff_size_empty),
	.in_median_pos(median_middle_actor_3_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_3_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_3_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_3_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_3_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_3_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_3_out_px_data),
	.out_px_wr(median_middle_actor_3_out_px_wr),
	.out_px_full(median_middle_actor_3_out_px_full),
	.out_pivot(median_middle_actor_3_out_pivot_data),
	.out_pivot_wr(median_middle_actor_3_out_pivot_wr),
	.out_pivot_full(median_middle_actor_3_out_pivot_full),
	.out_buff_size(median_middle_actor_3_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_3_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_3_out_buff_size_full),
	.out_median_pos(median_middle_actor_3_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_3_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_3_out_median_pos_full),
	.out_second_median_value(median_middle_actor_3_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_3_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_3_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_4_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_4_in_px(
	.datain(fifo_small_median_middle_actor_4_in_px_data),
	.dataout(median_middle_actor_4_in_px_data),
	.enr(median_middle_actor_4_in_px_rd),
	.enw(fifo_small_median_middle_actor_4_in_px_wr),
	.empty(median_middle_actor_4_in_px_empty),
	.full(fifo_small_median_middle_actor_4_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_4_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_4_in_pivot(
	.datain(fifo_small_median_middle_actor_4_in_pivot_data),
	.dataout(median_middle_actor_4_in_pivot_data),
	.enr(median_middle_actor_4_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_4_in_pivot_wr),
	.empty(median_middle_actor_4_in_pivot_empty),
	.full(fifo_small_median_middle_actor_4_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_4_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_4_in_buff_size(
	.datain(fifo_small_median_middle_actor_4_in_buff_size_data),
	.dataout(median_middle_actor_4_in_buff_size_data),
	.enr(median_middle_actor_4_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_4_in_buff_size_wr),
	.empty(median_middle_actor_4_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_4_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_4_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_4_in_median_pos(
	.datain(fifo_small_median_middle_actor_4_in_median_pos_data),
	.dataout(median_middle_actor_4_in_median_pos_data),
	.enr(median_middle_actor_4_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_4_in_median_pos_wr),
	.empty(median_middle_actor_4_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_4_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_4_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_4_in_second_median_value(
	.datain(fifo_small_median_middle_actor_4_in_second_median_value_data),
	.dataout(median_middle_actor_4_in_second_median_value_data),
	.enr(median_middle_actor_4_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_4_in_second_median_value_wr),
	.empty(median_middle_actor_4_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_4_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_4
median_middle_actor actor_median_middle_actor_4 (
	// Input Signal(s)
	.in_px(median_middle_actor_4_in_px_data),
	.in_px_rd(median_middle_actor_4_in_px_rd),
	.in_px_empty(median_middle_actor_4_in_px_empty),
	.in_pivot(median_middle_actor_4_in_pivot_data),
	.in_pivot_rd(median_middle_actor_4_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_4_in_pivot_empty),
	.in_buff_size(median_middle_actor_4_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_4_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_4_in_buff_size_empty),
	.in_median_pos(median_middle_actor_4_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_4_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_4_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_4_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_4_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_4_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_4_out_px_data),
	.out_px_wr(median_middle_actor_4_out_px_wr),
	.out_px_full(median_middle_actor_4_out_px_full),
	.out_pivot(median_middle_actor_4_out_pivot_data),
	.out_pivot_wr(median_middle_actor_4_out_pivot_wr),
	.out_pivot_full(median_middle_actor_4_out_pivot_full),
	.out_buff_size(median_middle_actor_4_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_4_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_4_out_buff_size_full),
	.out_median_pos(median_middle_actor_4_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_4_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_4_out_median_pos_full),
	.out_second_median_value(median_middle_actor_4_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_4_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_4_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_median_middle_actor_5_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_5_in_px(
	.datain(fifo_small_median_middle_actor_5_in_px_data),
	.dataout(median_middle_actor_5_in_px_data),
	.enr(median_middle_actor_5_in_px_rd),
	.enw(fifo_small_median_middle_actor_5_in_px_wr),
	.empty(median_middle_actor_5_in_px_empty),
	.full(fifo_small_median_middle_actor_5_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_5_in_pivot
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_5_in_pivot(
	.datain(fifo_small_median_middle_actor_5_in_pivot_data),
	.dataout(median_middle_actor_5_in_pivot_data),
	.enr(median_middle_actor_5_in_pivot_rd),
	.enw(fifo_small_median_middle_actor_5_in_pivot_wr),
	.empty(median_middle_actor_5_in_pivot_empty),
	.full(fifo_small_median_middle_actor_5_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_5_in_buff_size
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_5_in_buff_size(
	.datain(fifo_small_median_middle_actor_5_in_buff_size_data),
	.dataout(median_middle_actor_5_in_buff_size_data),
	.enr(median_middle_actor_5_in_buff_size_rd),
	.enw(fifo_small_median_middle_actor_5_in_buff_size_wr),
	.empty(median_middle_actor_5_in_buff_size_empty),
	.full(fifo_small_median_middle_actor_5_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_5_in_median_pos
fifo_small #(
	.depth(64),
	.size(11)
) fifo_small_median_middle_actor_5_in_median_pos(
	.datain(fifo_small_median_middle_actor_5_in_median_pos_data),
	.dataout(median_middle_actor_5_in_median_pos_data),
	.enr(median_middle_actor_5_in_median_pos_rd),
	.enw(fifo_small_median_middle_actor_5_in_median_pos_wr),
	.empty(median_middle_actor_5_in_median_pos_empty),
	.full(fifo_small_median_middle_actor_5_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_median_middle_actor_5_in_second_median_value
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_median_middle_actor_5_in_second_median_value(
	.datain(fifo_small_median_middle_actor_5_in_second_median_value_data),
	.dataout(median_middle_actor_5_in_second_median_value_data),
	.enr(median_middle_actor_5_in_second_median_value_rd),
	.enw(fifo_small_median_middle_actor_5_in_second_median_value_wr),
	.empty(median_middle_actor_5_in_second_median_value_empty),
	.full(fifo_small_median_middle_actor_5_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor median_middle_actor_5
median_middle_actor actor_median_middle_actor_5 (
	// Input Signal(s)
	.in_px(median_middle_actor_5_in_px_data),
	.in_px_rd(median_middle_actor_5_in_px_rd),
	.in_px_empty(median_middle_actor_5_in_px_empty),
	.in_pivot(median_middle_actor_5_in_pivot_data),
	.in_pivot_rd(median_middle_actor_5_in_pivot_rd),
	.in_pivot_empty(median_middle_actor_5_in_pivot_empty),
	.in_buff_size(median_middle_actor_5_in_buff_size_data),
	.in_buff_size_rd(median_middle_actor_5_in_buff_size_rd),
	.in_buff_size_empty(median_middle_actor_5_in_buff_size_empty),
	.in_median_pos(median_middle_actor_5_in_median_pos_data),
	.in_median_pos_rd(median_middle_actor_5_in_median_pos_rd),
	.in_median_pos_empty(median_middle_actor_5_in_median_pos_empty),
	.in_second_median_value(median_middle_actor_5_in_second_median_value_data),
	.in_second_median_value_rd(median_middle_actor_5_in_second_median_value_rd),
	.in_second_median_value_empty(median_middle_actor_5_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(median_middle_actor_5_out_px_data),
	.out_px_wr(median_middle_actor_5_out_px_wr),
	.out_px_full(median_middle_actor_5_out_px_full),
	.out_pivot(median_middle_actor_5_out_pivot_data),
	.out_pivot_wr(median_middle_actor_5_out_pivot_wr),
	.out_pivot_full(median_middle_actor_5_out_pivot_full),
	.out_buff_size(median_middle_actor_5_out_buff_size_data),
	.out_buff_size_wr(median_middle_actor_5_out_buff_size_wr),
	.out_buff_size_full(median_middle_actor_5_out_buff_size_full),
	.out_median_pos(median_middle_actor_5_out_median_pos_data),
	.out_median_pos_wr(median_middle_actor_5_out_median_pos_wr),
	.out_median_pos_full(median_middle_actor_5_out_median_pos_full),
	.out_second_median_value(median_middle_actor_5_out_second_median_value_data),
	.out_second_median_value_wr(median_middle_actor_5_out_second_median_value_wr),
	.out_second_median_value_full(median_middle_actor_5_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// Module(s) Assignments
assign fifo_small_median_first_actor_0_in_px_data = in_px_data;
assign fifo_small_median_first_actor_0_in_px_wr = in_px_wr;
assign in_px_full = fifo_small_median_first_actor_0_in_px_full;

assign fifo_small_median_middle_actor_3_in_px_data = median_first_actor_0_out_px_data;
assign fifo_small_median_middle_actor_3_in_px_wr = median_first_actor_0_out_px_wr;
assign median_first_actor_0_out_px_full = fifo_small_median_middle_actor_3_in_px_full;

assign fifo_small_median_middle_actor_3_in_pivot_data = median_first_actor_0_out_pivot_data;
assign fifo_small_median_middle_actor_3_in_pivot_wr = median_first_actor_0_out_pivot_wr;
assign median_first_actor_0_out_pivot_full = fifo_small_median_middle_actor_3_in_pivot_full;

assign fifo_small_median_middle_actor_3_in_buff_size_data = median_first_actor_0_out_buff_size_data;
assign fifo_small_median_middle_actor_3_in_buff_size_wr = median_first_actor_0_out_buff_size_wr;
assign median_first_actor_0_out_buff_size_full = fifo_small_median_middle_actor_3_in_buff_size_full;

assign fifo_small_median_middle_actor_3_in_median_pos_data = median_first_actor_0_out_median_pos_data;
assign fifo_small_median_middle_actor_3_in_median_pos_wr = median_first_actor_0_out_median_pos_wr;
assign median_first_actor_0_out_median_pos_full = fifo_small_median_middle_actor_3_in_median_pos_full;

assign fifo_small_median_middle_actor_3_in_second_median_value_data = median_first_actor_0_out_second_median_value_data;
assign fifo_small_median_middle_actor_3_in_second_median_value_wr = median_first_actor_0_out_second_median_value_wr;
assign median_first_actor_0_out_second_median_value_full = fifo_small_median_middle_actor_3_in_second_median_value_full;

assign fifo_small_median_middle_actor_4_in_px_data = median_middle_actor_3_out_px_data;
assign fifo_small_median_middle_actor_4_in_px_wr = median_middle_actor_3_out_px_wr;
assign median_middle_actor_3_out_px_full = fifo_small_median_middle_actor_4_in_px_full;

assign fifo_small_median_middle_actor_4_in_pivot_data = median_middle_actor_3_out_pivot_data;
assign fifo_small_median_middle_actor_4_in_pivot_wr = median_middle_actor_3_out_pivot_wr;
assign median_middle_actor_3_out_pivot_full = fifo_small_median_middle_actor_4_in_pivot_full;

assign fifo_small_median_middle_actor_4_in_buff_size_data = median_middle_actor_3_out_buff_size_data;
assign fifo_small_median_middle_actor_4_in_buff_size_wr = median_middle_actor_3_out_buff_size_wr;
assign median_middle_actor_3_out_buff_size_full = fifo_small_median_middle_actor_4_in_buff_size_full;

assign fifo_small_median_middle_actor_4_in_median_pos_data = median_middle_actor_3_out_median_pos_data;
assign fifo_small_median_middle_actor_4_in_median_pos_wr = median_middle_actor_3_out_median_pos_wr;
assign median_middle_actor_3_out_median_pos_full = fifo_small_median_middle_actor_4_in_median_pos_full;

assign fifo_small_median_middle_actor_4_in_second_median_value_data = median_middle_actor_3_out_second_median_value_data;
assign fifo_small_median_middle_actor_4_in_second_median_value_wr = median_middle_actor_3_out_second_median_value_wr;
assign median_middle_actor_3_out_second_median_value_full = fifo_small_median_middle_actor_4_in_second_median_value_full;

assign fifo_small_median_middle_actor_1_in_px_data = median_middle_actor_4_out_px_data;
assign fifo_small_median_middle_actor_1_in_px_wr = median_middle_actor_4_out_px_wr;
assign median_middle_actor_4_out_px_full = fifo_small_median_middle_actor_1_in_px_full;

assign fifo_small_median_middle_actor_1_in_pivot_data = median_middle_actor_4_out_pivot_data;
assign fifo_small_median_middle_actor_1_in_pivot_wr = median_middle_actor_4_out_pivot_wr;
assign median_middle_actor_4_out_pivot_full = fifo_small_median_middle_actor_1_in_pivot_full;

assign fifo_small_median_middle_actor_1_in_buff_size_data = median_middle_actor_4_out_buff_size_data;
assign fifo_small_median_middle_actor_1_in_buff_size_wr = median_middle_actor_4_out_buff_size_wr;
assign median_middle_actor_4_out_buff_size_full = fifo_small_median_middle_actor_1_in_buff_size_full;

assign fifo_small_median_middle_actor_1_in_median_pos_data = median_middle_actor_4_out_median_pos_data;
assign fifo_small_median_middle_actor_1_in_median_pos_wr = median_middle_actor_4_out_median_pos_wr;
assign median_middle_actor_4_out_median_pos_full = fifo_small_median_middle_actor_1_in_median_pos_full;

assign fifo_small_median_middle_actor_1_in_second_median_value_data = median_middle_actor_4_out_second_median_value_data;
assign fifo_small_median_middle_actor_1_in_second_median_value_wr = median_middle_actor_4_out_second_median_value_wr;
assign median_middle_actor_4_out_second_median_value_full = fifo_small_median_middle_actor_1_in_second_median_value_full;

assign fifo_small_median_middle_actor_0_in_px_data = median_middle_actor_1_out_px_data;
assign fifo_small_median_middle_actor_0_in_px_wr = median_middle_actor_1_out_px_wr;
assign median_middle_actor_1_out_px_full = fifo_small_median_middle_actor_0_in_px_full;

assign fifo_small_median_middle_actor_0_in_pivot_data = median_middle_actor_1_out_pivot_data;
assign fifo_small_median_middle_actor_0_in_pivot_wr = median_middle_actor_1_out_pivot_wr;
assign median_middle_actor_1_out_pivot_full = fifo_small_median_middle_actor_0_in_pivot_full;

assign fifo_small_median_middle_actor_0_in_buff_size_data = median_middle_actor_1_out_buff_size_data;
assign fifo_small_median_middle_actor_0_in_buff_size_wr = median_middle_actor_1_out_buff_size_wr;
assign median_middle_actor_1_out_buff_size_full = fifo_small_median_middle_actor_0_in_buff_size_full;

assign fifo_small_median_middle_actor_0_in_median_pos_data = median_middle_actor_1_out_median_pos_data;
assign fifo_small_median_middle_actor_0_in_median_pos_wr = median_middle_actor_1_out_median_pos_wr;
assign median_middle_actor_1_out_median_pos_full = fifo_small_median_middle_actor_0_in_median_pos_full;

assign fifo_small_median_middle_actor_0_in_second_median_value_data = median_middle_actor_1_out_second_median_value_data;
assign fifo_small_median_middle_actor_0_in_second_median_value_wr = median_middle_actor_1_out_second_median_value_wr;
assign median_middle_actor_1_out_second_median_value_full = fifo_small_median_middle_actor_0_in_second_median_value_full;

assign fifo_small_median_middle_actor_5_in_px_data = median_middle_actor_0_out_px_data;
assign fifo_small_median_middle_actor_5_in_px_wr = median_middle_actor_0_out_px_wr;
assign median_middle_actor_0_out_px_full = fifo_small_median_middle_actor_5_in_px_full;

assign fifo_small_median_middle_actor_5_in_pivot_data = median_middle_actor_0_out_pivot_data;
assign fifo_small_median_middle_actor_5_in_pivot_wr = median_middle_actor_0_out_pivot_wr;
assign median_middle_actor_0_out_pivot_full = fifo_small_median_middle_actor_5_in_pivot_full;

assign fifo_small_median_middle_actor_5_in_buff_size_data = median_middle_actor_0_out_buff_size_data;
assign fifo_small_median_middle_actor_5_in_buff_size_wr = median_middle_actor_0_out_buff_size_wr;
assign median_middle_actor_0_out_buff_size_full = fifo_small_median_middle_actor_5_in_buff_size_full;

assign fifo_small_median_middle_actor_5_in_median_pos_data = median_middle_actor_0_out_median_pos_data;
assign fifo_small_median_middle_actor_5_in_median_pos_wr = median_middle_actor_0_out_median_pos_wr;
assign median_middle_actor_0_out_median_pos_full = fifo_small_median_middle_actor_5_in_median_pos_full;

assign fifo_small_median_middle_actor_5_in_second_median_value_data = median_middle_actor_0_out_second_median_value_data;
assign fifo_small_median_middle_actor_5_in_second_median_value_wr = median_middle_actor_0_out_second_median_value_wr;
assign median_middle_actor_0_out_second_median_value_full = fifo_small_median_middle_actor_5_in_second_median_value_full;

assign fifo_small_median_middle_actor_2_in_px_data = median_middle_actor_5_out_px_data;
assign fifo_small_median_middle_actor_2_in_px_wr = median_middle_actor_5_out_px_wr;
assign median_middle_actor_5_out_px_full = fifo_small_median_middle_actor_2_in_px_full;

assign fifo_small_median_middle_actor_2_in_pivot_data = median_middle_actor_5_out_pivot_data;
assign fifo_small_median_middle_actor_2_in_pivot_wr = median_middle_actor_5_out_pivot_wr;
assign median_middle_actor_5_out_pivot_full = fifo_small_median_middle_actor_2_in_pivot_full;

assign fifo_small_median_middle_actor_2_in_buff_size_data = median_middle_actor_5_out_buff_size_data;
assign fifo_small_median_middle_actor_2_in_buff_size_wr = median_middle_actor_5_out_buff_size_wr;
assign median_middle_actor_5_out_buff_size_full = fifo_small_median_middle_actor_2_in_buff_size_full;

assign fifo_small_median_middle_actor_2_in_median_pos_data = median_middle_actor_5_out_median_pos_data;
assign fifo_small_median_middle_actor_2_in_median_pos_wr = median_middle_actor_5_out_median_pos_wr;
assign median_middle_actor_5_out_median_pos_full = fifo_small_median_middle_actor_2_in_median_pos_full;

assign fifo_small_median_middle_actor_2_in_second_median_value_data = median_middle_actor_5_out_second_median_value_data;
assign fifo_small_median_middle_actor_2_in_second_median_value_wr = median_middle_actor_5_out_second_median_value_wr;
assign median_middle_actor_5_out_second_median_value_full = fifo_small_median_middle_actor_2_in_second_median_value_full;

assign out_px_data = median_middle_actor_2_out_px_data;
assign out_px_wr = median_middle_actor_2_out_px_wr;
assign median_middle_actor_2_out_px_full = out_px_full;

endmodule
