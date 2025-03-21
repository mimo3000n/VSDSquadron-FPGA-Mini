Objective:
Participants are expected to understand and document the provided Verilog code, create the necessary PCF file, and integrate the design with the VSDSquadron FPGA Mini board using the provided datasheet. (install tools as explained in datasheet)

# Step 1: Understanding the Verilog Code

1.	Access the Verilog code from the provided link: https://github.com/thesourcerer8/VSDSquadron_FM/blob/main/led_blue/top.v
2.	Review the module declaration and understand the purpose of each input and output port:
  -	led_red, led_blue, led_green (Output): Control the RGB LED
  -	hw_clk (Input): Hardware oscillator clock input
  -	testwire (Output): Test signal output
3.	Analyze the internal components:
  o	Internal Oscillator (SB_HFOSC) instantiation
  o	Frequency counter logic driven by the internal oscillator
  o	RGB LED driver instantiation with defined current parameters

5.	Create a brief documentation explaining the functionality of the Verilog code, including:
  o	Purpose of the module
  o	Description of internal logic and oscillator
  o	Functionality of the RGB LED driver and its relationship to the outputs

# Step 2: Creating the PCF File

1.	Access the PCF file from the provided link: https://github.com/thesourcerer8/VSDSquadron_FM/blob/main/led_blue/VSDSquadronFM.pcf
2.	Understand the pin assignments from the PCF file:
  o	led_red -> Pin 39
  o	led_blue -> Pin 40
  o	led_green -> Pin 41
  o	hw_clk -> Pin 20
  o	testwire -> Pin 17
3.	Cross-reference the pin assignments with the VSDSquadron FPGA Mini board datasheet to verify the correctness of the assignments.
4.	Document the pin mapping and explain the significance of each connection in context with the Verilog code and board hardware.

# Step 3: Integrating with the VSDSquadron FPGA Mini Board

1.	Review the VSDSquadron FPGA Mini board datasheet to understand its features and pinout.
2.	Use the datasheet to correlate the physical board connections with the PCF file and Verilog code.
3.	Connect the board to the computer as described in the datasheet (e.g., using USB-C and ensuring FTDI connection).
4.	Follow the provided Makefile (https://github.com/thesourcerer8/VSDSquadron_FM/blob/main/led_blue/Makefile) for building and flashing the Verilog code:
o	Run 'make clean' to clear any previous builds
o	Run 'make build' to compile the design
o	Run 'sudo make flash' to program the FPGA board
5.	Observe the behavior of the RGB LED on the board to confirm successful programming.

# Step 4: Final Documentation

1.	Compile all observations, explanations, and steps into a comprehensive report.
2.	Include:
  o	Summary of the Verilog code functionality
  o	Pin mapping details from the PCF file
  o	Integration steps and observations while working with the FPGA Mini board
  o	Challenges faced and solutions implemented
3.	Submit the final document along with the working Verilog and PCF files.
4.	Document all of these in a GitHub repo.
