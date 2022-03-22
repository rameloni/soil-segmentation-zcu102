module fifo_small #(
       parameter depth = 64,  // FIFO depth (number of cells)
       parameter size = 8     // FIFO width (size in bits of each cell)
)(
    // PUSH
       output full,
       input [size-1:0] datain,
       input enw,
       // POP
       output valid, // ~empty
       output reg [size-1:0] dataout,
       input enr,
       input clk,
       input rst_n
);


 reg [size-1:0] dataToMem;
 reg [size-1:0] tmp [0:depth-1];
 reg [$clog2(depth)-1:0] addressInput, nextAddressInput;
 reg [$clog2(depth)-1:0] addressOutput, nextAddressOutput;
 reg [19:0] counterIn, counterOut;
 reg [19:0] counterInNext, counterOutNext;
 wire empty;
integer i;

     always@(posedge clk, negedge rst_n)             
     begin
       if(rst_n == 0)
       begin
         for (i=0; i<=depth-1; i=i+1)
             tmp[i] <= {size{1'bx}};
         addressInput <= {$clog2(depth){1'b0}};
         addressOutput <= {$clog2(depth){1'b0}};
         counterIn <= 20'd0;
         counterOut <= 20'd0;
       end
       else
       begin
         tmp[addressInput] <= dataToMem;
         addressInput <= nextAddressInput;
         addressOutput <= nextAddressOutput;
         counterIn <= counterInNext;
         counterOut <= counterOutNext;
       end
     end


     assign valid = (addressInput == addressOutput) ? 1'b0:1'b1;
     assign empty = (addressInput == addressOutput) ? 1'b1:1'b0;

     wire full1, full2, full3;
     assign full1 = ((addressInput+1) == addressOutput) ? 1'b1:1'b0;
     assign full2 = (addressInput == {($clog2(depth)){1'b 1}}) ? 1'b1:1'b0;
     assign full3 = (addressOutput == {($clog2(depth)){1'b 0}}) ? 1'b1:1'b0;

     assign full = (full1 || (full2 && full3)) ? 1'b1:1'b0;

     always@(enw, full, datain, addressInput)
     begin
       if(enw && !full)
       begin
         dataToMem = datain;
         nextAddressInput = addressInput + 1;
         counterInNext = counterIn + 1;
       end
       else
       begin
         dataToMem = {size{1'bx}};
         nextAddressInput = addressInput;
         counterInNext = counterIn;
       end
     end

     always@(enr, valid, addressOutput)
     begin
       if(enr && valid && !empty)
       begin
         nextAddressOutput = addressOutput + 1;
         dataout = tmp[addressOutput];
         counterOutNext = counterOut + 1;
       end
       else
       begin
         nextAddressOutput = addressOutput;
         dataout = {size{1'b0}};
         counterOutNext = counterOut;
       end
     end

endmodule