`include "../source/parameters.v"
module mux_fusion_2b ( Precision, I, W, I_MUX, W_MUX );
input	[3:0]	Precision;
input	[`MUX_FUS:0]	I, W;
output	reg	[`MUX_FUS:0]	I_MUX, W_MUX;

always @(*) begin
	case (Precision)
		default:	I_MUX	<= I;
		4'b00_00, 4'b01_00, 4'b10_00:	I_MUX	<= I;
		4'b00_01, 4'b01_01: begin
		  I_MUX[1:0] <= {2{I[0]}};
      I_MUX[3:2] <= {2{I[1]}};
      I_MUX[5:4] <= {2{I[2]}};
      I_MUX[7:6] <= {2{I[3]}};
      I_MUX[9:8] <= {2{I[4]}};
      I_MUX[11:10] <= {2{I[5]}};
      I_MUX[13:12] <= {2{I[6]}};
      I_MUX[15:14] <= {2{I[7]}};
    end
    4'b00_10, 4'b01_10, 4'b10_10: begin
      I_MUX[3:0] <= {4{I[0]}};
      I_MUX[7:4] <= {4{I[1]}};
      I_MUX[11:8] <= {4{I[2]}};
      I_MUX[15:12] <= {4{I[3]}};
    end
    4'b10_01: begin
      I_MUX[7:0] <= {2{I[3:0]}};
      I_MUX[15:8] <= {2{I[7:4]}};
    end
	endcase
end

always @(*) begin
	case (Precision)
		default:	W_MUX	<= W;
		4'b00_00, 4'b00_01, 4'b00_10:	W_MUX	<= W;
		4'b01_00: begin
		  W_MUX[1:0] <= {2{W[0]}};
      W_MUX[3:2] <= {2{W[1]}};
      W_MUX[5:4] <= {2{W[2]}};
      W_MUX[7:6] <= {2{W[3]}};
      W_MUX[9:8] <= {2{W[4]}};
      W_MUX[11:10] <= {2{W[5]}};
      W_MUX[13:12] <= {2{W[6]}};
      W_MUX[15:14] <= {2{W[7]}};
		end
    4'b10_00, 4'b10_01: begin
      W_MUX[3:0] <= {4{W[0]}};
      W_MUX[7:4] <= {4{W[1]}};
      W_MUX[11:8] <= {4{W[2]}};
      W_MUX[15:12] <= {4{W[3]}};
    end
    4'b01_01: begin
      W_MUX[3:0] <= {2{W[1:0]}};
      W_MUX[7:4] <= {2{W[3:2]}};
      W_MUX[11:8] <= {2{W[5:4]}};
      W_MUX[15:12] <= {2{W[7:6]}};
    end
    4'b01_10: begin
      W_MUX[7:0] <= {2{W[3:0]}};
      W_MUX[15:0] <= {2{W[7:4]}};
    end
    4'b10_10: begin
      W_MUX[15:0] <= {4{W[3:0]}};
    end
	endcase
end

endmodule
