//////////////////////////////////////////////////////////////////////////////////
// Engineer: Minsik Kim
// Project: BitBlade_FPGA
// Module Name: act_quant_vp
// Description: 
// Do power-of-2 activation quantization to transform 29-bit intermediate result to 2/4/8-bit output
//////////////////////////////////////////////////////////////////////////////////


module act_quant_vp #(
    parameter DATA_WIDTH = 29
)
(
input clk,
input rstn,
input [DATA_WIDTH-1:0] din,
input [1:0] fmap_precision, // 0: 2-bit, 1: 4-bit, 2: 8-bit
input [2:0] shift,
input vld_i,
input linear,
output reg [7:0] data_o,
output reg vld_o
);

integer MAX_VAL_8 = 127;
integer MIN_VAL_8 = -127;
integer MAX_VAL_4 = 15;
integer MIN_VAL_4 = -15;
integer MAX_VAL_2 = 1;
integer MIN_VAL_2 = -1;

always@(posedge clk, negedge rstn) begin
    if(!rstn) begin
        data_o <= 8'b0000_0000;
        vld_o <= 1'b0;
    end
    else begin
        vld_o <= 1'b0;
        data_o <= 8'b0000_0000;
        if (vld_i) begin
            vld_o <= 1'b1;
            case (fmap_precision)
                0: begin // 2-bit
                    if ($signed(din) >= 0) begin
                        if ($signed(din) > (MAX_VAL_2 <<< shift)) begin
                            data_o <= MAX_VAL_2;
                        end
                        else data_o <= (din >>> shift);
                    end
                    else begin
                        if (linear) begin
                            if ($signed(din) < (MIN_VAL_2 <<< shift)) begin
                                data_o <= MIN_VAL_2;
                            end
                            else data_o <= ((din + (1 << (shift)) - 1) >>> (shift));
                        end
                        else begin
                            if ($signed(din) < (MIN_VAL_2 <<< (shift+3))) begin
                                data_o <= MIN_VAL_2;
                            end
                            else data_o <= ((din + (1 << (shift+3)) - 1) >>> (shift+3));
                        end
                    end
                end
                1: begin // 4-bit
                    if ($signed(din) >= 0) begin
                        if ($signed(din) > (MAX_VAL_4 <<< shift)) begin
                            data_o <= MAX_VAL_4;
                        end
                        else data_o <= (din >>> shift);
                    end
                    else begin
                        if (linear) begin
                            if ($signed(din) < (MIN_VAL_4 <<< shift)) begin
                                data_o <= MIN_VAL_4;
                            end
                            else data_o <= ((din + (1 << (shift)) - 1) >>> (shift));
                        end
                        else begin
                            if ($signed(din) < (MIN_VAL_4 <<< (shift+3))) begin
                                data_o <= MIN_VAL_4;
                            end
                            else data_o <= ((din + (1 << (shift+3)) - 1) >>> (shift+3));
                        end
                    end
                end
                2: begin // 8-bit
                    if ($signed(din) >= 0) begin
                        if ($signed(din) > (MAX_VAL_8 <<< shift)) begin
                            data_o <= MAX_VAL_8;
                        end
                        else data_o <= (din >>> shift);
                    end
                    else begin
                        if (linear) begin
                            if ($signed(din) < (MIN_VAL_8 <<< shift)) begin
                                data_o <= MIN_VAL_8;
                            end
                            else data_o <= ((din + (1 << (shift)) - 1) >>> (shift));
                        end
                        else begin
                            if ($signed(din) < (MIN_VAL_8 <<< (shift+3))) begin
                                data_o <= MIN_VAL_8;
                            end
                            else data_o <= ((din + (1 << (shift+3)) - 1) >>> (shift+3));
                        end
                    end
                end
            endcase
        end
    end
end
endmodule
