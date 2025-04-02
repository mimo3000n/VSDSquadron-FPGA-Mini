
# VSDSquadron-FPGA-Mini Project - Task 2

## Overview
Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.

## 1. Study the Existing Code

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

![VSDSquadron-FPGA-Mini Project - Task 2 1](https://github.com/user-attachments/assets/47b345ad-05e9-4ce1-872d-653ed2fd52ee)

Develop a detailed circuit diagram showing connections between the FPGA and any peripheral devices used.

![VSDSquadron-FPGA-Mini Project - Task 22](https://github.com/user-attachments/assets/ad0da020-d427-40f0-8c47-761ad72ef984)

</details>

## 3. Implementation:
<details>
<summary>Implementation/summary>
</details>

## 4. Testing and Verification:
<details>
<summary>Testing and Verification</summary>
</details>

## 5: Final Documentation:
<details>
<summary>Final Documentation of Task 2</summary>
    
### Summary of the Verilog code functionality
This [Verilog module](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/647558cc2cb85a29e7f49e0d7019a559c4cdb210/Task%201/top.v) controls an RGB LED with an internal high-frequency oscillator (SB_HFOSC) and a 28-bit frequency counter. The counter's bit 6 is routed to a testwire for monitoring. The RGB LED driver (SB_RGBA_DRV) provides current-controlled PWM outputs with a fixed configuration: blue at maximum brightness, red and green at minimum. It ensures stable LED operation with minimal external dependencies, making it ideal for embedded systems education.

### Challenges Faced and Solutions Implemented

- Found it hard to understand the Verilog code originally - using google & ChatGPT i were able to understand things better but i have to investigate sill into Verilog.

## License
This project is open-source under the MIT License.

## Contact
Email: mimo3000ngmail.com
</details>Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.
