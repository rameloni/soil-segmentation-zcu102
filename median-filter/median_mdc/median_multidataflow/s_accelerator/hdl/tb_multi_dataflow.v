`timescale 1 ns / 1 ps
// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Test Bench module 
// Date: 2022/03/30 16:12:02
//
// Please note that the testbench manages only common signals to dataflows
// - clock system signals
// - reset system signals
// - dataflow communication signals
//
// ----------------------------------------------------------------------------

module tb_multi_dataflow;

	// test bench parameters
	// ----------------------------------------------------------------------------
	parameter CLOCK_PERIOD = 10;
	
	parameter IN_PX_MEDIAN_8BIT_FILE = "in_px_median_8bit_file.mem";
	parameter IN_PX_MEDIAN_8BIT_SIZE = 64;
	parameter IN_PIVOT_MEDIAN_8BIT_FILE = "in_pivot_median_8bit_file.mem";
	parameter IN_PIVOT_MEDIAN_8BIT_SIZE = 64;
	parameter IN_BUFF_SIZE_MEDIAN_8BIT_FILE = "in_buff_size_median_8bit_file.mem";
	parameter IN_BUFF_SIZE_MEDIAN_8BIT_SIZE = 64;
	parameter IN_MEDIAN_POS_MEDIAN_8BIT_FILE = "in_median_pos_median_8bit_file.mem";
	parameter IN_MEDIAN_POS_MEDIAN_8BIT_SIZE = 64;
	parameter IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_FILE = "in_second_median_value_median_8bit_file.mem";
	parameter IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE = 64;
	
	parameter OUT_PX_MEDIAN_8BIT_FILE = "out_px_median_8bit_file.mem";
	parameter OUT_PX_MEDIAN_8BIT_SIZE = 64;
	parameter OUT_PIVOT_MEDIAN_8BIT_FILE = "out_pivot_median_8bit_file.mem";
	parameter OUT_PIVOT_MEDIAN_8BIT_SIZE = 64;
	parameter OUT_BUFF_SIZE_MEDIAN_8BIT_FILE = "out_buff_size_median_8bit_file.mem";
	parameter OUT_BUFF_SIZE_MEDIAN_8BIT_SIZE = 64;
	parameter OUT_MEDIAN_POS_MEDIAN_8BIT_FILE = "out_median_pos_median_8bit_file.mem";
	parameter OUT_MEDIAN_POS_MEDIAN_8BIT_SIZE = 64;
	parameter OUT_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_FILE = "out_second_median_value_median_8bit_file.mem";
	parameter OUT_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE = 64;
	
	// ----------------------------------------------------------------------------
	
	// multi_dataflow signals
	// ----------------------------------------------------------------------------
	reg start_feeding;
	reg [7 : 0] in_px_data;
	reg in_px_wr;
	wire in_px_full;
	reg [7:0] in_px_median_8bit_file_data [IN_PX_MEDIAN_8BIT_SIZE-1:0];
	integer in_px_i = 0;
	reg [7 : 0] in_pivot_data;
	reg in_pivot_wr;
	wire in_pivot_full;
	reg [7:0] in_pivot_median_8bit_file_data [IN_PIVOT_MEDIAN_8BIT_SIZE-1:0];
	integer in_pivot_i = 0;
	reg [10 : 0] in_buff_size_data;
	reg in_buff_size_wr;
	wire in_buff_size_full;
	reg [10:0] in_buff_size_median_8bit_file_data [IN_BUFF_SIZE_MEDIAN_8BIT_SIZE-1:0];
	integer in_buff_size_i = 0;
	reg [10 : 0] in_median_pos_data;
	reg in_median_pos_wr;
	wire in_median_pos_full;
	reg [10:0] in_median_pos_median_8bit_file_data [IN_MEDIAN_POS_MEDIAN_8BIT_SIZE-1:0];
	integer in_median_pos_i = 0;
	reg [7 : 0] in_second_median_value_data;
	reg in_second_median_value_wr;
	wire in_second_median_value_full;
	reg [7:0] in_second_median_value_median_8bit_file_data [IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE-1:0];
	integer in_second_median_value_i = 0;
	
	wire [7 : 0] out_px_data;
	wire out_px_wr;
	reg out_px_full;
	reg [7:0] out_px_median_8bit_file_data [OUT_PX_MEDIAN_8BIT_SIZE-1:0];
	integer out_px_i = 0;
	wire [7 : 0] out_pivot_data;
	wire out_pivot_wr;
	reg out_pivot_full;
	reg [7:0] out_pivot_median_8bit_file_data [OUT_PIVOT_MEDIAN_8BIT_SIZE-1:0];
	integer out_pivot_i = 0;
	wire [10 : 0] out_buff_size_data;
	wire out_buff_size_wr;
	reg out_buff_size_full;
	reg [10:0] out_buff_size_median_8bit_file_data [OUT_BUFF_SIZE_MEDIAN_8BIT_SIZE-1:0];
	integer out_buff_size_i = 0;
	wire [10 : 0] out_median_pos_data;
	wire out_median_pos_wr;
	reg out_median_pos_full;
	reg [10:0] out_median_pos_median_8bit_file_data [OUT_MEDIAN_POS_MEDIAN_8BIT_SIZE-1:0];
	integer out_median_pos_i = 0;
	wire [7 : 0] out_second_median_value_data;
	wire out_second_median_value_wr;
	reg out_second_median_value_full;
	reg [7:0] out_second_median_value_median_8bit_file_data [OUT_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE-1:0];
	integer out_second_median_value_i = 0;
	
	
	
	reg clock;
	reg reset;
	// ----------------------------------------------------------------------------

	// network input and output files
	// ----------------------------------------------------------------------------
	initial
	 	$readmemh(IN_PX_MEDIAN_8BIT_FILE, in_px_median_8bit_file_data);
	initial
	 	$readmemh(IN_PIVOT_MEDIAN_8BIT_FILE, in_pivot_median_8bit_file_data);
	initial
	 	$readmemh(IN_BUFF_SIZE_MEDIAN_8BIT_FILE, in_buff_size_median_8bit_file_data);
	initial
	 	$readmemh(IN_MEDIAN_POS_MEDIAN_8BIT_FILE, in_median_pos_median_8bit_file_data);
	initial
	 	$readmemh(IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_FILE, in_second_median_value_median_8bit_file_data);
	initial
		$readmemh(OUT_PX_MEDIAN_8BIT_FILE, out_px_median_8bit_file_data);
	initial
		$readmemh(OUT_PIVOT_MEDIAN_8BIT_FILE, out_pivot_median_8bit_file_data);
	initial
		$readmemh(OUT_BUFF_SIZE_MEDIAN_8BIT_FILE, out_buff_size_median_8bit_file_data);
	initial
		$readmemh(OUT_MEDIAN_POS_MEDIAN_8BIT_FILE, out_median_pos_median_8bit_file_data);
	initial
		$readmemh(OUT_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_FILE, out_second_median_value_median_8bit_file_data);
	// ----------------------------------------------------------------------------

	// dut
	// ----------------------------------------------------------------------------
	multi_dataflow dut (
		.in_px_data(in_px_data),
		.in_px_wr(in_px_wr),
		.in_px_full(in_px_full),
		
		.in_pivot_data(in_pivot_data),
		.in_pivot_wr(in_pivot_wr),
		.in_pivot_full(in_pivot_full),
		
		.in_buff_size_data(in_buff_size_data),
		.in_buff_size_wr(in_buff_size_wr),
		.in_buff_size_full(in_buff_size_full),
		
		.in_median_pos_data(in_median_pos_data),
		.in_median_pos_wr(in_median_pos_wr),
		.in_median_pos_full(in_median_pos_full),
		
		.in_second_median_value_data(in_second_median_value_data),
		.in_second_median_value_wr(in_second_median_value_wr),
		.in_second_median_value_full(in_second_median_value_full),
		
		.out_px_data(out_px_data),
		.out_px_wr(out_px_wr),
		.out_px_full(out_px_full),
		.out_pivot_data(out_pivot_data),
		.out_pivot_wr(out_pivot_wr),
		.out_pivot_full(out_pivot_full),
		.out_buff_size_data(out_buff_size_data),
		.out_buff_size_wr(out_buff_size_wr),
		.out_buff_size_full(out_buff_size_full),
		.out_median_pos_data(out_median_pos_data),
		.out_median_pos_wr(out_median_pos_wr),
		.out_median_pos_full(out_median_pos_full),
		.out_second_median_value_data(out_second_median_value_data),
		.out_second_median_value_wr(out_second_median_value_wr),
		.out_second_median_value_full(out_second_median_value_full),
		
		
				
		.clock(clock),
		.reset(reset)
	);	
	// ----------------------------------------------------------------------------

	// clocks
	// ----------------------------------------------------------------------------
	always #(CLOCK_PERIOD/2)
		clock = ~clock;
	// ----------------------------------------------------------------------------

	// signals evolution
	// ----------------------------------------------------------------------------
	initial
	begin
		// feeding flag initialization
		start_feeding = 0;
		
		
	
		// clocks initialization
			clock = 0;
	
		// network signals initialization
				in_px_data = 0;
							in_px_wr  = 1'b0;
				in_pivot_data = 0;
							in_pivot_wr  = 1'b0;
				in_buff_size_data = 0;
							in_buff_size_wr  = 1'b0;
				in_median_pos_data = 0;
							in_median_pos_wr  = 1'b0;
				in_second_median_value_data = 0;
							in_second_median_value_wr  = 1'b0;
				out_px_full = 1'b1;
				out_pivot_full = 1'b1;
				out_buff_size_full = 1'b1;
				out_median_pos_full = 1'b1;
				out_second_median_value_full = 1'b1;
	
		// initial reset
				reset = 1;
		#2
				reset = 0;
		#100
				reset = 1;
		#100
	
		// network inputs (output side)
				out_px_full = 1'b1;
				out_pivot_full = 1'b1;
				out_buff_size_full = 1'b1;
				out_median_pos_full = 1'b1;
				out_second_median_value_full = 1'b1;
				
		 		// executing median_8bit
		 		ID = 8'd1;
	start_feeding = 1;
	while(in_px_i != IN_PX_MEDIAN_8BIT_SIZE)
		#10;
	while(in_pivot_i != IN_PIVOT_MEDIAN_8BIT_SIZE)
		#10;
	while(in_buff_size_i != IN_BUFF_SIZE_MEDIAN_8BIT_SIZE)
		#10;
	while(in_median_pos_i != IN_MEDIAN_POS_MEDIAN_8BIT_SIZE)
		#10;
	while(in_second_median_value_i != IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE)
		#10;
	start_feeding = 0;
	in_px_data = 0;
	in_px_wr  = 1'b0;
	in_px_i = 0;
	in_pivot_data = 0;
	in_pivot_wr  = 1'b0;
	in_pivot_i = 0;
	in_buff_size_data = 0;
	in_buff_size_wr  = 1'b0;
	in_buff_size_i = 0;
	in_median_pos_data = 0;
	in_median_pos_wr  = 1'b0;
	in_median_pos_i = 0;
	in_second_median_value_data = 0;
	in_second_median_value_wr  = 1'b0;
	in_second_median_value_i = 0;
	#1000
	
		$stop;
	end
	// ----------------------------------------------------------------------------

	// input feeding
	// ----------------------------------------------------------------------------
	always@(*)
		if(start_feeding && ID == 1)
	 			begin
			while(in_px_i < IN_PX_MEDIAN_8BIT_SIZE)
			begin
				#10
			 			if(in_px_full == 1)
			 			begin
							in_px_data = in_px_median_8bit_file_data[in_px_i];
							in_px_wr  = 1'b1;
					in_px_i = in_px_i + 1;
				end
				else
				begin
							in_px_data = 0;
							in_px_wr  = 1'b0;
				end
			end
			#10
					in_px_data = 0;
					in_px_wr  = 1'b0;
				end
	always@(*)
		if(start_feeding && ID == 1)
	 			begin
			while(in_pivot_i < IN_PIVOT_MEDIAN_8BIT_SIZE)
			begin
				#10
			 			if(in_pivot_full == 1)
			 			begin
							in_pivot_data = in_pivot_median_8bit_file_data[in_pivot_i];
							in_pivot_wr  = 1'b1;
					in_pivot_i = in_pivot_i + 1;
				end
				else
				begin
							in_pivot_data = 0;
							in_pivot_wr  = 1'b0;
				end
			end
			#10
					in_pivot_data = 0;
					in_pivot_wr  = 1'b0;
				end
	always@(*)
		if(start_feeding && ID == 1)
	 			begin
			while(in_buff_size_i < IN_BUFF_SIZE_MEDIAN_8BIT_SIZE)
			begin
				#10
			 			if(in_buff_size_full == 1)
			 			begin
							in_buff_size_data = in_buff_size_median_8bit_file_data[in_buff_size_i];
							in_buff_size_wr  = 1'b1;
					in_buff_size_i = in_buff_size_i + 1;
				end
				else
				begin
							in_buff_size_data = 0;
							in_buff_size_wr  = 1'b0;
				end
			end
			#10
					in_buff_size_data = 0;
					in_buff_size_wr  = 1'b0;
				end
	always@(*)
		if(start_feeding && ID == 1)
	 			begin
			while(in_median_pos_i < IN_MEDIAN_POS_MEDIAN_8BIT_SIZE)
			begin
				#10
			 			if(in_median_pos_full == 1)
			 			begin
							in_median_pos_data = in_median_pos_median_8bit_file_data[in_median_pos_i];
							in_median_pos_wr  = 1'b1;
					in_median_pos_i = in_median_pos_i + 1;
				end
				else
				begin
							in_median_pos_data = 0;
							in_median_pos_wr  = 1'b0;
				end
			end
			#10
					in_median_pos_data = 0;
					in_median_pos_wr  = 1'b0;
				end
	always@(*)
		if(start_feeding && ID == 1)
	 			begin
			while(in_second_median_value_i < IN_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE)
			begin
				#10
			 			if(in_second_median_value_full == 1)
			 			begin
							in_second_median_value_data = in_second_median_value_median_8bit_file_data[in_second_median_value_i];
							in_second_median_value_wr  = 1'b1;
					in_second_median_value_i = in_second_median_value_i + 1;
				end
				else
				begin
							in_second_median_value_data = 0;
							in_second_median_value_wr  = 1'b0;
				end
			end
			#10
					in_second_median_value_data = 0;
					in_second_median_value_wr  = 1'b0;
				end
	// ----------------------------------------------------------------------------

	// output check
	// ----------------------------------------------------------------------------
	always@(posedge clock)
				if(ID == 1)
					begin
					if(out_px_wr == 1)
						begin	
						if(out_px_data != out_px_median_8bit_file_data[out_px_i])
							$display("Error for config %d on output %d: obtained %d, expected %d", 1, out_px_i, out_px_data, out_px_median_8bit_file_data[out_px_i]);
						out_px_i = out_px_i + 1;
						end
									if(out_px_i == OUT_PX_MEDIAN_8BIT_SIZE)
						out_px_i = 0;
					end
	always@(posedge clock)
				if(ID == 1)
					begin
					if(out_pivot_wr == 1)
						begin	
						if(out_pivot_data != out_pivot_median_8bit_file_data[out_pivot_i])
							$display("Error for config %d on output %d: obtained %d, expected %d", 1, out_pivot_i, out_pivot_data, out_pivot_median_8bit_file_data[out_pivot_i]);
						out_pivot_i = out_pivot_i + 1;
						end
									if(out_pivot_i == OUT_PIVOT_MEDIAN_8BIT_SIZE)
						out_pivot_i = 0;
					end
	always@(posedge clock)
				if(ID == 1)
					begin
					if(out_buff_size_wr == 1)
						begin	
						if(out_buff_size_data != out_buff_size_median_8bit_file_data[out_buff_size_i])
							$display("Error for config %d on output %d: obtained %d, expected %d", 1, out_buff_size_i, out_buff_size_data, out_buff_size_median_8bit_file_data[out_buff_size_i]);
						out_buff_size_i = out_buff_size_i + 1;
						end
									if(out_buff_size_i == OUT_BUFF_SIZE_MEDIAN_8BIT_SIZE)
						out_buff_size_i = 0;
					end
	always@(posedge clock)
				if(ID == 1)
					begin
					if(out_median_pos_wr == 1)
						begin	
						if(out_median_pos_data != out_median_pos_median_8bit_file_data[out_median_pos_i])
							$display("Error for config %d on output %d: obtained %d, expected %d", 1, out_median_pos_i, out_median_pos_data, out_median_pos_median_8bit_file_data[out_median_pos_i]);
						out_median_pos_i = out_median_pos_i + 1;
						end
									if(out_median_pos_i == OUT_MEDIAN_POS_MEDIAN_8BIT_SIZE)
						out_median_pos_i = 0;
					end
	always@(posedge clock)
				if(ID == 1)
					begin
					if(out_second_median_value_wr == 1)
						begin	
						if(out_second_median_value_data != out_second_median_value_median_8bit_file_data[out_second_median_value_i])
							$display("Error for config %d on output %d: obtained %d, expected %d", 1, out_second_median_value_i, out_second_median_value_data, out_second_median_value_median_8bit_file_data[out_second_median_value_i]);
						out_second_median_value_i = out_second_median_value_i + 1;
						end
									if(out_second_median_value_i == OUT_SECOND_MEDIAN_VALUE_MEDIAN_8BIT_SIZE)
						out_second_median_value_i = 0;
					end
	// ----------------------------------------------------------------------------

endmodule
