-- F00 CPU Top Level - Using Xilinx IP Cores
-- Integrates ISM with Xilinx IP for complete CPU implementation
-- Uses Block RAM, ALU IP, and other LogiCORE components

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity f00_cpu_top is
    port (
        -- Clock and reset
        CLK             : in  std_logic;
        RESET_N         : in  std_logic;
        
        -- External memory interface (instruction)
        IMEM_ADDR       : out std_logic_vector(15 downto 0);
        IMEM_DATA       : in  std_logic_vector(15 downto 0);
        IMEM_EN         : out std_logic;
        
        -- External memory interface (data) 
        DMEM_ADDR       : out std_logic_vector(15 downto 0);
        DMEM_DATA_IN    : in  std_logic_vector(15 downto 0);
        DMEM_DATA_OUT   : out std_logic_vector(15 downto 0);
        DMEM_WE         : out std_logic;
        DMEM_EN         : out std_logic;
        
        -- I/O interface
        IO_ADDR         : out std_logic_vector(15 downto 0);
        IO_DATA_IN      : in  std_logic_vector(15 downto 0);
        IO_DATA_OUT     : out std_logic_vector(15 downto 0);
        IO_WE           : out std_logic;
        IO_EN           : out std_logic;
        
        -- Debug/status outputs
        DEBUG_PC        : out std_logic_vector(15 downto 0);
        DEBUG_STATE     : out std_logic_vector(7 downto 0);
        DEBUG_FLAGS     : out std_logic_vector(3 downto 0)
    );
end entity f00_cpu_top;

