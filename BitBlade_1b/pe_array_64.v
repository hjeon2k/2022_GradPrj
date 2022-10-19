`include "parameters.v"

module pe_array_64 ( CLK, RST, i_Act, i_Weight, i_Precision, i_Bias, i_Sel_Bias, i_Flush, core_vld, o_Done, o_Psum );
input	CLK, RST;
input	[`BITS_ACT*`PE_ROW-1:0]	i_Act;
input	[`BITS_WEIGHT*`PE_ROW-1:0]	i_Weight;
input	[3:0]	i_Precision;
input	signed	[`N_BIAS-1:0]	i_Bias;
input	i_Sel_Bias;
input	i_Flush;
input   core_vld;
output	signed	[`BITS_PSUM-1:0]	o_Psum;
output reg o_Done;

wire	[`BITS_ACT*`PE_ROW-1:0]	Act_BUF, Act_MUX, Act_TR;
wire	[`BITS_WEIGHT*`PE_ROW-1:0]	Weight_BUF, Weight_MUX, Weight_TR;
wire	signed	[`N_BIAS-1:0]	Bias_BUF;

reg	[`PE_ROW-1:0] SignI, SignW;
wire	signed	[`BITS_SIP_DOT_ADDER-1:0]	PSUM	[0:`PE_ROW-1];
reg	signed	[`BITS_PSUM_SHIFT-1:0]	PSUM_SHIFT	[0:`PE_ROW-1];
DFFQ	#(`N_BIAS)	DFFQ_BIAS_BUF	( .CLK(CLK),	.D(i_Bias),	.Q(Bias_BUF) );
wire	i_Sel_Bias_BUF;
DFFQ	#(1)	DFFQ_SEL_BIAS_BUF	( .CLK(CLK),	.D(i_Sel_Bias),	.Q(i_Sel_Bias_BUF) );
wire	i_Flush_BUF;
DFFQ	#(1)	DFFQ_FLUSH_BUF	( .CLK(CLK),	.D(i_Flush),	.Q(i_Flush_BUF) );
wire	core_vld_BUF;
DFFQ	#(1)	DFFQ_VLD_BUF	( .CLK(CLK),	.D(core_vld),	.Q(core_vld_BUF) );

genvar i;
generate
for (i=0;i<`N_DOT;i=i+1) begin: pe_forloop
	DFFQ	#(`MUX_FUS)	DFFQ_ACT_BUF	( .CLK(CLK), .D(i_Act[`MUX_FUS*i +: `MUX_FUS]), .Q(Act_BUF[`MUX_FUS*i +: `MUX_FUS]) );
	DFFQ	#(`MUX_FUS)	DFFQ_WEIGHT_BUF	( .CLK(CLK), .D(i_Weight[`MUX_FUS*i +: `MUX_FUS]), .Q(Weight_BUF[`MUX_FUS*i +: `MUX_FUS]) );

	mux_fusion_1b	MUX_FUSION  ( .Precision(i_Precision), .I(i_Act[`MUX_FUS*i +: `MUX_FUS]), .W(i_Weight[`MUX_FUS*i +: `MUX_FUS]), .I_MUX(Act_MUX[`MUX_FUS*i +: `MUX_FUS]), .W_MUX(Weight_MUX[`MUX_FUS*i +: `MUX_FUS]) );
end
endgenerate

genvar j;
generate
for (i=0;i<`PE_ROW;i=i+1) begin: transpose_forloop
	for (j=0;j<`N_DOT;j=j+1) begin: transpose_dot_forloop
		assign	Act_TR[`BITS_PARALLEL*(i*`N_DOT+j) +: `BITS_PARALLEL]	= Act_MUX[`BITS_PARALLEL*(j*16+i) +: `BITS_PARALLEL];
		assign	Weight_TR[`BITS_PARALLEL*(i*`N_DOT+j) +: `BITS_PARALLEL]	= Weight_MUX[`BITS_PARALLEL*(j*16+i) +: `BITS_PARALLEL];
	end
	pe	PE_MODULE	( .CLK(CLK), .Input_Feature(Act_TR[`BITS_ACT*i +: `BITS_ACT]), .Weight(Weight_TR[`BITS_WEIGHT*i +: `BITS_WEIGHT]), .i_SignI(SignI[i]), .i_SignW(SignW[i]), .Output_PSUM(PSUM[i]) ); 
end
endgenerate

