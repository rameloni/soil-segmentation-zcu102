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
     * COMM SIGNALS
     */
    
    output wire filling, fill_done,
     
    // input data: in_px, in_pivot, in_buff_size, in_median_pos, in_second_median_value
    input wire [7:0] in_px, 
    	output wire in_px_rd,
    	input wire in_px_empty,		// not valid; assign valid = ~empty;
    	

    input wire [7:0] in_pivot_samp,
//    	output wire in_pivot_rd,
//    	input wire in_pivot_empty,
    	
    input wire [BUFF_SIZE_BIT-1:0] in_buff_size_samp,
//    	output wire in_buff_size_rd,
//    	input wire in_buff_size_empty,
    	
    input wire [BUFF_SIZE_BIT-1:0] in_median_pos_samp,
//    	output wire in_median_pos_rd,
//    	input wire in_median_pos_empty,
    	
    input wire [7:0] in_second_median_value_samp,
//    	output wire in_second_median_value_rd,
//    	input wire in_second_median_value_empty,
//        
        
    // output data: out_px, out_pivot, out_buff_size, out_median_pos, out_second_median_value
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
    /*
     *  SIGNALS and MEMORIES
     */  
	// pivot register
	//reg [7:0] in_pivot_samp;
    
    // in_buffer_size_samp register
    //reg [BUFF_SIZE_BIT-1:0] in_buff_size_samp;
	//wire filling;
    //output wire fill_done;
    
    // in median pos register
   // reg [BUFF_SIZE_BIT-1:0] in_median_pos_samp;
    
    // in second median value
    //reg [7:0] in_second_median_value_samp;
    
    // buffers signals
    wire new_lower, new_larger;
    wire [BUFF_SIZE_BIT-1:0] lower_size, equal_size, larger_size;

    reg [7:0] lower_buffer  [BUFF_SIZE-1:0];    
    reg [7:0] larger_buffer [BUFF_SIZE-1:0];
    reg [7:0] next_buffer [BUFF_SIZE-1:0];
   
    // min and max data 
    wire [7:0] max_lower, min_lower, max_larger, min_larger;
    
	
	// next values
	wire [BUFF_SIZE_BIT-1:0] next_buff_size;
    wire [7:0] next_pivot;
    wire [BUFF_SIZE_BIT-1:0] next_median_pos;
    wire [7:0] next_second_median_value;
        
    // send logic signals
    wire sending;
    wire [BUFF_SIZE_BIT-1:0] send_count;
    
    
    
    integer i;
    /*
     * INPUT REGISTERS
     */
    // sample pivot
    /*always@(posedge clock, negedge reset)
    if (reset == 1'b0)
        in_pivot_samp <= DEFAULT_PIVOT;
        in_pivot_samp <= in_pivot;
    
    assign in_pivot_rd = ~filling;	// if is not filling, samp a new pivot
    
    // sample buff size
    always@(posedge clock, negedge reset)
    if (reset == 1'b0)
        in_buff_size_samp <= BUFF_SIZE;
    else if (in_buff_size_rd && (~in_buff_size_empty))
        in_buff_size_samp <= in_buff_size;
    
    assign in_buff_size_rd = ~filling;	// if is filling don't read a new in buff size
    
    // sample median pos
    always@(posedge clock, negedge reset)
    if (reset == 1'b0)
        in_median_pos_samp <= MEDIAN_POS;
    else if (in_median_pos_rd && (~in_median_pos_empty))
        in_median_pos_samp <= in_median_pos;
    
    assign in_median_pos_rd = ~filling;	// if is filling don't read a new in median pos
    
    // second median value samp
    always@(posedge clock, negedge reset)
    if (reset == 1'b0)
        in_second_median_value_samp <= DEFAULT_PIVOT;
    else if (in_second_median_value_rd && (~in_second_median_value_empty))
        in_second_median_value_samp <= in_second_median_value;
    
    assign in_second_median_value_rd = ~filling;	// if is filling don't read a new in median pos

    */
    /*
     * 	FILL BUFFERS
     */
    fill_buffers #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT))
    	DUT_fill_buffers (
    	.clk(clock), .rst_n(reset),
    	
    	// inputs
    	.pivot(in_pivot_samp),   
	
   		.in_px(in_px),
    	.in_px_empty(in_px_empty),
    	.in_px_rd(in_px_rd),	// read a new pixel when fill buffers is ready.
    	//.in_px_valid(in_px_rd & (~in_px_empty)),
    	//.in_px_ready(in_px_rd),	// read a new pixel when fill buffers is ready
    
    	.in_buff_size(in_buff_size_samp),
  
    	// outputs (sizes and "write pointers")
    	.lower_size(lower_size),
    	.equal_size(equal_size),
    	.larger_size(larger_size),


    	.max_lower(max_lower), .min_lower(min_lower),	// output of a register
    	.max_larger(max_larger), .min_larger(min_larger),	// output of a register
    
    	.new_lower(new_lower),	 // new lower signal
    	.new_larger(new_larger),// new larger signal
    	 
    	.sending(sending),
    	
    	.filling(filling),	// filling status
   		.fill_done(fill_done)	// all buffers are filled
    );
    
    // update the buffers
    always@(posedge clock, negedge reset)
        if (reset == 1'b0)
            for (i=0; i<=BUFF_SIZE-1; i=i+1)
            begin
                lower_buffer[i] <= 8'dx; 
                // equal_buffer[i] <= {BUFF_SIZE_BIT {1'bx}}; 
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

    	//.clk(clock), .rst_n(reset),
    	
      	// input buffer sizes
   		.lower_size(lower_size),
    	.equal_size(equal_size),
    	.larger_size(larger_size),
    
    	// min and max values
    	.max_lower(max_lower), .min_lower(min_lower),
		.max_larger(max_larger), .min_larger(min_larger),  
    
    	//.lower_buffer(),
   		// .equal_buffer(),
    	//.larger_buffer(),

    	/*
	 	 * 	"EXTERNAL" INPUTS 
	 	 */
    	.in_pivot(in_pivot_samp),
    	.in_median_pos(in_median_pos_samp),
    
    	/*
     	 * OUTPUT
     	 */
    	 .next_buff_size(next_buff_size),   
   		 .next_pivot(next_pivot),
    	 .next_median_pos(next_median_pos),
    	 .next_second_median_value(next_second_median_value)
    );
    
    /*
    always @(in_median_pos_samp, lower_size, equal_size, lower_buffer, in_pivot_samp, larger_buffer)
    	if(lower_size > in_median_pos_samp) // the median is inside the lower buffer
           next_buffer = lower_buffer;
		else if (lower_size + equal_size > in_median_pos_samp_samp)  // DONE
            next_buffer = {lower_buffer[BUFF_SIZE-1:1], in_pivot};  // then if the median has been found, it will be passed to the next block
		else 
			next_buffer = larger_buffer;
	*/
	
			
			
	/*
	 * SEND LOGIC
	 */
	 
	wire send_req;
	
	assign send_req = fill_done & (~sending);
	// sending (if sending) don't update the next_buffer 
	send_logic #(.BUFF_SIZE(BUFF_SIZE), .BUFF_SIZE_BIT(BUFF_SIZE_BIT))
		DUT_send_logic (
			.clk(clock), .rst_n(reset),
  
  			.send_buff_size(next_buff_size),
    		// input to start the sending
  			.send_req(send_req),
    
    		 
    
   			.send_px_full(out_px_full),
    		.send_pivot_full(out_pivot_full),
    		.send_buff_size_full(out_buff_size_full),    
   			.send_median_pos_full(out_median_pos_full),    
   			.send_second_median_value_full(out_second_median_value_full),
    
    		.send_px_wr(out_px_wr),
    		.send_pivot_wr(out_pivot_wr),
    		.send_buff_size_wr(out_buff_size_wr),
     		.send_median_pos_wr(out_median_pos_wr), 
			.send_second_median_value_wr(out_second_median_value_wr), 
    
    		.sending(sending),
   			.send_count(send_count)
    );
	
	
	// next buffer
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)
			for (i=0; i<=BUFF_SIZE-1; i=i+1)
				next_buffer[i] <= 8'd0;
		else if (sending == 1'b0) // if not sending you can update next buffer
			if (fill_done == 1'b1 & (lower_size > in_median_pos_samp))
				for (i=0; i<=BUFF_SIZE-1; i=i+1)
					next_buffer[i] <= lower_buffer[i];
			else if (fill_done == 1'b1 & (lower_size + equal_size > in_median_pos_samp || equal_size == in_median_pos_samp))
				next_buffer[0] <= in_pivot_samp;  // then if the median has been found, it will be passed to the next block
			//for (i=1; i<=BUFF_SIZE-1; i=i+1)
			//next_buffer[i] <= 8'd0;	
			else if (fill_done == 1'b1)
				for (i=0; i<=BUFF_SIZE-1; i=i+1)
					next_buffer[i] <= larger_buffer[i];
   
	always@(posedge clock, negedge reset)
		if (reset == 1'b0)
			begin
				out_pivot <= 0;
				out_buff_size <= 0;
				out_median_pos <= 0;
				out_second_median_value <= 0;
				
			end
		else if (sending == 1'b0) // if not sending you can update next buffer
			begin
				out_pivot <= next_pivot;
				out_buff_size <= next_buff_size;	
				out_median_pos <= next_median_pos;  
				out_second_median_value <= next_second_median_value;
			end

		
    // output signals
    assign out_px = next_buffer[send_count];
//    assign out_pivot = next_pivot;
//    assign out_buff_size = next_buff_size;	
//    assign out_median_pos = next_median_pos;  
//    assign out_second_median_value = next_second_median_value;
//    
    
			
		

endmodule
