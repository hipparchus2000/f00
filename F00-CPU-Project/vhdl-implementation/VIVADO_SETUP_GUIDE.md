# F00 CPU - Vivado Setup and Simulation Guide

This guide walks you through setting up and running the F00 CPU VHDL implementation in Xilinx Vivado from start to finish.

## 📋 **Prerequisites**

- **Xilinx Vivado** 2020.1 or newer (recommended: 2022.2 or later)
- **F00 CPU VHDL files** (from this repository)
- **Target FPGA board** (optional, for hardware deployment)
- **Basic VHDL knowledge** (helpful but not required)

## 🚀 **Step-by-Step Setup Guide**

### **Step 1: Launch Vivado**

1. Open **Xilinx Vivado Design Suite**
2. Click **Create Project** from the Quick Start menu
3. Click **Next** to proceed

### **Step 2: Create New Project**

1. **Project name**: `F00_CPU_Project`
2. **Project location**: Choose your workspace directory
3. **Create project subdirectory**: ✅ (checked)
4. Click **Next**

5. **Project Type**: Select **RTL Project**
6. **Do not specify sources at this time**: ✅ (checked)
7. Click **Next**

### **Step 3: Select Target Device**

**For Development/Simulation:**
- **Family**: Artix-7
- **Device**: xc7a35t
- **Package**: cpg236
- **Speed**: -1

**For Specific Hardware:**
- Select your target FPGA board from the **Boards** tab
- Common options: Basys 3, Arty A7, Nexys A7

Click **Next**, then **Finish**

### **Step 4: Generate Xilinx IP Cores**

1. In Vivado, open **TCL Console** (bottom panel)
2. Navigate to the IP generation directory:
   ```tcl
   cd C:/users/hippa/src/f00/F00-CPU-Project/vhdl-implementation/xilinx-ip
   ```
3. Run the IP generation script:
   ```tcl
   source generate_ip_cores.tcl
   ```

**Expected Output:**
```
Creating Register File Block RAM...
Creating Program Counter...
Creating ALU Adder/Subtracter...
Creating Instruction ROM...
Creating Data RAM...
Creating Clock Generator...
Generating all IP cores...
IP core generation complete!
```

**Note:** This process may take 5-10 minutes depending on your system.

### **Step 5: Add VHDL Source Files**

1. In the **Sources** panel, right-click **Design Sources**
2. Select **Add Sources...**
3. Choose **Add or create design sources**
4. Click **Next**

5. Click **Add Files**
6. Navigate to `C:/users/hippa/src/f00/F00-CPU-Project/vhdl-implementation/`
7. Select these files:
   - `f00_cpu_top.vhd`
   - `ism.vhd`
8. Click **OK**, then **Finish**

### **Step 6: Add IP Cores to Project**

1. In the **Sources** panel, right-click **Design Sources**
2. Select **Add Sources...**
3. Choose **Add or create design sources**
4. Click **Add Files**
5. Navigate to the generated IP directory (usually `xilinx_ip_project/F00_CPU_IP.srcs/sources_1/ip/`)
6. Add all generated IP core `.xci` files:
   - `register_file_bram.xci`
   - `pc_counter.xci`
   - `alu_addsub.xci`
   - `instruction_rom.xci`
   - `data_ram.xci`
   - `clk_gen.xci`
7. Click **Finish**

### **Step 7: Add Testbench**

1. Right-click **Simulation Sources**
2. Select **Add Sources...**
3. Choose **Add or create simulation sources**
4. Click **Add Files**
5. Select `f00_cpu_tb.vhd`
6. Click **Finish**

### **Step 8: Set Top-Level Modules**

1. **Design Top**: Right-click `f00_cpu_top` in Design Sources
2. Select **Set as Top**

3. **Simulation Top**: Right-click `f00_cpu_tb` in Simulation Sources
4. Select **Set as Top**

### **Step 9: Create Test Program (.coe file)**

1. Create/edit `test_programs/test_program.coe`:
   ```
   memory_initialization_radix=16;
   memory_initialization_vector=
   4110,1234,4120,5678,8B04,8252,8132,8014,8594,0000,0000,0000;
   ```

   **This program does:**
   ```assembly
   ; Address 0-1: LOADIMM R1, 0x1234
   4110, 1234,
   ; Address 2-3: LOADIMM R2, 0x5678
   4120, 5678,
   ; Address 4: ADD R1, R2 (R2 = R1 + R2)
   8B04,
   ; Address 5: MOVE R2, R3 (R3 = R2)
   8252,
   ; Address 6: STORE R3, R1 (Store R3 to address in R1)
   8132,
   ; Address 7: LOAD R1, R4 (Load from address in R1 to R4)
   8014,
   ; Address 8: JUMPABS R20 (infinite loop, R20 contains 0)
   8594,
   ; Padding
   0000,0000,0000;
   ```

### **Step 10: Run Behavioral Simulation**

1. In the **Flow Navigator**, click **Run Simulation**
2. Select **Run Behavioral Simulation**

**Vivado will:**
- Compile all VHDL files
- Elaborate the design
- Launch the simulator
- Open the waveform viewer

