module dff_448(clk,rst_n, d,q);
input rst_n, clk;
input [447:0]d;
output [447:0]q;

wire rst_n,clk;
wire [447:0]d;
reg [447:0]q;

always@(rst_n or posedge clk)
begin
	if(rst_n==0)
	q<=448'b0;
	else q<=d;
end
endmodule

module metric_mem(clk, rst, path_mem_in, path_mem_out);
//input data
input clk;
input rst;
input [447:0] path_mem_in;
//output data
output [447:0] path_mem_out;

wire clk;
wire rst;

wire [447:0] path_mem_in;
wire [447:0] path_mem_out;
//main code

dff_448 mm_h(clk, rst, path_mem_in, path_mem_out);

endmodule


