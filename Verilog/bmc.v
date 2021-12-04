//convolution encoder
module conv_encoder(poly_a, poly_b, state, br_out);
//code rate = 1/2, constraint length = 7
//generator polynomial is 7 bit
//state is 6 bit, data out is 2 bit

input [6:0] poly_a; //poly_a = 111_1001
input [6:0] poly_b; //poly_b = 101_1011

input [6:0] state; 
// with most significant bit is the input in truth table
//the rest are state s0...s5

output [1:0] br_out;
wire [6:0]wa;
wire [6:0]wb;
reg [1:0]br_out;

assign wa = state&poly_a[6:0];
assign wb = state&poly_b[6:0];

always @(wa or wb)
begin
	br_out[1] = wa[0]^wa[1]^wa[2]^wa[3]^wa[4]^wa[5]^wa[6]; //encoded data at C0 
	br_out[0] = wb[0]^wb[1]^wb[2]^wb[3]^wb[4]^wb[5]^wb[6]; //encoded data at C1
end

endmodule


//hamming calculation
//because code rate is 1/2, calculate 2bit at a time
module hamming_distance(data_in, br_out, ham_out);
input [1:0]data_in;
input [1:0]br_out;

output [1:0] ham_out;
wire[1:0] ham_out;

assign ham_out= (data_in[0]^br_out[0])+(data_in[1]^br_out[1]);

endmodule


//branch metric calculation
module bmc(data_in, bm_out);
input [1:0]data_in;
//contraint length =7, state = 2^6=64, 128 branches bc each state has 2 branches
//each hamming distance is 2 bit, compare all hamming distance of 128 branches =256 bit
output[255:0]bm_out;

wire [6:0] poly_a;
wire [6:0] poly_b;
//state in
wire [6:0] b0 [0:63];
wire [6:0] b1 [0:63];

//calculate the output of convolution code
wire [1:0] br0[0:63];
wire [1:0] br1[0:63];
//calculate hamming distance
wire [1:0] dout0[0:63];
wire [1:0] dout1[0:63];

assign 	poly_a = 7'b111_1001, 
	poly_b = 7'b101_1011;

assign	b0[0]=7'b000_0000,
	b0[1]=7'b000_0001,
	b0[2]=7'b000_0010,
	b0[3]=7'b000_0011,
	b0[4]=7'b000_0100,
	b0[5]=7'b000_0101,
	b0[6]=7'b000_0110,
	b0[7]=7'b000_0111,
	b0[8]=7'b000_1000,
	b0[9]=7'b000_1001,

b0[10]=7'b000_1010,
b0[11]=7'b000_1011,
b0[12]=7'b000_1100,
b0[13]=7'b000_1101,
b0[14]=7'b000_1110,
b0[15]=7'b000_1111,
b0[16]=7'b001_0000,
b0[17]=7'b001_0001,
b0[18]=7'b001_0010,
b0[19]=7'b001_0011,

	b0[20]=7'b001_0100,
	b0[21]=7'b001_0101,
	b0[22]=7'b001_0110,
	b0[23]=7'b001_0111,
	b0[24]=7'b001_1000,
	b0[25]=7'b001_1001,
	b0[26]=7'b001_1010,
	b0[27]=7'b001_1011,
	b0[28]=7'b001_1100,
	b0[29]=7'b001_1101,

b0[30]=7'b001_1110,
b0[31]=7'b001_1111,
b0[32]=7'b010_0000,
b0[33]=7'b010_0001,
b0[34]=7'b010_0010,
b0[35]=7'b010_0011,
b0[36]=7'b010_0100,
b0[37]=7'b010_0101,
b0[38]=7'b010_0110,
b0[39]=7'b010_0111,

	b0[40]=7'b010_1000,
	b0[41]=7'b010_1001,
	b0[42]=7'b010_1010,
	b0[43]=7'b010_1011,
	b0[44]=7'b010_1100,
	b0[45]=7'b010_1101,
	b0[46]=7'b010_1110,
	b0[47]=7'b010_1111,
	b0[48]=7'b011_0000,
	b0[49]=7'b011_0001,