### **Step 11: Configure Waveform View**

**Add Key Signals to Waveform:**
1. In the **Scope** panel, expand `f00_cpu_tb/uut`
2. Right-click and select **Add to Wave Window**:
   - `clk`
   - `reset_n`
   - `debug_pc`
   - `debug_state`
   - `debug_flags`
   - `imem_addr`
   - `imem_data`
   - `dmem_addr`
   - `dmem_data_out`

**Configure Display:**
1. Right-click signal names → **Radix** → **Hexadecimal**
2. **Zoom Fit** to see full simulation
3. **Run** for 2000ns or click **Run All**

### **Step 12: Analyze Results**

**Expected Behavior:**
1. **Reset Phase**: `debug_state` = 0x00, `debug_pc` = 0x0000
2. **Instruction Fetch**: `debug_state` cycles through 0x01, 0x02, 0x03
3. **LOADIMM R1**: `debug_state` = 0x40-0x42, loads 0x1234
4. **LOADIMM R2**: `debug_state` = 0x40-0x42, loads 0x5678
5. **ADD**: `debug_state` = 0x50-0x52, R2 becomes 0x68AC
6. **MOVE**: `debug_state` = 0x10-0x14, copies R2 to R3
7. **STORE**: `debug_state` = 0x30-0x32, writes to memory
8. **LOAD**: `debug_state` = 0x20-0x22, reads from memory
9. **JUMP**: `debug_state` = 0x80-0x81, jumps to address 0

**Check Console Output:**
- Look for simulation messages showing instruction execution
- UART output characters (if any)
- State transition reports

## 🔧 **Synthesis and Implementation**

### **Step 13: Run Synthesis** (Optional - for FPGA deployment)

1. Click **Run Synthesis** in Flow Navigator
2. Wait for completion (5-15 minutes)
3. **Open Synthesized Design** to view results

**Check Resource Utilization:**
- LUTs: ~2000 (varies by target device)
- Flip-Flops: ~1000
- Block RAMs: ~10

### **Step 14: Run Implementation** (Optional)

1. Click **Run Implementation**
2. Wait for completion (10-30 minutes)
3. **Open Implemented Design**

### **Step 15: Generate Bitstream** (Optional)

1. Click **Generate Bitstream**
2. Wait for completion
3. Bitstream ready for FPGA programming

## 🐛 **Troubleshooting**

### **Common Issues:**

**IP Core Generation Fails:**
```bash
# Solution: Ensure correct Vivado version and valid license
# Try regenerating IP cores individually
```

**Compilation Errors:**
```vhdl
-- Check that all files are added to correct source sets
-- Verify IP core .xci files are included
-- Ensure f00_cpu_top is set as design top
```

**Simulation Doesn't Start:**
```bash
# Check testbench is set as simulation top
# Verify all IP cores are generated successfully
# Look for errors in Messages tab
```

**No Waveforms:**
```bash
# Add signals manually: Simulation → Add to Wave Window
# Run simulation for sufficient time (2000ns+)
# Check that reset is released (reset_n = '1')
```

**Incorrect Behavior:**
```bash
# Verify .coe file format and content
# Check instruction encoding matches assembler output
# Compare with JavaScript simulator results
```

### **Debug Tips:**

1. **Check Messages Tab** for warnings/errors
2. **Use Console Commands**:
   ```tcl
   # Restart simulation
   restart

   # Run for specific time
   run 1000ns

   # Add signals to wave
   add_wave /f00_cpu_tb/uut/debug_pc
   ```

3. **Inspect Internal Signals**:
   - Add register file outputs to waveform
   - Monitor ALU inputs/outputs
   - Check ISM state transitions

## 📊 **Performance Analysis**

### **Timing Analysis:**
```tcl
# After synthesis, check timing
report_timing_summary
report_clock_networks
```

### **Resource Usage:**
```tcl
# Check resource utilization
report_utilization -hierarchical
```

## 🎯 **Next Steps**

1. **Modify Test Program**: Edit `.coe` file with your F00 assembly
2. **Add More Instructions**: Test additional opcodes
3. **Hardware Deployment**: Program FPGA board with generated bitstream
4. **Performance Optimization**: Analyze timing and optimize critical paths
5. **Add Peripherals**: Extend I/O system with additional memory-mapped devices

## 📚 **Additional Resources**

- **Vivado User Guides**: UG910 (Design Flows), UG835 (Simulation)
- **F00 CPU Reference**: `F00-CPU-Programmers-Reference.md`
- **JavaScript Simulator**: Use web IDE to develop and test programs
- **Xilinx Forums**: For specific IP core questions

## 🎉 **Success Indicators**

**✅ Simulation Working When:**
- No compilation errors
- Waveforms show state transitions
- PC increments through program addresses
- Instructions execute in correct sequence
- Debug outputs show expected values

**✅ Ready for Hardware When:**
- Synthesis completes without critical warnings
- Implementation meets timing constraints
- Bitstream generation succeeds
- Resource utilization is reasonable

**Congratulations! Your F00 CPU is running in Vivado! 🚀**