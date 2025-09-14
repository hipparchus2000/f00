-- F00 CPU Control Unit
-- Interfaces the Instruction State Machine with the CPU datapath

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control is
    port (
        -- Clock and reset
        CLOCK                           : in  std_logic;
        RESET_N                         : in  std_logic;
        
        -- Data buses
        internal_databus                : inout STD_LOGIC_VECTOR (15 downto 0);
        instruction_bus                 : in    STD_LOGIC_VECTOR (15 downto 0);
        
        -- Memory interface
        memory_address                  : out   STD_LOGIC_VECTOR (15 downto 0);
        memory_data                     : inout STD_LOGIC_VECTOR (15 downto 0);
        memory_read_enable              : out   std_logic;
        memory_write_enable             : out   std_logic;
        memory_request                  : out   std_logic;
        
        -- Register file interface
        reg_address_a                   : out   STD_LOGIC_VECTOR (4 downto 0);
        reg_address_b                   : out   STD_LOGIC_VECTOR (4 downto 0);
        reg_data_out                    : in    STD_LOGIC_VECTOR (15 downto 0);
        reg_data_in                     : out   STD_LOGIC_VECTOR (15 downto 0);
        reg_write_enable                : out   std_logic;
        
        -- ALU interface
        alu_operand_a                   : out   STD_LOGIC_VECTOR (15 downto 0);
        alu_operand_b                   : out   STD_LOGIC_VECTOR (15 downto 0);
        alu_result                      : in    STD_LOGIC_VECTOR (15 downto 0);
        alu_operation                   : out   STD_LOGIC_VECTOR (3 downto 0);
        alu_carry_in                    : out   std_logic;
        alu_carry_out                   : in    std_logic;
        alu_zero_flag                   : in    std_logic;
        alu_overflow                    : in    std_logic;
        
        -- Status flags
        carry_flag                      : inout std_logic;
        zero_flag                       : inout std_logic;
        overflow_flag                   : inout std_logic;
        
        -- Interrupt signals
        interrupt_request               : in    std_logic;
        interrupt_acknowledge           : out   std_logic
    );
end control;