b0[50]=7'b011_0010,
b0[51]=7'b011_0011,
b0[52]=7'b011_0100,
b0[53]=7'b011_0101,
b0[54]=7'b011_0110,
b0[55]=7'b011_0111,
b0[56]=7'b011_1000,
b0[57]=7'b011_1001,
b0[58]=7'b011_1010,
b0[59]=7'b011_1011,
	
	b0[60]=7'b011_1100,
	b0[61]=7'b011_1101,
	b0[62]=7'b011_1110,
	b0[63]=7'b011_1111,

b1[0]=7'b100_0000,
b1[1]=7'b100_0001,
b1[2]=7'b100_0010,
b1[3]=7'b100_0011,
b1[4]=7'b100_0100,
b1[5]=7'b100_0101,
b1[6]=7'b100_0110,
b1[7]=7'b100_0111,
b1[8]=7'b100_1000,
b1[9]=7'b100_1001,

	b1[10]=7'b100_1010,
	b1[11]=7'b100_1011,
	b1[12]=7'b100_1100,
	b1[13]=7'b100_1101,
	b1[14]=7'b100_1110,
	b1[15]=7'b100_1111,
	b1[16]=7'b101_0000,
	b1[17]=7'b101_0001,
	b1[18]=7'b101_0010,
	b1[19]=7'b101_0011,

b1[20]=7'b101_0100,
b1[21]=7'b101_0101,
b1[22]=7'b101_0110,
b1[23]=7'b101_0111,
b1[24]=7'b101_1000,
b1[25]=7'b101_1001,
b1[26]=7'b101_1010,
b1[27]=7'b101_1011,
b1[28]=7'b101_1100,
b1[29]=7'b101_1101,
	
	b1[30]=7'b101_1110,
	b1[31]=7'b101_1111,
	b1[32]=7'b110_0000,
	b1[33]=7'b110_0001,
	b1[34]=7'b110_0010,
	b1[35]=7'b110_0011,
	b1[36]=7'b110_0100,
	b1[37]=7'b110_0101,
	b1[38]=7'b110_0110,
	b1[39]=7'b110_0111,
	b1[40]=7'b110_1000,

b1[41]=7'b110_1001,
b1[42]=7'b110_1010,
b1[43]=7'b110_1011,
b1[44]=7'b110_1100,
b1[45]=7'b110_1101,
b1[46]=7'b110_1110,
b1[47]=7'b110_1111,
b1[48]=7'b111_0000,
b1[49]=7'b111_0001,
	
	b1[50]=7'b111_0010,
	b1[51]=7'b111_0011,
	b1[52]=7'b111_0100,
	b1[53]=7'b111_0101,
	b1[54]=7'b111_0110,
	b1[55]=7'b111_0111,
	b1[56]=7'b111_1000,
	b1[57]=7'b111_1001,
	b1[58]=7'b111_1010,
	b1[59]=7'b111_1011,

b1[60]=7'b111_1100,
b1[61]=7'b111_1101,
b1[62]=7'b111_1110,
b1[63]=7'b111_1111;

conv_encoder e0_0(poly_a, poly_b, b0[0], br0[0]);
conv_encoder e0_1(poly_a, poly_b, b0[1], br0[1]); 
conv_encoder e0_2(poly_a, poly_b, b0[2], br0[2]);
conv_encoder e0_3(poly_a, poly_b, b0[3], br0[3]);
conv_encoder e0_4(poly_a, poly_b, b0[4], br0[4]);
conv_encoder e0_5(poly_a, poly_b, b0[5], br0[5]);
conv_encoder e0_6(poly_a, poly_b, b0[6], br0[6]);
conv_encoder e0_7(poly_a, poly_b, b0[7], br0[7]);
conv_encoder e0_8(poly_a, poly_b, b0[8], br0[8]);
conv_encoder e0_9(poly_a, poly_b, b0[9], br0[9]);

conv_encoder e0_10(poly_a, poly_b, b0[10], br0[10]); 
conv_encoder e0_11(poly_a, poly_b, b0[11], br0[11]); 
conv_encoder e0_12(poly_a, poly_b, b0[12], br0[12]); 
conv_encoder e0_13(poly_a, poly_b, b0[13], br0[13]); 
conv_encoder e0_14(poly_a, poly_b, b0[14], br0[14]); 
conv_encoder e0_15(poly_a, poly_b, b0[15], br0[15]);
conv_encoder e0_16(poly_a, poly_b, b0[16], br0[16]); 
conv_encoder e0_17(poly_a, poly_b, b0[17], br0[17]);
conv_encoder e0_18(poly_a, poly_b, b0[18], br0[18]); 
conv_encoder e0_19(poly_a, poly_b, b0[19], br0[19]);

