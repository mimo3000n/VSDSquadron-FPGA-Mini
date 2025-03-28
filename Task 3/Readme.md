
# VSDSquadron-FPGA-Mini Project - Task 3

## Overview
Develop a UART transmitter module capable of sending serial data from the FPGA to an external device.

## Step 1: Study the Existing Code
The UART (Universal Asynchronous Receiver-Transmitter) is a hardware communication protocol designed for serial communication between devices. It features two primary data lines: the TX (Transmit) pin and the RX (Receive) pin. A UART loopback mechanism serves as a test or diagnostic mode where data sent to the TX pin is routed directly back to the RX pin of the same module. This functionality allows the system to confirm the proper operation of the TX and RX lines without requiring an external device. 

--------------------------------------------------------------

### `top.v` Module Analysis

#### Overview
The `top.v` module serves as the top-level module for a design that includes RGB LED control and UART transmission functionality. It generates a 9600 Hz clock from a high-frequency oscillator and drives RGB LEDs based on a frequency counter.

#### Module Declaration
```verilog
module top (
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green , // Green
  output wire uarttx , // UART Transmission pin
  input wire  hw_clk
);
```
- **Module Name:** The module is named `top`.
- **Ports:**
  - `led_red`, `led_blue`, `led_green`: Output wires for the RGB LEDs.
  - `uarttx`: Output wire for the UART transmission pin.
  - `hw_clk`: Input wire for the hardware clock signal.

#### Internal Signals
```verilog
wire        int_osc            ;
reg  [27:0] frequency_counter_i;
```
- **Internal Signals:**
  - `int_osc`: A wire that will carry the output of the internal oscillator.
  - `frequency_counter_i`: A 28-bit register that serves as a counter for generating PWM signals and controlling other timing-related functionalities.

#### 9600 Hz Clock Generation
```verilog
reg clk_9600 = 0;
reg [31:0] cntr_9600 = 32'b0;
parameter period_9600 = 625;
```
- **Clock Variables:**
  - `clk_9600`: A register that will hold the generated 9600 Hz clock signal.
  - `cntr_9600`: A 32-bit counter for generating the 9600 Hz clock by counting the number of cycles of the `int_osc`.
  - `period_9600`: A parameter defining the period for the 9600 Hz clock generation.

#### UART Transmission Instantiation
```verilog
uart_tx_8n1 DanUART (.clk (clk_9600), .txbyte("D"), .senddata(frequency_counter_i[24]), .tx(uarttx));
```
- **UART Instance:** An instance of the `uart_tx_8n1` module is created, named `DanUART`.
  - `clk`: Connected to the `clk_9600` signal.
  - `txbyte`: Transmits the ASCII character "D" when `senddata` is asserted.
  - `senddata`: Controlled by the 24th bit of `frequency_counter_i`.
  - `tx`: Output connected to the `uarttx` pin.

#### Internal Oscillator
```verilog
SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
```
- **Oscillator Instance:** A high-frequency oscillator is instantiated to generate a reference clock for the module.
  - `CLKHFPU`: Power-up signal enabled.
  - `CLKHFEN`: Oscillator enabled.
  
The oscillator's output is connected to `int_osc`, which provides the clock source for the frequency counter.

#### Frequency Counter
```verilog
always @(posedge int_osc) begin
  frequency_counter_i <= frequency_counter_i + 1'b1;
  /* generate 9600 Hz clock */
  cntr_9600 <= cntr_9600 + 1;
  if (cntr_9600 == period_9600) begin
    clk_9600 <= ~clk_9600;
    cntr_9600 <= 32'b0;
  end
end
```
- **Counter Logic:**
  - The always block triggers on the rising edge of `int_osc`.
  - It increments `frequency_counter_i`, which can be used for signaling or timing purposes.
  - `cntr_9600` counts the number of cycles of the oscillator. When it reaches `period_9600` (625 counts at 12 MHz), it toggles the `clk_9600` signal and resets the counter.

