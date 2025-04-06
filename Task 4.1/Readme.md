# Objective:

capture real time date from a Ultrasonic sensor (HC-SR04), calculate distance in cm an send ist to the UART

# reference documentation and findings

HC-SR04 is a 5V device, ICE40 i a 3V3 device so we ne a level shifter to interface between the 2 moduls, 
