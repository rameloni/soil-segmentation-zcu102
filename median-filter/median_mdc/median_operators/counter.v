

module counter #(parameter SIZE_BIT=4'd8)
    (
    input wire clk, rst_n,
    input wire en_count, 
    input wire restart,
    output reg [SIZE_BIT-1:0] count
    );
       
    always @(posedge clk, negedge rst_n)
        if (rst_n  == 1'b0)
        	count <= {SIZE_BIT{1'b0}};
        else if (restart == 1'b1)
            count <= 0;
        else if (en_count == 1'b1)
            count <= count + 1'b1;
            
endmodule

