`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2022 01:21:48 PM
// Design Name: 
// Module Name: easy_hw_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core_easy_hw_block #(parameter DATA_WIDTH=8) (

    input wire clk, rst,
    
    // input numbers
    input wire [DATA_WIDTH-1:0] in_num_sw, in_num_ddr,
    // input push button to send back data
    input wire btn, start,
        
    output wire [7:0] out_led,  // status leds
    output wire [DATA_WIDTH -1:0] sum,      // 
    output wire send_data,
    
    output wire ready
    );
    reg [ DATA_WIDTH -1:0] in_ddr_samp;

    // summer 
    always@(posedge clk, posedge rst)
        if(rst == 1)
            in_ddr_samp <= {DATA_WIDTH{1'b0}};    
        else if (start) in_ddr_samp<=in_num_ddr;
       
    assign sum = in_num_sw + in_ddr_samp;
    
    assign out_led = (ready==1'b1) ? 8'b10101010 : 8'b11111111;
    
    easy_fsm easy_fsm_i(.clk(clk), .rst(rst), .btn(btn), .start(start), .send_data(send_data), .idle(ready)); // when the fsm is in idle it is able to accept new data and therefore it is ready
    
endmodule


module easy_fsm(

    input wire clk, rst,
    input wire btn, start,
    
    output reg send_data, idle
    );
    
    parameter IDLE = 1'b0, COMPUTE = 1'b1;
    
    reg state, nxt_state;
    
    // state logic
    always @(posedge clk, posedge rst)
        if (rst==1'b1)
            state <= IDLE;
        else
            state <= nxt_state;
            
    // next state logic 
    always @(state, btn, start)
        case(state)
            IDLE: 
                if (start == 1'b0) nxt_state = IDLE;
                else nxt_state = COMPUTE;
            COMPUTE: 
                if (btn==1'b0) nxt_state = COMPUTE;
                else nxt_state = IDLE;
            default: nxt_state = IDLE;
         endcase 
         
    // output logic
    always @(state, btn)
        case(state)
            IDLE: 
            begin
                send_data = 1'b0;
                 idle = 1'b1;
            end
            COMPUTE: 
               begin
                if (btn==1'b0) send_data = 1'b0;
                else send_data = 1'b1;
                
                idle = 1'b0;
                end
            default: {send_data, idle} = 2'b01;
         endcase      
                              
   
    endmodule