conv_encoder e0_20(poly_a, poly_b, b0[20], br0[20]); 
conv_encoder e0_21(poly_a, poly_b, b0[21], br0[21]); 
conv_encoder e0_22(poly_a, poly_b, b0[22], br0[22]); 
conv_encoder e0_23(poly_a, poly_b, b0[23], br0[23]); 
conv_encoder e0_24(poly_a, poly_b, b0[24], br0[24]);
conv_encoder e0_25(poly_a, poly_b, b0[25], br0[25]); 
conv_encoder e0_26(poly_a, poly_b, b0[26], br0[26]); 
conv_encoder e0_27(poly_a, poly_b, b0[27], br0[27]); 
conv_encoder e0_28(poly_a, poly_b, b0[28], br0[28]);
conv_encoder e0_29(poly_a, poly_b, b0[29], br0[29]); 

conv_encoder e0_30(poly_a, poly_b, b0[30], br0[30]);
conv_encoder e0_31(poly_a, poly_b, b0[31], br0[31]);
conv_encoder e0_32(poly_a, poly_b, b0[32], br0[32]); 
conv_encoder e0_33(poly_a, poly_b, b0[33], br0[33]); 
conv_encoder e0_34(poly_a, poly_b, b0[34], br0[34]); 
conv_encoder e0_35(poly_a, poly_b, b0[35], br0[35]);
conv_encoder e0_36(poly_a, poly_b, b0[36], br0[36]);
conv_encoder e0_37(poly_a, poly_b, b0[37], br0[37]);
conv_encoder e0_38(poly_a, poly_b, b0[38], br0[38]);
conv_encoder e0_39(poly_a, poly_b, b0[39], br0[39]);

conv_encoder e0_40(poly_a, poly_b, b0[40], br0[40]);
conv_encoder e0_41(poly_a, poly_b, b0[41], br0[41]);
conv_encoder e0_42(poly_a, poly_b, b0[42], br0[42]);
conv_encoder e0_43(poly_a, poly_b, b0[43], br0[43]);
conv_encoder e0_44(poly_a, poly_b, b0[44], br0[44]);
conv_encoder e0_45(poly_a, poly_b, b0[45], br0[45]);
conv_encoder e0_46(poly_a, poly_b, b0[46], br0[46]);
conv_encoder e0_47(poly_a, poly_b, b0[47], br0[47]);
conv_encoder e0_48(poly_a, poly_b, b0[48], br0[48]); 
conv_encoder e0_49(poly_a, poly_b, b0[49], br0[49]);

conv_encoder e0_50(poly_a, poly_b, b0[50], br0[50]);
conv_encoder e0_51(poly_a, poly_b, b0[51], br0[51]);
conv_encoder e0_52(poly_a, poly_b, b0[52], br0[52]); 
conv_encoder e0_53(poly_a, poly_b, b0[53], br0[53]);
conv_encoder e0_54(poly_a, poly_b, b0[54], br0[54]); 
conv_encoder e0_55(poly_a, poly_b, b0[55], br0[55]); 
conv_encoder e0_56(poly_a, poly_b, b0[56], br0[56]); 
conv_encoder e0_57(poly_a, poly_b, b0[57], br0[57]); 
conv_encoder e0_58(poly_a, poly_b, b0[58], br0[58]);
conv_encoder e0_59(poly_a, poly_b, b0[59], br0[59]);

conv_encoder e0_60(poly_a, poly_b, b0[60], br0[60]); 
conv_encoder e0_61(poly_a, poly_b, b0[61], br0[61]);
conv_encoder e0_62(poly_a, poly_b, b0[62], br0[62]); 
conv_encoder e0_63(poly_a, poly_b, b0[63], br0[63]);

