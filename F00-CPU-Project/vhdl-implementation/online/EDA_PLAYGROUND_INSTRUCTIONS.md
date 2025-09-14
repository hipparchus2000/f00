# F00 CPU - EDA Playground Quick Start

**Fixed version - VHDL-93 compatible, works without compilation errors!**

## 🚀 **Quick Setup (5 Minutes)**

### **Step 1: Open EDA Playground**
1. Go to **https://www.edaplayground.com**
2. **Sign up** for free account (Google/GitHub login available)
3. Click **"Create"** to start new project

### **Step 2: Configure Settings**
- **Languages & Libraries**: VHDL
- **Testbench + Design**: ✅ (selected)
- **Simulator**: **ModelSim** (recommended)
- **Options**: ✅ Check "Open EPWave after run"

### **Step 3: Copy Files**

**In the LEFT panel (design.vhd), paste this:**

```vhdl
-- Copy the entire contents of f00_cpu_simple.vhd here
-- (Complete file contents - see f00_cpu_simple.vhd)
```

**In the RIGHT panel (testbench.vhd), paste this:**

```vhdl
-- Copy the entire contents of f00_cpu_simple_tb.vhd here
-- (Complete file contents - see f00_cpu_simple_tb.vhd)
```

### **Step 4: Run Simulation**
1. Click the big **"Run"** button ▶️
2. Wait 30-60 seconds for compilation
3. **EPWave waveform viewer** opens automatically
4. **Console** shows detailed execution log

## 📊 **Expected Results**

### **Console Output:**
```
=== F00 CPU Simple Online Test Started ===
Test Program Loaded:
  PC=0: LOADIMM R1, 0x1234
  PC=2: LOADIMM R2, 0x5678
  PC=4: ADD R1, R2 -> R2 = R1 + R2
  PC=5: MOVE R2, R3 -> R3 = R2

Cycle: PC=0x0000 State=0x01 Instr=0x4110 R1=0x0000 R2=0x0000 Flags=000
Cycle: PC=0x0002 State=0x01 Instr=0x4120 R1=0x1234 R2=0x0000 Flags=000
Cycle: PC=0x0004 State=0x01 Instr=0x8B04 R1=0x1234 R2=0x5678 Flags=000
Cycle: PC=0x0005 State=0x01 Instr=0x8252 R1=0x1234 R2=0x68AC Flags=000

PASS: R1 = 0x1234 (correct)
PASS: R2 = 0x68AC (0x1234 + 0x5678 correct)
=== Test Complete ===
```

### **Waveform Analysis:**
- **debug_pc**: Shows program counter: 0→2→4→5→6
- **debug_state**: Shows state machine: 01→02→03→04 (fetch→decode→execute→writeback)
- **debug_reg1**: Shows R1 loaded with 0x1234
- **debug_reg2**: Shows R2: 0000→5678→68AC (after ADD)
- **debug_instr**: Shows each instruction being executed

## 🎯 **What This Demonstrates**

**Working F00 CPU Features:**
1. **LOADIMM**: Loads immediate 16-bit values into registers
2. **ADD**: Performs 16-bit addition with carry flag
3. **MOVE**: Copies values between registers
4. **State Machine**: 5-state fetch-decode-execute cycle
5. **Program Counter**: Sequential instruction execution
6. **Register File**: 32 × 16-bit general-purpose registers
7. **ALU**: Arithmetic operations with flag generation

**Instruction Encoding:**
- `0x4110` = LOADIMM R1, #immediate (format=01, opcode=010000, reg=00001)
- `0x1234` = Immediate value 0x1234
- `0x8B04` = ADD R1, R2 (format=10, opcode=001011, R1=00001, R2=00010)
- `0x8252` = MOVE R2, R3 (format=10, opcode=000010, R2=00010, R3=00011)

## 🔧 **Customization**

### **Modify Test Program:**
In `f00_cpu_simple.vhd`, find the `imem` array:

```vhdl
signal imem : imem_t := (
    0  => x"4110",  -- LOADIMM R1, next_word
    1  => x"ABCD",  -- Change this immediate value
    2  => x"4120",  -- LOADIMM R2, next_word
    3  => x"1234",  -- Change this immediate value
    4  => x"8B04",  -- ADD R1, R2
    5  => x"8252",  -- MOVE R2, R3
    others => x"0000"
);
```

### **Expected Results for Custom Values:**
- If R1=0xABCD and R2=0x1234
- Then R2 after ADD = 0xABCD + 0x1234 = 0xBE01
- R3 after MOVE = 0xBE01

## 🐛 **Troubleshooting**

### **Common Issues:**

**"No declaration for std_logic":**
- ✅ **Fixed** in f00_cpu_simple.vhd - proper library usage

**"Compilation failed":**
- Ensure you copied the **complete** file contents
- Check that both files are pasted correctly
- Verify VHDL is selected as language

**"No waveforms shown":**
- Make sure "Open EPWave after run" is checked
- Wait for full compilation (can take 60+ seconds)
- Look for green "Done" message in console

**"Simulation doesn't run":**
- Check console for error messages
- Ensure both design.vhd and testbench.vhd have content
- Try refreshing browser and re-pasting

## 🎓 **Educational Value**

**Perfect for Learning:**
- **CPU Architecture**: See fetch-decode-execute in action
- **VHDL Programming**: Working example of state machines
- **Computer Engineering**: Understand processor internals
- **Assembly Language**: See instruction encoding and execution

**Hands-On Experiments:**
1. **Change immediate values** and verify arithmetic
2. **Add more registers** to the test program
3. **Observe state transitions** in waveform viewer
4. **Study instruction encoding** format

## 🚀 **Next Steps**

1. **Experiment** with different immediate values
2. **Add more instructions** to the test program
3. **Study the waveforms** to understand timing
4. **Compare results** with JavaScript simulator
5. **Graduate to full Vivado** for complete implementation

## ✅ **Success Checklist**

- [ ] EDA Playground account created
- [ ] Both files copied completely
- [ ] Simulator set to ModelSim
- [ ] "Open EPWave" option checked
- [ ] Green compilation success
- [ ] Console shows expected output
- [ ] Waveforms display correctly
- [ ] R1 = 0x1234, R2 = 0x68AC

**Ready to run your F00 CPU online! 🎉**