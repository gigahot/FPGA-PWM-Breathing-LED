# Phase 2: Sequential Running LED with Phase Offset
## Project Overview
Building upon the synchronized breathing effect in Phase 1, this version introduces a sequential flow (chasing effect). While all LEDs share the same breathing frequency, each LED starts at a different brightness level, creating a visual wave or "running" effect across the 10-LED array.

## Part I: Module & Logic Description
### 1. Multi-Instance PWM Array
Unlike Phase 1, which broadcasted a single PWM signal, Phase 2 implements **10 individual PWM instances** (pwm0 to pwm9). Each instance is controlled by its own dedicated duty cycle signal (cnt[0] to cnt[9]).

### 2. Initial Value Configuration (ini Parameter)
The core logic of this sequential effect lies in the repeat_cycle module's initialization. I assigned different initial duty cycle values to each instance:

* rp_c0 starts at ini(3'd1)

* rp_c1 starts at ini(3'd2)

* ...

* rp_c9 starts at ini(3'd10) (Full Brightness)

By staggering these starting points, the LEDs don't reach their peak brightness at the same time, resulting in a smooth, continuous flow.

### 3. Logic Inheritance
All other support modules (sync.v, up_cnt_pmtr.v, and PWM.v) remain identical to Phase 1, ensuring a stable foundation while focusing on the visual logic expansion.

## Part II: Challenges & Solutions
### 1. Scaling the Design
The primary challenge was moving from a "one-to-many" broadcast logic to a "many-to-many" mapping. I had to ensure that 10 different repeat_cycle instances remained perfectly synchronized with the same en (enable) pulse to maintain the 2-second cycle duration, while each maintained its unique state.

### 2. The Power of Initial States
Initially, I wondered if I needed 10 different state machines. However, I realized that because I solved the "reversal problem" with the **Tango Flag** in Phase 1, I could simply "drop" each LED into a different part of the same cycle.

For example, when rp_c9 hits duty_ten and starts fading down, rp_c0 might just be hitting duty_zero and starting to fade up.

The Tango Flag handles the direction of each LED independently based on its own boundaries, which is why the tango logic proved to be so universal.

##3. Hardware Efficiency Reflection
Even though I instantiated 10 sets of controllers, the FPGA resources remained low because the logic (Tango flag and 4-bit counters) is extremely efficient. This version demonstrates how a simple logical block, when staggered in time (Phase Offset), can create a much more complex and professional visual output.
