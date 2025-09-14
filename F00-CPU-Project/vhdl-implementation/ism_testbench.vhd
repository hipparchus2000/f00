-- Test bench for ISM (Instruction State Machine)
-- Verifies the VHDL translation of the Abel code

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ism_testbench is
end entity ism_testbench;

architecture sim of ism_testbench is
    -- Component declaration
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
    
    -- Test signals
    signal clock_tb                         : std_logic := '0';
    signal reset_n_tb                       : std_logic := '0';
    signal ibus_tb                          : std_logic_vector(15 downto 10) := (others => '0');
    signal interrupt_tb                     : std_logic := '0';
    
    -- Output signals
    signal alu_add_tb                       : std_logic;
    signal alu_carry_in_tb                  : std_logic;
    signal bus_not_signextend_to_temp_tb    : std_logic;
    signal clock_instruction_latch_tb       : std_logic;
    signal clock_pc_tb                      : std_logic;
    signal en_dataaddr_to_internalbus_tb    : std_logic;
    signal enable_adder_to_result_tb        : std_logic;
    signal enable_and_to_result_tb          : std_logic;
    signal enable_bus_to_alu_tb             : std_logic;
    signal enable_carry_from_alu_tb         : std_logic;
    signal enable_carry_out_to_shift_in_tb  : std_logic;
    signal enable_codebus_to_logical_tb     : std_logic;
    signal enable_databus_to_logical_tb     : std_logic;
    signal enable_down_regaddr_to_reg_tb    : std_logic;
    signal enable_external_to_internal_tb   : std_logic;
    signal enable_ground_to_bus_tb          : std_logic;
    signal enable_instruction_state_tb      : std_logic;
    signal enable_internal_to_external_tb   : std_logic;
    signal enable_invert_to_result_tb       : std_logic;
    signal enable_load_shift_tb             : std_logic;
    signal enable_mmu_phys_to_bus_tb        : std_logic;
    signal enable_or_to_result_tb           : std_logic;
    signal enable_overflow_from_alu_tb      : std_logic;
    signal enable_pc_to_bus_tb              : std_logic;
    signal enable_registers_to_bus_tb       : std_logic;
    signal enable_result_to_bus_tb          : std_logic;
    signal enable_shift_out_to_carry_in_tb  : std_logic;
    signal enable_shift_out_to_shift_in_tb  : std_logic;
    signal enable_shifter_to_result_tb      : std_logic;
    signal enable_superreg_read_tb          : std_logic;
    signal enable_superreg_write_tb         : std_logic;
    signal enable_usr_from_bus_tb           : std_logic;
    signal enable_usr_to_bus_tb             : std_logic;
    signal enable_zero_to_usr_tb            : std_logic;
    signal load_carry_bit_tb                : std_logic;
    signal load_data_address_latch_tb       : std_logic;
    signal load_operand_tb                  : std_logic;
    signal load_overflow_bit_tb             : std_logic;
    signal load_pc_tb                       : std_logic;
    signal load_result_latch_tb             : std_logic;
    signal load_shift_tb                    : std_logic;
    signal load_zero_bit_tb                 : std_logic;
    signal mem_read_not_write_tb            : std_logic;
    signal memreq_tb                        : std_logic;
    signal read_mmu_tb                      : std_logic;
    signal shift_left_not_right_tb          : std_logic;
    signal shift_out_bit_tb                 : std_logic;
    signal sregaddr_from_iword_not_ucode_tb : std_logic;
    signal superreg_addr_from_ucode_tb      : std_logic_vector(2 downto 0);
    signal superset_tb                      : std_logic_vector(4 downto 0);
    signal superset_not_bus_tb              : std_logic;
    signal uc_load_freeze_tb                : std_logic;
    signal uc_load_illegal_tb               : std_logic;
    signal uc_load_intenable_tb             : std_logic;
    signal uc_load_softint_tb               : std_logic;
    signal uc_load_superbit_tb              : std_logic;
    signal write_enable_registers_tb        : std_logic;
    signal write_mmu_tb                     : std_logic;
    signal write_to_registers_tb            : std_logic;
    
    -- Clock period
    constant clock_period : time := 10 ns;
    
