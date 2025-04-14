# Objectives:
-	Execute the project plan by developing, testing, and validating the system.
-	Document the entire process comprehensively and create a short video demonstrating the project's functionality.

## 1.	Develop FPGA Modules:
 - 	Write Verilog or VHDL code for each module, such as sensor interfaces, data processing units, and UART communication blocks.
 - 	
## 2.	Simulate and Test Modules:

o	Utilize simulation tools to verify the functionality of each module before hardware implementation.

## 3.	Integrate and Test Hardware:
o	Assemble the hardware components based on the circuit diagrams.
o	Program the FPGA with the developed code.
o	Conduct thorough testing to ensure the system operates as intended.

## 4.	Document the Project:
o	Compile comprehensive documentation, including system overview, design schematics, annotated code listings, and testing procedures.
o	Create a short video demonstrating the project's functionality.
## 5.	Publish on GitHub:
o	Use the same GitHub repository for the project.
o	Upload all project files, including code, documentation, and the demonstration video.

# Deliverables:
•	Fully functional project implementation.
<details>
<summary> Fully functional project implementation</summary>
</details>

•	Comprehensive project documentation on GitHub.
<details>
<summary>Comprehensive project documentation on GitHub </summary>

### Project description
 This project implements an ultrasonic distance measurement system with UART output. It measures distance using an ultrasonic sensor (HC-SR04 or similar), converts the measurement to centimeters, and transmits the result to ESP8266(NodeMCU) via UART at 9600 baud. This project also provides visual feedback through RGB LEDs based on the measured distance.

#### System Requirements

Hardware Components:

- VSDSquadron Fpga board.
- HC-SR04 ultrasonic sensor.
- Logic Analysator
- USB cable
- Connecting wires and breadboard

Software Tools:

pulsview (logic analysator software)
putty(Serial monitoring tool).

#### Block Diagram

![Task 6 block diagram](https://github.com/user-attachments/assets/3d860e6e-d82f-4b8d-ade8-29c90165c5c7)

The system consists of four primary functional blocks:

1. Sensor Interface Module
Generates 10μs trigger pulses for the HC-SR04
Measures echo pulse duration
Implements 250ms cooldown period between measurements.
2. Data Processing Module
Converts echo time to distance in centimeters
Formats data for transmission
Implements signal conditioning if necessary
3. Communication Module
UART transmitter (9600 baud rate)
Packet formation with start/stop bits.
Serial data transmission to ESP8266
4. Feedback and Display Module
RGB LED driver for visual distance indication
Distance thresholds for color changes
Data Flow

HC-SR04 sensor receives trigger pulse from FPGA
Echo pulse duration is measured by FPGA
FPGA converts pulse duration to distance
Distance data is formatted and transmitted via UART,
RGB LED provides visual distance indication


#### System Setup and Component Testing

- Configure FPGA development environment.
- Test HC-SR04 sensor functionality.
- Implement and test RGB LED driver.

#### FPGA Module Development

- Develop ultrasonic sensor interface module
- Implement trigger pulse generation (10μs).
- Create echo pulse measurement system.
- Add 250ms delay period between measurements.

#### Communication System Implementation

- Develop UART transmitter module.

#### Integration and Testing

- Combine all FPGA modules into complete system.
- Implement RGB LED feedback based on distance thresholds.
- Conduct comprehensive system testing
- Verify measurement accuracy at various distances.
- Test communication reliability.
- Validate visual feedback functionality
- 
#### Expected Outcomes

The completed system will provide:

- Real-time distance measurements using the HC-SR04 ultrasonic sensor.
- Visual feedback through RGB LEDs based on measured distance.
- This project demonstrates the integration of sensor data acquisition with real-time processing and communication capabilities.

</details>

•	A short video demonstrating the project's functionality.
<details>
<summary>A short video demonstrating the project's functionality. </summary>

 [Video 1](https://github.com/user-attachments/assets/9c3b2f3d-7ad4-4d9b-8be1-a261d89588b5)

 [Video 2](https://github.com/user-attachments/assets/85ac448e-c726-47ee-8404-e71b099a859a)

### pulsview (open souce sw for tiny logic analysator from sigrock) testing:

- D1 is trigger line
- D2 is Echo line of ultrasonic sensor show puls wide is dependent from object distance, simulated with hand movement.

 [pulseview screen shot](![image](https://github.com/user-attachments/assets/84bca8cc-d3dc-4b23-adcf-407ac631cda4)

 
)

</details>
