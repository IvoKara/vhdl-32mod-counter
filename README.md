# FPGA 32-modulus programmable counter

This is the source code of a course project form Technical University - Sofia that aims to create a 32-modulus (5-bit / MOD-32) counter using the Programmable Logic Devices (PLD) on a FPGA chip.

It is intended to be used on `Xilnx XC3S100` chip of the `Spartan3E` family.<br/>
May be used with **TQ144** or **CP132** package.

### Requirements
- Programmable counting module 32 - to have the ability to be assigned using the board's recources (buttons, switches) in the range **0 to 31**
- Programmable direction / counting (upwards, downwards)
- To have two CLK modes:
  -  **Manual**: to be able to manually fire clock signal (using button on the board)
  -  **Automatic**: get the board's built-in clock (100MHz) and generate new clock signal whose period is **1s**

### Example working board - Basys 2 from Digilent
Has `Xilinx Spartan3E XC3S100` in it
<p align="center">
  <a href="https://laravel.com" target="_blank">
    <img src="https://digilent.com/reference/_media/reference/programmable-logic/basys-2/basys2-0.png" width="400" alt"Basys 2 from Digilent">
  </a>
</p>
