//compare sub module for model add-compare-select
module compare(sum_in_a,sum_in_b, min_metric, select);
//input
input [6:0] sum_in_a;
input [6:0] sum_in_b; 

//output
output [6:0] min_metric;
output select;

reg [6:0] min_metric;
reg select;

//code
always@(sum_in_a or sum_in_b)
begin 
	if (sum_in_a<= sum_in_b) //less than or equal to
	begin
		min_metric<=sum_in_a; select <=0;
	end
	else begin
		min_metric<=sum_in_b; select <=1;
	end
end
endmodule

//module add_compare_select
//main module for path metric

module acs(bm_in,pm_in_con,pm_out_con,path_mem,small_state);
//input 
input [255:0] bm_in; //from bmc

input [447:0]pm_in_con;

//output
output [447:0]pm_out_con;
output [63:0] path_mem;
output [5:0] small_state;

wire [447:0]pm_in_con;

wire [447:0]pm_out_con;

wire [6:0] pm_in[0:63];
wire [6:0] pm_out[0:63];

wire [1:0] bm0 [0:63];
wire [1:0] bm1 [0:63];

wire [6:0]sum0 [0:63];
wire [6:0]sum1 [0:63];

wire [63:0]path_mem;
wire [6:0] comp [0:61];
wire [6:0]smallest;
reg [5:0]small_state;
//main code

assign {bm0[0],bm1[0],
bm0[1],bm1[1],
bm0[2],bm1[2],
bm0[3],bm1[3],
bm0[4],bm1[4],
bm0[5],bm1[5],
bm0[6],bm1[6],
bm0[7],bm1[7],
bm0[8],bm1[8],
bm0[9],bm1[9],

bm0[10],bm1[10],
bm0[11],bm1[11],
bm0[12],bm1[12],
bm0[13],bm1[13],
bm0[14],bm1[14],
bm0[15],bm1[15],
bm0[16],bm1[16],
bm0[17],bm1[17],
bm0[18],bm1[18],
bm0[19],bm1[19],

bm0[20],bm1[20],
bm0[21],bm1[21],
bm0[22],bm1[22],
bm0[23],bm1[23],
bm0[24],bm1[24],
bm0[25],bm1[25],
bm0[26],bm1[26],
bm0[27],bm1[27],
bm0[28],bm1[28],
bm0[29],bm1[29],

bm0[30],bm1[30],
bm0[31],bm1[31],
bm0[32],bm1[32],
bm0[33],bm1[33],
bm0[34],bm1[34],
bm0[35],bm1[35],
bm0[36],bm1[36],
bm0[37],bm1[37],
bm0[38],bm1[38],
bm0[39],bm1[39],

bm0[40],bm1[40],
bm0[41],bm1[41],
bm0[42],bm1[42],
bm0[43],bm1[43],
bm0[44],bm1[44],
bm0[45],bm1[45],
bm0[46],bm1[46],
bm0[47],bm1[47],
bm0[48],bm1[48],
bm0[49],bm1[49],

bm0[50],bm1[50],
bm0[51],bm1[51],
bm0[52],bm1[52],
bm0[53],bm1[53],
bm0[54],bm1[54],
bm0[55],bm1[55],
bm0[56],bm1[56],
bm0[57],bm1[57],
bm0[58],bm1[58],
bm0[59],bm1[59],

bm0[60],bm1[60],
bm0[61],bm1[61],
bm0[62],bm1[62],
bm0[63],bm1[63]}=bm_in;

assign {pm_in[0], pm_in[1],pm_in[2],pm_in[3],pm_in[4], pm_in[5],pm_in[6],pm_in[7],pm_in[8],pm_in[9],
pm_in[10], pm_in[11],pm_in[12],pm_in[13],pm_in[14], pm_in[15],pm_in[16],pm_in[17],pm_in[18],pm_in[19],
pm_in[20], pm_in[21],pm_in[22],pm_in[23],pm_in[24], pm_in[25],pm_in[26],pm_in[27],pm_in[28],pm_in[29],
pm_in[30], pm_in[31],pm_in[32],pm_in[33],pm_in[34], pm_in[35],pm_in[36],pm_in[37],pm_in[38],pm_in[39],
pm_in[40], pm_in[41],pm_in[42],pm_in[43],pm_in[44], pm_in[45],pm_in[46],pm_in[47],pm_in[48],pm_in[49],
pm_in[50], pm_in[51],pm_in[52],pm_in[53],pm_in[54], pm_in[55],pm_in[56],pm_in[57],pm_in[58],pm_in[59],
pm_in[60], pm_in[61],pm_in[62],pm_in[63]} = pm_in_con;

