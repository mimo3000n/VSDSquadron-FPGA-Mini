
# VSDSquadron-FPGA-Mini Project - Task 2

## Overview
Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.

## Study the Existing Code

<details>
<summary>Study the Existing Code</summary>
    The code is a simple UART (Universal Asynchronous Receiver/Transmitter) transmitter module that implements an 8 data bits, no parity, and 1 stop bit (8N1) format. Below, I will explain each part of the code and analyze its functionality.
  
### Module Declaration
```verilog
module uart_tx_8n1 (
    clk,        // input clock
    txbyte,     // outgoing byte
    senddata,   // trigger tx
    txdone,     // outgoing byte sent
    tx,         // tx wire,
);
```
- The module is named `uart_tx_8n1` and has five ports: two inputs (`clk`, `senddata`), one input/output (`txbyte`, which is the byte to transmit), two outputs (`txdone`, indicating transmission completion, and `tx`, the transmission line).

### Input and Output Declarations
```verilog
input clk;
input[7:0] txbyte;
input senddata;
output txdone;
output tx;
```
- `clk`: the clock signal for synchronization.
- `txbyte`: a byte (8 bits) to be transmitted.
- `senddata`: a signal to initiate the transmission.
- `txdone`: signals when the byte has been transmitted.
- `tx`: this is the serial transmission line.

### Parameter Definition
```verilog
parameter STATE_IDLE=8'd0;
parameter STATE_STARTTX=8'd1;
parameter STATE_TXING=8'd2;
parameter STATE_TXDONE=8'd3;
```
- Defines states for the state machine:
  - `STATE_IDLE`: Waiting for the send command.
  - `STATE_STARTTX`: Beginning transmission.
  - `STATE_TXING`: Sending the data bits.
  - `STATE_TXDONE`: Finished transmitting the byte.

### State Variables
```verilog
reg[7:0] state=8'b0;
reg[7:0] buf_tx=8'b0;
reg[7:0] bits_sent=8'b0;
reg txbit=1'b1;
reg txdone=1'b0;
```
- `state`: holds the current state of the state machine.
- `buf_tx`: buffer for the byte being transmitted.
- `bits_sent`: counts the number of bits sent.
- `txbit`: the actual value on the `tx` line (0 for start, data bits, or stop).
- `txdone`: indicates when the transmission is complete.

### Wiring
```verilog
assign tx=txbit;
```
- The `tx` output is assigned the value of `txbit`.

### Always Block
```verilog
always @ (posedge clk) begin
```
- This block is triggered at each rising edge of the clock.

### State Machine Logic
```verilog
if (senddata == 1 && state == STATE_IDLE) begin
    state <= STATE_STARTTX;
    buf_tx <= txbyte;
    txdone <= 1'b0;
end else if (state == STATE_IDLE) begin
    // idle at high
    txbit <= 1'b1;
    txdone <= 1'b0;
end
```
- If `senddata` is asserted while in the `STATE_IDLE`, it transitions to `STATE_STARTTX`, loads the byte to be transmitted into `buf_tx`, and resets `txdone`.

```verilog
if (state == STATE_STARTTX) begin
    txbit <= 1'b0; // Start bit is low
    state <= STATE_TXING;
end
```
- In `STATE_STARTTX`, the output `txbit` is set to low to indicate the start of transmission.

```verilog
if (state == STATE_TXING && bits_sent < 8'd8) begin
    txbit <= buf_tx[0]; // Send LSB first
    buf_tx <= buf_tx >> 1; // Shift the buffer
    bits_sent = bits_sent + 1;
end else if (state == STATE_TXING) begin
    // send stop bit (high)
    txbit <= 1'b1;
    bits_sent <= 8'b0;
    state <= STATE_TXDONE;
end
```
- During the `STATE_TXING`, the module sends the bits of `txbyte` starting from the least significant bit (LSB) to the most significant bit (MSB). It shifts `buf_tx` right after each transmission. When all bits have been sent, it sends the stop bit (high) and transitions to `STATE_TXDONE`.

### Transmission Completion
```verilog
if (state == STATE_TXDONE) begin
    txdone <= 1'b1;
    state <= STATE_IDLE;
end
```
- In the `STATE_TXDONE`, it sets `txdone` to high to indicate that the transmission is complete and transitions back to `STATE_IDLE`.
```


**output ports**:
- *led_red, led_blue, led_green* : These **three output wires** control the **RGB LED colors**. 
      Each wire carries a **single-bit signal** that determines whether its corresponding color is **active** (1) or **inactive** (0).
- *hw_clk* : A **single-bit input wire** that connects to the **hardware oscillator**, 
      providing the system **clock signal** that drives the module's timing.
- *testwire* : A **single-bit output** that provides a **test/debug signal**, specifically connected to **bit 6** of the frequency counter.    
```verilog
            assign testwire = frequency_counter_i[5];
