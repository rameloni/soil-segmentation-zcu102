`timescale 1ns / 1ps



module fill_buffers #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
        	
    /*
     * INPUT DATA: in_px, in_pivot_samp, in_buff_size
     */ 
    input wire [7:0] in_px,     // input pixel
    	input wire in_px_empty,	// control signals from fifo 
    	output wire in_px_rd,	// read request 
    // input wire in_px_valid,
    
    input wire [7:0] in_pivot_samp, 					// input pivot sampled
    input wire [BUFF_SIZE_BIT-1:0] in_buff_size_samp,	// in buff size sampled

    /*
     * OUTPUT DATA: new_lower, new_larger, lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
     */ 
    output reg new_lower, new_larger, //new_equal,

    output wire [BUFF_SIZE_BIT-1:0] lower_size,     // output buffer sizes
    output wire [BUFF_SIZE_BIT-1:0] equal_size,
    output wire [BUFF_SIZE_BIT-1:0] larger_size,

    output reg [7:0] max_lower, min_lower,	// output of a register
    output reg [7:0] max_larger, min_larger,	// output of a register
     
    // CONTROL SIGNALS
    input wire sending, 		// if sending --> wait
    output wire up_next, 		// update the next logic and send next data to next actor
    input wire control_sampled, // the input control data are sampled
    output wire filling         // the fill logic is filling
    
    );
	
	/*
	 * CONTROL BUFFER SIGNALS
	 */ 
	reg new_equal;
	wire new_min_low, new_max_low, new_min_larg, new_max_larg;

	
	/*
	 * CONTROL COUNT SIGNALS
	 */ 
	wire en_px_count;
	wire restart_count;
    wire fill_done;

    wire [BUFF_SIZE_BIT-1:0] in_px_count;	    // counter input pixels 
    
    
    /*
     * FSM
     */
    fsm_fill_logic DUT_fsm_fill_logic (
    		.clk(clk), .rst_n(rst_n),
     		
    		.fill_done(fill_done),
    		.sending(sending),
       		.control_sampled(control_sampled),

       		.read_req(in_px_rd),
            .filling(filling),
       		.up_next(up_next)     	
    	);
    	
    /*
     * BUFFER COUNTER ENABLES
     */ 
    assign en_px_count = in_px_rd & ~in_px_empty; 	// a new pixel is read

    always@(in_px, en_px_count, in_pivot_samp)
    begin
        if (en_px_count==1'b1)
        begin
            if (in_px < in_pivot_samp)
                {new_lower, new_equal, new_larger} = 3'b100;    // new lower
            else if (in_px == in_pivot_samp)
                {new_lower, new_equal, new_larger} = 3'b010;    // new equal
            else
                {new_lower, new_equal, new_larger} = 3'b001;    // new larger
        end
        else  {new_lower, new_equal, new_larger} = 3'b000;      // no input pixel
    end

 
    // restart the count when the buffers are sent to send_logic
    assign restart_count = up_next;
    assign fill_done = (in_px_count == in_buff_size_samp-1'b1) & ~in_px_empty;	// when the last pixel is received, raise the fill_done
        
    /*
     * INPUT PIXEL COUNTER
     */ 
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_pixels (
        .clk(clk), .rst_n(rst_n),
        .en_count(en_px_count), 
        .count(in_px_count),
        .restart(restart_count)
        );
    
   
    /*
  	 * TMP BUFFER COUNTERS
     */ 
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_lowers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_lower), 
        .count(lower_size),
        .restart(restart_count)
        );
                
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_equals (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_equal), 
        .count(equal_size),
        .restart(restart_count)
        );
        
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_largers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_larger), 
        .count(larger_size),
        .restart(restart_count)
    );
    
   
    /*
     * MAX and MIN UPDATE
     */ 
    
    // min lower
    assign new_min_low = (new_lower == 1'b1 && in_px < min_lower) ? 1'b1 : 1'b0;    
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_lower <= 8'd255;
        else if (restart_count == 1'b1)
            min_lower <= 8'd255;
        else if (new_min_low == 1'b1)
            min_lower <= in_px;
    
    // max lower
    assign new_max_low = (new_lower == 1'b1 && in_px > max_lower) ? 1'b1 : 1'b0;           
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_lower <= 8'd0;
        else if (restart_count == 1'b1)
            max_lower <= 8'd0;
        else if (new_max_low == 1'b1)
            max_lower <= in_px;
    
    // min larger
    assign new_min_larg = (new_larger == 1'b1 && in_px < min_larger) ? 1'b1 : 1'b0;     
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_larger <= 8'd255;
        else if (restart_count == 1'b1)
            min_larger <= 8'd255;
        else if (new_min_larg == 1'b1)
            min_larger <= in_px;
    
    // max larger
    assign new_max_larg = (new_larger == 1'b1 && in_px > max_larger) ? 1'b1 : 1'b0;
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_larger <= 8'd0;
        else if (restart_count == 1'b1)
            max_larger <= 8'd0;
        else if (new_max_larg == 1'b1)
            max_larger <= in_px;     
            
endmodule




/*
 * 	FSM FILL LOGIC
 */	
// module fsm_fill_logic (
// 		input wire clk,
// 		input wire rst_n,
    	
// 		input wire control_sampled,
// 		input wire fill_done,
// 		input wire sending,
// 		input wire en_buff_next,
		
// 		output wire read
		
// 		);
		
// 	parameter IDLE=2'b00, READ=2'b11, WAIT = 2'b01;
	
// 	reg [1:0] state, next_state;
	
// 	always@(posedge clk, negedge rst_n)
// 		if (rst_n == 1'b0)
// 			state <= IDLE;
// 		else 
// 			state <= next_state;
		
	
// 		/*
// 			 * NEXT LOGIC
// 			 */
// 	always@(state, control_sampled, fill_done, en_buff_next)
// 		case(state)
// 			IDLE: if(control_sampled == 1'b1) 
// 					next_state = READ;
// 				else 
// 					next_state = IDLE;
// 			READ: if(fill_done == 1'b0) 
// 					next_state = READ;
// 				else if(sending == 1'b0) 
// 					next_state = IDLE;
// 				else 
// 					next_state = WAIT;
// 			WAIT: if(en_buff_next == 1'b1) 
// 					 next_state = IDLE;
// 					else 
// 						next_state = WAIT;
// 			default: next_state = IDLE;
// 		endcase
		
	
// 		/*
// 		 * OUTPUT LOGIC
// 		 */
		
// 	assign read = &state;
// 	//	assign read = (state == READ & ~fill_done);
// endmodule