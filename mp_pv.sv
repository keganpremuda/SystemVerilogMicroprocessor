module mp_pv(input clk, SW0, SW1, KEY0, SW2, SW3, SW4, 
					output logic [6:0] SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0,
					output logic LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
	localparam maxVal = 15'h61A8;
	logic clk_1000Hz, Cout, OF;
	logic [1:0] State;
	logic [2:0] Switches;
	logic [3:0] OPCODE;
	logic [7:0] PC, Alu_out, W_Reg, acsiiCode0, acsiiCode1, acsiiCode2, acsiiCode3, acsiiCode4, acsiiCode5;
	logic [7:0] PClsv, PCmsv, Alu_outlsv, Alu_outmsv, W_Reglsv, W_Regmsv;
	logic [14:0] count;
	assign PCmsv = ((PC/8'd16) < 10)? ((PC/8'd16) + 8'd48):(PC/8'd16 + 8'd87);
	assign PClsv = ((PC%8'd16) < 10)? ((PC%8'd16) + 8'd48):(PC%8'd16 + 8'd87);
	assign Alu_outmsv = ((Alu_out/8'd16) < 10)? ((Alu_out/8'd16) + 8'd48):(Alu_out/8'd16 + 8'd87);
	assign Alu_outlsv = ((Alu_out%8'd16) < 10)? ((Alu_out%8'd16) + 8'd48):(Alu_out%8'd16 + 8'd87);
	assign W_Regmsv = ((W_Reg/8'd16) < 10)? ((W_Reg/8'd16) + 8'd48):(W_Reg/8'd16 + 8'd87);
	assign W_Reglsv = ((W_Reg%8'd16) < 10)? ((W_Reg%8'd16) + 8'd48):(W_Reg%8'd16 + 8'd87);

	//LED assignments
	assign LED0 = PC[0];
	assign LED1 = PC[1];
	assign LED2 = PC[2];
	assign LED3 = PC[3];
	assign LED4 = PC[4];
	assign LED5 = PC[5];
	assign LED6 = PC[6];
	assign LED7 = PC[7];

	//7-Segment display instances
	ASCII27Seg A0(acsiiCode0, SevSeg0);
	ASCII27Seg A1(acsiiCode1, SevSeg1);
	ASCII27Seg A2(acsiiCode2, SevSeg2);
	ASCII27Seg A3(acsiiCode3, SevSeg3);
	ASCII27Seg A4(acsiiCode4, SevSeg4);
	ASCII27Seg A5(acsiiCode5, SevSeg5);

	//7-Segment display case
	always_comb begin
		Switches = {SW4, SW3, SW2};
		case(Switches)
			3'b000 : begin	//Last name 6 letters = PREMUD
				acsiiCode5 = 8'h50;
				acsiiCode4 = 8'h52;
				acsiiCode3 = 8'h45;
				acsiiCode2 = 8'h4D;
				acsiiCode1 = 8'h55;
				acsiiCode0 = 8'h44;
			end
			3'b110 : begin	//PC hex
				acsiiCode0 = PClsv;
				acsiiCode1 = PCmsv;
				acsiiCode2 = 8'h68;
				acsiiCode3 = 8'd0;
				acsiiCode4 = 8'd0;
				acsiiCode5 = 8'd0;
			end
			3'b101 : begin	//current W_Reg hex
				acsiiCode0 = W_Reglsv;
				acsiiCode1 = W_Regmsv;
				acsiiCode2 = 8'h68;
				acsiiCode3 = 8'd0;
				acsiiCode4 = 8'd0;
				acsiiCode5 = 8'd0;
			end
			3'b011 : begin	//Alu_out hex
				acsiiCode0 = Alu_outlsv;
				acsiiCode1 = Alu_outmsv;
				acsiiCode2 = 8'h68;
				acsiiCode3 = 8'd0;
				acsiiCode4 = 8'd0;
				acsiiCode5 = 8'd0;
			end
			3'b111 : begin	//OPCODE
				acsiiCode0 = (OPCODE[0] == 1'b1)? 8'h31:8'h30;
				acsiiCode1 = (OPCODE[1] == 1'b1)? 8'h31:8'h30;
				acsiiCode2 = (OPCODE[2] == 1'b1)? 8'h31:8'h30;
				acsiiCode3 = (OPCODE[3] == 1'b1)? 8'h31:8'h30;
				acsiiCode4 = 8'd0;
				acsiiCode5 = 8'd0;
			end
			default : begin	//blank
				acsiiCode0 = 8'd0;
				acsiiCode1 = 8'd0;
				acsiiCode2 = 8'd0;
				acsiiCode3 = 8'd0;
				acsiiCode4 = 8'd0;
				acsiiCode5 = 8'd0;
			end
		endcase
	end
	//frequency divider instance
	freqDiv #(15) FD1(clk, SW0, maxVal, count, clk_1000Hz);
	//microprocessor instance
	lab5 MP(((SW1 == 1'b1)? KEY0:clk_1000Hz), SW0, OPCODE, State, PC, Alu_out, W_Reg, Cout, OF);
endmodule


//freqDiv - 50% Frequency Divider
module freqDiv #(parameter Size = 1)(input clk, reset, input [Size-1:0] maxVal, output logic [Size-1:0] count, output logic clkOut);
	always_ff @ (posedge clk or posedge reset)
		if(reset) begin
			count <= {Size{1'b0}};
			clkOut <= 1'b0;
		end
		else if(count < maxVal)
			count <= count + {{(Size-1){1'b0}}, 1'b1};
		else begin
			count <= {Size{1'b0}};
			clkOut <= ~clkOut;
		end
endmodule



//ASCII to 7Seg
module ASCII27Seg(input [7:0] asciiCode, output reg [6:0] hexSeg);
	always @ (*) begin
		hexSeg=7'd0;	//initialization of variable hexCode to 7 bit decimal 0
		// $display("asciiCode %b", asciiCode);
		case (asciiCode)
			8'h41 : begin		//A
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h61 : begin		//a
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h42 : begin		//B
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h62 : begin		//b
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h43 : begin		//C
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h63 : begin		//c
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h44 : begin		//D
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h64 : begin		//d
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h45 : begin		//E
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h65 : begin		//e
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h46 : begin		//F
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h66 : begin		//f
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h47 : begin		//G
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h67 : begin		//g
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h48 : begin		//H
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h68 : begin		//h
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h49 : begin		//I
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h69 : begin		//i
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h4A : begin		//J
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h6A : begin		//j
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h4B : begin		//K
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h6B : begin		//k
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h4C : begin		//L
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h6C : begin		//l
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h4D : begin		//M
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h6D : begin		//m
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h4E : begin		//N
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h6E : begin		//n
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h4F : begin		//O
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h6F : begin		//o
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h50 : begin		//P
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h70 : begin		//p
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h51 : begin		//Q
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h71 : begin		//q
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h52 : begin		//R
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h72 : begin		//r
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h53 : begin		//S
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h73 : begin		//s
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h54 : begin		//T
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h74 : begin		//t
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h55 : begin		//U
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h75 : begin		//u
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h56 : begin		//V
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h76 : begin		//v
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h57 : begin		//W
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h77 : begin		//w
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h58 : begin		//X
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h78 : begin		//x
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h59 : begin		//Y
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h79 : begin		//y
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h5A : begin		//Z
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h7A : begin		//z
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h30 : begin		//0
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=1;
				end
			8'h31 : begin		//1
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=1; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h32 : begin		//2
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h33 : begin		//3
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=1; hexSeg[6]=0;
				end
			8'h34 : begin		//4
					hexSeg[0]=1; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h35 : begin		//5
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h36 : begin		//6
					hexSeg[0]=0; hexSeg[1]=1; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h37 : begin		//7
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=1; hexSeg[4]=1; hexSeg[5]=1; hexSeg[6]=1;
				end
			8'h38 : begin		//8
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=0; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h39 : begin		//9
					hexSeg[0]=0; hexSeg[1]=0; hexSeg[2]=0; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=0; hexSeg[6]=0;
				end
			8'h5F : begin		//_
					hexSeg[0]=1; hexSeg[1]=1; hexSeg[2]=1; hexSeg[3]=0; hexSeg[4]=1; hexSeg[5]=1; hexSeg[6]=1;
				end
			default : hexSeg=7'b1111111;	//deafult of hexSeg
		endcase
	end
endmodule