conv_encoder e1_0(poly_a, poly_b, b1[0], br1[0]);
conv_encoder e1_1(poly_a, poly_b, b1[1], br1[1]); 
conv_encoder e1_2(poly_a, poly_b, b1[2], br1[2]);
conv_encoder e1_3(poly_a, poly_b, b1[3], br1[3]);
conv_encoder e1_4(poly_a, poly_b, b1[4], br1[4]);
conv_encoder e1_5(poly_a, poly_b, b1[5], br1[5]);
conv_encoder e1_6(poly_a, poly_b, b1[6], br1[6]);
conv_encoder e1_7(poly_a, poly_b, b1[7], br1[7]);
conv_encoder e1_8(poly_a, poly_b, b1[8], br1[8]);
conv_encoder e1_9(poly_a, poly_b, b1[9], br1[9]);

conv_encoder e1_10(poly_a, poly_b, b1[10], br1[10]); 
conv_encoder e1_11(poly_a, poly_b, b1[11], br1[11]); 
conv_encoder e1_12(poly_a, poly_b, b1[12], br1[12]); 
conv_encoder e1_13(poly_a, poly_b, b1[13], br1[13]); 
conv_encoder e1_14(poly_a, poly_b, b1[14], br1[14]); 
conv_encoder e1_15(poly_a, poly_b, b1[15], br1[15]);
conv_encoder e1_16(poly_a, poly_b, b1[16], br1[16]); 
conv_encoder e1_17(poly_a, poly_b, b1[17], br1[17]);
conv_encoder e1_18(poly_a, poly_b, b1[18], br1[18]); 
conv_encoder e1_19(poly_a, poly_b, b1[19], br1[19]);

conv_encoder e1_20(poly_a, poly_b, b1[20], br1[20]); 
conv_encoder e1_21(poly_a, poly_b, b1[21], br1[21]); 
conv_encoder e1_22(poly_a, poly_b, b1[22], br1[22]); 
conv_encoder e1_23(poly_a, poly_b, b1[23], br1[23]); 
conv_encoder e1_24(poly_a, poly_b, b1[24], br1[24]);
conv_encoder e1_25(poly_a, poly_b, b1[25], br1[25]); 
conv_encoder e1_26(poly_a, poly_b, b1[26], br1[26]); 
conv_encoder e1_27(poly_a, poly_b, b1[27], br1[27]); 
conv_encoder e1_28(poly_a, poly_b, b1[28], br1[28]);
conv_encoder e1_29(poly_a, poly_b, b1[29], br1[29]); 

conv_encoder e1_30(poly_a, poly_b, b1[30], br1[30]);
conv_encoder e1_31(poly_a, poly_b, b1[31], br1[31]);
conv_encoder e1_32(poly_a, poly_b, b1[32], br1[32]); 
conv_encoder e1_33(poly_a, poly_b, b1[33], br1[33]); 
conv_encoder e1_34(poly_a, poly_b, b1[34], br1[34]); 
conv_encoder e1_35(poly_a, poly_b, b1[35], br1[35]);
conv_encoder e1_36(poly_a, poly_b, b1[36], br1[36]);
conv_encoder e1_37(poly_a, poly_b, b1[37], br1[37]);
conv_encoder e1_38(poly_a, poly_b, b1[38], br1[38]);
conv_encoder e1_39(poly_a, poly_b, b1[39], br1[39]);

conv_encoder e1_40(poly_a, poly_b, b1[40], br1[40]);
conv_encoder e1_41(poly_a, poly_b, b1[41], br1[41]);
conv_encoder e1_42(poly_a, poly_b, b1[42], br1[42]);
conv_encoder e1_43(poly_a, poly_b, b1[43], br1[43]);
conv_encoder e1_44(poly_a, poly_b, b1[44], br1[44]);
conv_encoder e1_45(poly_a, poly_b, b1[45], br1[45]);
conv_encoder e1_46(poly_a, poly_b, b1[46], br1[46]);
conv_encoder e1_47(poly_a, poly_b, b1[47], br1[47]);
conv_encoder e1_48(poly_a, poly_b, b1[48], br1[48]); 
conv_encoder e1_49(poly_a, poly_b, b1[49], br1[49]);

