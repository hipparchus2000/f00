# F00 CPU Web IDE

A complete web-based Integrated Development Environment for the F00 CPU, featuring assembler, simulator, and debugger all in a single HTML file.

## Features

### 🔧 **Complete F00 Assembler**
- **Full Instruction Set Support**: All F00 instructions implemented
- **Symbol Resolution**: Labels and constants with forward references
- **Multiple Number Formats**: Decimal, hexadecimal (0x), binary (0b)
- **Pseudo-Instructions**: `CODEORG`, `DATAORG`, `WORD`
- **Error Reporting**: Detailed error messages with line numbers
- **Two-Pass Assembly**: Proper symbol resolution and code generation

### 🖥️ **Cycle-Accurate Simulator** 
- **Full CPU State**: 32 registers, PC, status flags, memory
- **Harvard Architecture**: Separate ROM/RAM spaces (64KB each)
- **Memory-Mapped I/O**: Virtual UART at address 32767
- **Interactive Execution**: Run, step, or reset at any time
- **Visual Debugging**: Register highlighting, PC tracking

### 🎨 **Modern IDE Interface**
- **Split-Panel Layout**: Code editor on left, simulator on right
- **Syntax Highlighting**: F00 assembly with line numbers
- **Multiple Views**: ROM, RAM, and symbol tables
- **Real-Time Updates**: Live register and memory display
- **Console I/O**: Interactive input/output terminal

### ⚡ **Performance & Usability**
- **Single File**: Entire IDE in one self-contained HTML file
- **No Dependencies**: Pure JavaScript, works offline
- **Responsive Design**: Adapts to different screen sizes
- **Keyboard Shortcuts**: Ctrl+B (assemble), Ctrl+R (run), Ctrl+S (step)

## F00 CPU Architecture

The F00 is a 16-bit Harvard architecture CPU designed for embedded applications:

- **16-bit data/address buses**
- **32 general-purpose registers** (R0-R31)
- **Harvard architecture** (separate code/data memory)
- **Memory-mapped I/O** with virtual UART
- **Status flags**: Carry, Zero, Supervisor
- **Interrupt support** with supervisor mode

## Instruction Set

### Data Movement
- `MOVE Ra,Rb` - Copy register Ra to Rb
- `LOAD Ra,Rb` - Load from memory[Ra] into Rb  
- `STORE Ra,Rb` - Store Ra into memory[Rb]
- `LOADIMM Ra,#imm` - Load immediate value into Ra

### Arithmetic
- `ADD Ra,Rb` - Rb = Ra + Rb
- `SUB Ra,Rb` - Rb = Ra - Rb

### Logical
- `AND Ra,Rb` - Rb = Ra & Rb
- `OR Ra,Rb` - Rb = Ra | Rb  
- `NOT Ra,Rb` - Rb = ~Ra

### Bit Manipulation
- `SHIFTL Ra,Rb` - Rb = Ra << 1
- `SHIFTR Ra,Rb` - Rb = Ra >> 1

### Control Flow
- `JUMPABS Ra` - Jump to address in Ra
- `JUMPREL Ra` - Jump relative by Ra
- `JUMPRIMM #imm` - Jump relative by immediate
- `JUMPRIMMC #imm` - Jump relative if carry flag set
- `JUMPRIMMZ #imm` - Jump relative if zero flag set

### System
- `SYSCALL` - System call (supervisor mode)

## Assembly Language Syntax

```assembly
; Comments start with semicolon
label:  INSTRUCTION operand1, operand2

; Pseudo-instructions
CODEORG 0x0000    ; Set code origin
DATAORG 0x1000    ; Set data origin  
DATA1: WORD 0x1234 ; Define data word

; Number formats
LOADIMM R0, 100    ; Decimal
LOADIMM R1, 0xFF   ; Hexadecimal
LOADIMM R2, 0b1010 ; Binary

; Register names
R0, R1, ..., R31   ; General purpose registers
```

## Example Programs

### Hello World
```assembly
CODEORG 0
RESET:  LOADIMM R0,32767    ; UART address
        LOADIMM R1,72       ; 'H'
        STORE R1,R0         ; Print character
        ; ... continue with other characters
        JUMPRIMM RESET      ; Loop
```

