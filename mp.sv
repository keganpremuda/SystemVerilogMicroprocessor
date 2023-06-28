module mp(input clk, reset, output logic [3:0] OPCODE, output logic [1:0] State, output logic [7:0] PC, Alu_out, W_Reg, output logic Cout, OF);
	localparam Size = 8, EX = 2'd2;
	logic [15:0] IR;
	logic [Size-1:0] Qn, RF_data_0, RF_data_1, aluin_a, aluin_b;
	logic [3:0] RA, RB, RD;
	assign OPCODE = IR[15:12];	//break up IR into OPCODE, RA, RB, and RD to pass to RegFile
	assign RA = IR[11:8];
	assign RB = IR[7:4];
	assign RD = IR[3:0];
	ROM R1(PC, IR);	//retieves IF values from PC address
	RegFile RF1(reset, clk, RA, RB, RD, OPCODE, State, W_Reg, RF_data_0, RF_data_1);	//if state = FD retrieves RA and RB, else if state = RWB stores RD
	ALU A1(RF_data_0, RF_data_1, PC, OPCODE, RD, 1'b0, Alu_out, Cout, OF);	//arithmetic and passes to Wreg
	Wreg #(Size) W1(Alu_out, State, clk, reset, W_Reg, Qn);	//if state = EX clocks alu_out, else clocks zero
	MCU #(Size) MCU1(reset, clk, OPCODE, W_Reg, PC, State);		//determines next state, and nextaddress from OPCODE and state
endmodule

//ROM
module ROM(input [7:0] PC, output logic [15:0] IR);
	logic [15:0] mem [20:0];
	assign mem[8'h00] = 16'h2000;
	assign mem[8'h01] = 16'h2011; 
	assign mem[8'h02] = 16'h2002;
	assign mem[8'h03] = 16'h20A3; 
	assign mem[8'h04] = 16'hD236;
	assign mem[8'h05] = 16'h1014; 
	assign mem[8'h06] = 16'h4100;
	assign mem[8'h07] = 16'h4401;
	assign mem[8'h08] = 16'h8022;
	assign mem[8'h09] = 16'hE040; 
	assign mem[8'h0A] = 16'h4405;
	assign mem[8'h0B] = 16'h5536; 
	assign mem[8'h0C] = 16'h6637;
	assign mem[8'h0D] = 16'h3538; 
	assign mem[8'h0E] = 16'h4329;
	assign mem[8'h0F] = 16'h709A;
	assign mem[8'h10] = 16'h70AB; 
	assign mem[8'h11] = 16'hBB8C;
	assign mem[8'h12] = 16'h9D8E; 
	assign mem[8'h13] = 16'hC0EF;
	assign mem[8'h14] = 16'hF000;
	assign IR = mem[PC];
endmodule


//RegFile
module RegFile(input reset, clk, input [3:0] RA, RB, RD, OPCODE, input [1:0] current_state, input [7:0] RF_data_in, output logic [7:0] RF_data_0, RF_data_1);
	logic [7:0] RF [15:0];
	localparam FD = 2'd1, RWB = 2'd3;
	always_ff @ (posedge clk or posedge reset)
		if(reset) begin
			integer i;
			for(i=0; i<=15; i=i+1)
				RF[i] <= 8'd0;
			RF_data_0 <= 8'd0;
			RF_data_1 <= 8'd0;
		end
		else
			case(OPCODE)
				4'b0001 : begin	//contents of RD = (contents of RA) + (contents of RB)
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0010 : begin	//contents of RD = {RA,RB} 
					if(current_state == FD) begin
						RF_data_0 <= {RA, 4'd0};
						RF_data_1 <= {4'd0, RB};
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0011 : begin	//contents of RD = (contents of RA) - (contents of RB)
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0100 : begin	//contents of RD = (contents of RA) + RB
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= {4'b0000, RB};
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0101 : begin	//contents of RD = (contents of RA) / (contents of RB) 
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0110 : begin	//contents of RD = (contents of RA) * (contents of RB) 
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b0111 : begin	//contents of RD = (contents of RB) - 1
					if(current_state == FD) begin
						RF_data_0 <= RF[RB];
						RF_data_1 <= 8'd1;
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b1000 : begin	//contents of RD = (contents of RB) + 1
					if(current_state == FD) begin
						RF_data_0 <= RF[RB];
						RF_data_1 <= 8'd1;
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b1001 : begin	//contents of RD = (contents of RA) NOR (contents of RB)
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end 
				4'b1010 : begin	//contents of RD = (contents of RA) NAND (contents of RB) 
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end 
				4'b1011 : begin	//contents of RD = (contents of RA) XOR (contents of RB)
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b1100 : begin	//contents of RD = ~(contents of RB) 
					if(current_state == FD) begin
						RF_data_0 <= 8'b0;
						RF_data_1 <= RF[RB];
					end
					else if(current_state == RWB)
						RF[RD] <= RF_data_in;
				end
				4'b1101 : begin	//if ( (contents of RA) >= (contents of RB) ) increment PC by RD
					if(current_state == FD) begin
						RF_data_0 <= RF[RA];
						RF_data_1 <= RF[RB];
					end
				end
				4'b1110 : begin	//Jump to PC address location {RA,RB} 
					if(current_state == FD) begin
						RF_data_0 <= {RA, 4'd0};
						RF_data_1 <= {4'd0, RB};
					end
				end
				4'b1111 : begin //Halt the program
					RF_data_0 <= RF_data_0;
					RF_data_1 <= RF_data_1;
					RF[RD] <= RF[RD];
				end
				default: begin //Halt the program
					RF_data_0 <= RF_data_0;
					RF_data_1 <= RF_data_1;
					RF[RD] <= RF[RD];
				end
			endcase
endmodule


//ALU
module ALU(input [7:0] aluin_a, aluin_b, PC, input [3:0] OPCODE, RD, input alu_cin, output logic [7:0] alu_out, output logic alu_cout, alu_of);
	localparam ADD = 4'b0001, LDI = 4'b0010, SUB = 4'b0011, ADI = 4'b0100, DIV = 4'b0101, MUL = 4'b0110, DEC = 4'b0111, INC = 4'b1000;
	localparam NOR = 4'b1001, NAND = 4'b1010, XOR = 4'b1011, COMP = 4'b1100, CMPJ = 4'b1101, JMP = 4'b1110, HLT = 4'b1111;
	localparam Size = 8;
	logic [7:0] ain, bin, contA, contB;	//left of = in always
	logic cin, Cout, OF;		//left of = in always
	logic [7:0] twoscomp_b, Sum;
	twoscomp tc1(aluin_b, twoscomp_b);	//instance of twos comp machine
	FA8 fa8_1(ain, bin, cin, Sum, Cout, OF);	//instance of four bit ripple adder
	always_comb begin
		ain = 8'd0; bin = 8'd0; cin = 1'b0; alu_out = 8'd0; alu_cout = 1'b0; alu_of = 1'b0; contA = 8'd0; contB = 8'd0;	//initialize output ports
		case(OPCODE)
			ADD : begin	//ADD
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = Sum; alu_cout = Cout; alu_of = OF;
				end
			LDI : begin	//LDI
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = Sum; alu_cout = 1'b0; alu_of = 1'b0;
				end
			SUB : begin	//SUB
						ain = aluin_a; bin = twoscomp_b; cin = 1'b0; alu_out = Sum; alu_cout = Cout; alu_of = OF;
				end
			ADI : begin	//ADI
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = Sum; alu_cout = Cout; alu_of = OF;
				end
			DIV : begin	//DIV
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = (aluin_a/aluin_b); alu_cout = Cout; alu_of = OF;
				end
			MUL : begin	//MUL
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = (aluin_a*aluin_b); alu_cout = Cout; alu_of = OF;
				end
			DEC : begin	//DEC
						ain = aluin_a; bin = twoscomp_b; cin = 1'b0; alu_out = Sum; alu_cout = Cout; alu_of = OF;
				end
			INC : begin	//INC
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = Sum; alu_cout = Cout; alu_of = OF;
				end
			NOR : begin	//NOR
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = ~(aluin_a|aluin_b); alu_cout = 1'b0; alu_of = 1'b0;
				end
			NAND : begin	//NAND
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = ~(aluin_a&aluin_b); alu_cout = 1'b0; alu_of = 1'b0;
				end
			XOR : begin	//XOR
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = aluin_a^bin; alu_cout = 1'b0; alu_of = 1'b0;
				end
			COMP : begin	//COMP
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = ~aluin_b; alu_cout = 1'b0; alu_of = 1'b0;
				end
			CMPJ : begin	//CMPJ
						contA = aluin_a; contB = aluin_b; cin = 1'b0; alu_cout = Cout; alu_of = OF;
						if(contA >= contB) begin
							ain = PC; bin = {4'd0, RD}; alu_out = Sum;	//PC = PC + RD
						end
						else
							alu_out = PC + {{Size-1{1'b0}},1'b1};	//increment
				end
			JMP : begin	//JMP
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = Sum; alu_cout = 1'b0; alu_of = 1'b0;
				end
			HLT : begin	//HLT
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = 8'd0; alu_cout = 1'b0; alu_of = 1'b0;
				end
			default : begin	//default HLT
						ain = aluin_a; bin = aluin_b; cin = 1'b0; alu_out = 8'd0; alu_cout = 1'b0; alu_of = 1'b0; contA = 8'd0; contB = 8'd0;
				end
		endcase				
	end
endmodule

module twoscomp(input [7:0] B, output [7:0] twoscomp_B);
	wire [7:0] nB;
	wire Cout, OF;
	assign nB = ~B;	//not B
	FA8 fa8_1(8'b0, nB, 1'b1, twoscomp_B, Cout, OF);	//instance of four bit ripple adder to add 1
endmodule

module FA8(input [7:0] A, B, input Cin, output [7:0] Sum, output Cout, OF);
	wire Cout1, Cout2, Cout3, Cout4, Cout5, Cout6, Cout7;
	FA fa1(A[0], B[0], Cin, Sum[0], Cout1);
	FA fa2(A[1], B[1], Cout1, Sum[1], Cout2);
	FA fa3(A[2], B[2], Cout2, Sum[2], Cout3);
	FA fa4(A[3], B[3], Cout3, Sum[3], Cout4);
	FA fa5(A[4], B[4], Cout4, Sum[4], Cout5);
	FA fa6(A[5], B[5], Cout5, Sum[5], Cout6);
	FA fa7(A[6], B[6], Cout6, Sum[6], Cout7);
	FA fa8(A[7], B[7], Cout7, Sum[7], Cout);
	xor XO1(OF, Cout, Cout7);	//Determine OF
endmodule

module FA(input A, B, Cin, output Sum, Cout);
	wire HA_Sum, HA_Cout;	//HA outputs
	HA ha1(A, B, HA_Sum, HA_Cout);	//instantiate HA
	assign Sum = HA_Sum^Cin;
	assign Cout = (HA_Cout)|(HA_Sum&Cin);
endmodule

module HA(input A,B, output Sum, Cout);
	assign Sum = A^B;
	assign Cout = A&B;
endmodule



//W Register
module Wreg #(parameter Size = 8)(input [Size-1:0] D, input [1:0] current_state, input clk, reset, output logic [Size-1:0] Q, output [Size-1:0] Qn);
	localparam EX = 2'd2;
	always_ff @ (posedge clk or posedge reset)	//asynchronous reset
		if (reset)
			Q <= {Size{1'b0}};
		else if (current_state == EX)
			Q <= D;
		else
			Q <= Q;
	assign Qn = ~Q;
endmodule



//MCU
module MCU #(parameter Size = 8)(input reset, clk, input [3:0] OPCODE, input [Size-1:0] dataOut, output logic [Size-1:0] nextAddress, output logic [1:0] state);
	localparam IF = 2'd0, FD = 2'd1, EX = 2'd2, RWB = 2'd3;
	logic [Size-1:0] Qmax;
	assign Qmax = 8'h14;
	logic [1:0] nextState;
	//combinatorial block or FSM Control Unit
	always_comb begin
		nextState = IF;
		case (state)
			IF : nextState = FD;
			FD : nextState = EX;
			EX : nextState = RWB;
			RWB : nextState = IF;
			default : nextState = IF;
		endcase
	end
	//sequential block for PC
	always_ff @ (posedge clk or posedge reset)
		if (reset) begin
			nextAddress <= {Size{1'b0}};
			state <= IF;
		end
		else begin
			if (state == RWB) begin
				case (OPCODE)
					4'b1101 : nextAddress <= dataOut;
					4'b1110 : nextAddress <= dataOut;
					4'b1111 : nextAddress <= nextAddress;
					default : begin
						if (nextAddress < Qmax)
							nextAddress <= nextAddress + {{Size-1{1'b0}},1'b1};	//increment			
						else
							nextAddress <= {Size{1'b0}};	//reset on 0
					end
				endcase
			end
			state <= nextState;
		end
endmodule