-- F00 CPU - Simple Online Version for EDA Playground
-- Single file, no component instantiation issues
-- Copy this entire file to design.vhd in EDA Playground

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity f00_cpu_simple is
    port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;
        -- Debug outputs
        debug_pc    : out std_logic_vector(15 downto 0);
        debug_state : out std_logic_vector(7 downto 0);
        debug_reg1  : out std_logic_vector(15 downto 0);
        debug_reg2  : out std_logic_vector(15 downto 0);
        debug_reg3  : out std_logic_vector(15 downto 0);
        debug_reg4  : out std_logic_vector(15 downto 0);
        debug_flags : out std_logic_vector(2 downto 0);
        debug_instr : out std_logic_vector(15 downto 0)
    );
end entity f00_cpu_simple;

architecture behavioral of f00_cpu_simple is

    -- State machine
    type state_t is (RESET_ST, FETCH, DECODE, EXECUTE, WRITEBACK);
    signal state : state_t := RESET_ST;
    signal state_counter : integer := 0;

    -- Program counter
    signal pc : unsigned(15 downto 0) := (others => '0');

    -- Instruction memory (hardcoded test program)
    type imem_t is array (0 to 15) of std_logic_vector(15 downto 0);
    signal imem : imem_t := (
        -- Test all supported opcodes
        0  => x"4120",  -- LOADIMM R9, 0x1234 (01 010000 01001 00000)
        1  => x"1234",  -- immediate value 0x1234
        2  => x"4140",  -- LOADIMM R10, 0x5678 (01 010000 01010 00000)
        3  => x"5678",  -- immediate value 0x5678
        4  => x"4160",  -- LOADIMM R11, 0xAAAA (01 010000 01011 00000)
        5  => x"AAAA",  -- immediate value 0xAAAA
        6  => x"4180",  -- LOADIMM R12, 0x5555 (01 010000 01100 00000)
        7  => x"5555",  -- immediate value 0x5555

        -- Test arithmetic instructions
        8  => x"8B4A",  -- ADD R9,R10 -> R10 = 0x1234 + 0x5678 = 0x68AC
        9  => x"8C4A",  -- SUB R9,R10 -> R10 = 0x1234 - 0x68AC (opcode=001100)

        -- Test logical instructions (corrected encodings)
        10 => x"C16C",  -- AND R11,R12 -> R12 = 0xAAAA & 0x5555 = 0x0000 (10 100001 01011 01100)
        11 => x"C56C",  -- OR R11,R12 -> R12 = 0xAAAA | 0x0000 = 0xAAAA (10 100010 01011 01100)
        12 => x"C96C",  -- NOT R11,R12 -> R12 = ~0xAAAA = 0x5555 (10 100011 01011 01100)

        -- Test move instruction
        13 => x"814D",  -- MOVE R10,R13 -> R13 = R10 (format=10, opcode=000010)

        14 => x"0000",  -- NOP (end of program)
        others => x"0000"
    );

    -- Current instruction and decode signals
    signal instruction : std_logic_vector(15 downto 0) := (others => '0');
    signal format : std_logic_vector(1 downto 0);
    signal opcode : std_logic_vector(5 downto 0);
    signal operand1 : unsigned(4 downto 0);
    signal operand2 : unsigned(4 downto 0);

    -- Register file (32 registers x 16 bits)
    type reg_array_t is array (0 to 31) of std_logic_vector(15 downto 0);
    signal registers : reg_array_t := (others => (others => '0'));

    -- ALU and flags
    signal alu_a : std_logic_vector(15 downto 0) := (others => '0');
    signal alu_b : std_logic_vector(15 downto 0) := (others => '0');
    signal alu_result : std_logic_vector(16 downto 0) := (others => '0');
    signal carry_flag : std_logic := '0';
    signal zero_flag : std_logic := '0';
    signal overflow_flag : std_logic := '0';

    -- Execution control
    signal reg_write_enable : std_logic := '0';
    signal reg_write_addr : integer range 0 to 31 := 0;
    signal reg_write_data : std_logic_vector(15 downto 0) := (others => '0');