conv_encoder e1_50(poly_a, poly_b, b1[50], br1[50]);
conv_encoder e1_51(poly_a, poly_b, b1[51], br1[51]);
conv_encoder e1_52(poly_a, poly_b, b1[52], br1[52]); 
conv_encoder e1_53(poly_a, poly_b, b1[53], br1[53]);
conv_encoder e1_54(poly_a, poly_b, b1[54], br1[54]); 
conv_encoder e1_55(poly_a, poly_b, b1[55], br1[55]); 
conv_encoder e1_56(poly_a, poly_b, b1[56], br1[56]); 
conv_encoder e1_57(poly_a, poly_b, b1[57], br1[57]); 
conv_encoder e1_58(poly_a, poly_b, b1[58], br1[58]);
conv_encoder e1_59(poly_a, poly_b, b1[59], br1[59]);

conv_encoder e1_60(poly_a, poly_b, b1[60], br1[60]); 
conv_encoder e1_61(poly_a, poly_b, b1[61], br1[61]);
conv_encoder e1_62(poly_a, poly_b, b1[62], br1[62]); 
conv_encoder e1_63(poly_a, poly_b, b1[63], br1[63]);

hamming_distance h0_0(data_in, br0[0], dout0[0]);
hamming_distance h0_1(data_in, br0[1], dout0[1]);
hamming_distance h0_2(data_in, br0[2], dout0[2]);
hamming_distance h0_3(data_in, br0[3], dout0[3]);
hamming_distance h0_4(data_in, br0[4], dout0[4]);
hamming_distance h0_5(data_in, br0[5], dout0[5]);
hamming_distance h0_6(data_in, br0[6], dout0[6]);
hamming_distance h0_7(data_in, br0[7], dout0[7]);
hamming_distance h0_8(data_in, br0[8], dout0[8]);
hamming_distance h0_9(data_in, br0[9], dout0[9]);

hamming_distance h0_10(data_in, br0[10], dout0[10]);
hamming_distance h0_11(data_in, br0[11], dout0[11]);
hamming_distance h0_12(data_in, br0[12], dout0[12]);
hamming_distance h0_13(data_in, br0[13], dout0[13]);
hamming_distance h0_14(data_in, br0[14], dout0[14]);
hamming_distance h0_15(data_in, br0[15], dout0[15]);
hamming_distance h0_16(data_in, br0[16], dout0[16]);
hamming_distance h0_17(data_in, br0[17], dout0[17]);
hamming_distance h0_18(data_in, br0[18], dout0[18]);
hamming_distance h0_19(data_in, br0[19], dout0[19]);

hamming_distance h0_20(data_in, br0[20], dout0[20]);
hamming_distance h0_21(data_in, br0[21], dout0[21]);
hamming_distance h0_22(data_in, br0[22], dout0[22]);
hamming_distance h0_23(data_in, br0[23], dout0[23]);
hamming_distance h0_24(data_in, br0[24], dout0[24]);
hamming_distance h0_25(data_in, br0[25], dout0[25]);
hamming_distance h0_26(data_in, br0[26], dout0[26]);
hamming_distance h0_27(data_in, br0[27], dout0[27]);
hamming_distance h0_28(data_in, br0[28], dout0[28]);
hamming_distance h0_29(data_in, br0[29], dout0[29]);

hamming_distance h0_30(data_in, br0[30], dout0[30]);
hamming_distance h0_31(data_in, br0[31], dout0[31]);
hamming_distance h0_32(data_in, br0[32], dout0[32]);
hamming_distance h0_33(data_in, br0[33], dout0[33]);
hamming_distance h0_34(data_in, br0[34], dout0[34]);
hamming_distance h0_35(data_in, br0[35], dout0[35]);
hamming_distance h0_36(data_in, br0[36], dout0[36]);
hamming_distance h0_37(data_in, br0[37], dout0[37]);
hamming_distance h0_38(data_in, br0[38], dout0[38]);
hamming_distance h0_39(data_in, br0[39], dout0[39]);

hamming_distance h0_40(data_in, br0[40], dout0[40]);
hamming_distance h0_41(data_in, br0[41], dout0[41]);
hamming_distance h0_42(data_in, br0[42], dout0[42]);
hamming_distance h0_43(data_in, br0[43], dout0[43]);
hamming_distance h0_44(data_in, br0[44], dout0[44]);
hamming_distance h0_45(data_in, br0[45], dout0[45]);
hamming_distance h0_46(data_in, br0[46], dout0[46]);
hamming_distance h0_47(data_in, br0[47], dout0[47]);
hamming_distance h0_48(data_in, br0[48], dout0[48]);
hamming_distance h0_49(data_in, br0[49], dout0[49]);

