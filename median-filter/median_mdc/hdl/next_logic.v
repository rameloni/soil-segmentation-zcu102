`timescale 1ns / 1ps

module next_logic #(
    parameter MEDIAN_POS = 11'd512,  // default 1024/2
        BUFF_SIZE = 11'd1024,
        BUFF_SIZE_BIT = $clog2(BUFF_SIZE)+1,
        
        LOW=2'b00, EQ0=2'b01, EQ1=2'b10, LARG=2'b11

    ) (
   	input wire clk, 
    input wire rst_n,
    
    // CONTROL DATA
    output reg [1:0] _case, // case of next data
	input wire up_next, 	// update next
    /*
     * "CONTROL" INPUT DATA: lower_size, equal_size, larger_size, max_lower, min_lower, max_larger, min_larger
     */
    input wire [BUFF_SIZE_BIT-1:0] lower_size,	// buffer sizes
    input wire [BUFF_SIZE_BIT-1:0] equal_size,
    input wire [BUFF_SIZE_BIT-1:0] larger_size,
    
    input wire [8:0] max_lower,  min_lower,		// min and max values
    input wire [8:0] max_larger, min_larger,
    
    /*
 	 * 	"EXTERNAL" INPUT DATA: in_pivot_samp, in_median_pos_samp 
 	 */
	input wire [BUFF_SIZE_BIT-1:0] in_buff_size_samp,
    input wire [8:0] in_pivot_samp,						
    input wire [BUFF_SIZE_BIT-1:0] in_median_pos_samp,	
    input wire [8:0] in_second_median_value_samp,	

    /*
     * OUTPUT DATA: next_pivot, next_buff_size, next_median_pos, next_second_median_value
     */
    output wire [7:0] next_pivot,
    output reg [BUFF_SIZE_BIT-1:0] next_buff_size,   
    output reg [BUFF_SIZE_BIT-1:0] next_median_pos,
    output reg [7:0] next_second_median_value
    
    );

	reg [8:0] _next_pivot;	// an added bit because of the mean computation
	assign next_pivot = _next_pivot[7:0];
	
	//reg [1:0] _case;	// 

	always@(lower_size, in_pivot_samp, in_median_pos_samp, equal_size, in_buff_size_samp)
		if(lower_size > in_median_pos_samp)
			_case = LOW;					// _case 00: the median is inside the lower buffer
		else if ((lower_size + equal_size) > in_median_pos_samp)
			if(BUFF_SIZE[0] == 1'b0 && lower_size == in_median_pos_samp)
				_case = EQ0;				// _case 01: the median is inside the equal buffer, then the median is found
			else
				_case = EQ1;					// _case 10: the median is inside the equal buffer, and it has been found in a previous actor or the pivot isn't a mean
		else if(equal_size == in_buff_size_samp) 
			_case = EQ1;
		else
			_case = LARG;					// _case 11: the median is inside the larger buffer
	/*
	 * NEXT PIVOT
	 */
	always@(posedge clk, negedge rst_n)
		if(rst_n == 1'b0)
			_next_pivot <= 9'd127;
		else if(up_next==1'b1)
			if(_case==LOW)
				_next_pivot <= (max_lower + min_lower) >> 1;
			else if(_case==LARG)
				_next_pivot <= (max_larger + min_larger) >> 1;
			else if(_case==EQ1)
				_next_pivot <= {1'b0, in_pivot_samp};
			else if(_case==EQ0 && in_median_pos_samp == 0)
				_next_pivot <= (in_pivot_samp + in_second_median_value_samp) >> 1;
			else
				_next_pivot <= (in_pivot_samp + max_lower) >> 1;

	/*
     * NEXT BUFF SIZE
     */
    always@(posedge clk, negedge rst_n)
		if(rst_n == 1'b0)
			next_buff_size <= BUFF_SIZE;
		else if(up_next==1'b1)
			if(_case==LOW)
    			next_buff_size <= lower_size;
			else if(_case==LARG)
    			next_buff_size <= larger_size;
			else if(_case==EQ1 | _case==EQ0)
				next_buff_size <= {{BUFF_SIZE_BIT-1{1'b0}}, 1'b1};
	

    /*
     * NEXT MEDIAN POS
     */ 
	always@(posedge clk, negedge rst_n)
		if(rst_n == 1'b0)
			next_median_pos <= MEDIAN_POS;
		else if(up_next==1'b1)
			if(_case==LOW)
    			next_median_pos <= in_median_pos_samp;
			else if(_case==LARG)
    			next_median_pos <= in_median_pos_samp - (lower_size + equal_size);
			else if(_case==EQ1 | _case==EQ0)
				next_median_pos <= {BUFF_SIZE_BIT{1'b0}};

	/*
     * NEXT SECOND MEDIAN VALUE
     */ 	
	always@(posedge clk, negedge rst_n)
		if(rst_n == 1'b0)
			next_second_median_value <= 8'd127;
		else if(up_next==1'b1)
			if(_case==LOW)
    			next_second_median_value <= in_second_median_value_samp[7:0];
			else if(_case==LARG)
				if(in_median_pos_samp - (lower_size + equal_size) == 0)
    				next_second_median_value <= (equal_size == 0) ? max_lower: in_pivot_samp;
				else 
					next_second_median_value <= in_second_median_value_samp[7:0];			
			else if(_case==EQ1 | _case==EQ0)
				next_second_median_value <= in_second_median_value_samp[7:0];

    
  
endmodule
