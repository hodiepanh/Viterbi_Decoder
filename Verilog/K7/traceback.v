module dff_64(clk,rst_n, d,q);
input rst_n, clk;
input [63:0]d;
output [63:0]q;

wire rst_n,clk;
wire [63:0]d;
reg [63:0]q;

always@(rst_n or posedge clk)
begin
	if(rst_n==0)
	q<=64'b0;
	else q<=d;
end
endmodule

module tb_unit(state, surv_data, next_state, out);
//input data
input [5:0] state;
input [63:0] surv_data;
//output data
output [5:0] next_state;
output out;
//main code
assign out = state[5];
assign next_state = {state[4:0],surv_data[state[5:0]]};
endmodule

module tb_mem(clk, rst_n, tb_in, tb_out);
//input data
input clk;
input rst_n;
input[63:0] tb_in;
//output data
output [63:0] tb_out;
wire clk;
wire rst_n;
wire [63:0] tb_in;
wire [63:0] tb_out;
//main code
//module dff_64(clk,rst_n, d,q);
dff_64 tbm(clk, rst_n, tb_in, tb_out);
endmodule

module traceback(clk, rst_n, acs_out, small_state, next, decode_out);
//input data
input clk;
input rst_n;
input [63:0] acs_out;
input [5:0] small_state;

//test with input stream of 8 pair 2 bits
output [7:0]decode_out;
output [47:0] next;
wire [63:0] acs_out;
//decode 36 symbols: 0->35
wire [63:0] pa_mem [0:7];
wire [5:0] next_state [0:7];
wire out [0:7];
wire [5:0] small_state;
//main code
assign pa_mem[0] =acs_out;
//module tb_mem(clk, rst_n, tb_in, tb_out);
//tb_mem tbm_0(clk, rst_n, acs_out, pa_mem[0]);
tb_mem tbm_1(clk, rst_n, pa_mem[0], pa_mem[1]);
tb_mem tbm_2(clk, rst_n, pa_mem[1], pa_mem[2]);
tb_mem tbm_3(clk, rst_n, pa_mem[2], pa_mem[3]);
tb_mem tbm_4(clk, rst_n, pa_mem[3], pa_mem[4]);
tb_mem tbm_5(clk, rst_n, pa_mem[4], pa_mem[5]);
tb_mem tbm_6(clk, rst_n, pa_mem[5], pa_mem[6]);
tb_mem tbm_7(clk, rst_n, pa_mem[6], pa_mem[7]);
//------------ comment out because bus is 36 bus only test n 8bit to check result-----------//
//tb_mem tbm_8(clk, rst_n, pa_mem[7], pa_mem[8]);
//tb_mem tbm_9(clk, rst_n, pa_mem[8], pa_mem[9]);

//tb_mem tbm_10(clk, rst_n, pa_mem[9], pa_mem[10]);
//tb_mem tbm_11(clk, rst_n, pa_mem[10], pa_mem[11]);
//tb_mem tbm_12(clk, rst_n, pa_mem[11], pa_mem[12]);
//tb_mem tbm_13(clk, rst_n, pa_mem[12], pa_mem[13]);
//tb_mem tbm_14(clk, rst_n, pa_mem[13], pa_mem[14]);
//tb_mem tbm_15(clk, rst_n, pa_mem[14], pa_mem[15]);
//tb_mem tbm_16(clk, rst_n, pa_mem[15], pa_mem[16]);
//tb_mem tbm_17(clk, rst_n, pa_mem[16], pa_mem[17]);
//tb_mem tbm_18(clk, rst_n, pa_mem[17], pa_mem[18]);
//tb_mem tbm_19(clk, rst_n, pa_mem[18], pa_mem[19]);

//tb_mem tbm_20(clk, rst_n, pa_mem[19], pa_mem[20]);
//tb_mem tbm_21(clk, rst_n, pa_mem[20], pa_mem[21]);
//tb_mem tbm_22(clk, rst_n, pa_mem[21], pa_mem[22]);
//tb_mem tbm_23(clk, rst_n, pa_mem[22], pa_mem[23]);
//tb_mem tbm_24(clk, rst_n, pa_mem[23], pa_mem[24]);
//tb_mem tbm_25(clk, rst_n, pa_mem[24], pa_mem[25]);
//tb_mem tbm_26(clk, rst_n, pa_mem[25], pa_mem[26]);
//tb_mem tbm_27(clk, rst_n, pa_mem[26], pa_mem[27]);
//tb_mem tbm_28(clk, rst_n, pa_mem[27], pa_mem[28]);
//tb_mem tbm_29(clk, rst_n, pa_mem[28], pa_mem[29]);

//tb_mem tbm_30(clk, rst_n, pa_mem[29], pa_mem[30]);
//tb_mem tbm_31(clk, rst_n, pa_mem[30], pa_mem[31]);
//tb_mem tbm_32(clk, rst_n, pa_mem[31], pa_mem[32]);
//tb_mem tbm_33(clk, rst_n, pa_mem[32], pa_mem[33]);
//tb_mem tbm_34(clk, rst_n, pa_mem[33], pa_mem[34]);
//tb_mem tbm_35(clk, rst_n, pa_mem[34], pa_mem[35]);

