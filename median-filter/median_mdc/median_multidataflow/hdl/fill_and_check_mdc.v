`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module fill_and_check #(
		parameter MEDIAN_POS = 11'd512,
		BUFF_SIZE = 11'd1024,
		//BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1'b1,
		BUFF_SIZE_BIT = 16,
		DEFAULT_PIVOT = 8'd127
		)(

		/*
		 * SYS SIGNALS
		 */
		input wire clock, reset,
    
		/*
		 * OUTPUT CONTROL SIGNALS
		 */
    	input wire control_sampled,
		output wire filling,// update_control_signals,
     
		/*
		 * INPUT DATA: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
		 */ 
		input wire [7:0] in_px, 
		output wire in_px_rd,
		input wire in_px_empty,		// not valid; assign valid = ~empty;
		//input wire in_px_valid,
	

		input wire [7:0] in_pivot_samp,
		input wire [BUFF_SIZE_BIT-1:0] in_buff_size_samp,
		input wire [BUFF_SIZE_BIT-1:0] in_median_pos_samp,
		input wire [7:0] in_second_median_value_samp,
    
		/*
		 * OUTPUT DATA: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
		 */
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
	//wire fill_last;
	
	/*
	 * BUFFER CONTROL SIGNALS
	 */ 
	wire new_lower, new_larger;										// new px received
	wire [BUFF_SIZE_BIT-1:0] lower_size, equal_size, larger_size;	// sizes

	/*
	 * BUFFERS
	 */ 
	reg [7:0] lower_buffer  [BUFF_SIZE-1:0];    	// lower buffer
	reg [7:0] larger_buffer [BUFF_SIZE-1:0];		// larger buffer
    
	reg [8:0] next_buffer   [BUFF_SIZE-1:0];		// next buffer
    
	/*
	 * DATA CONTROL SIGNALS
	 */ 
	wire [7:0] max_lower, min_lower, max_larger, min_larger;
    
	/*
	 * NEXT DATA VALUES
	 */ 
	wire [7:0] next_pivot;
	wire [BUFF_SIZE_BIT-1:0] next_buff_size;
	wire [BUFF_SIZE_BIT-1:0] next_median_pos;
	wire [7:0] next_second_median_value;
    
	parameter LOW=2'b00, EQ0=2'b01, EQ1=2'b10, LARG=2'b11;
	wire [1:0] _case;   // case of the next data
    
        
	/*
	 * CONTROL SIGNALS SEND LOGIC
	 */ 
	wire sending;								// the logic is sending the output pixels, it is busy
	wire up_next;
    
	wire [BUFF_SIZE_BIT-1:0] px_send_count;		// counting the output pixels
	//reg send_req;								// send request
    
    
	integer i;	// needed by the buffer registers

    
    
    
	/*
	 * 	FILL BUFFERS
	 */
	//assign in_px_rd = ~fill_done & ~en_buff_next;
	//assign in_px_rd = ~fill_done;

	//assign in_px_rd = (~fill_last) & (~fill_done);
    
	fill_buffers #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT)) DUT_fill_buffers
		(
			.clk(clock),
			.rst_n(reset),

			/*
			 * INPUT DATA: in_px, in_pivot_samp, in_buff_size
			 */
			.in_px(in_px), // input pixel
			.in_px_empty(in_px_empty), // control signals from fifo 
			.in_px_rd(in_px_rd), // read request 
			// input wire in_px_valid,

			.in_pivot_samp(in_pivot_samp), // input pivot sampled
			.in_buff_size_samp(in_buff_size_samp), // in buff size sampled

			/*
			 * OUTPUT DATA: new_lower, new_larger, lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
			 */
			.new_lower(new_lower), .new_larger(new_larger), //new_equal,

			.lower_size(lower_size), // output buffer sizes
			.equal_size(equal_size),
			.larger_size(larger_size),

			.max_lower(max_lower), .min_lower(min_lower), // output of a register
			.max_larger(max_larger), .min_larger(min_larger), // output of a register

			// CONTROL SIGNALS
			.sending(sending), // if sending --> wait
			.up_next(up_next), // update the next logic and send next data to next actor
			.control_sampled(control_sampled), // the input control data are sampled
			.filling(filling) // the fill logic is filling
		);
    
	// UPDATE TMP BUFFERS 
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)
			for (i=0; i<=BUFF_SIZE-1; i=i+1)
			begin
				lower_buffer[i] <= 8'dx; 
				// equal_buffer[i] <= {BUFF_SIZE_BIT {1'bx}}; // dummy buffer
				larger_buffer[i] <= 8'dx; 
			end 
		else if (new_lower == 1'b1)
			lower_buffer[lower_size] <= in_px;
		else if (new_larger == 1'b1)
			larger_buffer[larger_size] <= in_px;
    
    
		/*
			 * 	NEXT LOGIC
			 */    
	next_logic #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT),
			.LOW(LOW), .EQ0(EQ0), .EQ1(EQ1), .LARG(LARG)
		) DUT_next_logic (
			.clk(clock), 
			.rst_n(reset),
        
			._case(_case),
			.up_next(up_next),     // update next
			/*
			 * "CONTROL" INPUT DATA: lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
			 */
			.lower_size(lower_size),    // buffer sizes
			.equal_size(equal_size),
			.larger_size(larger_size),
        
			.max_lower({1'b0, max_lower}), .min_lower({1'b0, min_lower}), // output of a register
			.max_larger({1'b0, max_larger}), .min_larger({1'b0, min_larger}), // output of a register
        
			/*
			 *     "EXTERNAL" INPUT DATA: in_pivot_samp, in_median_pos_samp 
			 */
			.in_buff_size_samp(in_buff_size_samp),
			.in_pivot_samp({1'b0, in_pivot_samp}),                        
			.in_median_pos_samp(in_median_pos_samp),    
			.in_second_median_value_samp({1'b0, in_second_median_value_samp}),    
    
			/*
			 * OUTPUT DATA: next_pivot, next_buff_size, next_median_pos, next_second_median_value
			 */
			.next_pivot(next_pivot),
			.next_buff_size(next_buff_size),   
			.next_median_pos(next_median_pos),
			.next_second_median_value(next_second_median_value)
        
		);
    
	// UPDATE NEXT BUFFER
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)			// erase the next buffer
			for (i=0; i<=BUFF_SIZE-1'b1; i=i+1'b1) 
				next_buffer[i] <= 9'dx;
		else if (up_next == 1'b1) 	
			if (_case==LOW)
				for (i=0; i<=BUFF_SIZE-1'b1; i=i+1'b1) 
					next_buffer[i] <= {1'b0, lower_buffer[i]};
			else if (_case==LARG)								// "assign" the larger buffer
				for (i=0; i<=BUFF_SIZE-1'b1; i=i+1'b1) 
					next_buffer[i] <= {1'b0, larger_buffer[i]};
			else if (_case==EQ1)
				next_buffer[0] <= {1'b0, in_pivot_samp};  // then if the median has been already found, it will be passed to the next block
			else if (in_median_pos_samp == 0)   // _case==EQ0
				next_buffer[0] <= (in_pivot_samp + in_second_median_value_samp) >> 1;
			else 
				next_buffer[0] <= (in_pivot_samp + max_lower) >> 1;    

			
				/*
				 * SEND LOGIC
				 */
	 
	send_logic #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT)) DUT_send_logic (
			.clk(clock), .rst_n(reset),

			.send_buff_size(next_buff_size), // output buffer size
			.up_next(up_next), // request


			/*
			 * INPUT CONTROL FULL from FIFO
			 */
        
			.send_px_full(out_px_full),
			.send_pivot_full(out_pivot_full),
			.send_buff_size_full(out_buff_size_full),    
			.send_median_pos_full(out_median_pos_full),    
			.send_second_median_value_full(out_second_median_value_full),

			/*
			 * OTUPUT CONTROL WR to FIFO
			 */
			.send_px_wr(out_px_wr),
			.send_pivot_wr(out_pivot_wr),
			.send_buff_size_wr(out_buff_size_wr),
			.send_median_pos_wr(out_median_pos_wr), 
			.send_second_median_value_wr(out_second_median_value_wr), 

			/*
			 * CONTROL SIGNALS
			 */
			.sending(sending),
			.px_send_count(px_send_count)
		);
    	
	// output signals
	assign out_px = next_buffer[px_send_count][7:0];
	assign out_pivot = next_pivot;
	assign out_buff_size = next_buff_size;
	assign out_median_pos = next_median_pos;
	assign out_second_median_value = next_second_median_value;		

endmodule


//module send_req_gen (
//		input wire clk,
//		input wire rst_n,
    	
//		input wire fill_done,
//		input wire sending,
		
//		output wire send_req
//		);
		
//	parameter IDLE=2'b00, WAIT=2'b01, SEND_REQ=2'b11;
	
//	reg [1:0] state, next_state;
	
//	always@(posedge clk, negedge rst_n)
//		if (rst_n == 1'b0)
//			state <= IDLE;
//		else 
//			state <= next_state;
		
	
//		/*
//			 * NEXT LOGIC
//			 */
//	always@(state, fill_done, sending)
//		case(state)
//			IDLE: if(fill_done == 1'b1 & sending == 1'b0) next_state = SEND_REQ;
//				else next_state = IDLE;
//				//else next_state = WAIT;
//			SEND_REQ: if(sending == 1'b0) next_state = SEND_REQ;
//				else next_state = IDLE;
//		endcase
		
	
//		/*
//		 * OUTPUT LOGIC
//		 */
	
//	assign send_req = &state;
	
//	//assign en_read = en_size_buff_samp;
//endmodule



