// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Network module 
// Date: 2022/03/30 16:12:02
//
// ----------------------------------------------------------------------------

module multi_dataflow (
	// Input(s)
	input [7 : 0] in_px_data,
	input in_px_wr,
	output in_px_full,
	
	// Output(s)
	input [7 : 0] in_pivot_data,
	input in_pivot_wr,
	output in_pivot_full,
	
	// Output(s)
	input [10 : 0] in_buff_size_data,
	input in_buff_size_wr,
	output in_buff_size_full,
	
	// Output(s)
	input [10 : 0] in_median_pos_data,
	input in_median_pos_wr,
	output in_median_pos_full,
	
	// Output(s)
	input [7 : 0] in_second_median_value_data,
	input in_second_median_value_wr,
	output in_second_median_value_full,
	
	// Output(s)
	output [7 : 0] out_px_data,
	output out_px_wr,
	input out_px_full,
	output [7 : 0] out_pivot_data,
	output out_pivot_wr,
	input out_pivot_full,
	output [10 : 0] out_buff_size_data,
	output out_buff_size_wr,
	input out_buff_size_full,
	output [10 : 0] out_median_pos_data,
	output out_median_pos_wr,
	input out_median_pos_full,
	output [7 : 0] out_second_median_value_data,
	output out_second_median_value_wr,
	input out_second_median_value_full,
	
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
	
// actor fill_and_check_0
wire [7 : 0] fifo_small_fill_and_check_0_in_px_data;
wire fifo_small_fill_and_check_0_in_px_wr;
wire fifo_small_fill_and_check_0_in_px_full;
wire [7 : 0] fill_and_check_0_in_px_data;
wire fill_and_check_0_in_px_rd;
wire fill_and_check_0_in_px_empty;
wire [7 : 0] fifo_small_fill_and_check_0_in_pivot_data;
wire fifo_small_fill_and_check_0_in_pivot_wr;
wire fifo_small_fill_and_check_0_in_pivot_full;
wire [7 : 0] fill_and_check_0_in_pivot_data;
wire fill_and_check_0_in_pivot_rd;
wire fill_and_check_0_in_pivot_empty;
wire [10 : 0] fifo_small_fill_and_check_0_in_buff_size_data;
wire fifo_small_fill_and_check_0_in_buff_size_wr;
wire fifo_small_fill_and_check_0_in_buff_size_full;
wire [10 : 0] fill_and_check_0_in_buff_size_data;
wire fill_and_check_0_in_buff_size_rd;
wire fill_and_check_0_in_buff_size_empty;
wire [10 : 0] fifo_small_fill_and_check_0_in_median_pos_data;
wire fifo_small_fill_and_check_0_in_median_pos_wr;
wire fifo_small_fill_and_check_0_in_median_pos_full;
wire [10 : 0] fill_and_check_0_in_median_pos_data;
wire fill_and_check_0_in_median_pos_rd;
wire fill_and_check_0_in_median_pos_empty;
wire [7 : 0] fifo_small_fill_and_check_0_in_second_median_value_data;
wire fifo_small_fill_and_check_0_in_second_median_value_wr;
wire fifo_small_fill_and_check_0_in_second_median_value_full;
wire [7 : 0] fill_and_check_0_in_second_median_value_data;
wire fill_and_check_0_in_second_median_value_rd;
wire fill_and_check_0_in_second_median_value_empty;
wire [7 : 0] fill_and_check_0_out_px_data;
wire fill_and_check_0_out_px_wr;
wire fill_and_check_0_out_px_full;
wire [7 : 0] fill_and_check_0_out_pivot_data;
wire fill_and_check_0_out_pivot_wr;
wire fill_and_check_0_out_pivot_full;
wire [10 : 0] fill_and_check_0_out_buff_size_data;
wire fill_and_check_0_out_buff_size_wr;
wire fill_and_check_0_out_buff_size_full;
wire [10 : 0] fill_and_check_0_out_median_pos_data;
wire fill_and_check_0_out_median_pos_wr;
wire fill_and_check_0_out_median_pos_full;
wire [7 : 0] fill_and_check_0_out_second_median_value_data;
wire fill_and_check_0_out_second_median_value_wr;
wire fill_and_check_0_out_second_median_value_full;
	
// actor fill_and_check_1
wire [7 : 0] fifo_small_fill_and_check_1_in_px_data;
wire fifo_small_fill_and_check_1_in_px_wr;
wire fifo_small_fill_and_check_1_in_px_full;
wire [7 : 0] fill_and_check_1_in_px_data;
wire fill_and_check_1_in_px_rd;
wire fill_and_check_1_in_px_empty;
wire [7 : 0] fifo_small_fill_and_check_1_in_pivot_data;
wire fifo_small_fill_and_check_1_in_pivot_wr;
wire fifo_small_fill_and_check_1_in_pivot_full;
wire [7 : 0] fill_and_check_1_in_pivot_data;
wire fill_and_check_1_in_pivot_rd;
wire fill_and_check_1_in_pivot_empty;
wire [10 : 0] fifo_small_fill_and_check_1_in_buff_size_data;
wire fifo_small_fill_and_check_1_in_buff_size_wr;
wire fifo_small_fill_and_check_1_in_buff_size_full;
wire [10 : 0] fill_and_check_1_in_buff_size_data;
wire fill_and_check_1_in_buff_size_rd;
wire fill_and_check_1_in_buff_size_empty;
wire [10 : 0] fifo_small_fill_and_check_1_in_median_pos_data;
wire fifo_small_fill_and_check_1_in_median_pos_wr;
wire fifo_small_fill_and_check_1_in_median_pos_full;
wire [10 : 0] fill_and_check_1_in_median_pos_data;
wire fill_and_check_1_in_median_pos_rd;
wire fill_and_check_1_in_median_pos_empty;
wire [7 : 0] fifo_small_fill_and_check_1_in_second_median_value_data;
wire fifo_small_fill_and_check_1_in_second_median_value_wr;
wire fifo_small_fill_and_check_1_in_second_median_value_full;
wire [7 : 0] fill_and_check_1_in_second_median_value_data;
wire fill_and_check_1_in_second_median_value_rd;
wire fill_and_check_1_in_second_median_value_empty;
wire [7 : 0] fill_and_check_1_out_px_data;
wire fill_and_check_1_out_px_wr;
wire fill_and_check_1_out_px_full;
wire [7 : 0] fill_and_check_1_out_pivot_data;
wire fill_and_check_1_out_pivot_wr;
wire fill_and_check_1_out_pivot_full;
wire [10 : 0] fill_and_check_1_out_buff_size_data;
wire fill_and_check_1_out_buff_size_wr;
wire fill_and_check_1_out_buff_size_full;
wire [10 : 0] fill_and_check_1_out_median_pos_data;
wire fill_and_check_1_out_median_pos_wr;
wire fill_and_check_1_out_median_pos_full;
wire [7 : 0] fill_and_check_1_out_second_median_value_data;
wire fill_and_check_1_out_second_median_value_wr;
wire fill_and_check_1_out_second_median_value_full;
	
// actor fill_and_check_2
wire [7 : 0] fifo_small_fill_and_check_2_in_px_data;
wire fifo_small_fill_and_check_2_in_px_wr;
wire fifo_small_fill_and_check_2_in_px_full;
wire [7 : 0] fill_and_check_2_in_px_data;
wire fill_and_check_2_in_px_rd;
wire fill_and_check_2_in_px_empty;
wire [7 : 0] fifo_small_fill_and_check_2_in_pivot_data;
wire fifo_small_fill_and_check_2_in_pivot_wr;
wire fifo_small_fill_and_check_2_in_pivot_full;
wire [7 : 0] fill_and_check_2_in_pivot_data;
wire fill_and_check_2_in_pivot_rd;
wire fill_and_check_2_in_pivot_empty;
wire [10 : 0] fifo_small_fill_and_check_2_in_buff_size_data;
wire fifo_small_fill_and_check_2_in_buff_size_wr;
wire fifo_small_fill_and_check_2_in_buff_size_full;
wire [10 : 0] fill_and_check_2_in_buff_size_data;
wire fill_and_check_2_in_buff_size_rd;
wire fill_and_check_2_in_buff_size_empty;
wire [10 : 0] fifo_small_fill_and_check_2_in_median_pos_data;
wire fifo_small_fill_and_check_2_in_median_pos_wr;
wire fifo_small_fill_and_check_2_in_median_pos_full;
wire [10 : 0] fill_and_check_2_in_median_pos_data;
wire fill_and_check_2_in_median_pos_rd;
wire fill_and_check_2_in_median_pos_empty;
wire [7 : 0] fifo_small_fill_and_check_2_in_second_median_value_data;
wire fifo_small_fill_and_check_2_in_second_median_value_wr;
wire fifo_small_fill_and_check_2_in_second_median_value_full;
wire [7 : 0] fill_and_check_2_in_second_median_value_data;
wire fill_and_check_2_in_second_median_value_rd;
wire fill_and_check_2_in_second_median_value_empty;
wire [7 : 0] fill_and_check_2_out_px_data;
wire fill_and_check_2_out_px_wr;
wire fill_and_check_2_out_px_full;
wire [7 : 0] fill_and_check_2_out_pivot_data;
wire fill_and_check_2_out_pivot_wr;
wire fill_and_check_2_out_pivot_full;
wire [10 : 0] fill_and_check_2_out_buff_size_data;
wire fill_and_check_2_out_buff_size_wr;
wire fill_and_check_2_out_buff_size_full;
wire [10 : 0] fill_and_check_2_out_median_pos_data;
wire fill_and_check_2_out_median_pos_wr;
wire fill_and_check_2_out_median_pos_full;
wire [7 : 0] fill_and_check_2_out_second_median_value_data;
wire fill_and_check_2_out_second_median_value_wr;
wire fill_and_check_2_out_second_median_value_full;
	
// actor fill_and_check_3
wire [7 : 0] fifo_small_fill_and_check_3_in_px_data;
wire fifo_small_fill_and_check_3_in_px_wr;
wire fifo_small_fill_and_check_3_in_px_full;
wire [7 : 0] fill_and_check_3_in_px_data;
wire fill_and_check_3_in_px_rd;
wire fill_and_check_3_in_px_empty;
wire [7 : 0] fifo_small_fill_and_check_3_in_pivot_data;
wire fifo_small_fill_and_check_3_in_pivot_wr;
wire fifo_small_fill_and_check_3_in_pivot_full;
wire [7 : 0] fill_and_check_3_in_pivot_data;
wire fill_and_check_3_in_pivot_rd;
wire fill_and_check_3_in_pivot_empty;
wire [10 : 0] fifo_small_fill_and_check_3_in_buff_size_data;
wire fifo_small_fill_and_check_3_in_buff_size_wr;
wire fifo_small_fill_and_check_3_in_buff_size_full;
wire [10 : 0] fill_and_check_3_in_buff_size_data;
wire fill_and_check_3_in_buff_size_rd;
wire fill_and_check_3_in_buff_size_empty;
wire [10 : 0] fifo_small_fill_and_check_3_in_median_pos_data;
wire fifo_small_fill_and_check_3_in_median_pos_wr;
wire fifo_small_fill_and_check_3_in_median_pos_full;
wire [10 : 0] fill_and_check_3_in_median_pos_data;
wire fill_and_check_3_in_median_pos_rd;
wire fill_and_check_3_in_median_pos_empty;
wire [7 : 0] fifo_small_fill_and_check_3_in_second_median_value_data;
wire fifo_small_fill_and_check_3_in_second_median_value_wr;
wire fifo_small_fill_and_check_3_in_second_median_value_full;
wire [7 : 0] fill_and_check_3_in_second_median_value_data;
wire fill_and_check_3_in_second_median_value_rd;
wire fill_and_check_3_in_second_median_value_empty;
wire [7 : 0] fill_and_check_3_out_px_data;
wire fill_and_check_3_out_px_wr;
wire fill_and_check_3_out_px_full;
wire [7 : 0] fill_and_check_3_out_pivot_data;
wire fill_and_check_3_out_pivot_wr;
wire fill_and_check_3_out_pivot_full;
wire [10 : 0] fill_and_check_3_out_buff_size_data;
wire fill_and_check_3_out_buff_size_wr;
wire fill_and_check_3_out_buff_size_full;
wire [10 : 0] fill_and_check_3_out_median_pos_data;
wire fill_and_check_3_out_median_pos_wr;
wire fill_and_check_3_out_median_pos_full;
wire [7 : 0] fill_and_check_3_out_second_median_value_data;
wire fill_and_check_3_out_second_median_value_wr;
wire fill_and_check_3_out_second_median_value_full;
	
// actor fill_and_check_4
wire [7 : 0] fifo_small_fill_and_check_4_in_px_data;
wire fifo_small_fill_and_check_4_in_px_wr;
wire fifo_small_fill_and_check_4_in_px_full;
wire [7 : 0] fill_and_check_4_in_px_data;
wire fill_and_check_4_in_px_rd;
wire fill_and_check_4_in_px_empty;
wire [7 : 0] fifo_small_fill_and_check_4_in_pivot_data;
wire fifo_small_fill_and_check_4_in_pivot_wr;
wire fifo_small_fill_and_check_4_in_pivot_full;
wire [7 : 0] fill_and_check_4_in_pivot_data;
wire fill_and_check_4_in_pivot_rd;
wire fill_and_check_4_in_pivot_empty;
wire [10 : 0] fifo_small_fill_and_check_4_in_buff_size_data;
wire fifo_small_fill_and_check_4_in_buff_size_wr;
wire fifo_small_fill_and_check_4_in_buff_size_full;
wire [10 : 0] fill_and_check_4_in_buff_size_data;
wire fill_and_check_4_in_buff_size_rd;
wire fill_and_check_4_in_buff_size_empty;
wire [10 : 0] fifo_small_fill_and_check_4_in_median_pos_data;
wire fifo_small_fill_and_check_4_in_median_pos_wr;
wire fifo_small_fill_and_check_4_in_median_pos_full;
wire [10 : 0] fill_and_check_4_in_median_pos_data;
wire fill_and_check_4_in_median_pos_rd;
wire fill_and_check_4_in_median_pos_empty;
wire [7 : 0] fifo_small_fill_and_check_4_in_second_median_value_data;
wire fifo_small_fill_and_check_4_in_second_median_value_wr;
wire fifo_small_fill_and_check_4_in_second_median_value_full;
wire [7 : 0] fill_and_check_4_in_second_median_value_data;
wire fill_and_check_4_in_second_median_value_rd;
wire fill_and_check_4_in_second_median_value_empty;
wire [7 : 0] fill_and_check_4_out_px_data;
wire fill_and_check_4_out_px_wr;
wire fill_and_check_4_out_px_full;
wire [7 : 0] fill_and_check_4_out_pivot_data;
wire fill_and_check_4_out_pivot_wr;
wire fill_and_check_4_out_pivot_full;
wire [10 : 0] fill_and_check_4_out_buff_size_data;
wire fill_and_check_4_out_buff_size_wr;
wire fill_and_check_4_out_buff_size_full;
wire [10 : 0] fill_and_check_4_out_median_pos_data;
wire fill_and_check_4_out_median_pos_wr;
wire fill_and_check_4_out_median_pos_full;
wire [7 : 0] fill_and_check_4_out_second_median_value_data;
wire fill_and_check_4_out_second_median_value_wr;
wire fill_and_check_4_out_second_median_value_full;
// ----------------------------------------------------------------------------

// body
// ----------------------------------------------------------------------------



// fifo_small_fill_and_check_0_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_fill_and_check_0_in_px(
	.datain(fifo_small_fill_and_check_0_in_px_data),
	.dataout(fill_and_check_0_in_px_data),
	.enr(fill_and_check_0_in_px_rd),
	.enw(fifo_small_fill_and_check_0_in_px_wr),
	.empty(fill_and_check_0_in_px_empty),
	.full(fifo_small_fill_and_check_0_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_0_in_pivot
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_0_in_pivot(
	.datain(fifo_small_fill_and_check_0_in_pivot_data),
	.dataout(fill_and_check_0_in_pivot_data),
	.enr(fill_and_check_0_in_pivot_rd),
	.enw(fifo_small_fill_and_check_0_in_pivot_wr),
	.empty(fill_and_check_0_in_pivot_empty),
	.full(fifo_small_fill_and_check_0_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_0_in_buff_size
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_0_in_buff_size(
	.datain(fifo_small_fill_and_check_0_in_buff_size_data),
	.dataout(fill_and_check_0_in_buff_size_data),
	.enr(fill_and_check_0_in_buff_size_rd),
	.enw(fifo_small_fill_and_check_0_in_buff_size_wr),
	.empty(fill_and_check_0_in_buff_size_empty),
	.full(fifo_small_fill_and_check_0_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_0_in_median_pos
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_0_in_median_pos(
	.datain(fifo_small_fill_and_check_0_in_median_pos_data),
	.dataout(fill_and_check_0_in_median_pos_data),
	.enr(fill_and_check_0_in_median_pos_rd),
	.enw(fifo_small_fill_and_check_0_in_median_pos_wr),
	.empty(fill_and_check_0_in_median_pos_empty),
	.full(fifo_small_fill_and_check_0_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_0_in_second_median_value
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_0_in_second_median_value(
	.datain(fifo_small_fill_and_check_0_in_second_median_value_data),
	.dataout(fill_and_check_0_in_second_median_value_data),
	.enr(fill_and_check_0_in_second_median_value_rd),
	.enw(fifo_small_fill_and_check_0_in_second_median_value_wr),
	.empty(fill_and_check_0_in_second_median_value_empty),
	.full(fifo_small_fill_and_check_0_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor fill_and_check_0
fill_and_check actor_fill_and_check_0 (
	// Input Signal(s)
	.in_px(fill_and_check_0_in_px_data),
	.in_px_rd(fill_and_check_0_in_px_rd),
	.in_px_empty(fill_and_check_0_in_px_empty),
	.in_pivot(fill_and_check_0_in_pivot_data),
	.in_pivot_rd(fill_and_check_0_in_pivot_rd),
	.in_pivot_empty(fill_and_check_0_in_pivot_empty),
	.in_buff_size(fill_and_check_0_in_buff_size_data),
	.in_buff_size_rd(fill_and_check_0_in_buff_size_rd),
	.in_buff_size_empty(fill_and_check_0_in_buff_size_empty),
	.in_median_pos(fill_and_check_0_in_median_pos_data),
	.in_median_pos_rd(fill_and_check_0_in_median_pos_rd),
	.in_median_pos_empty(fill_and_check_0_in_median_pos_empty),
	.in_second_median_value(fill_and_check_0_in_second_median_value_data),
	.in_second_median_value_rd(fill_and_check_0_in_second_median_value_rd),
	.in_second_median_value_empty(fill_and_check_0_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(fill_and_check_0_out_px_data),
	.out_px_wr(fill_and_check_0_out_px_wr),
	.out_px_full(fill_and_check_0_out_px_full),
	.out_pivot(fill_and_check_0_out_pivot_data),
	.out_pivot_wr(fill_and_check_0_out_pivot_wr),
	.out_pivot_full(fill_and_check_0_out_pivot_full),
	.out_buff_size(fill_and_check_0_out_buff_size_data),
	.out_buff_size_wr(fill_and_check_0_out_buff_size_wr),
	.out_buff_size_full(fill_and_check_0_out_buff_size_full),
	.out_median_pos(fill_and_check_0_out_median_pos_data),
	.out_median_pos_wr(fill_and_check_0_out_median_pos_wr),
	.out_median_pos_full(fill_and_check_0_out_median_pos_full),
	.out_second_median_value(fill_and_check_0_out_second_median_value_data),
	.out_second_median_value_wr(fill_and_check_0_out_second_median_value_wr),
	.out_second_median_value_full(fill_and_check_0_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_fill_and_check_1_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_fill_and_check_1_in_px(
	.datain(fifo_small_fill_and_check_1_in_px_data),
	.dataout(fill_and_check_1_in_px_data),
	.enr(fill_and_check_1_in_px_rd),
	.enw(fifo_small_fill_and_check_1_in_px_wr),
	.empty(fill_and_check_1_in_px_empty),
	.full(fifo_small_fill_and_check_1_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_1_in_pivot
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_1_in_pivot(
	.datain(fifo_small_fill_and_check_1_in_pivot_data),
	.dataout(fill_and_check_1_in_pivot_data),
	.enr(fill_and_check_1_in_pivot_rd),
	.enw(fifo_small_fill_and_check_1_in_pivot_wr),
	.empty(fill_and_check_1_in_pivot_empty),
	.full(fifo_small_fill_and_check_1_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_1_in_buff_size
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_1_in_buff_size(
	.datain(fifo_small_fill_and_check_1_in_buff_size_data),
	.dataout(fill_and_check_1_in_buff_size_data),
	.enr(fill_and_check_1_in_buff_size_rd),
	.enw(fifo_small_fill_and_check_1_in_buff_size_wr),
	.empty(fill_and_check_1_in_buff_size_empty),
	.full(fifo_small_fill_and_check_1_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_1_in_median_pos
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_1_in_median_pos(
	.datain(fifo_small_fill_and_check_1_in_median_pos_data),
	.dataout(fill_and_check_1_in_median_pos_data),
	.enr(fill_and_check_1_in_median_pos_rd),
	.enw(fifo_small_fill_and_check_1_in_median_pos_wr),
	.empty(fill_and_check_1_in_median_pos_empty),
	.full(fifo_small_fill_and_check_1_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_1_in_second_median_value
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_1_in_second_median_value(
	.datain(fifo_small_fill_and_check_1_in_second_median_value_data),
	.dataout(fill_and_check_1_in_second_median_value_data),
	.enr(fill_and_check_1_in_second_median_value_rd),
	.enw(fifo_small_fill_and_check_1_in_second_median_value_wr),
	.empty(fill_and_check_1_in_second_median_value_empty),
	.full(fifo_small_fill_and_check_1_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor fill_and_check_1
fill_and_check actor_fill_and_check_1 (
	// Input Signal(s)
	.in_px(fill_and_check_1_in_px_data),
	.in_px_rd(fill_and_check_1_in_px_rd),
	.in_px_empty(fill_and_check_1_in_px_empty),
	.in_pivot(fill_and_check_1_in_pivot_data),
	.in_pivot_rd(fill_and_check_1_in_pivot_rd),
	.in_pivot_empty(fill_and_check_1_in_pivot_empty),
	.in_buff_size(fill_and_check_1_in_buff_size_data),
	.in_buff_size_rd(fill_and_check_1_in_buff_size_rd),
	.in_buff_size_empty(fill_and_check_1_in_buff_size_empty),
	.in_median_pos(fill_and_check_1_in_median_pos_data),
	.in_median_pos_rd(fill_and_check_1_in_median_pos_rd),
	.in_median_pos_empty(fill_and_check_1_in_median_pos_empty),
	.in_second_median_value(fill_and_check_1_in_second_median_value_data),
	.in_second_median_value_rd(fill_and_check_1_in_second_median_value_rd),
	.in_second_median_value_empty(fill_and_check_1_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(fill_and_check_1_out_px_data),
	.out_px_wr(fill_and_check_1_out_px_wr),
	.out_px_full(fill_and_check_1_out_px_full),
	.out_pivot(fill_and_check_1_out_pivot_data),
	.out_pivot_wr(fill_and_check_1_out_pivot_wr),
	.out_pivot_full(fill_and_check_1_out_pivot_full),
	.out_buff_size(fill_and_check_1_out_buff_size_data),
	.out_buff_size_wr(fill_and_check_1_out_buff_size_wr),
	.out_buff_size_full(fill_and_check_1_out_buff_size_full),
	.out_median_pos(fill_and_check_1_out_median_pos_data),
	.out_median_pos_wr(fill_and_check_1_out_median_pos_wr),
	.out_median_pos_full(fill_and_check_1_out_median_pos_full),
	.out_second_median_value(fill_and_check_1_out_second_median_value_data),
	.out_second_median_value_wr(fill_and_check_1_out_second_median_value_wr),
	.out_second_median_value_full(fill_and_check_1_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_fill_and_check_2_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_fill_and_check_2_in_px(
	.datain(fifo_small_fill_and_check_2_in_px_data),
	.dataout(fill_and_check_2_in_px_data),
	.enr(fill_and_check_2_in_px_rd),
	.enw(fifo_small_fill_and_check_2_in_px_wr),
	.empty(fill_and_check_2_in_px_empty),
	.full(fifo_small_fill_and_check_2_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_2_in_pivot
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_2_in_pivot(
	.datain(fifo_small_fill_and_check_2_in_pivot_data),
	.dataout(fill_and_check_2_in_pivot_data),
	.enr(fill_and_check_2_in_pivot_rd),
	.enw(fifo_small_fill_and_check_2_in_pivot_wr),
	.empty(fill_and_check_2_in_pivot_empty),
	.full(fifo_small_fill_and_check_2_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_2_in_buff_size
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_2_in_buff_size(
	.datain(fifo_small_fill_and_check_2_in_buff_size_data),
	.dataout(fill_and_check_2_in_buff_size_data),
	.enr(fill_and_check_2_in_buff_size_rd),
	.enw(fifo_small_fill_and_check_2_in_buff_size_wr),
	.empty(fill_and_check_2_in_buff_size_empty),
	.full(fifo_small_fill_and_check_2_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_2_in_median_pos
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_2_in_median_pos(
	.datain(fifo_small_fill_and_check_2_in_median_pos_data),
	.dataout(fill_and_check_2_in_median_pos_data),
	.enr(fill_and_check_2_in_median_pos_rd),
	.enw(fifo_small_fill_and_check_2_in_median_pos_wr),
	.empty(fill_and_check_2_in_median_pos_empty),
	.full(fifo_small_fill_and_check_2_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_2_in_second_median_value
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_2_in_second_median_value(
	.datain(fifo_small_fill_and_check_2_in_second_median_value_data),
	.dataout(fill_and_check_2_in_second_median_value_data),
	.enr(fill_and_check_2_in_second_median_value_rd),
	.enw(fifo_small_fill_and_check_2_in_second_median_value_wr),
	.empty(fill_and_check_2_in_second_median_value_empty),
	.full(fifo_small_fill_and_check_2_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor fill_and_check_2
fill_and_check actor_fill_and_check_2 (
	// Input Signal(s)
	.in_px(fill_and_check_2_in_px_data),
	.in_px_rd(fill_and_check_2_in_px_rd),
	.in_px_empty(fill_and_check_2_in_px_empty),
	.in_pivot(fill_and_check_2_in_pivot_data),
	.in_pivot_rd(fill_and_check_2_in_pivot_rd),
	.in_pivot_empty(fill_and_check_2_in_pivot_empty),
	.in_buff_size(fill_and_check_2_in_buff_size_data),
	.in_buff_size_rd(fill_and_check_2_in_buff_size_rd),
	.in_buff_size_empty(fill_and_check_2_in_buff_size_empty),
	.in_median_pos(fill_and_check_2_in_median_pos_data),
	.in_median_pos_rd(fill_and_check_2_in_median_pos_rd),
	.in_median_pos_empty(fill_and_check_2_in_median_pos_empty),
	.in_second_median_value(fill_and_check_2_in_second_median_value_data),
	.in_second_median_value_rd(fill_and_check_2_in_second_median_value_rd),
	.in_second_median_value_empty(fill_and_check_2_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(fill_and_check_2_out_px_data),
	.out_px_wr(fill_and_check_2_out_px_wr),
	.out_px_full(fill_and_check_2_out_px_full),
	.out_pivot(fill_and_check_2_out_pivot_data),
	.out_pivot_wr(fill_and_check_2_out_pivot_wr),
	.out_pivot_full(fill_and_check_2_out_pivot_full),
	.out_buff_size(fill_and_check_2_out_buff_size_data),
	.out_buff_size_wr(fill_and_check_2_out_buff_size_wr),
	.out_buff_size_full(fill_and_check_2_out_buff_size_full),
	.out_median_pos(fill_and_check_2_out_median_pos_data),
	.out_median_pos_wr(fill_and_check_2_out_median_pos_wr),
	.out_median_pos_full(fill_and_check_2_out_median_pos_full),
	.out_second_median_value(fill_and_check_2_out_second_median_value_data),
	.out_second_median_value_wr(fill_and_check_2_out_second_median_value_wr),
	.out_second_median_value_full(fill_and_check_2_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_fill_and_check_3_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_fill_and_check_3_in_px(
	.datain(fifo_small_fill_and_check_3_in_px_data),
	.dataout(fill_and_check_3_in_px_data),
	.enr(fill_and_check_3_in_px_rd),
	.enw(fifo_small_fill_and_check_3_in_px_wr),
	.empty(fill_and_check_3_in_px_empty),
	.full(fifo_small_fill_and_check_3_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_3_in_pivot
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_3_in_pivot(
	.datain(fifo_small_fill_and_check_3_in_pivot_data),
	.dataout(fill_and_check_3_in_pivot_data),
	.enr(fill_and_check_3_in_pivot_rd),
	.enw(fifo_small_fill_and_check_3_in_pivot_wr),
	.empty(fill_and_check_3_in_pivot_empty),
	.full(fifo_small_fill_and_check_3_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_3_in_buff_size
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_3_in_buff_size(
	.datain(fifo_small_fill_and_check_3_in_buff_size_data),
	.dataout(fill_and_check_3_in_buff_size_data),
	.enr(fill_and_check_3_in_buff_size_rd),
	.enw(fifo_small_fill_and_check_3_in_buff_size_wr),
	.empty(fill_and_check_3_in_buff_size_empty),
	.full(fifo_small_fill_and_check_3_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_3_in_median_pos
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_3_in_median_pos(
	.datain(fifo_small_fill_and_check_3_in_median_pos_data),
	.dataout(fill_and_check_3_in_median_pos_data),
	.enr(fill_and_check_3_in_median_pos_rd),
	.enw(fifo_small_fill_and_check_3_in_median_pos_wr),
	.empty(fill_and_check_3_in_median_pos_empty),
	.full(fifo_small_fill_and_check_3_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_3_in_second_median_value
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_3_in_second_median_value(
	.datain(fifo_small_fill_and_check_3_in_second_median_value_data),
	.dataout(fill_and_check_3_in_second_median_value_data),
	.enr(fill_and_check_3_in_second_median_value_rd),
	.enw(fifo_small_fill_and_check_3_in_second_median_value_wr),
	.empty(fill_and_check_3_in_second_median_value_empty),
	.full(fifo_small_fill_and_check_3_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor fill_and_check_3
fill_and_check actor_fill_and_check_3 (
	// Input Signal(s)
	.in_px(fill_and_check_3_in_px_data),
	.in_px_rd(fill_and_check_3_in_px_rd),
	.in_px_empty(fill_and_check_3_in_px_empty),
	.in_pivot(fill_and_check_3_in_pivot_data),
	.in_pivot_rd(fill_and_check_3_in_pivot_rd),
	.in_pivot_empty(fill_and_check_3_in_pivot_empty),
	.in_buff_size(fill_and_check_3_in_buff_size_data),
	.in_buff_size_rd(fill_and_check_3_in_buff_size_rd),
	.in_buff_size_empty(fill_and_check_3_in_buff_size_empty),
	.in_median_pos(fill_and_check_3_in_median_pos_data),
	.in_median_pos_rd(fill_and_check_3_in_median_pos_rd),
	.in_median_pos_empty(fill_and_check_3_in_median_pos_empty),
	.in_second_median_value(fill_and_check_3_in_second_median_value_data),
	.in_second_median_value_rd(fill_and_check_3_in_second_median_value_rd),
	.in_second_median_value_empty(fill_and_check_3_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(fill_and_check_3_out_px_data),
	.out_px_wr(fill_and_check_3_out_px_wr),
	.out_px_full(fill_and_check_3_out_px_full),
	.out_pivot(fill_and_check_3_out_pivot_data),
	.out_pivot_wr(fill_and_check_3_out_pivot_wr),
	.out_pivot_full(fill_and_check_3_out_pivot_full),
	.out_buff_size(fill_and_check_3_out_buff_size_data),
	.out_buff_size_wr(fill_and_check_3_out_buff_size_wr),
	.out_buff_size_full(fill_and_check_3_out_buff_size_full),
	.out_median_pos(fill_and_check_3_out_median_pos_data),
	.out_median_pos_wr(fill_and_check_3_out_median_pos_wr),
	.out_median_pos_full(fill_and_check_3_out_median_pos_full),
	.out_second_median_value(fill_and_check_3_out_second_median_value_data),
	.out_second_median_value_wr(fill_and_check_3_out_second_median_value_wr),
	.out_second_median_value_full(fill_and_check_3_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// fifo_small_fill_and_check_4_in_px
fifo_small #(
	.depth(64),
	.size(8)
) fifo_small_fill_and_check_4_in_px(
	.datain(fifo_small_fill_and_check_4_in_px_data),
	.dataout(fill_and_check_4_in_px_data),
	.enr(fill_and_check_4_in_px_rd),
	.enw(fifo_small_fill_and_check_4_in_px_wr),
	.empty(fill_and_check_4_in_px_empty),
	.full(fifo_small_fill_and_check_4_in_px_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_4_in_pivot
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_4_in_pivot(
	.datain(fifo_small_fill_and_check_4_in_pivot_data),
	.dataout(fill_and_check_4_in_pivot_data),
	.enr(fill_and_check_4_in_pivot_rd),
	.enw(fifo_small_fill_and_check_4_in_pivot_wr),
	.empty(fill_and_check_4_in_pivot_empty),
	.full(fifo_small_fill_and_check_4_in_pivot_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_4_in_buff_size
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_4_in_buff_size(
	.datain(fifo_small_fill_and_check_4_in_buff_size_data),
	.dataout(fill_and_check_4_in_buff_size_data),
	.enr(fill_and_check_4_in_buff_size_rd),
	.enw(fifo_small_fill_and_check_4_in_buff_size_wr),
	.empty(fill_and_check_4_in_buff_size_empty),
	.full(fifo_small_fill_and_check_4_in_buff_size_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_4_in_median_pos
fifo_small #(
	.depth(16),
	.size(11)
) fifo_small_fill_and_check_4_in_median_pos(
	.datain(fifo_small_fill_and_check_4_in_median_pos_data),
	.dataout(fill_and_check_4_in_median_pos_data),
	.enr(fill_and_check_4_in_median_pos_rd),
	.enw(fifo_small_fill_and_check_4_in_median_pos_wr),
	.empty(fill_and_check_4_in_median_pos_empty),
	.full(fifo_small_fill_and_check_4_in_median_pos_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);
// fifo_small_fill_and_check_4_in_second_median_value
fifo_small #(
	.depth(16),
	.size(8)
) fifo_small_fill_and_check_4_in_second_median_value(
	.datain(fifo_small_fill_and_check_4_in_second_median_value_data),
	.dataout(fill_and_check_4_in_second_median_value_data),
	.enr(fill_and_check_4_in_second_median_value_rd),
	.enw(fifo_small_fill_and_check_4_in_second_median_value_wr),
	.empty(fill_and_check_4_in_second_median_value_empty),
	.full(fifo_small_fill_and_check_4_in_second_median_value_full),
	
	// System Signal(s)
	.clk(clock),
	.rst(reset)
);

// actor fill_and_check_4
fill_and_check actor_fill_and_check_4 (
	// Input Signal(s)
	.in_px(fill_and_check_4_in_px_data),
	.in_px_rd(fill_and_check_4_in_px_rd),
	.in_px_empty(fill_and_check_4_in_px_empty),
	.in_pivot(fill_and_check_4_in_pivot_data),
	.in_pivot_rd(fill_and_check_4_in_pivot_rd),
	.in_pivot_empty(fill_and_check_4_in_pivot_empty),
	.in_buff_size(fill_and_check_4_in_buff_size_data),
	.in_buff_size_rd(fill_and_check_4_in_buff_size_rd),
	.in_buff_size_empty(fill_and_check_4_in_buff_size_empty),
	.in_median_pos(fill_and_check_4_in_median_pos_data),
	.in_median_pos_rd(fill_and_check_4_in_median_pos_rd),
	.in_median_pos_empty(fill_and_check_4_in_median_pos_empty),
	.in_second_median_value(fill_and_check_4_in_second_median_value_data),
	.in_second_median_value_rd(fill_and_check_4_in_second_median_value_rd),
	.in_second_median_value_empty(fill_and_check_4_in_second_median_value_empty)
	,
	
	// Output Signal(s)
	.out_px(fill_and_check_4_out_px_data),
	.out_px_wr(fill_and_check_4_out_px_wr),
	.out_px_full(fill_and_check_4_out_px_full),
	.out_pivot(fill_and_check_4_out_pivot_data),
	.out_pivot_wr(fill_and_check_4_out_pivot_wr),
	.out_pivot_full(fill_and_check_4_out_pivot_full),
	.out_buff_size(fill_and_check_4_out_buff_size_data),
	.out_buff_size_wr(fill_and_check_4_out_buff_size_wr),
	.out_buff_size_full(fill_and_check_4_out_buff_size_full),
	.out_median_pos(fill_and_check_4_out_median_pos_data),
	.out_median_pos_wr(fill_and_check_4_out_median_pos_wr),
	.out_median_pos_full(fill_and_check_4_out_median_pos_full),
	.out_second_median_value(fill_and_check_4_out_second_median_value_data),
	.out_second_median_value_wr(fill_and_check_4_out_second_median_value_wr),
	.out_second_median_value_full(fill_and_check_4_out_second_median_value_full)
		,
	
	// System Signal(s)
	.clock(clock),
	.reset(reset)
);


// Module(s) Assignments
assign fifo_small_fill_and_check_0_in_px_data = in_px_data;
assign fifo_small_fill_and_check_0_in_px_wr = in_px_wr;
assign in_px_full = fifo_small_fill_and_check_0_in_px_full;

assign fifo_small_fill_and_check_0_in_pivot_data = in_pivot_data;
assign fifo_small_fill_and_check_0_in_pivot_wr = in_pivot_wr;
assign in_pivot_full = fifo_small_fill_and_check_0_in_pivot_full;

assign fifo_small_fill_and_check_0_in_buff_size_data = in_buff_size_data;
assign fifo_small_fill_and_check_0_in_buff_size_wr = in_buff_size_wr;
assign in_buff_size_full = fifo_small_fill_and_check_0_in_buff_size_full;

assign fifo_small_fill_and_check_0_in_median_pos_data = in_median_pos_data;
assign fifo_small_fill_and_check_0_in_median_pos_wr = in_median_pos_wr;
assign in_median_pos_full = fifo_small_fill_and_check_0_in_median_pos_full;

assign fifo_small_fill_and_check_0_in_second_median_value_data = in_second_median_value_data;
assign fifo_small_fill_and_check_0_in_second_median_value_wr = in_second_median_value_wr;
assign in_second_median_value_full = fifo_small_fill_and_check_0_in_second_median_value_full;

assign fifo_small_fill_and_check_1_in_px_data = fill_and_check_0_out_px_data;
assign fifo_small_fill_and_check_1_in_px_wr = fill_and_check_0_out_px_wr;
assign fill_and_check_0_out_px_full = fifo_small_fill_and_check_1_in_px_full;

assign fifo_small_fill_and_check_1_in_pivot_data = fill_and_check_0_out_pivot_data;
assign fifo_small_fill_and_check_1_in_pivot_wr = fill_and_check_0_out_pivot_wr;
assign fill_and_check_0_out_pivot_full = fifo_small_fill_and_check_1_in_pivot_full;

assign fifo_small_fill_and_check_1_in_buff_size_data = fill_and_check_0_out_buff_size_data;
assign fifo_small_fill_and_check_1_in_buff_size_wr = fill_and_check_0_out_buff_size_wr;
assign fill_and_check_0_out_buff_size_full = fifo_small_fill_and_check_1_in_buff_size_full;

assign fifo_small_fill_and_check_1_in_median_pos_data = fill_and_check_0_out_median_pos_data;
assign fifo_small_fill_and_check_1_in_median_pos_wr = fill_and_check_0_out_median_pos_wr;
assign fill_and_check_0_out_median_pos_full = fifo_small_fill_and_check_1_in_median_pos_full;

assign fifo_small_fill_and_check_1_in_second_median_value_data = fill_and_check_0_out_second_median_value_data;
assign fifo_small_fill_and_check_1_in_second_median_value_wr = fill_and_check_0_out_second_median_value_wr;
assign fill_and_check_0_out_second_median_value_full = fifo_small_fill_and_check_1_in_second_median_value_full;

assign fifo_small_fill_and_check_2_in_px_data = fill_and_check_1_out_px_data;
assign fifo_small_fill_and_check_2_in_px_wr = fill_and_check_1_out_px_wr;
assign fill_and_check_1_out_px_full = fifo_small_fill_and_check_2_in_px_full;

assign fifo_small_fill_and_check_2_in_pivot_data = fill_and_check_1_out_pivot_data;
assign fifo_small_fill_and_check_2_in_pivot_wr = fill_and_check_1_out_pivot_wr;
assign fill_and_check_1_out_pivot_full = fifo_small_fill_and_check_2_in_pivot_full;

assign fifo_small_fill_and_check_2_in_buff_size_data = fill_and_check_1_out_buff_size_data;
assign fifo_small_fill_and_check_2_in_buff_size_wr = fill_and_check_1_out_buff_size_wr;
assign fill_and_check_1_out_buff_size_full = fifo_small_fill_and_check_2_in_buff_size_full;

assign fifo_small_fill_and_check_2_in_median_pos_data = fill_and_check_1_out_median_pos_data;
assign fifo_small_fill_and_check_2_in_median_pos_wr = fill_and_check_1_out_median_pos_wr;
assign fill_and_check_1_out_median_pos_full = fifo_small_fill_and_check_2_in_median_pos_full;

assign fifo_small_fill_and_check_2_in_second_median_value_data = fill_and_check_1_out_second_median_value_data;
assign fifo_small_fill_and_check_2_in_second_median_value_wr = fill_and_check_1_out_second_median_value_wr;
assign fill_and_check_1_out_second_median_value_full = fifo_small_fill_and_check_2_in_second_median_value_full;

assign fifo_small_fill_and_check_3_in_px_data = fill_and_check_2_out_px_data;
assign fifo_small_fill_and_check_3_in_px_wr = fill_and_check_2_out_px_wr;
assign fill_and_check_2_out_px_full = fifo_small_fill_and_check_3_in_px_full;

assign fifo_small_fill_and_check_3_in_pivot_data = fill_and_check_2_out_pivot_data;
assign fifo_small_fill_and_check_3_in_pivot_wr = fill_and_check_2_out_pivot_wr;
assign fill_and_check_2_out_pivot_full = fifo_small_fill_and_check_3_in_pivot_full;

assign fifo_small_fill_and_check_3_in_buff_size_data = fill_and_check_2_out_buff_size_data;
assign fifo_small_fill_and_check_3_in_buff_size_wr = fill_and_check_2_out_buff_size_wr;
assign fill_and_check_2_out_buff_size_full = fifo_small_fill_and_check_3_in_buff_size_full;

assign fifo_small_fill_and_check_3_in_median_pos_data = fill_and_check_2_out_median_pos_data;
assign fifo_small_fill_and_check_3_in_median_pos_wr = fill_and_check_2_out_median_pos_wr;
assign fill_and_check_2_out_median_pos_full = fifo_small_fill_and_check_3_in_median_pos_full;

assign fifo_small_fill_and_check_3_in_second_median_value_data = fill_and_check_2_out_second_median_value_data;
assign fifo_small_fill_and_check_3_in_second_median_value_wr = fill_and_check_2_out_second_median_value_wr;
assign fill_and_check_2_out_second_median_value_full = fifo_small_fill_and_check_3_in_second_median_value_full;

assign fifo_small_fill_and_check_4_in_px_data = fill_and_check_3_out_px_data;
assign fifo_small_fill_and_check_4_in_px_wr = fill_and_check_3_out_px_wr;
assign fill_and_check_3_out_px_full = fifo_small_fill_and_check_4_in_px_full;

assign fifo_small_fill_and_check_4_in_pivot_data = fill_and_check_3_out_pivot_data;
assign fifo_small_fill_and_check_4_in_pivot_wr = fill_and_check_3_out_pivot_wr;
assign fill_and_check_3_out_pivot_full = fifo_small_fill_and_check_4_in_pivot_full;

assign fifo_small_fill_and_check_4_in_buff_size_data = fill_and_check_3_out_buff_size_data;
assign fifo_small_fill_and_check_4_in_buff_size_wr = fill_and_check_3_out_buff_size_wr;
assign fill_and_check_3_out_buff_size_full = fifo_small_fill_and_check_4_in_buff_size_full;

assign fifo_small_fill_and_check_4_in_median_pos_data = fill_and_check_3_out_median_pos_data;
assign fifo_small_fill_and_check_4_in_median_pos_wr = fill_and_check_3_out_median_pos_wr;
assign fill_and_check_3_out_median_pos_full = fifo_small_fill_and_check_4_in_median_pos_full;

assign fifo_small_fill_and_check_4_in_second_median_value_data = fill_and_check_3_out_second_median_value_data;
assign fifo_small_fill_and_check_4_in_second_median_value_wr = fill_and_check_3_out_second_median_value_wr;
assign fill_and_check_3_out_second_median_value_full = fifo_small_fill_and_check_4_in_second_median_value_full;

assign out_px_data = fill_and_check_4_out_px_data;
assign out_px_wr = fill_and_check_4_out_px_wr;
assign fill_and_check_4_out_px_full = out_px_full;

assign out_buff_size_data = fill_and_check_4_out_buff_size_data;
assign out_buff_size_wr = fill_and_check_4_out_buff_size_wr;
assign fill_and_check_4_out_buff_size_full = out_buff_size_full;

assign out_pivot_data = fill_and_check_4_out_pivot_data;
assign out_pivot_wr = fill_and_check_4_out_pivot_wr;
assign fill_and_check_4_out_pivot_full = out_pivot_full;

assign out_median_pos_data = fill_and_check_4_out_median_pos_data;
assign out_median_pos_wr = fill_and_check_4_out_median_pos_wr;
assign fill_and_check_4_out_median_pos_full = out_median_pos_full;

assign out_second_median_value_data = fill_and_check_4_out_second_median_value_data;
assign out_second_median_value_wr = fill_and_check_4_out_second_median_value_wr;
assign fill_and_check_4_out_second_median_value_full = out_second_median_value_full;

endmodule