assign 	sum0[0] = bm0[0] + pm_in[0], sum1[0] = bm0[1] + pm_in[1],
	sum0[1] = bm0[2] + pm_in[2], sum1[1] = bm0[3] + pm_in[3],
	sum0[2] = bm0[4] + pm_in[4], sum1[2] = bm0[5] + pm_in[5],
	sum0[3] = bm0[6] + pm_in[6], sum1[3] = bm0[7] + pm_in[7],
	sum0[4] = bm0[8] + pm_in[8], sum1[4] = bm0[9] + pm_in[9],
	sum0[5] = bm0[10] + pm_in[10], sum1[5] = bm0[11] + pm_in[11],
	sum0[6] = bm0[12] + pm_in[12], sum1[6] = bm0[13] + pm_in[13],
	sum0[7] = bm0[14] + pm_in[14], sum1[7] = bm0[15] + pm_in[15],
	sum0[8] = bm0[16] + pm_in[16], sum1[8] = bm0[17] + pm_in[17],
	sum0[9] = bm0[18] + pm_in[18], sum1[9] = bm0[19] + pm_in[19],
	
	sum0[10] = bm0[20] + pm_in[20], sum1[10] = bm0[21] + pm_in[21],
	sum0[11] = bm0[22] + pm_in[22], sum1[11] = bm0[23] + pm_in[23],
	sum0[12] = bm0[24] + pm_in[24], sum1[12] = bm0[25] + pm_in[25],
	sum0[13] = bm0[26] + pm_in[26], sum1[13] = bm0[27] + pm_in[27],
	sum0[14] = bm0[28] + pm_in[28], sum1[14] = bm0[29] + pm_in[29],
	sum0[15] = bm0[30] + pm_in[30], sum1[15] = bm0[31] + pm_in[31],
	sum0[16] = bm0[32] + pm_in[32], sum1[16] = bm0[33] + pm_in[33],
	sum0[17] = bm0[34] + pm_in[34], sum1[17] = bm0[35] + pm_in[35],
	sum0[18] = bm0[36] + pm_in[36], sum1[18] = bm0[37] + pm_in[37],
	sum0[19] = bm0[38] + pm_in[38], sum1[19] = bm0[39] + pm_in[39],

	sum0[20] = bm0[40] + pm_in[40], sum1[20] = bm0[41] + pm_in[41],
	sum0[21] = bm0[42] + pm_in[42], sum1[21] = bm0[43] + pm_in[43],
	sum0[22] = bm0[44] + pm_in[44], sum1[22] = bm0[45] + pm_in[45],
	sum0[23] = bm0[46] + pm_in[46], sum1[23] = bm0[47] + pm_in[47],
	sum0[24] = bm0[48] + pm_in[48], sum1[24] = bm0[49] + pm_in[49],
	sum0[25] = bm0[50] + pm_in[50], sum1[25] = bm0[51] + pm_in[51],
	sum0[26] = bm0[52] + pm_in[52], sum1[26] = bm0[53] + pm_in[53],
	sum0[27] = bm0[54] + pm_in[54], sum1[27] = bm0[55] + pm_in[55],
	sum0[28] = bm0[56] + pm_in[56], sum1[28] = bm0[57] + pm_in[57],
	sum0[29] = bm0[58] + pm_in[58], sum1[29] = bm0[59] + pm_in[59],

	sum0[30] = bm0[60] + pm_in[60], sum1[30] = bm0[61] + pm_in[61],
	sum0[31] = bm0[62] + pm_in[62], sum1[31] = bm0[63] + pm_in[63],

