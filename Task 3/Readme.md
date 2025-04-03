
# VSDSquadron-FPGA-Mini Project - Task 3

## Overview
Develop a UART transmitter module capable of sending serial data from the FPGA to an external device.

## 1: Study the Existing Code

<details>
<summary>Study the Existing Code</summary>
    The code is a simple UART (Universal Asynchronous Receiver/Transmitter) transmitter module that implements an 8 data bits, no parity, and 1 stop bit (8N1) format. Below, I will explain each part of the code and analyze its functionality.

### Overview

The system described consists of a top-level module that implements a basic RGB LED control along with a simple loopback logic for UART communication. The UART transmits data on one line of the communication while receiving on another line, effectively allowing for feedback that can be useful in debugging and communication testing.

### Code Breakdown

#### Top Module

```verilog
module top (
  // outputs
  output wire led_red,    // Red LED
  output wire led_blue,   // Blue LED
  output wire led_green,  // Green LED
  output wire uarttx,     // UART Transmission pin
  input wire uartrx,      // UART Receiving pin
  input wire hw_clk       // Hardware clock
);
```

##### Internal Components
- **Internal Oscillator**: Generates a clock signal from a high-frequency oscillator block.
- **Registers**: `frequency_counter_i` is utilized for counting cycle events (e.g., in setting baud rates).
- **UART Loopback**: The assignment `assign uarttx = uartrx;` creates the primary loopback behavior where data received on the `uartrx` pin is directly sent out on the `uarttx` pin.

#### Counter Logic

```verilog
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
    /* generate 9600 Hz clock */
  end
```

This section of the code increments a counter on the rising edge of the internal oscillator clock. This counter serves as a tool to potentially generate a baud rate of 9600 Hz, which is a common speed for UART communication. However, note that without further details or clock division, this section alone does not showcase the complete implementation for establishing a 9600 Hz signal.

#### UART Transmission Module

```verilog
module uart_tx_8n1 (
    clk,        // input clock
    txbyte,     // outgoing byte
    senddata,   // trigger tx
    txdone,     // outgoing byte sent
    tx,         // tx wire
);
```

##### Functionality
- **State Machine**: The UART module operates as a simple state machine with several states:
  - `STATE_IDLE`: No transmission occurring.
  - `STATE_STARTTX`: Initiates the transmission by sending a start bit.
  - `STATE_TXING`: Sends the data bits, one at a time.
  - `STATE_TXDONE`: Completes the transmission and sends the stop bit.
  
##### Transmission Logic
The UART system sends data according to the 8N1 format, which means:
- 8 data bits
- No parity bit
- 1 stop bit

Each state serves a distinct signaling purpose which adheres to UART communication standards.

#### RGB Driver

```verilog
SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1),
    .RGB0PWM(uartrx),
    .RGB1PWM(uartrx),
    .RGB2PWM(uartrx),
    .CURREN(1'b1),
    .RGB0(led_green),
    .RGB1(led_blue),
    .RGB2(led_red)
);
```

The RGB LED driver interfaces the UART receive signal (`uartrx`) to the LED control signals. Each LED’s brightness can be modulated by the same `uartrx` input, making the LEDs respond visually to incoming UART data.

#### PCF File

```plaintext
set_io led_green 40
set_io led_red	39
set_io led_blue 41
set_io uarttx 14
set_io uartrx 15
set_io hw_clk 20
```

This PCF file maps the I/O pins in the Verilog code to physical pins on the hardware device. Here is a breakdown:
- LED pins are assigned to specific GPIOs (General Purpose Input/Output).
- UART TX and RX pins are also mapped, facilitating communication.

### Conclusion

The loopback logic is primarily facilitated by the direct assignment of `uartrx` to `uarttx`, allowing for a self-testing UART mode. This is particularly useful for testing communication setups. The RGB LED outputs provide visual feedback based on UART RX activity while the state machine in the `uart_tx_8n1` module ensures proper transmission using the UART protocol.

There are still a few improvements that could be explored, such as error handling and more precise generation of timing signals for reliable communication. 

This document serves as an overview and reference for anyone looking to understand or further develop the UART loopback functionality implemented in the provided code.  

</details>
  
## 2. Design Documentation:
<details>
<summary>Design Documentation</summary>
  
Create a block diagram illustrating the UART loopback architecture.

