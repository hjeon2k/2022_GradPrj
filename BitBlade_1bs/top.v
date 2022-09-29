`include "../source/parameters.v"

module core_top( CLK, RST, i_Act, i_Weight, i_Precision, w_Precision, i_Bias, i_Sel_Bias, i_Flush, layer_num, next_i_precision, next_i_precision_small, shift, core_vld, buf_base_addr, buf_base_addr_small, o_row, o_col, buf_ena_0, buf_addr_0, buf_wea_select_0, buf_wea_byte_0, buf_din_0, buf_ena_1, buf_addr_1, buf_wea_select_1, buf_wea_byte_1, buf_din_1, layer_done);

parameter DATA_WIDTH = 28;
parameter MAX_INPUT_WIDTH = 16;
parameter NUM_PIXEL=4;
parameter NUM_WEIGHT=4;
parameter DW=256;

input CLK, RST;
input [`BITS_ACT*`PE_ROW*4-1:0] i_Act;
input [`BITS_WEIGHT*`PE_ROW*4-1:0] i_Weight;
input [1:0]	i_Precision;
input [1:0]	w_Precision;
input signed [`N_BIAS*`PE_ARRAY-1:0] i_Bias; // 8bit 16 bias
input i_Sel_Bias;
input i_Flush;
input [4:0] layer_num;
input [1:0] next_i_precision; // next input feature precision
input [1:0] next_i_precision_small; // layer 19 input feature precision
input [3:0] shift;
input core_vld;
input [9:0] buf_base_addr;
input [9:0] buf_base_addr_small;
output [8:0] o_row;
output [8:0] o_col;
output buf_ena_0;
output [159:0] buf_addr_0;
output [15:0] buf_wea_select_0;
output [DW*2-1:0] buf_wea_byte_0;
output [DW*16-1:0] buf_din_0;
output buf_ena_1;
output [159:0] buf_addr_1;
output [15:0] buf_wea_select_1;
output [DW*2-1:0] buf_wea_byte_1;
output [DW*16-1:0] buf_din_1;
output layer_done;

wire o_Done_wire;
wire [`BITS_PSUM*`PE_ARRAY-1:0] o_Psum_wire;
wire o_Vld_wire;
wire [8*MAX_INPUT_WIDTH-1:0] o_Data_wire;
wire [8*MAX_INPUT_WIDTH-1:0] o_Data_small_wire;
wire [8:0] o_row_wire;
wire [8:0] o_col_wire;
wire [8:0] ch_count;
wire [1:0] o_pixel_count_wire;
wire [NUM_WEIGHT*NUM_PIXEL*8-1:0] pool_result_wire;
wire rs_vld_wire;
wire pool_done_wire;
wire [1:0] next_prec_wire;
wire [4:0] next_layer_num_wire;
wire no_connect;

wire buf_ena_0_wire;
wire [159:0] buf_addr_0_wire;
wire [15:0] buf_wea_select_0_wire;
wire [DW*2-1:0] buf_wea_byte_0_wire;
wire [DW*16-1:0] buf_din_0_wire;
wire buf_ena_0_small;
wire [159:0] buf_addr_0_small;
wire [15:0] buf_wea_select_0_small;
wire [DW*2-1:0] buf_wea_byte_0_small;
wire [DW*16-1:0] buf_din_0_small;


assign buf_ena_0 = ((layer_num == 8) ? buf_ena_0_small : buf_ena_0_wire);
assign buf_wea_select_0 = ((layer_num == 8) ? buf_wea_select_0_small : buf_wea_select_0_wire);
assign buf_wea_byte_0 = ((layer_num == 8) ? buf_wea_byte_0_small : buf_wea_byte_0_wire);
assign buf_din_0 = ((layer_num == 8) ? buf_din_0_small : buf_din_0_wire);
assign buf_addr_0 = ((layer_num == 8) ? buf_addr_0_small : buf_addr_0_wire);

assign o_row = o_row_wire;
assign o_col = o_col_wire;

BBcore u_BBcore (.CLK(CLK), .RST(RST), .i_Act(i_Act), .i_Weight(i_Weight), .i_Precision(i_Precision), .w_Precision(w_Precision), .i_Bias(i_Bias), .i_Sel_Bias(i_Sel_Bias), .i_Flush(i_Flush), .core_vld(core_vld), .o_Done(o_Done_wire), .o_Psum(o_Psum_wire) );

result_quantized #(.DATA_WIDTH(DATA_WIDTH), .MAX_INPUT_WIDTH(MAX_INPUT_WIDTH)) u_result_quantized (.CLK(CLK), .RST(RST), .core_Done(o_Done_wire), .core_Psum(o_Psum_wire), .layer_num(layer_num), .next_i_precision(next_i_precision), .shift(shift), .o_Vld(o_Vld_wire), .o_Data(o_Data_wire) );

result_quantized #(.DATA_WIDTH(DATA_WIDTH), .MAX_INPUT_WIDTH(MAX_INPUT_WIDTH)) u_result_quantized_small (.CLK(CLK), .RST(RST), .core_Done(o_Done_wire), .core_Psum(o_Psum_wire), .layer_num(layer_num), .next_i_precision(next_i_precision_small), .shift(shift), .o_Vld(no_connect), .o_Data(o_Data_small_wire) );

pooling_wrapper u_pooling_wrapper (.clk(CLK), .rstn(RST), .vld_i(o_Vld_wire), .quant_result(o_Data_wire), .layer_num(layer_num), .next_precision(next_i_precision), .pool_result(pool_result_wire), .o_row(o_row_wire), .o_col(o_col_wire), .ch_count(ch_count), .o_pixel_count(o_pixel_count_wire), .vld_o(rs_vld_wire), .pool_done(pool_done_wire), .next_prec(next_prec_wire), .next_layer_num(next_layer_num_wire));

result_saver_dh u_result_saver_dh (.clk(CLK), .rstn(RST), .layer_num(next_layer_num_wire), .next_precision(next_prec_wire), .i_data(pool_result_wire), .i_row(o_row_wire), .i_col(o_col_wire), .channel(ch_count), .pixel_count(o_pixel_count_wire), .i_vld(rs_vld_wire), .buf_base_addr(buf_base_addr), .buf_ena_0(buf_ena_0_wire), .buf_addr_0(buf_addr_0_wire), .buf_wea_select_0(buf_wea_select_0_wire), .buf_wea_byte_0(buf_wea_byte_0_wire), .buf_din_0(buf_din_0_wire), .buf_ena_1(buf_ena_1), .buf_addr_1(buf_addr_1), .buf_wea_select_1(buf_wea_select_1), .buf_wea_byte_1(buf_wea_byte_1), .buf_din_1(buf_din_1), .layer_done(layer_done));

result_saver_small_dh u_result_saver_small_dh (.clk(CLK), .rstn(RST), .layer_num(next_layer_num_wire), .next_precision(next_prec_wire), .i_data(o_Data_small_wire), .i_row(o_row_wire), .i_col(o_col_wire), .channel(ch_count), .i_vld(rs_vld_wire), .buf_base_addr(buf_base_addr_small), .buf_ena_0(buf_ena_0_small), .buf_addr_0(buf_addr_0_small), .buf_wea_select_0(buf_wea_select_0_small), .buf_wea_byte_0(buf_wea_byte_0_small), .buf_din_0(buf_din_0_small));

endmodule
