# Eriksen Flanker Task

This repository contains MATLAB code and analysis for a **colored Eriksen Flanker Task**, implemented using [Psychtoolbox](http://psychtoolbox.org/).  
The experiment was conducted with 16 participants as part of the *Introduction to Programming* course in the MCNB Master’s program at Freie Universität Berlin.

## Overview
The task measures the effect of stimulus congruency on reaction times and accuracy.  
Participants responded to the color of a target square while ignoring the two flanking distractor squares.

### Experimental Design
- **Stimuli**: Three colored squares (target in the middle, flankers on each side).
- **Conditions**:
  - **Congruent** — flankers match the target color.
  - **Incongruent** — flankers differ from the target color.
  - **Neutral** — flankers unrelated to target color.
- **Response mapping**:
  - Red/Green → key **A**
  - Blue/Yellow → key **L**
- **Trials**: 96 trials per participant (24 per block × 4 blocks), randomized order.
- **Dependent variables**: reaction time (ms), accuracy (% correct).

### Procedure
1. Instruction screen → 15-trial practice block (with feedback).
2. Experimental blocks (no feedback; “Too Slow” message if >3 seconds).
3. Approximately 3 minutes total duration.
4. Data saved per trial (reaction time, accuracy).
