module dff_4(clk,rst_n, d,q);
input rst_n, clk;
input [3:0]d;
output [3:0]q;

wire rst_n,clk;
wire [3:0]d;
reg [3:0]q;

always@(rst_n or posedge clk)
begin
	if(rst_n==0)
	q<=4'b0;
	else q<=d;
end
endmodule

module tb_unit_test(state, surv_data, next_state, out);
//input data
input [1:0] state;
input [3:0] surv_data;
//output data
output [1:0] next_state;
output out;
//main code
assign out = state[1];
assign next_state = {state[0],surv_data[state[1:0]]};
endmodule

module tb_mem_test(clk, rst_n, tb_in, tb_out);
//input data
input clk;
input rst_n;
input[3:0] tb_in;
//output data
output [3:0] tb_out;
wire clk;
wire rst_n;
wire [3:0] tb_in;
wire [3:0] tb_out;
//main code
dff_4 tbm(clk, rst_n, tb_in, tb_out);
endmodule

module traceback_test(clk, rst_n, acs_out, small_state, next, decode_out);
//input data
input clk;
input rst_n;
input [3:0] acs_out;
input [1:0] small_state;

output [7:0]decode_out;
output [15:0] next;

wire [3:0] acs_out;
wire [3:0] pa_mem [0:7];
wire [1:0] next_state [0:7];
wire out [0:7];

//main code

assign pa_mem[0] = acs_out;
//tb_mem_test tbm_0(clk, rst_n, acs_out, pa_mem[0]);
tb_mem_test tbm_1(clk, rst_n, pa_mem[0], pa_mem[1]);
tb_mem_test tbm_2(clk, rst_n, pa_mem[1], pa_mem[2]);
tb_mem_test tbm_3(clk, rst_n, pa_mem[2], pa_mem[3]);
tb_mem_test tbm_4(clk, rst_n, pa_mem[3], pa_mem[4]);
tb_mem_test tbm_5(clk, rst_n, pa_mem[4], pa_mem[5]);
tb_mem_test tbm_6(clk, rst_n, pa_mem[5], pa_mem[6]);
tb_mem_test tbm_7(clk, rst_n, pa_mem[6], pa_mem[7]);
//tb_mem_test tbm_8(clk, rst_n, pa_mem[7], pa_mem[8]);


//module tb_unit(state, surv_data, next_state, out);
tb_unit_test tbu_0(small_state, pa_mem[0], next_state[0], out[0]);
tb_unit_test tbu_1(next_state[0], pa_mem[1],next_state[1], out[1]);
tb_unit_test tbu_2(next_state[1], pa_mem[2],next_state[2], out[2]);
tb_unit_test tbu_3(next_state[2], pa_mem[3],next_state[3], out[3]);
tb_unit_test tbu_4(next_state[3], pa_mem[4],next_state[4], out[4]);
tb_unit_test tbu_5(next_state[4], pa_mem[5],next_state[5], out[5]);
tb_unit_test tbu_6(next_state[5], pa_mem[6],next_state[6], out[6]);
tb_unit_test tbu_7(next_state[6], pa_mem[7],next_state[7], out[7]);
//tb_unit_test tbu_8(next_state[7], pa_mem[8],next_state[8], out[8]);

assign next = {next_state[6],next_state[5],next_state[4],next_state[3],next_state[2],next_state[1],next_state[0]};

assign decode_out = {out[7],out[6],out[5],out[4],out[3],out[2],out[1],out[0]};

endmodule

module traceback_test_tb;
//input data
reg clk;
reg rst_n;
reg [3:0] acs_out;
reg [1:0] small_state;

wire [7:0]decode_out;
wire [15:0] next;

initial begin
	$monitor ("acs_out = %b, small_state = %b, next = %b, decode_out = %b", acs_out, small_state, next, decode_out);
end

initial begin 
	clk = 1'b0;
forever #10 clk = ~clk;
end 

initial begin
	#0 rst_n = 1'b0; acs_out = 4'b0000; small_state = 2'b10;
	#5 rst_n = 1'b1; //acs_out = 4'b0011;
	//acs_out = 4'b0000; small_state = 2'b10; @(posedge clk)
	acs_out = 4'b1100; small_state = 2'b11; @(posedge clk)
	acs_out = 4'b1111; small_state = 2'b01; @(posedge clk)
	acs_out = 4'b1100; small_state = 2'b00; @(posedge clk)
	acs_out = 4'b1100; small_state = 2'b00; @(posedge clk)
	acs_out = 4'b0000; small_state = 2'b10; @(posedge clk)
	acs_out = 4'b0011; small_state = 2'b01; @(posedge clk)
	acs_out = 4'b1100; small_state = 2'b00; @(posedge clk)
#10 $stop;
end

//module traceback_test(clk, rst_n, acs_out, small, next, decode_out);
traceback_test tb2(clk, rst_n, acs_out, small_state, next, decode_out);
endmodule