#### RGB LED Driver Instantiation
```verilog
SB_RGBA_DRV RGB_DRIVER (
  .RGBLEDEN(1'b1                                            ),
  .RGB0PWM (frequency_counter_i[24]&frequency_counter_i[23] ),
  .RGB1PWM (frequency_counter_i[24]&~frequency_counter_i[23]),
  .RGB2PWM (~frequency_counter_i[24]&frequency_counter_i[23]),
  .CURREN  (1'b1                                            ),
  .RGB0    (led_green                                       ), //Actual Hardware connection
  .RGB1    (led_blue                                       

Here's the detailed analysis in Markdown format. You can copy and paste this into a file named `uart_tx_8n1_analysis.md`.

```markdown
# UART TX 8N1 Module Analysis

## 1. Module Declaration
```verilog
module uart_tx_8n1 (
    clk,        // input clock
    txbyte,     // outgoing byte
    senddata,   // trigger tx
    txdone,     // outgoing byte sent
    tx,         // tx wire
);
```
- **Module Name**: The module is named `uart_tx_8n1`.
- **Ports**:
  - `clk`: The clock input used to synchronize the state transitions.
  - `txbyte`: The 8-bit input representing the byte to be transmitted.
  - `senddata`: A control signal used to trigger the transmission of the `txbyte`.
  - `txdone`: An output signal that indicates when the transmission of the byte is complete.
  - `tx`: The serial output line used to transmit data.

## 2. Input and Output Declarations
```verilog
input clk;
input[7:0] txbyte;
input senddata;

output txdone;
output tx;
```
- **Inputs**:
  - `clk`: The clock signal for synchronizing operations.
  - `txbyte`: A byte (8 bits) to be transmitted.
  - `senddata`: A signal to start the transmission process.
  
- **Outputs**:
  - `txdone`: Indicates that the byte has been successfully transmitted.
  - `tx`: Serial transmission line.

## 3. Parameters
```verilog
parameter STATE_IDLE=8'd0;
parameter STATE_STARTTX=8'd1;
parameter STATE_TXING=8'd2;
parameter STATE_TXDONE=8'd3;
```
- **States**: The parameters define the various states of the state machine used in UART transmission:
  - `STATE_IDLE`: The initial state where no transmission is occurring.
  - `STATE_STARTTX`: The state where the start bit is sent.
  - `STATE_TXING`: The state during which data bits are being transmitted.
  - `STATE_TXDONE`: The state indicating that the transmission is complete.

## 4. State Variables
```verilog
reg[7:0] state=8'b0;
reg[7:0] buf_tx=8'b0;
reg[7:0] bits_sent=8'b0;
reg txbit=1'b1;
reg txdone=1'b0;
```
- **State Variables**:
  - `state`: Holds the current state of the transmission process.
  - `buf_tx`: Buffer that stores the byte to be transmitted.
  - `bits_sent`: Counts the number of bits that have been transmitted.
  - `txbit`: The signal that is driven onto the `tx` wire (initialized to high).
  - `txdone`: A flag to indicate the completion of the transmission (initialized to low).

## 5. Wiring
```verilog
assign tx=txbit;
```
- The `assign` statement connects the `tx` output to the `txbit` signal, which carries the current bit value being transmitted.

## 6. The Always Block
```verilog
always @ (posedge clk) begin
```
- This `always` block triggers on the positive edge of the clock signal, allowing the state machine to process events in sync with the clock.

## 7. State Machine Logic
The state machine governs the transmission process:

### Start Sending
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
- If `senddata` is high and the state is `STATE_IDLE`, the machine transitions to `STATE_STARTTX`, and the byte to be transmitted is loaded into `buf_tx`.

### Send Start Bit
```verilog
if (state == STATE_STARTTX) begin
    txbit <= 1'b0; // Start bit is low
    state <= STATE_TXING;
end
```
- In this state, the start bit is sent as a low signal (ground). The state then transitions to `STATE_TXING`.

### Clock Data Out
```verilog
if (state == STATE_TXING && bits_sent < 8'd8) begin
    txbit <= buf_tx[0]; // Send LSB first
    buf_tx <= buf_tx >> 1; // Shift the buffer
    bits_sent = bits_sent + 1;
end else if (state == STATE_TXING) begin
    // send stop bit (high)
    txbit

-------------------------------------------------------------

```verilog
module top (
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green , // Green
  input wire hw_clk,  // Hardware Oscillator, not the internal oscillator
  output wire testwire
);

  wire        int_osc            ;
  reg  [27:0] frequency_counter_i;

  assign testwire = frequency_counter_i[5];
 
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
  end
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
  
## Step 2: Creating the PCF File

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
