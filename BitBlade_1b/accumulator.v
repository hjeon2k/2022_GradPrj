`include "../source/parameters.v"

module accumulator	( i_Sel_Bias_BUF, Bias_BUF, i_Flush, PSUM_Q, PSUM_SHIFT_MERGE, core_vld, PSUM_D );
input	i_Sel_Bias_BUF;
input	signed	[`N_BIAS-1:0]	Bias_BUF;
input	signed	[`BITS_PSUM-1:0]	PSUM_Q;
input	signed	[`BITS_PSUM_SHIFT-1:0]	PSUM_SHIFT_MERGE;
input  core_vld;
input i_Flush;
output	signed	[`BITS_PSUM-1:0]	PSUM_D;

wire signed [`BITS_PSUM-1:0] PSUM_D_unbiased;
assign PSUM_D_unbiased = ( core_vld ? PSUM_SHIFT_MERGE : 0 ) + ( i_Flush ? 0 : PSUM_Q );
wire signed [`BITS_PSUM-1:0] PSUM_D_shifted;
`ifdef R_MULT
assign PSUM_D_shifted = $signed($signed(PSUM_D_unbiased)>>>`R_MULT_LOG) + &({PSUM_D_unbiased[`BITS_PSUM-1], (|PSUM_D_unbiased[`R_MULT_LOG-1:0])});
`endif
`ifndef R_MULT
assign PSUM_D_shifted = PSUM_D_unbiased;
`endif
assign PSUM_D = i_Sel_Bias_BUF ? $signed(PSUM_D_shifted) + $signed(Bias_BUF) : PSUM_D_unbiased;

// assign	PSUM_D	= ( core_vld ? PSUM_SHIFT_MERGE : 0 ) + ( i_Sel_Bias_BUF ? Bias_BUF : 0 ) + ( i_Flush ? 0 : PSUM_Q );
                

endmodule