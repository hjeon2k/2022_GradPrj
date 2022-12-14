module mux_fusion_2b ( Precision, I, W, I_MUX, W_MUX );
input	[3:0]	Precision;
input	[31:0]	I, W;
output	reg	[31:0]	I_MUX, W_MUX;

always @(*) begin
	case (Precision)
		default:	I_MUX	<= I;
		4'b00_00:	I_MUX	<= I;
		4'b01_00: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*2+:2];
			I_MUX[2*2+:2]	<= I[2*4+:2];
			I_MUX[2*3+:2]	<= I[2*6+:2];
			I_MUX[2*4+:2]	<= I[2*1+:2];
			I_MUX[2*5+:2]	<= I[2*3+:2];
			I_MUX[2*6+:2]	<= I[2*5+:2];
			I_MUX[2*7+:2]	<= I[2*7+:2];
			I_MUX[2*8+:2]	<= I[2*8+:2];
			I_MUX[2*9+:2]	<= I[2*10+:2];
			I_MUX[2*10+:2]	<= I[2*12+:2];
			I_MUX[2*11+:2]	<= I[2*14+:2];
			I_MUX[2*12+:2]	<= I[2*9+:2];
			I_MUX[2*13+:2]	<= I[2*11+:2];
			I_MUX[2*14+:2]	<= I[2*13+:2];
			I_MUX[2*15+:2]	<= I[2*15+:2];
		end
		4'b00_01: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*0+:2];
			I_MUX[2*2+:2]	<= I[2*1+:2];
			I_MUX[2*3+:2]	<= I[2*1+:2];
			I_MUX[2*4+:2]	<= I[2*2+:2];
			I_MUX[2*5+:2]	<= I[2*2+:2];
			I_MUX[2*6+:2]	<= I[2*3+:2];
			I_MUX[2*7+:2]	<= I[2*3+:2];
			I_MUX[2*8+:2]	<= I[2*4+:2];
			I_MUX[2*9+:2]	<= I[2*4+:2];
			I_MUX[2*10+:2]	<= I[2*5+:2];
			I_MUX[2*11+:2]	<= I[2*5+:2];
			I_MUX[2*12+:2]	<= I[2*6+:2];
			I_MUX[2*13+:2]	<= I[2*6+:2];
			I_MUX[2*14+:2]	<= I[2*7+:2];
			I_MUX[2*15+:2]	<= I[2*7+:2];
		end
		4'b10_00: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*4+:2];
			I_MUX[2*2+:2]	<= I[2*8+:2];
			I_MUX[2*3+:2]	<= I[2*12+:2];
			I_MUX[2*4+:2]	<= I[2*1+:2];
			I_MUX[2*5+:2]	<= I[2*5+:2];
			I_MUX[2*6+:2]	<= I[2*9+:2];
			I_MUX[2*7+:2]	<= I[2*13+:2];
			I_MUX[2*8+:2]	<= I[2*2+:2];
			I_MUX[2*9+:2]	<= I[2*6+:2];
			I_MUX[2*10+:2]	<= I[2*10+:2];
			I_MUX[2*11+:2]	<= I[2*14+:2];
			I_MUX[2*12+:2]	<= I[2*3+:2];
			I_MUX[2*13+:2]	<= I[2*7+:2];
			I_MUX[2*14+:2]	<= I[2*11+:2];
			I_MUX[2*15+:2]	<= I[2*15+:2];
		end
		4'b00_10, 4'b01_10, 4'b10_10: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*0+:2];
			I_MUX[2*2+:2]	<= I[2*0+:2];
			I_MUX[2*3+:2]	<= I[2*0+:2];
			I_MUX[2*4+:2]	<= I[2*1+:2];
			I_MUX[2*5+:2]	<= I[2*1+:2];
			I_MUX[2*6+:2]	<= I[2*1+:2];
			I_MUX[2*7+:2]	<= I[2*1+:2];
			I_MUX[2*8+:2]	<= I[2*2+:2];
			I_MUX[2*9+:2]	<= I[2*2+:2];
			I_MUX[2*10+:2]	<= I[2*2+:2];
			I_MUX[2*11+:2]	<= I[2*2+:2];
			I_MUX[2*12+:2]	<= I[2*3+:2];
			I_MUX[2*13+:2]	<= I[2*3+:2];
			I_MUX[2*14+:2]	<= I[2*3+:2];
			I_MUX[2*15+:2]	<= I[2*3+:2];
		end
		4'b01_01: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*0+:2];
			I_MUX[2*2+:2]	<= I[2*2+:2];
			I_MUX[2*3+:2]	<= I[2*2+:2];
			I_MUX[2*4+:2]	<= I[2*1+:2];
			I_MUX[2*5+:2]	<= I[2*1+:2];
			I_MUX[2*6+:2]	<= I[2*3+:2];
			I_MUX[2*7+:2]	<= I[2*3+:2];
			I_MUX[2*8+:2]	<= I[2*4+:2];
			I_MUX[2*9+:2]	<= I[2*4+:2];
			I_MUX[2*10+:2]	<= I[2*6+:2];
			I_MUX[2*11+:2]	<= I[2*6+:2];
			I_MUX[2*12+:2]	<= I[2*5+:2];
			I_MUX[2*13+:2]	<= I[2*5+:2];
			I_MUX[2*14+:2]	<= I[2*7+:2];
			I_MUX[2*15+:2]	<= I[2*7+:2];
		end
		4'b10_01: begin
			I_MUX[2*0+:2]	<= I[2*0+:2];
			I_MUX[2*1+:2]	<= I[2*0+:2];
			I_MUX[2*2+:2]	<= I[2*4+:2];
			I_MUX[2*3+:2]	<= I[2*4+:2];
			I_MUX[2*4+:2]	<= I[2*1+:2];
			I_MUX[2*5+:2]	<= I[2*1+:2];
			I_MUX[2*6+:2]	<= I[2*5+:2];
			I_MUX[2*7+:2]	<= I[2*5+:2];
			I_MUX[2*8+:2]	<= I[2*2+:2];
			I_MUX[2*9+:2]	<= I[2*2+:2];
			I_MUX[2*10+:2]	<= I[2*6+:2];
			I_MUX[2*11+:2]	<= I[2*6+:2];
			I_MUX[2*12+:2]	<= I[2*3+:2];
			I_MUX[2*13+:2]	<= I[2*3+:2];
			I_MUX[2*14+:2]	<= I[2*7+:2];
			I_MUX[2*15+:2]	<= I[2*7+:2];
		end
	endcase
