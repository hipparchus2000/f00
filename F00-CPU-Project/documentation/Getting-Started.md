# Getting Started with F00 CPU Development

This guide will get you up and running with F00 CPU development in minutes.

## Quick Setup

### 1. Open the Web IDE
1. Navigate to the `web-ide/` folder
2. Open `f00-web-ide.html` in any modern web browser
3. The IDE loads instantly - no installation required!

### 2. Load Your First Program
1. Click the **"Example"** button to load Hello World
2. Or copy this simple program:

```assembly
CODEORG 0
START:  LOADIMM R0,32767    ; UART address
        LOADIMM R1,72       ; 'H' 
        STORE R1,R0         ; Print it
        JUMPRIMM START      ; Loop
```

### 3. Assemble and Run
1. Click **"Assemble"** (or press Ctrl+B)
2. Check for success in the "Assembly Output" panel
3. Click **"Run"** (or press Ctrl+R)
4. Watch output appear in the "UART Output" terminal!

## Understanding the Interface

### Left Panel - Code Editor
- **Line numbers** for easy navigation
- **Syntax highlighting** for F00 assembly
- **Auto-save** your work with Ctrl+S

### Right Panel - CPU State
- **Registers** (R0-R31) with live updates
- **PC, Flags** (Carry, Zero, Supervisor)
- **Memory views** (ROM, RAM, Hex dump, Symbols)

### Bottom Panel - I/O
- **UART Output** - see your program's output here
- **Assembly Messages** - assembler errors/success
- **Input** - send characters to your program

## Your First Programs

### Example 1: Count to 10
```assembly
CODEORG 0
        LOADIMM R0,32767    ; UART address
        LOADIMM R1,0        ; Counter
        LOADIMM R2,10       ; Limit
LOOP:   LOADIMM R3,48       ; ASCII '0'
        ADD R1,R3           ; R3 = R1 + R3 = counter + '0'
        STORE R3,R0         ; Print digit
        LOADIMM R3,32       ; Space
        STORE R3,R0
        LOADIMM R3,1        ; Increment
        ADD R1,R3           ; R3 = R1 + R3 = counter + 1  
        MOVE R3,R1          ; R1 = R3 (update counter)
        SUB R2,R1           ; R1 = R2 - R1 = limit - counter
        JUMPRIMMZ DONE      ; If zero, we're done
        SUB R2,R1           ; Restore R1 = R2 - R1 = counter
        JUMPRIMM LOOP
DONE:   JUMPRIMM DONE       ; Halt
```

### Example 2: Echo Program  
```assembly
CODEORG 0
        LOADIMM R0,32767    ; UART address
ECHO:   LOAD R0,R1         ; Read character
        STORE R1,R0        ; Echo it back
        JUMPRIMM ECHO      ; Repeat forever
```

## F00 Assembly Basics

### Instruction Format
```assembly
[LABEL:] INSTRUCTION [operand1], [operand2]  ; comment
```

### Key Instructions
- **LOADIMM Ra,#value** - Load constant into register
- **MOVE Ra,Rb** - Copy Ra to Rb  
- **LOAD Ra,Rb** - Load from memory[Ra] into Rb
- **STORE Ra,Rb** - Store Ra to memory[Rb]
- **ADD/SUB Ra,Rb** - Rb = Ra +/- Rb
- **JUMPRIMM #offset** - Jump relative by offset

### Memory Layout
- **0x0000-0x7FFE**: Program memory (ROM)
- **0x7FFF**: UART I/O (memory-mapped)  
- **0x8000-0xFFFF**: Data memory (RAM)

## Debugging Tips

### Use Single-Step Mode
1. Assemble your program
2. Click **"Step"** (or Ctrl+Shift+S) to execute one instruction
3. Watch registers change in real-time
4. Check the PC (Program Counter) to see where you are

### Monitor Memory
1. Click the **"Memory View"** tab
2. See your program in hex dump format
3. Watch for the **green highlight** showing current PC location

### Common Issues
- **Forgot CODEORG 0?** - Program starts at wrong address
- **Infinite loop?** - Use Step mode to trace execution  
- **No output?** - Check you're writing to address 32767 (0x7FFF)
- **Assembly errors?** - Check syntax and register names (R0-R31)

## Advanced Features

### File Management
- **Save**: Ctrl+S downloads your program
- **Load**: Ctrl+O opens local .f00 files
- **Filename**: Edit in the toolbar

### Memory Analysis
- **ROM tab**: See your assembled program
- **RAM tab**: Watch data memory changes
- **Symbols tab**: View all labels and addresses

### Performance Monitoring
- **Cycle count**: Shows in status during execution
- **Register highlighting**: Changed registers flash green
- **PC tracking**: Current instruction highlighted in memory

## Next Steps

1. **Try the examples** in the `examples/` folder
2. **Read the [Programmer's Reference](F00-CPU-Programmers-Reference.md)** for complete instruction set
3. **Experiment** with different algorithms and programs
4. **Share your programs** - save and distribute .f00 files

## Help & Resources

- **F5 key**: Reset simulator  
- **Status bar**: Shows keyboard shortcuts
- **UART terminal**: Scrolls automatically
- **Error messages**: Appear in Assembly Output panel

**Happy coding on the F00 CPU!** 🚀