
# VSDSquadron-FPGA-Mini Project - Task 4

## Overview
Implement a UART transmitter that sends data based on sensor inputs, enabling the FPGA to communicate real-time sensor data to an external device.

## 1: Study the Existing Code
-	Access the uart_tx_sense project from the ![VSDSquadron_FM repository](https://github.com/thesourcerer8/VSDSquadron_FM/tree/53840bb096ec59b11f26a0b5e362711b12540dbd/uart_tx_sense).
-	Review the Verilog code to understand how sensor data is acquired and transmitted.

<details>
<summary>Here is a detailed explanation of the transmission process for the provided Verilog code. </summary>

### Module Declaration

The top-level module is named `top`. It contains the following input and output ports:

- **Outputs:**
  - `led_red`: Connects to a red LED.
  - `led_blue`: Connects to a blue LED.
  - `led_green`: Connects to a green LED.
  - `uarttx`: UART transmission pin.
  
- **Inputs:**
  - `uartrx`: UART reception pin (sendor data).
  - `hw_clk`: Hardware clock input.

### Internal Signals

- `int_osc`: Internal oscillator signal for clock generation.
- `frequency_counter_i`: 28-bit register used for counting the frequency.
- `clk_9600`: Register to hold the generated 9600 Hz clock.
- `cntr_9600`: Counter for generating the 9600 Hz clock.
- `period_9600`: Constant parameter to determine the period for the 9600 Hz clock.

### Clock Generation

The internal oscillator is defined using the `SB_HFOSC` primitive, which sets up a high-frequency oscillator:

```verilog
SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
```

The `always` block monitors the positive edge of `int_osc` to increment `frequency_counter_i`. When the counter reaches the specified period (`625`), it toggles `clk_9600`:

```verilog
always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
    ...
    if (cntr_9600 == period_9600) begin
        clk_9600 <= ~clk_9600;
        cntr_9600 <= 32'b0;
    end
end
```

### UART Transmission

#### Instantiation of UART Module

The UART transmission module `uart_tx_8n1` is instantiated to handle the UART transmission. It sends a byte of data (`"D"`) based on the condition:

```verilog
uart_tx_8n1 DanUART (.clk (clk_9600), .txbyte("D"), .senddata(frequency_counter_i[24]), .tx(uarttx));
```

#### UART Module Details 

The `uart_tx_8n1` module operates as follows:

- **States:** 
  - `STATE_IDLE`: Waiting for a signal to start transmission.
  - `STATE_STARTTX`: Sending the start bit.
  - `STATE_TXING`: Sending the data bits.
  - `STATE_TXDONE`: Indicating transmission is complete.

The transmission begins when `senddata` is high and `state` is `STATE_IDLE`. It transitions through the states, sending a start bit, data bits, and a stop bit:

```verilog
if (senddata == 1 && state == STATE_IDLE) begin
    ...
    state <= STATE_STARTTX;
end
```

### RGB LED Driver

The RGB LED driver (`SB_RGBA_DRV`) is instantiated to control the RGB LEDs based on the incoming UART data (`uartrx`). The connection to the actual hardware pins is specified within:

```verilog
SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1),
    .RGB0PWM (uartrx),
    .RGB1PWM (uartrx),
    .RGB2PWM (uartrx),
    ... // LED pin connections
);
```

#### Current Settings

Each RGB channel's current settings are defined, ensuring that they operate correctly when activated.

#### I/O Connections

Throughout the code, specific I/O pins are assigned using the following statements:

```verilog
set_io  led_green 40
set_io  led_red	39
set_io  led_blue 41
set_io  uarttx 14
set_io  uartrx 15
set_io  hw_clk 20
```

### Summary

This Verilog code captures the operational flow for a microcontroller-like system that generates a 9600 Hz clock from a high-frequency oscillator, transmits sensor data using UART, and visually indicates the data with RGB LEDs. The UART module transmits data one byte at a time according to the defined states, allowing for straightforward and effective communication in embedded systems.

</details>

  
## 2. Design Documentation:
-	Create a block diagram depicting the integration of the sensor module with the UART transmitter.
-	Develop a circuit diagram showing connections between the FPGA, sensor, and the receiving device.


<details>
<summary>Design Documentation</summary>
  
Create a block diagram illustrating the UART Tx architecture.

![VSDSquadron-FPGA-Mini Project - Task 4 1](https://github.com/user-attachments/assets/ac16e495-5d72-4623-957c-569992a6ecf3)


Develop a detailed circuit diagram showing connections between the FPGA and any peripheral devices used.

![VSDSquadron-FPGA-Mini Project - Task 4 2](https://github.com/user-attachments/assets/8b220b98-490b-4111-8a5f-776baa352154)


</details>

## 3. Implementation:
<details>
<summary>Implementation</summary>
    
### **Hardware Setup**

- Refer to the [VSDSquadron FPGA Mini Datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf)
 for board details and pinout specifications.
- Set up the hardware according to the circuit diagram, ensuring proper sensor interfacing.
-	Synthesize and load the Verilog code onto the FPGA.

  - ![image](https://github.com/user-attachments/assets/2b0adc95-aefd-413d-86a2-c0dc65b42b20)

    or in VM provided by VSD, in Devices -> USB

  - ![image](https://github.com/user-attachments/assets/848be0a3-a1fa-457c-837b-dc11097a178a)

### **steps for compiling and flashing**

   open a termin window, cd to uart_tx_sense folder and execute below described comand sequence.

- ![image](https://github.com/user-attachments/assets/4f1fee32-7b73-4776-b880-05dfead8f408)
   

### **Execution Sequence**
```
lsusb # To check if Fpga-board is connected
```
   - ![image](https://github.com/user-attachments/assets/e756da51-45cb-43f7-b6fa-ea4fb10c6c7c)     
```
make clean # Clear out old compilation artifacts

make build # Compile the Verilog design

sudo make flash # Upload the synthesized bitstream to the FPGA

```
 - ![image](https://github.com/user-attachments/assets/dbdca8a6-09a0-4cdf-90e6-d4cff9cac0d5)

the led's on the board look like this, RGB-LED is ligthing red as expected!

   -  ![20250404_163829](https://github.com/user-attachments/assets/333632c1-a7cc-4cf8-b4c2-7dc21e370570)


</details>

## 4. Testing and Verification:
-	Stimulate the sensor and observe the transmitted data on a serial terminal to verify accurate sensor data transmission.

<details>
<summary>Testing and Verification</summary>

1. For the testing we will use docklight porogran which is a great testing tool for serial communication protocols. It allows us to monitor the communication between two serial devices.It can be downladed from [here](https://docklight.de/downloads/).
    
2. befor we start using dockligth we chek in Windows Device Manager that COM-Port is still availabel - COM8 in my case.

   - ![image](https://github.com/user-attachments/assets/70879f06-c0b9-42a6-ba68-19fbab6a121f)

- open Docklight and start with "Start with a blank project / blank script".

    - ![image](https://github.com/user-attachments/assets/1f7f5a08-f2ad-4422-ba62-50fd0cbfe11c)

 - Configure the correct communication port and protocol: COM8, 9600, 8, N, 1

  -  ![image](https://github.com/user-attachments/assets/7d193f1a-2e18-4802-bde0-6d3a395a13a7)

  - in top icon-bar you find the "Start comminication" butten (marked with red arrow)

  - ![image](https://github.com/user-attachments/assets/ba39faba-e85a-4d03-892b-17cb26455f83)

- click now on "Start communication" butten or F5 to start receiving process. As defined in Verilog-module we reveive continuous the char "D". 

 - ![image](https://github.com/user-attachments/assets/7ef30896-6b7f-4eef-ba8b-6a33e9d9bf46)

- Task 4 succesful completed with expected result!
</details>

## 5: Final Documentation:
- Assemble the block diagram, circuit diagram, code analysis, and testing results into a detailed report.
-	Record a short video demonstrating the system transmitting sensor data via UART.

<details>
<summary>Final Documentation of Task 2</summary>
    
### Summary of the Verilog code functionality
The given [Verilog module](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/9221679090866a04f7cff231b9ec5c29e8601404/Task%202/top.v) works as a UART (Universal Asynchronous Receiver-Transmitter) for serial communication between devices. It use on one port for transmitting char "D", verified via Docklight in Video below. In addition LED driver in ICS40 is used to ligth RGB-Led in static red color.

- block & curicuit diagram
  
- ![VSDSquadron-FPGA-Mini Project - Task 4 1](https://github.com/user-attachments/assets/898ba38f-18f4-4c25-8fc4-220b7d5ffb60)

- ![VSDSquadron-FPGA-Mini Project - Task 4 2](https://github.com/user-attachments/assets/c9f3cad4-538a-4339-8e72-effd85e4bef6)

- Validation Video:

- [Video terminal in VM](https://github.com/user-attachments/assets/fcf878a9-460d-4271-baae-1371ed9550c8)

RGB LED is static red.

- ![20250404_163829](https://github.com/user-attachments/assets/dc221afe-4a22-4961-aa29-bd1fb8886f72)

### Challenges Faced and Solutions Implemented

- Found it hard to understand the Verilog code originally - using google & ChatGPT i were able to understand things better but i have to investigate sill into Verilog.

## License
This project is open-source under the MIT License.

## Contact
Email: mimo3000ngmail.com
</details>
