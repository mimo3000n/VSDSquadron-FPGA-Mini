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
 
#### Expected Outcomes

The completed system will provide:

- Real-time distance measurements using the HC-SR04 ultrasonic sensor.
- Visual feedback through RGB LEDs based on measured distance.
- This project demonstrates the integration of sensor data acquisition with real-time processing and communication capabilities.
 
</details>

•	Comprehensive project documentation.
<details>
<summary>Comprehensive project documentation</summary>

### Project description
 This project implements an ultrasonic distance measurement system with UART output. It measures distance using an ultrasonic sensor (HC-SR04 or similar), converts the measurement to centimeters, and transmits the result to ESP8266(NodeMCU) via UART at 9600 baud. This project also provides visual feedback through RGB LEDs based on the measured distance.

#### System Requirements

**Hardware Components:**

- VSDSquadron Fpga board.
- HC-SR04 ultrasonic sensor.
- Logic Analysator
- USB cable
- Connecting wires and breadboard

**Software Tools:**

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

<summary>Developing FPGA Modules</summary>

<br>

The project is implemented using several interconnected Verilog modules, each handling specific functionality. Here's a detailed explanation of each module:

#### Ultrasonic Sensor Interface

The `ultrasonic` module manages the HC-SR04 ultrasonic distance sensor interface:

- **Parameters**:
  - `TRIGGER_CYCLES`: Controls the trigger pulse duration (set to 60 cycles).
  - `MAX_ECHO_CYCLES`: Prevents system hanging if echo never returns (24-bit max value). 
  - `COOLDOWN_CYCLES`: Ensures proper timing between measurements (12,000 cycles or 250ms at 12MHz).
- **Functionality**: Implements a 4-state FSM that:
  - Initializes counters in idle state.
  - Generates a trigger pulse to the sensor.
  - Measures the echo pulse width by counting clock cycles.
  - Enforces a cooldown period before starting the next measurement.

- The module outputs `pulse_width`, which represents the echo duration in clock cycles.

#### Distance Calculation

The `distance_calc` module converts echo pulse duration to distance:

- **Parameters**:
  - `CLK_PER_CM`: Calibration constant (348 clock cycles per centimeter).
- **Functionality**: Divides the echo pulse width by the calibration constant to calculate distance in centimeters.

#### BCD Converter

The `bcd_converter` module converts binary distance values to decimal digits:

- **Inputs**: 16-bit binary distance value.
- **Outputs**: Three 4-bit BCD values for hundreds, tens, and units digits,
- **Functionality**: Performs integer division and modulo operations to extract individual decimal digits from the binary distance value.

#### Communication System Implementation

#### UART Transmission

The `uart_tx_8n1` module (included but not shown in detail) handles serial communication:

- **Functionality**: Transmits 8-bit data with no parity and 1 stop bit over UART protocol.

##### Top Module Integration

The `top` module integrates all components:

- **Clock Generation**: Uses the internal oscillator (SB\_HFOSC) configured to generate the system clock.
- **Measurement System**: Instantiates the ultrasonic sensor interface and distance calculation modules.
- **Data Processing**: Uses the BCD converter to prepare distance values for transmission.
- **UART Control**: Implements a 5-state FSM to transmit distance readings serially:
  - Waits for 1 second between transmissions.
  - Sends hundreds digit.
  - Sends tens digit.
  - Sends units digit.
  - Sends newline character.
- **LED Feedback**: Uses the RGB LED to provide visual distance feedback:
  - Red LED: Distance ≤ 50cm.
  - Green LED: Distance between 50cm and 100cm.
  - Blue LED: Distance > 100cm.

The system continuously measures distance, converts it to human-readable format, transmits it via UART, and provides visual feedback through the RGB LED.


### Integration and Testing

<summary> Testing with Serial Termianl</summary>

<br>

1. **Hardware Setup**

- Refer to the [VSDSquadron FPGA Mini Datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf)
 for board details and pinout specifications.
- Connect a USB-C interface between the board and the host computer.
- Check FTDI connection in order to facilitate FPGA programming and debugging.
- Ensure proper power supply and stable connections to avoid communication errors during flashing.
- Connect TRIG (Pin 4) → HC-SR04 TRIG
- Connect ECHO (Pin 3)→ HC-SR04 ECHO.
- Connect 5 V to sensor VCC, common GND.
- Connect FPGA’s UARTTX (Pin 14) → USB–Serial RX.

**Compilation and Flashing Workflow**

A Makefile is used for compilation and flashing of the Verilog design. The repository link is: [Makefile](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/8018ee750dfb273a538cbd82497332c55d138d3c/Task%206/Makefile).

**Execution Sequence**
```
lsusb # To check if Fpga is connected

make clean # Clear out old compilation artifacts

make build # Compile the Verilog design

sudo make flash # Upload the synthesized bitstream to the FPGA
```

![image](https://github.com/user-attachments/assets/1cefe843-326a-4c61-9c97-401a1da42202)


2. **Terminal**:

   - Open putty and select serial option.
   - Verify the speed (baud rate) is 9600.
   - Verify that the correct port is connected through serial communication (COM 8 in my case).

3. **Measuring Distance**:

   - Place an object ~10 cm away from the sensor.
   - Terminal should display a reading around “0010” .
   - Move the object closer or farther to see changing values.

![image](https://github.com/user-attachments/assets/ac3fc7a4-3b95-4f00-a9cd-ba31094cd968)


***


 
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

 new Viedo - showing distance change if i mode hand close to ultrasonic sensor

 [Video 3](https://github.com/user-attachments/assets/d7cb5cdf-beb1-4332-8383-4488ee55c94e)

https://github.com/user-attachments/assets/d7cb5cdf-beb1-4332-8383-4488ee55c94e




### pulsview (open souce sw for tiny logic analysator from sigrock) testing:

- D1 is trigger line
- D2 is Echo line of ultrasonic sensor show puls wide is dependent from object distance, simulated with hand movement.

 [pulseview screen shot](![image](https://github.com/user-attachments/assets/84bca8cc-d3dc-4b23-adcf-407ac631cda4)

 
)

</details>
