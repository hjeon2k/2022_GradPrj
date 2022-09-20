module accumulator	( i_Sel_Bias_BUF, Bias_BUF, PSUM_Q, PSUM_SHIFT_MERGE, PSUM_D );
input	i_Sel_Bias_BUF;
input	signed	[`N_BIAS-1:0]	Bias_BUF;
input	signed	[`BITS_PSUM-1:0]	PSUM_Q;
input	signed	[`BITS_PSUM_SHIFT-1:0]	PSUM_SHIFT_MERGE;
output	signed	[`BITS_PSUM-1:0]	PSUM_D;

assign	PSUM_D	= ( i_Sel_Bias_BUF ? Bias_BUF : PSUM_Q ) + PSUM_SHIFT_MERGE;

endmodule
