# Project Themes:
•  Real-Time Sensor Data Acquisition and Transmission System: This theme focuses on developing systems that interface with various sensors to collect data, process it using the FPGA, and transmit the information to external devices through communication protocols like UART.
•  FPGA-Based Digital Oscilloscope: This theme involves designing a digital oscilloscope utilizing the FPGA to sample input signals, process the data, and display waveforms on a screen, enabling real-time signal analysis.
 
## Objectives:
•	Conduct comprehensive research on the chosen theme.
•	Formulate a detailed project proposal outlining the system's functionality, required components, and implementation strategy.
Steps:
### 1. Literature Review:
-	Explore existing projects and resources related to the selected theme.
<details>
<summary>Literature Review</summary>

There are several open-source projects available for iCE40 FPGAs, particularly for educational purposes and various applications, including digital oscilloscopes. Below are noteworthy projects and resources:

#### IceStorm
- **Description**: IceStorm is an open-source toolchain for Lattice iCE40 FPGAs, providing synthesis, place-and-route, and programming utilities.
- **Repository**: [IceStorm GitHub Repository](https://github.com/cliffordwolf/icestorm)
- **Features**: It includes examples that help you understand how to use iCE40 devices, supporting Verilog code, and comprehensive documentation.

#### iCE40 Oscilloscope Projects
- **TinyFPGA**: The TinyFPGA project, which supports iCE40 chips, includes examples for building a simple oscilloscope.
  - **Repository**: [TinyFPGA Projects](https://github.com/tinyfpga/TinyFPGA-BX)
  - **Example**: Look for projects utilizing the ADC and displaying captured signals on an LED matrix or small screen.

#### iCE40 Video (ICE40-VGA)
- **Description**: This project showcases how to use iCE40 FPGAs for video applications, which can include generating waveform displays similar to those seen on oscilloscopes.
- **Repository**: [ice40-vga GitHub](https://github.com/LEDing/ice40-vga)
- **Features**: While not a direct oscilloscope, the project provides insights into waveform generation.

#### OpenOCD/FPGA Support
- **Description**: Open On-Chip Debugger (OpenOCD) supports various debugging methods and can interact with FPGA designs.
- **Repository**: [OpenOCD GitHub](https://github.com/ntfreak/openocd)
- **Usage**: Useful for debugging designs running on iCE40s, especially when developing more complex logic including ADC interfaces.

#### Lattice Semiconductor Resources
- **Description**: Lattice provides several application design examples that showcase how to effectively use their FPGAs, including educational projects.
- **Website**: [Lattice Design Resources](https://www.latticesemi.com/en/solutions/design-resources)
- **Examples**: These often come with design files and educational materials, although not all are open source.

#### Community and Forums
- **Hackaday.io**: Browse for iCE40 projects and tutorials where users share designs, including oscilloscopes and other signal processing tools.
- **FPGA Forums**: Online communities can be valuable resources to find user-generated content and projects.

#### GitHub and Other Public Repositories
- Search GitHub for repositories specifically mentioning "iCE40 oscilloscope" or "iCE40 ADC". Users frequently share educational projects that can be inspirations or direct implementations.

These projects and resources provide an excellent foundation for learning about using iCE40 FPGAs in digital signal processing applications. They can also serve as inspiration for your own designs, especially if you're focusing on building a digital oscilloscope or similar educational project. Refer to the documentation associated with each project for guidance on setup and implementation.
</details>

### 2.	Define System Requirements:
-	Identify the necessary hardware components, such as specific sensors or display modules, and software tools required for the project.
<details>
<summary>Define System Requirement</summary>

# Hardware and Software Components for Digital Oscilloscope Project

## Hardware Components

### 1. iCE40 FPGA Development Board
- **Recommendation**: TinyFPGA BX or iCE40 UltraPlus Breakout Board
  - **Features**: Low power consumption, reasonable I/O capabilities, easy prototyping.
  - **Usage**: Acts as the main processing unit for collecting and processing ADC data.

### 2. Analog-to-Digital Converter (ADC)
- **Recommendation**: Microchip MCP3201
  - **Resolution**: 12-bit
  - **Sampling Rate**: Up to 100 kSPS
  - **Interface**: SPI (Serial Peripheral Interface)
  - **Usage**: Converts analog signals to digital form, allowing the FPGA to process the data.

### 3. DDR4 Memory Module
- **Recommendation**: Micron MT40A256M16 (4Gb DDR4 SDRAM)
  - **Features**: Sufficient capacity for storing sampled data.
  - **Usage**: Stores collected ADC data for further processing and display.

### 4. Power Supply
- **Recommendation**: 5V DC power supply or battery pack suitable for portable use.
  - **Usage**: Powers the development board, ADC, and any additional components like displays.

### 5. Display Module
- **Recommendation**: OLED or LCD Display (e.g., 128x64 OLED display)
  - **Interface**: I2C or SPI (based on the display chosen)
  - **Usage**: Displays waveform visualizations of the captured signals from the ADC.

### 6. Prototyping Accessories
- **Breadboard**: For prototyping connections between the FPGA, ADC, and other components.
- **Jumper wires**: For making electrical connections between components.
- **Resistors, capacitors, and other passive components**: As needed for signal conditioning or filtering.

### 7. Sensors (Optional)
- **Signal Probes**: For measuring various signals (e.g., oscilloscopes probes).
- **Other sensors**: Depending on the application, you may add temperature or other sensors for expanded functionality.

## Software Tools

### 1. FPGA Development Tools
- **Lattice iCEcube2**: 
  - **Features**: Design entry, synthesis, place & route, and programming for iCE40 FPGAs.
  - **Usage**: Primary tool for developing and programming the FPGA.

- **IceStorm Toolchain**: 
  - **Features**: Open-source toolchain for Lattice iCE40 FPGAs.
  - **Usage**: Includes synthesis, place-and-route tools, and programming utility for free.

### 2. Simulation and Verification Tools
- **ModelSim or GHDL**: 
  - **Usage**: For simulating HDL code ensuring that your design works as intended before hardware implementation.
  
### 3. Code Development
- **Verilog/VHDL IDE**: 
  - **Recommendation**: A text editor or IDE such as Visual Studio Code with HDMI extensions or dedicated tools like Gedit, VIM, etc.
  - **Usage**: Write and edit Verilog or VHDL code for the FPGA design.

### 4. Configuration and Programming Tools
- **OpenOCD**: 
  - **Features**: Open On-Chip Debugger for programming and debugging.
  - **Usage**: Load the compiled design onto the FPGA and handle any debugging during development.

### 5. Libraries and Frameworks
- **FPGA Libraries**: Depending on your choice of ADC, you may need libraries for interfacing with SPI or I2C.
- **Display Libraries**: Libraries for managing graphics on the display module (e.g., u8g2 for OLED displays).

## Conclusion
This outline provides a comprehensive list of hardware components and software tools to build a digital oscilloscope with an iCE40 FPGA. Ensure to validate each component's compatibility with your overall design, and refer to datasheets and manuals for specific implementation details.

</details>

### 3.	Design System Architecture:
-	Develop block diagrams illustrating the system's architecture, including data flow between components.
<summary>Design System Architecture</summary>
<details>
  
</details>

### 4.	Develop a Project Plan:
Outline the implementation steps, timelines, and milestones for the project with detailed explanation and block diagrams wherever necessary
<summary>Develop a Project Plan</summary>

#### Deliverables:
-	A comprehensive project proposal document.
<details>

# Project Proposal: Development of a Digital Oscilloscope Using iCE40 FPGA

## 1. Introduction

### 1.1 Background
Digital oscilloscopes are vital tools for electronics engineers, enabling the visualization of voltage signals as waveforms over time. This project aims to design and develop a basic digital oscilloscope using an Lattice iCE40 FPGA, emphasizing educational purposes and hands-on learning in digital signal processing, FPGA design, and data acquisition.

### 1.2 Objective
The main objective of this project is to build a functional digital oscilloscope capable of capturing and displaying analog signals using an ADC interfaced with the iCE40 FPGA and a display module.

## 2. Project Scope

This project encompasses:
- Selection of appropriate hardware components, including ADCs, memory, and display modules.
- Development of firmware to interface with the components using Verilog/VHDL.
- Design of the system architecture including data flow diagrams and block diagrams.
- Testing and validation of the oscilloscope functionality.

## 3. Hardware Components

### 3.1 Main Components
- **iCE40 FPGA Development Board**
  - Example: TinyFPGA BX or iCE40 UltraPlus Breakout Board
- **Analog-to-Digital Converter (ADC)**
  - Example: Microchip MCP3201 (12-bit resolution, 100 kSPS)
- **DDR4 Memory Module**
  - Example: Micron MT40A256M16 (4Gb DDR4 SDRAM)
- **Display Module**
  - Example: 128x64 OLED display (I2C or SPI interface)
- **Power Supply**
  - 5V DC power supply or battery pack

### 3.2 Additional Components
- Signal probes for input measurement
- Breadboard and jumper wires for connections
- Resistors, capacitors, and other passive components for signal conditioning

## 4. Software Tools

### 4.1 Development Environment
- **Lattice iCEcube2**: Design entry and FPGA programming tool.
- **IceStorm Toolchain**: Open-source toolchain for Lattice iCE40 FPGAs.
- **Simulation Tools**: ModelSim or GHDL for simulating Verilog/VHDL designs.
- **OpenOCD**: For programming and debugging the FPGA.

### 4.2 Code Libraries
- Libraries for managing I2C or SPI communications for display and ADC interaction.

## 5. Project Timeline

| Phase                     | Task                                   | Duration    |
|---------------------------|----------------------------------------|-------------|
| Phase 1: Design & Research| Research components and functionalities| 2 weeks     |
| Phase 2: Hardware Setup   | Assemble hardware components           | 1 week      |
| Phase 3: Firmware Development| Implement ADC and DDR4 interface logic| 3 weeks     |
| Phase 4: Testing          | Validate functionality and performance | 2 weeks     |
| Phase 5: Documentation    | Compile findings and create user manuals| 1 week      |
| **Total Duration**        |                                        | **9 weeks** |

## 6. Expected Outcomes

- A functional digital oscilloscope that can visualize waveforms from analog signals.
- An educational experience in FPGA development, digital signal processing, and hardware integration.
- Documentation and user manuals providing insights into setup and operation.

## 7. Budget Estimate

| Item                       | Cost Estimate |
|----------------------------|---------------|
| iCE40 FPGA Development Board| $30-50       |
| ADC Module                 | $10-20       |
| DDR4 Memory Module         | $20-30       |
| Display Module             | $5-15        |
| Miscellaneous Components    | $10-20       |
| **Total Estimated Cost**   | **$85-155**  |

## 8. Conclusion

This project seeks to bridge the gap between theoretical knowledge in electronics and practical application through hands-on development of a digital oscilloscope. By utilizing readily available components and open-source tools, the project is approachable and educationally beneficial, preparing participants for more advanced projects in embedded systems and digital signal processing.

## 9. References

- Lattice Semiconductor: iCE40 Products
- Microchip Technology: MCP3201 ADC Datasheet
- Micron Technology: MT40A256M16 DDR4 Datasheet
- Display Module Manufacturer Documentation

  
</details>

-	System architecture diagrams.
<details>
<summary>System architecture diagrams</summary> 
</details>

### 4. develop a project plan.

<details>
<summary>Implementation Steps and Project Timelin</summary>
# Implementation Steps and Project Timeline for Digital Oscilloscope Using iCE40 FPGA

## Project Overview

### Objective
Develop a digital oscilloscope capable of capturing and visualizing analog signals through the integration of an iCE40 FPGA, an ADC, and a display module.

## Implementation Steps

### 1. Research and Design (Weeks 1-2)
- **Tasks**:
  - Research various ADC options to determine which best fits project specifications (e.g., resolution, sampling rate).
  - Study the capabilities and limitations of the iCE40 FPGA to understand how to implement the design.
  - Define the overall architecture and data flow of the digital oscilloscope.
  
- **Deliverables**:
  - Comprehensive research report outlining selected components.
  - Initial system architecture diagram.

### 2. Component Selection (Week 3)
- **Tasks**:
  - Select the following components:
    - FPGA Development Board
    - ADC module
    - DDR4 memory chip
    - Display module (OLED/LCD)
  - Place orders for the selected components, considering delivery times.

- **Deliverables**:
  - Bill of materials (BOM) including all components with specifications.
  - Confirmation of orders placed with suppliers.

### 3. Hardware Setup (Week 4)
- **Tasks**:
  - Assemble all hardware components on a breadboard or custom PCB.
  - Create clear wiring diagrams to illustrate connections between the FPGA, ADC, and other peripherals.
  - Implement proper power supply connections to ensure all components are powered appropriately.

- **Deliverables**:
  - Completed hardware prototype.
  - Wiring diagram documentation.

### 4. Firmware Development (Weeks 5-7)
- **Tasks**:
  - Develop Verilog/VHDL code for the following:
    - ADC Interface Logic: Handle ADC data acquisition.
    - FIFO Buffer Logic: Buffer data to manage rate differences between the ADC and DDR4.
    - DDR4 Controller: Manage read/write operations with the DDR4 memory.
    - Display Controller: Convert digital data into a visual representation for the display.

- **Deliverables**:
  - Complete firmware source code.
  - Code documentation and comments.

### 5. Simulation & Testing (Weeks 8-9)
- **Tasks**:
  - Simulate individual components using a simulation tool like ModelSim or GHDL to verify functionality.
  - Perform unit tests on firmware modules to confirm correct behavior.
  - Integrate firmware into the FPGA and test the complete system using various input signals.

- **Deliverables**:
  - Simulation results confirming component functionality.
  - Verification and validation report on system performance.

### 6. Calibration & Validation (Weeks 10-11)
- **Tasks**:
  - Calibrate the oscilloscope with known signal inputs using a function generator.
  - Validate output signal accuracy and ensure the design meets performance requirements.
  - Make adjustments to firmware algorithms as needed based on testing results.

- **Deliverables**:
  - Calibration report detailing the accuracy of measurements.
  - Final validation results showing successful operation of the oscilloscope.

### 7. Documentation (Week 12)
- **Tasks**:
  - Compile a user manual detailing how to operate the oscilloscope, including setup, functions, and troubleshooting.
  - Document design decisions, code comments, and findings from the project.
  - Prepare final presentation materials summarizing project outcomes.

</details>


----------------------------------------------
# Project Plan: Digital Oscilloscope Development Using iCE40 FPGA

## Project Overview

### Objective
Develop a digital oscilloscope that captures and displays analog signals using an iCE40 FPGA, an ADC, and a display module. The project will provide hands-on experience in FPGA design, digital signal processing, and component integration.

## Project Phases and Timeline

| Phase                      | Tasks                                                     | Duration       | Start Date   | End Date     | Responsible   | Resources Required                                  |
|----------------------------|----------------------------------------------------------|----------------|--------------|--------------|---------------|-----------------------------------------------------|
| **Phase 1: Research & Design**    | - Research ADC options and specifications<br>- Research FPGA capabilities<br>- Define system architecture and requirements | 2 weeks       | 05/01/2025   | 05/14/2025   | Team Member 1 | Internet access, component datasheets, design software (e.g., draw.io) |
| **Phase 2: Component Selection** | - Select hardware components (ADC, FPGA, DDR4, Display)<br>- Order components and confirm delivery dates          | 1 week        | 05/15/2025   | 05/21/2025   | Team Member 2 | Component suppliers (e.g., Digi-Key, Mouser), budget for purchasing |
| **Phase 3: Hardware Setup**      | - Assemble the hardware prototype on breadboard<br>- Create wiring diagrams<br>- Ensure proper power supply connections  | 1 week        | 05/22/2025   | 05/28/2025   | Team Member 1 | Breadboard, jumper wires, power supply, multimeter for testing |
| **Phase 4: Firmware Development**| - Implement ADC interface logic in Verilog/VHDL<br>- Develop FIFO buffer logic<br>- Write DDR4 controller logic<br>- Implement display controller logic | 3 weeks       | 05/29/2025   | 06/18/2025   | Team Member 3 | FPGA development environment (iCEcube2, IceStorm), simulation tools (e.g., ModelSim), code libraries |
| **Phase 5: Simulation & Testing**| - Simulate individual components (ADC interface, buffers)<br>- Perform unit tests on firmware modules<br>- Integrate components and test the complete system | 2 weeks       | 06/19/2025   | 07/02/2025   | Team Member 3 | Simulation tools (e.g., ModelSim or GHDL), testing equipment (oscilloscope, logic analyzer) |
| **Phase 6: Calibration & Validation** | - Calibrate the oscilloscope against known signals<br>- Validate signal accuracy and functionality<br>- Adjust firmware algorithms as necessary | 2 weeks   | 07/03/2025   | 07/16/2025   | Team Member 1 | Calibration signals (function generator), existing oscilloscope for reference, testing protocols |
| **Phase 7: Documentation**      | - Create user manual for the oscilloscope<br>- Document design decisions and code comments<br>- Compile findings into a final report | 1 week        | 07/17/2025   | 07/23/2025   | Team Member 2 | Document editing software (e.g., Google Docs, LaTeX), presentations software |
| **Phase 8: Presentation & Review** | - Prepare presentation materials<br>- Present project outcomes to stakeholders<br>- Gather feedback and suggestions for improvement | 1 week        | 07/24/2025   | 07/30/2025   | All Team Members | Presentation software (e.g., PowerPoint, Google Slides), feedback tools |

## Total Project Duration
- **Duration**: 12 weeks
- **Start Date**: 05/01/2025
- **End Date**: 07/30/2025

## Milestones
- **Milestone 1**: Completion of research and design phase (05/14/2025)
- **Milestone 2**: Hardware components selected and ordered (05/21/2025)
- **Milestone 3**: Hardware prototype successfully assembled (05/28/2025)
- **Milestone 4**: Firmware development completed (06/18/2025)
- **Milestone 5**: Successful testing and validation of the oscilloscope (07/16/2025)
- **Milestone 6**: Final documentation and presentation prepared (07/30/2025)

## Team Roles
- **Team Member 1**: Research, Hardware setup, Calibration
- **Team Member 2**: Component selection, Documentation, General support
- **Team Member 3**: Firmware development, Simulation/testing
  
</details>

