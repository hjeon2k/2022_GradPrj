`include "parameters.v"

module pe_2_2	( CLK, Input_Feature, Weight, i_SignI, Output_PSUM );
input	CLK;
input	[`BITS_ACT-1:0]	Input_Feature;
input	[`BITS_WEIGHT-1:0]	Weight;
input	i_SignI;
output 	signed	[`BITS_SIP_DOT_ADDER-1:0]	Output_PSUM;

wire	[`BITS_DOT-1:0]	Dot_Product;

sip_dot_2_2	sip_dot_2	( .i_Act(Input_Feature), .i_Weight(Weight), .i_SignI(i_SignI), .o_sip_dot(Dot_Product) );
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_add;
sip_dot_adder	sip_dot_adder	( .i_sip_dot(Dot_Product), .o_sip_dot_adder(sip_dot_add) );

DFFQ	#(`BITS_SIP_DOT_ADDER)	DFFQ_SIP_DOT_ADD	( .CLK(CLK), .D(sip_dot_add), .Q(Output_PSUM) );
//assign	Output_PSUM	= sip_dot_add;
endmodule

module pe_1_1	( CLK, Input_Feature, Weight, Output_PSUM );
input	CLK;
input	[`BITS_ACT-1:0]	Input_Feature;
input	[`BITS_WEIGHT-1:0]	Weight;
output 	signed	[`BITS_SIP_DOT_ADDER-1:0]	Output_PSUM;

wire	[`BITS_DOT-1:0]	Dot_Product;
sip_dot_1_1	sip_dot_1	( .i_Act(Input_Feature), .i_Weight(Weight), .o_sip_dot(Dot_Product) );
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	sip_dot_add;
sip_dot_adder	sip_dot_adder	( .i_sip_dot(Dot_Product), .o_sip_dot_adder(sip_dot_add) );

DFFQ	#(`BITS_SIP_DOT_ADDER)	DFFQ_SIP_DOT_ADD	( .CLK(CLK), .D(sip_dot_add), .Q(Output_PSUM) );
//assign	Output_PSUM	= sip_dot_add;
endmodule
