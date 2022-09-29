module MUL_custom_2_2 (I, W, SignI, SignW, MUL);
  input I, W;
  input SignI, Sign@;
  output [1:0] MUL;

  assign MUL = {I & W & SignI, I & W};

endmodule

module	MUL_reconfigurable_3_3 ( A, B, SignI, SignW, MUL );
input	[1:0] 	A, B;
input 	SignI, 	SignW;
output	[5:0]	MUL;
wire 	[10:0] 	PP;

wire 	[2:0] 	A_Ext, B_Ext;
assign 	A_Ext	= {SignI & A[1], A[1:0]};
assign 	B_Ext	= {SignW & B[1], B[1:0]};

assign 	PP[0]	= A_Ext[0]	& B_Ext[0];
assign 	PP[1]	= A_Ext[1]	& B_Ext[0];
assign	PP[2]	= ~ ( A_Ext[2] 	& B_Ext[0] );
assign 	PP[3] 	= 1'b1;
assign 	PP[4] 	= A_Ext[0]	& B_Ext[1];
assign 	PP[5] 	= A_Ext[1]	& B_Ext[1];
assign	PP[6]	= ~ ( A_Ext[2] 	& B_Ext[1] );
assign	PP[7]	= ~ ( A_Ext[0] 	& B_Ext[2] );
assign	PP[8]	= ~ ( A_Ext[1] 	& B_Ext[2] );
assign 	PP[9] 	= A_Ext[2]	& B_Ext[2];
assign 	PP[10] 	= 1'b1;

wire 	HA_0_CO, FA_0_S, FA_0_CO, HA_1_CO, FA_1_S, FA_1_CO, FA_2_CO, FA_3_CO;

wire	NOCONNECT;
assign 	MUL[0] 	= PP[0];
half_adder 	HA_0 	( .A(PP[1]),	.B(PP[4]),	.S(MUL[1]),	.CO(HA_0_CO) );
full_adder 	FA_0 	( .A(PP[7]), 	.B(PP[5]), 	.CI(HA_0_CO),	.S(FA_0_S),	.CO(FA_0_CO) );
half_adder	HA_1	( .A(PP[2]), 	.B(FA_0_S),	.S(MUL[2]),	.CO(HA_1_CO) );
full_adder 	FA_1	( .A(PP[6]), 	.B(PP[8]),	.CI(FA_0_CO),	.S(FA_1_S),	.CO(FA_1_CO) );
full_adder	FA_2	( .A(PP[3]), 	.B(FA_1_S),	.CI(HA_1_CO), 	.S(MUL[3]), .CO(FA_2_CO) );
full_adder 	FA_3 	( .A(PP[9]), 	.B(FA_1_CO),	.CI(FA_2_CO), 	.S(MUL[4]),	.CO(FA_3_CO) );
half_adder	HA_2	( .A(PP[10]),	.B(FA_3_CO), 	.S(MUL[5]), .CO(NOCONNECT));
endmodule


