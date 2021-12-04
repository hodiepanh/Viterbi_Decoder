module viterbi(clk, rst_n, data_in, next, decode_out);
//input data
input clk;
input rst_n;
input [1:0] data_in;
//output data
output [7:0]decode_out;
output [47:0] next;

wire clk;
wire rst_n;
wire [1:0] data_in;

wire [255:0] bm_data;
wire [447:0] acs_mem;

wire [447:0] acs_norm;
wire [5:0] small_state;
wire [63:0] acs_out;
wire [7:0] decode_out;



//module bmc(data_in, bm_out);
bmc bmc1(data_in,bm_data);

//module acs(comp_en, bm_in,pm_in_h, pm_in_l,pm_out_h,pm_out_l,path_mem);
acs acs1(bm_data, acs_mem, acs_norm, acs_out,small_state);

//module metric_mem(clk, rst, path_mem_in_h, path_mem_in_l, path_mem_out_h, path_mem_out_l);
metric_mem mm1(clk,rst_n, acs_norm, acs_mem);

//module traceback(clk, rst_n, acs_out, small_state, decode_out);
traceback tb1(clk, rst_n, acs_out, small_state, next, decode_out);

endmodule

module viterbi_tb;
//module viterbi_test(clk, rst_n, data_in, next, decode_out);
wire [7:0]decode_out;
wire [47:0] next;
reg clk;
reg rst_n;
reg [1:0] data_in;

viterbi v0(clk, rst_n, data_in, next, decode_out);

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



