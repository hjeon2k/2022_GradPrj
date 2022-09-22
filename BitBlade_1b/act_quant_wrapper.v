`timescale 1ns / 1ps

module act_quant_wrapper #(
    parameter DATA_WIDTH = 28,
    parameter MAX_INPUT_WIDTH = 16
)
(
    input clk,
    input rstn,
    input [DATA_WIDTH*MAX_INPUT_WIDTH-1:0] din,
    input [1:0] fmap_precision,
    input [3:0] shift,
    input vld_i,
    input [4:0] layer_num,
    output [8*MAX_INPUT_WIDTH-1:0] data_o,
    output vld_o
);

wire [MAX_INPUT_WIDTH-1:0] act_vld_o;

  genvar i;
  generate
      for(i=0; i<MAX_INPUT_WIDTH; i=i+1) begin:act
      wire linear = (layer_num == 13 || layer_num == 20) ? 1'b1 : 1'b0;
        act_quant_vp #(.DATA_WIDTH(DATA_WIDTH)) u_act_quant_vp(.clk(clk), .rstn(rstn), .din(din[i*DATA_WIDTH +: DATA_WIDTH]), .fmap_precision(fmap_precision), .shift(shift), . vld_i(vld_i), .linear(linear), .data_o(data_o[i*8 +: 8]), .vld_o(act_vld_o[i]));
      end
  endgenerate

//FOR DEBUG
wire [DATA_WIDTH-1:0] din_debug = din[DATA_WIDTH-1:0];
wire [7:0] dout_debug = data_o[7:0];

assign vld_o = act_vld_o[0];
    
endmodule
