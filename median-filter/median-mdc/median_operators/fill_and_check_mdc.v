`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



// receives an input stream from an external buffer, fill the inner buffers and check the median, if the median is found --> end 
module fill_and_check #(
       parameter MEDIAN_POS = 10'd512,
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
    
    output wire filling, fill_done, fill_last,// update_control_signals,
     
    /*
     * INPUT DATA: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
     */ 
    input wire [7:0] in_px, 
    	output wire in_px_rd,
    	input wire in_px_empty,		// not valid; assign valid = ~empty;
   	input wire in_px_valid,
	

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
        
    output reg [7:0] out_pivot,
    	output wire out_pivot_wr,
    	input wire out_pivot_full,
    
    output reg [BUFF_SIZE_BIT-1:0] out_buff_size,
    	output wire out_buff_size_wr,
    	input wire out_buff_size_full,
    	
    output reg [BUFF_SIZE_BIT-1:0] out_median_pos,
    	output wire out_median_pos_wr,
    	input wire out_median_pos_full,
    	
    output reg [7:0] out_second_median_value,
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
    
    reg [7:0] next_buffer [BUFF_SIZE-1:0];			// next buffer
    
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
        
    /*
     * CONTROL SIGNALS SEND LOGIC
     */ 
    wire sending;								// the logic is sending the output pixels, it is busy
    wire [BUFF_SIZE_BIT-1:0] send_count;		// counting the output pixels
    reg send_req;								// send request
    
   // assign update_control_signals = send_req;
    
    integer i;	// needed by the buffer registers

    
    
    
    /*
     * 	FILL BUFFERS
     */
    assign in_px_rd = ~fill_done & ~send_req;
  	//assign in_px_rd = (~fill_last) & (~fill_done);
    	
    fill_buffers #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT))
    	DUT_fill_buffers (
    	.clk(clock), .rst_n(reset),
 		
    	/*
    	 * INPUT DATA: in_px_delay, in_pivot_samp, in_buff_size
    	 */ 
		.in_px(in_px),
    	.in_px_empty(in_px_empty),
    	.in_px_rd(in_px_rd),	// read a new pixel when fill buffers is ready.
    	.in_px_valid(in_px_valid),	// read a new pixel when fill buffers is ready.
    
    	.pivot(in_pivot_samp),   
    	.in_buff_size(in_buff_size_samp),
  
    	/*
    	 * OUTPUT DATA: new_lower, new_larger, lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
    	 */ 
    	.new_lower(new_lower),	 	// new lower signal
    	.new_larger(new_larger),	// new larger signal
    	
    	.lower_size(lower_size), 	// output (sizes and "write pointers")
    	.equal_size(equal_size),
    	.larger_size(larger_size),

    	.max_lower(max_lower), .min_lower(min_lower),	// output of a register
    	.max_larger(max_larger), .min_larger(min_larger),	// output of a register
    
    	// INPUT CONTROL SIGNALS
    	.sending(sending),
    	.send_req(send_req),
    	.free(~send_req),
    	// OUTPUT CONTROL SIGNALS
    	.filling(filling),		// filling status
   		.fill_done(fill_done),	// all buffers are filled
   		.fill_last(fill_last)
    );
    
    // UPDATE BUFFERS
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
    next_logic #(.MEDIAN_POS(MEDIAN_POS), .BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT))
    	DUT_next_logic (

    	
    	/*
    	 * "CONTROL" INPUT DATA: lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
    	 */
   		.lower_size(lower_size),	// buffer sizes
    	.equal_size(equal_size),
    	.larger_size(larger_size),
    	
    	.max_lower(max_lower), .min_lower(min_lower), // min and max values
		.max_larger(max_larger), .min_larger(min_larger),  
    
    	/*
	 	 * 	"EXTERNAL" INPUT DATA: in_pivot_samp, in_median_pos_samp 
	 	 */
    	.in_pivot(in_pivot_samp),
    	.in_median_pos(in_median_pos_samp),
    
    	/*
     	 * OUTPUT DATA: next_pivot, next_buff_size, next_median_pos, next_second_median_value
     	 */
    	.next_pivot(next_pivot), 
    	.next_buff_size(next_buff_size),   
   		.next_median_pos(next_median_pos),
    	.next_second_median_value(next_second_median_value)
    );
    

			
	/*
	 * SEND LOGIC
	 */
	 
    always@(posedge clock, negedge reset)
    	if (reset == 1'b0)			// erase the next buffer
    		send_req <= 1'b0;
    	else send_req <= fill_done & ~sending;
    	
	//assign send_req = fill_done & (~sending);		// send a request if fill done and not already sending
	send_logic #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT))
		DUT_send_logic (
			
			.clk(clock), .rst_n(reset),
			
  			.send_buff_size(next_buff_size),	// output buffer size
  			.send_req(send_req),				// request
        	
  			.en_read(),
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
    		.sending(sending),			// the logic is sending
   			.send_count(send_count)		// the count of pixels sent
    );
	
	/*
	 * UPDATE THE NEXT BUFFER
	 */ 
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)			// erase the next buffer
			for (i=0; i<=BUFF_SIZE-1; i=i+1) next_buffer[i] <= 8'd0;		
		else if (sending == 1'b0) 	
			// if not sending, update next buffer
			if (send_req == 1'b1 & (lower_size > in_median_pos_samp))	// "assign" the lower buffer
				for (i=0; i<=BUFF_SIZE-1; i=i+1) next_buffer[i] <= lower_buffer[i];
			else if (send_req == 1'b1 & (lower_size + equal_size > in_median_pos_samp || equal_size == in_median_pos_samp))
				next_buffer[0] <= in_pivot_samp;  // then if the median has been found, it will be passed to the next block
			//for (i=1; i<=BUFF_SIZE-1; i=i+1)
			//next_buffer[i] <= 8'd0;	
			else if (send_req == 1'b1)									// "assign" the larger buffer
				for (i=0; i<=BUFF_SIZE-1; i=i+1) next_buffer[i] <= larger_buffer[i];

		// output signals
		assign out_px = next_buffer[send_count];
	
	/*
	 * UPDATE THE OUTPUT VALUES
	 */ 	
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)
			begin
				out_pivot <= 0;
				out_buff_size <= 0;
				out_median_pos <= 0;
				out_second_median_value <= 0;
				
			end
		else if (send_req == 1'b1) // if not sending can update output values buffer
			begin
				out_pivot <= next_pivot;
				out_buff_size <= next_buff_size;	
				out_median_pos <= next_median_pos;  
				out_second_median_value <= next_second_median_value;
			end

		


			
		

endmodule
