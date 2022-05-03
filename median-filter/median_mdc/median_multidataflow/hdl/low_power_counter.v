`timescale 1ns / 1ps

module low_power_counter #(parameter SIZE_BIT=4'd8, MAX = 11'd1024)
    (
    input wire clk, rst_n,
    input wire en_count, 
    input wire restart,
    output reg [SIZE_BIT-1:0] count
    );
    parameter MAX_4 = MAX >> 2; 
    
    
    counter #(.SIZE_BIT($clog2(MAX_4))) counter0 (
    		.clk(clk), .rst_n(rst_n),
    		.en_count(en_count), 
    		.count(equal_size),
    		.restart()
    	);
    always @(posedge clk, negedge rst_n)
        if (rst_n  == 1'b0)
        	count <= {SIZE_BIT{1'b0}};
        else if (restart == 1'b1)
            count <= 0;
        else if (en_count == 1'b1)
            count <= count + 1'b1;
            
endmodule

