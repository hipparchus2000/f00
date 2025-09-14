# F00 CPU Development Tools

This directory is reserved for future development tools and utilities for the F00 CPU ecosystem.

## Current Tools

### Web IDE (Primary Development Environment)
The complete development environment is available in `../web-ide/f00-web-ide.html`:
- **Assembler**: Full F00 assembly language support
- **Simulator**: Cycle-accurate CPU simulation
- **Debugger**: Step-by-step execution with register monitoring
- **Memory Inspector**: ROM, RAM, and hex dump views
- **UART Terminal**: Real-time I/O interaction

## Future Tool Ideas

### Command-Line Tools
- **f00-asm**: Standalone assembler for batch processing
- **f00-sim**: Headless simulator for automated testing
- **f00-debug**: GDB-style debugger interface
- **f00-objdump**: Disassembler and object file inspector

### Development Utilities  
- **f00-linker**: Multi-file linking and library support
- **f00-profiler**: Performance analysis and optimization
- **f00-test**: Automated test framework
- **f00-bootloader**: ROM image generator

### Integration Tools
- **f00-vscode**: Visual Studio Code extension
- **f00-vim**: Vim syntax highlighting and IDE integration
- **f00-emacs**: Emacs mode for F00 assembly
- **f00-make**: Build system integration

### Hardware Tools
- **f00-flash**: FPGA programming utilities
- **f00-jtag**: Hardware debugging interface
- **f00-scope**: Logic analyzer integration
- **f00-bench**: Hardware testing framework

## Contributing Tools

If you develop tools for the F00 CPU ecosystem:

1. **Follow naming convention**: `f00-toolname`
2. **Include documentation**: README.md with usage examples
3. **Support standard formats**: Compatible with web IDE file formats
4. **Add to this index**: Update this README with your tool

## Tool Architecture Guidelines

### File Formats
- **Source code**: `.f00`, `.asm` (F00 assembly)
- **Object files**: `.o` (assembled machine code)
- **Executables**: `.bin`, `.rom` (ROM images)
- **Symbols**: `.sym` (symbol tables)
- **Listings**: `.lst` (assembly listings)

### Command-Line Interface
Follow Unix conventions:
```bash
f00-asm input.f00 -o output.bin    # Assemble
f00-sim program.bin                 # Simulate  
f00-debug program.bin               # Debug
```

### Integration
- **Exit codes**: 0 success, non-zero error
- **Error messages**: Descriptive, with line numbers
- **Verbose mode**: `-v` flag for detailed output
- **Quiet mode**: `-q` flag for minimal output

## Historical Tools

The original development tools are preserved in `../archive/original-c-tools/`:
- **f00asm0.03.c**: Original C assembler
- **f00sim.c**: Original C simulator

These can serve as reference implementations for new tool development.

## Current Status

**Active Development**: Web IDE provides complete development environment
**Future Planning**: Additional tools will be added based on community needs
**Contributions Welcome**: Submit tools following the guidelines above

---

*Build the future of F00 CPU development tools!*