# F00 CPU Programmer's Reference Guide

**Version 0.04 - Web IDE Edition**  
*Based on the original F00 CPU design by Jeff Davies (1999)*

---

## Table of Contents

1. [CPU Overview](#cpu-overview)
2. [Architecture](#architecture)  
3. [Register Set](#register-set)
4. [Memory Organization](#memory-organization)
5. [Instruction Formats](#instruction-formats)
6. [Instruction Set Reference](#instruction-set-reference)
7. [Addressing Modes](#addressing-modes)
8. [Status Flags](#status-flags)
9. [Interrupts and Exceptions](#interrupts-and-exceptions)
10. [Memory-Mapped I/O](#memory-mapped-io)
11. [Assembly Language Syntax](#assembly-language-syntax)
12. [Programming Examples](#programming-examples)
13. [Performance Characteristics](#performance-characteristics)
14. [Hardware Implementation Notes](#hardware-implementation-notes)

---

## CPU Overview

The F00 is a 16-bit embedded CPU with Harvard architecture designed for FPGA implementation. It features a RISC-like instruction set optimized for simplicity and performance in embedded applications.

### Key Specifications
- **Architecture**: 16-bit Harvard (separate instruction/data buses)
- **Word Size**: 16 bits
- **Address Space**: 64KB instruction, 64KB data
- **Registers**: 32 general-purpose registers
- **Instruction Length**: 16 bits (some instructions use additional immediate word)
- **Endianness**: Little-endian for multi-byte values
- **Target Applications**: Embedded systems, consumer electronics, multimedia controllers

### Design Philosophy
- Minimize gate count for FPGA implementation (~13,000 gates target)
- Maximize register count for efficient code generation
- Simple, orthogonal instruction set
- Support for real-time applications without virtual memory overhead

---

## Architecture

```
                F00 CPU Block Diagram
    
    ┌─────────────┐    ┌──────────────┐    ┌─────────────┐
    │   Program   │    │              │    │    Data     │
    │   Memory    │◄───┤ Instruction  ├───►│   Memory    │
    │   (64KB)    │    │    Fetch     │    │   (64KB)    │
    └─────────────┘    │              │    └─────────────┘
                       └──────┬───────┘
                              │
                    ┌─────────▼──────────┐
                    │   Instruction      │
                    │     Decoder        │
                    └─────────┬──────────┘
                              │
    ┌─────────────┐    ┌──────▼───────┐    ┌─────────────┐
    │   Register  │◄───┤   Control    ├───►│     ALU     │
    │    File     │    │     Unit     │    │  (16-bit)   │
    │  (32 × 16)  │    │              │    └─────────────┘
    └─────────────┘    └──────────────┘
                              │
                    ┌─────────▼──────────┐
                    │  Memory Management │
                    │   Unit (MMU)       │
                    └────────────────────┘
```

### Pipeline
The F00 uses a simple 3-stage pipeline:
1. **Fetch**: Retrieve instruction from program memory
2. **Decode**: Decode instruction and read registers  
3. **Execute**: Perform operation and write results

---

## Register Set

### General Purpose Registers
- **R0-R31**: 32 × 16-bit general-purpose registers
- **Usage**: All arithmetic, logical, and memory operations
- **Special Notes**: 
  - R0 has no special meaning (unlike some architectures)
  - All registers are equally capable
  - Registers are the fastest storage locations

### System Registers
- **PC**: 16-bit Program Counter
- **USR**: User Status Register
- **SR0-SR4**: Supervisor Registers (supervisor mode only)

#### User Status Register (USR) - 16 bits
```
Bit  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
    │  │  │  │  │  │  │  │  │  │  │  │  │  │  │ Z│ C│
    └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
     Reserved (always 0)                        │  │
                                                │  └─ Carry Flag
                                                └──── Zero Flag
```

#### Supervisor Status Register (SR0) - 16 bits
```
Bit  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
    │  │  │  │  │  │  │  │  │  │  │  │ S│SI│IE│ F│IL│
    └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
     Reserved                           │ │ │ │ │
                                        │ │ │ │ └─ Illegal Instruction
                                        │ │ │ └─── Freeze (halt)
                                        │ │ └───── Interrupt Enable
                                        │ └─────── Software Interrupt
                                        └───────── Supervisor Mode
```

#### Supervisor Registers (SR1-SR4)
- **SR1**: Interrupt stack pointer (where PC is saved during interrupts)
- **SR2**: Interrupt vector address (where to jump on interrupt)
- **SR3**: MMU control address
- **SR4**: MMU data register

---

## Memory Organization

### Harvard Architecture
The F00 uses separate address spaces for instructions and data:

#### Program Memory Space (64KB)
```
Address Range │ Contents
──────────────┼─────────────────────────────────
0x0000-0x7FFE │ Program instructions
0x7FFF        │ Memory-mapped I/O (Virtual UART)
```

#### Data Memory Space (64KB)  
```
Address Range │ Contents
──────────────┼─────────────────────────────────
0x0000-0x7FFE │ Data storage (RAM)
0x7FFF        │ Memory-mapped I/O (Virtual UART)
0x8000-0xFFFF │ Extended data storage
```

### Memory Access Patterns
- **Instruction fetches**: Always from program memory space
- **LOAD/STORE operations**: Access data memory space
- **Immediate values**: Stored as additional instruction words in program space
- **Memory-mapped I/O**: Same address (0x7FFF) in both spaces

### Memory Management Unit (MMU)
- **Purpose**: Provides memory protection and virtual addressing
- **Size**: 512 entries (256 for code, 256 for data)
- **Page Size**: 256 bytes (64KB ÷ 256 pages)
- **Supervisor Mode**: MMU bypassed, direct physical addressing
- **User Mode**: All addresses translated through MMU

---

## Instruction Formats

The F00 uses four different instruction formats based on the top 2 bits:

### Format 00 - Short Immediate (Relative Jumps)
```
Bit  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
    │ 0│ 0│     Opcode    │        Immediate        │
    └──┴──┴───────────────┴─────────────────────────┘
          │               │
          └─ Format ID    └─ 10-bit signed immediate (-512 to +511)
```

### Format 01 - Register + Immediate (Next Word)
```
Word 1: ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
        │ 0│ 1│     Opcode    │   Register    │ Unused │
        └──┴──┴───────────────┴───────────────┴────────┘
        
Word 2: ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
        │               16-bit Immediate Value           │
        └─────────────────────────────────────────────────┘
```

### Format 10 - Register Operations  
```
Bit  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
    │ 1│ 0│     Opcode    │  Register A   │ Register B│
    └──┴──┴───────────────┴───────────────┴───────────┘
          │               │               │
          └─ Format ID    └─ Source Reg   └─ Dest Reg
```

### Format 11 - No Operands
```
Bit  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
    │ 1│ 1│     Opcode    │           Unused          │
    └──┴──┴───────────────┴───────────────────────────┘
          │
          └─ Format ID
```

---

## Instruction Set Reference

### Data Movement Instructions

#### MOVE - Move Register to Register
- **Format**: `MOVE Ra, Rb`
- **Encoding**: `10 000010 AAAAA BBBBB`
- **Operation**: `Rb ← Ra`
- **Flags**: None affected
- **Description**: Copies the contents of register Ra to register Rb
- **Example**: `MOVE R5, R10` ; Copy R5 to R10

#### LOAD - Load from Memory
- **Format**: `LOAD Ra, Rb`  
- **Encoding**: `10 000000 AAAAA BBBBB`
- **Operation**: `Rb ← Memory[Ra]`
- **Flags**: None affected
- **Description**: Loads a 16-bit word from data memory address in Ra into Rb
- **Example**: `LOAD R3, R7` ; Load from address in R3 into R7

#### STORE - Store to Memory
- **Format**: `STORE Ra, Rb`
- **Encoding**: `10 000001 AAAAA BBBBB`  
- **Operation**: `Memory[Rb] ← Ra`
- **Flags**: None affected
- **Description**: Stores the contents of Ra to data memory address in Rb
- **Example**: `STORE R8, R2` ; Store R8 to address in R2

#### LOADIMM - Load Immediate Value
- **Format**: `LOADIMM Ra, #immediate`
- **Encoding**: `01 010000 AAAAA 00000` + immediate word
- **Operation**: `Ra ← immediate`
- **Flags**: None affected  
- **Description**: Loads a 16-bit immediate value into register Ra
- **Example**: `LOADIMM R1, 0x1234` ; Load 0x1234 into R1

### Arithmetic Instructions

#### ADD - Addition
- **Format**: `ADD Ra, Rb`
- **Encoding**: `10 101011 AAAAA BBBBB`
- **Operation**: `Rb ← Ra + Rb`
- **Flags**: C (carry), Z (zero)
- **Description**: Adds Ra to Rb, storing result in Rb
- **Example**: `ADD R1, R2` ; R2 = R1 + R2

#### SUB - Subtraction  
- **Format**: `SUB Ra, Rb`
- **Encoding**: `10 101100 AAAAA BBBBB`
- **Operation**: `Rb ← Ra - Rb`  
- **Flags**: C (carry/borrow), Z (zero)
- **Description**: Subtracts Rb from Ra, storing result in Rb
- **Example**: `SUB R5, R3` ; R3 = R5 - R3

### Logical Instructions

#### AND - Bitwise AND
- **Format**: `AND Ra, Rb`
- **Encoding**: `10 100000 AAAAA BBBBB`
- **Operation**: `Rb ← Ra & Rb`
- **Flags**: Z (zero)
- **Description**: Performs bitwise AND of Ra and Rb, storing result in Rb
- **Example**: `AND R4, R6` ; R6 = R4 & R6

#### OR - Bitwise OR
- **Format**: `OR Ra, Rb`  
- **Encoding**: `10 100001 AAAAA BBBBB`
- **Operation**: `Rb ← Ra | Rb`
- **Flags**: Z (zero)
- **Description**: Performs bitwise OR of Ra and Rb, storing result in Rb
- **Example**: `OR R7, R9` ; R9 = R7 | R9

#### NOT - Bitwise NOT  
- **Format**: `NOT Ra, Rb`
- **Encoding**: `10 100010 AAAAA BBBBB`
- **Operation**: `Rb ← ~Ra`
- **Flags**: Z (zero)
- **Description**: Performs bitwise complement of Ra, storing result in Rb
- **Example**: `NOT R10, R11` ; R11 = ~R10

### Shift Instructions

#### SHIFTL - Shift Left
- **Format**: `SHIFTL Ra, Rb`
- **Encoding**: `10 100011 AAAAA BBBBB`
- **Operation**: `Rb ← Ra << 1`
- **Flags**: C (bit shifted out), Z (zero)
- **Description**: Shifts Ra left by one bit, storing result in Rb
- **Example**: `SHIFTL R1, R2` ; R2 = R1 << 1

#### SHIFTR - Shift Right
- **Format**: `SHIFTR Ra, Rb`
- **Encoding**: `10 100100 AAAAA BBBBB`  
- **Operation**: `Rb ← Ra >> 1`
- **Flags**: C (bit shifted out), Z (zero)
- **Description**: Shifts Ra right by one bit (logical), storing result in Rb
- **Example**: `SHIFTR R3, R4` ; R4 = R3 >> 1

#### ROTATEL - Rotate Left
- **Format**: `ROTATEL Ra, Rb`
- **Encoding**: `10 100101 AAAAA BBBBB`
- **Operation**: `Rb ← Ra rotated left 1 bit`
- **Flags**: C (bit rotated), Z (zero)
- **Description**: Rotates Ra left by one bit, storing result in Rb
- **Status**: *Not implemented in current simulator*

#### ROTATER - Rotate Right  
- **Format**: `ROTATER Ra, Rb`
- **Encoding**: `10 100110 AAAAA BBBBB`
- **Operation**: `Rb ← Ra rotated right 1 bit`
- **Flags**: C (bit rotated), Z (zero)  
- **Description**: Rotates Ra right by one bit, storing result in Rb
- **Status**: *Not implemented in current simulator*

#### SHIFTLC - Shift Left Through Carry
- **Format**: `SHIFTLC Ra, Rb`
- **Encoding**: `10 100111 AAAAA BBBBB`
- **Operation**: `Rb ← (Ra << 1) | C; C ← Ra[15]`
- **Flags**: C (bit shifted out), Z (zero)
- **Description**: Shifts Ra left through carry flag
- **Status**: *Not implemented in current simulator*

#### SHIFTRC - Shift Right Through Carry
- **Format**: `SHIFTRC Ra, Rb` 
- **Encoding**: `10 101000 AAAAA BBBBB`
- **Operation**: `Rb ← (C << 15) | (Ra >> 1); C ← Ra[0]`
- **Flags**: C (bit shifted out), Z (zero)
- **Description**: Shifts Ra right through carry flag  
- **Status**: *Not implemented in current simulator*

#### ROTATELC - Rotate Left Through Carry
- **Format**: `ROTATELC Ra, Rb`
- **Encoding**: `10 101001 AAAAA BBBBB`
- **Status**: *Not implemented in current simulator*

#### ROTATERC - Rotate Right Through Carry  
- **Format**: `ROTATERC Ra, Rb`
- **Encoding**: `10 101010 AAAAA BBBBB`
- **Status**: *Not implemented in current simulator*

### Control Flow Instructions

#### JUMPABS - Absolute Jump
- **Format**: `JUMPABS Ra`
- **Encoding**: `10 000101 AAAAA 00000`
- **Operation**: `PC ← Ra`
- **Flags**: None affected
- **Description**: Jumps to the address contained in register Ra
- **Example**: `JUMPABS R15` ; Jump to address in R15

#### JUMPREL - Relative Jump  
- **Format**: `JUMPREL Ra`
- **Encoding**: `10 000100 AAAAA 00000`
- **Operation**: `PC ← PC + Ra`
- **Flags**: None affected
- **Description**: Jumps relative by the offset in register Ra  
- **Example**: `JUMPREL R5` ; Jump forward/backward by R5 instructions

#### JUMPRIMM - Jump Relative Immediate
- **Format**: `JUMPRIMM #offset`
- **Encoding**: `00 000110 IIIIIIIIII`
- **Operation**: `PC ← PC + sign_extend(offset)`
- **Flags**: None affected
- **Description**: Jumps relative by signed 10-bit immediate offset (-512 to +511)
- **Example**: `JUMPRIMM -10` ; Jump back 10 instructions

#### JUMPRIMMC - Jump Relative on Carry  
- **Format**: `JUMPRIMMC #offset`
- **Encoding**: `00 000111 IIIIIIIIII`
- **Operation**: `if (C) PC ← PC + sign_extend(offset)`
- **Flags**: None affected
- **Description**: Conditional jump relative if carry flag is set
- **Example**: `JUMPRIMMC +5` ; Jump forward 5 if carry set

#### JUMPRIMMZ - Jump Relative on Zero
- **Format**: `JUMPRIMMZ #offset`  
- **Encoding**: `00 001000 IIIIIIIIII`
- **Operation**: `if (Z) PC ← PC + sign_extend(offset)`
- **Flags**: None affected
- **Description**: Conditional jump relative if zero flag is set
- **Example**: `JUMPRIMMZ LOOP` ; Jump to LOOP if zero flag set

#### JUMPRIMMO - Jump Relative on Overflow
- **Format**: `JUMPRIMMO #offset`
- **Encoding**: `00 001001 IIIIIIIIII`  
- **Operation**: `if (V) PC ← PC + sign_extend(offset)`
- **Flags**: None affected
- **Description**: Conditional jump relative if overflow flag is set
- **Status**: *Not implemented in current simulator*

### System Instructions

#### SYSCALL - System Call
- **Format**: `SYSCALL`
- **Encoding**: `11 110000 0000000000`
- **Operation**: Complex supervisor mode transition
- **Flags**: All supervisor flags affected
- **Description**: Triggers a system call, switching to supervisor mode
- **Side Effects**:
  - Sets supervisor mode bit
  - Sets software interrupt bit  
  - Saves PC to address in SR1
  - Jumps to address in SR2
  - Clears interrupt enable, freeze, and illegal instruction flags

#### SUPERSWAP - Supervisor Register Swap
- **Format**: `SUPERSWAP SRn, Rb`
- **Encoding**: `10 000011 nnnnn BBBBB` (where nnnnn encodes supervisor register)
- **Operation**: `temp = SRn; SRn = Rb; Rb = temp`
- **Flags**: None affected
- **Description**: Swaps supervisor register with user register (supervisor mode only)
- **Privilege**: Supervisor mode required
- **Example**: `SUPERSWAP SR1, R5` ; Swap SR1 with R5

---

## Addressing Modes

### 1. Register Direct  
- **Syntax**: `Ra, Rb`
- **Description**: Operands are register contents
- **Example**: `ADD R1, R2` uses contents of R1 and R2

### 2. Register Indirect
- **Syntax**: `(Ra)` in LOAD/STORE 
- **Description**: Register contains memory address
- **Example**: `LOAD R5, R6` loads from address in R5 to R6

### 3. Immediate
- **Syntax**: `#value` or `value`
- **Description**: Constant value encoded in instruction
- **Formats**: 
  - 10-bit signed immediate (-512 to +511) for jumps
  - 16-bit immediate (following word) for LOADIMM
- **Example**: `LOADIMM R1, 0x1234`

### 4. Label/Symbol
- **Syntax**: `LABEL`
- **Description**: Assembler resolves to address or offset
- **Example**: `JUMPRIMM LOOP` where LOOP is a label

---

## Status Flags

### Carry Flag (C) - Bit 0 of USR
**Set when**:
- Arithmetic operation produces carry out of bit 15
- Shift operation shifts a '1' out of the register
- Rotate operation rotates a bit through carry

**Used by**:
- `JUMPRIMMC` - conditional jump on carry set
- Shift/rotate operations with carry

**Example**:
```assembly
LOADIMM R1, 0xFFFF
LOADIMM R2, 1  
ADD R1, R2        ; R2 = 0x0000, C = 1 (carry out)
JUMPRIMMC OVERFLOW ; Jump if carry occurred
```

### Zero Flag (Z) - Bit 1 of USR  
**Set when**:
- Result of arithmetic/logical operation is zero
- Register value becomes zero after operation

**Used by**:
- `JUMPRIMMZ` - conditional jump on zero set
- Testing for equality (subtract and test zero)

**Example**:
```assembly
SUB R1, R2        ; R2 = R1 - R2  
JUMPRIMMZ EQUAL   ; Jump if R1 == R2 (result was zero)
```

### Flag Update Rules
- **Arithmetic instructions** (ADD, SUB): Update both C and Z
- **Logical instructions** (AND, OR, NOT): Update Z only
- **Shift instructions**: Update C (shifted bit) and Z  
- **Data movement**: No flags affected
- **Control flow**: No flags affected

---

## Interrupts and Exceptions

### Interrupt Processing
1. **Hardware interrupt signal** received
2. **Automatic state save**:
   - Current PC saved to memory address in SR1
   - Supervisor mode bit set (SR0 bit 4)
   - Interrupt enable cleared (SR0 bit 2)
3. **Vector jump**: PC loaded from SR2  
4. **Supervisor code** handles interrupt
5. **Return**: Jump instruction with user mode restore

### Exception Types
- **Illegal Instruction**: Unknown or privileged instruction in user mode
- **Software Interrupt**: SYSCALL instruction
- **Hardware Interrupt**: External interrupt signal

### Supervisor Mode
**Enabled when**:
- Reset (initial state)
- Interrupt or exception occurs
- SYSCALL instruction executed

**Special privileges**:
- MMU bypassed (direct physical memory access)
- Access to supervisor registers (SR0-SR4)
- Can execute SUPERSWAP instruction

**Return to user mode**:
- Jump instruction automatically restores user mode
- MMU re-enabled for address translation

---

## Memory-Mapped I/O

### Virtual UART - Address 0x7FFF

The F00 includes a simple memory-mapped UART interface at address 0x7FFF in both instruction and data spaces.

#### Output (Write to 0x7FFF)
```assembly
LOADIMM R0, 0x7FFF    ; UART address
LOADIMM R1, 65        ; ASCII 'A'
STORE R1, R0          ; Print character
```

#### Input (Read from 0x7FFF)  
```assembly
LOADIMM R0, 0x7FFF    ; UART address  
LOAD R0, R1           ; Read character into R1
```

**Characteristics**:
- **Output**: 8-bit character (lower byte of 16-bit word)
- **Input**: Blocking read, returns ASCII character
- **Buffering**: Implementation dependent
- **Flow Control**: None specified

### Extending I/O
Additional memory-mapped devices can be added:
- **Timer/Counter**: For real-time applications
- **GPIO Ports**: For external device control  
- **SPI/I2C**: For serial communications
- **Interrupt Controller**: For multiple interrupt sources

---

## Assembly Language Syntax

### Basic Syntax Rules
```assembly
[label:] instruction [operand1] [, operand2] [; comment]
```

### Labels
- **Format**: Alphanumeric + underscore, starting with letter
- **Case**: Sensitive  
- **Scope**: Global within source file
- **Usage**: Branch targets, data references

### Numbers
- **Decimal**: `123`, `-456`
- **Hexadecimal**: `0x1234`, `0xABCD`  
- **Binary**: `0b1010`, `0b11110000`
- **Character**: `'A'` (ASCII value)

### Registers
- **Format**: `R0` through `R31`
- **Case**: Insensitive (`r0` same as `R0`)

### Comments
- **Line comments**: `;` or `#` to end of line
- **Usage**: Document code purpose and algorithms

### Pseudo-Instructions
```assembly
CODEORG address    ; Set code origin  
DATAORG address    ; Set data origin
label: WORD value  ; Define 16-bit data word
```

### Example Program Structure
```assembly
; Program header comment
CODEORG 0x0000

START:  LOADIMM R0, UART_ADDR
        LOADIMM R1, HELLO_MSG
        JUMPRIMM PRINT_STRING
        
UART_ADDR: WORD 0x7FFF
HELLO_MSG: WORD 0x48    ; 'H'
           WORD 0x65    ; 'e'
           WORD 0x00    ; null terminator
```

---

## Programming Examples

### Example 1: Hello World
```assembly
; Print "Hello World" to UART
CODEORG 0

HELLO:  LOADIMM R0, 0x7FFF    ; UART address
        LOADIMM R1, 72        ; 'H'
        STORE R1, R0
        LOADIMM R1, 101       ; 'e'
        STORE R1, R0
        LOADIMM R1, 108       ; 'l' 
        STORE R1, R0
        LOADIMM R1, 108       ; 'l'
        STORE R1, R0
        LOADIMM R1, 111       ; 'o'
        STORE R1, R0
        LOADIMM R1, 32        ; ' '
        STORE R1, R0
        LOADIMM R1, 87        ; 'W'
        STORE R1, R0
        LOADIMM R1, 111       ; 'o'
        STORE R1, R0
        LOADIMM R1, 114       ; 'r'
        STORE R1, R0
        LOADIMM R1, 108       ; 'l'
        STORE R1, R0
        LOADIMM R1, 100       ; 'd'
        STORE R1, R0
        LOADIMM R1, 10        ; '\n'
        STORE R1, R0
        
DONE:   JUMPRIMM DONE         ; Infinite loop
```

### Example 2: String Output Function
```assembly
; Print null-terminated string
; Entry: R1 = string address, R0 = UART address
; Uses: R1 (string pointer), R2 (character), R3 (temp)

PRINT_STRING:
        LOAD R1, R2           ; Load character
        MOVE R2, R3           ; Copy to test register  
        JUMPRIMMZ PRINT_DONE  ; Exit if null terminator
        STORE R2, R0          ; Print character
        LOADIMM R3, 1         ; Increment value
        ADD R1, R3            ; R3 = R1 + R3
        MOVE R3, R1           ; R1 = R3 (increment pointer)
        JUMPRIMM PRINT_STRING ; Continue loop
        
PRINT_DONE:
        JUMPABS R31           ; Return (assuming R31 = return address)
```

### Example 3: 16-bit Multiplication  
```assembly
; Multiply R1 × R2 → R3 (16×16=16, no overflow check)
; Uses shift-and-add algorithm

MULTIPLY:
        LOADIMM R3, 0         ; Result = 0
        LOADIMM R4, 0         ; Counter = 0  
        LOADIMM R5, 16        ; Loop limit
        
MULT_LOOP:
        ; Test if multiplier bit is set
        LOADIMM R6, 1
        AND R2, R6            ; R6 = R2 & 1
        JUMPRIMMZ MULT_SKIP   ; Skip if bit is 0
        
        ; Add multiplicand to result
        ADD R1, R3            ; R3 = R1 + R3
        
MULT_SKIP:
        ; Shift multiplicand left, multiplier right
        SHIFTL R1, R1         ; R1 = R1 << 1
        SHIFTR R2, R2         ; R2 = R2 >> 1
        
        ; Increment counter and test
        LOADIMM R6, 1
        ADD R4, R6            ; R6 = R4 + R6  
        MOVE R6, R4           ; R4 = R6
        SUB R5, R4            ; R4 = R5 - R4
        MOVE R4, R7           ; R7 = R4 (remaining count)
        JUMPRIMMZ MULT_DONE   ; Exit if done
        
        ; Restore R4 and continue  
        SUB R5, R7            ; R7 = R5 - R7 = original R4
        MOVE R7, R4           ; R4 = R7
        JUMPRIMM MULT_LOOP
        
MULT_DONE:
        ; Result in R3
        JUMPABS R31           ; Return
```

### Example 4: Memory Copy Function
```assembly  
; Copy memory block  
; Entry: R1 = source, R2 = dest, R3 = count
; Uses: R4 (data), R5 (temp)

MEMCOPY:
        ; Test if count is zero
        MOVE R3, R5
        JUMPRIMMZ COPY_DONE
        
COPY_LOOP:
        LOAD R1, R4           ; Load from source
        STORE R4, R2          ; Store to destination
        
        ; Increment pointers
        LOADIMM R5, 1
        ADD R1, R5            ; R5 = R1 + R5  
        MOVE R5, R1           ; R1 = R5
        ADD R2, R5            ; R5 = R2 + R5
        MOVE R5, R2           ; R2 = R5
        
        ; Decrement count
        LOADIMM R5, 1
        SUB R3, R5            ; R5 = R3 - R5
        MOVE R5, R3           ; R3 = R5
        JUMPRIMMZ COPY_DONE   ; Exit if zero
        
        JUMPRIMM COPY_LOOP    ; Continue
        
COPY_DONE:
        JUMPABS R31           ; Return
```

### Example 5: Interrupt Service Routine
```assembly
; Simple interrupt handler
; Assumption: SR1 points to interrupt stack
; Assumption: SR2 points to this routine

ISR_ENTRY:
        ; Save working registers to stack  
        SUPERSWAP SR1, R29    ; Get stack pointer
        STORE R1, R29         ; Save R1
        LOADIMM R1, 1
        ADD R29, R1           ; Increment stack pointer
        MOVE R1, R29
        SUPERSWAP SR1, R29    ; Update stack pointer
        
        ; Handle interrupt (example: echo UART input)
        LOADIMM R0, 0x7FFF    ; UART address
        LOAD R0, R1           ; Read input character  
        STORE R1, R0          ; Echo it back
        
        ; Restore registers
        SUPERSWAP SR1, R29    ; Get stack pointer
        LOADIMM R1, 1
        SUB R29, R1           ; Decrement stack pointer
        MOVE R1, R29          ; R29 = stack pointer
        LOAD R29, R1          ; Restore R1
        SUPERSWAP SR1, R29    ; Update stack pointer
        
        ; Return from interrupt - jump restores user mode
        LOADIMM R29, USER_MODE_RETURN
        JUMPABS R29
        
USER_MODE_RETURN:
        ; Normal program continues here
```

---

## Performance Characteristics

### Instruction Timing
All instructions execute in **3 clock cycles** (fetch-decode-execute):

| Instruction Type | Cycles | Notes |
|------------------|--------|--------|
| Data Movement | 3 | MOVE, LOAD, STORE |
| Arithmetic/Logic | 3 | ADD, SUB, AND, OR, NOT |  
| Shifts | 3 | Single-bit shifts only |
| Immediate Load | 6 | 3 for instruction + 3 for immediate fetch |
| Jumps | 3 | Pipeline flush may add 1-2 cycles |
| System Calls | 10+ | Supervisor mode transition overhead |

### Memory Access
- **Harvard architecture** eliminates instruction/data conflicts
- **Single-cycle memory access** (with fast memory)
- **No cache** - predictable timing for real-time applications

### Register Usage Optimization  
- **32 registers** reduce memory traffic
- **Register-to-register operations** are fastest
- **Avoid memory for temporary values**

### Code Size Optimization
- **16-bit instructions** minimize program memory
- **Immediate instructions** cost extra word
- **Short relative jumps** (-512 to +511) save space vs absolute jumps

---

## Hardware Implementation Notes

### FPGA Resource Usage (Estimated)
- **Logic Elements**: ~8,000
- **Memory Blocks**: 2-4 (for register file and instruction buffer)  
- **DSP Blocks**: 0 (pure logic implementation)
- **I/O Pins**: 32+ (16-bit data bus, 16-bit address bus, control signals)

### Critical Path  
The longest combinatorial path typically includes:
1. Register file read
2. ALU operation  
3. Flag computation
4. Result writeback

**Target frequency**: 50-100 MHz on mid-range FPGA

### Memory Interface
- **Synchronous RAM**: Single clock cycle access
- **Asynchronous ROM**: Combinatorial read  
- **Memory controllers**: May add wait states

### Power Consumption
- **Static power**: Minimal (CMOS technology)
- **Dynamic power**: Proportional to clock frequency and switching activity
- **Sleep modes**: Can halt clock to conserve power

### Extensibility  
The F00 architecture allows easy addition of:
- **Custom ALU functions**: Using unused opcode space
- **Coprocessors**: Via memory-mapped interface
- **Cache memory**: For higher-performance applications  
- **DMA controllers**: For high-bandwidth data transfers

---

## Instruction Set Summary Table

| Mnemonic | Opcode | Format | Description | Flags |
|----------|--------|--------|-------------|-------|
| **Data Movement** |
| MOVE | 02 | 10 | Copy register to register | - |
| LOAD | 00 | 10 | Load from memory | - |  
| STORE | 01 | 10 | Store to memory | - |
| LOADIMM | 16 | 01 | Load immediate value | - |
| **Arithmetic** |
| ADD | 43 | 10 | Addition | C,Z |
| SUB | 44 | 10 | Subtraction | C,Z |
| **Logical** |
| AND | 32 | 10 | Bitwise AND | Z |
| OR | 33 | 10 | Bitwise OR | Z |
| NOT | 34 | 10 | Bitwise NOT | Z |
| **Shift/Rotate** |
| SHIFTL | 35 | 10 | Shift left | C,Z |
| SHIFTR | 36 | 10 | Shift right | C,Z |
| ROTATEL | 37 | 10 | Rotate left | C,Z |
| ROTATER | 38 | 10 | Rotate right | C,Z |
| SHIFTLC | 39 | 10 | Shift left through carry | C,Z |
| SHIFTRC | 40 | 10 | Shift right through carry | C,Z |
| ROTATELC | 41 | 10 | Rotate left through carry | C,Z |
| ROTATERC | 42 | 10 | Rotate right through carry | C,Z |
| **Control Flow** |
| JUMPABS | 05 | 10 | Jump absolute | - |
| JUMPREL | 04 | 10 | Jump relative | - |
| JUMPRIMM | 06 | 00 | Jump relative immediate | - |
| JUMPRIMMC | 07 | 00 | Jump relative on carry | - |
| JUMPRIMMZ | 08 | 00 | Jump relative on zero | - |
| JUMPRIMMO | 09 | 00 | Jump relative on overflow | - |
| **System** |
| SYSCALL | 48 | 11 | System call | All SR |
| SUPERSWAP | 03 | 10 | Supervisor register swap | - |

**Legend**:
- **Format**: 00=Short immediate, 01=Reg+immediate, 10=Register, 11=No operands
- **Flags**: C=Carry, Z=Zero, SR=Supervisor register bits
- **-**: No flags affected

---

This completes the F00 CPU Programmer's Reference Guide. The F00 provides a clean, orthogonal instruction set suitable for embedded applications while maintaining simplicity for educational use and FPGA implementation.

For the latest updates and tools, including the web-based IDE, assembler, and simulator, visit the F00 development resources.