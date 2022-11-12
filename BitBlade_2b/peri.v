module	DFFQ #(parameter WIDTH=32)( CLK, D, Q );
input	CLK;
input		[WIDTH-1:0] 	D;
output	reg	[WIDTH-1:0] 	Q;

always @(posedge CLK)	Q <= D;

endmodule
/*
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
*/