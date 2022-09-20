`include "../source/parameters.v"

module	sip_dot	( i_Act, i_Weight, i_SignI, i_SignW, o_sip_dot );
input	[`BITS_ACT-1:0]	i_Act;
input	[`BITS_WEIGHT-1:0]	i_Weight;
input	i_SignI, i_SignW;
output	[`BITS_DOT-1:0]	o_sip_dot;

genvar i;
generate
	for (i=0;i<`N_DOT;i=i+1) begin: sip_dot_dot_forloop
		//assign	o_sip_dot[i]	= i_Act[i] & i_Weight[i];
		MUL_reconfigurable_3_3 mul ( .A(i_Act[`BITS_PARALLEL*i +: `BITS_PARALLEL]), .B(i_Weight[`BITS_PARALLEL*i +: `BITS_PARALLEL]), .SignI(i_SignI), .SignW(i_SignW), .MUL(o_sip_dot[`BITS_MUL*i +: `BITS_MUL]) );
	end
endgenerate

endmodule

module	sip_dot_adder ( i_sip_dot, o_sip_dot_adder );
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

assign sip_dotadd = i_sip_dot_vector[0] + i_sip_dot_vector[1] + i_sip_dot_vector[2] + i_sip_dot_vector[3] + i_sip_dot_vector[4] + i_sip_dot_vector[5] + i_sip_dot_vector[6] + i_sip_dot_vector[7] + i_sip_dot_vector[8] + i_sip_dot_vector[9] + i_sip_dot_vector[10] + i_sip_dot_vector[11] + i_sip_dot_vector[12] + i_sip_dot_vector[13] + i_sip_dot_vector[14] + i_sip_dot_vector[15];

endmodule
