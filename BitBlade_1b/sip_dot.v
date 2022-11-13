`include "parameters.v"

module	sip_dot_2_2	( i_Act, i_Weight, i_SignI, o_sip_dot );
parameter B = 2;
input	[`BITS_ACT-1:0]	i_Act;
input	[`BITS_WEIGHT-1:0]	i_Weight;
input	i_SignI;
output	[`BITS_DOT-1:0]	o_sip_dot;

genvar i;
generate
	for (i=0;i<`N_DOT;i=i+1) begin: sip_dot_dot_forloop_2_2
	   MUL_and_2_2 mul ( .I(i_Act[i]), .W(i_Weight[i]), .SignI(i_SignI), .MUL(o_sip_dot[`BITS_MUL*i +: `BITS_MUL]) );
	end
endgenerate
endmodule

module	sip_dot_1_1 ( i_Act, i_Weight, o_sip_dot );
input	[`BITS_ACT-1:0]	i_Act;
input	[`BITS_WEIGHT-1:0]	i_Weight;
output	[`BITS_DOT-1:0]	o_sip_dot;

genvar i;
generate
	for (i=0;i<`N_DOT;i=i+1) begin: sip_dot_dot_forloop_1_1
		assign o_sip_dot[`BITS_MUL*i +: `BITS_MUL] = {0, i_Act[i] & i_Weight[i]};
	end
endgenerate
endmodule

module	sip_dot_adder_2 ( i_sip_dot, o_sip_dot_adder );
input	[`BITS_DOT-1:0]	i_sip_dot;
output	signed	[`BITS_SIP_DOT_ADDER-1:0]	o_sip_dot_adder;

wire	signed	[`BITS_MUL-1:0]	i_sip_dot_vector	[0:`N_DOT-1];

wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dotadd;

genvar i;
generate
for (i=0;i<`N_DOT;i=i+1)	begin: i_sip_dot_forloop
	assign	i_sip_dot_vector[i]	= i_sip_dot[`BITS_MUL*i +: `BITS_MUL];
end
endgenerate

assign	o_sip_dot_adder	= sip_dotadd;

assign sip_dotadd = 
  ((((i_sip_dot_vector[0] + i_sip_dot_vector[1]) + (i_sip_dot_vector[2] + i_sip_dot_vector[3])) + ((i_sip_dot_vector[4] + i_sip_dot_vector[5]) + (i_sip_dot_vector[6] + i_sip_dot_vector[7])))
  + (((i_sip_dot_vector[8] + i_sip_dot_vector[9]) + (i_sip_dot_vector[10] + i_sip_dot_vector[11])) + ((i_sip_dot_vector[12] + i_sip_dot_vector[13]) + (i_sip_dot_vector[14] + i_sip_dot_vector[15]))))
  + ((((i_sip_dot_vector[16] + i_sip_dot_vector[17]) + (i_sip_dot_vector[18] + i_sip_dot_vector[19])) + ((i_sip_dot_vector[20] + i_sip_dot_vector[21]) + (i_sip_dot_vector[22] + i_sip_dot_vector[23])))
  + (((i_sip_dot_vector[24] + i_sip_dot_vector[25]) + (i_sip_dot_vector[26] + i_sip_dot_vector[27])) + ((i_sip_dot_vector[28] + i_sip_dot_vector[29]) + (i_sip_dot_vector[30] + i_sip_dot_vector[31]))));
  /*
  + i_sip_dot_vector[32] + i_sip_dot_vector[33] + i_sip_dot_vector[34] + i_sip_dot_vector[35] + i_sip_dot_vector[36] + i_sip_dot_vector[37] + i_sip_dot_vector[38] + i_sip_dot_vector[39]
  + i_sip_dot_vector[40] + i_sip_dot_vector[41] + i_sip_dot_vector[42] + i_sip_dot_vector[43] + i_sip_dot_vector[44] + i_sip_dot_vector[45] + i_sip_dot_vector[46] + i_sip_dot_vector[47]
  + i_sip_dot_vector[48] + i_sip_dot_vector[49] + i_sip_dot_vector[50] + i_sip_dot_vector[51] + i_sip_dot_vector[52] + i_sip_dot_vector[53] + i_sip_dot_vector[54] + i_sip_dot_vector[55]
  + i_sip_dot_vector[56] + i_sip_dot_vector[57] + i_sip_dot_vector[58] + i_sip_dot_vector[59] + i_sip_dot_vector[60] + i_sip_dot_vector[61] + i_sip_dot_vector[62] + i_sip_dot_vector[63];
  */
endmodule

module	sip_dot_adder_1 ( i_sip_dot, o_sip_dot_adder );
input	[`N_DOT-1:0]	i_sip_dot;
output	signed	[`BITS_SIP_DOT_ADDER-1:0]	o_sip_dot_adder;

wire [`N_DOT-1:0] i_sip_dot_vector;

assign o_sip_dot_adder[7] = 1'b0;
assign o_sip_dot_adder[6:0] = 
  ((((i_sip_dot_vector[0] + i_sip_dot_vector[1]) + (i_sip_dot_vector[2] + i_sip_dot_vector[3])) + ((i_sip_dot_vector[4] + i_sip_dot_vector[5]) + (i_sip_dot_vector[6] + i_sip_dot_vector[7])))
  + (((i_sip_dot_vector[8] + i_sip_dot_vector[9]) + (i_sip_dot_vector[10] + i_sip_dot_vector[11])) + ((i_sip_dot_vector[12] + i_sip_dot_vector[13]) + (i_sip_dot_vector[14] + i_sip_dot_vector[15]))))
  + ((((i_sip_dot_vector[16] + i_sip_dot_vector[17]) + (i_sip_dot_vector[18] + i_sip_dot_vector[19])) + ((i_sip_dot_vector[20] + i_sip_dot_vector[21]) + (i_sip_dot_vector[22] + i_sip_dot_vector[23])))
  + (((i_sip_dot_vector[24] + i_sip_dot_vector[25]) + (i_sip_dot_vector[26] + i_sip_dot_vector[27])) + ((i_sip_dot_vector[28] + i_sip_dot_vector[29]) + (i_sip_dot_vector[30] + i_sip_dot_vector[31]))));
  /*
  + i_sip_dot_vector[32] + i_sip_dot_vector[33] + i_sip_dot_vector[34] + i_sip_dot_vector[35] + i_sip_dot_vector[36] + i_sip_dot_vector[37] + i_sip_dot_vector[38] + i_sip_dot_vector[39]
  + i_sip_dot_vector[40] + i_sip_dot_vector[41] + i_sip_dot_vector[42] + i_sip_dot_vector[43] + i_sip_dot_vector[44] + i_sip_dot_vector[45] + i_sip_dot_vector[46] + i_sip_dot_vector[47]
  + i_sip_dot_vector[48] + i_sip_dot_vector[49] + i_sip_dot_vector[50] + i_sip_dot_vector[51] + i_sip_dot_vector[52] + i_sip_dot_vector[53] + i_sip_dot_vector[54] + i_sip_dot_vector[55]
  + i_sip_dot_vector[56] + i_sip_dot_vector[57] + i_sip_dot_vector[58] + i_sip_dot_vector[59] + i_sip_dot_vector[60] + i_sip_dot_vector[61] + i_sip_dot_vector[62] + i_sip_dot_vector[63];
  */
endmodule