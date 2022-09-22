`include "../source/parameters.v"

module BBcore ( CLK, RST, i_Act, i_Weight, i_Precision, w_Precision, i_Bias, i_Sel_Bias, i_Flush, core_vld, o_Done, o_Psum );

input	CLK, RST;
input [`BITS_ACT*`PE_ROW*4-1:0] i_Act;
input [`BITS_WEIGHT*`PE_ROW*4-1:0] i_Weight;
input	[1:0]	i_Precision;
input	[1:0]	w_Precision;
input	signed	[`N_BIAS*`PE_ARRAY-1:0]	i_Bias; // 16 bias
input	i_Sel_Bias;
input	i_Flush;
input core_vld;
output o_Done
output [`BITS_PSUM*`PE_ARRAY-1:0] o_Psum;

wire [`PE_ARRAY-1:0] o_Done_pe;
wire [3:0] Precision;
  
assign Precision = {i_Precision, w_Precision};
assign o_Done = o_Done_pe[0];

genvar i;
generate
  for (i=0; i<`PE_ARRAY; i=i+1) begin: pe_array_forloop
    pe_array_64 PE_64 ( .CLK(CLK), .RST(RST), .i_Act(i_Act[`BITS_ACT*`PE_ROW*(i%4) +:`BITS_ACT*`PE_ROW]), .i_Weight(i_Weight[`BITS_WEIGHT*`PE_ROW*(i/4) +:`BITS_WEIGHT*`PE_ROW]), .i_Precision(Precision), .i_Bias(i_Bias[`N_BIAS*i +: `N_BIAS]), .i_Sel_Bias(i_Sel_Bias), .i_Flush(i_Flush), .core_vld(core_vld), .o_Done(o_Done_pe[i]), .o_Psum(o_Psum[`BITS_PSUM*i +: `BITS_PSUM]) );
  end
endgenerate
endmodule
