module viterbi_test(clk, rst_n, data_in, next, decode_out);
//input data
input clk;
input rst_n;
input [1:0] data_in;
//output data
output [7:0]decode_out;
output [15:0] next;

wire clk;
wire rst_n;
wire [1:0] data_in;
wire [15:0] bm_data;
wire [11:0] acs_mem;
wire [11:0] acs_norm;
wire [1:0] small_state;
wire [3:0] acs_out;
wire [7:0]decode_out;


//connect all blocks
//---------------------//
//module bmc(data_in, bm_out);
bmc_test bmc0_test(data_in,bm_data);

//module acs_test(bm_in,pm_in_con,pm_out_con,path_mem,small_state);
acs_test acs0_test(bm_data, acs_mem, acs_norm, acs_out,small_state);

//module metric_mem_test(clk, rst, path_mem_in, path_mem_out);
metric_mem_test mm0_test(clk,rst_n, acs_norm, acs_mem);

//module traceback_test(clk, rst_n, acs_out, small_state, next, decode_out);
traceback_test tb0_test(clk, rst_n, acs_out, small_state, next, decode_out);

endmodule

module viterbi_test_tb;
//module viterbi_test(clk, rst_n, data_in, next, decode_out);
wire [7:0]decode_out;
wire [15:0] next;
reg clk;
reg rst_n;
reg [1:0] data_in;
//half 5
//full 10
viterbi_test v_test(clk, rst_n, data_in, next, decode_out);

initial begin
	$monitor ("%t data_in = %b, next = %b, decode_out = %b",$time, data_in, 
			next,decode_out);
end

initial begin 
	clk = 1'b0;
forever #10 clk = ~clk;
end 

initial begin
	#0 rst_n = 1'b0; data_in = 2'b01;
	#5 rst_n = 1'b1; //data_in = 2'b01;
	
	//data_in = 2'b01;  @(posedge clk)
	data_in = 2'b10;  @(posedge clk)
	data_in = 2'b11;  @(posedge clk)
	data_in = 2'b00;  @(posedge clk)
	data_in = 2'b10;  @(posedge clk)
	data_in = 2'b01;  @(posedge clk)
	data_in = 2'b11;  @(posedge clk)
	data_in = 2'b00;  //@(posedge clk)
#5 $stop;
end
 
endmodule
	