begin

    -- Instruction fetch
    instruction <= imem(to_integer(pc)) when pc < imem'length else x"0000";

    -- Instruction decode
    format <= instruction(15 downto 14);
    opcode <= instruction(13 downto 8);
    operand1 <= unsigned(instruction(9 downto 5));
    operand2 <= unsigned(instruction(4 downto 0));

    -- Main CPU process
    cpu_process: process(clk, reset_n)
        variable reg_addr : integer;
        variable temp_result : signed(16 downto 0);
    begin
        if reset_n = '0' then
            -- Reset all state
            state <= RESET_ST;
            pc <= (others => '0');
            carry_flag <= '0';
            zero_flag <= '0';
            overflow_flag <= '0';
            registers <= (others => (others => '0'));
            state_counter <= 0;

        elsif rising_edge(clk) then
            state_counter <= state_counter + 1;

            case state is
                when RESET_ST =>
                    pc <= (others => '0');
                    state <= FETCH;

                when FETCH =>
                    -- Fetch instruction
                    state <= DECODE;

                when DECODE =>
                    -- Decode instruction
                    state <= EXECUTE;

                when EXECUTE =>
                    -- Prepare execution based on opcode
                    reg_write_enable <= '0';  -- Default: no write
                    pc <= pc + 1;             -- Default: increment PC

                    case opcode is
                        when "010000" => -- LOADIMM (opcode 16, format should be 01)
                            if format = "01" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 and (pc + 1) < imem'length then
                                    -- Prepare register write for next cycle
                                    reg_write_enable <= '1';
                                    reg_write_addr <= reg_addr;
                                    reg_write_data <= imem(to_integer(pc + 1));
                                    pc <= pc + 2;  -- Skip immediate word
                                    report "LOADIMM prepared" severity note;
                                else
                                    report "LOADIMM condition failed" severity note;
                                end if;
                            else
                                report "LOADIMM format check failed" severity note;
                            end if;

                        when "000010" => -- MOVE (opcode 2)
                            if format = "10" then
                                reg_addr := to_integer(operand1);  -- Source register
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);  -- Destination register
                                    if reg_addr < 32 then
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= registers(to_integer(operand1));
                                    end if;
                                end if;
                            end if;

                        when "001011" => -- ADD (opcode 11)
                            if format = "10" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);
                                    if reg_addr < 32 then
                                        -- Perform addition
                                        temp_result := signed('0' & registers(to_integer(operand1))) + signed('0' & registers(reg_addr));
                                        -- Prepare register write
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= std_logic_vector(temp_result(15 downto 0));
                                        -- Update flags
                                        carry_flag <= temp_result(16);
                                        if temp_result(15 downto 0) = x"0000" then
                                            zero_flag <= '1';
                                        else
                                            zero_flag <= '0';
                                        end if;
                                        report "ADD prepared" severity note;
                                    end if;
                                end if;
                            end if;

                        when "001100" => -- SUB (opcode 12)
                            if format = "10" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);
                                    if reg_addr < 32 then
                                        -- Perform subtraction
                                        temp_result := signed('0' & registers(to_integer(operand1))) - signed('0' & registers(reg_addr));
                                        -- Prepare register write
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= std_logic_vector(temp_result(15 downto 0));
                                        -- Update flags
                                        carry_flag <= temp_result(16);  -- borrow
                                        if temp_result(15 downto 0) = x"0000" then
                                            zero_flag <= '1';
                                        else
                                            zero_flag <= '0';
                                        end if;
                                        report "SUB prepared" severity note;
                                    end if;
                                end if;
                            end if;

                        when "100001" => -- AND (opcode 33)
                            if format = "10" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);
                                    if reg_addr < 32 then
                                        -- Perform bitwise AND
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= registers(to_integer(operand1)) and registers(reg_addr);
                                        -- Update zero flag
                                        if (registers(to_integer(operand1)) and registers(reg_addr)) = x"0000" then
                                            zero_flag <= '1';
                                        else
                                            zero_flag <= '0';
                                        end if;
                                        carry_flag <= '0';  -- Clear carry for logical ops
                                        report "AND prepared" severity note;
                                    end if;
                                end if;
                            end if;

                        when "100010" => -- OR (opcode 34)
                            if format = "10" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);
                                    if reg_addr < 32 then
                                        -- Perform bitwise OR
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= registers(to_integer(operand1)) or registers(reg_addr);
                                        -- Update zero flag
                                        if (registers(to_integer(operand1)) or registers(reg_addr)) = x"0000" then
                                            zero_flag <= '1';
                                        else
                                            zero_flag <= '0';
                                        end if;
                                        carry_flag <= '0';  -- Clear carry for logical ops
                                        report "OR prepared" severity note;
                                    end if;
                                end if;
                            end if;

                        when "100011" => -- NOT (opcode 35)
                            if format = "10" then
                                reg_addr := to_integer(operand1);
                                if reg_addr < 32 then
                                    reg_addr := to_integer(operand2);
                                    if reg_addr < 32 then
                                        -- Perform bitwise NOT
                                        reg_write_enable <= '1';
                                        reg_write_addr <= reg_addr;
                                        reg_write_data <= not registers(to_integer(operand1));
                                        -- Update zero flag
                                        if (not registers(to_integer(operand1))) = x"0000" then
                                            zero_flag <= '1';
                                        else
                                            zero_flag <= '0';
                                        end if;
                                        carry_flag <= '0';  -- Clear carry for logical ops
                                        report "NOT prepared" severity note;
                                    end if;
                                end if;
                            end if;

                        when others =>
                            -- Unknown instruction, default PC increment
                            null;
                    end case;

                    state <= WRITEBACK;

                when WRITEBACK =>
                    -- Complete instruction: apply register writes
                    if reg_write_enable = '1' then
                        registers(reg_write_addr) <= reg_write_data;
                        report "Register write: R" & integer'image(reg_write_addr) & " gets data" severity note;
                        -- Force immediate update to debug outputs for verification
                        if reg_write_addr = 4 then
                            report "Written to R4, should see in debug_reg1 next cycle" severity note;
                        elsif reg_write_addr = 5 then
                            report "Written to R5, should see in debug_reg2 next cycle" severity note;
                        end if;
                    end if;
                    state <= FETCH;

            end case;
        end if;
    end process;

    -- Debug outputs
    debug_pc <= std_logic_vector(pc);

    -- State encoding for debug (process for VHDL-93 compatibility)
    state_debug_process: process(state)
    begin
        case state is
            when RESET_ST => debug_state <= x"00";
            when FETCH => debug_state <= x"01";
            when DECODE => debug_state <= x"02";
            when EXECUTE => debug_state <= x"03";
            when WRITEBACK => debug_state <= x"04";
            when others => debug_state <= x"FF";
        end case;
    end process;

    -- Show register values for debugging (use actual written registers)
    debug_reg1 <= registers(9);  -- R9 (first register)
    debug_reg2 <= registers(10); -- R10 (second register)
    debug_reg3 <= registers(11); -- R11 (third register)
    debug_reg4 <= registers(12); -- R12 (fourth register)

    debug_flags <= overflow_flag & zero_flag & carry_flag;
    debug_instr <= instruction;

end architecture behavioral;