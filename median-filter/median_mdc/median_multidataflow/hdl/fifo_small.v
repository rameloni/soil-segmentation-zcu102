module fifo_small #(
       parameter depth = 64,  // FIFO depth (number of cells)
       parameter size = 8     // FIFO width (size in bits of each cell)
)(
  full,
  datain,
  enw,
  //valid,	// not empty 
  empty,
  dataout,
  enr,
  clk,
  rst
);

  output wire full;
  input [size-1:0] datain;
  input enw;
  //output wire valid;
  output wire empty;
  output wire [size-1:0] dataout;
  input enr;
  input clk;
  input rst;

 reg [size-1:0] dataToMem;
 reg [size-1:0] tmp [0:depth-1];
 reg [$clog2(depth)-1:0] addressInput, nextAddressInput;
 reg [$clog2(depth)-1:0] addressOutput, nextAddressOutput;
 //wire empty;
 wire valid;
integer i;

     always@(posedge clk, negedge rst)             
     begin
       if(rst == 0)
       begin
         for (i=0; i<=depth-1; i=i+1)
             tmp[i] <= {size{1'b0}};
         addressInput <= 0;
         addressOutput <= 0;
       end
       else
       begin
         tmp[addressInput] <= dataToMem;
         addressInput <= nextAddressInput;
         addressOutput <= nextAddressOutput;
       end
     end


     assign valid = (addressInput == addressOutput) ? 1'b0:1'b1;
     assign empty = (addressInput == addressOutput) ? 1'b1:1'b0;

     wire full1, full2, full3;
     assign full1 = ((addressInput+1) == addressOutput) ? 1'b1:1'b0;
     assign full2 = (addressInput == {($clog2(depth)){1'b1}}) ? 1'b1:1'b0;
     assign full3 = (addressOutput == {($clog2(depth)){1'b0}}) ? 1'b1:1'b0;

     assign full = (full1 || (full2 && full3)) ? 1'b1:1'b0;

     always@(enw, full, datain, addressInput)
     begin
       if(enw && !full)
       begin
         dataToMem = datain;
         nextAddressInput = addressInput + 1;
       end
       else
       begin
         dataToMem = {size{1'b0}};
         nextAddressInput = addressInput;
       end
     end

     always@(enr, valid, addressOutput, empty)
     begin
       if(enr && valid && !empty)
       begin
         nextAddressOutput = addressOutput + 1;
       end
       else
       begin
         nextAddressOutput = addressOutput;
       end
     end
     
     assign dataout = tmp[addressOutput];

endmodule