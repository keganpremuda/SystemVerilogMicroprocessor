<h1>System Verilog Microprocessor</h1>

 <!--### [YouTube Demonstration](https://youtu.be/7eJexJVCqJo)-->

<h2>Description</h2>
This project consists of a microprocessor module designed using System Verilog in the IDE ModelSim to use OPCODE to perform arithmetic and logical functions on values stored in the register file and to read and write new values to the register file depending on the instruction sets stored in the ROM. The microprocessor contains ROM, a register file, an ALU, a write register, and a control unit written as a Moore machine. The microprocessor module was tested, and then a physical validation was created and tested to validate the functionality of the microprocessor program on the Cyclone V FPGA.
<br />


<h2>Languages and Utilities Used</h2>

- <b>System Verilog</b> 
- <b>Quartus Prime</b>

<h2>Environments Used </h2>

- <b>ModelSim</b>

<h2>Project walk-through:</h2>

<p align="center">
Microprocessor Program: <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp.sv">microp.sv</a><br>
<br />
<br />
Microprocessor Program Test Bench  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_testbench.sv">microp_testbench.sv</a><br>
<br />
<br />
Log File From Test Bench: <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_logfile.csv">microp_logfile.csv</a><br>
<br />
<br />
Physical Validation Program For Microprocessor:  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_physicalValidation.sv">microp_physicalValidation.sv</a><br>
<br />
<br />
Physical Validation Program Test Bench:  <br/>
<a href="https://github.com/keganpremuda/SystemVerilogMicroprocessor/blob/main/microp_physicalValidation_testbench.sv">microp_physicalValidation_testbench.sv</a><br>
<br />
<br />
Physical Validation:  <br><br/>
<img src="https://i.imgur.com/cQ2aEcH.jpg" height="40%" width="40%" alt="Physical Validation Picture 1"/>
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
