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
        IBUS                            : in  std_logic_vector(15 downto 0);  -- Full 16-bit instruction
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
        WRITE_TO_REGISTERS              : out std_logic;
        -- Additional outputs for debugging and integration
        CURRENT_STATE_OUT               : out std_logic_vector(7 downto 0);
        INSTRUCTION_OPCODE              : out std_logic_vector(5 downto 0);
        OPERAND1                        : out std_logic_vector(4 downto 0);
        OPERAND2                        : out std_logic_vector(4 downto 0)
    );
end entity ism;

architecture behavioral of ism is
    -- State machine type definition
    type state_type is (
        RESET_STATE,
        IFETCH1,
        IFETCH2, 
        IFETCH3,
        -- Data Movement Instructions
        MOVE1, MOVE2, MOVE3, MOVE4, MOVE5,
        LOAD1, LOAD2, LOAD3,
        STORE1, STORE2, STORE3,
        LOADIMM1, LOADIMM2, LOADIMM3,
        -- Arithmetic Instructions  
        ADD1, ADD2, ADD3,
        SUB1, SUB2, SUB3,
        -- Logical Instructions
        AND1, AND2, AND3,
        OR1, OR2, OR3,
        NOT1, NOT2, NOT3,
        -- Shift Instructions
        SHIFTL1, SHIFTL2, SHIFTL3,
        SHIFTR1, SHIFTR2, SHIFTR3,
        -- Jump Instructions
        JUMPABS1, JUMPABS2,
        JUMPREL1, JUMPREL2,
        JUMPRIMM1, JUMPRIMM2, JUMPRIMM3,
        JUMPRIMMC1, JUMPRIMMC2, JUMPRIMMC3,
        JUMPRIMMZ1, JUMPRIMMZ2, JUMPRIMMZ3,
        JUMPRIMMO1, JUMPRIMMO2, JUMPRIMMO3,
        -- System Instructions
        SYSCALL1, SYSCALL2,
        SUPERSWAP1, SUPERSWAP2, SUPERSWAP3
    );
    
    signal current_state, next_state : state_type;
    
    -- Instruction decode signals
    signal instruction_opcode : std_logic_vector(5 downto 0);
    signal instruction_format : std_logic_vector(1 downto 0);
    signal operand1 : std_logic_vector(4 downto 0);
    signal operand2 : std_logic_vector(4 downto 0);
    signal short_immediate : std_logic_vector(4 downto 0);
    
    -- Full 16-bit instruction word input (expanded from 6-bit IBUS)
    signal INSTRUCTION : std_logic_vector(15 downto 0);
    
    -- Constants for instruction opcodes (matching JavaScript simulator)
    constant OPCODE_LOAD     : std_logic_vector(5 downto 0) := "000000";  -- 0
    constant OPCODE_STORE    : std_logic_vector(5 downto 0) := "000001";  -- 1  
    constant OPCODE_MOVE     : std_logic_vector(5 downto 0) := "000010";  -- 2
    constant OPCODE_SHIFTL   : std_logic_vector(5 downto 0) := "000011";  -- 3
    constant OPCODE_SHIFTR   : std_logic_vector(5 downto 0) := "000100";  -- 4
    constant OPCODE_JUMPABS  : std_logic_vector(5 downto 0) := "000101";  -- 5
    constant OPCODE_JUMPRIMM : std_logic_vector(5 downto 0) := "000110";  -- 6
    constant OPCODE_JUMPRIMMC: std_logic_vector(5 downto 0) := "000111";  -- 7
    constant OPCODE_JUMPRIMMZ: std_logic_vector(5 downto 0) := "001000";  -- 8
    constant OPCODE_JUMPRIMMO: std_logic_vector(5 downto 0) := "001001";  -- 9
    constant OPCODE_JUMPREL  : std_logic_vector(5 downto 0) := "001010";  -- 10
    constant OPCODE_ADD      : std_logic_vector(5 downto 0) := "001011";  -- 11
    constant OPCODE_SUB      : std_logic_vector(5 downto 0) := "001100";  -- 12
    constant OPCODE_LOADIMM  : std_logic_vector(5 downto 0) := "010000";  -- 16
    constant OPCODE_SUPERSWAP: std_logic_vector(5 downto 0) := "100000";  -- 32
    constant OPCODE_AND      : std_logic_vector(5 downto 0) := "100001";  -- 33
    constant OPCODE_OR       : std_logic_vector(5 downto 0) := "100010";  -- 34
    constant OPCODE_NOT      : std_logic_vector(5 downto 0) := "100011";  -- 35
    constant OPCODE_SYSCALL  : std_logic_vector(5 downto 0) := "110000";  -- 48
    
    -- Format constants
    constant FORMAT_LOADIMM  : std_logic_vector(1 downto 0) := "01";  -- Format 1
    constant FORMAT_REGULAR  : std_logic_vector(1 downto 0) := "10";  -- Format 2
    
