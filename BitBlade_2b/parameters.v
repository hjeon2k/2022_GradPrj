//`define	BITS_PSUM_LOG	12
//`define	N_MUL	17
//`define	LOG_PE_ROW	4
//`define	BITS_AC1	`BITS_SIP_DOT_ADDER+`N_ACT-1
//`define	BITS_AC2	`BITS_AC1+`N_WEIGHT-1+`BITS_PSUM_LOG
`define	BITS_PARALLEL	2
`define	N_DOT	8 // 8, 16
`define	PE_ROW	16
`define PE_ARRAY 16

`define	N_ACT	`N_DOT
`define	BITS_ACT	`N_ACT * `BITS_PARALLEL
`define	N_WEIGHT	`N_DOT
`define	BITS_WEIGHT	`N_WEIGHT * `BITS_PARALLEL
`define	N_BIAS	16

`define	BITS_MUL	6
`define	BITS_DOT	`N_DOT * `BITS_MUL // 48, 96
`define	BITS_SIP_DOT_ADDER	9	//BITS_MUL + (log_2_N_DOT)

`define	BITS_PSUM_SHIFT		21
`define	BITS_PSUM		26