```
**input port**:
- *hw_clk* : A **single-bit input wire** that connects to the **hardware oscillator**, 
      providing the system **clock signal** that drives the module's timing.
  
#### **internal components (oscillator, LED driver)**:
The ICE40 family of FPGAs from Lattice Semiconductor includes several internal oscillators that can be utilized in various designs. Here's a detailed overview of the internal oscillators available in ICE40 FPGAs:

##### Internal Oscillators in ICE40
<details>
    <summary> Types of internal oscillators in IEC40 family</summary>

1. **High-Frequency Oscillator (HFOSC)**:
   - **Module Name**: `SB_HFOSC`
   - **Purpose**: Generates a high-frequency clock signal that can be used in your designs.
   - **Features**:
     - The frequency can be configured by the `CLKHF_DIV` parameter during instantiation.
     - Supports features such as enabling via `CLKHFPU` (power-up) and `CLKHFEN` (enable output).
   - **Use Case**: Suitable for applications that require a high-speed clock, bringing high-frequency timing for digital circuits.

2. **Low-Frequency Oscillator (LFOSC)**:
   - **Module Name**: `SB_LFOSC` (may also be referenced as a generic oscillator without a specific naming convention depending on the toolset).
   - **Purpose**: Provides a low-frequency clock source.
   - **Features**:
     - Generally operates in the range of hundreds of kHz to a few MHz.
     - Often used for low-power applications and scenarios where precise timing is less critical.
   - **Use Case**: Ideal for low-power designs where minimal clock speed is sufficient for operation (e.g., wakeup timers, low-speed peripherals).

3. **Key Parameters for `SB_HFOSC`**
   The `SB_HFOSC` module typically includes the following key parameters:
    - **`CLKHF_DIV`**: Controls the division ratio for the output clock frequency. For instance:
    - `"0b00"`: Output clock divided by 1 (no division).
    - `"0b01"`: Output clock divided by 2.
    - `"0b10"`: Output clock divided by 4, etc.

4. **Ports**:
    - **`CLKHFPU`**: Power-up signal to enable the oscillator.
    - **`CLKHFEN`**: Enable signal to turn on the oscillator output.
    - **`CLKHF`**: The output clock signal.

5. Documentation Reference
  To explore details about these internal oscillators, refer to the official Lattice Semiconductor documentation:
    - **ICE40 Family Data Sheet**: Contains detailed descriptions of the internal oscillator features and their parameters.
    - **ICE40 FPGA User Guides**: Provides application examples and implementation techniques.
</details>

what is used in Task 1 Verliog code:

- **int_osc** : it is designed to carry the output from the internal oscillator **SB_HFOSC** used in the design
```verilog
            wire        int_osc;
```
- **frequency_counter_i** : 28bit register as frequency counter used for timing information and testing/debugging
```verilog
            reg  [27:0] frequency_counter_i;
```
          frequency_counter_i is incremented on every positive edge of *int_osc*
```verilog
            always @(posedge int_osc) begin
                frequency_counter_i <= frequency_counter_i + 1'b1;
            end
```
- **instantiation of internal oscilliator (*SB_HFOSC*)**
```verilog
         SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
