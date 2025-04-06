# Objective:

capture real time date from a Ultrasonic sensor (HC-SR04), calculate distance in cm an send ist to the UART

# reference documentation and findings

HC-SR04 is a 5V device, ICE40 is a 3V3 device, so we need a level shifter (TXS0108) to interface between the sensore and FPGA board. 