architecture control_arch of control is
    
    -- Component declaration for ISM
    component ism is
        port (
            CLOCK                           : in  std_logic;
            RESET_N                         : in  std_logic;
            IBUS                            : in  std_logic_vector(15 downto 10);
            INTERRUPT                       : in  std_logic;
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
            ENABLE_USR_FROM_BUS             : out std_logic;
            ENABLE_USR_TO_BUS               : out std_logic;
            ENABLE_ZERO_TO_USR              : out std_logic;
            LOAD_CARRY_BIT                  : out std_logic;
            LOAD_DATA_ADDRESS_LATCH         : out std_logic;
            LOAD_OPERAND                    : out std_logic;
            LOAD_OVERFLOW_BIT               : out std_logic;
            LOAD_PC                         : out std_logic;
            LOAD_RESULT_LATCH               : out std_logic;
            LOAD_SHIFT                      : out std_logic;
            LOAD_ZERO_BIT                   : out std_logic;
            MEM_READ_NOT_WRITE              : out std_logic;
            MEMREQ                          : out std_logic;
            READ_MMU                        : out std_logic;
            SHIFT_LEFT_NOT_RIGHT            : out std_logic;
            SHIFT_OUT_BIT                   : out std_logic;
            SREGADDR_FROM_IWORD_NOT_UCODE   : out std_logic;
            SUPERREG_ADDR_FROM_UCODE        : out std_logic_vector(2 downto 0);
            SUPERSET                        : out std_logic_vector(4 downto 0);
            SUPERSET_NOT_BUS                : out std_logic;
            UC_LOAD_FREEZE                  : out std_logic;
            UC_LOAD_ILLEGAL                 : out std_logic;
            UC_LOAD_INTENABLE               : out std_logic;
            UC_LOAD_SOFTINT                 : out std_logic;
            UC_LOAD_SUPERBIT               : out std_logic;
            WRITE_ENABLE_REGISTERS          : out std_logic;
            WRITE_MMU                       : out std_logic;
            WRITE_TO_REGISTERS              : out std_logic
        );
    end component;
    
    -- ISM control signals
    signal ism_alu_add                      : std_logic;
    signal ism_alu_carry_in                 : std_logic;
    signal ism_bus_not_signextend_to_temp   : std_logic;
    signal ism_clock_instruction_latch      : std_logic;
    signal ism_clock_pc                     : std_logic;
    signal ism_en_dataaddr_to_internalbus   : std_logic;
    signal ism_enable_adder_to_result       : std_logic;
    signal ism_enable_and_to_result         : std_logic;
    signal ism_enable_bus_to_alu            : std_logic;
    signal ism_enable_carry_from_alu        : std_logic;
    signal ism_enable_carry_out_to_shift_in : std_logic;
    signal ism_enable_codebus_to_logical    : std_logic;
    signal ism_enable_databus_to_logical    : std_logic;
    signal ism_enable_down_regaddr_to_reg   : std_logic;
    signal ism_enable_external_to_internal  : std_logic;
    signal ism_enable_ground_to_bus         : std_logic;
    signal ism_enable_instruction_state     : std_logic;
    signal ism_enable_internal_to_external  : std_logic;
    signal ism_enable_invert_to_result      : std_logic;
    signal ism_enable_load_shift            : std_logic;
    signal ism_enable_mmu_phys_to_bus       : std_logic;
    signal ism_enable_or_to_result          : std_logic;
    signal ism_enable_overflow_from_alu     : std_logic;
    signal ism_enable_pc_to_bus             : std_logic;
    signal ism_enable_registers_to_bus      : std_logic;
    signal ism_enable_result_to_bus         : std_logic;
    signal ism_enable_shift_out_to_carry_in : std_logic;
    signal ism_enable_shift_out_to_shift_in : std_logic;
    signal ism_enable_shifter_to_result     : std_logic;
    signal ism_enable_superreg_read         : std_logic;
    signal ism_enable_superreg_write        : std_logic;
    signal ism_enable_usr_from_bus          : std_logic;
    signal ism_enable_usr_to_bus            : std_logic;
    signal ism_enable_zero_to_usr           : std_logic;
    signal ism_load_carry_bit               : std_logic;
    signal ism_load_data_address_latch      : std_logic;
    signal ism_load_operand                 : std_logic;
    signal ism_load_overflow_bit            : std_logic;
    signal ism_load_pc                      : std_logic;
    signal ism_load_result_latch            : std_logic;
    signal ism_load_shift                   : std_logic;
    signal ism_load_zero_bit                : std_logic;
    signal ism_mem_read_not_write           : std_logic;
    signal ism_memreq                       : std_logic;
    signal ism_read_mmu                     : std_logic;
    signal ism_shift_left_not_right         : std_logic;
    signal ism_shift_out_bit                : std_logic;
    signal ism_sregaddr_from_iword_not_ucode: std_logic;
    signal ism_superreg_addr_from_ucode     : std_logic_vector(2 downto 0);
    signal ism_superset                     : std_logic_vector(4 downto 0);
    signal ism_superset_not_bus             : std_logic;
    signal ism_uc_load_freeze               : std_logic;
    signal ism_uc_load_illegal              : std_logic;
    signal ism_uc_load_intenable            : std_logic;
    signal ism_uc_load_softint              : std_logic;
    signal ism_uc_load_superbit             : std_logic;
    signal ism_write_enable_registers       : std_logic;
    signal ism_write_mmu                    : std_logic;
    signal ism_write_to_registers           : std_logic;
    
    -- Program Counter
    signal program_counter                  : std_logic_vector(15 downto 0);
    signal pc_increment                     : std_logic;
    
    -- Instruction register
    signal instruction_register            : std_logic_vector(15 downto 0);
    