hamming_distance h0_50(data_in, br0[50], dout0[50]);
hamming_distance h0_51(data_in, br0[51], dout0[51]);
hamming_distance h0_52(data_in, br0[52], dout0[52]);
hamming_distance h0_53(data_in, br0[53], dout0[53]);
hamming_distance h0_54(data_in, br0[54], dout0[54]);
hamming_distance h0_55(data_in, br0[55], dout0[55]);
hamming_distance h0_56(data_in, br0[56], dout0[56]);
hamming_distance h0_57(data_in, br0[57], dout0[57]);
hamming_distance h0_58(data_in, br0[58], dout0[58]);
hamming_distance h0_59(data_in, br0[59], dout0[59]);

hamming_distance h0_60(data_in, br0[60], dout0[60]);
hamming_distance h0_61(data_in, br0[61], dout0[61]);
hamming_distance h0_62(data_in, br0[62], dout0[62]);
hamming_distance h0_63(data_in, br0[63], dout0[63]);

hamming_distance h1_0(data_in, br1[0], dout1[0]);
hamming_distance h1_1(data_in, br1[1], dout1[1]);
hamming_distance h1_2(data_in, br1[2], dout1[2]);
hamming_distance h1_3(data_in, br1[3], dout1[3]);
hamming_distance h1_4(data_in, br1[4], dout1[4]);
hamming_distance h1_5(data_in, br1[5], dout1[5]);
hamming_distance h1_6(data_in, br1[6], dout1[6]);
hamming_distance h1_7(data_in, br1[7], dout1[7]);
hamming_distance h1_8(data_in, br1[8], dout1[8]);
hamming_distance h1_9(data_in, br1[9], dout1[9]);

hamming_distance h1_10(data_in, br1[10], dout1[10]);
hamming_distance h1_11(data_in, br1[11], dout1[11]);
hamming_distance h1_12(data_in, br1[12], dout1[12]);
hamming_distance h1_13(data_in, br1[13], dout1[13]);
hamming_distance h1_14(data_in, br1[14], dout1[14]);
hamming_distance h1_15(data_in, br1[15], dout1[15]);
hamming_distance h1_16(data_in, br1[16], dout1[16]);
hamming_distance h1_17(data_in, br1[17], dout1[17]);
hamming_distance h1_18(data_in, br1[18], dout1[18]);
hamming_distance h1_19(data_in, br1[19], dout1[19]);

hamming_distance h1_20(data_in, br1[20], dout1[20]);
hamming_distance h1_21(data_in, br1[21], dout1[21]);
hamming_distance h1_22(data_in, br1[22], dout1[22]);
hamming_distance h1_23(data_in, br1[23], dout1[23]);
hamming_distance h1_24(data_in, br1[24], dout1[24]);
hamming_distance h1_25(data_in, br1[25], dout1[25]);
hamming_distance h1_26(data_in, br1[26], dout1[26]);
hamming_distance h1_27(data_in, br1[27], dout1[27]);
hamming_distance h1_28(data_in, br1[28], dout1[28]);
hamming_distance h1_29(data_in, br1[29], dout1[29]);

hamming_distance h1_30(data_in, br1[30], dout1[30]);
hamming_distance h1_31(data_in, br1[31], dout1[31]);
hamming_distance h1_32(data_in, br1[32], dout1[32]);
hamming_distance h1_33(data_in, br1[33], dout1[33]);
hamming_distance h1_34(data_in, br1[34], dout1[34]);
hamming_distance h1_35(data_in, br1[35], dout1[35]);
hamming_distance h1_36(data_in, br1[36], dout1[36]);
hamming_distance h1_37(data_in, br1[37], dout1[37]);
hamming_distance h1_38(data_in, br1[38], dout1[38]);
hamming_distance h1_39(data_in, br1[39], dout1[39]);

