`timescale 1ns / 1ps



module fill_buffers #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
    
    	
    /*
     * INPUT DATA: in_px_delay, in_pivot_samp, in_buff_size
     */ 
    input wire [7:0] in_px,     // input pixel delay
    input wire in_px_empty,		// control signals from fifo (delayed)
    //output wire in_px_rd,
    input wire in_px_valid,
     
    input wire [7:0] pivot, 						// input pivot sampled
    input wire [BUFF_SIZE_BIT-1:0] in_buff_size,	// in buff size sampled

    /*
     * OUTPUT DATA: new_lower, new_larger, lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
     */ 
    output reg new_lower, new_larger,

    output wire [BUFF_SIZE_BIT-1:0] lower_size,     // output buffer sizes
    output wire [BUFF_SIZE_BIT-1:0] equal_size,
    output wire [BUFF_SIZE_BIT-1:0] larger_size,

    output reg [7:0] max_lower, min_lower,	// output of a register
    output reg [7:0] max_larger, min_larger,	// output of a register
     
    // INPUT CONTROL SIGNALS
    input wire sending, 		// if sending cannot rise up the fill_done
    input wire send_req, 		// if sending cannot rise up the fill_done
    // OUTPUT CONTROL SIGNALS
    output wire filling,
    output wire fill_done
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

    wire [BUFF_SIZE_BIT-1:0] in_px_count;	    // counter input pixels 
    
    integer i; 	// needed by the buffer registers
    
    
    /*
     * INPUT PIXEL COUNTER
     */ 
    // if sending and fill is done, I cannot update the count and I cannot read new pixels
    //assign in_px_rd = ~fill_done;									// read if able to fill or filling
   /* always@(posedge clk, negedge rst_n)
    	if (rst_n == 1'b0)
    		in_px_rd <= 1'b1;
    	else 
    		in_px_rd <= ~send_req;*/
    //assign in_px_rd = ~send_req;									// read if able to fill or filling
    
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_pixels (
        .clk(clk), .rst_n(rst_n),
        .en_count(en_px_count), 
        .count(in_px_count),
        .restart(fill_done & (~sending))		// if not sending and fill done restart the count, new pixels could be sent
        //.restart(send_req)		// if not sending and fill done restart the count, new pixels could be sent
        );
    
    assign filling = (in_px_count > 0);			// if the count is greater than zero the logic is filling
    //assign filling = en_px_count;	// if is filling don't read a new in median pos
	
    assign fill_done = (in_px_count == in_buff_size) & filling;	// when the last pixel is received, raise the fill_done
    //assign fill_done = (in_px_count == buff_size_samp);         
     
//    assign en_px_count = (~fill_done) & (~sending) & (~in_px_empty); 	// increase the count if fill not done, not sending and input not empty 
    assign en_px_count = (~fill_done) & (in_px_valid) & (~in_px_empty); 	// increase the count if fill not done, not sending and input not empty
    

    /*
     * BUFFER SELECTOR
     */    
    always@(in_px, en_px_count, pivot)
    begin
        if (en_px_count==1'b1)
        begin
            if (in_px < pivot)
                {new_lower, new_equal, new_larger} = 3'b100;    // new lower
            else if (in_px == pivot)
                {new_lower, new_equal, new_larger} = 3'b010;    // new equal
            else
                {new_lower, new_equal, new_larger} = 3'b001;    // new larger
        end
        else  {new_lower, new_equal, new_larger} = 3'b000;      // no input pixel
    end
    
   /*
  	* SIZE BUFFER COUNTERS
    */ 
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_lowers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_lower), 
        .count(lower_size),
        .restart(send_req)
        );
            
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_equals (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_equal), 
        .count(equal_size),
        .restart(send_req)
        );
        
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_largers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_larger), 
        .count(larger_size),
        .restart(send_req)
    );
    
   
    /*
     * MAX and MIN UPDATE
     */ 
    
    // min lower
    assign new_min_low = (new_lower == 1'b1 && in_px < min_lower) ? 1'b1 : 1'b0;    
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_lower <= 8'd255;
        else if (send_req == 1'b1)
            min_lower <= 8'd255;
        else if (new_min_low == 1'b1)
            min_lower <= in_px;
    
    // max lower
    assign new_max_low = (new_lower == 1'b1 && in_px > max_lower) ? 1'b1 : 1'b0;           
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_lower <= 8'd0;
        else if (send_req == 1'b1)
            max_lower <= 8'd0;
        else if (new_max_low == 1'b1)
            max_lower <= in_px;
    
    // min larger
    assign new_min_larg = (new_larger == 1'b1 && in_px < min_larger) ? 1'b1 : 1'b0;     
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_larger <= 8'd255;
        else if (send_req == 1'b1)
            min_larger <= 8'd255;
        else if (new_min_larg == 1'b1)
            min_larger <= in_px;
    
    // max larger
    assign new_max_larg = (new_larger == 1'b1 && in_px > max_larger) ? 1'b1 : 1'b0;
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_larger <= 8'd0;
        else if (send_req == 1'b1)
            max_larger <= 8'd0;
        else if (new_max_larg == 1'b1)
            max_larger <= in_px;
            
            
endmodule
