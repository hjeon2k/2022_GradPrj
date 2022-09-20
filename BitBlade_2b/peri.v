module	MUL_reconfigurable_2_2 ( A, B, SignI, SignW, MUL );
input	A, B;
input 	SignI, 	SignW;
output	[3:0]	MUL;
wire 	[5:0] 	PP;

wire 	[1:0] 	A_Ext, B_Ext;
assign 	A_Ext	= {SignI & A, A};
assign 	B_Ext	= {SignW & B, B};

assign 	PP[0]	= A_Ext[0]	& B_Ext[0];
assign	PP[1]	= ~ ( A_Ext[1] 	& B_Ext[0] );
assign 	PP[2] 	= 1'b1;
assign 	PP[3] 	= ~ ( A_Ext[0]	& B_Ext[1] );
assign 	PP[4] 	= A_Ext[1]	& B_Ext[1];
assign 	PP[5] 	= 1'b1;

wire	n0, n1, n2, n3;
assign 	MUL[0] 	= PP[0];
ADDH_X1M_A9TR 	HA_0 	( .A(PP[1]),	.B(PP[3]),	.S(MUL[1]),	.CO(n0) );
ADDF_X1M_A9TR 	FA_0 	( .A(PP[4]), 	.B(PP[2]), 	.CI(n0),	.S(MUL[2]),	.CO(n1) );
ADDH_X1M_A9TR	HA_1	( .A(PP[5]), 	.B(n1),	.S(MUL[3]),	.CO(n2) );
endmodule

module	DFFQ #(parameter WIDTH=32)( CLK, D, Q );
input	CLK;
input		[WIDTH-1:0] 	D;
output	reg	[WIDTH-1:0] 	Q;

always @(posedge CLK)	Q <= D;

endmodule

module	DFFQF #(parameter WIDTH=32)( CLK, F, D, Q );
input	CLK;
input	F;
input		[WIDTH-1:0] 	D;
output	reg	[WIDTH-1:0] 	Q;

always @(posedge CLK) begin
	if (F)	Q <= {WIDTH{1'b0}};
	else		Q <= D;
end

endmodule

module	BUF_PSUM_RST #(parameter WIDTH=32)( CLK, RST, D, Q );
input	CLK;
input	RST;
input		[WIDTH-1:0] 	D;
output	reg	[WIDTH-1:0] 	Q;

always @(posedge CLK, posedge RST) begin
	if (RST)	Q <= {WIDTH{1'b0}};
	else		Q <= D;
end

endmodule

module prng #(parameter WIDTH=32)(
		input CLK, RST, 
		output reg [WIDTH-1:0] Y
);

	reg [WIDTH-1:0] S;
	always @(*) begin
		if (RST)
			S <= {WIDTH{1'b0}};
		else begin
			S[WIDTH-1:1] <= Y[WIDTH-2:0];
			S[0] <= ~(Y[0] ^ Y[5] ^ Y[7]);
		end
	end
	
	always @(posedge CLK, posedge RST) begin
		if (RST)
			Y <= {WIDTH{1'b0}};
		else 
			Y <= S;
	end
endmodule	

module prng2 #(parameter WIDTH=32)(
		input CLK, RST, 
		output reg [WIDTH-1:0] Y
);

	reg [WIDTH-1:0] S;
	always @(*) begin
		if (RST)
			S <= {WIDTH{1'b0}};
		else begin
			S[WIDTH-1:1] <= Y[WIDTH-2:0];
			S[0] <= ~(Y[1] ^ Y[4] ^ Y[6]);
		end
	end
	
	always @(posedge CLK, posedge RST) begin
		if (RST)
			Y <= {WIDTH{1'b0}};
		else 
			Y <= S;
	end
endmodule	
