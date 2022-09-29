`include "../source/parameters.v"

module result_quantized ( CLK, RST, core_Done, core_Psum, layer_num, next_i_precision, shift, o_Vld, o_Data);

parameter DATA_WIDTH = 28;
parameter MAX_INPUT_WIDTH = 16;

input	CLK, RST;
input core_Done;
input [`BITS_PSUM*`PE_ARRAY-1:0] core_Psum;
input [4:0] layer_num;
input [1:0] next_i_precision; // next input feature precision
input [3:0] shift;
output o_Vld;
output [8*MAX_INPUT_WIDTH-1:0] o_Data;

act_quant_wrapper #(.DATA_WIDTH(DATA_WIDTH), .MAX_INPUT_WIDTH(MAX_INPUT_WIDTH)) u_act_quant_wrapper(.clk(CLK), .rstn(RST), .din(core_Psum), .fmap_precision(next_i_precision), .shift(shift), .vld_i(core_Done), .layer_num(layer_num), .data_o(o_Data), .vld_o(o_Vld));

endmodule
