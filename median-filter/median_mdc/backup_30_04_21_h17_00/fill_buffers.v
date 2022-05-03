`timescale 1ns / 1ps

module fill_buffers #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
    
    // input pivot 
    input wire [7:0] pivot,
    
    // input pixel flow
    input wire [7:0] in_px,
    input wire in_px_empty,
    output wire in_px_rd,
    
    input wire [BUFF_SIZE_BIT-1:0] in_buff_size,


    
    /*
     * OUTPUTS TO CHECK MODULE
     */
    // output buffer sizes
    output wire [BUFF_SIZE_BIT-1:0] lower_size,
    output wire [BUFF_SIZE_BIT-1:0] equal_size,
    output wire [BUFF_SIZE_BIT-1:0] larger_size,


    output reg [7:0] max_lower, min_lower,	// output of a register
    output reg [7:0] max_larger, min_larger,	// output of a register
    
    
    output reg new_lower, new_larger,
    //output reg [7:0] lower_buffer [BUFF_SIZE-1:0],
    // reg [7:0] equal_buffer [BUFF_SIZE-1:0];
    //output reg [7:0] larger_buffer [BUFF_SIZE-1:0],
    
    
    input wire sending, 		// if sending cannot rise up the fill_done
    
    output wire filling,
    output wire fill_done
    );
    
    
//    reg [7:0] lower_buffer [BUFF_SIZE-1:0];
//    // reg [7:0] equal_buffer [BUFF_SIZE-1:0];
//    reg [7:0] larger_buffer [BUFF_SIZE-1:0];



	wire en_px_count;
	
    reg new_equal;
    wire new_min_low, new_max_low, new_min_larg, new_max_larg;


    // counter input pixels 
    wire [BUFF_SIZE_BIT-1:0] in_px_count;
    integer i;
    
    /*
    reg [BUFF_SIZE_BIT-1:0] buff_size_samp;
	
	// sample input buffer size
    always@(posedge clk, negedge rst_n)
    if (rst_n==1'b0)
        buff_size_samp <= BUFF_SIZE;
    else if (in_px_count == 0)
        buff_size_samp <= in_buff_size;
    */
    // if sending and fill done I cannot update the count and I cannot read new pixels
    
    assign in_px_rd = ~fill_done; // able to fill or filling
    assign en_px_count = (~fill_done) & (~sending) & (~in_px_empty); // 
    
    counter #(.MAX(BUFF_SIZE)) counter_pixels (
        .clk(clk), .rst_n(rst_n),
        .en_count(en_px_count), 
        .count(in_px_count),
        .restart(fill_done & (~sending))		// if not sending and fill done restart the count, new pixels could be sent
        );
        
    assign filling = (in_px_count > 0);
	assign fill_done = (in_px_count == in_buff_size);         
    //assign fill_done = (in_px_count == buff_size_samp);         
       

        
    
    // buffer selector
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
    
   
    // fill buffers
  /*  always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
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
       */     
    // update sizes     
    counter #(.MAX(BUFF_SIZE)) counter_lowers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_lower), 
        .count(lower_size),
        .restart(fill_done)
        );
            
     
    counter #(.MAX(BUFF_SIZE)) counter_equals (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_equal), 
        .count(equal_size),
        .restart(fill_done)
        );
        
    counter #(.MAX(BUFF_SIZE)) counter_largers (
        .clk(clk), .rst_n(rst_n),
        .en_count(new_larger), 
        .count(larger_size),
        .restart(fill_done)
    );
    
   
    // update max and min lowers and largers 

    // min lower
    assign new_min_low = (new_lower == 1'b1 && in_px < min_lower) ? 1'b1 : 1'b0;    
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_lower <= 8'd255;
        else if (fill_done == 1'b1)
            min_lower <= 8'd255;
        else if (new_min_low == 1'b1)
            min_lower <= in_px;
    
    // max lower
    assign new_max_low = (new_lower == 1'b1 && in_px > max_lower) ? 1'b1 : 1'b0;           
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_lower <= 8'd0;
        else if (fill_done == 1'b1)
            max_lower <= 8'd0;
        else if (new_max_low == 1'b1)
            max_lower <= in_px;
    
    // min larger
    assign new_min_larg = (new_larger == 1'b1 && in_px < min_larger) ? 1'b1 : 1'b0;     
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            min_larger <= 8'd255;
        else if (fill_done == 1'b1)
            min_larger <= 8'd255;
        else if (new_min_larg == 1'b1)
            min_larger <= in_px;
    
    // max larger
    assign new_max_larg = (new_larger == 1'b1 && in_px > max_larger) ? 1'b1 : 1'b0;
    always @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            max_larger <= 8'd0;
        else if (fill_done == 1'b1)
            max_larger <= 8'd0;
        else if (new_max_larg == 1'b1)
            max_larger <= in_px;
            
            
endmodule