//module tb_unit(state, surv_data, next_state, out);
tb_unit tbu_0(small_state, pa_mem[0], next_state[0], out[0]);
tb_unit tbu_1(next_state[0], pa_mem[1],next_state[1], out[1]);
tb_unit tbu_2(next_state[1], pa_mem[2],next_state[2], out[2]);
tb_unit tbu_3(next_state[2], pa_mem[3],next_state[3], out[3]);
tb_unit tbu_4(next_state[3], pa_mem[4],next_state[4], out[4]);
tb_unit tbu_5(next_state[4], pa_mem[5],next_state[5], out[5]);
tb_unit tbu_6(next_state[5], pa_mem[6],next_state[6], out[6]);
tb_unit tbu_7(next_state[6], pa_mem[7],next_state[7], out[7]);
//------------ comment out because bus is 36 bus only test n 8bit to check result-----------//
//tb_unit tbu_8(next_state[7], pa_mem[8],next_state[8], out[8]);
//tb_unit tbu_9(next_state[8], pa_mem[9],next_state[9], out[9]);

//tb_unit tbu_10(next_state[9], pa_mem[10],next_state[10], out[10]);
//tb_unit tbu_11(next_state[10], pa_mem[11],next_state[11], out[11]);
//tb_unit tbu_12(next_state[11], pa_mem[12],next_state[12], out[12]);
//tb_unit tbu_13(next_state[12], pa_mem[13],next_state[13], out[13]);
//tb_unit tbu_14(next_state[13], pa_mem[14],next_state[14], out[14]);
//tb_unit tbu_15(next_state[14], pa_mem[15],next_state[15], out[15]);
//tb_unit tbu_16(next_state[15], pa_mem[16],next_state[16], out[16]);
//tb_unit tbu_17(next_state[16], pa_mem[17],next_state[17], out[17]);
//tb_unit tbu_18(next_state[17], pa_mem[18],next_state[18], out[18]);
//tb_unit tbu_19(next_state[18], pa_mem[19],next_state[19], out[19]);

//tb_unit tbu_20(next_state[19], pa_mem[20],next_state[20], out[20]);
//tb_unit tbu_21(next_state[20], pa_mem[21],next_state[21], out[21]);
//tb_unit tbu_22(next_state[21], pa_mem[22],next_state[22], out[22]);
//tb_unit tbu_23(next_state[22], pa_mem[23],next_state[23], out[23]);
//tb_unit tbu_24(next_state[23], pa_mem[24],next_state[24], out[24]);
//tb_unit tbu_25(next_state[24], pa_mem[25],next_state[25], out[25]);
//tb_unit tbu_26(next_state[25], pa_mem[26],next_state[26], out[26]);
//tb_unit tbu_27(next_state[26], pa_mem[27],next_state[27], out[27]);
//tb_unit tbu_28(next_state[27], pa_mem[28],next_state[28], out[28]);
//tb_unit tbu_29(next_state[28], pa_mem[29],next_state[29], out[29]);

//tb_unit tbu_30(next_state[29], pa_mem[30],next_state[30], out[30]);
//tb_unit tbu_31(next_state[30], pa_mem[31],next_state[31], out[31]);
//tb_unit tbu_32(next_state[31], pa_mem[32],next_state[32], out[32]);
//tb_unit tbu_33(next_state[32], pa_mem[33],next_state[33], out[33]);
//tb_unit tbu_34(next_state[33], pa_mem[34],next_state[34], out[34]);
//tb_unit tbu_35(next_state[34], pa_mem[35],next_state[35], out[35]);

assign next = {next_state[6],next_state[5],next_state[4],next_state[3],next_state[2],next_state[1],next_state[0]};

assign decode_out = {out[7],out[6],out[5],out[4],out[3],out[2],out[1],out[0]};

endmodule

module traceback_tb;
//input data
reg clk;
reg rst_n;
reg [63:0] acs_out;
reg [5:0] small_state;

wire [7:0]decode_out;
wire [47:0] next;

initial begin
	$monitor ("acs_out = %b, small_state = %b, next = %b, decode_out = %b", acs_out, small_state, next, decode_out);
	//$monitor ("next = %b, decode_out = %b", next, decode_out);
end

initial begin 
	clk = 1'b0;
forever #10 clk = ~clk;
end 

initial begin
	#0 rst_n = 1'b0; acs_out =64'b0000010101010000101000000000101001010000000001010000101010100000;small_state = 6'b000001;
	#5 rst_n = 1'b1;
	acs_out =64'b0101000010101111000010101111010100000101111110101010000001011111;small_state = 6'b000001; @(posedge clk)
	acs_out =64'b1010000001001110000001010111001000001010111001000101000000100111;small_state = 6'b000000; @(posedge clk)
	acs_out =64'b0001111110100000111110000000010110110101000010101010110101010000;small_state = 6'b000000; @(posedge clk)
	acs_out =64'b0111100000100101000111101010010000101101011100001011010000001110;small_state = 6'b101011; @(posedge clk)
	acs_out =64'b0000010101110000001000000101111000010000001001010000101011110100;small_state = 6'b111110; @(posedge clk)
	acs_out =64'b0010010000011010000001001111100000001110101100000101000010101101;small_state = 6'b011111; @(posedge clk)
	acs_out =64'b0100101110010000110100100000010111100001000110101000011101010000;small_state = 6'b001111; @(posedge clk)
#10 $stop;
end

//module traceback_test(clk, rst_n, acs_out, small, next decode_out);
traceback tbu2(clk, rst_n, acs_out, small_state, next, decode_out);
endmodule






