#FPGA PWM Breathing LED Series (10-LED Array)
##Project Overview
This project, developed using Quartus II 13.1, implements a series of LED breathing effects on the Altera Cyclone III (EP3C16F484C6) hardware platform. The project evolves from basic synchronized breathing (Phase 1) to a sequential chasing effect with phase offsets (Phase 2), and finally to a resource-optimized symmetrical mirror effect (Phase 3).

##Environment & Hardware
IDE: Quartus II 13.1 (64-bit)

FPGA Platform: Altera Cyclone III EP3C16F484C6

System Clock: 50MHz

##Directory Structure
The repository is organized into three main phases. Each folder contains the independent Verilog source code and detailed design documentation:

01_Basic_Breath: Basic Synchronized Breathing

Key Tech: PWM Modulation, Tango Flag (Directional Control), 50MHz Clock Synchronization.

Effect: All 10 LEDs fade in and out simultaneously in a 2-second cycle.

02_Sequential_Run: Sequential Chasing Flow

Key Tech: Module Instantiation, Phase Offset configuration.

Effect: LEDs create a "chasing" wave effect while maintaining the 2-second breathing rhythm.

03_Mirror_Wave: Symmetrical Mirror Effect

Key Tech: Symmetrical Mapping, Hardware Resource Optimization.

Effect: A "heartbeat" pattern where light radiates from the center outward to both edges.

##Core Design Logic
The series successfully addresses two critical challenges in FPGA digital logic design: Asynchronous Clock Conflicts and Symmetrical Transition Logic.

The Tango Flag: Instead of using unstable clock dividers, this project utilizes a boundary-detection flag. When brightness reaches 0% or 100%, the tango flag toggles, ensuring stable directional logic regardless of the initial reset state.

Precise Timing Control: By using parameterized counters to divide the 50MHz clock, the system triggers a state update every 0.1s. This ensures exactly 20 steps per 2-second cycle, providing a smooth visual experience.

##Quick Start
Clone or download this repository.

Open the .qpf project file for the desired phase in Quartus II.

Verify the pin assignments in the Pin Planner (LED0~LED9, CLK, RST).

Compile the project and program the .sof file to your Cyclone III board.

##About the Authors
This project is part of the FPGA System Design Practice Lab at National Yunlin University of Science and Technology (NYUST).

Special Thanks: Special thanks to Gemini for the logic validation and technical discussions. Although the "AI gap" was humbling, independently deriving the Tango Flag logic was a highly rewarding development milestone.