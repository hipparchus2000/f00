# F00 CPU - Online Simulation Guide

This guide shows you how to run the F00 CPU online using free web-based VHDL simulators.

## 🌐 **Option 1: EDA Playground (RECOMMENDED)**

**URL**: https://www.edaplayground.com
**Cost**: Free with registration
**Capability**: Full VHDL simulation with waveform viewer

### **Step-by-Step Instructions:**

#### **1. Access EDA Playground**
1. Go to https://www.edaplayground.com
2. **Sign Up** for free account (Google/LinkedIn login available)
3. Click **"New Playground"**

#### **2. Configure Simulator**
- **Testbench + Design**: Select this option
- **Language**: VHDL
- **Simulator**: **ModelSim** (recommended) or **GHDL**
- **Options**: Check "Open EPWave after run"

#### **3. Add F00 CPU Files**

**In the "design.vhd" tab, paste:**
```vhdl
-- Copy the entire contents of f00_cpu_behavioral.vhd here
-- (The file is in the online/ folder)
```

**In the "testbench.vhd" tab, paste:**
```vhdl
-- Copy the entire contents of f00_cpu_online_tb.vhd here
-- (The file is in the online/ folder)
```

#### **4. Run Simulation**
1. Click **"Run"** button (▶️)
2. Wait for compilation (30-60 seconds)
3. **Waveform viewer** will open automatically
4. **Console output** shows instruction execution

#### **5. Analyze Results**

**Expected Console Output:**
```
=== F00 CPU Online Test Started ===
PC=0000 State=01 R1=0000 R2=0000 Flags=000
PC=0000 State=10 R1=0000 R2=0000 Flags=000
PC=0000 State=11 R1=1234 R2=0000 Flags=000
PC=0002 State=01 R1=1234 R2=0000 Flags=000
PC=0002 State=10 R1=1234 R2=5678 Flags=000
PC=0004 State=11 R1=1234 R2=68AC Flags=000
=== Expected Results ===
  R1 should contain 0x1234
  R2 should contain 0x68AC (0x1234 + 0x5678)
```

**Waveform Analysis:**
- **debug_pc**: Should increment through 0→2→4→5→6→0 (program loop)
- **debug_state**: Should show state machine transitions (01→10→11→00)
- **debug_reg1/reg2**: Should show register value changes
- **debug_flags**: Should show carry/zero flags during ADD operation

## 🌐 **Option 2: Online VHDL IDEs**

### **HDLBits (Limited VHDL)**
- **URL**: https://hdlbits.01xz.net/
- **Note**: Primarily Verilog, limited VHDL support
- **Use**: For basic logic verification only

### **CircuitVerse (Visual)**
- **URL**: https://circuitverse.org/
- **Type**: Visual circuit simulator
- **Use**: Can implement F00 CPU as visual logic blocks
- **Limitation**: Manual construction required

### **FPGA4Student Online Tools**
- **URL**: Various university-hosted online labs
- **Access**: Usually requires student account
- **Capability**: Full VHDL simulation

## 📱 **Option 3: Cloud-Based Professional Tools**

### **Xilinx Vivado WebPACK (Cloud)**
```bash
# AWS EC2 instance with Vivado
# Requires AWS account, costs ~$0.10-1.00/hour
# Full Vivado functionality including Xilinx IP
```

### **Intel Quartus Cloud**
```bash
# Intel/Altera cloud platform
# Free tier available for small designs
# Good for educational use
```

## 🎮 **Quick Demo - Copy & Paste Ready**

### **For EDA Playground - Complete Setup:**

**File 1: design.vhd** (Copy from `f00_cpu_behavioral.vhd`)
**File 2: testbench.vhd** (Copy from `f00_cpu_online_tb.vhd`)

**Settings:**
- Language: VHDL
- Simulator: ModelSim
- Options: ✅ Open EPWave after run

**Click Run → View waveforms → Success! 🎉**

## 🔧 **Customizing the Online Version**

### **Modify Test Program:**
Edit the `imem` array in `f00_cpu_behavioral.vhd`:

```vhdl
signal imem : imem_t := (
    0  => x"4110",  -- LOADIMM R1, next_word
    1  => x"ABCD",  -- Your immediate value
    2  => x"4120",  -- LOADIMM R2, next_word
    3  => x"EFEF",  -- Your immediate value
    4  => x"8B04",  -- ADD R1, R2
    5  => x"8594",  -- JUMPABS R20 (loop back)
    others => x"0000"
);
```

### **Add More Instructions:**
Extend the `case opcode is` statement in the EXECUTE state:

```vhdl
when "001100" => -- SUB (opcode 12)
    reg_addr_a <= std_logic_vector(operand1);
    reg_addr_b <= std_logic_vector(operand2);
    alu_op <= "001";  -- SUB
    reg_data_in <= alu_result;
    reg_we <= '1';
    pc <= pc + 1;
```

### **Add More Debug Outputs:**
```vhdl
-- In entity declaration:
debug_instruction : out std_logic_vector(15 downto 0);

-- In architecture:
debug_instruction <= instruction;
```

## 📊 **Performance Comparison**

| Platform | Compilation Time | Simulation Speed | Waveform Viewer | Cost |
|----------|------------------|------------------|-----------------|------|
| **EDA Playground** | ~60 seconds | Medium | ✅ Excellent | Free |
| **Local Vivado** | ~30 seconds | Fast | ✅ Professional | Free |
| **Cloud Vivado** | ~45 seconds | Fast | ✅ Professional | ~$0.50/hour |
| **University Labs** | ~30 seconds | Fast | ✅ Full featured | Free* |

## 🐛 **Troubleshooting Online Simulation**

### **Common Issues:**

**Compilation Errors:**
```vhdl
-- Check VHDL-2008 constructs
-- Ensure all entities/architectures are properly closed
-- Verify signal declarations
```

**No Waveforms:**
```bash
# Make sure "Open EPWave after run" is checked
# Simulation might need longer run time
# Check console for error messages
```

**Unexpected Behavior:**
```vhdl
-- Add more report statements for debugging
-- Check instruction encoding matches expected values
-- Verify reset behavior (reset_n = '0' then '1')
```

**Timeout/Resource Limits:**
```bash
# Simplify test program
# Reduce simulation time
# Remove unnecessary debug outputs
```

## 🎯 **Online vs. Local Comparison**

### **Online Advantages:**
✅ No installation required
✅ Works on any device with browser
✅ Shareable links for collaboration
✅ Always up-to-date simulator versions
✅ Cross-platform compatibility

### **Online Limitations:**
❌ No Xilinx IP cores
❌ Limited simulation time
❌ Smaller design capacity
❌ Internet connection required
❌ Less debugging features

### **When to Use Online:**
- **Learning VHDL** and basic CPU concepts
- **Algorithm verification** before full implementation
- **Quick prototyping** and sharing designs
- **Educational demonstrations**
- **No local tools** available

### **When to Use Local Vivado:**
- **Full F00 CPU implementation** with IP cores
- **FPGA synthesis** and deployment
- **Performance optimization**
- **Large, complex designs**
- **Professional development**

## 🚀 **Getting Started Now**

**Immediate Steps:**
1. **Go to https://www.edaplayground.com**
2. **Create free account**
3. **Copy the two .vhd files** from the online/ folder
4. **Paste into EDA Playground**
5. **Click Run**
6. **Watch your F00 CPU execute instructions! 🎉**

**Next Steps:**
1. **Modify the test program** with your own instructions
2. **Add more debug outputs** to understand CPU behavior
3. **Experiment with different opcodes**
4. **Compare results** with JavaScript simulator
5. **Graduate to local Vivado** when ready for full implementation

## 📚 **Educational Value**

**Perfect for:**
- **Students** learning CPU architecture
- **Engineers** prototyping processor designs
- **Educators** demonstrating computer architecture
- **Hobbyists** exploring FPGA development
- **Teams** collaborating on processor designs

**Learning Outcomes:**
- Understanding CPU state machines
- VHDL simulation and debugging
- Instruction execution cycles
- Register file and ALU operations
- Memory and I/O concepts

**Ready to run your F00 CPU in the cloud? Let's go! ☁️🚀**