![VSDSquadron-FPGA-Mini Project - Task 2 1 (2)](https://github.com/user-attachments/assets/3305a57f-4a2f-40c1-a92f-4b427ad0cfe9)

Develop a detailed circuit diagram showing connections between the FPGA and any peripheral devices used.

![VSDSquadron-FPGA-Mini Project - Task 22](https://github.com/user-attachments/assets/ad0da020-d427-40f0-8c47-761ad72ef984)

</details>

## 3. Implementation:
<details>
<summary>Implementation</summary>
    
### **Hardware Setup**

- Refer to the [VSDSquadron FPGA Mini Datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf)
 for board details and pinout specifications.
- Connect a USB-C interface between the board and the host computer.
- Check FTDI connection in order to facilitate FPGA programming and debugging. Validate new serial device on you host system i.e. in Windows Device Manger that you see an additionam COM-Port, COM8 in my case.
 
  ![image](https://github.com/user-attachments/assets/2b0adc95-aefd-413d-86a2-c0dc65b42b20)

    or in VM provided by VSD, in Devices -> USB

  ![image](https://github.com/user-attachments/assets/848be0a3-a1fa-457c-837b-dc11097a178a)

### **steps for compiling and flashing**

   open a termin window, cd to uart_loopback folder and execute below described comand sequence.

   ![image](https://github.com/user-attachments/assets/f4d5efd6-f14b-467d-a250-ec9733383f3e)

### **Execution Sequence**
```
lsusb # To check if Fpga is connected
```
   ![image](https://github.com/user-attachments/assets/e756da51-45cb-43f7-b6fa-ea4fb10c6c7c)     
```
make clean # Clear out old compilation artifacts

make build # Compile the Verilog design

sudo make flash # Upload the synthesized bitstream to the FPGA

```

   ![image](https://github.com/user-attachments/assets/2eb60b66-db50-41c2-bf3e-19a87e23c079)

the led's on the board look like this, all leds ligthing red as expected!

![image](https://github.com/user-attachments/assets/a6b76bcb-a977-4da5-aa0d-35dac6fcf71a)

</details>

## 4. Testing and Verification:
<details>
<summary>Testing and Verification</summary>

1. For the testing we will use docklight porogran which is a great testing tool for serial communication protocols. It allows us to monitor the communication between two serial devices.It can be downladed from [here](https://docklight.de/downloads/).
    
2. befor we start using dockligth we chek in Windows Device Manager that COM-Port is still availabel - COM8 in my case.

   ![image](https://github.com/user-attachments/assets/70879f06-c0b9-42a6-ba68-19fbab6a121f)

- open Docklight and start with "Start with a blank project / blank script".

    ![image](https://github.com/user-attachments/assets/1f7f5a08-f2ad-4422-ba62-50fd0cbfe11c)

 - Configure the correct communication port and protocol: COM8, 9600, 8, N, 1

   ![image](https://github.com/user-attachments/assets/7d193f1a-2e18-4802-bde0-6d3a395a13a7)

  - in top icon-bar you find the "Start comminication" butten (marked with red arrow)

  - ![image](https://github.com/user-attachments/assets/ba39faba-e85a-4d03-892b-17cb26455f83)

- click now on "Start communication" butten or F5 to start receiving process. As defined in Verilog-module we reveive continuous the char "D". 

- ![image](https://github.com/user-attachments/assets/250441a2-289b-41b1-bda6-023bf8008d7d)

</details>

## 5: Final Documentation:
<details>
<summary>Final Documentation of Task 2</summary>
    
### Summary of the Verilog code functionality
The given [Verilog module](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/9221679090866a04f7cff231b9ec5c29e8601404/Task%202/top.v) works as a UART (Universal Asynchronous Receiver-Transmitter) for serial communication between devices. It use on one port for transmitting char "D", verified via Docklight in Video below. In addition LED driver in ICS40 is used to blink RGB-Led in red, green and blue color. 

[Video Docklight](https://github.com/user-attachments/assets/d5be707e-d4f0-4cf1-95cb-7f162dee374c)


[Video LED blinking](https://github.com/user-attachments/assets/aebb2fbd-2adc-4f61-bce9-0b80ef9081bc)


### Challenges Faced and Solutions Implemented

- Found it hard to understand the Verilog code originally - using google & ChatGPT i were able to understand things better but i have to investigate sill into Verilog.

## License
This project is open-source under the MIT License.

## Contact
Email: mimo3000ngmail.com
</details>Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.