end

always @(*) begin
	case (Precision)
		default:	W_MUX	<= W;
		4'b00_00, 4'b00_01, 4'b00_10:	W_MUX	<= W;
		4'b01_00, 4'b01_01, 4'b01_10: begin
			W_MUX[2*0+:2]	<= W[2*0+:2];
			W_MUX[2*1+:2]	<= W[2*1+:2];
			W_MUX[2*2+:2]	<= W[2*2+:2];
			W_MUX[2*3+:2]	<= W[2*3+:2];
			W_MUX[2*4+:2]	<= W[2*0+:2];
			W_MUX[2*5+:2]	<= W[2*1+:2];
			W_MUX[2*6+:2]	<= W[2*2+:2];
			W_MUX[2*7+:2]	<= W[2*3+:2];
			W_MUX[2*8+:2]	<= W[2*4+:2];
			W_MUX[2*9+:2]	<= W[2*5+:2];
			W_MUX[2*10+:2]	<= W[2*6+:2];
			W_MUX[2*11+:2]	<= W[2*7+:2];
			W_MUX[2*12+:2]	<= W[2*4+:2];
			W_MUX[2*13+:2]	<= W[2*5+:2];
			W_MUX[2*14+:2]	<= W[2*6+:2];
			W_MUX[2*15+:2]	<= W[2*7+:2];
		end
		4'b10_00, 4'b10_01, 4'b10_10: begin
			W_MUX[2*0+:2]	<= W[2*0+:2];
			W_MUX[2*1+:2]	<= W[2*1+:2];
			W_MUX[2*2+:2]	<= W[2*2+:2];
			W_MUX[2*3+:2]	<= W[2*3+:2];
			W_MUX[2*4+:2]	<= W[2*0+:2];
			W_MUX[2*5+:2]	<= W[2*1+:2];
			W_MUX[2*6+:2]	<= W[2*2+:2];
			W_MUX[2*7+:2]	<= W[2*3+:2];
			W_MUX[2*8+:2]	<= W[2*0+:2];
			W_MUX[2*9+:2]	<= W[2*1+:2];
			W_MUX[2*10+:2]	<= W[2*2+:2];
			W_MUX[2*11+:2]	<= W[2*3+:2];
			W_MUX[2*12+:2]	<= W[2*0+:2];
			W_MUX[2*13+:2]	<= W[2*1+:2];
			W_MUX[2*14+:2]	<= W[2*2+:2];
			W_MUX[2*15+:2]	<= W[2*3+:2];
		end
	endcase
end

endmodule
