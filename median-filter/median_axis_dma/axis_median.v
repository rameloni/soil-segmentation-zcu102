`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Axis median top module 
module axis_median #( parameter C_AXIS_TDATA_WIDTH = 32)
		(
		// User inputs
		
		// User outputs
		
		/*
		 * AXIS slave interface ( input data )
		 */
		input  wire                   s00_axis_aclk,
		input  wire                   s00_axis_aresetn,
		input  wire [C_AXIS_TDATA_WIDTH-1:0]  s00_axis_tdata, // input data
		input  wire                   s00_axis_tvalid,        // input data valid 
		output wire                   s00_axis_tready,        // slave ready
		// input  wire                s00_axis_tlast,	
		
		/*
		 * Other AXIS slaves
		 */
		// input  wire 					s0i_axis_aclk,
		// input  wire 					s0i_axis_aresetn,
		// input  wire [ C_AXIS_TDATA_WIDTH -1:0] s0i_axis_tdata, // input data
		// input  wire 					s0i_axis_tvalid,	      // input data valid
		// output wire 					s0i_axis_tready, 		  // slave ready
		
		/*
		 * AXIS master interface ( output data )
		 */
		input  wire                   m00_axis_aclk,    
		input  wire                   m00_axis_aresetn,
		output wire [C_AXIS_TDATA_WIDTH-1:0]  m00_axis_tdata, // output data
		output wire                   m00_axis_tvalid,        // output data valid
		input  wire                   m00_axis_tready,        
		output wire                   m00_axis_tlast          // data last signal
		
		/*
		 * Other AXIS masters
		 */
//		input  wire                   m00_axis_aclk,    
//		input  wire                   m00_axis_aresetn,
//		output wire [C_AXIS_TDATA_WIDTH-1:0]  m00_axis_tdata, // output data
//		output wire                   m00_axis_tvalid,        // output data valid
//		input  wire                   m00_axis_tready,        
//		output wire                   m00_axis_tlast          // data last signal
		);
	
	// Signals
	wire [7:0] in_px_data;
	wire in_px_wr;
	wire in_px_full;
	
	wire [7:0] out_px_data;
	wire out_px_wr;
	wire out_px_full;
	
	wire [7:0] out00_fifo_data;
	wire out00_fifo_empty;
	 
	// External inputs ( switches , pushbuttons etc .)
	
	
	// Input slave logic
	
	assign in_px_data = s00_axis_tdata[7:0];
	assign in_px_wr = s00_axis_tvalid;
	assign s00_axis_tready = ~in_px_full;
	
	// Accelerator
	multi_dataflow DUT_median_multi_dataflow (
			// Input(s)
			.in_px_data(in_px_data),
			.in_px_wr(in_px_wr),
			.in_px_full(in_px_full),
	
			// Output(s)
			.out_px_data(out_px_data),
			.out_px_wr(out_px_wr),
			.out_px_full(out_px_full),
	
			// Dynamic Parameter(s)
	
			// Monitoring
	
			// Configuration ID
	
	
			// System Signal(s)		
			.clock(s00_axis_aclk),
			.reset(s00_axis_aresetn)
			);	

	
	// Output master logic
	fifo_small #(.depth(1024), .size(8)) DUT_fifo_small_out00(
			.full(out_px_full),
			.datain(out_px_data),
			.enw(out_px_wr),
			
			//valid,	// not empty 
			.empty(out00_fifo_empty),
			.dataout(out00_fifo_data),
			.enr(m00_axis_tready),
			
			.clk(s00_axis_aclk),
			.rst(s00_axis_aresetn)
		);	
	assign m00_axis_tdata = {{C_AXIS_TDATA_WIDTH-8{1'b0}}, out00_fifo_data};
	assign m00_axis_tvalid = ~out00_fifo_empty & m00_axis_tready;
	
	// tlast logic 
	wire valid_first, done;
	wire computing;
    reg  [C_AXIS_TDATA_WIDTH-8-1:0] threshold;		// threshold counter
    wire [C_AXIS_TDATA_WIDTH-8-1:0] px_send_count;		// threshold counter
    wire restart_count;
    wire count_zero;
    
    // THRESHOLD REGISTER
    always@(posedge s00_axis_aclk, negedge s00_axis_aresetn)
    	if(s00_axis_aresetn == 1'b0)
    		threshold <= 0;
    	else if (~computing & valid_first)
    		threshold <= s00_axis_tdata[C_AXIS_TDATA_WIDTH-1:8];    
    	
	fsm_tlast DUT_fsm_tlast(
			.clk(s00_axis_aclk), .rst_n(s00_axis_aresetn),
		
			.valid_first(valid_first),
			.done(done),
			.computing(computing)
		);
		
	assign en_px_send_count = m00_axis_tvalid;
	assign restart_count = done;
	assign done = (px_send_count == threshold-1'b1) & en_px_send_count;
	assign count_zero = (px_send_count == 0);
	assign valid_first = count_zero & s00_axis_tvalid & s00_axis_tready;
	
	counter #(.SIZE_BIT(C_AXIS_TDATA_WIDTH-8)) counter_send_pixels (
			.clk(s00_axis_aclk), .rst_n(s00_axis_aresetn),
			.en_count(m00_axis_tvalid), 
			.count(px_send_count),
			.restart(restart_count)
		);
		
	assign m00_axis_tlast = done;
	
	
	// External outputs ( leds etc .)
endmodule



module fsm_tlast (
		input wire clk, rst_n,
		
		input wire valid_first,
		output wire computing,
		input wire done
		);
	parameter IDLE = 1'b0, COMP = 1'b1;
	
	reg state, next_state;
	
	always@(posedge clk, negedge rst_n)
		if(rst_n == 1'b0)
			state <= IDLE;
		else
			state <= next_state;
		
	always@(state, valid_first, done)
		case(state)
			IDLE: next_state = (valid_first == 1'b1) ? COMP : IDLE;
			COMP: next_state = (done == 1'b1) ? IDLE : COMP;
			default: next_state = IDLE;
		endcase
		
	assign computing = state;
	
endmodule

/*
 * 1. Sample s00_axis_tdata[C_AXIS_TDATA_WIDTH-1:8] of the first pixel, it is the expected number of output pixels. In other words: the threshold
 * 2. Update the counter for each output pixel
 * 3. Raise the tlast signal once the count == s00_axis_tdata[C_AXIS_TDATA_WIDTH-1:8];
 */ 

