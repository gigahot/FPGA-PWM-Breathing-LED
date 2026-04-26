# Phase 3: Mirror Wave LED (Symmetrical Breath)
## Project Overview
In Phase 3, I explored **Symmetrical Mapping** to create a "Mirror Wave" effect. Instead of each LED having its own independent sequence, the LED array is divided into two mirrored halves. This results in a visual effect where the breathing pattern originates from the center and radiates outwards to both sides simultaneously.

## Part I: Module & Logic Description
### 1. Resource Optimization through Mirroring
In this version, I optimized the design by only instantiating **5** repeat_cycle **modules** (rp_c5 to rp_c9) to drive all **10 LEDs**. By sharing the duty cycle data (cnt) between pairs of LEDs, I ensured perfect symmetry while reducing hardware logic usage.

### 2. Symmetrical PWM Mapping
The core of the "Mirror" effect lies in how the duty inputs are assigned to the PWM modules. I mapped the 5 sequences to the 10 LEDs in a mirrored fashion:

* Center LEDs (led[4], led[5]): Highest brightness/lead phase (using cnt[9]).

* Inner-Mid LEDs (led[3], led[6]): (using cnt[8]).

* Outer-Mid LEDs (led[2], led[7]): (using cnt[7]).

* Outer LEDs (led[1], led[8]): (using cnt[6]).

* Edge LEDs (led[0], led[9]): Lowest brightness/lag phase (using cnt[5]).

Verilog
// Example of Mirror Mapping in my code:  
PWM pwm9 (.duty(cnt[5]), .pwm(pwm_out[9])); // Edge  
PWM pwm0 (.duty(cnt[5]), .pwm(pwm_out[0])); // Edge  

## Part II: Challenges & Solutions
### 1. Logical Mapping Ingenuity
The challenge here wasn't in the state machine itself, but in the interconnect logic. I had to carefully map the ini (initial values) and the pwm_out indices to ensure the wave looked balanced. By setting the center LEDs to the highest initial value (3'd10) and decreasing towards the edges, I achieved a "heartbeat" effect that feels organic and centered.

### 2. Efficiency Reflection
This project taught me that "more code isn't always better." By realizing that the left side of the board was just a reflection of the right side, I was able to halve the number of controller instances compared to Phase 2. This is a crucial concept in FPGA design: identifying symmetry to save logic resources (LEs).

### 3. Final Project Conclusion
Through these three phases—from synchronized breathing to sequential chasing, and finally to mirrored waves—I have mastered the implementation of PWM control, FSM direction flags (Tango Flag), and complex hardware mapping. The use of a parameterized, modular approach allowed me to pivot from one visual effect to another with minimal changes to the core logic.
