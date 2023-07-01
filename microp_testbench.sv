`timescale 1ns/1ps
module mp_tb();
	localparam IF = 2'd0, FD = 2'd1, EX = 2'd2, RWB = 2'd3;
	localparam ADD = 4'b0001, LDI = 4'b0010, SUB = 4'b0011, ADI = 4'b0100, DIV = 4'b0101, MUL = 4'b0110, DEC = 4'b0111, INC = 4'b1000;
	localparam NOR = 4'b1001, NAND = 4'b1010, XOR = 4'b1011, COMP = 4'b1100, CMPJ = 4'b1101, JMP = 4'b1110, HLT = 4'b1111;
	logic clk, reset;
	logic [1:0] State;
	logic [3:0] OPCODE, RA, RB, RD;
	logic [7:0] PC, Alu_out, W_Reg;
	logic [15:0] IR;
	logic Cout, OF;
	integer fd;
	mp MP(clk, reset, OPCODE, State, PC, Alu_out, W_Reg, Cout, OF);
	assign RA = IR[11:8];	//RA RB and RD for logfile
	assign RB = IR[7:4];
	assign RD = IR[3:0];
	ROM R1(PC, IR);	//retieves IF values from PC address for logfile
	initial begin
		//reset and initialize
		fd = $fopen("mp_logfile.csv");	//initialize file variable
		$display("PC IR    OPCODE  RA RB RD  W_Reg    Alu_out   Cout OF");
		$fwrite(fd, "PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF\n");	//column headings
		clk = 1'b0; reset = 1'b1; 
		OPCODE = 4'd0; State = IF; Cout = 1'b0; OF = 1'b0;	#10;
		reset = 1'b0;
		//run program
		repeat(77) begin
			clk = 1'b1; #10;	//FD
			clk = 1'b0; #10;
			clk = 1'b1; #10;	//EX
			$display("%h %h    %h     %h  %h  %h    %h       %h        %h    %h", PC, IR, OPCODE, RA, RB, RD, W_Reg, Alu_out, Cout, OF);
			$fwrite(fd, "%h, %h, %h, %h, %h, %h, %h, %h, %h\n", PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF);
			clk = 1'b0; #10;
			clk = 1'b1; #10;	//RWB
			clk = 1'b0; #10;
			clk = 1'b1; #10;	//IF
			clk = 1'b0; #10;
		end
	end
endmodule