```
        - Purpose: This generates a stable internal HF clock signal
        - clock division: Uses CLKHF_DIV = "0b10" (binary 2)
        - Control Signals:
                1. *CLKHFPU = 1'b1* : Enables power-up
                2. *CLKHFEN = 1'b1* : Enables oscillator
                3. *CLKHF* : Output connected to internal *int_osc* signal

##### Internal LED Driver in ICE40
<details>
<summary> description of internal LED Driver in IEC40 family</summary>
In the ICE40 FPGA family from Lattice Semiconductor, there is an internal RGB LED driver that can be used to control RGB LEDs directly from the FPGA fabric. This allows you to easily interface with RGB LEDs without requiring external components. Here are some details about the internal LED driver:

###### Internal RGB LED Driver
Module Name: SB_RGBA_DRV

This module is used to drive RGB LEDs, which generally support Red, Green, and Blue color channels.
Key Features:

The driver allows for the control of multiple LED components simultaneously, facilitating RGB color mixing.
It supports pulse-width modulation (PWM) to control the brightness of each channel by varying the duty cycle.
Inputs and Outputs:

###### Inputs:
RGBLEDEN: Enables the LED driver. Setting this to high allows the RGB LEDs to be driven.
RGB0PWM, RGB1PWM, RGB2PWM: These signals control the brightness levels of the Red, Green, and Blue components, respectively. They are usually set to represent PWM values.
CURREN: This signal is used to enable the current drivers for the respective RGB channels.
####### Outputs:
RGB0, RGB1, RGB2: These are the output signals connected to the actual RGB LED cathodes (or anodes, depending on the LED configuration).
###### Configuration
Brightness Control: The PWM signals typically would be generated by counters or other logic in your design to control how bright each color is displayed on the RGB LED.
Current Settings: The RGB driver allows you to set the driving current for each channel using defparam statements to match the LED specifications for optimal brightness.
###### Documentation Reference
To get more in-depth information regarding the RGB LED driver:

ICE40 Family Data Sheet: Look for details about the RGB driver and its functionality.
ICE40 UltraPlus FPGA User Guide: It includes examples and additional details about using the internal LED driver.
###### Summary
The ICE40 FPGA family includes an internal RGB LED driver (SB_RGBA_DRV) that simplifies controlling RGB LEDs directly from the FPGA, allowing for flexible control over color and brightness. This is particularly useful for user interfaces and visual signaling in various applications. 
</details>

- **instantiation of RGB LED Driver (*SB_RGBA_DRV*)**
```verilog
 SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1                                            ),
    .RGB0PWM (1'b0), // red
    .RGB1PWM (1'b0), // green
    .RGB2PWM (1'b1), // blue
    .CURREN  (1'b1                                            ),
    .RGB0    (led_red                                       ), //Actual Hardware connection
    .RGB1    (led_green                                       ),
    .RGB2    (led_blue                                        )
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";
```

- Configuration:
    1. *RGBLEDEN = 1'b1* : Enables LED operation
    2. *RGB0PWM = 1'b0* : Red LED minimum brightness
    3. *RGB1PWM = 1'b0* : Green LED minimum brightness
    4. *RGB2PWM = 1'b1* : Blue LED maximum brightness
    5. *CURREN = 1'b1* : Enables current control
- Current settings: All LEDs set to "0b000001" (minimum current)
- Output connections:
    1. *RGB0* → *led_red*
    2. *RGB1* → *led_green*
    3. *RGB2* → *led_blue*
</details>
  
## Step 2: Design Documentation:
<details>
<summary>Design Documentation</summary>
  
Create a block diagram illustrating the UART loopback architecture.

![VSDSquadron-FPGA-Mini Project - Task 2 1](https://github.com/user-attachments/assets/47b345ad-05e9-4ce1-872d-653ed2fd52ee)

Develop a detailed circuit diagram showing connections between the FPGA and any peripheral devices used.

![VSDSquadron-FPGA-Mini Project - Task 22](https://github.com/user-attachments/assets/ad0da020-d427-40f0-8c47-761ad72ef984)

</details>

The PCF [Physical Constraint File] file can be accessed [here](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/a8364ed4a33e27c54fb73841acb0c101f5b01b22/Task%201/VSDSquadronFM.pcf). It is used in FPGA development to map logical signals from HDL code to physical pins on the FPGA chip. Each set_io command establishes this connection between the named ports to physical pins on the board.
```pcf
set_io  led_red	39
set_io  led_blue 40
set_io  led_green 41
set_io  hw_clk 20
set_io  testwire 17
````

**set_io**

- This command is used to assign specific I/O signals (wires) in your HDL design to physical pins on the FPGA package. It tells the synthesis and implementation tools which FPGA pins correspond to the specified logic signals in your design.

**led_red, led_blue, led_green, hw_clk, testwire**

-These are the names of the logical signals (or wires) defined in your Verilog design. Each name corresponds to a specific output or input in your design that connects to physical hardware components, such as LEDs or clocks.


**39, 40, 41, 20, 17**
- These are the physical pin numbers of the FPGA where each respective signal will be connected. The numbers refer to the physical pin assignments on the FPGA package.

| Signal    | FPGA Pin | Description          |
|-----------|---------|----------------------|
| led_red   | 39      | Red LED Output       |
| led_blue  | 40      | Blue LED Output      |
| led_green | 41      | Green LED Output     |
| hw_clk    | 20      | External Clock Input |
| testwire  | 17      | Debugging Signal     |

**Validation in provided Datasheet:** [Datasheet](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/829abdf43e5d6107ee70a793af6b33382ff3fe6f/Task%201/VSDSquadronFMDatasheet.pdf)

![image](https://github.com/user-attachments/assets/500904cf-1382-41f5-8f65-6af7b3918028)


## Step 3: Integrating with the VSDSquadron FPGA Mini Board
<details>
<summary>Integration of VSDSquadron FPGA Mini Board</summary>
</details>

## Step 4: Final Documentation
<details>
<summary>Final Documentation of Task 1</summary>
    
### Summary of the Verilog code functionality
This [Verilog module](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/blob/647558cc2cb85a29e7f49e0d7019a559c4cdb210/Task%201/top.v) controls an RGB LED with an internal high-frequency oscillator (SB_HFOSC) and a 28-bit frequency counter. The counter's bit 6 is routed to a testwire for monitoring. The RGB LED driver (SB_RGBA_DRV) provides current-controlled PWM outputs with a fixed configuration: blue at maximum brightness, red and green at minimum. It ensures stable LED operation with minimal external dependencies, making it ideal for embedded systems education.

### Challenges Faced and Solutions Implemented

- Found it hard to understand the Verilog code originally - using google & ChatGPT i were able to understand things better but i have to investigate sill into Verilog.

## License
This project is open-source under the MIT License.

## Contact
Email: mimo3000ngmail.com
</details>Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.
