

//Memory_Transfer
module memory_transfer(clock, Reset, DataInA);
	 wire[4:0] count;
	 input clock, Reset;
	 wire[2:0] AddrA;
	 input wire [7:0] DataInA;
	 wire [7:0] DOut1;
	 wire [7:0] DOut2;
	 wire [7:0] AddOut;
	 wire [7:0] SubOut;
	 wire Sign;
	 wire [1:0] AddrB;
	 wire [7:0] DataInB;
	 wire[7:0] DataOut;
	 wire WEA,IncA, WEB,IncB;

	controller contr_MUT(.clock(clock), .Reset(Reset), .WEA(WEA), .WEB(WEB), 
	.IncA(IncA), .IncB(IncB), .count(count));
	counter_a count_a_MUT(.AddrA(AddrA), .clock(clock),.Reset(Reset), .IncA(IncA));
memoryA mem_a_MUT(.DataInA(DataInA), .AddrA(AddrA), .WEA(WEA), .DOut1(DOut1),.count(count));
	DFlipFlop ff_MUT(.DOut1(DOut1), .DOut2(DOut2), .clock(clock));
	Comp comp_MUT(.DOut1(DOut1), .DOut2(DOut2), .Sign(Sign));
	Adder add_MUT(.AddOut(AddOut), .DOut1(DOut1), .DOut2(DOut2));
	subtractor sub_MUT(.SubOut(SubOut), .DOut1(DOut1), .DOut2(DOut2));
	MUX mux_MUT(.Sign(Sign), .AddOut(AddOut), .SubOut(SubOut), .DataInB(DataInB));
	counter_b count_b_MUT(.IncB(IncB), .Reset(Reset), .clock(clock), .AddrB(AddrB));
memoryB mem_b_MUT(.DataInB(DataInB), .AddrB(AddrB), .WEB(WEB),.DataOut(DataOut),.count(count));

endmodule       //Memory_Transfer

//Controller
`timescale 1ns/1ns
module controller(clock, Reset, WEA, WEB, IncA, IncB, count);
	input clock;
	output reg[4:0]count=0;
	input Reset;
	output reg WEA, WEB, IncA, IncB;

always @ (Reset==1)
	begin
	count <=0;
	IncA <=0;
	IncB <=0;
	WEA <=0;
	WEB <=0;
	end
always @ (posedge clock)
	begin
	count = count+1;
	
	if (count<9)
	begin
		WEA <=1;
	end
	else
	begin
		WEA <= 0;
	end

	if(count<17 && Reset==0)
	begin
		IncA <=1;
	end
	else
	begin
		IncA<=0;
	end

	if(((count ==11) || (count ==13) || (count ==15) || (count ==17)) && Reset==0)
	begin
		 WEB<=1;
	end
	else
	begin
		WEB<=0;
	end
	if(((count ==12) || (count ==14) || (count ==16) || (count ==18)) && Reset==0)
	begin
		IncB<=1;
	end
	else
	begin
		IncB<=0;
	end
	
end
endmodule     //Controller


//Counter_A

module counter_a(AddrA, clock, Reset, IncA);
	output reg[2:0] AddrA;
	input clock;
	input Reset;
	input IncA;

	always @ (Reset==1)
		AddrA<=-1;

	always @ (posedge clock && IncA==1)
		AddrA <= AddrA+1;
	
endmodule  //Counter_A


//Memory_A

`timescale 1ns/1ns
module memoryA(DataInA, AddrA, WEA, DOut1,count);
	input [7:0]DataInA;
	input [2:0]AddrA;
	input WEA;
	output reg [7:0] DOut1;
	reg[7:0] SRAM[7:0];
	input[4:0] count;



	always @(AddrA)
		begin
		if(WEA==1)
			begin
			SRAM[AddrA]<=DataInA;
			end

		else  
	 		begin
	   		DOut1<=SRAM[AddrA-1];
		if((AddrA==0) && (count==17))
			begin
			DOut1<= SRAM[7];
			end
			end
		end

endmodule   // Memory A


//D Flip-Flop

module DFlipFlop(DOut1,clock,DOut2);
	input [7:0]DOut1;
	input clock;
	output [7:0]DOut2;
	wire [7:0]DOut1;
	reg [7:0] DOut2;

	always @(posedge clock)
	begin 
		DOut2<=DOut1;
	end

endmodule    //D Flip-Flop


//Comparator

module Comp(DOut1,DOut2,Sign);
	input [7:0]DOut1;
	input [7:0]DOut2;
	output Sign;
	reg Sign;

	always @(DOut1 or DOut2)
	begin
		if(DOut2>DOut1)
			Sign<=0;
		else
			Sign<=1;
	end
endmodule   // Comparator



//Adder

module Adder(AddOut, DOut1, DOut2);
	input[7:0] DOut1, DOut2;
	output[7:0] AddOut;
	reg[7:0] AddOut;

	always @(DOut1 or DOut2)
	begin
		AddOut <= DOut1 + DOut2;
	end

endmodule   //Adder


//Subtractor

module subtractor(SubOut, DOut1, DOut2);
	input[7:0] DOut1, DOut2;
	output[7:0] SubOut;
	reg[7:0] SubOut;

	always @(DOut1 or DOut2)
	begin
		SubOut <= DOut2 - DOut1;
	end
endmodule   //Subtractor


//Multiplexer

module MUX(Sign,AddOut,SubOut,DataInB);
	input Sign;
	input [7:0] AddOut,SubOut;
	output reg [7:0] DataInB;

	always @(Sign or AddOut or SubOut)
	begin
		case(Sign)
		1:DataInB=AddOut;
		0:DataInB=SubOut;
		default:DataInB=AddOut;
	endcase
	end

endmodule     //Multiplexer

//Counter_B

module counter_b(AddrB, clock, Reset,IncB);
	output reg[1:0] AddrB=-1;
	input clock;
	input IncB, Reset;


	always @ (Reset==1)
		AddrB<=0;

	always @ (posedge IncB)
		AddrB <= AddrB+1;
	
endmodule  //Counter_B

//Memory_B

module memoryB(DataInB,AddrB,WEB, DataOut, count);
	input [7:0]DataInB;
	input [1:0]AddrB;
	input WEB;
	reg [7:0] SRAM[3:0];
	output reg [7:0] DataOut;
	input [4:0] count;

	always @(*)
	begin
		if(WEB==1)
			begin
			SRAM[AddrB] <= DataInB;
			end
		else
			begin
			DataOut <= SRAM[AddrB-1];
			if((AddrB==0) && (count>=18))
			begin
			DataOut <= SRAM[3];
			end
			end
	end
endmodule    //Memory_B


//Memory_Transfer_TB

`timescale 1ns/1ns
module memory_transfer_tb();
	reg clock, Reset;
	reg [7:0] DataInA;
	reg [7:0] DOut1;
	
	initial
	begin
		clock <=0;
		Reset <= 0;
		DataInA <= 10;
	
	end

	always
	begin
		#1 clock<= ~ clock;
	end
	always @(posedge clock)
	begin

		#1 DataInA <= 4;
		#2 DataInA <= 2;
		#2 DataInA <= 3;
		#2 DataInA <= 6;
		#2 DataInA <= 1;
		#2 DataInA <= 0;
		#2 DataInA <= 9;
		
	end
	always
	begin
		#39 Reset=1;
	end 
	
memory_transfer MUT(clock,Reset,DataInA);
endmodule     // Memory_Transfer_TB