begin
    
    -- Instantiate the Instruction State Machine
    ism_inst: ism
        port map (
            CLOCK                           => CLOCK,
            RESET_N                         => RESET_N,
            IBUS                            => instruction_register(15 downto 10),
            INTERRUPT                       => interrupt_request,
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
            ENABLE_USR_FROM_BUS             => ism_enable_usr_from_bus,
            ENABLE_USR_TO_BUS               => ism_enable_usr_to_bus,
            ENABLE_ZERO_TO_USR              => ism_enable_zero_to_usr,
            LOAD_CARRY_BIT                  => ism_load_carry_bit,
            LOAD_DATA_ADDRESS_LATCH         => ism_load_data_address_latch,
            LOAD_OPERAND                    => ism_load_operand,
            LOAD_OVERFLOW_BIT               => ism_load_overflow_bit,
            LOAD_PC                         => ism_load_pc,
            LOAD_RESULT_LATCH               => ism_load_result_latch,
            LOAD_SHIFT                      => ism_load_shift,
            LOAD_ZERO_BIT                   => ism_load_zero_bit,
            MEM_READ_NOT_WRITE              => ism_mem_read_not_write,
            MEMREQ                          => ism_memreq,
            READ_MMU                        => ism_read_mmu,
            SHIFT_LEFT_NOT_RIGHT            => ism_shift_left_not_right,
            SHIFT_OUT_BIT                   => ism_shift_out_bit,
            SREGADDR_FROM_IWORD_NOT_UCODE   => ism_sregaddr_from_iword_not_ucode,
            SUPERREG_ADDR_FROM_UCODE        => ism_superreg_addr_from_ucode,
            SUPERSET                        => ism_superset,
            SUPERSET_NOT_BUS                => ism_superset_not_bus,
            UC_LOAD_FREEZE                  => ism_uc_load_freeze,
            UC_LOAD_ILLEGAL                 => ism_uc_load_illegal,
            UC_LOAD_INTENABLE               => ism_uc_load_intenable,
            UC_LOAD_SOFTINT                 => ism_uc_load_softint,
            UC_LOAD_SUPERBIT               => ism_uc_load_superbit,
            WRITE_ENABLE_REGISTERS          => ism_write_enable_registers,
            WRITE_MMU                       => ism_write_mmu,
            WRITE_TO_REGISTERS              => ism_write_to_registers
        );
    
    -- Program Counter Logic
    pc_process: process(CLOCK, RESET_N)
    begin
        if RESET_N = '0' then
            program_counter <= (others => '0');
        elsif rising_edge(CLOCK) then
            if ism_clock_pc = '1' then
                program_counter <= std_logic_vector(unsigned(program_counter) + 1);
            end if;
        end if;
    end process;
    
    -- Instruction Register
    instruction_register_process: process(CLOCK, RESET_N)
    begin
        if RESET_N = '0' then
            instruction_register <= (others => '0');
        elsif rising_edge(CLOCK) then
            if ism_clock_instruction_latch = '0' then -- Active low per original Abel
                instruction_register <= instruction_bus;
            end if;
        end if;
    end process;
    
    -- Connect ISM control signals to external interfaces
    memory_address      <= program_counter;
    memory_read_enable  <= ism_mem_read_not_write;
    memory_write_enable <= not ism_mem_read_not_write;
    memory_request      <= ism_memreq;
    
    alu_carry_in        <= ism_alu_carry_in;
    reg_write_enable    <= ism_write_to_registers;
    
    -- Status flag handling
    status_flag_process: process(CLOCK, RESET_N)
    begin
        if RESET_N = '0' then
            carry_flag <= '0';
            zero_flag <= '0';
            overflow_flag <= '0';
        elsif rising_edge(CLOCK) then
            if ism_load_carry_bit = '1' then
                carry_flag <= alu_carry_out;
            end if;
            if ism_load_zero_bit = '1' then
                zero_flag <= alu_zero_flag;
            end if;
            if ism_load_overflow_bit = '1' then
                overflow_flag <= alu_overflow;
            end if;
        end if;
    end process;
    
    -- TODO: Add more complete datapath control logic
    -- This is a basic framework that needs expansion for full CPU functionality
    
end control_arch;
