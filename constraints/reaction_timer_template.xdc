## FPGA Reaction Timer constraints - Real Digital Urbana board (xc7s50csga324-1)
## Pins taken from the Urbana master constraints file (V2I1).
##
## Board notes:
##  - Buttons, switches and seven-segment displays sit in a 2.5 V bank, so they
##    must use LVCMOS25. LEDs and the clock are LVCMOS33.
##  - Buttons read 1 when pressed (active-high), which matches the design.
##  - Seven-segment cathodes and anodes are active-low, which matches the design.
##  - The design drives seg[6] = segment A ... seg[0] = segment G, so the order
##    below is reversed compared with the Urbana master file (SEG[0] = CA there).

## 100 MHz clock
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## reset = BTN1, button = BTN0
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS25} [get_ports reset]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS25} [get_ports button]

## go_led = LED0
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports go_led]

## Seven-segment display 0
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS25} [get_ports {seg[6]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS25} [get_ports {seg[5]}]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS25} [get_ports {seg[4]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS25} [get_ports {seg[3]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS25} [get_ports {seg[2]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS25} [get_ports {seg[1]}]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS25} [get_ports {seg[0]}]

## On the Urbana, G6 is the leftmost digit and B3 the rightmost. This design
## uses an[0] for the rightmost (ones) digit, so the anodes are reversed here.
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS25} [get_ports {an[0]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS25} [get_ports {an[1]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS25} [get_ports {an[2]}]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS25} [get_ports {an[3]}]
