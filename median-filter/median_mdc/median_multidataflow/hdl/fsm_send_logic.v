
module fsm_send_logic (
		input wire clk,
		input wire rst_n,
    	
		input wire up_next,
		input wire send_done,
		
        output wire send_req,
		output wire sending
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
	always@(state, up_next, send_done)
		case(state)
			IDLE: if(up_next) 
					next_state = SEND;
				  else 
					next_state = IDLE;
			SEND: if(send_done)
					next_state = IDLE;
				  else 
					next_state = SEND;
			default: next_state = IDLE;
		endcase
		
	
	/*
	 * OUTPUT LOGIC
	 */

    assign send_req = state;
    assign sending = state;
	
endmodule

