`timescale 1 ns / 1 ps
// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Test Bench module 
// Date: 2022/04/15 15:15:02
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
	
	parameter OUT_PX_MEDIAN_8BIT_FILE = "out_px_median_8bit_file.mem";
	parameter OUT_PX_MEDIAN_8BIT_SIZE = 64;
	
	// ----------------------------------------------------------------------------
	
	// multi_dataflow signals
	// ----------------------------------------------------------------------------
	reg start_feeding;
	reg [7 : 0] in_px_data;
	reg in_px_wr;
	wire in_px_full;
	reg [7:0] in_px_median_8bit_file_data [IN_PX_MEDIAN_8BIT_SIZE-1:0];
	integer in_px_i = 0;
	
	wire [7 : 0] out_px_data;
	wire out_px_wr;
	reg out_px_full;
	reg [7:0] out_px_median_8bit_file_data [OUT_PX_MEDIAN_8BIT_SIZE-1:0];
	integer out_px_i = 0;
	
	
	
	reg clock;
	reg reset;
	// ----------------------------------------------------------------------------

	// network input and output files
	// ----------------------------------------------------------------------------
	initial
	 	$readmemh(IN_PX_MEDIAN_8BIT_FILE, in_px_median_8bit_file_data);
	initial
		$readmemh(OUT_PX_MEDIAN_8BIT_FILE, out_px_median_8bit_file_data);
	// ----------------------------------------------------------------------------

	// dut
	// ----------------------------------------------------------------------------
	multi_dataflow dut (
		.in_px_data(in_px_data),
		.in_px_wr(in_px_wr),
		.in_px_full(in_px_full),
		
		.out_px_data(out_px_data),
		.out_px_wr(out_px_wr),
		.out_px_full(out_px_full),
		
		
				
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
				out_px_full = 1'b1;
	
		// initial reset
				reset = 1;
		#2
				reset = 0;
		#100
				reset = 1;
		#100
	
		// network inputs (output side)
				out_px_full = 1'b1;
				
		 		// executing median_8bit
		 		ID = 8'd1;
	start_feeding = 1;
	while(in_px_i != IN_PX_MEDIAN_8BIT_SIZE)
		#10;
	start_feeding = 0;
	in_px_data = 0;
	in_px_wr  = 1'b0;
	in_px_i = 0;
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
	// ----------------------------------------------------------------------------

endmodule
