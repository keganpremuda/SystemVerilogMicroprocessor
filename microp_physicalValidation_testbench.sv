`timescale 1ns/1ps
module mp_pv_tb();
	logic clk, SW0, SW1, KEY0, SW2, SW3, SW4;
	logic [6:0] SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0;
	logic LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7;
	mp_pv MPpv(clk, SW0, SW1, KEY0, SW2, SW3, SW4, SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
	initial begin
		//reset and initialize
		$display("SW0 SW1 SW2 SW3 SW4 KEY0 SevSeg5 SevSeg4 SevSeg3 SevSeg2 SevSeg1 SevSeg0 LED0 LED1 LED2 LED3 LED4 LED5 LED6 LED7");
		KEY0 = 1'b0; SW0 = 1'b1; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; clk = 1'b0; #10;
		SW0 = 1'b0; SW2 = 1'b0; SW3 = 1'b1; SW4 = 1'b1; #10;
		SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b1; #10;
		SW2 = 1'b1; SW3 = 1'b1; SW4 = 1'b0; #10;
		SW2 = 1'b1; SW3 = 1'b1; SW4 = 1'b1; #10;
		SW1 = 1'b1;	//to manually clock
		//run program
		repeat(44) begin
			KEY0 = 1'b1; #10;	//FD
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//EX
			$display("%b   %b   %b   %b   %b   %b       %h      %h      %h      %h      %h      %h      %b    %b    %b    %b    %b    %b    %b    %b",
			SW0, SW1, SW2, SW3, SW4, KEY0, SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0,LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//RWB
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//IF
			KEY0 = 1'b0; #10;
		end
		SW2 = 1'b0; SW3 = 1'b1; SW4 = 1'b1; #10;
		SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b1; #10;
		SW2 = 1'b1; SW3 = 1'b1; SW4 = 1'b0; #10;
		SW2 = 1'b1; SW3 = 1'b1; SW4 = 1'b1; #10;		
		repeat(33) begin
			KEY0 = 1'b1; #10;	//FD
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//EX
			$display("%b   %b   %b   %b   %b   %b       %h      %h      %h      %h      %h      %h      %b    %b    %b    %b    %b    %b    %b    %b",
			SW0, SW1, SW2, SW3, SW4, KEY0, SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0,LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//RWB
			KEY0 = 1'b0; #10;
			KEY0 = 1'b1; #10;	//IF
			KEY0 = 1'b0; #10;
		end
	end
endmodule