### Memory Test
```assembly
CODEORG 0
START:  LOADIMM R0,1000     ; Test address
        LOADIMM R1,0x1234   ; Test data
        STORE R1,R0         ; Write to memory
        LOAD R0,R2          ; Read back
        SUB R1,R2           ; Compare
        JUMPRIMMZ SUCCESS   ; Branch if equal
```

## Using the IDE

### 1. **Writing Code**
- Enter F00 assembly code in the left editor panel
- Code is automatically syntax-highlighted
- Line numbers are displayed for reference

### 2. **Assembling**
- Click "Assemble" or press Ctrl+B
- Check output panel for errors or success message
- Successfully assembled code is loaded into simulator

### 3. **Running Programs**
- Click "Run" or press Ctrl+R for continuous execution
- Click "Step" or press Ctrl+S for single-step debugging
- Click "Reset" to restart from beginning

### 4. **Monitoring Execution**
- **CPU State**: View PC, flags, and all registers
- **Memory Views**: Examine ROM, RAM, and symbol tables
- **Console**: See program output and provide input

### 5. **Debugging Features**
- **Register Highlighting**: Changed registers are highlighted
- **PC Tracking**: Current instruction highlighted in memory
- **Symbol Table**: View all labels and their addresses
- **Disassembly**: Instructions shown in memory view

## Technical Implementation

### Assembler Architecture
```javascript
class F00Assembler {
    // Two-pass assembler with symbol resolution
    // Pass 1: Collect symbols and labels
    // Pass 2: Generate machine code
}
```

### Simulator Architecture  
```javascript
class F00Simulator {
    // Cycle-accurate simulation
    // Harvard architecture with separate ROM/RAM
    // Memory-mapped I/O with virtual UART
}
```

### Instruction Encoding
The F00 uses variable instruction formats:

- **Format 11** (No operands): `11 OOOOOO XXXXXXXXXX`
- **Format 10** (Register): `10 OOOOOO RRRRR RRRRR`  
- **Format 01** (Immediate): `01 OOOOOO RRRRR XXXXX` + immediate word
- **Format 00** (Short immediate): `00 OOOOOO IIIIIIIIII`

Where:
- `O` = Opcode bits
- `R` = Register address bits  
- `I` = Immediate value bits
- `X` = Unused bits

## Browser Compatibility

- **Chrome/Chromium**: Full support
- **Firefox**: Full support
- **Safari**: Full support  
- **Edge**: Full support
- **Mobile browsers**: Responsive design works on tablets

## File Structure

```
f00-web-ide.html           # Complete IDE (single file)
f00-examples/
├── fibonacci.f00          # Fibonacci sequence generator
├── memory-test.f00        # Memory operations test
└── arithmetic-test.f00    # Arithmetic operations test
```

## Keyboard Shortcuts

- **Ctrl+B**: Assemble code
- **Ctrl+R**: Run program
- **Ctrl+S**: Step one instruction
- **F5**: Reset simulator
- **Ctrl+L**: Load example program

## Memory Map

| Address Range | Contents |
|---------------|----------|
| 0x0000-0x7FFF | ROM (32KB) - Program code |
| 0x7FFF        | Virtual UART I/O |
| 0x8000-0xFFFF | RAM (32KB) - Data storage |

## Status Flags

- **Carry (C)**: Set on arithmetic overflow
- **Zero (Z)**: Set when result is zero  
- **Supervisor (S)**: CPU privilege mode

## Future Enhancements

- [ ] Breakpoint support
- [ ] Memory watch windows
- [ ] Assembly syntax highlighting improvements
- [ ] Export/import functionality
- [ ] Performance profiling
- [ ] Multi-file project support

## License

This F00 Web IDE is provided as-is for educational and development purposes. Based on the original F00 CPU design by Jeff Davies.

## Credits

- **Original F00 CPU Design**: Jeff Davies (1999)
- **Web IDE Implementation**: Translated from original C assembler/simulator
- **UI Design**: Modern dark theme inspired by VS Code

---

**Ready to start coding?** Open `f00-web-ide.html` in any modern web browser and begin developing for the F00 CPU!