hamming_distance h1_40(data_in, br1[40], dout1[40]);
hamming_distance h1_41(data_in, br1[41], dout1[41]);
hamming_distance h1_42(data_in, br1[42], dout1[42]);
hamming_distance h1_43(data_in, br1[43], dout1[43]);
hamming_distance h1_44(data_in, br1[44], dout1[44]);
hamming_distance h1_45(data_in, br1[45], dout1[45]);
hamming_distance h1_46(data_in, br1[46], dout1[46]);
hamming_distance h1_47(data_in, br1[47], dout1[47]);
hamming_distance h1_48(data_in, br1[48], dout1[48]);
hamming_distance h1_49(data_in, br1[49], dout1[49]);

hamming_distance h1_50(data_in, br1[50], dout1[50]);
hamming_distance h1_51(data_in, br1[51], dout1[51]);
hamming_distance h1_52(data_in, br1[52], dout1[52]);
hamming_distance h1_53(data_in, br1[53], dout1[53]);
hamming_distance h1_54(data_in, br1[54], dout1[54]);
hamming_distance h1_55(data_in, br1[55], dout1[55]);
hamming_distance h1_56(data_in, br1[56], dout1[56]);
hamming_distance h1_57(data_in, br1[57], dout1[57]);
hamming_distance h1_58(data_in, br1[58], dout1[58]);
hamming_distance h1_59(data_in, br1[59], dout1[59]);

hamming_distance h1_60(data_in, br1[60], dout1[60]);
hamming_distance h1_61(data_in, br1[61], dout1[61]);
hamming_distance h1_62(data_in, br1[62], dout1[62]);
hamming_distance h1_63(data_in, br1[63], dout1[63]);

assign bm_out={
dout0[0],dout1[0],
dout0[1],dout1[1],
dout0[2],dout1[2],
dout0[3],dout1[3],
dout0[4],dout1[4],
dout0[5],dout1[5],
dout0[6],dout1[6],
dout0[7],dout1[7],
dout0[8],dout1[8],
dout0[9],dout1[9],

dout0[10],dout1[10],
dout0[11],dout1[11],
dout0[12],dout1[12],
dout0[13],dout1[13],
dout0[14],dout1[14],
dout0[15],dout1[15],
dout0[16],dout1[16],
dout0[17],dout1[17],
dout0[18],dout1[18],
dout0[19],dout1[19],

dout0[20],dout1[20],
dout0[21],dout1[21],
dout0[22],dout1[22],
dout0[23],dout1[23],
dout0[24],dout1[24],
dout0[25],dout1[25],
dout0[26],dout1[26],
dout0[27],dout1[27],
dout0[28],dout1[28],
dout0[29],dout1[29],

dout0[30],dout1[30],
dout0[31],dout1[31],
dout0[32],dout1[32],
dout0[33],dout1[33],
dout0[34],dout1[34],
dout0[35],dout1[35],
dout0[36],dout1[36],
dout0[37],dout1[37],
dout0[38],dout1[38],
dout0[39],dout1[39],

dout0[40],dout1[40],
dout0[41],dout1[41],
dout0[42],dout1[42],
dout0[43],dout1[43],
dout0[44],dout1[44],
dout0[45],dout1[45],
dout0[46],dout1[46],
dout0[47],dout1[47],
dout0[48],dout1[48],
dout0[49],dout1[49],

dout0[50],dout1[50],
dout0[51],dout1[51],
dout0[52],dout1[52],
dout0[53],dout1[53],
dout0[54],dout1[54],
dout0[55],dout1[55],
dout0[56],dout1[56],
dout0[57],dout1[57],
dout0[58],dout1[58],
dout0[59],dout1[59],

dout0[60],dout1[60],
dout0[61],dout1[61],
dout0[62],dout1[62],
dout0[63],dout1[63]};


endmodule

module bmc_tb;
reg [1:0]data_in;
wire[255:0]bm_out;

bmc bmc_dut(data_in, bm_out);

initial begin: input_gen
	data_in = 2'b00; 
#10 data_in = 2'b01; 
#10 data_in = 2'b10;
#10 data_in = 2'b11;
end

//monitor output
initial
begin: mon_output
	$monitor("%t: data in=%b, bm_out=%h", $time, data_in, bm_out,);
end: mon_output
 
endmodule
