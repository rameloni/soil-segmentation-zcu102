

module counter #(parameter MAX=16)
    (
    input clk,
    input rst_n,
   // input restart, 
    input en_count, 
    input wire restart,
    output reg [$clog2(MAX):0] count
   // output max
    );
    //wire max;
       
    always @(posedge clk, negedge rst_n)
        if (rst_n  == 1'b0)
            count <= 0;
        else if (restart == 1'b1)
            count <= 0;
        else if (en_count == 1'b1)
            count <= count + 1'b1;
            
            
  //  assign max = (count == MAX);        
endmodule

