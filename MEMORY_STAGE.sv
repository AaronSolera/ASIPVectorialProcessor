module MEMORY_STAGE (CLK, PIPELINE_E, PIPELINE_M, SWITCH, IMAGE);

	input  			CLK; 
	input  [115:0] PIPELINE_E;
	input  [4:0]   SWITCH;
	output [76:0]  PIPELINE_M;
	output [7:0]	IMAGE;
	
	logic  		  W_WE;
	logic  [31:0] W_WD_MUX, W_ALU_RESULT_MUX, W_RD, W_READ_DATA;
	
	N_BITS_REGISTER #(77) 
		PIPELINE (CLK, CLK, 1'b0, 
					{PIPELINE_E[115:114],PIPELINE_E[108:106],PIPELINE_E[105:98],W_ALU_RESULT_MUX,W_READ_DATA}, 
					 PIPELINE_M);
		
	TWO_INPUTS_N_BITS_MUX #(32) 
		ALU_MUX (PIPELINE_E[65:34], PIPELINE_E[31:0], PIPELINE_E[109], W_ALU_RESULT_MUX),
		WD_MUX  (PIPELINE_E[31:0],  PIPELINE_E[97:66], PIPELINE_E[110], W_WD_MUX);
		
	MEMORY 
		MEM (CLK, PIPELINE_E[65:34], W_WD_MUX, PIPELINE_E[97:66], PIPELINE_E[33:32], W_WE, PIPELINE_E[113], PIPELINE_E[112], W_RD);
		
	ADDRESS_CONTROL 
		ADDSS_CNTL (CLK, PIPELINE_E[65:34], W_RD, W_WD_MUX, PIPELINE_E[111], SWITCH, W_WE, W_READ_DATA, IMAGE);
	
endmodule 