//branch 1

	sum0[32] = bm1[0] + pm_in[0], sum1[32] = bm1[1] + pm_in[1],
	sum0[33] = bm1[2] + pm_in[2], sum1[33] = bm1[3] + pm_in[3],
	sum0[34] = bm1[4] + pm_in[4], sum1[34] = bm1[5] + pm_in[5],
	sum0[35] = bm1[6] + pm_in[6], sum1[35] = bm1[7] + pm_in[7],
	sum0[36] = bm1[8] + pm_in[8], sum1[36] = bm1[9] + pm_in[9],
	sum0[37] = bm1[10] + pm_in[10], sum1[37] = bm1[11] + pm_in[11],
	sum0[38] = bm1[12] + pm_in[12], sum1[38] = bm1[13] + pm_in[13],
	sum0[39] = bm1[14] + pm_in[14], sum1[39] = bm1[15] + pm_in[15],
	sum0[40] = bm1[16] + pm_in[16], sum1[40] = bm1[17] + pm_in[17],
	sum0[41] = bm1[18] + pm_in[18], sum1[41] = bm1[19] + pm_in[19],
	
	sum0[42] = bm1[20] + pm_in[20], sum1[42] = bm1[21] + pm_in[21],
	sum0[43] = bm1[22] + pm_in[22], sum1[43] = bm1[23] + pm_in[23],
	sum0[44] = bm1[24] + pm_in[24], sum1[44] = bm1[25] + pm_in[25],
	sum0[45] = bm1[26] + pm_in[26], sum1[45] = bm1[27] + pm_in[27],
	sum0[46] = bm1[28] + pm_in[28], sum1[46] = bm1[29] + pm_in[29],
	sum0[47] = bm1[30] + pm_in[30], sum1[47] = bm1[31] + pm_in[31],
	sum0[48] = bm1[32] + pm_in[32], sum1[48] = bm1[33] + pm_in[33],
	sum0[49] = bm1[34] + pm_in[34], sum1[49] = bm1[35] + pm_in[35],
	sum0[50] = bm1[36] + pm_in[36], sum1[50] = bm1[37] + pm_in[37],
	sum0[51] = bm1[38] + pm_in[38], sum1[51] = bm1[39] + pm_in[39],

	sum0[52] = bm1[40] + pm_in[40], sum1[52] = bm1[41] + pm_in[41],
	sum0[53] = bm1[42] + pm_in[42], sum1[53] = bm1[43] + pm_in[43],
	sum0[54] = bm1[44] + pm_in[44], sum1[54] = bm1[45] + pm_in[45],
	sum0[55] = bm1[46] + pm_in[46], sum1[55] = bm1[47] + pm_in[47],
	sum0[56] = bm1[48] + pm_in[48], sum1[56] = bm1[49] + pm_in[49],
	sum0[57] = bm1[50] + pm_in[50], sum1[57] = bm1[51] + pm_in[51],
	sum0[58] = bm1[52] + pm_in[52], sum1[58] = bm1[53] + pm_in[53],
	sum0[59] = bm1[54] + pm_in[54], sum1[59] = bm1[55] + pm_in[55],
	sum0[60] = bm1[56] + pm_in[56], sum1[60] = bm1[57] + pm_in[57],
	sum0[61] = bm1[58] + pm_in[58], sum1[61] = bm1[59] + pm_in[59],

	sum0[62] = bm1[60] + pm_in[60], sum1[62] = bm1[61] + pm_in[61],
	sum0[63] = bm1[62] + pm_in[62], sum1[63] = bm1[63] + pm_in[63];


//compare branch metric
//module compare(comp_en, sum_in_a,sum_in_b, min_metric, select);
compare comp0(sum0[0], sum1[0], pm_out[0], path_mem[0]);
compare comp1(sum0[1], sum1[1], pm_out[1], path_mem[1]);
compare comp2(sum0[2], sum1[2], pm_out[2], path_mem[2]);
compare comp3(sum0[3], sum1[3], pm_out[3], path_mem[3]);
compare comp4(sum0[4], sum1[4], pm_out[4], path_mem[4]);
compare comp5(sum0[5], sum1[5], pm_out[5], path_mem[5]);
compare comp6(sum0[6], sum1[6], pm_out[6], path_mem[6]);
compare comp7(sum0[7], sum1[7], pm_out[7], path_mem[7]);
compare comp8(sum0[8], sum1[8], pm_out[8], path_mem[8]);
compare comp9(sum0[9], sum1[9], pm_out[9], path_mem[9]);

compare comp10(sum0[10], sum1[10], pm_out[10], path_mem[10]);
compare comp11(sum0[11], sum1[11], pm_out[11], path_mem[11]);
compare comp12(sum0[12], sum1[12], pm_out[12], path_mem[12]);
compare comp13(sum0[13], sum1[13], pm_out[13], path_mem[13]);
compare comp14(sum0[14], sum1[14], pm_out[14], path_mem[14]);
compare comp15(sum0[15], sum1[15], pm_out[15], path_mem[15]);
compare comp16(sum0[16], sum1[16], pm_out[16], path_mem[16]);
compare comp17(sum0[17], sum1[17], pm_out[17], path_mem[17]);
compare comp18(sum0[18], sum1[18], pm_out[18], path_mem[18]);
compare comp19(sum0[19], sum1[19], pm_out[19], path_mem[19]);

