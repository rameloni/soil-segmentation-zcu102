`timescale 1ns / 1ps

module send_logic #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
    
    input wire [BUFF_SIZE_BIT-1:0] send_buff_size, // output buffer size
    input wire send_req,						   // request
    output wire en_read,
    /*
     * INPUT CONTROL FULL from FIFO
     */ 
    input wire send_px_full,
    input wire send_pivot_full,
    input wire send_buff_size_full,    
    input wire send_median_pos_full,    
    input wire send_second_median_value_full,
    
    /*
     * OTUPUT CONTROL WR to FIFO
     */ 
    output wire send_px_wr,
    output wire send_pivot_wr,
    output wire send_buff_size_wr,
    output wire send_median_pos_wr, 
    output wire send_second_median_value_wr, 
    
    /*
     * CONTROL SIGNALS
     */ 
    output wire sending,
   	output wire [BUFF_SIZE_BIT-1:0] send_count
    );
    
    
    wire en_send;
    wire en_size_buff_samp;
    reg [BUFF_SIZE_BIT-1:0] send_buff_size_samp;
    wire count_zero;  
    wire restart_count;
    

   	// send the control data to the fifo
 	assign send_pivot_wr =  send_px_wr & (~send_pivot_full) & count_zero; 	
 	assign send_buff_size_wr = send_px_wr & (~send_buff_size_full) & count_zero; 	
 	assign send_median_pos_wr = send_px_wr & (~send_median_pos_full) & count_zero; 	
 	assign send_second_median_value_wr = send_px_wr & (~send_second_median_value_full) & count_zero;
 	
    /*
     * output send pixels 
     */

    
//    always@(posedge clk, negedge rst_n)
//        if(rst_n == 1'b0)
//        begin
//            en_send <= 1'b0;
//            send_buff_size_samp <= 0;
//        end
//       		// if is not sending and arrives a new send request enable the count
//       	//else if (restart_count == 1'b)
//       		//en_send <= 1'b0;
//        else if (count_zero == 1'b1 && send_req == 1'b1)
//        begin
//            en_send <= 1'b1;
//            send_buff_size_samp <= send_buff_size;
//        end
//            // if is sending continue to count
//            
//            // is not sending and a new request is not arrived don't enable ythe count
//        else if (restart_count == 1'b1 && send_req == 1'b0)
//        	en_send <= 1'b0;

 	
 	always@(posedge clk, negedge rst_n)
 		if(rst_n == 1'b0)
 			send_buff_size_samp <= 0;
 		else if(en_size_buff_samp == 1'b1) 
 			send_buff_size_samp <= send_buff_size;
 		
 	fsm_send_logic DUT_fsm_send_logic (
    	.clk(clk), .rst_n(rst_n),
     		
    	.send_req(send_req),
    	.restart(restart_count),
    	.full(send_px_full),
    	
    	.sending(sending),
    	.en_size_buff_samp(en_size_buff_samp),
    	.en_send(en_send)
	   	);
        
    
    // send counter
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) buffer_indexer (
        .clk(clk), .rst_n(rst_n),
        .en_count(send_px_wr), 
        .count(send_count),
        .restart(restart_count)
        );
    
	assign count_zero = (send_count==0);
	assign restart_count = (send_count == send_buff_size_samp-1);
	//assign sending = en_send;
	assign send_px_wr = (~send_px_full) & sending;

endmodule


/*
 * 	FSM SEND LOGIC
 */	
module fsm_send_logic (
		input wire clk,
		input wire rst_n,
    	
		input wire send_req,
		input wire restart,
		input wire full,
		
		output wire sending,
		output reg en_size_buff_samp,
		output reg en_send,
		output wire en_read
		);
		
	parameter IDLE=1'b0, SEND=1'b1;
	
	reg state, next_state;
	
	always@(posedge clk, negedge rst_n)
		if (rst_n == 1'b0)
			state <= IDLE;
		else 
			state <= next_state;
		
	
	/*
	 * NEXT LOGIC
	 */
	always@(state, send_req, restart)
		case(state)
			IDLE: if(send_req == 1'b1 & full == 1'b0) next_state = SEND;
				else next_state = IDLE;
			SEND: if(send_req == 1'b0 && restart == 1'b1) next_state = IDLE;
				else next_state = SEND;
		endcase
		
	
	/*
	 * OUTPUT LOGIC
	 */
	always@(state, send_req, restart)
		case(state)
			IDLE: if(send_req == 1'b1 & full==1'b0) en_send = 1'b1;
				else en_send = 1'b0;
			SEND: if(send_req == 1'b0 & restart == 1'b1) en_send = 1'b0;
					else en_send = 1'b1;
			default: en_send = 1'b1;
			endcase
	
	always@(state, send_req)
		if(state == IDLE && send_req == 1'b1 & full==1'b0) en_size_buff_samp = 1'b1;
		else en_size_buff_samp = 1'b0;
	
		assign sending = state;
	
	//assign en_read = en_size_buff_samp;
endmodule


