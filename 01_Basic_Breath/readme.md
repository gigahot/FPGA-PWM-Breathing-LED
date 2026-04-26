# 💡Phase 1: The Journey of Designing the Breathing LED

## 📝Project Overview
The objective of this experiment is to implement a Pulse Width Modulation (PWM) controller combined with a Finite State Machine (FSM) on the Cyclone III FPGA platform. By utilizing a parameterized counter to manage the 50MHz system clock, the project aims to achieve a full "Fade-in to Fade-out" cycle within 2 seconds. This lab focuses on understanding the relationship between duty cycles and perceived brightness, as well as mastering synchronization between modular hardware components.

## 🏗️Part I: Module & Logic Description

### 1. 🌊PWM Generator (**PWM.v**)
First, let's talk about the **PWM module**. Internally, it features a counter (cnt) that resets and starts over after reaching its maximum value. In this lab, I set the maximum to 9, meaning the full cycle period ($T$) is $10$ cycles ($9 + 1$).
The logic of PWM dimming is simple: **"How long should the LED stay ON within one cycle?"** - We compare the internal cnt with an external input duty.
* If cnt < duty, the output is 1 (ON); otherwise, it's 0 (OFF).
* As the duty value decreases, the number of "zeros" in a cycle increases, dimming the LED.  
  🌕1111111111 ➡️ 100% Brightness  
  🌓1111100000 ➡️ 50% Brightness  
  🌑0000000000 ➡️ 0% (OFF)  

### 2. 🎮Duty Cycle Controller (**repeat_cycle.v**)
To create a breathing effect (fading from dark to bright and back), we need to dynamically change the duty value. I used an **Enable Signal (en)** from a parameterizable counter to trigger state transitions every $0.1$ seconds.
To achieve the "bounce" between dark and bright, I introduced a tango **flag**:
🚩**Reset/Start**: tango is initialized to 0.  
⬆️**At** duty_zero: tango is set to 1 (Triggering an upward transition).  
⬆️**At** duty_ten: tango is set to 0 (Triggering a downward transition).  
* **Directional Logic**: When tango is 0, the sequence goes $10 \rightarrow 9 \rightarrow \dots \rightarrow 0$. When tango is 1, it reverses to $0 \rightarrow 1 \rightarrow \dots \rightarrow 10$.

### 3. ⏱️Precision Timing (**up_cnt_pmtr.v**)
The requirement was a full breathing cycle every **2 seconds**. I divided this into **20 state** changes (covering 11 distinct brightness levels from 100% down to 0% and back).
* **Sequence**: $10 \rightarrow 9 \rightarrow \dots \rightarrow 1 \rightarrow 0 \rightarrow 1 \rightarrow \dots \rightarrow 9$ (Total 20 steps).
* **Timing**: To fit 20 changes into 2 seconds, each state must last **0.1 seconds**. With a $50\text{MHz}$ clock, this means triggering every **5,000,000 cycles**.
Initially, I thought this would be **"a piece of cake"** after reviewing the lecture slides. However, realizing the LED had to fade in and out added a layer of complexity I hadn't expected.

## 🛠️Part II: Challenges & Solutions

### ❌The Failed Attempt with Clock Divider
**Experimental Concept**: Initially, I referred to the "1/6 Clock Divider" principle from our lectures (where the signal toggles every 3 counts). Since the goal was a 2-second cycle (Fade-out to Fade-in), I planned to use a counter to toggle the signal every $50,000,000$ cycles (1.0s).

**Encountered Issues**: However, the actual hardware results were not as expected. Significant flickering or jitter occurred near the peak brightness and darkness transitions (e.g., between $80\% \sim 70\%$ or $10\% \sim 20\%$), making the visual effect very unsmooth.

**Root Cause Analysis**: Upon analysis, the primary issue was Clock Synchronization.

**1. Signal Conflict**: The "Up-counter" used for duty cycle transitions (triggered every 0.1s) and the "Clock Divider circuit" (triggered every 1.0s) were running asynchronously.

**2. Logic Glitch**: When the FSM attempted to transition to the next brightness level (e.g., from duty_one to duty_two), the asynchronous timing meant the divider had not yet toggled. This caused a logic conflict that forcibly pulled the signal back to duty_zero.

**Conclusion**: This timing misalignment led to inconsistent circuit behavior. I realized that a simple clock divider cannot reliably handle multi-stage brightness transitions, leading me to abandon this approach.

### ⚠️Considerations of the Enable Counter
**Experimental Concept**: After moving on from the clock divider, I considered using an Enable Counter. The idea was to set up a 4-bit register count that increments whenever the 0.1s enable signal (en) triggers, driving the state transitions.

**Encountered Challenges**: While simple, I realized this approach was somewhat "clumsy" and inflexible for complex requirements. Specifically, it struggled with scenarios like pwm_LED_02 or 03, where the sequence does not always start from a fixed 0% or 100% brightness.

**The Reversal Problem**: Suppose the initial state is 50% brightness (duty_five). After fading down to 0%, how would a simple counter know to "reverse" and start incrementing back to 10%? A basic increment-only counter cannot handle this symmetrical "down-then-up" logic.

**Conclusion**: To ensure the circuit could correctly perform a "Bright-Dark-Bright" cycle from any starting point, I realized I had to abandon this unidirectional logic.

### ✅Final Solution: The Tango Flag Epiphany
**The Epiphany**: While taking a shower one day, an elegant solution suddenly came to me: I could solve all the issues by simply implementing a flag named tango at the boundaries—duty_ten (Max) and duty_zero (Min).

**Logic Operation**: When the state reaches duty_ten, tango is set to 0; when it hits duty_zero, tango is set to 1. For subsequent state transitions, the system simply checks the value of tango to decide whether to increment or decrement the brightness.

**Key Advantages**: This method is both clever and universal. It doesn't rely on complex clock dividers, and regardless of where the initial reset state points, it correctly triggers a reversal at the boundaries, perfectly handling the "Fade-out to Fade-in" logic.

**AI Coincidence**: Interestingly, when I later reviewed a previous suggestion from Gemini (which I had initially ignored to solve it myself), I realized its idea was identical to mine. I couldn't help but sigh, "My talent is no match for Gemini; I feel the gap between us."

**Summary**: Although it feels like I'm on the verge of being replaced by AI, independently deriving the same logical architecture as an advanced model was a highly rewarding development experience.
