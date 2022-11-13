`include "parameters.v"

module pe_2_2	( CLK, Input_Feature, Weight, i_BF, i_SignI, Output_PSUM );
input	CLK;
input	[`BITS_ACT-1:0]	Input_Feature;
input	[`BITS_WEIGHT-1:0]	Weight;
input [1:0] i_BF;
input	i_SignI;
output 	signed	[`BITS_SIP_DOT_ADDER-1:0]	Output_PSUM;

wire	[`BITS_DOT-1:0]	Dot_Product;

sip_dot_2_2	sip_dot_2	( .i_Act(Input_Feature), .i_Weight(Weight), .i_SignI(i_SignI), .o_sip_dot(Dot_Product) );
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_add;
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_bf;
sip_dot_adder_2	sip_dot_adder2	( .i_sip_dot(Dot_Product), .o_sip_dot_adder(sip_dot_add) );
sip_dot_adder_1	sip_dot_adder_bf( .i_sip_dot(Input_Feature&{`BITS_ACT{i_BF[0]}}), .o_sip_dot_adder(sip_dot_bf) );
wire    signed  [`BITS_SIP_DOT_ADDER-1:0] sip_dot_add_bf;
assign sip_dot_add_bf = ((sip_dot_add<<i_BF[0])-sip_dot_bf)<<i_BF[1];

DFFQ	#(`BITS_SIP_DOT_ADDER)	DFFQ_SIP_DOT_ADD	( .CLK(CLK), .D(sip_dot_add_bf), .Q(Output_PSUM) );
//assign	Output_PSUM	= sip_dot_add;
endmodule

module pe_1_1	( CLK, Input_Feature, Weight, i_BF, Output_PSUM );
input	CLK;
input	[`BITS_ACT-1:0]	Input_Feature;
input	[`BITS_WEIGHT-1:0]	Weight;
input [1:0] i_BF;
output 	signed	[`BITS_SIP_DOT_ADDER-1:0]	Output_PSUM;

wire	[`N_DOT-1:0]	Dot_Product;
sip_dot_1_1	sip_dot_1	( .i_Act(Input_Feature), .i_Weight(Weight), .o_sip_dot(Dot_Product) );
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_add;
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_bf;
sip_dot_adder_1	sip_dot_adder1	( .i_sip_dot(Dot_Product), .o_sip_dot_adder(sip_dot_add) );
sip_dot_adder_1	sip_dot_adder_bf( .i_sip_dot(Input_Feature&{`BITS_ACT{i_BF[0]}}), .o_sip_dot_adder(sip_dot_bf) );
assign sip_dot_add_bf = ((sip_dot_add<<i_BF[0])-sip_dot_bf)<<i_BF[1];

DFFQ	#(`BITS_SIP_DOT_ADDER)	DFFQ_SIP_DOT_ADD	( .CLK(CLK), .D(sip_dot_add_bf), .Q(Output_PSUM) );
//assign	Output_PSUM	= sip_dot_add;
endmodule
