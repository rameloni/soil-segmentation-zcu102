`timescale 1ns / 1ps

module send_logic #(
    parameter BUFF_SIZE=32,
              BUFF_SIZE_BIT = $clog2(BUFF_SIZE) + 1
              )(
    input wire clk,
    input wire rst_n,
    
    input wire [BUFF_SIZE_BIT-1:0] send_buff_size, // output buffer size
    input wire up_next,						   // request

  
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
   	output wire [BUFF_SIZE_BIT-1:0] px_send_count
    );
    
	/*
	 * CONTROL COUNT SIGNALS
	 */    
    wire en_px_send_count;		// output pixel send count enable
	wire restart_count;
	wire send_done;
	wire count_zero;	

	/*
	 * FSM
	 */
	fsm_send_logic DUT_fsm_send_logic (
  		.clk(clk), .rst_n(rst_n),
    	
       	.up_next(up_next), 	
		.send_done(send_done),
		
		.send_req(send_px_wr),
    	.sending(sending)
		);


	/*
	 * OUTPUT COUNTER ENABLE
	 */
	
	assign en_px_send_count = send_px_wr & ~send_px_full;
	
	assign restart_count = send_done;
	assign send_done = (px_send_count == send_buff_size-1'b1) & en_px_send_count;
	assign count_zero = (px_send_count == 0);
	/*
	 * OUTPUT PIXEL COUNTER
	 */
    counter #(.SIZE_BIT(BUFF_SIZE_BIT)) counter_send_pixels (
        .clk(clk), .rst_n(rst_n),
        .en_count(en_px_send_count), 
        .count(px_send_count),
        .restart(restart_count)
        );
	 // wire en_size_buff_samp;

    //reg [BUFF_SIZE_BIT-1:0] send_buff_size_samp;
    //wire count_zero;  
    
	/*
	 * OUTPUT CONTROL DATA
	 */
   	// send the control data to the fifo
 	assign send_pivot_wr =  en_px_send_count & (~send_pivot_full) & count_zero; 	
 	assign send_buff_size_wr = en_px_send_count & (~send_buff_size_full) & count_zero; 	
 	assign send_median_pos_wr = en_px_send_count & (~send_median_pos_full) & count_zero; 	
 	assign send_second_median_value_wr = en_px_send_count & (~send_second_median_value_full) & count_zero;
 	
	/*
	 * OUTPUT PIXEL COUNTER
	 */
    // counter #(.SIZE_BIT(BUFF_SIZE_BIT)) buffer_indexer (
    //     .clk(clk), .rst_n(rst_n),
    //     .en_count(en_px_send_count), 
    //     .count(px_send_count),
    //     .restart(restart_count)
    //     );


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
//       	//else if (send_done == 1'b)
//       		//en_send <= 1'b0;
//        else if (count_zero == 1'b1 && send_req == 1'b1)
//        begin
//            en_send <= 1'b1;
//            send_buff_size_samp <= send_buff_size;
//        end
//            // if is sending continue to count
//            
//            // is not sending and a new request is not arrived don't enable ythe count
//        else if (send_done == 1'b1 && send_req == 1'b0)
//        	en_send <= 1'b0;

 	
 	// always@(posedge clk, negedge rst_n)
 	// 	if(rst_n == 1'b0)
 	// 		send_buff_size_samp <= 0;
 	// 	else if(en_size_buff_samp == 1'b1) 
 	// 		send_buff_size_samp <= send_buff_size;
 		
// 	fsm_send_logic DUT_fsm_send_logic (
//    	.clk(clk), .rst_n(rst_n),
//     		
//    	.send_req(send_req),
//    	.restart(send_done),
//    	.full(send_px_full),
//    	
//    	.sending(sending),
//    	.en_size_buff_samp(en_size_buff_samp),
//    	.en_send(en_send)
//	   	);
 	// new_fsm_send_logic DUT_new_fsm_send_logic (
 	// 		.clk(clk), .rst_n(rst_n),
     		
 	// 		.fill_done(fill_done),
 	// 		.send_done(send_done),
 	// 		.full(send_px_full),
    	
 	// 		.sending(sending),
 	// 		.en_size_buff_samp(en_size_buff_samp),
 	// 		.en_buff_samp(en_buff_samp)
 	// 	);

        
    
    // // send counter
    // counter #(.SIZE_BIT(BUFF_SIZE_BIT)) buffer_indexer (
    //     .clk(clk), .rst_n(rst_n),
    //     .en_count(send_px_wr), 
    //     .count(send_count),
    //     .restart(send_done)
    //     );
    
	// assign count_zero = (send_count==0);
	// //assign send_done = (send_count == send_buff_size_samp-1) & (send_buff_size_samp > 1);
	// always@(send_buff_size_samp, send_count)
	// 	if (send_buff_size_samp > 1)
	// 		send_done = (send_count == send_buff_size_samp-1);
	// 	else 
	// 		send_done = (send_count == 0);
		
	// //assign sending = en_send;
	// assign send_px_wr = (~send_px_full) & sending;

endmodule


/*
 * 	FSM SEND LOGIC
 */	


// module old_fsm_send_logic (
// 		input wire clk,
// 		input wire rst_n,
    	
// 		input wire fill_done,
// 		input wire send_done,
// 		input wire full,
		
// 		output wire sending,
// 		output reg en_size_buff_samp,
// 		output reg en_buff_samp
// 		);
		
// 	parameter IDLE=1'b0, SEND=1'b1;
	
// 	reg state, next_state;
	
// 	always@(posedge clk, negedge rst_n)
// 		if (rst_n == 1'b0)
// 			state <= IDLE;
// 		else 
// 			state <= next_state;
		
	
// 		/*
// 			 * NEXT LOGIC
// 			 */
// 	always@(state, fill_done, send_done, full)
// 		case(state)
// 			IDLE: if(fill_done & ~full) 
// 					next_state = SEND;
// 				  else 
// 					next_state = IDLE;
// 			SEND: if(send_done)
// 					next_state = IDLE;
// 				  else 
// 					next_state = SEND;
// 			default: next_state = IDLE;
// 		endcase
		
	
// 		/*
// 		 * OUTPUT LOGIC
// 		 */
// //		reg [1:0] out;
// //		assign {en_buff_size_samp, en_buff_samp} = out;
// //		
// 	always@(state, fill_done, send_done, full)
// 		case(state)
// 			IDLE: if(fill_done & ~full) 
// 				begin
// 					en_size_buff_samp = 1'b1;
// 					en_buff_samp = 1'b1;
// 				end
// 				else 
// 				begin
// 					en_size_buff_samp = 1'b0;
// 					en_buff_samp = 1'b0;
// 				end			
// 			SEND: if(send_done)
// 				begin
// 					en_size_buff_samp = 1'b0;
// 					en_buff_samp = 1'b0;
// 				end		
// 				else 
// 				begin
// 					en_size_buff_samp = 1'b0;
// 					en_buff_samp = 1'b0;
// 				end		
// 			default: 
// 				begin
// 					en_size_buff_samp=1'b0;
// 				en_buff_samp = 1'b0;
// 				end
// 		endcase
	
// //	always@(state, send_req)
// //		if(state == IDLE && send_req == 1'b1 & full==1'b0) en_size_buff_samp = 1'b1;
// //		else en_size_buff_samp = 1'b0;
	
// 	assign sending = state;
	
// 	//assign en_read = en_size_buff_samp;
// endmodule