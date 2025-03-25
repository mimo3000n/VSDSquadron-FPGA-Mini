
# VSDSquadron-FPGA-Mini Project

## Overview
Exersice 1 should analyze verlog code of **top.v**. It includes a module **top**, instantiation of an internal oscillator and RGB LED control.

## 1.Modul Analysis:
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
  
**internal components**:
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
- **setup of internal oscilliator (*SB_HFOSC*)**
```verilog
         SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
```
        - Purpose: This generates a stable internal HF clock signal
        - clock division: Uses CLKHF_DIV = "0b10" (binary 2)
        - Control Signals:
                1. *CLKHFPU = 1'b1* : Enables power-up
                2. *CLKHFEN = 1'b1* : Enables oscillator
                3. *CLKHF* : Output connected to internal *int_osc* signal


- **RGB LED Driver (*SB_RGBA_DRV*)**

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
  
## 2.Pin Mappings
| Signal    | FPGA Pin | Description          |
|-----------|---------|----------------------|
| led_red   | 39      | Red LED Output       |
| led_blue  | 40      | Blue LED Output      |
| led_green | 41      | Green LED Output     |
| hw_clk    | 20      | External Clock Input |
| testwire  | 17      | Debugging Signal     |


## License
This project is open-source under the MIT License.

## Contact
Email: kmskanda29@gmail.com