architecture structural of f00_cpu_top is

    -- Component declarations for Xilinx IP cores
    
    -- Block Memory Generator for Register File (32x16-bit dual-port)
    component register_file_bram
        port (
            clka  : in  std_logic;
            wea   : in  std_logic_vector(0 downto 0);
            addra : in  std_logic_vector(4 downto 0);  -- 32 registers = 5-bit address
            dina  : in  std_logic_vector(15 downto 0);
            douta : out std_logic_vector(15 downto 0);
            clkb  : in  std_logic;
            web   : in  std_logic_vector(0 downto 0);
            addrb : in  std_logic_vector(4 downto 0);
            dinb  : in  std_logic_vector(15 downto 0);
            doutb : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Binary Counter for Program Counter
    component pc_counter
        port (
            CLK   : in  std_logic;
            CE    : in  std_logic;
            SCLR  : in  std_logic;
            LOAD  : in  std_logic;
            L     : in  std_logic_vector(15 downto 0);
            Q     : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Adder/Subtracter IP for ALU arithmetic
    component alu_addsub
        port (
            A      : in  std_logic_vector(15 downto 0);
            B      : in  std_logic_vector(15 downto 0);
            ADD    : in  std_logic;  -- 1=add, 0=subtract
            CLK    : in  std_logic;
            C_OUT  : out std_logic;
            S      : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- ISM (Instruction State Machine)
    component ism
        port (
            CLOCK                           : in  std_logic;
            RESET_N                         : in  std_logic;
            IBUS                            : in  std_logic_vector(15 downto 0);  -- Full instruction
            INTERRUPT                       : in  std_logic;
            -- Control outputs (49 signals)
            ALU_ADD                         : out std_logic;
            ALU_CARRY_IN                    : out std_logic;
            BUS_NOT_SIGNEXTEND_TO_TEMP      : out std_logic;
            CLOCK_INSTRUCTION_LATCH         : out std_logic;
            CLOCK_PC                        : out std_logic;
            EN_DATAADDR_TO_INTERNALBUS      : out std_logic;
            ENABLE_ADDER_TO_RESULT          : out std_logic;
            ENABLE_AND_TO_RESULT            : out std_logic;
            ENABLE_BUS_TO_ALU               : out std_logic;
            ENABLE_CARRY_FROM_ALU           : out std_logic;
            ENABLE_CARRY_OUT_TO_SHIFT_IN    : out std_logic;
            ENABLE_CODEBUS_TO_LOGICAL       : out std_logic;
            ENABLE_DATABUS_TO_LOGICAL       : out std_logic;
            ENABLE_DOWN_REGADDR_TO_REG      : out std_logic;
            ENABLE_EXTERNAL_TO_INTERNAL     : out std_logic;
            ENABLE_GROUND_TO_BUS            : out std_logic;
            ENABLE_INSTRUCTION_STATE        : out std_logic;
            ENABLE_INTERNAL_TO_EXTERNAL     : out std_logic;
            ENABLE_INVERT_TO_RESULT         : out std_logic;
            ENABLE_LOAD_SHIFT               : out std_logic;
            ENABLE_MMU_PHYS_TO_BUS          : out std_logic;
            ENABLE_OR_TO_RESULT             : out std_logic;
            ENABLE_OVERFLOW_FROM_ALU        : out std_logic;
            ENABLE_PC_TO_BUS                : out std_logic;
            ENABLE_REGISTERS_TO_BUS         : out std_logic;
            ENABLE_RESULT_TO_BUS            : out std_logic;
            ENABLE_SHIFT_OUT_TO_CARRY_IN    : out std_logic;
            ENABLE_SHIFT_OUT_TO_SHIFT_IN    : out std_logic;
            ENABLE_SHIFTER_TO_RESULT        : out std_logic;
            ENABLE_SUPERREG_READ            : out std_logic;
            ENABLE_SUPERREG_WRITE           : out std_logic;
            ENABLE_TEMP_TO_ALU              : out std_logic;
            ENABLE_TEMP_TO_BUS              : out std_logic;
            ENABLE_UP_REGADDR_TO_REG        : out std_logic;
            INCDEC_PC                       : out std_logic;
            INCREMENT_PC                    : out std_logic;
            LOAD_INSTRUCTION_LATCH          : out std_logic;
            LOAD_PC                         : out std_logic;
            MEMREQ                          : out std_logic;
            MEMREQDATA                      : out std_logic;
            RESET_INCDEC_PC                 : out std_logic;
            SET_SUPERUSER_BIT               : out std_logic;
            SHIFT_DIRECTION                 : out std_logic;
            SUPERUSER_MODE                  : out std_logic;
            UPDATE_FLAGS                    : out std_logic;
            WRITE_REGISTERS                 : out std_logic;
            -- Additional outputs for debugging
            CURRENT_STATE_OUT               : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Internal signals
    signal pc_out           : std_logic_vector(15 downto 0);
    signal pc_load          : std_logic;
    signal pc_ce            : std_logic;
    signal pc_sclr          : std_logic;
    signal pc_load_value    : std_logic_vector(15 downto 0);

    -- Internal bus system
    signal internal_bus     : std_logic_vector(15 downto 0);
    signal external_bus     : std_logic_vector(15 downto 0);

    -- Temporary registers and latches
    signal temp_register    : std_logic_vector(15 downto 0);
    signal result_register  : std_logic_vector(15 downto 0);
    signal data_addr_latch  : std_logic_vector(15 downto 0);
    signal operand_latch    : std_logic_vector(15 downto 0);

    -- Shifter signals
    signal shifter_input    : std_logic_vector(15 downto 0);
    signal shifter_output   : std_logic_vector(15 downto 0);
    signal shifter_carry    : std_logic;
    
    signal reg_file_addra   : std_logic_vector(4 downto 0);
    signal reg_file_addrb   : std_logic_vector(4 downto 0);
    signal reg_file_dina    : std_logic_vector(15 downto 0);
    signal reg_file_dinb    : std_logic_vector(15 downto 0);
    signal reg_file_douta   : std_logic_vector(15 downto 0);
    signal reg_file_doutb   : std_logic_vector(15 downto 0);
    signal reg_file_wea     : std_logic_vector(0 downto 0);
    signal reg_file_web     : std_logic_vector(0 downto 0);
    
    signal alu_a            : std_logic_vector(15 downto 0);
    signal alu_b            : std_logic_vector(15 downto 0);
    signal alu_add_mode     : std_logic;
    signal alu_result       : std_logic_vector(15 downto 0);
    signal alu_carry_out    : std_logic;
    
    signal current_instruction : std_logic_vector(15 downto 0);
    signal instruction_opcode  : std_logic_vector(5 downto 0);
    signal operand1           : std_logic_vector(4 downto 0);
    signal operand2           : std_logic_vector(4 downto 0);
    
    -- ISM control signals
    signal ism_alu_add                         : std_logic;
    signal ism_alu_carry_in                    : std_logic;
    signal ism_bus_not_signextend_to_temp      : std_logic;
    signal ism_clock_instruction_latch         : std_logic;
    signal ism_clock_pc                        : std_logic;
    signal ism_en_dataaddr_to_internalbus      : std_logic;
    signal ism_enable_adder_to_result          : std_logic;
    signal ism_enable_and_to_result            : std_logic;
    signal ism_enable_bus_to_alu               : std_logic;
    signal ism_enable_carry_from_alu           : std_logic;
    signal ism_enable_carry_out_to_shift_in    : std_logic;
    signal ism_enable_codebus_to_logical       : std_logic;
    signal ism_enable_databus_to_logical       : std_logic;
    signal ism_enable_down_regaddr_to_reg      : std_logic;
    signal ism_enable_external_to_internal     : std_logic;
    signal ism_enable_ground_to_bus            : std_logic;
    signal ism_enable_instruction_state        : std_logic;
    signal ism_enable_internal_to_external     : std_logic;
    signal ism_enable_invert_to_result         : std_logic;
    signal ism_enable_load_shift               : std_logic;
    signal ism_enable_mmu_phys_to_bus          : std_logic;
    signal ism_enable_or_to_result             : std_logic;
    signal ism_enable_overflow_from_alu        : std_logic;
    signal ism_enable_pc_to_bus                : std_logic;
    signal ism_enable_registers_to_bus         : std_logic;
    signal ism_enable_result_to_bus            : std_logic;
    signal ism_enable_shift_out_to_carry_in    : std_logic;
    signal ism_enable_shift_out_to_shift_in    : std_logic;
    signal ism_enable_shifter_to_result        : std_logic;
    signal ism_enable_superreg_read            : std_logic;
    signal ism_enable_superreg_write           : std_logic;
    signal ism_enable_temp_to_alu              : std_logic;
    signal ism_enable_temp_to_bus              : std_logic;
    signal ism_enable_up_regaddr_to_reg        : std_logic;
    signal ism_incdec_pc                       : std_logic;
    signal ism_increment_pc                    : std_logic;
    signal ism_load_instruction_latch          : std_logic;
    signal ism_load_pc                         : std_logic;
    signal ism_memreq                          : std_logic;
    signal ism_memreqdata                      : std_logic;
    signal ism_reset_incdec_pc                 : std_logic;
    signal ism_set_superuser_bit               : std_logic;
    signal ism_shift_direction                 : std_logic;
    signal ism_superuser_mode                  : std_logic;
    signal ism_update_flags                    : std_logic;
    signal ism_write_registers                 : std_logic;
    signal ism_current_state                   : std_logic_vector(7 downto 0);

    -- Additional ISM signals needed for datapath
    signal ism_shift_left_not_right            : std_logic;
    signal ism_mem_read_not_write              : std_logic;
    signal ism_load_carry_bit                  : std_logic;
    signal ism_load_zero_bit                   : std_logic;
    signal ism_load_overflow_bit               : std_logic;
    signal ism_load_data_address_latch         : std_logic;
    signal ism_load_operand                    : std_logic;
    signal ism_write_to_registers              : std_logic;
    
    -- Status flags
    signal carry_flag       : std_logic;
    signal zero_flag        : std_logic;
    signal overflow_flag    : std_logic;
    signal negative_flag    : std_logic;

begin

    -- Instruction decode
    current_instruction <= IMEM_DATA;
    instruction_opcode <= current_instruction(15 downto 10);
    operand1 <= current_instruction(9 downto 5);
    operand2 <= current_instruction(4 downto 0);
    
    -- Program Counter (using Xilinx Binary Counter IP)
    pc_inst : pc_counter
        port map (
            CLK  => CLK,
            CE   => pc_ce,
            SCLR => pc_sclr,
            LOAD => pc_load,
            L    => pc_load_value,
            Q    => pc_out
        );
    
    -- Register File (using Xilinx Block Memory Generator IP)
    register_file_inst : register_file_bram
        port map (
            clka  => CLK,
            wea   => reg_file_wea,
            addra => reg_file_addra,
            dina  => reg_file_dina,
            douta => reg_file_douta,
            clkb  => CLK,
            web   => reg_file_web,
            addrb => reg_file_addrb,
            dinb  => reg_file_dinb,
            doutb => reg_file_doutb
        );
    
    -- Enhanced ALU with logical operations
    enhanced_alu_inst : process(alu_a, alu_b, alu_add_mode, ism_enable_and_to_result, ism_enable_or_to_result, ism_enable_invert_to_result)
        variable temp_result : std_logic_vector(16 downto 0);
    begin
        -- Default to arithmetic operations
        if ism_enable_and_to_result = '1' then
            -- Logical AND operation
            temp_result := '0' & (alu_a and alu_b);
        elsif ism_enable_or_to_result = '1' then
            -- Logical OR operation
            temp_result := '0' & (alu_a or alu_b);
        elsif ism_enable_invert_to_result = '1' then
            -- Logical NOT operation
            temp_result := '0' & (not alu_a);
        elsif alu_add_mode = '1' then
            -- Addition
            temp_result := std_logic_vector(unsigned('0' & alu_a) + unsigned('0' & alu_b));
        else
            -- Subtraction
            temp_result := std_logic_vector(unsigned('0' & alu_a) - unsigned('0' & alu_b));
        end if;

        alu_result <= temp_result(15 downto 0);
        alu_carry_out <= temp_result(16);
    end process;

    -- Shifter Unit
    shifter_unit: process(shifter_input, ism_shift_left_not_right, carry_flag)
    begin
        if ism_shift_left_not_right = '1' then
            -- Shift left
            shifter_output <= shifter_input(14 downto 0) & '0';
            shifter_carry <= shifter_input(15);
        else
            -- Shift right
            shifter_output <= '0' & shifter_input(15 downto 1);
            shifter_carry <= shifter_input(0);
        end if;
    end process;

    -- Internal Bus Routing
    internal_bus_routing: process(
        ism_enable_registers_to_bus, ism_enable_pc_to_bus, ism_enable_result_to_bus,
        ism_enable_temp_to_bus, ism_enable_ground_to_bus,
        reg_file_douta, pc_out, result_register, temp_register, external_bus,
        ism_enable_external_to_internal
    )
    begin
        internal_bus <= (others => '0');  -- Default

        if ism_enable_registers_to_bus = '1' then
            internal_bus <= reg_file_douta;
        elsif ism_enable_pc_to_bus = '1' then
            internal_bus <= pc_out;
        elsif ism_enable_result_to_bus = '1' then
            internal_bus <= result_register;
        elsif ism_enable_temp_to_bus = '1' then
            internal_bus <= temp_register;
        elsif ism_enable_external_to_internal = '1' then
            internal_bus <= external_bus;
        elsif ism_enable_ground_to_bus = '1' then
            internal_bus <= (others => '0');
        end if;
    end process;

    -- External Bus (Memory Interface)
    external_bus <= IMEM_DATA when ism_memreq = '1' else DMEM_DATA_IN;

    -- Temporary Registers and Latches
    temp_regs: process(CLK, RESET_N)
    begin
        if RESET_N = '0' then
            temp_register <= (others => '0');
            result_register <= (others => '0');
            data_addr_latch <= (others => '0');
            operand_latch <= (others => '0');
        elsif rising_edge(CLK) then
            -- Load temporary register
            if ism_enable_bus_to_alu = '1' then
                temp_register <= internal_bus;
            end if;

            -- Load result register
            if ism_enable_adder_to_result = '1' then
                result_register <= alu_result;
            elsif ism_enable_and_to_result = '1' or ism_enable_or_to_result = '1' or ism_enable_invert_to_result = '1' then
                result_register <= alu_result;
            elsif ism_enable_shifter_to_result = '1' then
                result_register <= shifter_output;
            end if;

            -- Load data address latch
            if ism_load_data_address_latch = '1' then
                data_addr_latch <= internal_bus;
            end if;

            -- Load operand latch
            if ism_load_operand = '1' then
                operand_latch <= internal_bus;
            end if;
        end if;
    end process;

    -- Instruction State Machine
    ism_inst : ism
        port map (
            CLOCK                           => CLK,
            RESET_N                         => RESET_N,
            IBUS                            => current_instruction,
            INTERRUPT                       => '0',  -- No interrupts for now
            ALU_ADD                         => ism_alu_add,
            ALU_CARRY_IN                    => ism_alu_carry_in,
            BUS_NOT_SIGNEXTEND_TO_TEMP      => ism_bus_not_signextend_to_temp,
            CLOCK_INSTRUCTION_LATCH         => ism_clock_instruction_latch,
            CLOCK_PC                        => ism_clock_pc,
            EN_DATAADDR_TO_INTERNALBUS      => ism_en_dataaddr_to_internalbus,
            ENABLE_ADDER_TO_RESULT          => ism_enable_adder_to_result,
            ENABLE_AND_TO_RESULT            => ism_enable_and_to_result,
            ENABLE_BUS_TO_ALU               => ism_enable_bus_to_alu,
            ENABLE_CARRY_FROM_ALU           => ism_enable_carry_from_alu,
            ENABLE_CARRY_OUT_TO_SHIFT_IN    => ism_enable_carry_out_to_shift_in,
            ENABLE_CODEBUS_TO_LOGICAL       => ism_enable_codebus_to_logical,
            ENABLE_DATABUS_TO_LOGICAL       => ism_enable_databus_to_logical,
            ENABLE_DOWN_REGADDR_TO_REG      => ism_enable_down_regaddr_to_reg,
            ENABLE_EXTERNAL_TO_INTERNAL     => ism_enable_external_to_internal,
            ENABLE_GROUND_TO_BUS            => ism_enable_ground_to_bus,
            ENABLE_INSTRUCTION_STATE        => ism_enable_instruction_state,
            ENABLE_INTERNAL_TO_EXTERNAL     => ism_enable_internal_to_external,
            ENABLE_INVERT_TO_RESULT         => ism_enable_invert_to_result,
            ENABLE_LOAD_SHIFT               => ism_enable_load_shift,
            ENABLE_MMU_PHYS_TO_BUS          => ism_enable_mmu_phys_to_bus,
            ENABLE_OR_TO_RESULT             => ism_enable_or_to_result,
            ENABLE_OVERFLOW_FROM_ALU        => ism_enable_overflow_from_alu,
            ENABLE_PC_TO_BUS                => ism_enable_pc_to_bus,
            ENABLE_REGISTERS_TO_BUS         => ism_enable_registers_to_bus,
            ENABLE_RESULT_TO_BUS            => ism_enable_result_to_bus,
            ENABLE_SHIFT_OUT_TO_CARRY_IN    => ism_enable_shift_out_to_carry_in,
            ENABLE_SHIFT_OUT_TO_SHIFT_IN    => ism_enable_shift_out_to_shift_in,
            ENABLE_SHIFTER_TO_RESULT        => ism_enable_shifter_to_result,
            ENABLE_SUPERREG_READ            => ism_enable_superreg_read,
            ENABLE_SUPERREG_WRITE           => ism_enable_superreg_write,
            ENABLE_TEMP_TO_ALU              => ism_enable_temp_to_alu,
            ENABLE_TEMP_TO_BUS              => ism_enable_temp_to_bus,
            ENABLE_UP_REGADDR_TO_REG        => ism_enable_up_regaddr_to_reg,
            INCDEC_PC                       => ism_incdec_pc,
            INCREMENT_PC                    => ism_increment_pc,
            LOAD_INSTRUCTION_LATCH          => ism_load_instruction_latch,
            LOAD_PC                         => ism_load_pc,
            MEMREQ                          => ism_memreq,
            MEMREQDATA                      => ism_memreqdata,
            RESET_INCDEC_PC                 => ism_reset_incdec_pc,
            SET_SUPERUSER_BIT               => ism_set_superuser_bit,
            SHIFT_DIRECTION                 => ism_shift_direction,
            SUPERUSER_MODE                  => ism_superuser_mode,
            UPDATE_FLAGS                    => ism_update_flags,
            WRITE_REGISTERS                 => ism_write_registers,
            CURRENT_STATE_OUT               => ism_current_state,
            -- Additional signals for complete datapath
            MEM_READ_NOT_WRITE              => ism_mem_read_not_write,
            SHIFT_LEFT_NOT_RIGHT            => ism_shift_left_not_right,
            LOAD_CARRY_BIT                  => ism_load_carry_bit,
            LOAD_ZERO_BIT                   => ism_load_zero_bit,
            LOAD_OVERFLOW_BIT               => ism_load_overflow_bit,
            LOAD_DATA_ADDRESS_LATCH         => ism_load_data_address_latch,
            LOAD_OPERAND                    => ism_load_operand,
            WRITE_TO_REGISTERS              => ism_write_to_registers
        );

    -- Control Logic (connects ISM outputs to datapath components)

    -- Program Counter Control
    pc_ce <= ism_increment_pc or ism_clock_pc;
    pc_sclr <= not RESET_N;
    pc_load_value <= internal_bus when ism_load_pc = '1' else (others => '0');

    -- Register File Control (Dynamic Addressing)
    reg_file_addra <= operand1 when ism_enable_down_regaddr_to_reg = '1' else
                      operand2 when ism_enable_up_regaddr_to_reg = '1' else
                      (others => '0');
    reg_file_addrb <= operand2;
    reg_file_dina <= internal_bus;
    reg_file_wea(0) <= ism_write_to_registers;
    reg_file_web(0) <= '0';  -- Port B used for read only

    -- ALU Control and Input Routing
    alu_add_mode <= ism_alu_add;  -- 1 for ADD, 0 for SUB
    alu_a <= temp_register when ism_enable_temp_to_alu = '1' else
             reg_file_douta when ism_enable_bus_to_alu = '1' else
             (others => '0');
    alu_b <= reg_file_doutb when ism_enable_temp_to_alu = '1' else
             internal_bus;

    -- Shifter Input Control
    shifter_input <= reg_file_douta when ism_enable_load_shift = '1' else
                     internal_bus;
    
    -- Memory Interface
    IMEM_ADDR <= pc_out;
    IMEM_EN <= ism_memreq;

    -- Data Memory Interface
    DMEM_ADDR <= data_addr_latch when ism_en_dataaddr_to_internalbus = '1' else
                 internal_bus;
    DMEM_DATA_OUT <= internal_bus when ism_enable_internal_to_external = '1' else
                     reg_file_douta;
    DMEM_EN <= ism_memreqdata;
    DMEM_WE <= ism_enable_internal_to_external and (not ism_mem_read_not_write);

    -- I/O Interface (memory-mapped at 0x7FFF)
    IO_EN <= '1' when (unsigned(DMEM_ADDR) = 32767 and ism_memreqdata = '1') else '0';
    IO_WE <= DMEM_WE when (unsigned(DMEM_ADDR) = 32767) else '0';
    IO_ADDR <= DMEM_ADDR;
    IO_DATA_OUT <= DMEM_DATA_OUT;
    
    -- Enhanced Status Flag Updates
    flag_control: process(CLK, RESET_N)
    begin
        if RESET_N = '0' then
            carry_flag <= '0';
            zero_flag <= '0';
            overflow_flag <= '0';
            negative_flag <= '0';
        elsif rising_edge(CLK) then
            if ism_update_flags = '1' then
                -- Update carry flag from ALU or shifter
                if ism_enable_carry_from_alu = '1' then
                    carry_flag <= alu_carry_out;
                elsif ism_enable_shift_out_to_carry_in = '1' then
                    carry_flag <= shifter_carry;
                end if;

                -- Update zero flag based on result
                if ism_enable_adder_to_result = '1' or ism_enable_and_to_result = '1' or
                   ism_enable_or_to_result = '1' or ism_enable_invert_to_result = '1' or
                   ism_enable_shifter_to_result = '1' then
                    zero_flag <= '1' when result_register = x"0000" else '0';
                end if;

                -- Update negative flag (MSB of result)
                negative_flag <= result_register(15);

                -- Overflow detection for signed arithmetic
                if alu_add_mode = '1' then
                    overflow_flag <= (alu_a(15) xor result_register(15)) and
                                   (alu_b(15) xor result_register(15));
                else
                    overflow_flag <= (alu_a(15) xor result_register(15)) and
                                   (not alu_b(15) xor result_register(15));
                end if;
            end if;

            -- Individual flag control signals
            if ism_load_carry_bit = '1' then
                carry_flag <= shifter_carry;
            end if;
            if ism_load_zero_bit = '1' then
                zero_flag <= '1' when internal_bus = x"0000" else '0';
            end if;
            if ism_load_overflow_bit = '1' then
                overflow_flag <= internal_bus(0);
            end if;
        end if;
    end process;

    -- Conditional Jump Logic
    conditional_jump_control: process(
        ism_load_pc, carry_flag, zero_flag, overflow_flag,
        current_instruction, instruction_opcode
    )
    begin
        -- Default PC load behavior
        pc_load <= ism_load_pc;

        -- Override for conditional jumps
        if instruction_opcode = "000111" then  -- JUMPRIMMC (7)
            pc_load <= ism_load_pc and carry_flag;
        elsif instruction_opcode = "001000" then  -- JUMPRIMMZ (8)
            pc_load <= ism_load_pc and zero_flag;
        elsif instruction_opcode = "001001" then  -- JUMPRIMMO (9)
            pc_load <= ism_load_pc and overflow_flag;
        end if;
    end process;
    
    -- Debug Outputs
    DEBUG_PC <= pc_out;
    DEBUG_STATE <= ism_current_state;
    DEBUG_FLAGS <= overflow_flag & negative_flag & zero_flag & carry_flag;
    
end architecture structural;