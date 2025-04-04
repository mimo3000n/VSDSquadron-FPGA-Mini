
# VSDSquadron-FPGA-Mini Project - Task 3

## Overview
Develop a UART transmitter module capable of sending serial data from the FPGA to an external device.

## 1: Study the Existing Code
-	Access the uart_tx project from the VSDSquadron_FM repository.
-	Examine the Verilog code to understand the transmission process.

<details>
<summary>Here is a detailed explanation of the transmission process for the provided Verilog code. </summary>

# Transmission Process of Verilog Code

## Overview

The provided Verilog code implements a simple UART (Universal Asynchronous Receiver Transmitter) transmission module, along with RGB LED control. It generates a 9600 Hz clock from a higher frequency oscillator and uses this clock to send a byte of data over UART while controlling RGB LEDs based on the frequency counter.

## Structure of the Code

The code consists of two main modules:
1. `top`
2. `uart_tx_8n1`

### 1. Top Module

#### Module Declaration

```verilog
module top (
  output wire led_red,
  output wire led_blue,
  output wire led_green,
  output wire uarttx,
  input wire hw_clk
);
```

#### Signal Declaration

- Outputs: Red, Blue, and Green LEDs, UART transmission pin.
- Input: Hardware clock.

#### Internal Components

- **Instant Oscillator**: 
  - A high-frequency oscillator (`SB_HFOSC`) generates a base clock signal.
  
- **Frequency Counter**: 
  - A 28-bit register (`frequency_counter_i`) is used to count clock cycles.

#### Clock Generation for 9600 Hz

```verilog
reg clk_9600 = 0;
reg [31:0] cntr_9600 = 32'b0;
parameter period_9600 = 625;
```

This section generates a 9600 Hz clock signal from the oscillator's output (12 MHz) using a counter. The counter increments on every rising edge of `int_osc` and toggles `clk_9600` after 625 counts (representing 9600 Hz).

#### UART Transmission

```verilog
uart_tx_8n1 DanUART (.clk (clk_9600), .txbyte("D"), .senddata(frequency_counter_i[24]), .tx(uarttx));
```

Here, the `uart_tx_8n1` module is instantiated to handle UART transmission. It sends the character "D" when `frequency_counter_i[24]` is high, triggering the transmission.

### 2. UART Module (`uart_tx_8n1`)

#### Module Declaration

```verilog
module uart_tx_8n1 (
    clk,
    txbyte,
    senddata,
    txdone,
    tx
);
```

#### Signal Declaration

- Inputs: Clock, the byte to transmit (`txbyte`), and a signal to trigger transmission (`senddata`).
- Outputs: `txdone` (indicates transmission completion) and UART transmission signal `tx`.

#### State Machine for Transmission

The module implements a state machine with the following states:
- **STATE_IDLE**: Waiting for transmission trigger.
- **STATE_STARTTX**: Sending the start bit (low).
- **STATE_TXING**: Transmitting data bits (low to high).
- **STATE_TXDONE**: Completing the transmission and sending the stop bit (high).

#### Transmission Process Logic

The logic block reacts to clock edges and includes conditions for each state:
- In **STATE_IDLE**, if `senddata` is high, it transitions to **STATE_STARTTX**.
- In **STATE_STARTTX**, it sends a start bit (low).
- In **STATE_TXING**, it sends the 8 data bits, shifting the byte right.
- In **STATE_TXDONE**, it sends the stop bit (high) and returns to **STATE_IDLE**, indicating the transmission is complete.

## LED Driver

```verilog
SB_RGBA_DRV RGB_DRIVER (
  .RGBLEDEN(1'b1),
  .RGB0PWM (frequency_counter_i[24]&frequency_counter_i[23]),
  .RGB1PWM (frequency_counter_i[24]&~frequency_counter_i[23]),
  .RGB2PWM (~frequency_counter_i[24]&frequency_counter_i[23]),
  .CURREN  (1'b1),
  .RGB0    (led_green),
  .RGB1    (led_blue),
  .RGB2    (led_red)
);
```

This section drives the RGB LEDs' brightness based on bits from `frequency_counter_i`, which allows for a dynamic change in LED colors in sync with the oscillator frequency.

## I/O Pin Assignments

```verilog
set_io  led_green 40
set_io  led_red	39
set_io  led_blue 41
set_io  uarttx 14
set_io  hw_clk 20
```

This specifies the physical pin assignments for the FPGA or hardware where the signals will be connected.

## Conclusion

In summary, the Verilog code implements a UART transmitter alongside RGB LED functionality. The key steps in the transmission process are:
1. Generating a 9600 Hz clock from a higher frequency using a counter.
2. Triggering the transmission when certain conditions are met.
3. Utilizing a state machine to manage the
</details>
  
## 2. Design Documentation:
-	Create a block diagram detailing the UART transmitter module.
-	Develop a circuit diagram illustrating the FPGA's UART TX pin connection to the receiving device.

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
