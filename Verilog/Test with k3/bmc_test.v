//convolution encoder
module conv_encoder_test(poly_a, poly_b, state, br_out);
//code rate = 1/2, constraint length = 3
//generator polynomial is 3 bit
//state is 2 bit, data out is 2 bit

input [2:0] poly_a; //poly_a = 101
input [2:0] poly_b; //poly_b = 111

input [2:0] state; 
// with most significant bit is the input in truth table
//the rest are state s0...s2

output [1:0] br_out;
wire [2:0]wa;
wire [2:0]wb;
reg [1:0]br_out;

assign wa = state&poly_a[2:0];
assign wb = state&poly_b[2:0];

always @(wa or wb)
begin
	br_out[1] = wa[0]^wa[1]^wa[2]; //encoded data at C0
	br_out[0] = wb[0]^wb[1]^wb[2]; //encoded data at C1
end

endmodule


//hamming calculation
//because code rate is 1/2, calculate 2bit at a time
module hamming_distance_test(data_in, br_out, ham_out);
input [1:0]data_in;
input [1:0]br_out;

output [1:0] ham_out;
wire[1:0] ham_out;

assign ham_out= (data_in[0]^br_out[0])+(data_in[1]^br_out[1]);

endmodule


//branch metric calculation
module bmc_test(data_in, bm_out);
input [1:0]data_in;
//contraint length =3, state = 2^2=4, 4*2=8 branches bc each state has 2 branches
//each hamming distance is 2 bit, compare all hamming distance of 8 branches =16 bit
output[15:0]bm_out;

wire [2:0] poly_a;
wire [2:0] poly_b;
//state in
wire [2:0] b0 [0:3];
wire [2:0] b1 [0:3];

//calculate the output of convolution code
wire [1:0] br0[0:3];
wire [1:0] br1[0:3];
//calculate hamming distance
wire [1:0] dout0[0:3];
wire [1:0] dout1[0:3];

assign 	poly_a = 3'b001, 
	poly_b = 3'b101;

assign	b0[0]=3'b000,
	b0[1]=3'b001,
	b0[2]=3'b010,
	b0[3]=3'b011,

	b1[0]=3'b100,
	b1[1]=3'b101,
	b1[2]=3'b110,
	b1[3]=3'b111;

conv_encoder_test e0_0(poly_a, poly_b, b0[0], br0[0]); 
conv_encoder_test e0_1(poly_a, poly_b, b0[1], br0[1]);
conv_encoder_test e0_2(poly_a, poly_b, b0[2], br0[2]);
conv_encoder_test e0_3(poly_a, poly_b, b0[3], br0[3]);

conv_encoder_test e1_0(poly_a, poly_b, b1[0], br1[0]); 
conv_encoder_test e1_1(poly_a, poly_b, b1[1], br1[1]);
conv_encoder_test e1_2(poly_a, poly_b, b1[2], br1[2]);
conv_encoder_test e1_3(poly_a, poly_b, b1[3], br1[3]);

hamming_distance_test h0_0(data_in, br0[0], dout0[0]);
hamming_distance_test h0_1(data_in, br0[1], dout0[1]);
hamming_distance_test h0_2(data_in, br0[2], dout0[2]);
hamming_distance_test h0_3(data_in, br0[3], dout0[3]);

hamming_distance_test h1_0(data_in, br1[0], dout1[0]);
hamming_distance_test h1_1(data_in, br1[1], dout1[1]);
hamming_distance_test h1_2(data_in, br1[2], dout1[2]);
hamming_distance_test h1_3(data_in, br1[3], dout1[3]);

assign bm_out = {dout0[0],dout1[0],dout0[1],dout1[1],dout0[2],dout1[2],dout0[3],dout1[3]};

endmodule

module bmc_test_tb;
reg [1:0]data_in;
wire[15:0]bm_out;

bmc_test bmc_test_dut(data_in, bm_out);

initial begin: input_gen
	data_in = 2'b00; 
#10 data_in = 2'b01; 
#10 data_in = 2'b10;
#10 data_in = 2'b11;
end

//monitor output
initial
begin: mon_output
	$monitor("%t: data in=%b, bm_out=%b", $time, data_in, bm_out);
end: mon_output
 
endmodule