wire	signed	[`BITS_PSUM_SHIFT-1:0]	PSUM_SHIFT_MERGE;
assign PSUM_SHIFT_MERGE = PSUM_SHIFT[0] + PSUM_SHIFT[1] + PSUM_SHIFT[2] + PSUM_SHIFT[3] + PSUM_SHIFT[4] + PSUM_SHIFT[5] + PSUM_SHIFT[6] + PSUM_SHIFT[7] + PSUM_SHIFT[8] + PSUM_SHIFT[9] + PSUM_SHIFT[10] + PSUM_SHIFT[11] + PSUM_SHIFT[12] + PSUM_SHIFT[13] + PSUM_SHIFT[14] + PSUM_SHIFT[15] ;

wire	signed	[`BITS_PSUM-1:0]	PSUM_D, PSUM_Q;
//assign	PSUM_D	= ( i_Sel_Bias_BUF ? Bias_BUF : PSUM_Q ) + PSUM_SHIFT_MERGE;
accumulator	ACCU_PSUM	( .i_Sel_Bias_BUF(i_Sel_Bias_BUF), .Bias_BUF(Bias_BUF), .PSUM_Q(PSUM_Q), .i_Flush(i_Flush_BUF), .PSUM_SHIFT_MERGE(PSUM_SHIFT_MERGE), .core_vld(core_vld_BUF), .PSUM_D(PSUM_D) );
DFFQ	#(`BITS_PSUM)	DFFQ_PSUM	( .CLK(CLK), .D(PSUM_D), .Q(PSUM_Q) );
assign	o_Psum	= PSUM_Q;

always @(posedge CLK) o_Done <= i_Sel_Bias_BUF;

// PE Sign Configuration
always @(*) begin
	case (i_Precision)
		default: begin
			SignI <= 16'd0;
			SignW <= 16'd0;
		end
		4'b00_00: begin // 1b 1b
			SignI <= 16'd0;
			SignW <= 16'd0;
		end
		4'b01_00: begin // 2b 1b
			SignI <= 16'b1010_1010_1010_1010;
			SignW <= 16'd0;
		end
		4'b00_01: begin // 1b 2b
			SignI <= 16'd0;
			SignW <= 16'b1010_1010_1010_1010;
		end
		4'b10_00: begin // 4b 1b
			SignI <= 16'b1000_1000_1000_1000;
			SignW <= 16'd0;
		end
		4'b00_10: begin // 1b 4b
			SignI <= 16'd0;
			SignW <= 16'b1000_1000_1000_1000;
		end
		4'b01_01: begin // 2b 2b
			SignI <= 16'b1100_1100_1100_1100;
			SignW <= 16'b1010_1010_1010_1010;
		end
		4'b10_01: begin // 4b 2b
			SignI <= 16'b1000_1000_1000_1000;
			SignW <= 16'b1111_0000_1111_0000;
		end
		4'b01_10: begin // 2b 4b
			SignI <= 16'b1111_0000_1111_0000;
			SignW <= 16'b1000_1000_1000_1000;
		end
		4'b10_10: begin // 4b 4b 
			SignI <= 16'b1111_0000_0000_0000;
			SignW <= 16'b1000_1000_1000_1000;
		end
	endcase
end

