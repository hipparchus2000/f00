# TCL Script to generate Xilinx IP cores for F00 CPU
# Run this script in Vivado to create the necessary IP cores
# Usage: source generate_ip_cores.tcl

# Set up project (modify path as needed)
set project_name "f00_cpu_ip"
set project_dir "./xilinx_ip_project"

# Create project
create_project $project_name $project_dir -part xc7a35tcpg236-1 -force

# 1. Register File - Block Memory Generator (32x16-bit dual-port RAM)
puts "Creating Register File Block RAM..."
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name register_file_bram
set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Write_Width_A {16} \
    CONFIG.Write_Depth_A {32} \
    CONFIG.Read_Width_A {16} \
    CONFIG.Write_Width_B {16} \
    CONFIG.Read_Width_B {16} \
    CONFIG.Enable_A {Always_Enabled} \
    CONFIG.Enable_B {Always_Enabled} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
    CONFIG.Port_A_Clock {100} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_A_Enable_Rate {100} \
    CONFIG.Port_B_Enable_Rate {100} \
] [get_ips register_file_bram]

# 2. Program Counter - Binary Counter (16-bit up/down counter with load)
puts "Creating Program Counter..."
create_ip -name c_counter_binary -vendor xilinx.com -library ip -version 12.0 -module_name pc_counter
set_property -dict [list \
    CONFIG.Output_Width {16} \
    CONFIG.Increment_Value {1} \
    CONFIG.Restrict_Count {false} \
    CONFIG.Count_Mode {UP} \
    CONFIG.Load {true} \
    CONFIG.SCLR {true} \
    CONFIG.CE {true} \
    CONFIG.Implementation {Fabric} \
] [get_ips pc_counter]

# 3. ALU Adder/Subtracter
puts "Creating ALU Adder/Subtracter..."
create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name alu_addsub
set_property -dict [list \
    CONFIG.A_Width {16} \
    CONFIG.B_Width {16} \
    CONFIG.Out_Width {16} \
    CONFIG.Add_Mode {Add_Subtract} \
    CONFIG.A_Type {Unsigned} \
    CONFIG.B_Type {Unsigned} \
    CONFIG.Latency_Configuration {Automatic} \
    CONFIG.Latency {1} \
    CONFIG.B_Value {0000000000000000} \
    CONFIG.CE {false} \
    CONFIG.C_In {false} \
    CONFIG.C_Out {true} \
    CONFIG.SCLR {false} \
    CONFIG.SSET {false} \
    CONFIG.SINIT {false} \
] [get_ips alu_addsub]

# 4. Instruction ROM - Block Memory Generator
puts "Creating Instruction ROM..."
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name instruction_rom
set_property -dict [list \
    CONFIG.Memory_Type {Single_Port_ROM} \
    CONFIG.Write_Width_A {16} \
    CONFIG.Write_Depth_A {32768} \
    CONFIG.Read_Width_A {16} \
    CONFIG.Enable_A {Always_Enabled} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Load_Init_File {true} \
    CONFIG.Coe_File {../test_programs/test_program.coe} \
    CONFIG.Port_A_Clock {100} \
    CONFIG.Port_A_Enable_Rate {100} \
] [get_ips instruction_rom]

# 5. Data RAM - Block Memory Generator
puts "Creating Data RAM..."
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name data_ram
set_property -dict [list \
    CONFIG.Memory_Type {Single_Port_RAM} \
    CONFIG.Write_Width_A {16} \
    CONFIG.Write_Depth_A {32768} \
    CONFIG.Read_Width_A {16} \
    CONFIG.Enable_A {Always_Enabled} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Port_A_Clock {100} \
    CONFIG.Port_A_Enable_Rate {100} \
] [get_ips data_ram]

# 6. Clock Generator - Clocking Wizard
puts "Creating Clock Generator..."
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_gen
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
    CONFIG.USE_RESET {false} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.CLKIN1_JITTER_PS {100.0} \
    CONFIG.MMCM_DIVCLK_DIVIDE {5} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {47.250} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {18.875} \
    CONFIG.CLKOUT1_JITTER {175.402} \
    CONFIG.CLKOUT1_PHASE_ERROR {164.985} \
] [get_ips clk_gen]

# Generate all IP cores
puts "Generating all IP cores..."
generate_target all [get_ips register_file_bram]
generate_target all [get_ips pc_counter]
generate_target all [get_ips alu_addsub]
generate_target all [get_ips instruction_rom]
generate_target all [get_ips data_ram]
generate_target all [get_ips clk_gen]

# Create synthesis run for IP cores
puts "Creating synthesis runs..."
create_ip_run [get_ips register_file_bram]
create_ip_run [get_ips pc_counter]
create_ip_run [get_ips alu_addsub]
create_ip_run [get_ips instruction_rom]
create_ip_run [get_ips data_ram]
create_ip_run [get_ips clk_gen]

puts "IP core generation complete!"
puts "Generated IP cores:"
puts "  - register_file_bram: 32x16-bit dual-port RAM for register file"
puts "  - pc_counter: 16-bit binary counter for program counter"
puts "  - alu_addsub: 16-bit adder/subtracter for ALU operations"
puts "  - instruction_rom: 32K x 16-bit ROM for instruction memory"
puts "  - data_ram: 32K x 16-bit RAM for data memory"
puts "  - clk_gen: 50MHz clock generator from 100MHz input"

# Generate example .coe file for instruction ROM
set coe_file [open "../test_programs/test_program.coe" w]
puts $coe_file "memory_initialization_radix=16;"
puts $coe_file "memory_initialization_vector="
puts $coe_file "0000,   // NOP or first instruction"
puts $coe_file "0001,   // Example instruction"
puts $coe_file "0002;"  // End with semicolon
close $coe_file

puts "Created example .coe file: test_programs/test_program.coe"
puts "Modify this file with your actual F00 program instructions"