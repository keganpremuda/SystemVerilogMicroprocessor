<h1>System Verilog Microprocessor</h1>

 <!--### [YouTube Demonstration](https://youtu.be/7eJexJVCqJo)-->

<h2>Description</h2>
This project consists of a microprocessor module designed using System Verilog in the IDE ModelSim to process OPCODE to perform arithmetic and logical functions on values stored in the register file, and to read and write new values to the register file depending on the instruction sets stored in the ROM. The microprocessor contains ROM, a register file, an ALU, a write register, and a control unit written as a Moore machine. The microprocessor module was tested, and then a physical validation was created and tested to validate the functionality of the microprocessor program on the Cyclone V FPGA.
<br />


<h2>Languages Used</h2>

- <b>System Verilog</b> 

<h2>Environments Used </h2>

- <b>ModelSim</b>
- <b>Quartus Prime</b>

<h2>Project walk-through:</h2>

<p align="center">
<b>Microprocessor Program:</b> <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp.sv">microp.sv</a><br></p>
<p align="left">
The microprocessor program is a parent module with child modules which include the ROM, register file, ALU, a twos complement module, an 8-bit full adder, write register, a program counter (sequential block within the control unit), an instruction register (within the parent module), and control unit (finite state machine within the control  unit). All child modules were previously created and simulated, along with a test bench and physical validation if necessary. The program was written and simulated in ModelSim to debug any initial errors and warnings, then ported to Quartus Prime for further debugging and synthesis of the program. The program was then written to the FPGA for physical validation.</p>
<br />
<br />
<p align="center">
<b>Microprocessor Program Test Bench:</b>  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_testbench.sv">microp_testbench.sv</a><br></p>
<p align="left">
A test bench program was written to test the functionality of the microprocessor by clocking through the entire test program within the ROM and displaying the results on the terminal display of ModelSim, as well as writing the data to a CSV log file. The results were analyzed to ensure proper function during all steps of the test program.</p>
<br />
<br />
<p align="center">
<b>Log File From Test Bench:</b> <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_logfile.csv">microp_logfile.csv</a><br></p>
<p align="left">
The log file shows the value of the program counter, the instruction register, OPCODE, register A, B, and D of the register file, the write register, and the carry-out and overflow values of the ALU.
<br />
<br />
<p align="center">
<b>Physical Validation Program For Microprocessor:</b>  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_physicalValidation.sv">microp_physicalValidation.sv</a><br></p>
<p align="left">
The physical validation was created by instantiating the microprocessor module, assigning variables and values to appropriate switches, LEDs, buttons, and 7-segment displays, instantiating an ASCII to 7-segment display conversion module, and instantiating a frequency divider module. The frequency divider reduces the 25MHz clock on the FPGA to 1000Hz, and the microprocessor module enables the ability to switch from the 1000Hz clock to a manual clocking using a button on the board.</p>
<br />
<br />
<p align="center">
<b>Physical Validation Program Test Bench:</b>  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_physicalValidation_testbench.sv">microp_physicalValidation_testbench.sv</a><br></p>
<p align="left">
A physical validation test bench was created to confirm the desired functionality of the switches, LEDs, buttons, and 7-segment display before the actual physical validation.</p>
<br />
<br />
<p align="center">
<b>Physical Validation:</b>  <br><br/>
<img src="https://i.imgur.com/cQ2aEcH.jpg" height="40%" width="40%" alt="Physical Validation Picture 1"/></p>
<p align="left">
A physical validation of the program written during the microprocessor test bench was conducted as a final test of the functionality of the microprocessor.</p><br><br><br>
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
