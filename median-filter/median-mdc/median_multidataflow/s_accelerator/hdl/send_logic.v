`timescale 1ns / 1ps

module send_logic #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
    
    
    // 
    
    // send buffer size
    input wire [BUFF_SIZE_BIT-1:0] send_buff_size,
    // input sending request
    input wire send_req,
    
    
    input wire send_px_full,
    input wire send_pivot_full,
    input wire send_buff_size_full,    
    input wire send_median_pos_full,    
    input wire send_second_median_value_full,
    
    output wire send_px_wr,
    output wire send_pivot_wr,
    output wire send_buff_size_wr,
    output wire send_median_pos_wr, 
    output wire send_second_median_value_wr, 
    
    
    output wire sending,
   	output wire [BUFF_SIZE_BIT-1:0] send_count
    );
    
    
    reg en_send;
    wire idle;  
    
    

   	// send the control data to the fifo
 	assign send_pivot_wr = en_send & (~send_pivot_full); 	
 	assign send_buff_size_wr = en_send & (~send_buff_size_full); 	
 	assign send_median_pos_wr = en_send & (~send_median_pos_full); 	
 	assign send_second_median_value_wr = en_send & (~send_second_median_value_full);
 	
    /*
     * output send pixels 
     */

    
    always@(posedge clk, negedge rst_n)
        if(rst_n == 1'b0)
            en_send <= 1'b0;
       		// if is not sending and arrives a new send request enable the count
       	//else if (restart_count == 1'b)
       		//en_send <= 1'b0;
        else if (idle == 1'b1 && send_req == 1'b1)
            en_send <= 1'b1;
            // if is sending continue to count
            
            // is not sending and a new request is not arrived don't enable ythe count
        else if (idle == 1'b1 && send_req == 1'b0)
        	en_send <= 1'b0;

            
    
    // send counter
    counter #(.MAX(BUFF_SIZE)) buffer_indexer (
        .clk(clk), .rst_n(rst_n),
        .en_count(send_px_wr), 
        .count(send_count),
        .restart(restart_count)
        );
    
    // it is idle if the count is zero
	assign idle = (send_count == 0);
	   
	assign restart_count = (send_count == send_buff_size-1);

	assign send_px_wr = (~send_px_full) & en_send;
	
	assign sending = en_send;

endmodule
