# FPGA Reaction Timer

A real-time reaction timer written in SystemVerilog for a Xilinx Spartan-7 FPGA. The design uses a four-state finite-state machine, a pseudo-random wait period, pushbutton debouncing, millisecond timing, false-start detection, and a multiplexed four-digit seven-segment display.

## Features

- Four-state FSM: `IDLE`, `WAIT`, `GO`, and `RESULT`
- 16-bit LFSR pseudo-random delay generator
- Random wait window defaults to 1-4 seconds
- 1 ms clock-enable generator
- Pushbutton synchronization and debouncing
- False-start detection if the user presses during `WAIT`
- Reaction timing up to 9999 ms
- Four-digit seven-segment display
- `go_led` output that turns on during the reaction window
- Self-checking SystemVerilog testbench for normal and false-start cases

## Project Structure

```text
fpga_reaction_timer/
├── src/
│   ├── reaction_timer_top.sv
│   ├── reaction_timer_core.sv
│   ├── ms_tick.sv
│   ├── debounce.sv
│   ├── lfsr16.sv
│   └── sevenseg_driver.sv
├── sim/
│   └── tb_reaction_timer.sv
├── constraints/
│   └── reaction_timer_template.xdc
├── create_vivado_project.tcl
└── README.md
```

## How It Works

1. **IDLE** - the display shows `----`. Press the button to begin.
2. **WAIT** - the LFSR selects a random delay between 1000 and 4000 ms. The display is blank. Pressing early causes a false start.
3. **GO** - `go_led` turns on and the millisecond reaction counter starts.
4. **RESULT** - the measured reaction time is shown on the display. A false start shows `FALS`. Press the button again to return to `IDLE`.

## Create the Vivado Project

From the project directory, run this in the Vivado Tcl Console or launch Vivado in Tcl mode:

```tcl
source create_vivado_project.tcl
```

The script targets `xc7s50csga324-1`, a Spartan-7 device. If your board uses another Spartan-7 part, edit `part_name` in the Tcl script.

## Board Constraints

`constraints/reaction_timer_template.xdc` intentionally contains placeholder pins because Spartan-7 boards use different package pins.

Assign pins for:

- `clk`
- `reset`
- `button`
- `go_led`
- `seg[6:0]`
- `an[3:0]`

The design assumes a 100 MHz input clock by default. If your board clock is different, change `CLK_HZ` in the top-level parameters and update the XDC clock period.

## Simulation

Set `tb_reaction_timer` as the simulation top and run behavioral simulation. The testbench checks:

- reset into `IDLE`
- transition from `IDLE` to `WAIT`
- random wait completion
- transition to `GO`
- a measured 123 ms reaction
- result capture
- return to `IDLE`
- false-start detection

A passing simulation prints:

```text
All reaction timer core tests passed.
```

## Resume Description

**FPGA Reaction Timer | SystemVerilog, Vivado, Xilinx Spartan-7**

- Designed a real-time reaction timer on a Xilinx Spartan-7 FPGA, driven by a four-state finite state machine (`IDLE`, `WAIT`, `GO`, `RESULT`) with LFSR-based random delays and false-start detection
- Implemented supporting modules for millisecond clock timing, button debouncing, reaction counting, and multiplexed seven-segment display output
- Built a self-checking simulation testbench covering normal reaction timing, state transitions, result capture, and false-start behavior

After you run synthesis and implementation successfully on your own board in Vivado, you can accurately replace the final bullet with: "Synthesized, simulated, and verified the complete timing-critical design in Vivado."
