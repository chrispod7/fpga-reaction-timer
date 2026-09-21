set project_name reaction_timer
set project_dir ./vivado_project
set part_name xc7s50csga324-1

create_project $project_name $project_dir -part $part_name -force

add_files [glob ./src/*.sv]
add_files -fileset sim_1 ./sim/tb_reaction_timer.sv
add_files -fileset constrs_1 ./constraints/reaction_timer_template.xdc

set_property top reaction_timer_top [current_fileset]
set_property top tb_reaction_timer [get_filesets sim_1]
set_property target_language Verilog [current_project]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Vivado project created at $project_dir"
puts "Target part: $part_name"
puts "Update the XDC file with your board pin assignments before generating a bitstream."
