during VSDSquadron-FPGA Mini Class i have to work on different Tasks related to FPGA-board provided by VSD.

this repo reflects work on all taks and contain all used material.

# VSDSquadron FPGA Mini (FM) Internship 
## 🙌 Acknowledgement
- Kunal Ghosh, Co-founder, VSD Corp. Pvt. Ltd.
- Professor Madhav Roa, International Institute of Information Technology, Bangalore
- Professor Subir K Roy, International Institute of Information Technology, Bangalore
 - Professor Himanshu Rai, International Institute of Information Technology, Bangalore
- Mr. Sudarshan R, National Institute of Advanced Studies (NIAS)
## 📚 Resources
[VSDSquadron FPGA Mini (FM)](https://www.vlsisystemdesign.com/vsdsquadronfm/)
## ⚡ About FPGA Board
![FPGA Mini](https://github.com/user-attachments/assets/1c39daa2-2e8c-47ed-8f8c-a40f7b32df06)
![FPGA Mini](https://github.com/user-attachments/assets/89b6bf16-97ae-4214-b8fa-ac8d3fe2e682)

The VSDSquadron FPGA Mini (FM) is a compact and low-cost development board designed for FPGA prototyping and embedded system projects. This board provides a seamless hardware development experience with an integrated programmer, versatile GPIO access, and onboard memory, making it ideal for students, hobbyists, and developers exploring FPGA-based designs.

**The VSDSquadron FM board - Features and specifications:**
###  FPGA:
– Powered by the Lattice UltraPlus ICE40UP5K FPGA

– Offers 5.3K LUTs, 1Mb SPRAM, 120Kb DPRAM, and 8 multipliers for versatile design
capabilities
###  Connectivity:
– Equipped with an FTDI FT232H USB to SPI device for seamless communication

– All FTDI pins are accessible through test points for easy debugging and customization
###  General Purpose I/O (GPIO):
– All 32 FPGA GPIOs brought out for easy prototyping and interfacing
###  Memory:
– Integrated 4MB SPI flash for data storage and configuration
###  LED Indicators:
– RGB LED included for status indication or user-defined functionality
###  Form Factor:
– Compact design with all pins accessible, perfect for fast prototyping and embedded applications

**Block Diagram**

![image](https://github.com/user-attachments/assets/10308705-7d7e-4052-b18a-2663bcb0e788)

**Board Overview**

![image](https://github.com/user-attachments/assets/c8019505-11f6-40ce-a50d-7d57972fe5d4)

## ICE40UP5K-SG48ITR Specification

| Feature                     | Specification                         |
|-----------------------------|--------------------------------------|
| **Technology Node**         | 40 nm                               |
| **Logic Cells**             | 5,280                               |
| **Flip-Flops**              | 4,960                               |
| **SRAM Blocks**             | 120 kbits                           |
| **DSP Blocks**              | None                                |
| **Package Type**            | SG48                                |
| **I/O Pins**                | 39                                  |
| **I/O Standards Supported** | LVCMOS, LVDS                        |
| **Max Operating Frequency** | 133 MHz                             |
| **Clock Sources**           | Internal oscillator & external clock |
| **Core Voltage**            | 1.2V                                |
| **I/O Voltage**             | 3.3V, 2.5V, 1.8V                   |
| **Operating Temperature**   | -40°C to 85°C                      |
| **Development Tools**       | Project Icestorm, Yosys, NextPNR    |
## ✅ Task
- [Task 1](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/tree/f2dc22679ddc3caba393c163f38a492fbb7128da/Task%201) -The project focuses on implementing and testing an FPGA-based RGB LED controller on the VSDSquadron FPGA Mini board. It involves analyzing a Verilog design, mapping pin configurations using a PCF file, and programming the FPGA to control LED behavior using an internal oscillator.

- [Task 2](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/tree/f2dc22679ddc3caba393c163f38a492fbb7128da/Task%202) -The task implements a UART loopback mechanism on the VSDSquadron FPGA Mini, where transmitted data is immediately received back, enabling easy testing and debugging of UART functionality

- [Task 3](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/tree/f2dc22679ddc3caba393c163f38a492fbb7128da/Task%203) - This task develop a UART transmitter module capable of sending serial data from the FPGA to an external device.

- [Task 4](https://github.com/mimo3000n/VSDSquadron-FPGA-Mini/tree/f2dc22679ddc3caba393c163f38a492fbb7128da/Task%204) - This task implement a UART transmitter that sends data based on sensor inputs, enabling the FPGA to communicate real-time sensor data to an external device.
## ✍ Author
**Gerhard Koller**
**Github-** [Gerhard Koller](https://github.com/mimo3000n)






