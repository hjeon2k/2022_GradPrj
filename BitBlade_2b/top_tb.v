`timescale 1ns / 1ps
`include "parameters.v"

module top_tb;

  parameter DW=256;
  
  reg clk;
  reg rstn;
  reg [`BITS_ACT*`PE_ROW*4-1:0] i_Act; // 256 * 4
  reg [`BITS_WEIGHT*`PE_ROW*4-1:0] i_Weight; // 256 * 4
  reg [1:0] i_Precision;
  reg [1:0] w_Precision;
  reg [`N_BIAS*`PE_ARRAY-1:0] i_Bias; // 16 * 16
  reg i_Sel_Bias;
  reg i_Flush;
  reg [4:0] layer_num;
  reg [1:0] next_i_precision;
  reg [1:0] next_i_precision_small;
  reg [2:0] shift;
  reg core_vld;
  reg [9:0] buf_base_addr;
  reg [9:0] buf_base_addr_small;

  wire [8:0] o_row;
  wire [8:0] o_col;
  wire buf_ena_0;
  wire [159:0] buf_addr_0;
  wire [15:0] buf_wea_select_0;
  wire [DW*2-1:0] buf_wea_byte_0;
  wire [DW*16-1:0] buf_din_0;
  wire buf_ena_1;
  wire [159:0] buf_addr_1;
  wire [15:0] buf_wea_select_1;
  wire [DW*2-1:0] buf_wea_byte_1;
  wire [DW*16-1:0] buf_din_1;
  wire layer_done;

  initial clk = 1'b1;
  always #5 clk = ~clk;
  
  reg[31:0] i, j, k, l;
  initial begin
    rstn = 1'b0;
    i_Act = 0;
    i_Weight = 0;
    i_Precision = 0;
    w_Precision = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;
    layer_num = 0;
    next_i_precision = 0;
    next_i_precision_small = 0;
    shift = 0;
    i = 0;
    j = 0;
    k = 0;
    l = 0;
    core_vld = 0;
    buf_base_addr = 10'b0000000000;
    buf_base_addr_small = 10'b0000100100;
    
    repeat(10)
    @(posedge clk);

    /*
    rstn = 1'b1;
    // layer 6 : 40x40x64 to 40x40x128 (3x3x64x128)
    layer_num = 6;
    // 8b 8b multiply, 8b result
    i_Precision = 2;
    w_Precision = 2;
    next_i_precision = 2;
    core_vld = 1;
    
    for (k=1; k<33; k=k+1) begin
      for (i=1; i<21; i=i+1) begin
        for (j=1; j<21; j=j+1) begin
          for (l=0; l<72; l=l+1) begin
            if (l==0) begin
              i_Act[0 +: 256] = j;
              i_Act[256 +: 256] = j;
              i_Act[512 +: 256] = j;
              i_Act[768 +: 256] = j;
              
              i_Weight[0 +: 256] = 1;
              i_Weight[256 +: 256] = 1;
              i_Weight[512 +: 256] = 1;
              i_Weight[768 +: 256] = 1;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 1;
            end
            else if (l==70) begin
              i_Act[0 +: 256] = 1;
              i_Act[256 +: 256] = 1;
              i_Act[512 +: 256] = 1;
              i_Act[768 +: 256] = 1;
              
              i_Weight[0 +: 256] = i;
              i_Weight[256 +: 256] = i;
              i_Weight[512 +: 256] = i;
              i_Weight[768 +: 256] = i;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            else if (l==71) begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias[0 +: 16] = 1;
              i_Bias[16 +: 16] = 2;
              i_Bias[32 +: 16] = 3;
              i_Bias[48 +: 16] = 4;
              
              i_Bias[64 +: 16] = 5;
              i_Bias[80 +: 16] = 6;
              i_Bias[96 +: 16] = 7;
              i_Bias[112 +: 16] = 8;
              
              i_Bias[128 +: 16] = 9;
              i_Bias[144 +: 16] = 10;
              i_Bias[160 +: 16] = 11;
              i_Bias[176 +: 16] = 12;
              
              i_Bias[192 +: 16] = 13;
              i_Bias[208 +: 16] = 14;
              i_Bias[224 +: 16] = 15;
              i_Bias[240 +: 16] = 16;
              
              i_Sel_Bias = 1;
              i_Flush = 0;
            end
            else begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            #10;
          end
        end
      end
    end
    
    core_vld = 0;
    i_Act = 0;
    i_Weight = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;
    
    repeat(10)
    @(posedge clk);
    rstn = 0;
    repeat(10)
    @(posedge clk);
    */
    
    rstn = 1'b1;
    // layer 8 : 20x20x128 to 10x10x128 (3x3x128x128)
    layer_num = 8;
    // 8b 8b multiply, 8b result
    i_Precision = 2;
    w_Precision = 2;
    next_i_precision = 2;
    next_i_precision_small = 2;
    core_vld = 1;
    
    for (k=1; k<33; k=k+1) begin
      for (i=1; i<11; i=i+1) begin
        for (j=1; j<11; j=j+1) begin
          for (l=0; l<144; l=l+1) begin
            if (l==0) begin
              i_Act[0 +: 256] = j;
              i_Act[256 +: 256] = j;
              i_Act[512 +: 256] = j;
              i_Act[768 +: 256] = j;
              
              i_Weight[0 +: 256] = 1;
              i_Weight[256 +: 256] = 1;
              i_Weight[512 +: 256] = 1;
              i_Weight[768 +: 256] = 1;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 1;
            end
            else if (l==142) begin
              i_Act[0 +: 256] = 1;
              i_Act[256 +: 256] = 1;
              i_Act[512 +: 256] = 1;
              i_Act[768 +: 256] = 1;
              
              i_Weight[0 +: 256] = i;
              i_Weight[256 +: 256] = i;
              i_Weight[512 +: 256] = i;
              i_Weight[768 +: 256] = i;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            else if (l==143) begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias[0 +: 16] = 1;
              i_Bias[16 +: 16] = 2;
              i_Bias[32 +: 16] = 3;
              i_Bias[48 +: 16] = 4;
              
              i_Bias[64 +: 16] = 5;
              i_Bias[80 +: 16] = 6;
              i_Bias[96 +: 16] = 7;
              i_Bias[112 +: 16] = 8;
              
              i_Bias[128 +: 16] = 9;
              i_Bias[144 +: 16] = 10;
              i_Bias[160 +: 16] = 11;
              i_Bias[176 +: 16] = 12;
              
              i_Bias[192 +: 16] = 13;
              i_Bias[208 +: 16] = 14;
              i_Bias[224 +: 16] = 15;
              i_Bias[240 +: 16] = 16;
              
              i_Sel_Bias = 1;
              i_Flush = 0;
            end
            else begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            #10;
          end
        end
      end
    end
    
    core_vld = 0;
    i_Act = 0;
    i_Weight = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;
    
    repeat(10)
    @(posedge clk);
    rstn = 0;
    repeat(10)
    @(posedge clk);
    
    /*
    rstn = 1;
    // layer 10 : 10x10x128 to 10x10x128 (3x3x128x128)
    layer_num = 10;
    // 8b 8b multiply, 8b result
    i_Precision = 2;
    w_Precision = 2;
    next_i_precision = 2;
    core_vld = 1;
    
    for (k=1; k<33; k=k+1) begin
      for (i=1; i<6; i=i+1) begin
        for (j=1; j<6; j=j+1) begin
          for (l=0; l<144; l=l+1) begin
            if (l==0) begin
              i_Act[0 +: 256] = j;
              i_Act[256 +: 256] = j;
              i_Act[512 +: 256] = j;
              i_Act[768 +: 256] = j;
              
              i_Weight[0 +: 256] = 1;
              i_Weight[256 +: 256] = 1;
              i_Weight[512 +: 256] = 1;
              i_Weight[768 +: 256] = 1;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 1;
            end
            else if (l==142) begin
              i_Act[0 +: 256] = 1;
              i_Act[256 +: 256] = 1;
              i_Act[512 +: 256] = 1;
              i_Act[768 +: 256] = 1;
              
              i_Weight[0 +: 256] = i;
              i_Weight[256 +: 256] = i;
              i_Weight[512 +: 256] = i;
              i_Weight[768 +: 256] = i;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            else if (l==143) begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias[0 +: 16] = 1;
              i_Bias[16 +: 16] = 2;
              i_Bias[32 +: 16] = 3;
              i_Bias[48 +: 16] = 4;
              
              i_Bias[64 +: 16] = 5;
              i_Bias[80 +: 16] = 6;
              i_Bias[96 +: 16] = 7;
              i_Bias[112 +: 16] = 8;
              
              i_Bias[128 +: 16] = 9;
              i_Bias[144 +: 16] = 10;
              i_Bias[160 +: 16] = 11;
              i_Bias[176 +: 16] = 12;
              
              i_Bias[192 +: 16] = 13;
              i_Bias[208 +: 16] = 14;
              i_Bias[224 +: 16] = 15;
              i_Bias[240 +: 16] = 16;
              
              i_Sel_Bias = 1;
              i_Flush = 0;
            end
            else begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            #10;
          end
        end
      end
    end
    
    core_vld = 0;
    i_Act = 0;
    i_Weight = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;

    repeat(100)
    @(posedge clk);
    rstn = 0;
    repeat(10)
    @(posedge clk);
    */
    
    /*
    rstn = 1;
    // layer 19 : 20x20x256 to 20x20x128 (3x3x256x128)
    layer_num = 19;
    // 8b 8b multiply, 8b result
    i_Precision = 2;
    w_Precision = 2;
    next_i_precision = 2;
    core_vld = 1;
    
    for (k=1; k<33; k=k+1) begin
      for (i=1; i<11; i=i+1) begin
        for (j=1; j<11; j=j+1) begin
          for (l=0; l<288; l=l+1) begin
            if (l==0) begin
              i_Act[0 +: 256] = j;
              i_Act[256 +: 256] = j;
              i_Act[512 +: 256] = j;
              i_Act[768 +: 256] = j;
              
              i_Weight[0 +: 256] = 1;
              i_Weight[256 +: 256] = 1;
              i_Weight[512 +: 256] = 1;
              i_Weight[768 +: 256] = 1;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 1;
            end
            else if (l==286) begin
              i_Act[0 +: 256] = 1;
              i_Act[256 +: 256] = 1;
              i_Act[512 +: 256] = 1;
              i_Act[768 +: 256] = 1;
              
              i_Weight[0 +: 256] = i;
              i_Weight[256 +: 256] = i;
              i_Weight[512 +: 256] = i;
              i_Weight[768 +: 256] = i;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            else if (l==287) begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias[0 +: 16] = 1;
              i_Bias[16 +: 16] = 2;
              i_Bias[32 +: 16] = 3;
              i_Bias[48 +: 16] = 4;
              
              i_Bias[64 +: 16] = 5;
              i_Bias[80 +: 16] = 6;
              i_Bias[96 +: 16] = 7;
              i_Bias[112 +: 16] = 8;
              
              i_Bias[128 +: 16] = 9;
              i_Bias[144 +: 16] = 10;
              i_Bias[160 +: 16] = 11;
              i_Bias[176 +: 16] = 12;
              
              i_Bias[192 +: 16] = 13;
              i_Bias[208 +: 16] = 14;
              i_Bias[224 +: 16] = 15;
              i_Bias[240 +: 16] = 16;
              
              i_Sel_Bias = 1;
              i_Flush = 0;
            end
            else begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            #10;
          end
        end
      end
    end
    
    core_vld = 0;
    i_Act = 0;
    i_Weight = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;

    repeat(10)
    @(posedge clk);
    rstn = 0;
    repeat(10)
    @(posedge clk);   
    */
    /*
    rstn = 1;
    // layer 16 : 10x10x128 to 10x10x128 (1x1x128x128)
    layer_num = 16;
    // 8b 8b multiply, 8b result
    i_Precision = 2;
    w_Precision = 2;
    next_i_precision = 2;
    core_vld = 1;
    
    for (k=1; k<33; k=k+1) begin
      for (i=1; i<6; i=i+1) begin
        for (j=1; j<6; j=j+1) begin
          for (l=0; l<16; l=l+1) begin
            if (l==0) begin
              i_Act[0 +: 256] = j;
              i_Act[256 +: 256] = j;
              i_Act[512 +: 256] = j;
              i_Act[768 +: 256] = j;
              
              i_Weight[0 +: 256] = 1;
              i_Weight[256 +: 256] = 1;
              i_Weight[512 +: 256] = 1;
              i_Weight[768 +: 256] = 1;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 1;
            end
            else if (l==14) begin
              i_Act[0 +: 256] = 1;
              i_Act[256 +: 256] = 1;
              i_Act[512 +: 256] = 1;
              i_Act[768 +: 256] = 1;
              
              i_Weight[0 +: 256] = i;
              i_Weight[256 +: 256] = i;
              i_Weight[512 +: 256] = i;
              i_Weight[768 +: 256] = i;
              
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            else if (l==15) begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias[0 +: 16] = 1;
              i_Bias[16 +: 16] = 2;
              i_Bias[32 +: 16] = 3;
              i_Bias[48 +: 16] = 4;
              
              i_Bias[64 +: 16] = 5;
              i_Bias[80 +: 16] = 6;
              i_Bias[96 +: 16] = 7;
              i_Bias[112 +: 16] = 8;
              
              i_Bias[128 +: 16] = 9;
              i_Bias[144 +: 16] = 10;
              i_Bias[160 +: 16] = 11;
              i_Bias[176 +: 16] = 12;
              
              i_Bias[192 +: 16] = 13;
              i_Bias[208 +: 16] = 14;
              i_Bias[224 +: 16] = 15;
              i_Bias[240 +: 16] = 16;
              
              i_Sel_Bias = 1;
              i_Flush = 0;
            end
            else begin
              i_Act = 0;
              i_Weight = 0;
              i_Bias = 0;
              i_Sel_Bias = 0;
              i_Flush = 0;
            end
            #10;
          end
        end
      end
    end
    
    core_vld = 0;
    i_Act = 0;
    i_Weight = 0;
    i_Bias = 0;
    i_Sel_Bias = 0;
    i_Flush = 0;

    repeat(10)
    @(posedge clk);
    rstn = 0;
    repeat(10)
    @(posedge clk);   
    */
  end
  
  core_top u_core_top(.CLK(clk), .RST(rstn), .i_Act(i_Act), .i_Weight(i_Weight), .i_Precision(i_Precision), .w_Precision(w_Precision), .i_Bias(i_Bias), .i_Sel_Bias(i_Sel_Bias), .i_Flush(i_Flush), .layer_num(layer_num), .next_i_precision(next_i_precision), .next_i_precision_small(next_i_precision_small), .shift(shift), .core_vld(core_vld), .o_row(o_row), .o_col(o_col), .buf_base_addr(buf_base_addr), .buf_base_addr_small(buf_base_addr_small), .buf_ena_0(buf_ena_0), .buf_addr_0(buf_addr_0), .buf_wea_select_0(buf_wea_select_0), .buf_wea_byte_0(buf_wea_byte_0), .buf_din_0(buf_din_0), .buf_ena_1(buf_ena_1), .buf_addr_1(buf_addr_1), .buf_wea_select_1(buf_wea_select_1), .buf_wea_byte_1(buf_wea_byte_1), .buf_din_1(buf_din_1), .layer_done(layer_done));

endmodule