compare comp20(sum0[20], sum1[20], pm_out[20], path_mem[20]);
compare comp21(sum0[21], sum1[21], pm_out[21], path_mem[21]);
compare comp22(sum0[22], sum1[22], pm_out[22], path_mem[22]);
compare comp23(sum0[23], sum1[23], pm_out[23], path_mem[23]);
compare comp24(sum0[24], sum1[24], pm_out[24], path_mem[24]);
compare comp25(sum0[25], sum1[25], pm_out[25], path_mem[25]);
compare comp26(sum0[26], sum1[26], pm_out[26], path_mem[26]);
compare comp27(sum0[27], sum1[27], pm_out[27], path_mem[27]);
compare comp28(sum0[28], sum1[28], pm_out[28], path_mem[28]);
compare comp29(sum0[29], sum1[29], pm_out[29], path_mem[29]);

compare comp30(sum0[30], sum1[30], pm_out[30], path_mem[30]);
compare comp31(sum0[31], sum1[31], pm_out[31], path_mem[31]);
compare comp32(sum0[32], sum1[32], pm_out[32], path_mem[32]);
compare comp33(sum0[33], sum1[33], pm_out[33], path_mem[33]);
compare comp34(sum0[34], sum1[34], pm_out[34], path_mem[34]);
compare comp35(sum0[35], sum1[35], pm_out[35], path_mem[35]);
compare comp36(sum0[36], sum1[36], pm_out[36], path_mem[36]);
compare comp37(sum0[37], sum1[37], pm_out[37], path_mem[37]);
compare comp38(sum0[38], sum1[38], pm_out[38], path_mem[38]);
compare comp39(sum0[39], sum1[39], pm_out[39], path_mem[39]);

compare comp40(sum0[40], sum1[40], pm_out[40], path_mem[40]);
compare comp41(sum0[41], sum1[41], pm_out[41], path_mem[41]);
compare comp42(sum0[42], sum1[42], pm_out[42], path_mem[42]);
compare comp43(sum0[43], sum1[43], pm_out[43], path_mem[43]);
compare comp44(sum0[44], sum1[44], pm_out[44], path_mem[44]);
compare comp45(sum0[45], sum1[45], pm_out[45], path_mem[45]);
compare comp46(sum0[46], sum1[46], pm_out[46], path_mem[46]);
compare comp47(sum0[47], sum1[47], pm_out[47], path_mem[47]);
compare comp48(sum0[48], sum1[48], pm_out[48], path_mem[48]);
compare comp49(sum0[49], sum1[49], pm_out[49], path_mem[49]);

compare comp50(sum0[50], sum1[50], pm_out[50], path_mem[50]);
compare comp51(sum0[51], sum1[51], pm_out[51], path_mem[51]);
compare comp52(sum0[52], sum1[52], pm_out[52], path_mem[52]);
compare comp53(sum0[53], sum1[53], pm_out[53], path_mem[53]);
compare comp54(sum0[54], sum1[54], pm_out[54], path_mem[54]);
compare comp55(sum0[55], sum1[55], pm_out[55], path_mem[55]);
compare comp56(sum0[56], sum1[56], pm_out[56], path_mem[56]);
compare comp57(sum0[57], sum1[57], pm_out[57], path_mem[57]);
compare comp58(sum0[58], sum1[58], pm_out[58], path_mem[58]);
compare comp59(sum0[59], sum1[59], pm_out[59], path_mem[59]);

compare comp60(sum0[60], sum1[60], pm_out[60], path_mem[60]);
compare comp61(sum0[61], sum1[61], pm_out[61], path_mem[61]);
compare comp62(sum0[62], sum1[62], pm_out[62], path_mem[62]);
compare comp63(sum0[63], sum1[63], pm_out[63], path_mem[63]);

