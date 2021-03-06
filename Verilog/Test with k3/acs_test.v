//compare sub module for model add-compare-select
module compare_test(sum_in_a,sum_in_b, min_metric, select);
//input
input [2:0] sum_in_a;
input [2:0] sum_in_b; //don't know why sum is 3 bit, will explain later

//output
output [2:0] min_metric;
output select;

reg [2:0] min_metric;
reg select;

//code
always@(sum_in_a or sum_in_b)
begin 
	if (sum_in_a<= sum_in_b) //less than or equal to
	begin 	min_metric <=sum_in_a; select <=0; end
	else begin
		min_metric <=sum_in_b; select <=1; end
end
endmodule

//module add_compare_select
//main module for path metric
module acs_test(bm_in,pm_in_con,pm_out_con,path_mem,small_state);
//input 
input [15:0] bm_in; //from bmc
input [11:0]pm_in_con; 
//output
output [11:0]pm_out_con;
output [3:0] path_mem;
output [1:0] small_state;

wire [11:0]pm_in_con;
wire [11:0]pm_out_con;

wire [2:0] pm_in[0:3];
wire [2:0] pm_out[0:3];

wire [1:0] bm0 [0:3];
wire [1:0] bm1 [0:3];

wire [2:0]sum0 [0:3];
wire [2:0]sum1 [0:3];

wire [3:0]path_mem;

//to find the smallest state 
wire [2:0] comp [0:1];
wire [2:0]smallest;
reg [1:0]small_state;

//main code

assign {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = bm_in;

assign {pm_in[0],pm_in[1],pm_in[2],pm_in[3]} = pm_in_con;

assign 	sum0[0] = bm0[0] + pm_in[0], sum1[0] = bm0[1] + pm_in[1],
	sum0[1] = bm0[2] + pm_in[2], sum1[1] = bm0[3] + pm_in[3],
	sum0[2] = bm1[0] + pm_in[0], sum1[2] = bm1[1] + pm_in[1],
	sum0[3] = bm1[2] + pm_in[2], sum1[3] = bm1[3] + pm_in[3];

//compare branch metric
//module compare(comp_en, sum_in_a,sum_in_b, min_metric, select);
compare_test comp0(sum0[0], sum1[0], pm_out[0], path_mem[0]);
compare_test comp1(sum0[1], sum1[1], pm_out[1], path_mem[1]);
compare_test comp2(sum0[2], sum1[2], pm_out[2], path_mem[2]);
compare_test comp3(sum0[3], sum1[3], pm_out[3], path_mem[3]);

assign pm_out_con = {pm_out[0],pm_out[1],pm_out[2],pm_out[3]};

assign 	comp[0] = (pm_out[0]<=pm_out[1])?pm_out[0]:pm_out[1];
assign	comp[1] = (pm_out[2]<=pm_out[3])?pm_out[2]:pm_out[3];
assign	smallest = (comp[0]<=comp[1])?comp[0]:comp[1];

always@(smallest or pm_out[0] or pm_out[1] or pm_out[2] or pm_out[3])
begin
case (smallest)
	pm_out[0]: small_state = 2'b00;
	pm_out[1]: small_state = 2'b01;
	pm_out[2]: small_state = 2'b10;
	pm_out[3]: small_state = 2'b11;
	default: small_state = 2'b00;
endcase
end

endmodule

module acs_connected_test(clk, rst_n, data_in, acs_norm, acs_out, small_state);
//input data
input clk;
input rst_n;
input [1:0] data_in;

wire [15:0] bm_data;
wire [11:0] acs_mem;

//output data
output [11:0] acs_norm;
output [3:0] acs_out;
output [1:0] small_state;


//connect all blocks

//module bmc(data_in, bm_out);
bmc_test bmc0_test(data_in,bm_data);

//module acs_test(bm_in,pm_in_con,pm_out_con,path_mem,small_state);
acs_test acs0_test(bm_data, acs_mem, acs_norm, acs_out,small_state);

//module metric_mem_test(clk, rst, path_mem_in, path_mem_out);
metric_mem_test mm0_test(clk,rst_n, acs_norm, acs_mem);
endmodule

module acs_connected_test_tb;
reg clk;
reg rst_n;
reg [1:0] data_in;

wire [11:0] acs_norm;
wire [3:0] acs_out;
wire [1:0] small_state;

initial begin
	$monitor ("%t data_in = %b, acs_norm = %b , acs_out =%b,small state = %b",$time, data_in, 
			acs_norm , acs_out,small_state);
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
	data_in = 2'b00;  
#5 $stop;
end

//module acs_connected_test(clk, rst_n, data_in, acs_norm, acs_out, small_state);
acs_connected_test acs2(clk, rst_n, data_in, acs_norm, acs_out,small_state);

endmodule
