
# VSDSquadron-FPGA-Mini Project

## Overview
Task 1 should analyze verlog code of **top.v**. It includes a module **top**, instantiation of an internal oscillator and RGB LED control.

## Step 1: Understanding the Verilog Code
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
  
###**internal components (oscilatzor, LED driver**:
The ICE40 family of FPGAs from Lattice Semiconductor includes several internal oscillators that can be utilized in various designs. Here's a detailed overview of the internal oscillators available in ICE40 FPGAs:

<details>#### Types of Internal Oscillators in ICE40


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

#### Key Parameters for `SB_HFOSC`
The `SB_HFOSC` module typically includes the following key parameters:
- **`CLKHF_DIV`**: Controls the division ratio for the output clock frequency. For instance:
  - `"0b00"`: Output clock divided by 1 (no division).
  - `"0b01"`: Output clock divided by 2.
  - `"0b10"`: Output clock divided by 4, etc.

- **Ports**:
  - **`CLKHFPU`**: Power-up signal to enable the oscillator.
  - **`CLKHFEN`**: Enable signal to turn on the oscillator output.
  - **`CLKHF`**: The output clock signal.

#### Documentation Reference
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
</details>