begin
    -- Instantiate the device under test
    dut: ism
        port map (
            CLOCK                           => clock_tb,
            RESET_N                         => reset_n_tb,
            IBUS                            => ibus_tb,
            INTERRUPT                       => interrupt_tb,
            ALU_ADD                         => alu_add_tb,
            ALU_CARRY_IN                    => alu_carry_in_tb,
            BUS_NOT_SIGNEXTEND_TO_TEMP      => bus_not_signextend_to_temp_tb,
            CLOCK_INSTRUCTION_LATCH         => clock_instruction_latch_tb,
            CLOCK_PC                        => clock_pc_tb,
            EN_DATAADDR_TO_INTERNALBUS      => en_dataaddr_to_internalbus_tb,
            ENABLE_ADDER_TO_RESULT          => enable_adder_to_result_tb,
            ENABLE_AND_TO_RESULT            => enable_and_to_result_tb,
            ENABLE_BUS_TO_ALU               => enable_bus_to_alu_tb,
            ENABLE_CARRY_FROM_ALU           => enable_carry_from_alu_tb,
            ENABLE_CARRY_OUT_TO_SHIFT_IN    => enable_carry_out_to_shift_in_tb,
            ENABLE_CODEBUS_TO_LOGICAL       => enable_codebus_to_logical_tb,
            ENABLE_DATABUS_TO_LOGICAL       => enable_databus_to_logical_tb,
            ENABLE_DOWN_REGADDR_TO_REG      => enable_down_regaddr_to_reg_tb,
            ENABLE_EXTERNAL_TO_INTERNAL     => enable_external_to_internal_tb,
            ENABLE_GROUND_TO_BUS            => enable_ground_to_bus_tb,
            ENABLE_INSTRUCTION_STATE        => enable_instruction_state_tb,
            ENABLE_INTERNAL_TO_EXTERNAL     => enable_internal_to_external_tb,
            ENABLE_INVERT_TO_RESULT         => enable_invert_to_result_tb,
            ENABLE_LOAD_SHIFT               => enable_load_shift_tb,
            ENABLE_MMU_PHYS_TO_BUS          => enable_mmu_phys_to_bus_tb,
            ENABLE_OR_TO_RESULT             => enable_or_to_result_tb,
            ENABLE_OVERFLOW_FROM_ALU        => enable_overflow_from_alu_tb,
            ENABLE_PC_TO_BUS                => enable_pc_to_bus_tb,
            ENABLE_REGISTERS_TO_BUS         => enable_registers_to_bus_tb,
            ENABLE_RESULT_TO_BUS            => enable_result_to_bus_tb,
            ENABLE_SHIFT_OUT_TO_CARRY_IN    => enable_shift_out_to_carry_in_tb,
            ENABLE_SHIFT_OUT_TO_SHIFT_IN    => enable_shift_out_to_shift_in_tb,
            ENABLE_SHIFTER_TO_RESULT        => enable_shifter_to_result_tb,
            ENABLE_SUPERREG_READ            => enable_superreg_read_tb,
            ENABLE_SUPERREG_WRITE           => enable_superreg_write_tb,
            ENABLE_USR_FROM_BUS             => enable_usr_from_bus_tb,
            ENABLE_USR_TO_BUS               => enable_usr_to_bus_tb,
            ENABLE_ZERO_TO_USR              => enable_zero_to_usr_tb,
            LOAD_CARRY_BIT                  => load_carry_bit_tb,
            LOAD_DATA_ADDRESS_LATCH         => load_data_address_latch_tb,
            LOAD_OPERAND                    => load_operand_tb,
            LOAD_OVERFLOW_BIT               => load_overflow_bit_tb,
            LOAD_PC                         => load_pc_tb,
            LOAD_RESULT_LATCH               => load_result_latch_tb,
            LOAD_SHIFT                      => load_shift_tb,
            LOAD_ZERO_BIT                   => load_zero_bit_tb,
            MEM_READ_NOT_WRITE              => mem_read_not_write_tb,
            MEMREQ                          => memreq_tb,
            READ_MMU                        => read_mmu_tb,
            SHIFT_LEFT_NOT_RIGHT            => shift_left_not_right_tb,
            SHIFT_OUT_BIT                   => shift_out_bit_tb,
            SREGADDR_FROM_IWORD_NOT_UCODE   => sregaddr_from_iword_not_ucode_tb,
            SUPERREG_ADDR_FROM_UCODE        => superreg_addr_from_ucode_tb,
            SUPERSET                        => superset_tb,
            SUPERSET_NOT_BUS                => superset_not_bus_tb,
            UC_LOAD_FREEZE                  => uc_load_freeze_tb,
            UC_LOAD_ILLEGAL                 => uc_load_illegal_tb,
            UC_LOAD_INTENABLE               => uc_load_intenable_tb,
            UC_LOAD_SOFTINT                 => uc_load_softint_tb,
            UC_LOAD_SUPERBIT               => uc_load_superbit_tb,
            WRITE_ENABLE_REGISTERS          => write_enable_registers_tb,
            WRITE_MMU                       => write_mmu_tb,
            WRITE_TO_REGISTERS              => write_to_registers_tb
        );
    
    -- Clock generation
    clock_process: process
    begin
        clock_tb <= '0';
        wait for clock_period / 2;
        clock_tb <= '1';
        wait for clock_period / 2;
    end process;
    
    -- Test stimulus
    stimulus_process: process
    begin
        -- Initialize
        report "Starting ISM testbench...";
        
        -- Test reset sequence
        reset_n_tb <= '0';
        wait for 2 * clock_period;
        reset_n_tb <= '1';
        wait for clock_period;
        
        -- Should be in RESET_STATE, then go to IFETCH2
        wait for clock_period;
        assert enable_codebus_to_logical_tb = '1' report "RESET_STATE: ENABLE_CODEBUS_TO_LOGICAL should be '1'" severity error;
        assert mem_read_not_write_tb = '1' report "RESET_STATE: MEM_READ_NOT_WRITE should be '1'" severity error;
        assert superset_not_bus_tb = '1' report "RESET_STATE: SUPERSET_NOT_BUS should be '1'" severity error;
        assert superset_tb = "00001" report "RESET_STATE: SUPERSET should be '00001'" severity error;
        
        wait for clock_period;
        -- Now should be in IFETCH2
        assert memreq_tb = '1' report "IFETCH2: MEMREQ should be '1'" severity error;
        assert clock_pc_tb = '0' report "IFETCH2: CLOCK_PC should be '0'" severity error;
        
        wait for clock_period;
        -- Now should be in IFETCH3
        assert clock_instruction_latch_tb = '0' report "IFETCH3: CLOCK_INSTRUCTION_LATCH should be '0'" severity error;
        
        -- Test MOVE instruction decode
        ibus_tb <= "000001"; -- MOVE instruction pattern
        wait for clock_period;
        -- Should go to MOVE1
        assert enable_registers_to_bus_tb = '1' report "MOVE1: ENABLE_REGISTERS_TO_BUS should be '1'" severity error;
        assert enable_down_regaddr_to_reg_tb = '0' report "MOVE1: ENABLE_DOWN_REGADDR_TO_REG should be '0'" severity error;
        
        wait for clock_period;
        -- Should be in MOVE2
        assert load_data_address_latch_tb = '1' report "MOVE2: LOAD_DATA_ADDRESS_LATCH should be '1'" severity error;
        
        wait for clock_period;
        -- Should be in MOVE3
        assert enable_registers_to_bus_tb = '0' report "MOVE3: ENABLE_REGISTERS_TO_BUS should be '0'" severity error;
        assert enable_down_regaddr_to_reg_tb = '1' report "MOVE3: ENABLE_DOWN_REGADDR_TO_REG should be '1'" severity error;
        assert en_dataaddr_to_internalbus_tb = '1' report "MOVE3: EN_DATAADDR_TO_INTERNALBUS should be '1'" severity error;
        
        wait for clock_period;
        -- Should be in MOVE4
        assert write_enable_registers_tb = '0' report "MOVE4: WRITE_ENABLE_REGISTERS should be '0'" severity error;
        
        wait for clock_period;
        -- Should be in MOVE5
        assert write_to_registers_tb = '1' report "MOVE5: WRITE_TO_REGISTERS should be '1'" severity error;
        
        wait for clock_period;
        -- Should go back to IFETCH1
        assert clock_pc_tb = '1' report "IFETCH1: CLOCK_PC should be '1'" severity error;
        assert enable_codebus_to_logical_tb = '1' report "IFETCH1: ENABLE_CODEBUS_TO_LOGICAL should be '1'" severity error;
        assert enable_external_to_internal_tb = '1' report "IFETCH1: ENABLE_EXTERNAL_TO_INTERNAL should be '1'" severity error;
        
        -- Test unknown instruction (should go back to IFETCH1)
        wait for 2 * clock_period; -- Through IFETCH2
        ibus_tb <= "111111"; -- Unknown instruction
        wait for clock_period;
        -- Should go back to IFETCH1 after IFETCH3
        wait for clock_period;
        assert clock_pc_tb = '1' report "Unknown instruction should return to IFETCH1" severity error;
        
        wait for 5 * clock_period;
        
        report "ISM testbench completed successfully!";
        wait;
    end process;
    
end architecture sim;