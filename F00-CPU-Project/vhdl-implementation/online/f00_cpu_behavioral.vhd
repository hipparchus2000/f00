-- F00 CPU - Behavioral Model for Online Simulation
-- Replaces Xilinx IP cores with behavioral VHDL for EDA Playground
-- URL: https://www.edaplayground.com

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Behavioral Register File (replaces Xilinx Block RAM)
entity register_file_behavioral is
    port (
        clk     : in  std_logic;
        we      : in  std_logic;
        addr_a  : in  std_logic_vector(4 downto 0);
        addr_b  : in  std_logic_vector(4 downto 0);
        data_in : in  std_logic_vector(15 downto 0);
        data_a  : out std_logic_vector(15 downto 0);
        data_b  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behavioral of register_file_behavioral is
    type reg_array_t is array (0 to 31) of std_logic_vector(15 downto 0);
    signal registers : reg_array_t := (others => x"0000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                registers(to_integer(unsigned(addr_a))) <= data_in;
            end if;
        end if;
    end process;

    data_a <= registers(to_integer(unsigned(addr_a)));
    data_b <= registers(to_integer(unsigned(addr_b)));
end architecture;

-- Behavioral Program Counter (replaces Xilinx Counter IP)
entity pc_counter_behavioral is
    port (
        clk  : in  std_logic;
        ce   : in  std_logic;
        sclr : in  std_logic;
        load : in  std_logic;
        din  : in  std_logic_vector(15 downto 0);
        q    : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behavioral of pc_counter_behavioral is
    signal count : unsigned(15 downto 0) := x"0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if sclr = '1' then
                count <= x"0000";
            elsif load = '1' then
                count <= unsigned(din);
            elsif ce = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;

    q <= std_logic_vector(count);
end architecture;

-- Behavioral ALU (replaces Xilinx Adder/Subtracter)
entity alu_behavioral is
    port (
        clk     : in  std_logic;
        a       : in  std_logic_vector(15 downto 0);
        b       : in  std_logic_vector(15 downto 0);
        op      : in  std_logic_vector(2 downto 0); -- 000=ADD, 001=SUB, 010=AND, 011=OR, 100=NOT, 101=SHL, 110=SHR
        result  : out std_logic_vector(15 downto 0);
        carry   : out std_logic;
        zero    : out std_logic
    );
end entity;

architecture behavioral of alu_behavioral is
    signal temp_result : std_logic_vector(16 downto 0);
    signal final_result : std_logic_vector(15 downto 0);
begin
    process(a, b, op)
    begin
        case op is
            when "000" => -- ADD
                temp_result <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
            when "001" => -- SUB
                temp_result <= std_logic_vector(unsigned('0' & a) - unsigned('0' & b));
            when "010" => -- AND
                temp_result <= '0' & (a and b);
            when "011" => -- OR
                temp_result <= '0' & (a or b);
            when "100" => -- NOT
                temp_result <= '0' & (not a);
            when "101" => -- SHIFT LEFT
                temp_result <= a & '0';
            when "110" => -- SHIFT RIGHT
                temp_result <= '0' & ('0' & a(15 downto 1));
            when others =>
                temp_result <= '0' & a;
        end case;
    end process;

    final_result <= temp_result(15 downto 0);
    result <= final_result;
    carry <= temp_result(16);
    zero <= '1' when final_result = x"0000" else '0';
end architecture;

-- Simplified F00 CPU for Online Simulation
entity f00_cpu_online is
    port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;
        -- Debug outputs
        debug_pc    : out std_logic_vector(15 downto 0);
        debug_state : out std_logic_vector(7 downto 0);
        debug_reg1  : out std_logic_vector(15 downto 0);
        debug_reg2  : out std_logic_vector(15 downto 0);
        debug_flags : out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavioral of f00_cpu_online is

    -- State machine
    type state_t is (RESET_ST, FETCH, DECODE, EXECUTE, WRITEBACK);
    signal state : state_t := RESET_ST;

    -- Program counter
    signal pc : unsigned(15 downto 0) := x"0000";
    signal pc_load : std_logic := '0';
    signal pc_ce : std_logic := '0';
    signal pc_new : unsigned(15 downto 0) := x"0000";

    -- Instruction memory (hardcoded test program)
    type imem_t is array (0 to 15) of std_logic_vector(15 downto 0);
    signal imem : imem_t := (
        0  => x"4100",  -- LOADIMM R1, next_word (01 010000 00001 00000)
        1  => x"1234",  -- immediate value 0x1234
        2  => x"4120",  -- LOADIMM R2, next_word (01 010000 00010 00000)
        3  => x"5678",  -- immediate value 0x5678
        4  => x"8B04",  -- ADD R1, R2 -> R2 (10 001011 00001 00010) = 0x68AC
        5  => x"8C22",  -- SUB R1, R2 -> R2 (10 001100 00001 00010) = 0x1234 - 0x68AC
        6  => x"8252",  -- MOVE R2, R3 (10 000010 00010 00011)
        7  => x"C143",  -- AND R1, R3 -> R3 (10 100001 00001 00011)
        8  => x"C244",  -- OR R2, R4 -> R4 (10 100010 00010 00100)
        9  => x"C345",  -- NOT R3, R5 -> R5 (10 100011 00011 00101)
        10 => x"8346",  -- SHIFTL R3, R6 -> R6 (10 000011 00011 00110)
        11 => x"8447",  -- SHIFTR R4, R7 -> R7 (10 000100 00100 00111)
        12 => x"0000", -- NOP (end of program)
        others => x"0000"
    );

    -- Current instruction
    signal instruction : std_logic_vector(15 downto 0);
    signal opcode : std_logic_vector(5 downto 0);
    signal format : std_logic_vector(1 downto 0);
    signal operand1 : unsigned(4 downto 0);
    signal operand2 : unsigned(4 downto 0);

    -- Register file signals
    signal reg_we : std_logic := '0';
    signal reg_addr_a : std_logic_vector(4 downto 0);
    signal reg_addr_b : std_logic_vector(4 downto 0);
    signal reg_data_in : std_logic_vector(15 downto 0);
    signal reg_data_a : std_logic_vector(15 downto 0);
    signal reg_data_b : std_logic_vector(15 downto 0);

    -- ALU signals
    signal alu_op : std_logic_vector(2 downto 0) := "000";
    signal alu_result : std_logic_vector(15 downto 0);
    signal alu_carry : std_logic;
    signal alu_zero : std_logic;

    -- Flags
    signal carry_flag : std_logic := '0';
    signal zero_flag : std_logic := '0';
    signal overflow_flag : std_logic := '0';

    component register_file_behavioral
        port (
            clk     : in  std_logic;
            we      : in  std_logic;
            addr_a  : in  std_logic_vector(4 downto 0);
            addr_b  : in  std_logic_vector(4 downto 0);
            data_in : in  std_logic_vector(15 downto 0);
            data_a  : out std_logic_vector(15 downto 0);
            data_b  : out std_logic_vector(15 downto 0)
        );
    end component;

    component alu_behavioral
        port (
            clk     : in  std_logic;
            a       : in  std_logic_vector(15 downto 0);
            b       : in  std_logic_vector(15 downto 0);
            op      : in  std_logic_vector(2 downto 0);
            result  : out std_logic_vector(15 downto 0);
            carry   : out std_logic;
            zero    : out std_logic
        );
    end component;

begin

    -- Instruction fetch
    instruction <= imem(to_integer(pc)) when pc < imem'length else x"0000";

    -- Instruction decode
    format <= instruction(15 downto 14);
    opcode <= instruction(13 downto 8);
    operand1 <= unsigned(instruction(9 downto 5));
    operand2 <= unsigned(instruction(4 downto 0));

    -- Register file instantiation
    reg_file: register_file_behavioral
        port map (
            clk     => clk,
            we      => reg_we,
            addr_a  => reg_addr_a,
            addr_b  => reg_addr_b,
            data_in => reg_data_in,
            data_a  => reg_data_a,
            data_b  => reg_data_b
        );

    -- ALU instantiation
    alu: alu_behavioral
        port map (
            clk     => clk,
            a       => reg_data_a,
            b       => reg_data_b,
            op      => alu_op,
            result  => alu_result,
            carry   => alu_carry,
            zero    => alu_zero
        );

    -- Main CPU process
    cpu_process: process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= RESET_ST;
            pc <= x"0000";
            carry_flag <= '0';
            zero_flag <= '0';
            overflow_flag <= '0';

        elsif rising_edge(clk) then
            case state is
                when RESET_ST =>
                    pc <= x"0000";
                    state <= FETCH;

                when FETCH =>
                    state <= DECODE;

                when DECODE =>
                    state <= EXECUTE;

                when EXECUTE =>
                    reg_we <= '0';  -- Default

                    case opcode is
                        when "010000" => -- LOADIMM (opcode 16)
                            if format = "01" then
                                reg_addr_a <= std_logic_vector(operand1);
                                reg_data_in <= imem(to_integer(pc + 1));
                                reg_we <= '1';
                                pc <= pc + 2;  -- Skip immediate word
                            end if;

                        when "000010" => -- MOVE (opcode 2)
                            reg_addr_a <= std_logic_vector(operand1);  -- Source
                            reg_addr_b <= std_logic_vector(operand2);  -- Dest
                            reg_data_in <= reg_data_a;
                            reg_we <= '1';
                            pc <= pc + 1;

                        when "001011" => -- ADD (opcode 11)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "000";  -- ADD
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            carry_flag <= alu_carry;
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "001100" => -- SUB (opcode 12)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "001";  -- SUB
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            carry_flag <= alu_carry;
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "100001" => -- AND (opcode 33)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "010";  -- AND
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "100010" => -- OR (opcode 34)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "011";  -- OR
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "100011" => -- NOT (opcode 35)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "100";  -- NOT
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "000011" => -- SHIFTL (opcode 3)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "101";  -- SHIFT LEFT
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            carry_flag <= alu_carry;
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "000100" => -- SHIFTR (opcode 4)
                            reg_addr_a <= std_logic_vector(operand1);
                            reg_addr_b <= std_logic_vector(operand2);
                            alu_op <= "110";  -- SHIFT RIGHT
                            reg_data_in <= alu_result;
                            reg_we <= '1';
                            carry_flag <= alu_carry;
                            zero_flag <= alu_zero;
                            pc <= pc + 1;

                        when "000101" => -- JUMPABS (opcode 5)
                            reg_addr_a <= std_logic_vector(operand1);
                            pc <= unsigned(reg_data_a);

                        when others =>
                            pc <= pc + 1;  -- Skip unknown instructions
                    end case;

                    state <= WRITEBACK;

                when WRITEBACK =>
                    state <= FETCH;

            end case;
        end if;
    end process;

    -- Debug outputs
    debug_pc <= std_logic_vector(pc);
    debug_state <= "000" &
                  "01" when state = FETCH else
                  "10" when state = DECODE else
                  "11" when state = EXECUTE else
                  "00";
    debug_reg1 <= reg_data_a;
    debug_reg2 <= reg_data_b;
    debug_flags <= overflow_flag & zero_flag & carry_flag;

end architecture;