begin
    -- Instruction decode - extract fields from 16-bit instruction word
    instruction_format <= IBUS(15 downto 14);
    instruction_opcode <= IBUS(13 downto 8);
    operand1 <= IBUS(9 downto 5);
    operand2 <= IBUS(4 downto 0);
    short_immediate <= IBUS(4 downto 0);  -- For immediate addressing

    -- Connect to output ports for debugging
    INSTRUCTION_OPCODE <= instruction_opcode;
    OPERAND1 <= operand1;
    OPERAND2 <= operand2;
    
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
                -- Complete instruction decode based on opcode
                case instruction_opcode is
                    when OPCODE_MOVE =>
                        next_state <= MOVE1;
                    when OPCODE_LOAD =>
                        next_state <= LOAD1;
                    when OPCODE_STORE =>
                        next_state <= STORE1;
                    when OPCODE_LOADIMM =>
                        next_state <= LOADIMM1;
                    when OPCODE_ADD =>
                        next_state <= ADD1;
                    when OPCODE_SUB =>
                        next_state <= SUB1;
                    when OPCODE_AND =>
                        next_state <= AND1;
                    when OPCODE_OR =>
                        next_state <= OR1;
                    when OPCODE_NOT =>
                        next_state <= NOT1;
                    when OPCODE_SHIFTL =>
                        next_state <= SHIFTL1;
                    when OPCODE_SHIFTR =>
                        next_state <= SHIFTR1;
                    when OPCODE_JUMPABS =>
                        next_state <= JUMPABS1;
                    when OPCODE_JUMPREL =>
                        next_state <= JUMPREL1;
                    when OPCODE_JUMPRIMM =>
                        next_state <= JUMPRIMM1;
                    when OPCODE_JUMPRIMMC =>
                        next_state <= JUMPRIMMC1;
                    when OPCODE_JUMPRIMMZ =>
                        next_state <= JUMPRIMMZ1;
                    when OPCODE_JUMPRIMMO =>
                        next_state <= JUMPRIMMO1;
                    when OPCODE_SYSCALL =>
                        next_state <= SYSCALL1;
                    when OPCODE_SUPERSWAP =>
                        next_state <= SUPERSWAP1;
                    when others =>
                        -- Illegal instruction - return to IFETCH1
                        next_state <= IFETCH1;
                end case;
                
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

            -- LOAD instruction states
            when LOAD1 =>
                next_state <= LOAD2;
            when LOAD2 =>
                next_state <= LOAD3;
            when LOAD3 =>
                next_state <= IFETCH1;

            -- STORE instruction states
            when STORE1 =>
                next_state <= STORE2;
            when STORE2 =>
                next_state <= STORE3;
            when STORE3 =>
                next_state <= IFETCH1;

            -- LOADIMM instruction states
            when LOADIMM1 =>
                next_state <= LOADIMM2;
            when LOADIMM2 =>
                next_state <= LOADIMM3;
            when LOADIMM3 =>
                next_state <= IFETCH1;

            -- Arithmetic instruction states
            when ADD1 =>
                next_state <= ADD2;
            when ADD2 =>
                next_state <= ADD3;
            when ADD3 =>
                next_state <= IFETCH1;

            when SUB1 =>
                next_state <= SUB2;
            when SUB2 =>
                next_state <= SUB3;
            when SUB3 =>
                next_state <= IFETCH1;

            -- Logical instruction states
            when AND1 =>
                next_state <= AND2;
            when AND2 =>
                next_state <= AND3;
            when AND3 =>
                next_state <= IFETCH1;

            when OR1 =>
                next_state <= OR2;
            when OR2 =>
                next_state <= OR3;
            when OR3 =>
                next_state <= IFETCH1;

            when NOT1 =>
                next_state <= NOT2;
            when NOT2 =>
                next_state <= NOT3;
            when NOT3 =>
                next_state <= IFETCH1;

            -- Shift instruction states
            when SHIFTL1 =>
                next_state <= SHIFTL2;
            when SHIFTL2 =>
                next_state <= SHIFTL3;
            when SHIFTL3 =>
                next_state <= IFETCH1;

            when SHIFTR1 =>
                next_state <= SHIFTR2;
            when SHIFTR2 =>
                next_state <= SHIFTR3;
            when SHIFTR3 =>
                next_state <= IFETCH1;

            -- Jump instruction states
            when JUMPABS1 =>
                next_state <= JUMPABS2;
            when JUMPABS2 =>
                next_state <= IFETCH1;

            when JUMPREL1 =>
                next_state <= JUMPREL2;
            when JUMPREL2 =>
                next_state <= IFETCH1;

            when JUMPRIMM1 =>
                next_state <= JUMPRIMM2;
            when JUMPRIMM2 =>
                next_state <= JUMPRIMM3;
            when JUMPRIMM3 =>
                next_state <= IFETCH1;

            when JUMPRIMMC1 =>
                next_state <= JUMPRIMMC2;
            when JUMPRIMMC2 =>
                next_state <= JUMPRIMMC3;
            when JUMPRIMMC3 =>
                next_state <= IFETCH1;

            when JUMPRIMMZ1 =>
                next_state <= JUMPRIMMZ2;
            when JUMPRIMMZ2 =>
                next_state <= JUMPRIMMZ3;
            when JUMPRIMMZ3 =>
                next_state <= IFETCH1;

            when JUMPRIMMO1 =>
                next_state <= JUMPRIMMO2;
            when JUMPRIMMO2 =>
                next_state <= JUMPRIMMO3;
            when JUMPRIMMO3 =>
                next_state <= IFETCH1;

            -- System instruction states
            when SYSCALL1 =>
                next_state <= SYSCALL2;
            when SYSCALL2 =>
                next_state <= IFETCH1;

            when SUPERSWAP1 =>
                next_state <= SUPERSWAP2;
            when SUPERSWAP2 =>
                next_state <= SUPERSWAP3;
            when SUPERSWAP3 =>
                next_state <= IFETCH1;

            when others =>
                next_state <= RESET_STATE;
        end case;
    end process;

    -- State encoding for debug output
    debug_encoding: process(current_state)
    begin
        case current_state is
            when RESET_STATE => CURRENT_STATE_OUT <= x"00";
            when IFETCH1     => CURRENT_STATE_OUT <= x"01";
            when IFETCH2     => CURRENT_STATE_OUT <= x"02";
            when IFETCH3     => CURRENT_STATE_OUT <= x"03";
            when MOVE1       => CURRENT_STATE_OUT <= x"10";
            when MOVE2       => CURRENT_STATE_OUT <= x"11";
            when MOVE3       => CURRENT_STATE_OUT <= x"12";
            when MOVE4       => CURRENT_STATE_OUT <= x"13";
            when MOVE5       => CURRENT_STATE_OUT <= x"14";
            when LOAD1       => CURRENT_STATE_OUT <= x"20";
            when LOAD2       => CURRENT_STATE_OUT <= x"21";
            when LOAD3       => CURRENT_STATE_OUT <= x"22";
            when STORE1      => CURRENT_STATE_OUT <= x"30";
            when STORE2      => CURRENT_STATE_OUT <= x"31";
            when STORE3      => CURRENT_STATE_OUT <= x"32";
            when LOADIMM1    => CURRENT_STATE_OUT <= x"40";
            when LOADIMM2    => CURRENT_STATE_OUT <= x"41";
            when LOADIMM3    => CURRENT_STATE_OUT <= x"42";
            when ADD1        => CURRENT_STATE_OUT <= x"50";
            when ADD2        => CURRENT_STATE_OUT <= x"51";
            when ADD3        => CURRENT_STATE_OUT <= x"52";
            when SUB1        => CURRENT_STATE_OUT <= x"60";
            when SUB2        => CURRENT_STATE_OUT <= x"61";
            when SUB3        => CURRENT_STATE_OUT <= x"62";
            when AND1        => CURRENT_STATE_OUT <= x"70";
            when AND2        => CURRENT_STATE_OUT <= x"71";
            when AND3        => CURRENT_STATE_OUT <= x"72";
            when OR1         => CURRENT_STATE_OUT <= x"80";
            when OR2         => CURRENT_STATE_OUT <= x"81";
            when OR3         => CURRENT_STATE_OUT <= x"82";
            when NOT1        => CURRENT_STATE_OUT <= x"90";
            when NOT2        => CURRENT_STATE_OUT <= x"91";
            when NOT3        => CURRENT_STATE_OUT <= x"92";
            when SHIFTL1     => CURRENT_STATE_OUT <= x"A0";
            when SHIFTL2     => CURRENT_STATE_OUT <= x"A1";
            when SHIFTL3     => CURRENT_STATE_OUT <= x"A2";
            when SHIFTR1     => CURRENT_STATE_OUT <= x"A3";
            when SHIFTR2     => CURRENT_STATE_OUT <= x"A4";
            when SHIFTR3     => CURRENT_STATE_OUT <= x"A5";
            when JUMPABS1    => CURRENT_STATE_OUT <= x"B0";
            when JUMPABS2    => CURRENT_STATE_OUT <= x"B1";
            when JUMPREL1    => CURRENT_STATE_OUT <= x"B2";
            when JUMPREL2    => CURRENT_STATE_OUT <= x"B3";
            when JUMPRIMM1   => CURRENT_STATE_OUT <= x"B4";
            when JUMPRIMM2   => CURRENT_STATE_OUT <= x"B5";
            when JUMPRIMM3   => CURRENT_STATE_OUT <= x"B6";
            when JUMPRIMMC1  => CURRENT_STATE_OUT <= x"B7";
            when JUMPRIMMC2  => CURRENT_STATE_OUT <= x"B8";
            when JUMPRIMMC3  => CURRENT_STATE_OUT <= x"B9";
            when JUMPRIMMZ1  => CURRENT_STATE_OUT <= x"BA";
            when JUMPRIMMZ2  => CURRENT_STATE_OUT <= x"BB";
            when JUMPRIMMZ3  => CURRENT_STATE_OUT <= x"BC";
            when JUMPRIMMO1  => CURRENT_STATE_OUT <= x"BD";
            when JUMPRIMMO2  => CURRENT_STATE_OUT <= x"BE";
            when JUMPRIMMO3  => CURRENT_STATE_OUT <= x"BF";
            when SYSCALL1    => CURRENT_STATE_OUT <= x"C0";
            when SYSCALL2    => CURRENT_STATE_OUT <= x"C1";
            when SUPERSWAP1  => CURRENT_STATE_OUT <= x"C2";
            when SUPERSWAP2  => CURRENT_STATE_OUT <= x"C3";
            when SUPERSWAP3  => CURRENT_STATE_OUT <= x"C4";
            when others      => CURRENT_STATE_OUT <= x"FF";
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

            -- LOAD instruction states
            when LOAD1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable source register address
                ENABLE_REGISTERS_TO_BUS     <= '1';  -- Put address on bus

            when LOAD2 =>
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';  -- Enable memory read
                MEMREQ                      <= '1';  -- Request memory access
                MEM_READ_NOT_WRITE          <= '1';  -- Set for read operation

            when LOAD3 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';  -- Enable dest register address
                WRITE_TO_REGISTERS          <= '1';  -- Write loaded data to register

            -- STORE instruction states
            when STORE1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable source register (data)
                ENABLE_REGISTERS_TO_BUS     <= '1';  -- Put data on bus

            when STORE2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';  -- Enable address register
                ENABLE_INTERNAL_TO_EXTERNAL <= '1';  -- Enable memory write
                MEMREQ                      <= '1';  -- Request memory access
                MEM_READ_NOT_WRITE          <= '0';  -- Set for write operation

            when STORE3 =>
                -- Complete store operation
                null;

            -- LOADIMM instruction states
            when LOADIMM1 =>
                INCREMENT_PC                <= '1';  -- Move to next word (immediate)
                MEMREQ                      <= '1';  -- Fetch immediate value
                MEM_READ_NOT_WRITE          <= '1';

            when LOADIMM2 =>
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';  -- Get immediate from memory
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable destination register

            when LOADIMM3 =>
                WRITE_TO_REGISTERS          <= '1';  -- Write immediate to register

            -- ADD instruction states
            when ADD1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable first operand
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_BUS_TO_ALU           <= '1';

            when ADD2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';  -- Enable second operand
                ENABLE_TEMP_TO_ALU          <= '1';  -- Use temp register
                ALU_ADD                     <= '1';  -- Set ALU to add mode
                ENABLE_ADDER_TO_RESULT      <= '1';

            when ADD3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                ENABLE_CARRY_FROM_ALU       <= '1';
                UPDATE_FLAGS                <= '1';

            -- SUB instruction states
            when SUB1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_BUS_TO_ALU           <= '1';

            when SUB2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_TEMP_TO_ALU          <= '1';
                ALU_ADD                     <= '0';  -- Set ALU to subtract mode
                ENABLE_ADDER_TO_RESULT      <= '1';

            when SUB3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                ENABLE_CARRY_FROM_ALU       <= '1';
                UPDATE_FLAGS                <= '1';

            -- AND instruction states
            when AND1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';

            when AND2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_DATABUS_TO_LOGICAL   <= '1';
                ENABLE_AND_TO_RESULT        <= '1';

            when AND3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                UPDATE_FLAGS                <= '1';

            -- OR instruction states
            when OR1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';

            when OR2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_DATABUS_TO_LOGICAL   <= '1';
                ENABLE_OR_TO_RESULT         <= '1';

            when OR3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                UPDATE_FLAGS                <= '1';

            -- NOT instruction states
            when NOT1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_CODEBUS_TO_LOGICAL   <= '1';

            when NOT2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_INVERT_TO_RESULT     <= '1';

            when NOT3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                UPDATE_FLAGS                <= '1';

            -- SHIFTL instruction states
            when SHIFTL1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_LOAD_SHIFT           <= '1';
                SHIFT_LEFT_NOT_RIGHT        <= '1';

            when SHIFTL2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_SHIFTER_TO_RESULT    <= '1';
                ENABLE_SHIFT_OUT_TO_CARRY_IN <= '1';

            when SHIFTL3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                UPDATE_FLAGS                <= '1';

            -- SHIFTR instruction states
            when SHIFTR1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_LOAD_SHIFT           <= '1';
                SHIFT_LEFT_NOT_RIGHT        <= '0';

            when SHIFTR2 =>
                ENABLE_UP_REGADDR_TO_REG    <= '1';
                ENABLE_SHIFTER_TO_RESULT    <= '1';
                ENABLE_SHIFT_OUT_TO_CARRY_IN <= '1';

            when SHIFTR3 =>
                ENABLE_RESULT_TO_BUS        <= '1';
                WRITE_TO_REGISTERS          <= '1';
                UPDATE_FLAGS                <= '1';

            -- JUMPABS instruction states
            when JUMPABS1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable register with jump address
                ENABLE_REGISTERS_TO_BUS     <= '1';  -- Put address on bus

            when JUMPABS2 =>
                LOAD_PC                     <= '1';  -- Load new PC value
                ENABLE_PC_TO_BUS            <= '1';

            -- JUMPREL instruction states
            when JUMPREL1 =>
                ENABLE_DOWN_REGADDR_TO_REG  <= '1';  -- Enable register with offset
                ENABLE_REGISTERS_TO_BUS     <= '1';
                ENABLE_PC_TO_BUS            <= '1';  -- Add to current PC

            when JUMPREL2 =>
                ENABLE_ADDER_TO_RESULT      <= '1';  -- PC + offset
                ALU_ADD                     <= '1';
                LOAD_PC                     <= '1';

            -- JUMPRIMM instruction states
            when JUMPRIMM1 =>
                INCREMENT_PC                <= '1';  -- Skip to next word
                MEMREQ                      <= '1';  -- Fetch offset
                MEM_READ_NOT_WRITE          <= '1';

            when JUMPRIMM2 =>
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';  -- Get offset from memory
                ENABLE_PC_TO_BUS            <= '1';  -- Current PC

            when JUMPRIMM3 =>
                ENABLE_ADDER_TO_RESULT      <= '1';  -- PC + offset
                ALU_ADD                     <= '1';
                LOAD_PC                     <= '1';

            -- JUMPRIMMC instruction states (jump if carry)
            when JUMPRIMMC1 =>
                INCREMENT_PC                <= '1';
                MEMREQ                      <= '1';
                MEM_READ_NOT_WRITE          <= '1';

            when JUMPRIMMC2 =>
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';
                -- Check carry flag condition here (implementation dependent)

            when JUMPRIMMC3 =>
                -- Conditional jump based on carry flag
                ENABLE_ADDER_TO_RESULT      <= '1';
                ALU_ADD                     <= '1';
                LOAD_PC                     <= '1';  -- Only if carry set

            -- JUMPRIMMZ instruction states (jump if zero)
            when JUMPRIMMZ1 =>
                INCREMENT_PC                <= '1';
                MEMREQ                      <= '1';
                MEM_READ_NOT_WRITE          <= '1';

            when JUMPRIMMZ2 =>
                ENABLE_EXTERNAL_TO_INTERNAL <= '1';
                -- Check zero flag condition here (implementation dependent)

            when JUMPRIMMZ3 =>
                -- Conditional jump based on zero flag
                ENABLE_ADDER_TO_RESULT      <= '1';
                ALU_ADD                     <= '1';
                LOAD_PC                     <= '1';  -- Only if zero set

            -- SYSCALL instruction states
            when SYSCALL1 =>
                -- Save current state and switch to supervisor mode
                UC_LOAD_SUPERBIT           <= '1';  -- Enter supervisor mode
                UC_LOAD_SOFTINT             <= '1';  -- Set software interrupt
                ENABLE_SUPERREG_WRITE       <= '1';  -- Save PC to supervisor register

            when SYSCALL2 =>
                -- Jump to system call handler
                SUPERREG_ADDR_FROM_UCODE    <= "010";  -- SR2 contains handler address
                ENABLE_SUPERREG_READ        <= '1';
                LOAD_PC                     <= '1';

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