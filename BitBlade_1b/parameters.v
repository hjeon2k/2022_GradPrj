//`define N_MUL         17
//`define LOG_PE_ROW	4
//`define BITS_PSUM_LOG	12
//`define BITS_AC1	    `BITS_SIP_DOT_ADDER+`N_ACT-1
//`define BITS_AC2	    `BITS_AC1+`N_WEIGHT-1+`BITS_PSUM_LOG
`define BITS_PARALLEL	1 //From 2 to 1
`define N_DOT       8
`define PE_ROW      64 //From 16 to 64
`define PE_ARRAY    16

`define N_ACT       N_DOT
`define BITS_ACT	N_ACT*BITS_PARALLEL
`define N_WEIGHT	N_DOT
`define BITS_WEIGHT N_WEIGHT*BITS_PARALLEL
`define N_BIAS      16

`define BITS_MUL    2 //From 6 to 4, 4 to 1
`define BITS_DOT	N_DOT*BITS_MUL
`define BITS_SIP_DOT_ADDER  5 //BITS_MUL + log_2_N_DOT. From 9 to 5

`define BITS_PSUM_SHIFT     19 //BITS_SIP_DOT_ADDER + MAX_SHIFT
`define BITS_PSUM           24 // BITS_PSUM_SHITF + LOG_2_PE_ROW + 1