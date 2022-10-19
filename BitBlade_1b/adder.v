/*
module full_adder(
input A,
input B,
input CI,
output reg S,
output reg CO
);

always @ (A, B, CI) begin
    case ({A, B, CI})
        3'b000: begin S=0; CO=0; end
        3'b001: begin S=1; CO=0; end
        3'b010: begin S=1; CO=0; end
        3'b011: begin S=0; CO=1; end
        3'b100: begin S=1; CO=0; end
        3'b101: begin S=0; CO=1; end
        3'b110: begin S=0; CO=1; end
        3'b111: begin S=1; CO=1; end
    endcase
end
        
endmodule


module half_adder(
input A,
input B,
output reg S,
output reg CO
);

always @ (A, B) begin
    case ({A, B})
        2'b00: begin S=0; CO=0; end
        2'b01: begin S=1; CO=0; end
        2'b10: begin S=1; CO=0; end
        2'b11: begin S=0; CO=1; end
    endcase
end
        
endmodule
*/