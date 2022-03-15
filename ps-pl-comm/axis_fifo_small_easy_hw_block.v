`timescale 1ns / 1ps

/*
 * AXI4-Stream asynchronous FIFO
 */
module axis_fifo_small_easy_hw_block #
(
    parameter ADDR_WIDTH = 12,
    parameter C_AXIS_TDATA_WIDTH = 8
)
(
    // CORE input output 
    input btn,
    input [7:0] in_num_sw,
    output [7:0] out_led,

    /*
     * AXI slave interface (input to the FIFO)
     */
    input  wire                   s00_axis_aclk,
    input  wire                   s00_axis_aresetn,
    input  wire [C_AXIS_TDATA_WIDTH-1:0]  s00_axis_tdata, // input data
   // input  wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
    input  wire                   s00_axis_tvalid,  // there is a valid input data              OK
    output wire                   s00_axis_tready,  // fifo is ready to receive new data        OK
   // input  wire                   s00_axis_tlast,
    
    /*
     * AXI master interface (output of the FIFO)
     */
    input  wire                   m00_axis_aclk, // unconnected
    input  wire                   m00_axis_aresetn, // unconnected
    output wire [C_AXIS_TDATA_WIDTH-1:0]  m00_axis_tdata,
   // output wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
    output wire                   m00_axis_tvalid,
    input  wire                   m00_axis_tready,
    output wire                   m00_axis_tlast
);

wire in_fifo_full;
assign s00_axis_tready = ~in_fifo_full; // if fifo is not full, it is ready to receive new data


wire in_enr, in_valid;
wire [C_AXIS_TDATA_WIDTH-1:0] in_dataout;
wire [C_AXIS_TDATA_WIDTH-1:0] sum;

wire send_data;

fifo_small #( .depth(64),.size(C_AXIS_TDATA_WIDTH)) in_fifo_small_inst (
        .full(in_fifo_full),
        .datain(s00_axis_tdata), // input data
        .enw(s00_axis_tvalid),
        
        
       .valid(in_valid), // read data from fifo
       .dataout(in_dataout),
       .enr(in_enr),
       
       .clk(s00_axis_aclk),
       .rst_n(s00_axis_aresetn)
);

core_easy_hw_block #(.DATA_WIDTH(8)) core_easy_hw_block_inst (

    .clk(s00_axis_aclk ), .rst(~s00_axis_aresetn),
    
    // input numbers
    .in_num_sw(in_num_sw), .in_num_ddr(in_dataout[7:0]),
    
    // input push button to send back data
    .btn(btn & m00_axis_tready), 
    .start(in_valid), // if the input fifo is not empty (valid==1) start 
        
    .out_led(out_led),  // status leds
    
    .sum(sum),      // 
    .send_data(send_data),
    
    .ready(in_enr) // I'm ready to read data from INPUT FIFO
    );


// output data 
assign m00_axis_tdata = sum;
assign m00_axis_tvalid = send_data;


assign m00_axis_tlast = send_data;

endmodule 