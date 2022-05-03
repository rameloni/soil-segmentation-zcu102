/*
 * 	FSM FILL LOGIC
 */	
module fsm_fill_logic (
		input wire clk,
		input wire rst_n,
    	
		input wire fill_done,       // the fill logic has filled the tmp buffers
		input wire sending,         // the send logic is sending
		input wire control_sampled, // the control data are sampled, hence a new read could start
		
		output wire read_req,       // read request
        output wire filling,        // the fill logic is filling
        output wire up_next         // the fill logic has ended, the send logic is not busy, therefore the next data can be sent
		
		);
		
	parameter IDLE=2'b00, READ=2'b01, WAIT=2'b10, SEND_REQ=2'b11;
	
	reg [1:0] state, next_state;
	
	always@(posedge clk, negedge rst_n)
		if (rst_n == 1'b0)
			state <= IDLE;
		else 
			state <= next_state;
		
	
	/*
	 * NEXT STATE LOGIC
	 */
	always@(state, control_sampled, fill_done, sending)
		case(state)
			IDLE:   if(control_sampled)
                        next_state = READ;
                    else    
                        next_state = IDLE;
            READ:   if(~fill_done)
                        next_state = READ;
                    else if(sending)
                        next_state = WAIT;
                    else 
                        next_state = SEND_REQ;
            WAIT:   if(sending) 
                        next_state = WAIT;
                    else
                        next_state = SEND_REQ;
            SEND_REQ:   next_state = IDLE;

			default: next_state = IDLE;
		endcase
		
	
		/*
		 * OUTPUT LOGIC
		 */
		
	assign read_req = (state==READ) ? 1'b1 : 1'b0;
    assign filling = |state;
    assign up_next = (state==SEND_REQ) ? 1'b1 : 1'b0;

endmodule