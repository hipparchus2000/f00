-- Instruction State Machine (ISM) for F00 CPU
-- Translated from ISM.abl to VHDL
-- Original Abel file created: 10/18/99 22:54:38
-- VHDL translation by Claude

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ism is
    port (
        -- Clock and reset
        CLOCK                           : in  std_logic;
        RESET_N                         : in  std_logic;  -- Active low reset
        
        -- Input ports
        IBUS                            : in  std_logic_vector(15 downto 10);
        INTERRUPT                       : in  std_logic;
        
        -- Output control signals
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
end entity ism;

architecture behavioral of ism is
    -- State machine type definition
    type state_type is (
        RESET_STATE,
        IFETCH1,
        IFETCH2, 
        IFETCH3,
        MOVE1,
        MOVE2,
        MOVE3,
        MOVE4,
        MOVE5
    );
    
    signal current_state, next_state : state_type;
    
    -- Instruction decode signals
    signal instruction_opcode : std_logic_vector(5 downto 0);
    
    -- Constants for instruction opcodes (from simulator and assembler)
    -- The original Abel code checks for specific instruction patterns
    -- IBUS==1 (binary 000001), IBUS==1024 (binary 10000000000), IBUS==2048 (binary 100000000000)
    -- But these should be 16-bit values, so we need to check the full instruction word
    constant MOVE_INSTRUCTION_1    : std_logic_vector(5 downto 0) := "000001";  -- 1
    constant MOVE_INSTRUCTION_1024 : std_logic_vector(5 downto 0) := "000010";  -- Simplified for 6-bit check
    constant MOVE_INSTRUCTION_2048 : std_logic_vector(5 downto 0) := "000100";  -- Simplified for 6-bit check
    
begin
    -- Convert IBUS to instruction opcode (simplified)
    instruction_opcode <= IBUS;
    
    -- State register process
    state_register: process(CLOCK, RESET_N)
    begin
        if RESET_N = '0' then
            current_state <= RESET_STATE;
        elsif rising_edge(CLOCK) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Next state logic
    next_state_logic: process(current_state, IBUS, instruction_opcode)
    begin
        case current_state is
            when RESET_STATE =>
                next_state <= IFETCH2;
                
            when IFETCH1 =>
                next_state <= IFETCH2;
                
            when IFETCH2 =>
                next_state <= IFETCH3;
                
            when IFETCH3 =>
                -- Instruction decode - check for MOVE instruction
                -- The original Abel checks: IF (IBUS==1) THEN MOVE1; IF (IBUS==1024) THEN MOVE1; IF (IBUS==2048) THEN MOVE1;
                -- IBUS is only 6 bits (15 downto 10), so we need to check against these patterns
                if IBUS = "000001" or IBUS = "000010" or IBUS = "000100" then
                    next_state <= MOVE1;
                else
                    -- For now, go back to IFETCH1 for unsupported instructions
                    -- TODO: Add other instruction implementations (LOAD, STORE, ADD, etc.)
                    next_state <= IFETCH1;
                end if;
                
            when MOVE1 =>
                next_state <= MOVE2;
                
            when MOVE2 =>
                next_state <= MOVE3;
                
            when MOVE3 =>
                next_state <= MOVE4;
                
            when MOVE4 =>
                next_state <= MOVE5;
                
            when MOVE5 =>
                next_state <= IFETCH1;
                
            when others =>
                next_state <= RESET_STATE;
        end case;
    end process;
    
    -- Output logic - combinatorial outputs based on current state
    output_logic: process(current_state)
    begin
        -- Default all outputs to '0' or appropriate inactive state
        ALU_ADD                         <= '0';
        ALU_CARRY_IN                    <= '0';
        BUS_NOT_SIGNEXTEND_TO_TEMP      <= '0';
        CLOCK_INSTRUCTION_LATCH         <= '0';
        CLOCK_PC                        <= '0';
        EN_DATAADDR_TO_INTERNALBUS      <= '0';
        ENABLE_ADDER_TO_RESULT          <= '0';
        ENABLE_AND_TO_RESULT            <= '0';
        ENABLE_BUS_TO_ALU               <= '0';
        ENABLE_CARRY_FROM_ALU           <= '0';
        ENABLE_CARRY_OUT_TO_SHIFT_IN    <= '0';
        ENABLE_CODEBUS_TO_LOGICAL       <= '0';
        ENABLE_DATABUS_TO_LOGICAL       <= '0';
        ENABLE_DOWN_REGADDR_TO_REG      <= '0';
        ENABLE_EXTERNAL_TO_INTERNAL     <= '0';
        ENABLE_GROUND_TO_BUS            <= '0';
        ENABLE_INSTRUCTION_STATE        <= '0';
        ENABLE_INTERNAL_TO_EXTERNAL     <= '0';
        ENABLE_INVERT_TO_RESULT         <= '0';
        ENABLE_LOAD_SHIFT               <= '0';
        ENABLE_MMU_PHYS_TO_BUS          <= '0';
        ENABLE_OR_TO_RESULT             <= '0';
        ENABLE_OVERFLOW_FROM_ALU        <= '0';
        ENABLE_PC_TO_BUS                <= '0';
        ENABLE_REGISTERS_TO_BUS         <= '0';
        ENABLE_RESULT_TO_BUS            <= '0';
        ENABLE_SHIFT_OUT_TO_CARRY_IN    <= '0';
        ENABLE_SHIFT_OUT_TO_SHIFT_IN    <= '0';
        ENABLE_SHIFTER_TO_RESULT        <= '0';
        ENABLE_SUPERREG_READ            <= '0';
        ENABLE_SUPERREG_WRITE           <= '0';
        ENABLE_USR_FROM_BUS             <= '0';
        ENABLE_USR_TO_BUS               <= '0';
        ENABLE_ZERO_TO_USR              <= '0';
        LOAD_CARRY_BIT                  <= '0';
        LOAD_DATA_ADDRESS_LATCH         <= '0';
        LOAD_OPERAND                    <= '0';
        LOAD_OVERFLOW_BIT               <= '0';
        LOAD_PC                         <= '0';
        LOAD_RESULT_LATCH               <= '0';
        LOAD_SHIFT                      <= '0';
        LOAD_ZERO_BIT                   <= '0';
        MEM_READ_NOT_WRITE              <= '0';
        MEMREQ                          <= '0';
        READ_MMU                        <= '0';
        SHIFT_LEFT_NOT_RIGHT            <= '0';
        SHIFT_OUT_BIT                   <= '0';
        SREGADDR_FROM_IWORD_NOT_UCODE   <= '0';
        SUPERREG_ADDR_FROM_UCODE        <= "000";
        SUPERSET                        <= "00000";
        SUPERSET_NOT_BUS                <= '0';
        UC_LOAD_FREEZE                  <= '0';
        UC_LOAD_ILLEGAL                 <= '0';
        UC_LOAD_INTENABLE               <= '0';
        UC_LOAD_SOFTINT                 <= '0';
        UC_LOAD_SUPERBIT               <= '0';
        WRITE_ENABLE_REGISTERS          <= '0';
        WRITE_MMU                       <= '0';
        WRITE_TO_REGISTERS              <= '0';
        
        -- State-specific outputs
        case current_state is
            when RESET_STATE =>
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';
                MEM_READ_NOT_WRITE          <= '1';
                UC_LOAD_SUPERBIT           <= '0';
                SUPERSET_NOT_BUS            <= '1';
                SUPERSET                    <= "00001";
                
            when IFETCH1 =>
                CLOCK_PC                    <= '1';
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';
                MEM_READ_NOT_WRITE          <= '1';
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';
                
            when IFETCH2 =>
                CLOCK_PC                    <= '0';
                MEMREQ                      <= '1';
                
            when IFETCH3 =>
                CLOCK_INSTRUCTION_LATCH     <= '0';
                
            when MOVE1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '0';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                
            when MOVE2 =>
                LOAD_DATA_ADDRESS_LATCH     <= '1';
                
            when MOVE3 =>
                ENABLE_REGISTERS_TO_BUS     <= '0';
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                EN_DATAADDR_TO_INTERNALBUS  <= '1';
                
            when MOVE4 =>
                WRITE_ENABLE_REGISTERS      <= '0';
                
            when MOVE5 =>
                WRITE_TO_REGISTERS          <= '1';
                
            when others =>
                -- Default state - same as RESET_STATE
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';
                MEM_READ_NOT_WRITE          <= '1';
                UC_LOAD_SUPERBIT           <= '0';
                SUPERSET_NOT_BUS            <= '1';
                SUPERSET                    <= "00001";
        end case;
    end process;
    
end architecture behavioral;