assign pm_out_con = {pm_out[0], pm_out[1],pm_out[2],pm_out[3],pm_out[4], pm_out[5],pm_out[6],pm_out[7],pm_out[8],pm_out[9],
pm_out[10], pm_out[11],pm_out[12],pm_out[13],pm_out[14], pm_out[15],pm_out[16],pm_out[17],pm_out[18],pm_out[19],
pm_out[20], pm_out[21],pm_out[22],pm_out[23],pm_out[24], pm_out[25],pm_out[26],pm_out[27],pm_out[28],pm_out[29],
pm_out[30], pm_out[31],pm_out[32],pm_out[33],pm_out[34], pm_out[35],pm_out[36],pm_out[37],pm_out[38],pm_out[39],
pm_out[40], pm_out[41],pm_out[42],pm_out[43],pm_out[44], pm_out[45],pm_out[46],pm_out[47],pm_out[48],pm_out[49],
pm_out[50], pm_out[51],pm_out[52],pm_out[53],pm_out[54], pm_out[55],pm_out[56],pm_out[57],pm_out[58],pm_out[59],
pm_out[60], pm_out[61],pm_out[62],pm_out[63]};

assign 	comp[0] = (pm_out[0]<=pm_out[1])?pm_out[0]:pm_out[1],
	comp[1] = (pm_out[2]<=pm_out[3])?pm_out[2]:pm_out[3],
	comp[2] = (pm_out[4]<=pm_out[5])?pm_out[4]:pm_out[5],
	comp[3] = (pm_out[6]<=pm_out[7])?pm_out[6]:pm_out[7],
	comp[4] = (pm_out[8]<=pm_out[9])?pm_out[8]:pm_out[9],
	comp[5] = (pm_out[10]<=pm_out[11])?pm_out[10]:pm_out[11],
	comp[6] = (pm_out[12]<=pm_out[13])?pm_out[12]:pm_out[13],
	comp[7] = (pm_out[14]<=pm_out[15])?pm_out[14]:pm_out[15],
	comp[8] = (pm_out[16]<=pm_out[17])?pm_out[16]:pm_out[17],
	comp[9] = (pm_out[18]<=pm_out[19])?pm_out[18]:pm_out[19],
	comp[10] = (pm_out[20]<=pm_out[21])?pm_out[20]:pm_out[21],
	comp[11] = (pm_out[22]<=pm_out[23])?pm_out[22]:pm_out[23],
	comp[12] = (pm_out[24]<=pm_out[25])?pm_out[24]:pm_out[25],
	comp[13] = (pm_out[26]<=pm_out[27])?pm_out[26]:pm_out[27],
	comp[14] = (pm_out[28]<=pm_out[29])?pm_out[28]:pm_out[29],
	comp[15] = (pm_out[30]<=pm_out[31])?pm_out[30]:pm_out[31],
	comp[16] = (pm_out[32]<=pm_out[33])?pm_out[32]:pm_out[33],
	comp[17] = (pm_out[34]<=pm_out[35])?pm_out[34]:pm_out[35],
	comp[18] = (pm_out[36]<=pm_out[37])?pm_out[36]:pm_out[37],
	comp[19] = (pm_out[38]<=pm_out[39])?pm_out[38]:pm_out[39],
	comp[20] = (pm_out[40]<=pm_out[41])?pm_out[40]:pm_out[41],
	comp[21] = (pm_out[42]<=pm_out[43])?pm_out[42]:pm_out[43],
	comp[22] = (pm_out[44]<=pm_out[45])?pm_out[44]:pm_out[45],
	comp[23] = (pm_out[46]<=pm_out[47])?pm_out[46]:pm_out[47],
	comp[24] = (pm_out[48]<=pm_out[49])?pm_out[48]:pm_out[49],
	comp[25] = (pm_out[50]<=pm_out[51])?pm_out[50]:pm_out[51],
	comp[26] = (pm_out[52]<=pm_out[53])?pm_out[52]:pm_out[53],
	comp[27] = (pm_out[54]<=pm_out[55])?pm_out[54]:pm_out[55],
	comp[28] = (pm_out[56]<=pm_out[57])?pm_out[56]:pm_out[57],
	comp[29] = (pm_out[58]<=pm_out[59])?pm_out[58]:pm_out[59],
	comp[30] = (pm_out[60]<=pm_out[61])?pm_out[60]:pm_out[61],
	comp[31] = (pm_out[62]<=pm_out[63])?pm_out[62]:pm_out[63],

	comp[32] = (comp[0]<=comp[1])?comp[0]:comp[1],
	comp[33] = (comp[2]<=comp[3])?comp[2]:comp[3],
	comp[34] = (comp[4]<=comp[5])?comp[4]:comp[5],
	comp[35] = (comp[6]<=comp[7])?comp[6]:comp[7],
	comp[36] = (comp[8]<=comp[9])?comp[8]:comp[9],
	comp[37] = (comp[10]<=comp[11])?comp[10]:comp[11],
	comp[38] = (comp[12]<=comp[13])?comp[12]:comp[13],
	comp[39] = (comp[14]<=comp[15])?comp[14]:comp[15],
	comp[40] = (comp[16]<=comp[17])?comp[16]:comp[17],
	comp[41] = (comp[18]<=comp[19])?comp[18]:comp[19],
	comp[42] = (comp[20]<=comp[21])?comp[20]:comp[21],
	comp[43] = (comp[22]<=comp[23])?comp[22]:comp[23],
	comp[44] = (comp[24]<=comp[25])?comp[24]:comp[25],
	comp[45] = (comp[26]<=comp[27])?comp[26]:comp[27],
	comp[46] = (comp[28]<=comp[29])?comp[28]:comp[29],
	comp[47] = (comp[30]<=comp[31])?comp[30]:comp[31],

	
	comp[48] = (comp[32]<=comp[33])?comp[32]:comp[33],
	comp[49] = (comp[34]<=comp[35])?comp[34]:comp[35],
	comp[50] = (comp[36]<=comp[37])?comp[36]:comp[37],
	comp[51] = (comp[38]<=comp[39])?comp[38]:comp[39],
	comp[52] = (comp[40]<=comp[41])?comp[40]:comp[41],
	comp[53] = (comp[42]<=comp[43])?comp[42]:comp[43],
	comp[54] = (comp[44]<=comp[45])?comp[44]:comp[45],
	comp[55] = (comp[46]<=comp[47])?comp[46]:comp[47],
	
	comp[56] = (comp[48]<=comp[49])?comp[48]:comp[49],
	comp[57] = (comp[50]<=comp[51])?comp[50]:comp[51],
	comp[58] = (comp[52]<=comp[53])?comp[52]:comp[53],
	comp[59] = (comp[54]<=comp[55])?comp[54]:comp[55],

	comp[60] = (comp[56]<=comp[57])?comp[56]:comp[57],
	comp[61] = (comp[58]<=comp[59])?comp[58]:comp[59],
	
	smallest = (comp[60]<=comp[61])?comp[60]:comp[61];