// PSUM Shift
always @(*) begin
	case (i_Precision)
	  default: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1];
			PSUM_SHIFT[2]	<= PSUM[2];
			PSUM_SHIFT[3]	<= PSUM[3];
			PSUM_SHIFT[4]	<= PSUM[4];
			PSUM_SHIFT[5]	<= PSUM[5];
			PSUM_SHIFT[6]	<= PSUM[6];
			PSUM_SHIFT[7]	<= PSUM[7];
			PSUM_SHIFT[8]	<= PSUM[8];
			PSUM_SHIFT[9]	<= PSUM[9];
			PSUM_SHIFT[10]	<= PSUM[10];
			PSUM_SHIFT[11]	<= PSUM[11];
			PSUM_SHIFT[12]	<= PSUM[12];
			PSUM_SHIFT[13]	<= PSUM[13];
			PSUM_SHIFT[14]	<= PSUM[14];
			PSUM_SHIFT[15]	<= PSUM[15];
		end
	4'b00_00: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1];
			PSUM_SHIFT[2]	<= PSUM[2];
			PSUM_SHIFT[3]	<= PSUM[3];
			PSUM_SHIFT[4]	<= PSUM[4];
			PSUM_SHIFT[5]	<= PSUM[5];
			PSUM_SHIFT[6]	<= PSUM[6];
			PSUM_SHIFT[7]	<= PSUM[7];
			PSUM_SHIFT[8]	<= PSUM[8];
			PSUM_SHIFT[9]	<= PSUM[9];
			PSUM_SHIFT[10]	<= PSUM[10];
			PSUM_SHIFT[11]	<= PSUM[11];
			PSUM_SHIFT[12]	<= PSUM[12];
			PSUM_SHIFT[13]	<= PSUM[13];
			PSUM_SHIFT[14]	<= PSUM[14];
			PSUM_SHIFT[15]	<= PSUM[15];
		end
		4'b01_00, 4'b00_01: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1] << 1;
			PSUM_SHIFT[2]	<= PSUM[2];
			PSUM_SHIFT[3]	<= PSUM[3] << 1;
			PSUM_SHIFT[4]	<= PSUM[4];
			PSUM_SHIFT[5]	<= PSUM[5] << 1;
			PSUM_SHIFT[6]	<= PSUM[6];
			PSUM_SHIFT[7]	<= PSUM[7] << 1;
			PSUM_SHIFT[8]	<= PSUM[8];
			PSUM_SHIFT[9]	<= PSUM[9] << 1;
			PSUM_SHIFT[10]	<= PSUM[10];
			PSUM_SHIFT[11]	<= PSUM[11] << 1;
			PSUM_SHIFT[12]	<= PSUM[12];
			PSUM_SHIFT[13]	<= PSUM[13]	<< 1;
			PSUM_SHIFT[14]	<= PSUM[14];
			PSUM_SHIFT[15]	<= PSUM[15]	<< 1;
		end
		4'b10_00, 4'b00_10, 4'b01_01: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1] << 1;
			PSUM_SHIFT[2]	<= PSUM[2] << 2;
			PSUM_SHIFT[3]	<= PSUM[3] << 3;
			PSUM_SHIFT[4]	<= PSUM[4];
			PSUM_SHIFT[5]	<= PSUM[5] << 1;
			PSUM_SHIFT[6]	<= PSUM[6] << 2;
			PSUM_SHIFT[7]	<= PSUM[7] << 3;
			PSUM_SHIFT[8]	<= PSUM[8];
			PSUM_SHIFT[9]	<= PSUM[9] << 1;
			PSUM_SHIFT[10]	<= PSUM[10] << 2;
			PSUM_SHIFT[11]	<= PSUM[11] << 3;
			PSUM_SHIFT[12]	<= PSUM[12];
			PSUM_SHIFT[13]	<= PSUM[13] << 1;
			PSUM_SHIFT[14]	<= PSUM[14] << 2;
			PSUM_SHIFT[15]	<= PSUM[15] << 3;
		end
		4'b01_10, 4'b10_01: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1] << 1;
			PSUM_SHIFT[2]	<= PSUM[2] << 2;
			PSUM_SHIFT[3]	<= PSUM[3] << 3;
			PSUM_SHIFT[4]	<= PSUM[4] << 1;
			PSUM_SHIFT[5]	<= PSUM[5] << 2;
			PSUM_SHIFT[6]	<= PSUM[6] << 3;
			PSUM_SHIFT[7]	<= PSUM[7] << 4;
			PSUM_SHIFT[8]	<= PSUM[8];
			PSUM_SHIFT[9]	<= PSUM[9] << 1;
			PSUM_SHIFT[10]	<= PSUM[10] << 2;
			PSUM_SHIFT[11]	<= PSUM[11] << 3;
			PSUM_SHIFT[12]	<= PSUM[12] << 1;
			PSUM_SHIFT[13]	<= PSUM[13] << 2;
			PSUM_SHIFT[14]	<= PSUM[14] << 3;
			PSUM_SHIFT[15]	<= PSUM[15] << 4;
		end
		4'b10_10: begin
			PSUM_SHIFT[0]	<= PSUM[0];
			PSUM_SHIFT[1]	<= PSUM[1] << 1;
			PSUM_SHIFT[2]	<= PSUM[2] << 2;
			PSUM_SHIFT[3]	<= PSUM[3] << 3;
			PSUM_SHIFT[4]	<= PSUM[4] << 1;
			PSUM_SHIFT[5]	<= PSUM[5] << 2;
			PSUM_SHIFT[6]	<= PSUM[6] << 3;
			PSUM_SHIFT[7]	<= PSUM[7] << 4;
			PSUM_SHIFT[8]	<= PSUM[8] << 2;
			PSUM_SHIFT[9]	<= PSUM[9] << 3;
			PSUM_SHIFT[10]	<= PSUM[10] << 4;
			PSUM_SHIFT[11]	<= PSUM[11] << 5;
			PSUM_SHIFT[12]	<= PSUM[12] << 3;
			PSUM_SHIFT[13]	<= PSUM[13] << 4;
			PSUM_SHIFT[14]	<= PSUM[14] << 5;
			PSUM_SHIFT[15]	<= PSUM[15] << 6;
		end
	endcase
end

endmodule
