module control_unit(
input load,
input [2:0] control,
output reg stop, bmc, add, compare, select, smallest, tbu,
input clk, rst_n,
input stage_end);

begin
	localparam IDLE = 3'b000;
	localparam LOAD_BMC = 3'b001;
	localparam ADD = 3'b010;
	localparam COMPARE= 3'b011;
	localparam SELECT = 3'b100;
	localparam SMALLEST = 3'b101;
	localparam TRACEBACK =3'b110;

	reg [2:0] state, nextstate;
	
	always @(state or nextstate or control or load or stage_end)
	begin
	case(state)
	IDLE: begin
		if((load ==1) &&(control==3'b000)) begin
		nextstate = LOAD_BMC;
		stop =0; bmc=1; add = 0; compare =0; select=0; smallest =0; tbu=0; end
		else begin nextstate = IDLE;
		stop =1; bmc=0; add = 0; compare =0; select=0; smallest =0; tbu=0; end
	end
	LOAD_BMC: begin
		if ((load==1)&&(control == 3'b001)) begin
		nextstate = ADD;
		stop =0; bmc=0; add = 1; compare =0; select=0; smallest =0; tbu=0; end
		else begin nextstate = LOAD_BMC;
		stop =0; bmc=1; add =0; compare =0; select =0; smallest =0; tbu=0; end
	end
	ADD: begin
		if ((load==1)&&(control == 3'b010)) begin
		nextstate = COMPARE;
		stop =0; bmc=0; add = 0; compare =1; select=0; smallest =0; tbu=0; end
		else begin nextstate = ADD;
		stop =0; bmc=0; add =1; compare =0; select =0; smallest =0; tbu=0; end
	end
	COMPARE: begin
		if ((load==1)&&(control==3'b011)) begin
		nextstate = SELECT;
		stop =0; bmc=0; add = 0; compare =0; select =1; smallest =0; tbu=0; end
		else begin nextstate = COMPARE;
		stop = 0; bmc=0; add = 0; compare =1; select =0; smallest =0; tbu=0; end
	end
	SELECT: begin
		if ((load==1)&&(control==3'b100)) begin
		nextstate = SMALLEST;
		stop =0; bmc=0; add = 0; compare =0; select=0; smallest =1; tbu=0; end
		else begin nextstate = SELECT;
		stop = 0; bmc=0; add = 0; compare =0; select =1; smallest =0; tbu=0; end
	end
	SMALLEST: begin
		if((load ==1)&&(control==3'b101)&&(stage_end ==1)) begin
		nextstate = TRACEBACK;
		stop =0; bmc=0; add = 0; compare =0;select=0; smallest =0; tbu=1; end
		else begin nextstate = LOAD_BMC;
		stop =0; bmc=1; add = 0; compare =0;select =0; smallest =0; tbu=0; end
	end
	TRACEBACK: begin
		if ((load==1)&&(control==3'b110)&&(stage_end ==1)) begin
		nextstate = TRACEBACK;
		stop =0; bmc=0; add = 0; compare =0; select=0; smallest =0; tbu=1; end
		else begin nextstate = IDLE;
		stop = 1; bmc=0; add = 0; compare =0; select =0; smallest =0; tbu=0; end
	end
	default: begin nextstate = state;
	end 
	endcase
	end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	state<=IDLE;
	else state <=nextstate;
end
end
endmodule


module datapath (
input stop, bmc, add, compare, select, smallest, tbu,
output reg [7:0] decode,
input clk, rst_n,
//input [11:0] pm_in_con,
input [1:0] data_in,
output reg stage_end);

reg [3:0] stage;

reg [2:0] pm_in[0:3];
reg [2:0] pm_out[0:3];

reg [1:0] bm0 [0:3];
reg [1:0] bm1 [0:3];

reg [2:0]sum0 [0:3];
reg [2:0]sum1 [0:3];

reg [3:0]path_mem;

//to find the smallest state 
reg [2:0] comp [0:1];
reg [2:0]smallest_comp;
reg [1:0]smallest_state;
reg [3:0] surv [0:7];
reg [1:0] next [0:7];
//concatenate wire
//assign {pm_in[0],pm_in[1],pm_in[2],pm_in[3]} = pm_in_con;

always@(stage)
begin
	if(stage==0)
	{pm_in[0],pm_in[1],pm_in[2],pm_in[3]} = 12'b0;
	else
	{pm_in[0],pm_in[1],pm_in[2],pm_in[3]} = {pm_out[0],pm_out[1],pm_out[2],pm_out[3]};
end

//add_compare_select stage
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		stage<=0;
		decode<=8'b00000000;
		next[0]<=2'b00; next[1]<=2'b00; next[2]<=2'b00; next[3]<=2'b00; next[4]<=2'b00; next[5]<=2'b00; next[6]<=2'b00; next[7]<=2'b00;
		surv[0]<=4'b0000; surv[1]<=4'b0000; surv[2]<=4'b0000; surv[3]<=4'b0000;
		sum0[0]<=3'b000; sum0[1]<=3'b000; sum0[2]<=3'b000; sum0[3]<=3'b000;
		sum1[0]<=3'b000; sum1[1]<=3'b000; sum1[2]<=3'b000; sum1[3]<=3'b000;
		pm_out[0]<=3'b000; pm_out[1]<=3'b000; pm_out[2]<=3'b000; pm_out[3]<=3'b000;
		path_mem[0]<=0; path_mem[1]<=0; path_mem[2]<=0; path_mem[3]<=0;
		stage_end<=0;
	end
	else
	begin
		if(stop) begin
		stage<=stage;
		end

		else if(bmc) begin
		stage<=stage;
		case (data_in)
			2'b00: {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = 16'b00_01_10_01_00_01_10_01;
			2'b01: {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = 16'b01_00_01_10_01_00_01_10;
			2'b10: {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = 16'b01_10_01_00_01_10_01_00;
			2'b11: {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = 16'b10_01_00_01_10_01_00_01;
			default: {bm0[0],bm1[0],bm0[1],bm1[1],bm0[2],bm1[2],bm0[3],bm1[3]} = 16'b00_01_10_01_00_01_10_01;
		endcase 
		end
		else if(add) begin
		stage<=stage; 
		sum0[0] = bm0[0] + pm_in[0]; sum1[0] = bm0[1] + pm_in[1];
		sum0[1] = bm0[2] + pm_in[2]; sum1[1] = bm0[3] + pm_in[3];
		sum0[2] = bm1[0] + pm_in[0]; sum1[2] = bm1[1] + pm_in[1];
		sum0[3] = bm1[2] + pm_in[2]; sum1[3] = bm1[3] + pm_in[3];
		end
		else if(compare) begin
		stage <=stage; 
		pm_out[0] = (sum0[0]<=sum1[0])?sum0[0]:sum1[0];
		pm_out[1] = (sum0[1]<=sum1[1])?sum0[1]:sum1[1];
		pm_out[2] = (sum0[2]<=sum1[2])?sum0[2]:sum1[2];
		pm_out[3] = (sum0[3]<=sum1[3])?sum0[3]:sum1[3];
		end
		else if(select) begin
		stage <=stage; 
		path_mem[0] = (sum0[0]<=sum1[0])?0:1;
		path_mem[1] = (sum0[1]<=sum1[1])?0:1;
		path_mem[2] = (sum0[2]<=sum1[2])?0:1;
		path_mem[3] = (sum0[3]<=sum1[3])?0:1;
		
		surv[stage]= path_mem;
		
		end
		else if(smallest) begin
			if(stage== 4'b0111) begin
			stage_end = 1; stage<=stage; 
			comp[0] = (pm_out[0]<=pm_out[1])?pm_out[0]:pm_out[1];
			comp[1] = (pm_out[2]<=pm_out[3])?pm_out[2]:pm_out[3];
			smallest_comp = (comp[0]<=comp[1])?comp[0]:comp[1];
				case (smallest_comp)
					pm_out[0]: smallest_state = 2'b00;
					pm_out[1]: smallest_state = 2'b01;
					pm_out[2]: smallest_state = 2'b10;
					pm_out[3]: smallest_state = 2'b11;
					default: smallest_state = 2'b00;
				endcase
			end
			else begin stage <=stage +1; 
			comp[0] = (pm_out[0]<=pm_out[1])?pm_out[0]:pm_out[1];
			comp[1] = (pm_out[2]<=pm_out[3])?pm_out[2]:pm_out[3];
			smallest_comp = (comp[0]<=comp[1])?comp[0]:comp[1];
				case (smallest_comp)
					pm_out[0]: smallest_state = 2'b00;
					pm_out[1]: smallest_state = 2'b01;
					pm_out[2]: smallest_state = 2'b10;
					pm_out[3]: smallest_state = 2'b11;
					default: smallest_state = 2'b00;
				endcase
			end
		end
		else if (tbu) begin
		next[7] = {smallest_state[0],surv[7][smallest_state]};
		next[6] = {next[7][0], surv[6][next[7]]};
		next[5] = {next[6][0], surv[5][next[6]]};
		next[4] = {next[5][0], surv[4][next[5]]};
		next[3] = {next[4][0], surv[3][next[4]]};
		next[2] = {next[3][0], surv[2][next[3]]};
		next[1] = {next[2][0], surv[1][next[2]]};
		next[0] = {next[1][0], surv[0][next[1]]};
	
		decode = {next[1][1],next[2][1],next[3][1],next[4][1],next[5][1],next[6][1],next[7][1],smallest_state[1]};
		end
	end
end 

//assign pm_out_con = {pm_out[0],pm_out[1],pm_out[2],pm_out[3]};
endmodule

module top_module(
input load, 
input [2:0] control,
//input [11:0] pm_in_con,
input [1:2] data_in,
output [7:0] decode,
input clk, rst_n);

wire stop, bmc, add, compare, select, smallest, tbu;
wire stage_end;

//module acs_datapath(
//input stop, add, compare_select, smallest,
//output reg [11:0] pm_out_con,
//output [1:0] smallest_state,
//output [3:0] path_mem,
//input clk, rst_n,
//input [11:0] pm_in_con,
//input [15:0] bm_in,
//output reg [3:0] stage,
//output reg stage_end);

datapath dp(.stop(stop),.bmc(bmc),.add(add),.compare(compare),.select(select),.smallest(smallest),.tbu(tbu),
			.clk(clk),.rst_n(rst_n),
			//.pm_in_con(pm_in_con),
			.data_in(data_in),.decode(decode),.stage_end(stage_end));

//module acs_control(
//input load,
//input [1:0] control,
//output reg stop, add, compare_select, smallest,
//input clk, rst_n,
//input stage_end);

control_unit ctrl(.load(load),.control(control),
			.stop(stop),.bmc(bmc),.add(add),.compare(compare),.select(select),.smallest(smallest),.tbu(tbu),
			.clk(clk),.rst_n(rst_n),.stage_end(stage_end));
endmodule

module viterbi_asmd_tb1;
reg load;
reg [2:0] control;
reg clk, rst_n;

//reg [11:0] pm_in_con; 
reg [1:0] data_in;
wire [7:0] decode;
reg [15:0] data_sim;
reg [15:0] read_data[0:9];
integer i,j, cnt;

top_module acs_asmd_dut(.load(load),.control(control),.clk(clk),.rst_n(rst_n),
			//.pm_in_con(pm_in_con),
			.data_in(data_in),.decode(decode));
//clock
initial begin
	clk=1'b0;
	forever #10 clk = ~clk;
end
//input
initial
	begin
	    $readmemb("E:/Term20211/TKHTS2/input_16bit.txt",read_data);
	    for (i=0; i<10; i=i+1) // testing for reading the first 10 values from text file -> change this value when testing more values
        begin

			data_sim = read_data[i];
		    $display ("Starting to decode sequence = %b", data_sim);

            #0 rst_n =0; load=0; control =3'b000;
	        #5 rst_n =1; load=0; control =3'b000;
            
            load = 0; control =3'b000; data_in = data_sim[15:14]; @(posedge clk);
            load = 0; control =3'b001; data_in = data_sim[15:14]; @(posedge clk);//01
            load = 0; control =3'b010; data_in = data_sim[15:14]; @(posedge clk);
            load = 0; control =3'b011; data_in = data_sim[15:14]; @(posedge clk);
            load = 0; control =3'b100; data_in = data_sim[15:14]; @(posedge clk);
            load = 0; control =3'b101; data_in = data_sim[15:14]; @(posedge clk);
//load = 0; control =3'b110; data_in = 2'b01; pm_in_con = 12'b000000000000;@(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[15:14]; @(posedge clk);
            load = 1; control =3'b001; data_in = data_sim[15:14]; @(posedge clk);//01
            load = 1; control =3'b010; data_in = data_sim[15:14]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[15:14]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[15:14]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[15:14]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[15:14]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[13:12]; @(posedge clk); 
            load = 1; control =3'b001; data_in = data_sim[13:12]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[13:12]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[13:12]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[13:12]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[13:12]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[13:12]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[11:10]; @(posedge clk); //11
            load = 1; control =3'b001; data_in = data_sim[11:10]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[11:10]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[11:10]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[11:10]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[11:10]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[11:10]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[9:8]; @(posedge clk); //00
            load = 1; control =3'b001; data_in = data_sim[9:8]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[9:8]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[9:8]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[9:8]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[9:8]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[9:8]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[7:6]; @(posedge clk); //10
            load = 1; control =3'b001; data_in = data_sim[7:6]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[7:6]; @(posedge clk); 
            load = 1; control =3'b011; data_in = data_sim[7:6]; @(posedge clk); 
            load = 1; control =3'b100; data_in = data_sim[7:6]; @(posedge clk); 
            load = 1; control =3'b101; data_in = data_sim[7:6]; @(posedge clk); 
            load = 1; control =3'b110; data_in = data_sim[7:6]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[5:4]; @(posedge clk); //01
            load = 1; control =3'b001; data_in = data_sim[5:4]; @(posedge clk); 
            load = 1; control =3'b010; data_in = data_sim[5:4]; @(posedge clk); 
            load = 1; control =3'b011; data_in = data_sim[5:4]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[5:4]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[5:4]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[5:4]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[3:2]; @(posedge clk); //11
            load = 1; control =3'b001; data_in = data_sim[3:2]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[3:2]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[3:2]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[3:2]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[3:2]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[3:2]; @(posedge clk);

            load = 1; control =3'b000; data_in = data_sim[1:0]; @(posedge clk); //00
            load = 1; control =3'b001; data_in = data_sim[1:0]; @(posedge clk);
            load = 1; control =3'b010; data_in = data_sim[1:0]; @(posedge clk);
            load = 1; control =3'b011; data_in = data_sim[1:0]; @(posedge clk);
            load = 1; control =3'b100; data_in = data_sim[1:0]; @(posedge clk);
            load = 1; control =3'b101; data_in = data_sim[1:0]; @(posedge clk);
            load = 1; control =3'b110; data_in = data_sim[1:0]; @(posedge clk);

            /*load = 1; control =3'b000; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b001; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b010; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b011; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b100; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b101; data_in = 2'b01; @(posedge clk);
            load = 1; control =3'b110; data_in = 2'b01; @(posedge clk);

            load = 1; control =3'b000; data_in = 2'b00; @(posedge clk); //00
            load = 1; control =3'b001; data_in = 2'b00; @(posedge clk);
            load = 1; control =3'b010; data_in = 2'b00; @(posedge clk);
            load = 1; control =3'b011; data_in = 2'b00; @(posedge clk);
            load = 1; control =3'b100; data_in = 2'b00; @(posedge clk);
            load = 1; control =3'b101; data_in = 2'b00; @(posedge clk);
            load = 1; control =3'b110; data_in = 2'b00; @(posedge clk);

            load = 0; control =3'b000; data_in = 2'b01; @(posedge clk); */

        end
    #10 $stop;
    end

initial begin
$monitor ("load=%b, control=%b, data_in = %b, decode=%b", 
		load, control, data_in, decode);
end
endmodule