always@(smallest 
or pm_out[0] or pm_out[1] or pm_out[2] or pm_out[3] or pm_out[4] or pm_out[5] or pm_out[6] or pm_out[7] or pm_out[8] or pm_out[9]
or pm_out[10] or pm_out[11] or pm_out[12] or pm_out[13] or pm_out[14] or pm_out[15] or pm_out[16] or pm_out[17] or pm_out[18] or pm_out[19]
or pm_out[20] or pm_out[21] or pm_out[22] or pm_out[23] or pm_out[24] or pm_out[25] or pm_out[26] or pm_out[27] or pm_out[28] or pm_out[29]
or pm_out[30] or pm_out[31] or pm_out[32] or pm_out[33] or pm_out[34] or pm_out[35] or pm_out[36] or pm_out[37] or pm_out[38] or pm_out[39]
or pm_out[40] or pm_out[41] or pm_out[42] or pm_out[43] or pm_out[44] or pm_out[45] or pm_out[46] or pm_out[47] or pm_out[48] or pm_out[49]
or pm_out[50] or pm_out[51] or pm_out[52] or pm_out[53] or pm_out[54] or pm_out[55] or pm_out[56] or pm_out[57] or pm_out[58] or pm_out[59]
or pm_out[60] or pm_out[61] or pm_out[62] or pm_out[63])
begin
case (smallest)
	pm_out[0]: small_state = 6'b000_000;
	pm_out[1]: small_state = 6'b000_001;
	pm_out[2]: small_state = 6'b000_010;
	pm_out[3]: small_state = 6'b000_011;
	pm_out[4]: small_state = 6'b000_100;
	pm_out[5]: small_state = 6'b000_101;
	pm_out[6]: small_state = 6'b000_110;
	pm_out[7]: small_state = 6'b000_111;

	pm_out[8]: small_state = 6'b001_000;
	pm_out[9]: small_state = 6'b001_001;
	pm_out[10]: small_state = 6'b001_010;
	pm_out[11]: small_state = 6'b001_011;
	pm_out[12]: small_state = 6'b001_100;
	pm_out[13]: small_state = 6'b001_101;
	pm_out[14]: small_state = 6'b001_110;
	pm_out[15]: small_state = 6'b001_111;

	pm_out[16]: small_state = 6'b010_000;
	pm_out[17]: small_state = 6'b010_001;
	pm_out[18]: small_state = 6'b010_010;
	pm_out[19]: small_state = 6'b010_011;
	pm_out[20]: small_state = 6'b010_100;
	pm_out[21]: small_state = 6'b010_101;
	pm_out[22]: small_state = 6'b010_110;
	pm_out[23]: small_state = 6'b010_111;

	pm_out[24]: small_state = 6'b011_000;
	pm_out[25]: small_state = 6'b011_001;
	pm_out[26]: small_state = 6'b011_010;
	pm_out[27]: small_state = 6'b011_011;
	pm_out[28]: small_state = 6'b011_100;
	pm_out[29]: small_state = 6'b011_101;
	pm_out[30]: small_state = 6'b011_110;
	pm_out[31]: small_state = 6'b011_111;

	pm_out[32]: small_state = 6'b100_000;
	pm_out[33]: small_state = 6'b100_001;
	pm_out[34]: small_state = 6'b100_010;
	pm_out[35]: small_state = 6'b100_011;
	pm_out[36]: small_state = 6'b100_100;
	pm_out[37]: small_state = 6'b100_101;
	pm_out[38]: small_state = 6'b100_110;
	pm_out[39]: small_state = 6'b100_111;

	pm_out[40]: small_state = 6'b101_000;
	pm_out[41]: small_state = 6'b101_001;
	pm_out[42]: small_state = 6'b101_010;
	pm_out[43]: small_state = 6'b101_011;
	pm_out[44]: small_state = 6'b101_100;
	pm_out[45]: small_state = 6'b101_101;
	pm_out[46]: small_state = 6'b101_110;
	pm_out[47]: small_state = 6'b101_111;

	pm_out[48]: small_state = 6'b110_000;
	pm_out[49]: small_state = 6'b110_001;
	pm_out[50]: small_state = 6'b110_010;
	pm_out[51]: small_state = 6'b110_011;
	pm_out[52]: small_state = 6'b110_100;
	pm_out[53]: small_state = 6'b110_101;
	pm_out[54]: small_state = 6'b110_110;
	pm_out[55]: small_state = 6'b110_111;

	pm_out[56]: small_state = 6'b111_000;
	pm_out[57]: small_state = 6'b111_001;
	pm_out[58]: small_state = 6'b111_010;
	pm_out[59]: small_state = 6'b111_011;
	pm_out[60]: small_state = 6'b111_100;
	pm_out[61]: small_state = 6'b111_101;
	pm_out[62]: small_state = 6'b111_110;
	pm_out[63]: small_state = 6'b111_111;
	default: small_state = 6'b000_000;

