## FPGA Reaction Timer constraints template
## Replace each <PIN> with the package pin for your Spartan-7 board.
## The top module expects a clock, reset, one pushbutton, four seven-segment
## digit enables, seven segment lines, and one GO LED.

# set_property PACKAGE_PIN <PIN> [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# create_clock -period 10.000 -name sys_clk [get_ports clk]

# set_property PACKAGE_PIN <PIN> [get_ports reset]
# set_property IOSTANDARD LVCMOS33 [get_ports reset]

# set_property PACKAGE_PIN <PIN> [get_ports button]
# set_property IOSTANDARD LVCMOS33 [get_ports button]

# set_property PACKAGE_PIN <PIN> [get_ports go_led]
# set_property IOSTANDARD LVCMOS33 [get_ports go_led]

# set_property PACKAGE_PIN <PIN> [get_ports {seg[0]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[1]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[2]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[3]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[4]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[5]}]
# set_property PACKAGE_PIN <PIN> [get_ports {seg[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

# set_property PACKAGE_PIN <PIN> [get_ports {an[0]}]
# set_property PACKAGE_PIN <PIN> [get_ports {an[1]}]
# set_property PACKAGE_PIN <PIN> [get_ports {an[2]}]
# set_property PACKAGE_PIN <PIN> [get_ports {an[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]