endcase
end
endmodule

module acs_connected(clk, rst_n, data_in,acs_norm, acs_out, small_state);
//input data
input clk;
input rst_n;
input [1:0] data_in;
//output data

//wire [1:0] data_out;
wire [255:0] bm_data;
wire [447:0] acs_mem;

output [447:0] acs_norm;
output [63:0] acs_out;
output [5:0] small_state;


//connect all blocks
//module bmc(data_in, bm_out);
bmc bmc0(data_in,bm_data);

//module acs(bm_in,pm_in,pm_out,path_mem,small_state);
acs acs0(bm_data, acs_mem, acs_norm, acs_out,small_state);

//module metric_mem(clk, rst, path_mem_in, path_mem_out);
metric_mem mm0(clk,rst_n, acs_norm, acs_mem);

endmodule

module acs_connected_tb;
reg clk;
reg rst_n;
reg [1:0] data_in;

wire [447:0] acs_norm;
wire [63:0] acs_out;
wire [5:0] small_state;

initial begin
	$monitor ("%t data_in = %b, acs_out =%b,small state = %b",$time, data_in, acs_out,small_state);
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

//module acs_connected(clk, rst_n, data_in, acs_norm, acs_out,small_state);
acs_connected acs_con0(clk, rst_n, data_in, acs_norm, acs_out,small_state);

endmodule



